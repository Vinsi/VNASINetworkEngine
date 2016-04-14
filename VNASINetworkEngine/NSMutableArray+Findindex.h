//
//  NSMutableArray+Findindex.h
//  VNASINetworkEngine
//
//  Created by ARSMac on 7/21/14.
//  Copyright (c) 2014 ars. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef bool(^arraycallback)(id eachitem);
@interface NSMutableArray (Findindex){

}
-(NSInteger)FindIndex:(arraycallback )callback;
@end
