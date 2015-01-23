//
//  APIManager.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "APIManager.h"
#import "Constants.h"
#import "Listing.h"

@implementation APIManager

+(APIManager*)sharedManager {
    static APIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
        
        //TODO Error responses come as plain text
        //instance.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        //instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", nil];
    });
    return instance;
}

-(AFHTTPRequestOperation*)getActiveListings:(NSString*)keywordString page:(NSUInteger)page callback:(void (^)(NSArray *listings, BOOL hitEnd, AFHTTPRequestOperation *operation, NSError* error))callback{
    
    NSDictionary *params = @{@"api_key":kAPIKey,
                             @"includes":@"MainImage",
                             @"keywords":keywordString,
                             @"page":@(page)};
    AFHTTPRequestOperation *operation = [self GET:@"listings/active/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // total count
        // unused - NSUInteger count = [responseObject[@"count"] unsignedIntegerValue];
        
        // pagination info
        NSDictionary *paginationResp = responseObject[@"pagination"];

        NSArray *results = responseObject[@"results"];
        NSMutableArray *listings = [NSMutableArray new];
        
        for (NSDictionary *listingJson in results){
            [listings addObject:[[Listing alloc] initWithParams:listingJson]];
        }
        BOOL hitLimit = NO; // no more listings to load
        if ([paginationResp[@"effective_offset"] unsignedIntegerValue] >= 50000){
            hitLimit = YES;
        }
        callback(listings, hitLimit, operation, nil);


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil, NO, operation, error);
    }];
    [operation resume];
    return operation;

}
@end
