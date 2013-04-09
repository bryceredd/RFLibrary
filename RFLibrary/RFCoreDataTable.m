//
//  RFCoreDataTable.m
//  FMG
//
//  Created by Bryce Redd on 12/30/12.
//  Copyright (c) 2012 Bryce Redd. All rights reserved.
//

#import "RFCoreDataTable.h"

@interface RFCoreDataTable()
@end

@implementation RFCoreDataTable

- (void) observeClass:(Class)klass {
    [self observeClass:klass predicate:nil];
}

- (void) observeClass:(Class)klass predicate:(NSPredicate*)predicate {
    if (![klass conformsToProtocol:@protocol(TVJSONManagedObject)]) {
        NSLog(@"Class: %@ does not conform to TVJSONManagedObject protocol!", klass);
        NSAssert(0, @"See error above");
    }
    
    [self observeClass:klass predicate:predicate sort:[(id)klass uniqueIdKey] ascending:YES];
}

- (void) observeClass:(Class)klass predicate:(NSPredicate*)predicate sort:(NSString*)key ascending:(BOOL)ascending {
    if (!key) key = [(id)klass uniqueIdKey];
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
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

- (void) stopObservation {
    self.results.delegate = nil;
    self.results = nil;
}

- (NSObject<TVJSONManagedObject>*) objectAtIndexPath:(NSIndexPath*)indexPath {
    return [self.results objectAtIndexPath:indexPath];
}

- (int) numberOfSections {
    return [[self.results sections] count];
}

- (int) numberOfObjectsForSection:(int)section {
    return [[[self.results sections] objectAtIndex:section] numberOfObjects];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self cellForRowAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}

@end
