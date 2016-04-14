//
//  CLReachability.h
//  VNASINetworkEngine
//
//  Created by ARSMac on 7/24/14.
//  Copyright (c) 2014 ars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef void(^blkCLReachAbilityOnchange) (NetworkStatus status);
@interface CLReachability : NSObject{
    
    blkCLReachAbilityOnchange _callback;
    

}

+(CLReachability*)sharedCLReachability ;

@property(nonatomic,assign) BOOL started;
@property(nonatomic,strong) NSString* CLReachabilityHost;
@property (nonatomic,strong) Reachability *hostReachability;
@property (nonatomic,strong) Reachability *internetReachability;
@property (nonatomic,strong) Reachability *wifiReachability;
@property(nonatomic,assign) NetworkStatus Status;
@property(nonatomic,assign) BOOL clConnectivityHost,clConnectivityInet ,clConnectivitywifi;

-(void)OnChange:(blkCLReachAbilityOnchange)Callback;
-(void)start;

@end
