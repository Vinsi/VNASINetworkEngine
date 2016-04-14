//
//  NSString+UrlEncode.h
//  StripClubs
//
//  Created by solutino technologies pvt ltd on 08/08/13.
//  Copyright (c) 2013 solutino technologies pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlEncode)
- (NSString *)urlencode ;
-(NSString*)WrapURLVarsFromDict:(NSDictionary*)pRequestVars;
@end
