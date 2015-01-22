//
//  Listing.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "Listing.h"
#import "Utils.h"
@implementation Listing
-(id)initWithParams:(NSDictionary *)json{
    self = [super init];
    if (self){
        self.listingDescription = [Utils cleanHTMLCodes:json[@"description"]];
        self.price = json[@"price"];
        self.title = [Utils cleanHTMLCodes:json[@"title"]];
        NSDictionary *mainImage = json[@"MainImage"];        
        self.imgURL = [NSURL URLWithString:mainImage[@"url_570xN"]];
        //url_75x75
        //url_170x135
        //url_570xN
        //url_fullxfull

        self.favorers = [json[@"favorers"] unsignedIntegerValue];
    }
    return self;
}
-(NSString*)description {
    return [NSString stringWithFormat:@"%@:%@",[super description],self.title];
}
@end
