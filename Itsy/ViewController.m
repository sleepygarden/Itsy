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
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchResultsUpdating>
@property (weak, nonatomic) APIManager* sharedManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewYOffset;

@property (strong, nonatomic) NSArray *listings;
@property (strong, nonatomic) NSMutableArray *filteredListings;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedManager = [APIManager sharedManager];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    
    self.tableViewYOffset.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view layoutIfNeeded];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width,
                                                       44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.separatorColor = [UIColor clearColor];
        
    [self.spinner startAnimating];
    self.spinner.hidesWhenStopped = YES;

    [self.sharedManager getActiveListings:@"cats,dogs" callback:^(NSArray *listings, AFHTTPRequestOperation *operation, NSError *error) {
        [self.spinner stopAnimating];
        if (error){
            NSLog(@"error getting listing: %@",error.localizedDescription);
        }
        else {
            self.listings = listings;
            self.filteredListings = [self.listings mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

//

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.tableViewYOffset.constant = [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view layoutIfNeeded];
}
//

#pragma mark - UITableView Delegate + Datasource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ListingCell";
    ListingCell *cell = (ListingCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSLog(@"uh oh");
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    
    [cell setupWithListing:self.listings[indexPath.row]];
    NSLog(@"cell height %fx%f",cell.listingImage.frame.size.width,cell.listingImage.frame.size.height);
    NSLog(@"img %@",NSStringFromCGSize(cell.listingImage.image.size));
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredListings.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ListingCell cellHeight];
}

// clips trailing empty cells
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
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
