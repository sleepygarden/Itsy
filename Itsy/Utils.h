//
//  Utils.h
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+(NSString*)cleanHTMLCodes:(NSString*)htmlString;
+(void)testHTMLCleaner;
@end
