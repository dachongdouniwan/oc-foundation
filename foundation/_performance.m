//
//  _performance.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "_performance.h"

#pragma mark -

@implementation _Performance {
    NSMutableDictionary * _tags;
}

@def_singleton( _Performance );

- (id)init {
    self = [super init];
    if ( self ) {
        _tags = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)enter:(NSString *)tag {
    NSNumber * time = [NSNumber numberWithDouble:CACurrentMediaTime()];
    NSString * name = [NSString stringWithFormat:@"%@ enter", tag];
    
    [_tags setObject:time forKey:name];
}

- (void)leave:(NSString *)tag {
    @autoreleasepool {
        NSString * name1 = [NSString stringWithFormat:@"%@ enter", tag];
        NSString * name2 = [NSString stringWithFormat:@"%@ leave", tag];
        
#if __LOGGING__
        
        CFTimeInterval time1 = [[_tags objectForKey:name1] doubleValue];
        CFTimeInterval time2 = CACurrentMediaTime();
        
        logi( @"Time '%@' = %.0f(ms)", tag, fabs(time2 - time1) );
        
#endif	// #if __LOGGING__
        
        [_tags removeObjectForKey:name1];
        [_tags removeObjectForKey:name2];
    }
}

@end
