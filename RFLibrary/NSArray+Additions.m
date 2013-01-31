//
//  NSArray+iTV.m
//  iTV
//
//  Created by Mike on 12/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Additions.h"


@implementation NSArray (Additions)

- (id) firstObject {
	return ([self count] > 0)?[self objectAtIndex:0]:nil;
}

- (NSIndexSet *) indexesOfObjects:(NSArray *)objects {
	NSMutableIndexSet * indexes = [NSMutableIndexSet indexSet];
	for (id object in objects) {
		NSUInteger index = [self indexOfObject:object];
		if (index != NSNotFound)
			[indexes addIndex:index];
	}
	return indexes;
}

- (BOOL) every:(BOOL(^)(id))condition {
    BOOL result = YES;
    for(id value in self) {
        result = result && condition(value);
    }
    return result;
}

- (NSArray *) arrayByMappingWithBlock: (id(^)(id)) block {
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity: [self count]];
    for (id value in self)
    {
        [ret addObject: block(value)];
    }
    return [NSArray arrayWithArray: ret];
}

- (id) valueByReducingWithBlock: (id(^)(id, id)) block {
    id ret = nil;
    for (id value in self)
        ret = block(ret, value);
    return ret;
}

- (NSArray *) arrayByFilteringWithBlock:(BOOL(^)(id)) block {
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity: [self count]];
    for (id value in self)
        if (block(value))
            [ret addObject: value];
    return [NSArray arrayWithArray: ret];
}

- (NSArray*) arrayByRemovingObjectsFromArray:(NSArray*)array {
    NSMutableArray* temp = [self mutableCopy];
    
    [temp removeObjectsInArray:array];
    
    return temp;
}

- (NSDictionary*) groupBy:(SEL)selector {
    NSMutableDictionary* dict = [@{} mutableCopy];
    for(id item in self) {
        if(!dict[[item performSelector:selector]]) {
            dict[[item performSelector:selector]] = [NSMutableArray array];
        }
        
        [dict[[item performSelector:selector]] addObject:item];
    }
    return dict;
}

- (NSDictionary*) groupByFlat:(SEL)selector {
    NSMutableDictionary* dict = [@{} mutableCopy];
    for(id item in self) {
        dict[[item performSelector:selector]] = item;
    }
    return dict;
}

@end
