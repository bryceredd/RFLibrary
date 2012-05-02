//
//  NSManagedObject+JSON.m
//  DailyChallenge
//
//  Created by Bryce Redd on 4/25/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "NSManagedObject+JSON.h"
#import "NSArray+Additions.h"
#import "ISO8601DateFormatter.h"
#import "NSObject+Properties.h"


@implementation NSManagedObject (JSON)

+ (id) objectWithDefinition:(NSDictionary*)definition inContext:(NSManagedObjectContext*)context {
    NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    static ISO8601DateFormatter* formatter = nil;
    if(!formatter) formatter = [[ISO8601DateFormatter alloc] init];
    
    
    
    // set the exact attribute matches from the json
    
    NSDictionary* attributes = [[object entity] attributesByName];
    for(NSString* attribute in attributes) {
        id value = [definition objectForKey:attribute];
        if(!value) continue;
        
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        
        if(attributeType == NSStringAttributeType && [value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        } else if ((attributeType == NSInteger16AttributeType || attributeType == NSInteger32AttributeType || attributeType == NSInteger64AttributeType || attributeType == NSBooleanAttributeType) && [value isKindOfClass:[NSString class]]) {
            value = [NSNumber numberWithInt:[value intValue]];
        } else if (attributeType == NSFloatAttributeType && [value isKindOfClass:[NSString class]]) {
            value = [NSNumber numberWithFloat:[value floatValue]];
        } else if (attributeType == NSDateAttributeType && [value isKindOfClass:[NSString class]]) {
            value = [formatter dateFromString:value];
        }
        
        [object setValue:value forKey:attribute];
    }
    
    
    
    // attempt to set the exact relationship matches
    
    NSDictionary* relationships = [[object entity] relationshipsByName];
    for(NSString* relationship in relationships) {
        NSRelationshipDescription* description = [relationships objectForKey:relationship];
        id value = [definition objectForKey:relationship];
        if(!value) continue;
        
        NSEntityDescription* destination = [description destinationEntity];
        Class class = NSClassFromString([destination managedObjectClassName]);
        
        id objects = [class objectWithObject:value inContext:context];
        
        if([objects isKindOfClass:[NSArray class]]) {
            objects = [NSSet setWithArray:objects];
        }
        
        [object setValue:objects forKey:relationship];
    }
    
    
    // set the remaining properties on the entity that match the json object
    for(NSString* property in [object properties]) {
        if([relationships objectForKey:property]) continue;
        if([attributes objectForKey:property]) continue;
        
        id value = [definition objectForKey:property];
        if(!value) continue;
        
        [object setValue:value forKey:property];
    }

    return object;
}

+ (id) objectWithJSONString:(NSString*)json inContext:(NSManagedObjectContext*)context {
    NSError* error;
    id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    
    NSAssert(!error, @"There was an error parsing the json!: %@", error);
    
    return [self objectWithObject:result inContext:context];
}

+ (id) objectWithObject:(id)arrayOrDictionary inContext:(NSManagedObjectContext*)context {

    if([arrayOrDictionary isKindOfClass:[NSDictionary class]]) {
        return [self objectWithDefinition:arrayOrDictionary inContext:context];
    }
    if([arrayOrDictionary isKindOfClass:[NSArray class]]) {
        return [(NSArray*)arrayOrDictionary arrayByMappingWithBlock:^(id item) { return [self objectWithObject:item inContext:context]; }];
    }
    
    NSAssert(0, @"Something went wrong! JSON parse should only return a dictionary or array");
    return nil;
}

@end
