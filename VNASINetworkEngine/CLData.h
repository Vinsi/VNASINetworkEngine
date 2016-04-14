//

//
//  Created by Vinsi  on 04/12/12.
//  Copyright (c) 2012 Vinsi . All rights reserved.
//   Last commiteed on 1.3.2013
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLPostData.h"
#define VNTWRK [CLData new]
#define PRINTLOGMODE 0

#define kdev_OS_IOS [NSNumber numberWithInt:1]
static NSString *key_APPBundleVersion =@"bundleversion";
static NSString *key_APPdev_os  =@"dev_os";

#import "CLNetwork.h"
typedef enum CLDataError {
   
CLDataError_NoError=0,
CLDataError_Parser=1,
CLDataError_NetworkEngine=2,
CLDataError_Reachability=3,
CLDataError_Other=4
}CLDataError;

typedef void(^blkCallbackCLData)(id Data,CLDataError Errorno);
typedef void(^blkonProgress)(int progress);


@interface CLData : NSObject 
{


   
}
@property(nonatomic,assign) BOOL EnableCache;
@property(nonatomic,strong) UIProgressView *progress;
@property(nonatomic,readonly,strong) CLNetwork * clnetwork;
@property(nonatomic,assign) NSJSONReadingOptions cldatajsonreadoption;
-(ASIHTTPRequest*)CLDataURL :(NSString *)api
           WithDataOfTypeCLPOST:(id)arrData
   UpdateProgress:(UIProgressView *)progress
                     OnComplete:(blkCallbackCLData)callback;

- (ASIHTTPRequest*)       CLDataURL:(NSString *)api
    WithDataOfTypeCLPOST:(id)Data
              OnProgressBlk:(blkonProgress)callback_progress
              OnComplete:(blkCallbackCLData)callback ;

/*
 if using array of CLPOSTdata it automatically post the data
 if using dictionary then                      get works
 
 */
- (ASIHTTPRequest*)       CLDataURL:(NSString *)api
               WithDataOfTypeCLPOST:(id)Data
                         OnComplete:(blkCallbackCLData)callback ;
- (id)CLDataParseData:(NSString *)sData withError:(NSError **)error ;
-(ASIHTTPRequest*)CLDataWhenRequestCreated:(ASIHTTPRequest*)Request;

- (void)uploadFailed:(ASIHTTPRequest *)theRequest ;
- (void)uploadFinished:(ASIHTTPRequest *)theRequest ;
-(void)CLDataFindAndRemoveDelegates;
- (NSDictionary *)CLDataAddAdditionalInfo ;
@end
