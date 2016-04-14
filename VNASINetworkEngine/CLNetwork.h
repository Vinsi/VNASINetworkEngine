//
//  CLNetwork.h
//  unielement
//
//  Created by Vinsi  on 04/12/12.
//  Copyright (c) 2012 Vinsi . All rights reserved.
//  Last commiteed on 1.3.2013
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GlobalTypes.h"
#import "CLPostData.h"
#import "MMStopwatchARC.h"
#define key_NTW_URL @"url"
#define key_NTW_CALLBACK @"callback"
#define key_NTW_POST     @"post"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "ASINetworkQueue.h"
#import "NSArray+FindIndex.h"
#import "CLReachability.h"
typedef void(^blkCallBack_IDWithNSError)(id Data,NSError*Error);
@protocol CLNetworkDataSource <NSObject>
@optional
-(NSString*)CLNetworkHostName;
@end

@interface ASIFormDataRequestWithCallbk:ASIFormDataRequest{

}
@property(nonatomic,assign) blkCallBack_IDWithNSError callback;

@end


@interface CLNetwork : NSObject
{


   
}
@property(nonatomic,assign) BOOL clNetworkISNetworkAvailable;
@property(nonatomic,assign) BOOL clNetworkISHostReachable;
@property(nonatomic,strong) NSMutableArray *arrayofDelegates;
@property(nonatomic,strong) id progressbar;
@property(nonatomic,assign) NSInteger clnetworkLogMode;
@property(nonatomic,strong) ASINetworkQueue *ASIntwrkQue;






+ (CLNetwork*)sharedNetwork ;
- (ASIHTTPRequest*)CLNetworkCreateARequestUrl:(NSString *)apiUrl
                                     WithData:(NSArray *)arrOfData;





@end

