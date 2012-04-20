//
//  TextFieldWithInset.m
//  photoStream
//
//  Created by Bryce Redd on 1/22/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "TextFieldWithInset.h"

@implementation TextFieldWithInset

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
     return CGRectInset( bounds , 10 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
     return CGRectInset( bounds , 10 , 0 );
}

@end
