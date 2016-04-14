//
//  CLPostData.h
//  VinsiRemoteDataTransfer
//
//  Created by ARSMac on 7/18/14.
//  Copyright (c) 2014 ars. All rights reserved.
//
typedef enum Posttype{
    Posttype_asPostvariable,
    Posttype_asJson,
    Posttype_asData,
    
    
}Posttype;
#import <Foundation/Foundation.h>
@interface CLPostData : NSObject

{
    
    
    
}
-(CLPostData*)InitAsVariableTypeWithDictionary:(NSDictionary*)dct;
-(CLPostData*)InitAsJsonTypeWithDictionary:(NSDictionary*)dct andKey:(NSString*)key ;
-(CLPostData*)InitAsDataTypeWithData:(NSData*)dct andKey:(NSString*)key;
@property(nonatomic,assign) Posttype postType  ;
@property(nonatomic,strong) NSString *postkey ;
@property(nonatomic,strong) id postData;

@end
