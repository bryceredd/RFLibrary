//
//  LoadingView.m
//  tvclient
//
//  Created by Dave Durazzani on 9/29/10.
//  Copyright 2010 i.TV LLC. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView

@synthesize spinner;
@synthesize loadingLabel;
@synthesize check;

- (void) awakeFromNib {
    self.clipsToBounds = YES;
    [self.layer setCornerRadius:10.0f];
    self.loadingLabel.font = [UIFont fontWithName:@"Neutraface2Text-Bold" size:26.f];
}

- (void) setPositionToCenter {
	[self setPositionToCenterOfView:[self superview]];
}

- (void) setPositionToCenterOfView:(UIView *)someView {
	self.center = CGPointMake(CGRectGetMidX(someView.bounds), CGRectGetMidY(someView.bounds));
}

- (void) setText:(NSString*)text {
	loadingLabel.text = text;
}

@end
