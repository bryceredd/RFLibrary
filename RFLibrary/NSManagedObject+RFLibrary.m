//
//  NSObject+RFLibrary.m
//  FMG
//
//  Created by Bryce Redd on 12/30/12.
//  Copyright (c) 2012 Bryce Redd. All rights reserved.
//

#import "NSManagedObject+RFLibrary.h"
#import "RFFetchedResultsController.h"

@implementation NSManagedObject (RFLibrary)

+ (RFItemBlock) mapJSON:(RFItemBlock)callback {
    return ^(id data) {
        id obj = [self objectWithObject:data inContext:[NSManagedObjectContext mainContext] upsert:YES];
        
        [[NSManagedObjectContext mainContext] saveNested];
        
        if(callback) callback(obj);
    };
}

+ (NSFetchedResultsController*) observeSingle:(RFItemBlock)callback {
    return [self observeWithCallback:^(NSArray* objs) { callback(objs.count? objs[0]: nil); }];
}

+ (NSFetchedResultsController*) observeWithCallback:(RFArrayBlock)callback {
    return [self observeWithPredicate:nil callback:callback];
}

+ (NSFetchedResultsController*) observeWithPredicate:(id)predicateOrString callback:(RFArrayBlock)callback {
    if (![self conformsToProtocol:@protocol(TVJSONManagedObject)]) {
        NSLog(@"Class: %@ does not conform to TVJSONManagedObject protocol!", self);
        NSAssert(0, @"See error above");
    }
    return [self observeWithPredicate:predicateOrString sort:[(id)self uniqueIdKey] callback:callback];
}

+ (NSFetchedResultsController*) observeWithPredicate:(id)predicate sort:(NSString*)key callback:(RFArrayBlock)callback {

    NSManagedObjectContext* context = [NSManagedObjectContext mainContext];
    NSEntityDescription* entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    
    if([predicate isKindOfClass:[NSString class]]) {
        predicate = [NSPredicate predicateWithFormat:(NSString*)predicate];
    }
    
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    request.predicate = predicate;
    request.entity = entity;
    request.fetchBatchSize = 50;
    
    RFFetchedResultsController* controller = [[RFFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    controller.updateCallback = callback;
    
    [controller performFetch:nil];
    callback(controller.fetchedObjects);

    return controller;
}
            

@end
