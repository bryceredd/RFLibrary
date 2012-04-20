//
//  NSTimer+Block.m
//  uidemo
//
//  Created by Bryce Redd on 2/28/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)

+ (void) callbackFunction:(NSTimer*)timer {
    if([timer userInfo]) {
        void (^block)(NSTimer*) = (void (^)(NSTimer*))[timer userInfo];
        block(timer);
    }
}

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)(NSTimer*))inBlock repeats:(BOOL)inRepeats {
    void (^block)() = [inBlock copy];
    return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(callbackFunction:) userInfo:block repeats:inRepeats];
}



@end
