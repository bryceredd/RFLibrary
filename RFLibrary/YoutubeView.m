//
//  YoutubeView.m
//  TVPulse
//
//  Created by Bryce Redd on 8/1/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import "YoutubeView.h"

@implementation YoutubeView

@synthesize playOnLoad;

- (void) loadYoutubeVideoId:(NSString*)videoId {
    NSString* html = [NSString stringWithFormat:@"<html><body style='margin:0'><embed id='yt' src='http://www.youtube.com/v/%@' type='application/x-shockwave-flash' width='%0.0f' height='%0.0f'></embed></body></html>", videoId, self.frame.size.width, self.frame.size.height];

    [self loadHTMLString:html baseURL:nil];

    for(UIView* sv in self.subviews) {
       if([sv isKindOfClass:[UIScrollView class]]) {
           UIScrollView *scv = (UIScrollView*)sv;
           scv.scrollEnabled = NO;
       }
    }
}

- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;

    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }

    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }

    return button;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    if(!playOnLoad) return;
    
    UIButton *b = [self findButtonInView:_webView];
    [b sendActionsForControlEvents:UIControlEventTouchUpInside];
}
@end
