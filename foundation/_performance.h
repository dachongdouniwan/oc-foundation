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

#import <Foundation/Foundation.h>
#import "_singleton.h"

#pragma mark -

#if __DEBUG__

#define	PERF_TIME( block )			{ _PERF_ENTER(__PRETTY_FUNCTION__, __LINE__); block; _PERF_LEAVE(__PRETTY_FUNCTION__, __LINE__); }
#define	_PERF_ENTER( func, line )	[[_Performance sharedInstance] enter:[NSString stringWithFormat:@"%s#%d", func, line]];
#define	_PERF_LEAVE( func, line )	[[_Performance sharedInstance] leave:[NSString stringWithFormat:@"%s#%d", func, line]];

#else

#define	PERF_TIME( block )				{ block }

#endif

#pragma mark -

@interface _Performance : NSObject

@singleton( _Performance );

- (void)enter:(NSString *)tag;
- (void)leave:(NSString *)tag;

@end
