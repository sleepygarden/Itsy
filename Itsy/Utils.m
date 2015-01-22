//
//  Utils.m
//  Itsy
//
//  Created by Michael Cornell on 1/21/15.
//  Copyright (c) 2015 Michael Cornell. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>
@implementation Utils

// This covers all cases, but soooo slooowly
+(NSString*)cleanHTMLCodesSlowly:(NSString*)htmlString {
    NSData *stringData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *decodedString;
    NSError *error;
    decodedString = [[NSAttributedString alloc] initWithData:stringData options:options documentAttributes:NULL error:&error];
    if (error){
        NSLog(@"HTML cleaning failed, %@",error.localizedDescription);
        return nil;
    }
    
    return [decodedString string];

}

// this is actually much faster than iterative checking
+(NSString*)cleanHTMLCodes:(NSString*)htmlString {
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#35;" withString:@"#"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#36;" withString:@"$"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#37;" withString:@"%"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#38;" withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#40;" withString:@"("];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#41;" withString:@")"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#42;" withString:@"*"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#43;" withString:@"+"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#44;" withString:@","];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#46;" withString:@"."];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#47;" withString:@"/"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#58;" withString:@":"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#59;" withString:@";"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#60;" withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#61;" withString:@"="];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#62;" withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#63;" withString:@"?"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#64;" withString:@"@"];

    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\u00A0"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&iexcl;" withString:@"¡"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&cent;" withString:@"¢"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&curren;" withString:@"¤"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&yen;" withString:@"¥"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&brvbar;" withString:@"¦"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&sect;" withString:@"§"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&uml;" withString:@"¨"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&ordf;" withString:@"ª"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&not;" withString:@"¬"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&shy;" withString:@"\u00AD"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&macr;" withString:@"¯"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&plusmn;" withString:@"±"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&sup2;" withString:@"²"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&sup3;" withString:@"³"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&acute;" withString:@"´"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&micro;" withString:@"µ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&para;" withString:@"¶"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&cedil;" withString:@"¸"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&sup1;" withString:@"¹"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&ordm;" withString:@"º"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&frac14;" withString:@"¼"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&frac12;" withString:@"½"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&frac34;" withString:@"¾"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&iquest;" withString:@"¿"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&times;" withString:@"×"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&divide;" withString:@"÷"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&ETH;" withString:@"Ð"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&eth;" withString:@"ð"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&THORN;" withString:@"Þ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&thorn;" withString:@"þ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&AElig;" withString:@"Æ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&aelig;" withString:@"æ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&OElig;" withString:@"Œ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&oelig;" withString:@"œ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&Aring;" withString:@"Å"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&Oslash;" withString:@"Ø"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&Ccedil;" withString:@"Ç"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&ccedil;" withString:@"ç"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&szlig;" withString:@"ß"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&Ntilde;" withString:@"Ñ"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&ntilde;" withString:@"ñ"];
    
    return htmlString;
    
}

+(void)testHTMLCleaner {
    NSString *cleanMe = @"&quot; &lt; &gt; &nbsp; &iexcl; &cent; &pound; &curren; &yen; &brvbar; &sect; &uml; &copy; &ordf; &laquo; &not; &shy; &reg; &macr; &deg; &plusmn; &sup2; &sup3; &acute; &micro; &para; &middot; &cedil; &sup1; &ordm; &raquo; &frac14; &frac12; &frac34; &iquest; &times; &divide; &ETH; &eth; &THORN; &thorn; &AElig; &aelig; &OElig; &oelig; &Aring; &Oslash; &Ccedil; &ccedil; &szlig; &Ntilde; &ntilde;";
    cleanMe = [self cleanHTMLCodes:cleanMe];
    NSAssert([cleanMe isEqualToString:@"\" < > \u00A0 ¡ ¢ £ ¤ ¥ ¦ § ¨ © ª « ¬ \u00AD ® ¯ ° ± ² ³ ´ µ ¶ · ¸ ¹ º » ¼ ½ ¾ ¿ × ÷ Ð ð Þ þ Æ æ Œ œ Å Ø Ç ç ß Ñ ñ"],
             @"html code cleaner failed. \n",cleanMe);
    
    cleanMe = @"&amp; &#38;";
    cleanMe = [self cleanHTMLCodes:cleanMe];
    NSAssert([cleanMe isEqualToString:@"& &"],
             @"html code cleaner failed. \n",cleanMe);
}

@end
