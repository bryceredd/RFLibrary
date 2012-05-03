//
//  UIKit+Drawing.h
//  tvclient
//
//  Created by Sean Hess on 4/7/11.
//  Copyright 2011 i.TV LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Drawing)

- (void) drawInRect:(CGRect)rect context:(CGContextRef)ctx;

@end



@interface NSString (Drawing)

// WARNING: Size must be nearly correct or it won't display well. 
- (void) drawInRect:(CGRect)rect context:(CGContextRef)ctx color:(UIColor*)color font:(UIFont*)font;
- (void) drawInRectUsingCoreText:(CGRect)rect context:(CGContextRef)ctx color:(UIColor *)color font:(UIFont *)font;
- (void) drawInRect:(CGRect)rect context:(CGContextRef)ctx color:(UIColor*)color font:(UIFont*)font clip:(BOOL)clip;


@end



@interface UIColor (Drawing)

- (void)drawInRect:(CGRect)rect context:(CGContextRef)ctx;

@end