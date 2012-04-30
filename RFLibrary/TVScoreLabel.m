//
//  TVAnimatedLabel.m
//  numberflippertest
//
//  Created by Bryce Redd on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TVScoreLabel.h"
#import <QuartzCore/QuartzCore.h>

#define setFrameY(_a_, _y_) { CGRect tempframe = _a_.frame; tempframe.origin.y = _y_; _a_.frame = tempframe; }
#define setFrameHeight(_a_, _h_) { CGRect tempframe = _a_.frame; tempframe.size.height = _h_; _a_.frame = tempframe; }

@interface TVScoreLabel() 
- (void) didFinishAnimation;
- (CATransform3D) halfWayTopTransform;
- (CATransform3D) halfWayBottomTransform;
@end


@implementation TVScoreLabel

@synthesize topHalfNumber, bottomHalfNumber, backgroundTopNumber, backgroundBottomNumber, topHalf, bottomHalf;

- (CATransform3D) halfWayTopTransform {
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -300;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI/2, 1.0f, 0.0f, 0.0f);
    return rotationAndPerspectiveTransform;
}

- (CATransform3D) halfWayBottomTransform {
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -300;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI/2, 1.0f, 0.0f, 0.0f);
    return rotationAndPerspectiveTransform;
}

- (void) setScore:(NSString*)score animated:(BOOL)animated {
    
    if([score isEqualToString:backgroundTopNumber.text]) { animated = NO; }
    
    if(animated) {

        [self bringSubviewToFront:topHalf];
        
        self.backgroundTopNumber.text = score;
        self.bottomHalfNumber.text = score;        
        
        self.topHalf.layer.anchorPoint = CGPointMake(.5, 1);
        self.bottomHalf.layer.anchorPoint = CGPointMake(.5, 0);
        
        self.topHalf.layer.transform = CATransform3DIdentity;
        self.bottomHalf.layer.transform = [self halfWayBottomTransform];
        
        self.topHalf.center = CGPointMake(self.topHalf.frame.size.width/2.0, self.topHalf.frame.size.height);
        self.bottomHalf.center = CGPointMake(self.topHalf.frame.size.width/2.0, self.topHalf.frame.size.height);
        
        
        [UIView beginAnimations:@"scoreTopAnimation" context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.topHalf.layer.transform = [self halfWayTopTransform];
        [UIView commitAnimations];
        
        
        [UIView beginAnimations:@"scoreBottomAnimation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelay:.5];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didFinishAnimation)];
        self.bottomHalf.layer.transform = CATransform3DIdentity;
        [UIView commitAnimations];
        
    } else {
        
        self.topHalfNumber.text = score;
        self.bottomHalfNumber.text = score;
        self.backgroundTopNumber.text = score;
        self.backgroundBottomNumber.text = score;
    }
}

- (void) didFinishAnimation {    
    self.topHalfNumber.text = self.backgroundTopNumber.text;
    self.bottomHalfNumber.text = self.backgroundTopNumber.text;
    self.backgroundBottomNumber.text = self.backgroundTopNumber.text;
}

- (void)dealloc {
    self.topHalfNumber = nil;
    self.bottomHalfNumber = nil;
    self.backgroundTopNumber = nil;
    self.backgroundBottomNumber = nil;
    self.topHalf = nil;
    self.bottomHalf = nil;
    
    [super dealloc];
}

@end
        