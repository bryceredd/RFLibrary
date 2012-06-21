//
//  NSArray+iTV.h
//  iTV
//
//  Created by Mike on 12/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Additions)

- (id) firstObject;
- (NSIndexSet *) indexesOfObjects:(NSArray *)objects;
- (NSArray *) arrayByMappingWithBlock: (id(^)(id)) block;
- (id) valueByReducingWithBlock: (id(^)(id, id)) block;
- (NSArray *) arrayByFilteringWithBlock:(BOOL(^)(id)) block;
- (BOOL) every:(BOOL(^)(id))condition;
- (NSArray*) arrayByRemovingObjectsFromArray:(NSArray*)array;

@end
