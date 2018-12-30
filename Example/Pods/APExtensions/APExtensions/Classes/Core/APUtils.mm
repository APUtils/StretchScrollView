//
//  APUtils.m
//  APExtensions
//
//  Created by Anton Plebanovich on 11/3/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

#import "APUtils.h"
#import <exception>


@implementation APUtils

+ (NSException *)perform:(__attribute__((noescape)) void (^)(void))block {
    try {
        block();
    } catch (NSException *exception) {
        return exception;
    } catch (const std::exception &e) {
        NSString *description = [NSString stringWithUTF8String:e.what()];
        return [NSException exceptionWithName:@"cppException" reason:description userInfo:nil];
    } catch (...) {
        return [NSException exceptionWithName:@"Unknown exception" reason:@"Unknown reason" userInfo:nil];
    }
    
    return nil;
}

@end
