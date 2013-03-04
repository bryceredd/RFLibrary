//
//  RFFetchedResultsController.h
//  FMG
//
//  Created by Bryce Redd on 1/20/13.
//  Copyright (c) 2013 Bryce Redd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RFFetchedResultsController : NSFetchedResultsController <NSFetchedResultsControllerDelegate>

@property (nonatomic, copy) void(^updateCallback)(NSArray*);

@end
