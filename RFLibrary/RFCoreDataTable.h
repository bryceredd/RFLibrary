//
//  RFCoreDataTable.h
//  FMG
//
//  Created by Bryce Redd on 12/30/12.
//  Copyright (c) 2012 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLCoreData.h"
#import "NSManagedObject+TVJSON.h"

@interface RFCoreDataTable : UITableView <NSFetchedResultsControllerDelegate>

// to setup, set one of the followingfunctions:
// klass must implement TVJSONManagedObject

- (void) observeClass:(Class)klass;
- (void) observeClass:(Class)klass predicate:(id)predicateOrString;
- (void) observeClass:(Class)klass predicate:(id)predicateOrString sort:(NSString*)key;
- (void) observeFetchedResultsController:(NSFetchedResultsController*)controller;

- (NSObject<TVJSONManagedObject>*) objectAtIndexPath:(NSIndexPath*)indexPath;
- (int) numberOfSections;
- (int) numberOfObjectsForSection:(int)section;

- (void) stopObservation;

@end
