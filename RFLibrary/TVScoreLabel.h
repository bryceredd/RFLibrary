//
//  TVAnimatedLabel.h
//  numberflippertest
//
//  Created by Bryce Redd on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface TVScoreLabel : UIView {
    
}

@property(nonatomic, retain) IBOutlet UILabel* topHalfNumber;
@property(nonatomic, retain) IBOutlet UILabel* bottomHalfNumber;
@property(nonatomic, retain) IBOutlet UILabel* backgroundTopNumber;
@property(nonatomic, retain) IBOutlet UILabel* backgroundBottomNumber;
@property(nonatomic, retain) IBOutlet UIView* topHalf;
@property(nonatomic, retain) IBOutlet UIView* bottomHalf;


- (void) setScore:(NSString*)score animated:(BOOL)animated;

@end
