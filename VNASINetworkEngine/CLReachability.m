//
//  CLReachability.m
//  VNASINetworkEngine
//
//  Created by ARSMac on 7/24/14.
//  Copyright (c) 2014 ars. All rights reserved.
//

#import "CLReachability.h"

@implementation CLReachability
+ (CLReachability*)sharedCLReachability{
    static CLReachability* sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
        sharedMyManager.started =NO;
//        sharedMyManager.Status =ReachableViaWiFi;
        
        
        
        
        
    });
    return sharedMyManager;
}
-(id)init{

    if(self=[super init]){
        
    }
    return self;


}
-(void)start{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
  

    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self CheckReachability:self.internetReachability];
   

    self.started =YES;

}
- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
    
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self CheckReachability:curReach];

}
- (void)CheckReachability:(Reachability *)reachability
{
   
    if (reachability == self.hostReachability)
	{
        NSLog(@"host");
       self.clConnectivityHost= [self testConnection:reachability];

    }
    
	if (reachability == self.internetReachability)
	{
          NSLog(@"inet");
        self.clConnectivityInet= [self testConnection:reachability];
		//[self configureTextField:self.internetConnectionStatusField imageView:self.internetConnectionImageView reachability:reachability];
	}
    
	if (reachability == self.wifiReachability)
	{
         NSLog(@"wifi");
        self.clConnectivitywifi= [self testConnection:reachability];
		//[self configureTextField:self.localWiFiConnectionStatusField imageView:self.localWiFiConnectionImageView reachability:reachability];
	}
    
}

-(BOOL)testConnection:(Reachability*)reachability{
    NSLog(@"connection test");
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
  BOOL connectionRequired = [reachability connectionRequired];
 
    
    switch (netStatus)
    {
        case NotReachable:        {
//            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
//            imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
//            statusString = NSLocalizedString(@"Reachable WWAN", @"");
//            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
//            statusString= NSLocalizedString(@"Reachable WiFi", @"");
//            imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    self.Status =[self.internetReachability currentReachabilityStatus];
    NSLog(@"status changed");
    NSLog(@"connection =%@",@[@"NO",@"Yes"][netStatus !=NotReachable ]);
    return netStatus !=NotReachable;


}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if([keyPath isEqualToString:@"Status"]){
    
        if(_callback)_callback(self.Status);
    
    }



}
-(void)OnChange:(blkCLReachAbilityOnchange)Callback{

    [self start];
    _callback =[Callback copy];
    [self addObserver:self forKeyPath:@"Status" options:NSKeyValueObservingOptionNew context:Nil];
    
    


                }


@end
