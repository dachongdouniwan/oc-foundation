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

#pragma mark - NSObject ( SafeValueWithJSON )

@interface NSObject ( SafeValueWithJSON )

- (id)safeValueFromJSON;

- (id)safeObjectWithClass:(Class)aClass;

- (NSString *)safeString;

- (NSNumber *)safeNumber;

- (NSArray *)safeArray;

- (NSDictionary *)safeDictionary;

- (NSDate *)safeDate;

@end

#pragma mark - NSArray

@interface NSArray ( SafeValue )

- (id)safeObjectAtIndex:(NSUInteger)index;
- (id)safeSubarrayWithRange:(NSRange)range;
- (id)safeSubarrayFromIndex:(NSUInteger)index;
- (id)safeSubarrayWithCount:(NSUInteger)count;

- (NSString *)safeStringAtIndex:(NSUInteger)index;
- (NSNumber *)safeNumberAtIndex:(NSUInteger)index;
- (NSArray *)safeArrayAtIndex:(NSUInteger)index;
- (NSDictionary *)safeDictionaryAtIndex:(NSUInteger)index;

@end

@interface NSArray ( SafeInvoke )

- (id)objectAtIndexIfIndexInBounds:(NSUInteger)index;

@end

#pragma mark - NSDictionary ( SafeValue )

@interface NSDictionary ( SafeValue )
/**
 @brief   取一个安全的NSString对象
 @return  akey对应的实例不是NSString则返回nil
 */
- (NSString *)safeStringForKey:(id)aKey;

/**
 @brief   取一个安全的NSNumber对象
 @return  akey对应的实例不是NSNumber则返回nil
 */
- (NSNumber *)safeNumberForKey:(id)aKey;

/**
 @brief   取一个安全的NSArray对象
 @return  akey对应的实例不是NSArray则返回nil
 */
- (NSArray *)safeArrayForKey:(id)aKey;

/**
 @brief   取一个安全的NSDictionary对象
 @return  akey对应的实例不是NSDictionary则返回nil
 */
- (NSDictionary *)safeDictionaryForKey:(id)aKey;

@end
