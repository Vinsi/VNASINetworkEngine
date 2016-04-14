//
//  CLPostData.m
//  VinsiRemoteDataTransfer
//
//  Created by ARSMac on 7/18/14.
//  Copyright (c) 2014 ars. All rights reserved.
//

#import "CLPostData.h"

@implementation CLPostData
@synthesize postType, postkey, postData;
- (CLPostData *)InitAsDataTypeWithData:(NSData *)dct andKey:(NSString *)key {
	CLPostData *slf = [self init];
    
	slf.postData = dct;
	slf.postkey  = key;
	slf.postType = Posttype_asData;
    
    
    
	return slf;
}

- (CLPostData *)InitAsJsonTypeWithDictionary:(NSDictionary *)dct andKey:(NSString *)key {
	CLPostData *slf = [self init];
    
	slf.postData = dct;
	slf.postkey  = nil;
	slf.postType = Posttype_asJson;
    
    
    
	return slf;
}

- (CLPostData *)InitAsVariableTypeWithDictionary:(NSDictionary *)dct {
	CLPostData *slf = [self init];
    
	slf.postData = dct;
	slf.postkey  = nil;
	slf.postType = Posttype_asPostvariable;
    
    
    
	return slf;
}


@end