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

#import "foundation/_foundation.h"

#pragma mark -

@protocol NSDictionaryProtocol <NSObject>
@required
- (id)objectForKey:(id)key;
- (BOOL)hasObjectForKey:(id)key;
@optional
- (id)objectForKeyedSubscript:(id)key;
@end

#pragma mark -

@interface NSDictionary (Extension) <NSDictionaryProtocol>

- (id)objectForOneOfKeys:(NSArray *)array;

- (id)objectAtPath:(NSString *)path;

- (id)objectAtPath:(NSString *)path separator:(NSString *)separator;
- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other separator:(NSString *)separator;

- (BOOL)boolAtPath:(NSString *)path;
- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other;

- (NSNumber *)numberAtPath:(NSString *)path;
- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other;

- (NSString *)stringAtPath:(NSString *)path;
- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other;

- (NSArray *)arrayAtPath:(NSString *)path;
- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other;

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path;
- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other;

- (NSDictionary *)dictAtPath:(NSString *)path;
- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other;

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path;
- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other;

@end

#pragma mark - 

/**
 *  Usage
 
 NSDictionary+Primitive
 
 NSDictionary+Primitive extends NSDictionary and NSMutableDictionary to provide support for primitives BOOL, char, int, float, CGPoint, CGSize, CGRect, NSInteger, NSUInteger, and CGFloat. The following example demonstrates int but all the other types work the same way.
 
 NSMutableDictionary* dict = [NSMutableDictionary dictionary];
 [dict setInt:1 forKey:@"int1"]; // dict = { int1:1 }
 [dict setInt:2 forKey:@"int2"]; // dict = { int1:1, int2:2 }
 int i = [dict intForKey:@"int1"]; // i = 1
 NSLog(@"%@", [dict description]); // console shows { int1 = 1; int2 = 2; }
 
 */

@interface NSDictionary ( Primitive )

- (BOOL)hasKey:(NSString *)key;

- (BOOL)boolForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;
- (CGFloat)cgFloatForKey:(NSString *)key;
- (int)charForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (CGPoint)pointForKey:(NSString *)key;
- (CGSize)sizeForKey:(NSString *)key;
- (CGRect)rectForKey:(NSString *)key;

@end

@interface NSMutableDictionary ( Primitive )

- (void)setBool:(BOOL)i forKey:(NSString *)key;
- (void)setInt:(int)i forKey:(NSString *)key;
- (void)setInteger:(NSInteger)i forKey:(NSString *)key;
- (void)setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key;
- (void)setCGFloat:(CGFloat)f forKey:(NSString *)key;
- (void)setChar:(char)c forKey:(NSString *)key;
- (void)setFloat:(float)i forKey:(NSString *)key;
- (void)setPoint:(CGPoint)o forKey:(NSString *)key;
- (void)setSize:(CGSize)o forKey:(NSString *)key;
- (void)setRect:(CGRect)o forKey:(NSString *)key;

@end
