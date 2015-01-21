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
    });
    return instance;
}

-(id)init {
    if (self = [super init]) {

    }
    return self;
}

-(AFHTTPRequestOperation*)searchWithKeywordString:(NSString*)keywordString callback:(void (^)(id json, AFHTTPRequestOperation *operation, NSError* error))callback{

    // the language used for API parameter keys would get put into consts or a plist to standardize api growth
    NSDictionary *params = @{@"api_key":kAPIKey,
                             @"includes":@"MainImage",
                             @"keywords":keywordString};
    AFHTTPRequestOperation *operation = [self GET:@"listings/active/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSUInteger count = [responseObject[@"count"] unsignedIntegerValue];
        NSDictionary *paginationResp = responseObject[@"pagination"];
        NSArray *results = responseObject[@"results"];
        NSMutableArray *listings = [NSMutableArray new];
        
        for (NSDictionary *listingJson in results){
            [listings addObject:[[Listing alloc] initWithParams:listingJson]];
        }
        NSLog(@"listings:\n%@",listings);
        callback(responseObject, operation, nil);


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil, operation, error);
    }];
    [operation resume];
    return operation;

}
@end
