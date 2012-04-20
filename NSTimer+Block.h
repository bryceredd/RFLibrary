//
//  NSTimer+Block.h
//  uidemo
//
//  Created by Bryce Redd on 2/28/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block) 

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)(NSTimer*))inBlock repeats:(BOOL)inRepeats;
@end
