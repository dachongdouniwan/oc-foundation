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

#import "NSSet+Extension.h"

@implementation NSSet (Extension)

@end

#pragma mark - Computation

@implementation NSSet ( Computation )

- (NSSet *)map: (id (^)(id obj))block {
    NSMutableSet *set = [NSMutableSet setWithCapacity: [self count]];
    for(id obj in self)
        [set addObject: block(obj)];
    return set;
}

- (NSSet *)select: (BOOL (^)(id obj))block {
    NSMutableSet *set = [NSMutableSet set];
    for(id obj in self)
        if(block(obj))
            [set addObject: obj];
    return set;
}

- (id)match: (BOOL (^)(id obj))block {
    for(id obj in self)
        if(block(obj))
            return obj;
    return nil;
}

@end
