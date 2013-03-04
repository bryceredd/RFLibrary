//
//  RFFetchedResultsController.m
//  FMG
//
//  Created by Bryce Redd on 1/20/13.
//  Copyright (c) 2013 Bryce Redd. All rights reserved.
//

#import "RFFetchedResultsController.h"

@implementation RFFetchedResultsController

- (id) initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name {
    if ((self = [super initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:name])) {
        self.delegate = self;
    } return self;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if(self.updateCallback) self.updateCallback([self fetchedObjects]);
}

@end
