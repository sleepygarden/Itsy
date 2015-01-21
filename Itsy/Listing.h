//
//  Listing.h
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Listing : NSObject

//TODO MainImage obj

@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) NSUInteger favorers;
@property (strong, nonatomic) NSString *listingDescription;
@property (strong, nonatomic) NSURL *imgURL;

-(id)initWithParams:(NSDictionary*)json;
@end
