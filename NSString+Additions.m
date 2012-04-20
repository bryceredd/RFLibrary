//
//  NSString+Additions.m
//  tvclient
//
//  Created by Dave Durazzani on 10/29/10.
//  Copyright 2010 i.TV LLC. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (Additions)

- (NSComparisonResult) numericCompare:(NSString *)other {
	return [self compare:other options:NSNumericSearch];
}

- (NSString*) stripAllButLetters {
	NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
	return [self stringByTrimmingCharactersInSet:charactersToRemove];
}

- (NSDictionary *) parseKeyValuePairs {
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	NSArray * pairs = [self componentsSeparatedByString:@"&"];
	for (NSString * pair in pairs) {
		NSArray * components = [pair componentsSeparatedByString:@"="];
		if ([components count] != 2) {
			NSLog(@"ERROR: Unable to parse key/value from string: \"%@\"", pair);
			return nil;
		}
		[dict setObject:[components objectAtIndex:1] forKey:[components objectAtIndex:0]];
	}
	return dict;
}

- (NSString *) stringSafeForURL {
	
	CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(NULL,
																	(__bridge CFStringRef)self,
																	NULL,
																	(__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	kCFStringEncodingUTF8 );
	NSString *safeString = [NSString stringWithFormat:@"%@", (__bridge NSString*)stringRef];
	CFRelease(stringRef);
	
	return safeString;
	
}

- (NSString *) gitglueTitle {
    
    //1) Lowercase the title and remove any non alphanumeric characters (excluding spaces). So only keep numbers, letters, and spaces
    //2) Tokenize the title and drop any of these words: "the", "and", "&", "a"
    //3) Convert spaces to underscore
    //4) Prepend "tv_shows/" to the string
    

    NSString* strippedTitle = [self alphanumericAndSpaceString];
    NSMutableArray* acceptedWords = [NSMutableArray array];
    
    
    for(NSString* word in [[strippedTitle lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]) {
        if([word isEqualToString:@"the"] || [word isEqualToString:@"and"] || [word isEqualToString:@"&"] || [word isEqualToString:@"a"]) { continue; }
        
        if(![word length]) { continue; }
        
        [acceptedWords addObject:word];
    }
    
   return [acceptedWords componentsJoinedByString:@"_"];
    
    
}

- (NSString *) alphanumericString {
    NSCharacterSet* acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
    NSCharacterSet* unacceptableCharacters = [acceptableCharacters invertedSet];
    
    NSMutableString* mutableString = [self mutableCopy];
    
    for(NSRange range = [mutableString rangeOfCharacterFromSet:unacceptableCharacters]; range.location != NSNotFound; range = [mutableString rangeOfCharacterFromSet:unacceptableCharacters]) {
        [mutableString deleteCharactersInRange:range];
    }
    
    return mutableString;
}

- (NSString *) alphanumericAndSpaceString {
    
    NSCharacterSet* acceptableCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 "];
    NSCharacterSet* unacceptableCharacters = [acceptableCharacters invertedSet];
    
    NSMutableString* mutableString = [self mutableCopy]; 
    
    for(NSRange range = [mutableString rangeOfCharacterFromSet:unacceptableCharacters]; range.location != NSNotFound; range = [mutableString rangeOfCharacterFromSet:unacceptableCharacters]) {
        [mutableString deleteCharactersInRange:range];
    }
    
    return mutableString;
}

+ (NSString *) humanReadableStringFromInt:(int)integer {
    // greater than one million
    if(integer > 1000000) {
        return [NSString stringWithFormat:@"%.01fm", integer/1000000.f];
    }
    
    
    // larger than one thousand
    if(integer > 1000) {
        return [NSString stringWithFormat:@"%.01fk", integer/1000.f];
    }
    
    return [NSString stringWithFormat:@"%d", integer];
}

@end
