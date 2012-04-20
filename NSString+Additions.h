//
//  NSString+Additions.h
//  tvclient
//
//  Created by Dave Durazzani on 10/29/10.
//  Copyright 2010 i.TV LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Additions)

- (NSString *) gitglueTitle;
- (NSComparisonResult) numericCompare:(NSString *)other;
- (NSString*) stripAllButLetters;
- (NSDictionary *) parseKeyValuePairs;
- (NSString *) stringSafeForURL;
- (NSString *) alphanumericAndSpaceString;
- (NSString *) alphanumericString;
+ (NSString *) humanReadableStringFromInt:(int)integer;


@end
