//
//  UIKit+Drawing.m
//  tvclient
//
//  Created by Sean Hess on 4/7/11.
//  Copyright 2011 i.TV LLC. All rights reserved.
//

#import "UIKit+Drawing.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "RFMacros.h"

@implementation UIImage (Drawing)

- (void) drawInRect:(CGRect)rect context:(CGContextRef)ctx {
    
    CGContextSaveGState(ctx);
    
    // Flip the entire coordinate system (so we get right-side-up images)
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    // The coordinate system is now entirely flipped. Plus, each box starts at its lower left corner
    // or something. To account for both, we flip the y coordinate back, and add the size of the rect
    // to compensate
    
    CGRect flippedRect;
    flippedRect.size = rect.size;
    flippedRect.origin = CGPointMake(rect.origin.x, -(rect.origin.y + rect.size.height));
    
    // Need to copy to avoid crash    
    // http://stackoverflow.com/questions/2510684/cgcontextdrawimage-returning-bad-access    
    CGImageRef imageCopy = CGImageCreateCopy(self.CGImage);
    CGContextDrawImage(ctx, flippedRect, imageCopy);        
    CFRelease(imageCopy);
    
    CGContextRestoreGState(ctx);
}

@end







@implementation NSString (Drawing) 

- (void) drawInRect:(CGRect)rect context:(CGContextRef)ctx color:(UIColor*)color font:(UIFont*)font {
    [self drawInRect:rect context:ctx color:color font:font clip:YES];
}

- (void) drawInRectUsingCoreText:(CGRect)rect context:(CGContextRef)ctx color:(UIColor *)color font:(UIFont *)font {
    // Draw the string using core text and core graphics (Thread Safe)
    
    NSString * stringToDraw = self;
    
    if (![self canBeConvertedToEncoding:NSASCIIStringEncoding]) {
    
        // Strip Unicode Characters. 
        
        // Every method I found for drawing unicode characters crashes with EXC_BAD_ACCESS 
        // randomly. This includes Core Text. The methods I've tried include using CoreText with NSAttributeString, with 
        // only CFAttributedStringRef, using both line drawing, and drawing paths to CTFrames. Everything crashes
        // at least every once in a while. 
        
        // I found one method that is supposed to work, but only with embedded fonts, which I didn't have time to 
        // figure out (Google "GlyphDrawing.mm site:stackoverflow.com"). But it looked complicated. 
    
        NSMutableString * string = [NSMutableString stringWithCapacity:self.length];
        
        for (int i = 0; i < self.length; i++) {
            NSString * character = [self substringWithRange:NSMakeRange(i, 1)];
            
                 if ([character isEqualToString:@"é"]) character = @"e";
            else if ([character isEqualToString:@"á"]) character = @"a";
            else if ([character isEqualToString:@"Á"]) character = @"A";
            else if ([character isEqualToString:@"ó"]) character = @"o";
            else if ([character isEqualToString:@"í"]) character = @"i";
            else if ([character isEqualToString:@"ñ"]) character = @"n";
            else if ([character isEqualToString:@"ú"]) character = @"u";
            
            else if (![character canBeConvertedToEncoding:NSASCIIStringEncoding]) character = @"";
            
            [string appendString:character];            
        }
        
        
        stringToDraw = string;
    }
    
    CTFontRef fontref = CTFontCreateWithName(CFSTR("Helvetica-Bold"), ipad?14:12, NULL);
    
    CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorAttributeName };
    CFTypeRef values[] = { fontref, [UIColor whiteColor].CGColor };
    
    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, 
                                (const void**)&keys, 
                                (const void**)&values, sizeof(keys) / sizeof(keys[0]), NULL, NULL);
    
    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, (__bridge CFStringRef)stringToDraw, attributes);        
    
    CGContextSaveGState(ctx);    
    CGContextScaleCTM(ctx, 1.0, -1.0);
            
    CGRect flippedRect;
    flippedRect.size = rect.size;
    flippedRect.origin = CGPointMake(rect.origin.x, -(rect.origin.y + rect.size.height));
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    CGPathAddRect(path, NULL, flippedRect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
        
    
    // hack, we'll move the origin y depending on the # of lines
    CFArrayRef array = CTFrameGetLines(frame);
    int count = CFArrayGetCount(array);
    
    CGPathRelease(path);
    CFRelease(frame);

    path = CGPathCreateMutable();
    flippedRect.origin.y += count* (ipad?17:15);
    CGPathAddRect(path, NULL, flippedRect);
    frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    /////////////////////////////
    
    
    
                    
    CTFrameDraw(frame, ctx);
    CGContextRestoreGState(ctx);
    
    
    CFRelease(attributes);
    CFRelease(fontref);
    CFRelease(attrString);
    CFRelease(framesetter);
    CGPathRelease(path);
    CFRelease(frame);
    

}



- (void) drawInRect:(CGRect)rect context:(CGContextRef)ctx color:(UIColor*)color font:(UIFont*)font clip:(BOOL)clip {


    // Draw the string using core text and core graphics (Thread Safe)
    
    NSString * stringToDraw = self;
    
    if (![self canBeConvertedToEncoding:NSASCIIStringEncoding]) {
    
        // Strip Unicode Characters. 
        
        // Every method I found for drawing unicode characters crashes with EXC_BAD_ACCESS 
        // randomly. This includes Core Text. The methods I've tried include using CoreText with NSAttributeString, with 
        // only CFAttributedStringRef, using both line drawing, and drawing paths to CTFrames. Everything crashes
        // at least every once in a while. 
        
        // I found one method that is supposed to work, but only with embedded fonts, which I didn't have time to 
        // figure out (Google "GlyphDrawing.mm site:stackoverflow.com"). But it looked complicated. 
    
        NSMutableString * string = [NSMutableString stringWithCapacity:self.length];
        
        for (int i = 0; i < self.length; i++) {
            NSString * character = [self substringWithRange:NSMakeRange(i, 1)];
            
                 if ([character isEqualToString:@"é"]) character = @"e";
            else if ([character isEqualToString:@"á"]) character = @"a";
            else if ([character isEqualToString:@"Á"]) character = @"A";
            else if ([character isEqualToString:@"ó"]) character = @"o";
            else if ([character isEqualToString:@"í"]) character = @"i";
            else if ([character isEqualToString:@"ñ"]) character = @"n";
            else if ([character isEqualToString:@"ú"]) character = @"u";
            
            else if (![character canBeConvertedToEncoding:NSASCIIStringEncoding]) character = @"";
            
            [string appendString:character];            
        }
        
        
        stringToDraw = string;
    }
    
    const char * text = [stringToDraw cStringUsingEncoding:NSUTF8StringEncoding]; 
    
    CGContextSaveGState(ctx);    
    
    // Color
    CGColorRef colorCopy = CGColorCreateCopy(color.CGColor);
    CGContextSetFillColorWithColor(ctx, colorCopy);
    CGContextSetStrokeColorWithColor(ctx, colorCopy);
    CFRelease(colorCopy);
    
    // Font
    // Load font file from otf file
    CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], font.pointSize, kCGEncodingMacRoman); // UNICODE doesn't work!
    
    // Flip
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGRect flippedRect;
    flippedRect.size = rect.size;
    flippedRect.origin = CGPointMake(rect.origin.x, -(rect.origin.y + rect.size.height));
    
    // Clip, make the clip box a little bigger to account for the baseline. It draws at the BOTTOM
    // of the box, unfortunately. There's no way to know the actual size of the text, so you have
    // to get the size right when you pass it in. 
    
    if (clip) CGContextClipToRect(ctx, CGRectMake(flippedRect.origin.x, flippedRect.origin.y - flippedRect.size.height/2, flippedRect.size.width, flippedRect.size.height * 1.5));    

    // Fill     
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextShowTextAtPoint(ctx, flippedRect.origin.x, flippedRect.origin.y, text, strlen(text));
        
    CGContextRestoreGState(ctx);      
}

@end


//    CGAffineTransform original = CGContextGetCTM(ctx);
//    CGContextSetTextMatrix ... CGContextGetTextMatrix - not reset with restore GState





@implementation UIColor (Drawing)

- (void)drawInRect:(CGRect)rect context:(CGContextRef)ctx {

    CGColorRef colorCopy = CGColorCreateCopy(self.CGColor);
    CGContextSetFillColorWithColor(ctx, colorCopy);
    CGContextAddRect(ctx, rect);
    CGContextFillPath(ctx);
    CFRelease(colorCopy);

}

@end
