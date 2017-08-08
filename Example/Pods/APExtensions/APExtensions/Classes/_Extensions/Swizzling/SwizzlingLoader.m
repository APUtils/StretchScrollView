//
//  SwizzlingLoader.m
//  APExtensions
//
//  Created by Anton Plebanovich on 8/3/17.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

#import <APExtensions/APExtensions-Swift.h>
#import "SwizzlingLoader.h"


@interface UIViewController (Private)

+ (NSInteger)setupOnce;

@end


@implementation SwizzlingLoader

+ (void)load {
    if ([UIViewController respondsToSelector:@selector(setupOnce)]) {
        NSInteger result __unused = [UIViewController setupOnce];
    }
}

@end
