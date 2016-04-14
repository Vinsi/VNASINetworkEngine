//
//  VinsiRemoteDataTransfer.h
//  VinsiRemoteDataTransfer
//
//  Created by ARSMac on 6/20/14.
//  Copyright (c) 2014 ars. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KSuccess(Data,Errorno) ([[Data objectForKey:key_ERROR]integerValue]==0 && Errorno ==0)
#define KErrorNo(Data,Errorno) (Errorno==0?[[Data objectForKey:key_ERROR]integerValue]:Errorno)
#define KStatusMessage(Data,Errorno) (Errorno!=0?@"Network Error":[Data objectForKey:key_STATUSMSG])

#import "CLData.h"
#import "CLPostData.h"
#import "GlobalTypes.h"
#import "CLReachability.h"



