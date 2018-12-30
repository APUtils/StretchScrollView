//
//  APExtensionsLoader.m
//  APExtensions
//
//  Created by Anton Plebanovich on 8/3/17.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

#if CORE
#import <APExtensionsCore/APExtensionsCore-Swift.h>
#else
#import <APExtensions/APExtensions-Swift.h>
#endif

#import "APExtensionsLoader.h"


static Class *_allClasses = nil;
static int _count = 0;


@implementation APExtensionsLoader

// 0.012 - 0.15 on 5s simulator.
// 0.02 - 0.023 on 5s
+ (void)load {
    _count = objc_getClassList(NULL, 0);
    _allClasses = (Class *)malloc(_count * sizeof(Class));
    _count = objc_getClassList(_allClasses, _count);
    
    // Trigger SetupOnce
    Protocol *setupOnce = @protocol(SetupOnce);
    for (int index = 0; index < _count; index++) {
        Class class = _allClasses[index];
        
        if (class_conformsToProtocol(class, setupOnce)) {
            NSInteger result __unused = [class setupOnce];
        }
    }
}
    
// 0.007 - 0.02 on 5s
+ (NSArray<Class> * _Nonnull)getClassesConformToProtocol:(Protocol * _Nonnull)protocol {
    NSMutableArray<Class> *array = [NSMutableArray<Class> new];
    for (int index = 0; index < _count; index++) {
        Class class = _allClasses[index];
        
        if (class_conformsToProtocol(class, protocol)) {
            [array addObject:class];
        }
    }
    
    return array;
}

// 0.015 on 5s
+ (NSArray<Class> * _Nonnull)getChildClassesForClass:(Class _Nonnull)class {
    NSMutableArray<Class> *array = [NSMutableArray<Class> new];
    for (int index = 0; index < _count; index++) {
        Class currentClass = _allClasses[index];
        
        if (class_getSuperclass(currentClass) == class) {
            [array addObject:currentClass];
        }
    }
    
    return array;
}

@end
