//
//  RNTextView.h
//  TextDemo
//
//  Created by Rob on 9/7/10.
//  Copyright 2010 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface RNTextView : UIView

@property (nonatomic, readwrite, copy) NSAttributedString *attributedString;
@property (nonatomic, readwrite, copy) NSArray *paths;
@end
