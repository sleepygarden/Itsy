//
//  ViewController.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "ViewController.h"
#import "APIManager.h"
#import "Listing.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) APIManager* sharedManager;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarOffset;

@property (strong, nonatomic) NSArray *listings;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedManager = [APIManager sharedManager];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    
    self.searchBarOffset.constant = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view layoutIfNeeded];
    
    [self.sharedManager getActiveListings:@"cats,dogs" callback:^(NSArray *listings, AFHTTPRequestOperation *operation, NSError *error) {
        if (error){
            NSLog(@"error getting listing: %@",error.localizedDescription);
        }
        else {
            self.listings = listings;
            [self.tableView reloadData];
        }
    }];    
}

//

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.searchBarOffset.constant = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    [self.view layoutIfNeeded];
}
//

#pragma mark - UITableView Delegate + Datasource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Listing *listing = self.listings[indexPath.row];
    cell.textLabel.text = listing.title;
    [cell.imageView setImageWithURL:listing.imgURL placeholderImage:[UIImage imageNamed:@"ScreenShot"]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listings.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
