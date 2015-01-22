//
//  APIManager.h
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface APIManager : AFHTTPRequestOperationManager

+(APIManager*)sharedManager;

// in a fleshed out app, the method would take a dict of params as input, as opposed to just a keyword string
-(AFHTTPRequestOperation*)getActiveListings:(NSString*)keywordString page:(NSUInteger)page callback:(void (^)(NSArray *listings, BOOL hitLimit, AFHTTPRequestOperation *operation, NSError* error))callback;

@end
