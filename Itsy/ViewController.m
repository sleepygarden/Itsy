//
//  ViewController.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "ViewController.h"
#import "APIManager.h"
#import "ListingCell.h"
#import "Listing.h"
#import "LoadingCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ItsyStyles.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchResultsUpdating>
@property (weak, nonatomic) APIManager* sharedManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarYOffset;
@property (nonatomic, strong) UISearchController *searchController;

@property (strong, nonatomic) NSMutableArray *listings;
@property (strong, nonatomic) NSMutableArray *filteredListings;
@property (strong, nonatomic) NSString *lastSearchedPhrase;
@property (weak, nonatomic) AFHTTPRequestOperation *fetchOperation;

@property (nonatomic) BOOL isFetchingMoreListings;
@property (nonatomic) BOOL isAnimatingLoadingSpinner;
@property (nonatomic) BOOL hitListingsEnd;
@property (nonatomic) NSUInteger paginationIndex;

@end

@implementation ViewController

#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedManager = [APIManager sharedManager];
    
    self.paginationIndex = 1;
    
    self.listings = [NSMutableArray new];
    self.filteredListings = [NSMutableArray new];
    
    self.isFetchingMoreListings = NO;
    self.isAnimatingLoadingSpinner = NO;
    self.hitListingsEnd = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self resizeTableViewUnderStatusBar];
    self.tableView.separatorColor = [UIColor clearColor]; // hide seps
    self.tableView.backgroundColor = itsyCyan;
    
    self.searchBar.delegate = self;
    
    // adds another search bar, which will search from the current listings by title
    // i originally put this in because i misunderstood the assignment, and want to leave in the functionality but change the UI
    // [self setupSearchController];
    
}

-(void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width,
                                                       44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.placeholder = @"Refine Search";
    
}

#pragma mark -
-(void)addLoadingSpinner{
    if (!self.isAnimatingLoadingSpinner){
    self.isAnimatingLoadingSpinner = YES;
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.filteredListings.count inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    }
    
}

-(void)removeLoadingSpinner{
    if (self.isAnimatingLoadingSpinner){
    self.isAnimatingLoadingSpinner = NO;
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.filteredListings.count inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    }

}
-(void)resizeTableViewUnderStatusBar {
    self.searchBarYOffset.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view layoutIfNeeded];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self resizeTableViewUnderStatusBar];
}

-(void)fetchMoreListingsWithKeywordString:(NSString*)searchPhrase {
    if (!self.isFetchingMoreListings){
        self.isFetchingMoreListings = YES;
        [self addLoadingSpinner];
        
        self.fetchOperation = [self.sharedManager getActiveListings:searchPhrase page:self.paginationIndex callback:^(NSArray *listings, BOOL hitEnd, AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"search phrase %@, fetch phrase %@, op %lu, fetch op %lu",searchPhrase,self.lastSearchedPhrase,operation.hash,self.fetchOperation.hash);
 
            [self removeLoadingSpinner];
            self.hitListingsEnd = hitEnd;
            
            if (error){
                NSLog(@"error getting listing: %@",error.localizedDescription);
            }
            else {
                self.paginationIndex++;
                NSMutableArray *indexPaths = [NSMutableArray new];
                for (Listing *newListing in listings){
                    [self.listings addObject:newListing];
                    [indexPaths addObject:[NSIndexPath indexPathForRow:self.listings.count-1 inSection:0]];
                }
                self.filteredListings = [self.listings mutableCopy];
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
            }
            self.isFetchingMoreListings = NO;
        }];
    }
}

#pragma mark - UITableView Delegate + Datasource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.filteredListings.count){ // loading cell
        static NSString *loadingCellIdentifier = @"LoadingCell";
        LoadingCell *cell = (LoadingCell*)[self.tableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:loadingCellIdentifier bundle:nil] forCellReuseIdentifier:loadingCellIdentifier];
            cell = [self.tableView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
        }
        [cell.spinner startAnimating];
        return cell;
    }
    else { // listing cell
        static NSString *listingCellIdentifier = @"ListingCell";
        ListingCell *cell = (ListingCell*)[self.tableView dequeueReusableCellWithIdentifier:listingCellIdentifier];
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:listingCellIdentifier bundle:nil] forCellReuseIdentifier:listingCellIdentifier];
            cell = [self.tableView dequeueReusableCellWithIdentifier:listingCellIdentifier];
        }
        [cell setupWithListing:self.filteredListings[indexPath.row]];
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredListings.count + (self.isAnimatingLoadingSpinner ? 1:0);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.filteredListings.count){ // loading cell
        return [LoadingCell cellHeight];
    }
    else {
        
        return [ListingCell cellHeight];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // request once last item starts to ~appear in feed
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - 800) {
        // dont load more if search from existing
        [self fetchMoreListingsWithKeywordString:self.lastSearchedPhrase];
        if (!self.isFetchingMoreListings &&
            !self.hitListingsEnd &&
            self.listings.count == self.filteredListings.count){
            [self fetchMoreListingsWithKeywordString:self.lastSearchedPhrase];
        }
    }
}

-(void)fetchMoreListings {
    
}

#pragma mark - UISearchBar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (![self.lastSearchedPhrase isEqualToString:self.searchBar.text] && self.searchBar.text.length > 0){ // submit a new search, clear the old junk
        
        if (self.fetchOperation){
            [self.fetchOperation pause];
            [self.fetchOperation cancel];
            self.isFetchingMoreListings = NO;
        }
        self.paginationIndex = 1;
        [self.listings removeAllObjects];
        [self.filteredListings removeAllObjects];
        [self.tableView reloadData];
        self.lastSearchedPhrase = self.searchBar.text;
        [self fetchMoreListingsWithKeywordString:self.searchBar.text];
    }
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchController


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = self.searchController.searchBar.text;
    if (searchText.length == 0){
        self.filteredListings = [self.listings mutableCopy];
    }
    else {
        self.filteredListings = [NSMutableArray new];
        
        // ignore accents, etc
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        
        for (Listing *listing in self.listings) {
            NSRange titleRange = NSMakeRange(0, listing.title.length);
            NSRange foundRange = [listing.title rangeOfString:searchText options:searchOptions range:titleRange];
            if (foundRange.length > 0) {
                [self.filteredListings addObject:listing];
            }
        }
        [self.tableView reloadData];
    }
}


@end
