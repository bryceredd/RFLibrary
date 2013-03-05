//
//  RFCollectionView.m
//  FMG
//
//  Created by Bryce Redd on 12/30/12.
//  Copyright (c) 2012 Bryce Redd. All rights reserved.
//

#import "RFCoreDataCollectionView.h"

@interface RFCoreDataCollectionView ()
@property(nonatomic) NSMutableArray* objectChanges;
@property(nonatomic) NSMutableArray* sectionChanges;
@property(nonatomic) NSFetchedResultsController* results;
@end

@implementation RFCoreDataCollectionView

- (void) observeClass:(Class)klass {
    [self observeClass:klass predicate:nil];
}

- (void) observeClass:(Class)klass predicate:(NSPredicate*)predicate {
    if (![klass conformsToProtocol:@protocol(JSONBackedManagedObject)]) {
        NSLog(@"Class: %@ does not conform to JSONBackedManagedObject protocol!", klass);
        NSAssert(0, @"See error above");
    }
    
    [self observeClass:klass predicate:predicate sort:[(id)klass uniqueIdKey]];
}

- (void) observeClass:(Class)klass predicate:(NSPredicate*)predicate sort:(NSString*)key {
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:[(id)klass uniqueIdKey] ascending:YES];
    NSManagedObjectContext* context = [NSManagedObjectContext mainContext];
    NSEntityDescription* entity = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    if([predicate isKindOfClass:[NSString class]]) {
        predicate = [NSPredicate predicateWithFormat:(NSString*)predicate];
    }
    
    request.predicate = predicate;
    request.entity = entity;
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    request.fetchBatchSize = 50;
    
    NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    [self observeFetchedResultsController:controller];
}

- (void) observeFetchedResultsController:(NSFetchedResultsController*)controller {
    self.results = controller;
    self.results.delegate = self;
    
    if(self.results.fetchRequest.resultType == NSDictionaryResultType) {
        self.results.delegate = nil;
        NSLog(@"FETCH REQUEST RESULT TYPE IS DICTIONARY - AUTOMATIC UPDATES DISABLED");
    }
    
    [_results performFetch:nil];
    [self reloadData];
}

- (NSObject<JSONBackedManagedObject>*) objectAtIndexPath:(NSIndexPath*)indexPath {
    return [self.results objectAtIndexPath:indexPath];
}

- (int) numberOfSections {
    return [[self.results sections] count];
}

- (int) numberOfObjectsForSection:(int)section {
    return [[[self.results sections] objectAtIndex:section] numberOfObjects];
}

- (void) stopObservation {
    self.results.delegate = nil;
    self.results = nil;
}


#pragma observation methods

- (NSMutableArray*) objectChanges {
    if (!_objectChanges) {
        _objectChanges = [NSMutableArray array];
    }
    return _objectChanges;
}

- (NSMutableArray*) sectionChanges {
    if (!_sectionChanges) {
        _sectionChanges = [NSMutableArray array];
    }
    return _sectionChanges;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @[@(sectionIndex)];
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @[@(sectionIndex)];
            break;
    }
    
    [self.sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [self.objectChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([self.sectionChanges count] > 0) {
        [self performBatchUpdates:^{
            for (NSDictionary *change in _sectionChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    if(![obj isKindOfClass:[NSArray class]]) {
                        obj = @[obj];
                    }
                    
                    for(id item in obj) {
                        NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                        switch (type) {
                            case NSFetchedResultsChangeInsert:
                                [self insertSections:[NSIndexSet indexSetWithIndex:[item unsignedIntegerValue]]];
                                break;
                            case NSFetchedResultsChangeDelete:
                                [self deleteSections:[NSIndexSet indexSetWithIndex:[item unsignedIntegerValue]]];
                                break;
                            case NSFetchedResultsChangeUpdate:
                                [self reloadSections:[NSIndexSet indexSetWithIndex:[item unsignedIntegerValue]]];
                                break;
                        }
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([self.objectChanges count] > 0 && [self.sectionChanges count] == 0) {
        [self performBatchUpdates:^{
            
            for (NSDictionary *change in self.objectChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [self insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    [self.sectionChanges removeAllObjects];
    [self.objectChanges removeAllObjects];
}


@end
