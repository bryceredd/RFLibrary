//
//  NSObject+Properties.m
//  RFLibrary
//
//  Created by Bryce Redd on 5/1/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "NSObject+Properties.h"
#import <objc/runtime.h>

@implementation NSObject (Properties)

- (NSArray*) properties {
    NSMutableArray* array = [NSMutableArray array];
    
    // set all the properties that weren't relationships nor attributes
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            [array addObject:[NSString stringWithCString:propName encoding:NSASCIIStringEncoding]];
        }
    }
    free(properties);
    
    return array;
}

@end
