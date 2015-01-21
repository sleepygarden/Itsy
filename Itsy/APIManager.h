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
-(AFHTTPRequestOperation*)searchWithKeywordString:(NSString*)keywordString callback:(void (^)(id json, AFHTTPRequestOperation *operation, NSError* error))callback;

@end
