//
//  NSMutableArray+Findindex.m
//  VNASINetworkEngine
//
//  Created by ARSMac on 7/21/14.
//  Copyright (c) 2014 ars. All rights reserved.
//

#import "NSMutableArray+Findindex.h"

@implementation NSMutableArray (Findindex)
-(NSInteger)FindIndex:(arraycallback )callback{
    
    NSInteger length =[self count];
    for (int i =0 ;i<length;++i){
        BOOL result =callback(self[i]);
        if(result){
            
            return i;
        }
        
    }
    return -1;
}
@end
