//
//     ____              _____    _____    _____
//    / ___\   /\ /\     \_   \   \_  _\  /\  __\
//    \ \     / / \ \     / /\/    / /    \ \  _\_
//  /\_\ \    \ \_/ /  /\/ /_     / /      \ \____\
//  \____/     \___/   \____/     \_|       \/____/
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

#pragma mark -

#undef  base_class
#define base_class( __class ) \
+ (Class)baseClass \
{ \
return NSClassFromString( @(#__class) ); \
}

#undef	convert_class
#define	convert_class( __name, __class ) \
+ (Class)convertClass_##__name \
{ \
return NSClassFromString( @(#__class) ); \
}

#pragma mark -

@interface NSObject ( Extension )

+ (Class)baseClass;

+ (id)unserializeForUnknownValue:(id)value;
+ (id)serializeForUnknownValue:(id)value;

- (void)deepEqualsTo:(id)obj;
- (void)deepCopyFrom:(id)obj;

+ (id)unserialize:(id)obj;
+ (id)unserialize:(id)obj withClass:(Class)clazz;

- (id)JSONEncoded;
- (id)JSONDecoded;

- (BOOL)toBool;
- (float)toFloat;
- (double)toDouble;
- (NSInteger)toInteger;
- (NSUInteger)toUnsignedInteger;

- (NSURL *)toURL;
- (NSDate *)toDate;
- (NSData *)toData;
- (NSNumber *)toNumber;
- (NSString *)toString;

- (id)clone;					// override point
- (id)serialize;				// override point
- (void)unserialize:(id)obj;	// override point
- (void)zerolize;				// override point

+ (BOOL)isNullValue:(id)value;

#pragma mark - perform

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait;

- (void)performSelector:(SEL)aSelector withObjects:(NSArray *)arguments afterDelay:(NSTimeInterval)delay;

@end
