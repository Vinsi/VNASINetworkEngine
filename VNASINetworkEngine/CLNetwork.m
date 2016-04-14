//
//  CLNetwork.m
//  unielement
//
//  Created by Vinsi  on 04/12/12.
//  Copyright (c) 2012 Vinsi . All rights reserved.
//  Last commiteed on 1.3.2013

#import "CLNetwork.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "NSDictionary+Json.h"
#import "Reachability.h"
#import "NSMutableArray+Findindex.h"

@interface CLNetwork()

{
    blkCallBack_IDWithNSError _callbackqueuecomplete;
}
@property(nonatomic,strong) CLReachability *clreach;
@property(strong, nonatomic) ASIFormDataRequestWithCallbk *ASIrequest;
@property(nonatomic,strong) NSDictionary * dictionary;
@property(nonatomic,strong) NSString	   * apiUrl;
@property(nonatomic,strong) NSMutableData * data_fetched;
@property(nonatomic,strong) NSError *errorNetwrk;

@end
@implementation CLNetwork

-(NSMutableArray *)arrayofDelegates{

    if(_arrayofDelegates!=nil)return _arrayofDelegates;
return     _arrayofDelegates =[[NSMutableArray alloc]init];

}
-(CLReachability *)clreach{
    if(_clreach)return _clreach;
return     _clreach =[[CLReachability alloc]init];


}
+ (CLNetwork*)sharedNetwork {
    static CLNetwork* sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
      
     
        sharedMyManager.clnetworkLogMode =1;
        
        
        
    });
    return sharedMyManager;
}


-(void)CLNetwork_StartConnection{
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}
-(void)CLNetwork_EndConnection{
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)setApiUrl:(NSString *)apiUrl{


	_apiUrl = [apiUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(ASINetworkQueue *)ASIntwrkQue{
    if(_ASIntwrkQue!=nil)return _ASIntwrkQue;
    _ASIntwrkQue =[[ASINetworkQueue alloc]init];
    
   
    
    return _ASIntwrkQue;
}

-(id)init{
    if(self=[super init]){
//        [self.ASIntwrkQue setUploadProgressDelegate:self.progressbar];
        [self.ASIntwrkQue setDelegate:self];
        [self.ASIntwrkQue setRequestDidStartSelector:@selector(queueStart:)];
        [self.ASIntwrkQue setRequestDidFinishSelector:@selector(queueComplete:)];
        
    
    }
    return self;


}
- (ASIHTTPRequest*)CLNetworkCreateARequestUrl:(NSString *)apiUrl
                                   WithData:(NSArray *)arrOfData{
	
    
    
  


	
	
    self.apiUrl=apiUrl;
	
    

	ASIFormDataRequest *ASIrqst;
    
    if(arrOfData==nil){
    
    
        return [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.apiUrl]];
    }
    else {
    ASIrqst =[ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.apiUrl]];
    
    }
	

    for (int i=0; i<[arrOfData count]; ++i) {
        
        CLPostData *postdata = arrOfData[i];
       
   
//	for (CLPostData *postdata in arrOfData) {
		switch (postdata.postType) {
			case Posttype_asData:
			{
				NSData *data = postdata.postData; //[[[NSMutableData alloc] initWithLength:256*1024] autorelease];
				NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"_%d_IPHONE_IMAGE.jpg",i]];
				[data writeToFile:path atomically:NO];
                
				[ASIrqst setFile:path forKey:postdata.postkey];
				break;
			}

			case Posttype_asJson:
			{
                
         
                
                NSURL *url = [NSURL URLWithString:self.apiUrl];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                NSDictionary *dctTmp = postdata.postData;
                id data =dctTmp;
                NSError *error;
               NSData *jdata= [NSJSONSerialization dataWithJSONObject:data
                                                options: 0
                                                  error:&error];
                	//NSString *JSONString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
                [request addRequestHeader:@"Content-Type" value:@"application/json"];
                [request appendPostData: jdata];
                return request;
				

				break;
			}

			case Posttype_asPostvariable:
			{
				if ([postdata.postData isKindOfClass:[NSDictionary class]]) {
					for (NSString *skey in((NSDictionary *)postdata.postData).allKeys) {
						[ASIrqst setPostValue:[((NSDictionary *)postdata.postData)objectForKey : skey]  forKey:skey];
					}
				}
				break;
			}

			default:
				break;
		}
   }
     
    return ASIrqst;
}

- (void)queueStart:(ASINetworkQueue *)queue{
    
    [self CLNetwork_StartConnection];
    
    
    
}

- (void)queueComplete:(ASINetworkQueue *)queue{

[self CLNetwork_EndConnection];
   
    

}








@end
