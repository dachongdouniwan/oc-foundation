//
//  NSTimer+JKAddition.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer ( Extension )

#pragma mark - Timer control

- (void)pauseTimer {
    if (![self isValid]) {
        return;
    }
    
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    if (![self isValid]) {
        return;
    }
    
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return;
    }
    
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

#pragma mark - Block

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+ (void)__executeSimpleBlock:(NSTimer *)inTimer {
    if([inTimer userInfo]) {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end
