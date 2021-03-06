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

@interface NSObject ( Extension )

+ (Class)baseClass;

+ (id)unserializeForUnknownValue:(id)value;
+ (id)serializeForUnknownValue:(id)value;

- (void)deepEqualsTo:(id)obj;
- (void)deepCopyFrom:(id)obj;

- (id)clone;					// override point

+ (BOOL)isNullValue:(id)value;

@end
