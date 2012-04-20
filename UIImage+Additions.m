//
//  UIImage+Additions.m
//  photoStream
//
//  Created by Bryce Redd on 1/19/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage(Additions)

#pragma mark -
#pragma mark Scale and crop image
- (UIImage*)imageScaledToSize:(CGSize)newSize {
   UIGraphicsBeginImageContext(newSize);
   [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
   
   UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   return newImage;
}
@end
