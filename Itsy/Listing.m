//
//  Listing.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "Listing.h"

@implementation Listing
-(id)initWithParams:(NSDictionary *)json{
    self = [super init];
    if (self){
        self.listingDescription = json[@"description"];
        self.price = json[@"price"];
        self.title = json[@"title"];
        NSDictionary *mainImage = json[@"MainImage"];
        self.imgURL = mainImage[@"url_75x75"];
        self.favorers = [json[@"favorers"] unsignedIntegerValue];
    }
    return self;
}
-(NSString*)description {
    return [NSString stringWithFormat:@"%@:%@",[super description],self.title];
}
@end
