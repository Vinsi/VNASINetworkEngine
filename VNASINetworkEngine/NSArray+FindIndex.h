//
//  NSArray+FindIndex.h
//  VNASINetworkEngine
//
//  Created by ARSMac on 7/21/14.
//  Copyright (c) 2014 ars. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef bool(^arraycallback)(id eachitem);
@interface NSArray (FindIndex){
}
-(NSInteger)FindIndex:(arraycallback )callback;
@end
