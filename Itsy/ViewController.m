//
//  ViewController.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "ViewController.h"
#include "APIManager.h"

@interface ViewController ()
@property (weak, nonatomic) APIManager* sharedManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedManager = [APIManager sharedManager];
    
    [self.sharedManager searchWithKeywordString:@"cats,dogs" callback:^(id json, AFHTTPRequestOperation *operation, NSError *error) {
        if (error){
            NSLog(@"error getting listing!");
            NSLog(@"%@",error.localizedDescription);
            NSLog(@"%@",operation.request.URL);
        }
        else {
            NSLog(@"%@ \n%@",[json class],json);
        }
    }];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
