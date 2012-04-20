//
// LoadingView.h
// tvclient
//
// Created by Dave Durazzani on 9/29/10.
// Copyright 2010 i.TV LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
}

@property (nonatomic, assign) IBOutlet UIActivityIndicatorView * spinner;
@property (nonatomic, assign) IBOutlet UILabel * loadingLabel;
@property (nonatomic, assign) IBOutlet UIImageView *check;

- (void) setPositionToCenterOfView:(UIView *)someView;
- (void) setText:(NSString *)text;

@end
