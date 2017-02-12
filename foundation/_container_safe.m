//
//  _container_safe.m
//  component
//
//  Created by fallen.ink on 4/11/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_container_safe.h"

#pragma mark - NSObject (SafeValueWithJSON)

@implementation NSObject (SafeValueWithJSON)

- (id)safeValueFromJSON {
    return self == [NSNull null] ? nil : self;
}

- (id)safeObjectWithClass:(Class)aClass {
    if ([self isKindOfClass:aClass]) {
        return self;
    } else {
        //        NSAssert(NO,
        //                 @"Object class not matched, self is %@, should be %@",
        //                 NSStringFromClass([self class]),
        //                 NSStringFromClass(aClass));
        return nil;
    }
}

- (NSString *)safeString {
    return [self safeObjectWithClass:[NSString class]];
}

- (NSNumber *)safeNumber {
    return [self safeObjectWithClass:[NSNumber class]];
}

- (NSArray *)safeArray {
    return [self safeObjectWithClass:[NSArray class]];
}

- (NSDictionary *)safeDictionary {
    return [self safeObjectWithClass:[NSDictionary class]];
}

- (NSDate *)safeDate {
    return [self safeObjectWithClass:[NSDate class]];
}

@end

#pragma mark - NSArray

@implementation NSArray (SafeValue)

- (NSString *)safeStringAtIndex:(NSUInteger)index {
    return [[self objectAtIndexIfIndexInBounds:index] safeString];
}

- (NSNumber *)safeNumberAtIndex:(NSUInteger)index {
    return [[self objectAtIndexIfIndexInBounds:index] safeNumber];

}

- (NSArray *)safeArrayAtIndex:(NSUInteger)index {
    return [[self objectAtIndexIfIndexInBounds:index] safeArray];
}

- (NSDictionary *)safeDictionaryAtIndex:(NSUInteger)index {
    return [[self objectAtIndexIfIndexInBounds:index] safeDictionary];
}

#pragma mark -

- (id)safeObjectAtIndex:(NSUInteger)index {
    if ( index >= self.count )
        return nil;
    
    return [self objectAtIndex:index];
}

- (id)safeSubarrayWithRange:(NSRange)range {
    if ( 0 == self.count )
        return [NSArray array];
    
    if ( range.location >= self.count )
        return [NSArray array];
    
    range.length = MIN( range.length, self.count - range.location );
    if ( 0 == range.length )
        return [NSArray array];
    
    return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (id)safeSubarrayFromIndex:(NSUInteger)index {
    if ( 0 == self.count )
        return [NSArray array];
    
    if ( index >= self.count )
        return [NSArray array];
    
    return [self safeSubarrayWithRange:NSMakeRange(index, self.count - index)];
}

- (id)safeSubarrayWithCount:(NSUInteger)count {
    if ( 0 == self.count )
        return [NSArray array];
    
    return [self safeSubarrayWithRange:NSMakeRange(0, count)];
}

@end

@implementation NSArray (SafeInvoke)

- (id)objectAtIndexIfIndexInBounds:(NSUInteger)index {
    if (index < [self count]) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end

#pragma mark - NSDictionary (SafeValue)

@implementation NSDictionary (SafeValue)

- (NSString *)safeStringForKey:(id)aKey {
    return [[self objectForKey:aKey] safeString];
}

- (NSNumber *)safeNumberForKey:(id)aKey {
    return [[self objectForKey:aKey] safeNumber];
}

- (NSArray *)safeArrayForKey:(id)aKey {
    return [[self objectForKey:aKey] safeArray];
}

- (NSDictionary *)safeDictionaryForKey:(id)aKey {
    return [[self objectForKey:aKey] safeDictionary];
}

@end
