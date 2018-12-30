//
//  APExtensionsLoader.h
//  APExtensions
//
//  Created by Anton Plebanovich on 8/3/17.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APExtensionsLoader: NSObject
+ (NSArray<Class> * _Nonnull)getClassesConformToProtocol:(Protocol * _Nonnull)protocol;
+ (NSArray<Class> * _Nonnull)getChildClassesForClass:(Class _Nonnull)class;
@end
