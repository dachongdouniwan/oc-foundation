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

#import "_namespace.h"

// ----------------------------------
// MARK: Extern
// ----------------------------------

__strong _Namespace * greats = nil;

// ----------------------------------
// MARK: Source - _Namespace
// ----------------------------------

@implementation _Namespace

+ (void)load {
    greats = [[_Namespace alloc] init];
}

@end
