//
//  NSDictionary+Json.m
//  VinsiRemoteDataTransfer
//
//  Created by ARSMac on 7/18/14.
//  Copyright (c) 2014 ars. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)
- (NSString *)ConvertToJsonString{
       id data =self;
   	if (!data) {
   		return nil;
   	}
   	else {
   		NSString *JSONString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
   		return JSONString;
   	}
   }
@end
