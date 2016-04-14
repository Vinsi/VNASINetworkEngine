//
//  GlobalTypes.h
//  iValuation
//
//  Created by solutino technologies pvt ltd on 18/12/12.
//
//

#import <Foundation/Foundation.h>
#ifndef BUNDLE_IDENTIFIER
#define BUNDLE_IDENTIFIER [[NSBundle mainBundle] bundleIdentifier]
#endif
#ifndef BUNDLE_VER
#define BUNDLE_VER [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]floatValue ]
#endif
#ifndef BLOCK_SAFE_RUN
#define BLOCK_SAFE_RUN(block, ...) if(block!=nil) { block(__VA_ARGS__); }
#endif



