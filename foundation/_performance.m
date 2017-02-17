//
//     ____              _____    _____    _____
//    / ___\   /\ /\     \_   \   \_  _\  /\  __\
//    \ \     / / \ \     / /\/    / /    \ \  _\_
//  /\_\ \    \ \_/ /  /\/ /_     / /      \ \____\
//  \____/     \___/   \____/    /__|       \/____/
//
//	Copyright BinaryArtists development team and other contributors
//
//	https://github.com/BinaryArtists/suite.great
//
//	Free to use, prefer to discuss!
//
//  Welcome!
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
        CFTimeInterval time2 = CACurrentMediaTime(); // this method returns, units to seconds
        
        logi( @"Time '%@' = %.0f(ms)", tag, fabs((time2 - time1)*1000) );
        
#endif	// #if __LOGGING__
        
        [_tags removeObjectForKey:name1];
        [_tags removeObjectForKey:name2];
    }
}

@end
