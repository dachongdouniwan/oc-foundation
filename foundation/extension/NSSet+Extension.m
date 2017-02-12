//
//  NSSet+Extension.m
//  consumer
//
//  Created by fallen.ink on 18/10/2016.
//
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
