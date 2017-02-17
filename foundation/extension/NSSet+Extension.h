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

@interface NSSet (Extension)

@end

#pragma mark - Computation

@interface NSSet ( Computation )

/**
 *  映射
 */
- (NSSet *)map: (id (^)(id obj))block;

/**
 *  筛选
 */
- (NSSet *)select: (BOOL (^)(id obj))block;

/**
 *  匹配
 */
- (id)match: (BOOL (^)(id obj))block;

@end

