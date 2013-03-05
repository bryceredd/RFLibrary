//
//  NSManagedObject+JSON.h
//
//  Created by Bryce Redd on 4/25/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/NSJSONSerialization.h>


// Each CoreData object that you want to use with NSManagedObject+JSON *MUST* conform to this protocol.
// Will assert a failure if it doesn't
@protocol TVJSONManagedObject

@optional

// If there is something special that makes this document require a subclass, override this method
+ (Class)classForUniqueDocument:(NSDictionary*)definition;

// If your core data object has a nice key that ensures uniqueness, override this.
+ (NSString *)uniqueIdKey;

// Use this to handle discrepancies between the
// incoming JSON and your actual property names:
//
// e.g.
// json = {"_id":"someIdentifier"}
// coredata = NSString* myDataId
//
// - (NSDictionary *)propertyOverrides { return @{"_id":"myDataId"}; }
+ (NSDictionary *)propertyOverrides;


@end

@interface NSManagedObject (JSON)
+ (id) objectWithObject:(id)arrayOrDictionary inContext:(NSManagedObjectContext*)context; // upsert = YES
+ (id) objectWithObject:(id)arrayOrDictionary inContext:(NSManagedObjectContext*)context upsert:(BOOL)upsert;
@end
