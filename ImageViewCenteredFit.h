//
//  ImageViewCenteredFit.h
//  tvtag
//
//  Created by I.tv on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCenteredFit : UIImageView {
    UIImageView* _imageView;
}

@property (nonatomic, strong)       UIImage* image;

@end
