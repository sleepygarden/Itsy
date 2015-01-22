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

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchResultsUpdating>
@property (weak, nonatomic) APIManager* sharedManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewYOffset;

@property (strong, nonatomic) NSMutableArray *listings;
@property (strong, nonatomic) NSMutableArray *filteredListings;

@property (nonatomic) BOOL isFetchingMoreListings;

@end

@implementation ViewController

#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedManager = [APIManager sharedManager];
    
    self.listings = [NSMutableArray new];
    self.filteredListings = [NSMutableArray new];
    
    self.isFetchingMoreListings = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self resizeTableViewUnderStatusBar];
    self.tableView.separatorColor = [UIColor clearColor]; // hide seps
    
    [self setupSearchController];
    
    [self fetchMoreListings];
    
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
    
}

#pragma mark -
-(void)addLoadingSpinner{
    self.isFetchingMoreListings = YES;
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.filteredListings.count inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
}

-(void)removeLoadingSpinner{
    self.isFetchingMoreListings = NO;
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.filteredListings.count inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}
-(void)resizeTableViewUnderStatusBar {
    self.tableViewYOffset.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view layoutIfNeeded];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self resizeTableViewUnderStatusBar];
}

-(void)fetchMoreListings {
    if (!self.isFetchingMoreListings){
        NSLog(@"fetching more");
        [self addLoadingSpinner];
        [self.sharedManager getActiveListings:@"collars" callback:^(NSArray *listings, AFHTTPRequestOperation *operation, NSError *error) {
            [self removeLoadingSpinner];
            if (error){
                NSLog(@"error getting listing: %@",error.localizedDescription);
            }
            else {
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
    return self.filteredListings.count + (self.isFetchingMoreListings ? 1:0);
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
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - [ListingCell cellHeight]*4) {
        if (!self.isFetchingMoreListings){
            [self fetchMoreListings];
        }
    }
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
