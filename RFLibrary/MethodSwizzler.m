//
//  MethodSwizzler.m
//  RFLibrary
//
//  Created by Bryce Redd on 4/29/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "MethodSwizzler.h"
#import <objc/runtime.h>
#import </usr/include/objc/objc-class.h>

@implementation MethodSwizzler

+ (void) swizzleClass:(Class)klass selector:(SEL)original withSelector:(SEL)alternate {
    
    Method orig_method = class_getInstanceMethod(klass, original);
    Method alt_method = class_getInstanceMethod(klass, alternate);
    
    // if both methods are found, swizzle them
    if (orig_method && alt_method) {
        method_exchangeImplementations(orig_method, alt_method);
    }
}

@end
