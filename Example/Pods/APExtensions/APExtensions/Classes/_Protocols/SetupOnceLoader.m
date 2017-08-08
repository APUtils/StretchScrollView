//
//  SetupOnceLoader.m
//  APExtensions
//
//  Created by Anton Plebanovich on 8/3/17.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

#import <APExtensions/APExtensions-Swift.h>
#import "SetupOnceLoader.h"


@implementation SetupOnceLoader

// TODO: Measure on device. 0.1 - 0.15 on simulator.
+ (void)load {
    Protocol *setupOnce = @protocol(SetupOnce);
    
    int numberOfClasses = objc_getClassList(NULL, 0);
    Class *classList = (Class *) malloc(numberOfClasses * sizeof(Class));
    numberOfClasses = objc_getClassList(classList, numberOfClasses);
    
    for (int idx = 0; idx < numberOfClasses; idx++) {
        Class class = classList[idx];
        // Trigger SetupOnceProperty and SetupOnceMethod classes
        if (class_conformsToProtocol(class, setupOnce)) {
            NSInteger result __unused = [class setupOnce];
        }
    }
    free(classList);
}

@end
