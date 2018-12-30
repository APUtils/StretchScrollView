//
//  APUtils.h
//  APExtensions
//
//  Created by Anton Plebanovich on 11/3/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface APUtils : NSObject
+ (NSException * _Nullable)perform:(__attribute__((noescape)) void (^)(void))block;
@end
NS_ASSUME_NONNULL_END
