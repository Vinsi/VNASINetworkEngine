    //
//  CLJson.m
//  unielement
//
//  Created by Vinsi  on 04/12/12.
//  Copyright (c) 2012 Vinsi . All rights reserved.
//
//#import "CLConfig.h"
#import "CLData.h"
#import "NSDictionary+Json.h"
#import "NSString+UrlEncode.h"
#import "NSMutableArray+Findindex.h"
#import "CLNetwork.h"

@interface CLData () {
	blkCallBack_IDWithNSError _callbackOncomplete;
    blkonProgress _callbackOnProgress;
}
@property(nonatomic,copy) id DataPosted;
@end
@implementation CLData
@synthesize clnetwork = _clnetwork;


- (CLNetwork *)clnetwork {
	if (_clnetwork != nil) {
		return _clnetwork;
	}
	return _clnetwork = [CLNetwork sharedNetwork];
}

- (NSDictionary *)CLDataAddAdditionalInfo {
    
NSString *sysversion   =[NSString stringWithFormat:@"iOS-%@", [[UIDevice currentDevice] systemVersion] ];
	return @{ key_APPBundleVersion:
			  [NSNumber numberWithFloat:BUNDLE_VER],
			  key_APPdev_os:sysversion };
}

-(UIProgressView *)progress{
    if(_progress)return _progress;
return     _progress =[[UIProgressView alloc] init];

}
- (ASIHTTPRequest*)       CLDataURL:(NSString *)api
    WithDataOfTypeCLPOST:(id)Data
              OnProgressBlk:(blkonProgress)callback_progress
              OnComplete:(blkCallbackCLData)callback {
    
    _callbackOnProgress =callback_progress;
    [   self.progress addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    
     __weak typeof (self) wkself =self;
   return  [self CLDataURL:api WithDataOfTypeCLPOST:Data UpdateProgress:self.progress OnComplete:^(id Data, CLDataError Errorno) {
        [wkself.progress removeObserver:self forKeyPath:@"progress"];
        BLOCK_SAFE_RUN(callback,Data,Errorno);
    }];
    


}

- (ASIHTTPRequest*)       CLDataURL:(NSString *)api
               WithDataOfTypeCLPOST:(id)Data
                         OnComplete:(blkCallbackCLData)callback {
    
    _callbackOnProgress =nil;
  
    

    return  [self CLDataURL:api WithDataOfTypeCLPOST:Data UpdateProgress:nil OnComplete:^(id Data, CLDataError Errorno) {
     
        BLOCK_SAFE_RUN(callback,Data,Errorno);
    }];
    
    
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(object ==self.progress){
    
    if(_callbackOnProgress)
        _callbackOnProgress(self.progress.progress);
    }




}
- (ASIHTTPRequest*)       CLDataURL:(NSString *)api
    WithDataOfTypeCLPOST:(id)Data
          UpdateProgress:(UIProgressView *)progress
              OnComplete:(blkCallbackCLData)callback {
    
    if([CLReachability sharedCLReachability].Status ==NotReachable && [CLReachability sharedCLReachability].started ==YES){
        BLOCK_SAFE_RUN(callback,nil,CLDataError_Reachability);
        NSLog(@"CLData:Internet Not available");
        return nil;
    }
    

	id PostData;
   
	if ([Data isKindOfClass:[NSArray class]]) { //postmethods
        
        
        
    
	   NSMutableArray *arrPostData =[((NSArray *)Data)mutableCopy];
        
        
		[arrPostData addObject:[[CLPostData new]InitAsVariableTypeWithDictionary:[self CLDataAddAdditionalInfo]
		 ]];
        PostData =arrPostData;
        self.DataPosted =PostData;
	}
	else if ([Data isKindOfClass:[NSDictionary class]]) { //get method
		NSMutableDictionary *dctdata = [((NSDictionary *)Data)mutableCopy];
		[dctdata setValuesForKeysWithDictionary:[self CLDataAddAdditionalInfo]];
		PostData = nil;
		api =   [self WrapURLVarsFromDict:api
                                 WithData:dctdata];
             self.DataPosted =dctdata;
	}
    else if(Data ==nil) { //if nil
        
        
        PostData =@[[[CLPostData new]InitAsVariableTypeWithDictionary:[self CLDataAddAdditionalInfo]]];
        self.DataPosted=PostData;
    
    }




	if (progress != nil)
		self.clnetwork.progressbar = progress;



	/*----------Read before you code-------
	   //  code Used for Image/file Uploading
	   NSMutableArray *arrPost =[[NSMutableArray alloc]init];
	   CLPostData *post =[[CLPostData alloc] init];
	   post.postData    =  [NSData dataWithData:UIImageJPEGRepresentation([CLConfig scaleAndRotateImage:self.image], 1)];
	   post.postkey     =  @"imageKey";
	   post.postType    = Posttype_asData;
	   [arrPost addObject:post];
	   //code for json upload
	   post =[[CLPostData alloc] init];
	   post.postData    = nsdictionary;
	   post.postKey     =@"jsonkey";
	   post.posttype    =Posttype_asJSON;
	   [arrPost addObject:post];

	   //code for httpPost
	   post =[[CLPostData alloc] init];
	   post.postData    = nsdictionary;
	   post.postKey     =nil;
	   post.posttype    =Posttype_asPostvariable;

	   // function uploads all the data..
	   [self CLJSONPostData:api WithDataOfTypeCLPOST:arrPost :nil OnComplete:^(id data, int errcode) {

	   }];
	 */
  
    __block NSString * strparse;
    __block NSString *apiwithrand=[NSString  stringWithFormat: @"%@_%d",api,rand()*100 ];
	[MMStopwatchARC start:apiwithrand];


	__weak typeof(self) wkself = self;

	_callbackOncomplete = ^(ASIHTTPRequest *Request, NSError *Error) {
        id Objects=nil;
        int Errorno =0;
        NSException *exceptioncaught;
        NSString *ResponseString;
		@try {
            
			

			if (Error != nil) {
                NSException* myException = [NSException
                                            exceptionWithName:@"Request Error"
                                            reason:@"Some error on CLnetwork Request "
                                            userInfo:@{@"errno":[NSNumber numberWithInt:CLDataError_NetworkEngine]}];
                @throw myException;
				
				
			}

			
            ResponseString = [Request responseString];
			NSError *error;
             [MMStopwatchARC start:[NSString stringWithFormat:@"parse:%@",apiwithrand]];
			Objects= [wkself CLDataParseData:ResponseString withError:&error];
              strparse =[MMStopwatchARC stopNoPrint:[NSString stringWithFormat:@"parse:%@",apiwithrand]];
            
			if (error != nil) {
			
			 // for json parse errors
				NSException* myException = [NSException
                                            exceptionWithName:@"Parse Error"
                                            reason:@"Some error on Parse Data "
                                            userInfo:@{@"errno":[NSNumber numberWithInt:CLDataError_Parser]}];
                @throw myException;
			}
		}
		@catch (NSException *exception)
		{
            Errorno = [[exception.userInfo objectForKey:@"errno"] intValue];
            Objects =nil;
        exceptioncaught =exception;
           
		}
		@finally
		{
           
            if([CLNetwork sharedNetwork].clnetworkLogMode ){
               NSMutableArray* arrData=[[NSMutableArray alloc] init];
                id senddata=nil;
                if([wkself.DataPosted isKindOfClass:[CLPostData class]]){
                    
                    if(((CLPostData*)wkself.DataPosted).postType==Posttype_asJson){
                        NSLog(@"\n---------JSON POST INITIATED-----------");
                        NSData *jdata= [NSJSONSerialization dataWithJSONObject:arrData
                                                                       options: 0
                                                                         error:nil];
                        NSString *JSONString = [[NSString alloc] initWithBytes:[jdata bytes] length:[jdata length] encoding:NSUTF8StringEncoding];
                        senddata=JSONString;
                    }
                    else{
                
                    [arrData addObject: ((CLPostData*)wkself.DataPosted).postData];
                    senddata =arrData;
                    }
                }
                else if([wkself.DataPosted isKindOfClass:[NSArray class]]){
                    
                    for (CLPostData *Pdata in wkself.DataPosted ){
                    [arrData addObject:Pdata.postData];
                    }
                    senddata =arrData;
                    
                   if(((CLPostData*)wkself.DataPosted[0]).postType==Posttype_asJson){
                        NSLog(@"\n---------JSON POST INITIATED-----------");
                        NSData *jdata= [NSJSONSerialization dataWithJSONObject:arrData
                                                                       options: 0
                                                                         error:nil];
                        NSString *JSONString = [[NSString alloc] initWithBytes:[jdata bytes] length:[jdata length] encoding:NSUTF8StringEncoding];
                        senddata=JSONString;
                    }
                       else{
                           
                      
                           senddata =arrData;
                       }

                }
                
                else {
                
                    arrData =wkself.DataPosted;
                    senddata =arrData;
                }
               
                
            NSLog(@"\n---------START LOG-----------"
                  "\n------------------------------"
			      "\nAPI       :{%@}"
			      "\n-------------------------------"
                  "\nDATA POSTED:%@"
                  "\n-------------------------------"
			      "\nRawData   :%@"
			      "\n-------------------------------"
                  "\nStatus    :%@ CODE:%@"
                  "\n-------------------------------"
                  "\nTIME TAKEN:                    "
                  "\nLoad=%@ sec                    "
                  "\nParse=%@ sec                   "
                  "\n===============================",
                  api,senddata,
                  ResponseString,@[@"Success",@"Failed"][Errorno!=0],
                  (Errorno!=0)?[exceptioncaught reason]:@"",
                   [MMStopwatchARC stopNoPrint:apiwithrand],strparse);
          
            }

            BLOCK_SAFE_RUN(callback, Objects, Errorno); //callback

            
            [wkself CLDataFindAndRemoveDelegates];
            
		}
	};
	ASIHTTPRequest *newapirequest =   [self.clnetwork CLNetworkCreateARequestUrl:api WithData:PostData];
 
    [[CLNetwork sharedNetwork].arrayofDelegates addObject:self];
    
    if(self.EnableCache){
    [newapirequest setDownloadCache:[ASIDownloadCache sharedCache]];
    }
    else {
       [newapirequest setDownloadCache:nil];
    }
    [newapirequest setUploadProgressDelegate:self.clnetwork.progressbar];
	[newapirequest setDelegate:[[CLNetwork sharedNetwork].arrayofDelegates
                                lastObject]];
	[newapirequest setDidFailSelector:@selector(uploadFailed:)];
	[newapirequest setDidFinishSelector:@selector(uploadFinished:)];
	[newapirequest setTimeOutSeconds:20];
     newapirequest=[self CLDataWhenRequestCreated:newapirequest];
    

	[self.clnetwork.ASIntwrkQue addOperation:newapirequest];
	if ([self.clnetwork.ASIntwrkQue isSuspended]) {
		[self.clnetwork.ASIntwrkQue go];
	}
    return newapirequest;
}
-(void)CLDataFindAndRemoveDelegates{

    for (int i=0 ;i< [[CLNetwork sharedNetwork].arrayofDelegates count];++i) {
        if([CLNetwork sharedNetwork].arrayofDelegates[i] ==self){
            
            [[CLNetwork sharedNetwork].arrayofDelegates removeObjectAtIndex:i];
            break ;
        }
    }
}
- (void)uploadFinished:(ASIHTTPRequest *)theRequest {
    NSLog(@"uploadFinished");
	BLOCK_SAFE_RUN(_callbackOncomplete, theRequest, nil);
    
//    [self.delegate CLNetworkWhenOnApiTaskFinished];
}

- (void)uploadFailed:(ASIHTTPRequest *)theRequest {
        NSLog(@"uploadFailed");
	BLOCK_SAFE_RUN(_callbackOncomplete, theRequest, [NSError errorWithDomain:@"clnetwork" code:1 userInfo:nil]);
   
	//    [self.delegate CLNetworkWhenOnApiTaskFinished];
}
-(ASIHTTPRequest*)CLDataWhenRequestCreated:(ASIHTTPRequest*)Request{

    return Request;
}
- (id)CLDataParseData:(NSString *)sData withError:(NSError **)error {
	id obj;



	NSData *jsonData = [sData dataUsingEncoding:NSUTF8StringEncoding];




	obj = [NSJSONSerialization
	       JSONObjectWithData:jsonData
	                  options:self.cldatajsonreadoption
	                    error:error];




	return obj;
}

- (NSString *)urlencodeWithurl:(NSString*)url{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[url UTF8String];
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
+(NSString*)IFSTRNULL:(id)pValue REPLACEWITH:(NSString*)pReplace {
    
    bool isnull=(pValue==nil||[pValue isKindOfClass:[NSNull class]]);
    
    if(isnull){
        return pReplace;
        
    }
    else{
        
        return [NSString stringWithFormat:@"%@",pValue];
        
    }
    
    
    
}
-(NSString*)WrapURLVarsFromDict:(NSString*)url WithData:(NSDictionary*)pRequestVars
{
    NSString *pApiUrl =url;
    NSMutableString * str=[[NSMutableString alloc]init];
    for (NSString *key in pRequestVars.allKeys) {
        NSString *value=[
                         [CLData IFSTRNULL: [pRequestVars valueForKey:key]
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
