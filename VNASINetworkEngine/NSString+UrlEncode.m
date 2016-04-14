//
//  NSString+UrlEncode.m
//  StripClubs
//
//  Created by solutino technologies pvt ltd on 08/08/13.
//  Copyright (c) 2013 solutino technologies pvt ltd. All rights reserved.
//

#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)
- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
-(NSString*)WrapURLVarsFromDict:(NSDictionary*)pRequestVars
                          {
                              NSString *pApiUrl =self;
    NSMutableString * str=[[NSMutableString alloc]init];
    for (NSString *key in pRequestVars.allKeys) {
        NSString *value=[
                         [self IFSTRNULL: [pRequestVars valueForKey:key]
                             REPLACEWITH:@""]
                         urlencode
                         ] ;
        
        [str appendString: [NSString stringWithFormat:@"%@=%@&",key,value]];
        
    }
    NSString * newString;
    if ( [str length] > 0){
        newString         = [str substringToIndex:[str length] - 1];
    }
    
    return [NSString stringWithFormat:@"%@?%@",pApiUrl,newString];
    
}
-(NSString*)IFSTRNULL:(id)pValue REPLACEWITH:(NSString*)pReplace {
    
    bool isnull=(pValue==nil||[pValue isKindOfClass:[NSNull class]]);
    
    if(isnull){
        return pReplace;
        
    }
    else{
        
        return [NSString stringWithFormat:@"%@",pValue];
        
    }
    
    
    
}
@end
