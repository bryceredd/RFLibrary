//
// NSManagedObject+JSON.m
//
// Created by Bryce Redd on 4/25/12.
// Copyright (c) 2012 Itv. All rights reserved.
//

#import "NSManagedObject+JSON.h"
#import "NSArray+Additions.h"
#import "ISO8601DateFormatter.h"
#import "NSObject+Properties.h"
#import "NLCoreData.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation NSManagedObject (JSON)

+ (id) objectWithObject:(id)arrayOrDictionary inContext:(NSManagedObjectContext*)context {
    return [self objectWithObject:arrayOrDictionary inContext:context upsert:YES];
}

+ (id) objectWithObject:(id)arrayOrDictionary inContext:(NSManagedObjectContext*)context upsert:(BOOL)upsert {
    
    if([arrayOrDictionary isKindOfClass:[NSDictionary class]]) {
        return [self objectWithDefinition:arrayOrDictionary context:context upsert:upsert];
    }
    
    if([arrayOrDictionary isKindOfClass:[NSArray class]]) {
        return [self objectsWithArray:arrayOrDictionary context:context upsert:upsert];
    }
    
    NSLog(@"Something went wrong! JSON parse should only accept an array or dictionary but was passed: %@", arrayOrDictionary);
    
    return nil;
}

+ (id) objectWithDefinition:(NSDictionary*)definition context:(NSManagedObjectContext*)context upsert:(BOOL)upsert {
    
    if (![self conformsToProtocol:@protocol(TVJSONManagedObject)]) {
        NSLog(@"NSManagedObject+JSON objects requires the UpdateObject protocol.");
        NSAssert(false, @"");
        return nil;
    }
    
    Class klass = [self classForDocument:definition];
    NSPredicate* predicate = [(id)klass predicateForDefinition:definition];
    
    NSManagedObject<TVJSONManagedObject>* object = upsert? [(id)klass fetchOrInsertSingleWithPredicate:predicate] : [(id)klass insert];
    
    [(id)klass hydratePropertiesOnObject:object definition:definition upsert:upsert];
    [(id)klass hydrateRelationshipsOnObject:object definition:definition upsert:upsert];
    
    return object;
}

+ (id) objectsWithArray:(NSArray*)array context:(NSManagedObjectContext*)context upsert:(BOOL)upsert {
    int OPTIMIZE_LOOKUP_THRESHOLD = 5;
    
    if([array count] < OPTIMIZE_LOOKUP_THRESHOLD || !upsert) {
        return [array arrayByMappingWithBlock:^(NSDictionary* definition) {
            return [self objectWithDefinition:definition context:context upsert:upsert];
        }];
    }
    
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    NSString *jsonIdKey = [self uniqueIdKeyForDefinition:array[0]];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    request.predicate = [self predicateForDefinitions:array];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:uniqueIdKey ascending:YES]];
    
    NSError* error;
    NSArray* existingObjects = [context executeFetchRequest:request error:&error];
    NSArray* jsonObjects = [array sortedArrayUsingComparator:^(NSDictionary* def1, NSDictionary* def2) {
        return [def1[jsonIdKey] compare:def2[jsonIdKey]];
    }];
    
    //NSLog(@"sorted exising objects: %@", existingObjects);
    //NSLog(@"sorted json objects: %@", jsonObjects);
    
    NSMutableArray* objects = [NSMutableArray array];
    
    int existingObjectsIndex = 0;
    for(int i=0; i<jsonObjects.count; i++) {
        
        NSDictionary* definition = jsonObjects[i];
        NSString* jsonUniqueId = [self uniqueIdForDefinition:definition];
        
        //NSLog(@"looking for ID: %@", jsonUniqueId);
        
        NSString* existingUniqueId = nil;
        id existingObject = nil;
        while(existingObjectsIndex < existingObjects.count) {
            existingObject = existingObjects[existingObjectsIndex];
            existingUniqueId = [existingObject valueForKey:uniqueIdKey];
            
            //NSLog(@"existing store has ID: %@", existingUniqueId);
            
            if([existingUniqueId compare:jsonUniqueId] == NSOrderedAscending)
                existingObjectsIndex++;
            else
                break;
        }
        
        Class klass = [self classForDocument:definition];
        id object = ([jsonUniqueId compare:existingUniqueId] == NSOrderedSame)? existingObject : [(id)klass insert];
        
        [(id)klass hydratePropertiesOnObject:object definition:definition upsert:upsert];
        [(id)klass hydrateRelationshipsOnObject:object definition:definition upsert:upsert];
        
        [objects addObject:object];
    }
    
    return objects;
}

+ (void) hydrateRelationshipsOnObject:(NSManagedObject*)object definition:(NSDictionary*)definition upsert:(BOOL)upsert {
    
    NSDictionary* relationships = [[object entity] relationshipsByName];
    
    for(NSString* JSONKey in definition) {
        NSString* key = [self keyForJSONKey:JSONKey];
        NSDictionary* childDefinition = definition[JSONKey];
        NSRelationshipDescription* relationshipDescription = relationships[key];
        
        if(!relationshipDescription) continue;
        if(!childDefinition || [childDefinition isKindOfClass:[NSNull class]]) continue;
        
        BOOL isToMany = [relationshipDescription isToMany];
        Class relationshipClass = NSClassFromString([[relationshipDescription destinationEntity] managedObjectClassName]);
        id child = [relationshipClass objectWithObject:childDefinition inContext:object.managedObjectContext upsert:upsert];
        
        if(!upsert) {
            [object setValue:child forKey:key];
            continue;
        }
        
        else if(upsert && !isToMany) {
            
            BOOL isDifferentObject = [[object valueForKey:key] isEqual:child];
            if(!isDifferentObject) { [object setValue:child forKey:key]; }
        
        } else {
        
            // if we're upserting the relationship we have to add
            // the new objects, and remove the old.  the existing
            // ones have been updated
            
            SEL addObjectSelector = [self addSelectorForRelationship:key];
            SEL removeObjectsSelector = [self removeSelectorForRelationship:key];
            
            NSMutableSet* addedObjects = [NSMutableSet set];
            for(NSDictionary* relationshipDefinition in childDefinition) {
                
                // upsert any new objects in the relationship
                id childObject = [relationshipClass objectWithObject:relationshipDefinition inContext:object.managedObjectContext upsert:upsert];
                
                
                // add new objects that weren't there before
                if(![[object valueForKey:key] containsObject:childObject]) {
                    [object performSelector:addObjectSelector withObject:childObject];
                }
                
                // remember objects to not remove them
                [addedObjects addObject:childObject];
            }
            
            
            // remove any relationships that aren't in the
            // json dictionary - or in context, remove any
            // items that weren't in the 'addedObjects' set
            
            NSMutableSet* childrenToDelete = [[object valueForKey:key] mutableCopy];
            [childrenToDelete minusSet:addedObjects];
            
            if ([childrenToDelete count]) {
                [object performSelector:removeObjectsSelector withObject:childrenToDelete];
            }
        }
    }
}

+ (void) hydratePropertiesOnObject:(NSManagedObject<TVJSONManagedObject>*)object definition:(NSDictionary*)definition upsert:(BOOL)upsert {
    
    NSDictionary* attributes = [[object entity] attributesByName];
    
    for(NSString* JSONKey in definition) {
        NSString* key = [self keyForJSONKey:JSONKey];
        id value = definition[JSONKey];
        NSAttributeDescription* attributeDescription = attributes[key];
        
        
        // set the attribute matches from the json
        if (attributeDescription) {
            
            if (attributeDescription) value = [self massagedValue:definition[JSONKey] forAttributeType:[attributeDescription attributeType]];
            
            // we won't overwrite attributes that are identical, if we do
            // then we throw an nsnotification saying an nsmanagedobject has
            // been updated, when it's really the same in every way
            if([[object valueForKey:key] isEqual:value]) continue;
            if(!key || !value || [value isKindOfClass:[NSNull class]]) continue;
            
            [object setValue:value forKey:key];
        }
    }
}

+ (id) massagedValue:(id)value forAttributeType:(NSAttributeType)attributeType {
    static ISO8601DateFormatter* formatter = nil;
    if(!formatter) formatter = [[ISO8601DateFormatter alloc] init];
    
    if(attributeType == NSStringAttributeType && [value isKindOfClass:[NSNumber class]]) {
        value = [value stringValue];
    } else if ((attributeType == NSInteger16AttributeType || attributeType == NSInteger32AttributeType || attributeType == NSInteger64AttributeType || attributeType == NSBooleanAttributeType) && [value isKindOfClass:[NSString class]]) {
        value = [NSNumber numberWithInt:[value intValue]];
    } else if (attributeType == NSFloatAttributeType && [value isKindOfClass:[NSString class]]) {
        value = [NSNumber numberWithFloat:[value floatValue]];
    } else if (attributeType == NSDateAttributeType && [value isKindOfClass:[NSString class]]) {
        value = [formatter dateFromString:value];
    } else if (attributeType == NSDoubleAttributeType && [value isKindOfClass:[NSString class]]) {
        value = [NSNumber numberWithDouble:[value doubleValue]];
    }
    
    return value;
}

+ (NSString*) keyForJSONKey:(NSString*)key {
    if ([self respondsToSelector:@selector(propertyOverrides)]) {
        NSString* overrideKey = [(id)self propertyOverrides][key];
        if(overrideKey) return overrideKey;
    }
    
    return key;
}

+ (Class) classForDocument:(NSDictionary*)definition {
    Class<TVJSONManagedObject> klass = [self respondsToSelector:@selector(classForUniqueDocument:)]? [(id)self classForUniqueDocument:definition] : self;
    return klass? klass : self;
}

+ (NSPredicate*) predicateForDefinition:(NSDictionary*)definition {
    if (![self respondsToSelector:@selector(uniqueIdKey)]) {
        NSLog(@"TVJSONManagedObject objects must implement either uniqueIdKey or predicateForUniqueDocument:");
        NSAssert(false, @"");
        return nil;
    }
    
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    NSString *halfPredicate = [NSString stringWithFormat:@"%@=%%@", uniqueIdKey];
    NSString *uniqueId = [(id)self uniqueIdForDefinition:definition];
    
    return [NSPredicate predicateWithFormat:halfPredicate, uniqueId];
}

+ (NSPredicate*) predicateForDefinitions:(NSArray*)array {
    
    NSArray* identifiers = [array arrayByMappingWithBlock:^(NSDictionary* definition) {
        return [self uniqueIdForDefinition:definition];
    }];
    
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    NSString *halfPredicate = [NSString stringWithFormat:@"(%@ IN %%@)", uniqueIdKey];
    
    return [NSPredicate predicateWithFormat:halfPredicate, identifiers];
}

+ (NSString*) uniqueIdKeyForDefinition:(NSDictionary*)definition {
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    
    if ([(id)self respondsToSelector:@selector(propertyOverrides)]) {
        NSDictionary *overrides = [(id)self propertyOverrides];
        if ([overrides allKeysForObject:uniqueIdKey]) {
            
            // try all the keys till we find one!
            for (NSString* potentialKey in [overrides allKeysForObject:uniqueIdKey]) {
                if(definition[potentialKey]) return potentialKey;
            }
        }
    }
    return uniqueIdKey;
}

+ (NSString*) uniqueIdForDefinition:(NSDictionary*)definition {
    NSString* uniqueId = definition[[self uniqueIdKeyForDefinition:definition]];
    if(!uniqueId) {
        NSLog(@"Expected an id for key:(%@) in definition:(%@) but found none", [self uniqueIdKeyForDefinition:definition], definition);
        NSAssert(0, @"Read error above");
    }
    return uniqueId;
}

+ (SEL) addSelectorForRelationship:(NSString*)key {
    NSString* uppercaseAttribute = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] capitalizedString]];
    return NSSelectorFromString([NSString stringWithFormat:@"add%@Object:", uppercaseAttribute]);
    
}

+ (SEL) removeSelectorForRelationship:(NSString*)key {
    NSString* uppercaseAttribute = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] capitalizedString]];
    return NSSelectorFromString([NSString stringWithFormat:@"remove%@:", uppercaseAttribute]);
    
}

@end
