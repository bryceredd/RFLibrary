//
//  NSObject+RFLibrary.h
//  FMG
//
//  Created by Bryce Redd on 12/30/12.
//  Copyright (c) 2012 Bryce Redd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLCoreData.h"
#import "NSManagedObject+TVJSON.h"

typedef void (^RFBlock)();
typedef void (^RFArrayBlock)(NSArray*);
typedef void (^RFItemBlock)(id);
typedef void (^RFAsyncBlock)(RFBlock);

@interface NSManagedObject (RFLibrary)

+ (RFItemBlock) mapJSON:(RFItemBlock)callback;

+ (NSFetchedResultsController*) observeSingle:(RFItemBlock)callback;
+ (NSFetchedResultsController*) observeWithCallback:(RFArrayBlock)callback;
+ (NSFetchedResultsController*) observeWithPredicate:(id)predicateOrString callback:(RFArrayBlock) callback;
+ (NSFetchedResultsController*) observeWithPredicate:(id)predicateOrString sort:(NSString*)key callback:(RFArrayBlock)callback;


@end
