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

#import "_def.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -

typedef NSMutableArray * _Nullable 	(^NSArrayElementBlock)(_Nullable id obj );
typedef NSComparisonResult	(^NSArrayCompareBlock)( id left, id right );

#pragma mark -

@interface NSArray(Extension)

- (NSMutableArray *)head:(NSUInteger)count;
- (NSMutableArray *)tail:(NSUInteger)count;

- (NSString *)join;
- (NSString *)join:(NSString *)delimiter;

/**
 *  辅助方法
 */

// 鉴于containsObject:是比较对象：调用isEqual:，该方法比较的是hash值，所以添加如下方法
- (BOOL)containsString:(NSString *)aString;

- (NSArray *)filteredArrayWhereProperty:(NSString *)property equals:(id)value;

@end

#pragma mark - Computation

@interface __GENERICS(NSArray, ObjectType) ( Computation )

/**
 *  遍历
 */
- (void)each:(void (^)(id obj))block;

/**
 *  映射
 */
- (NSArray *)map: (id (^)(id obj))block;

/**
 *  筛选
 */
- (NSArray *)select: (BOOL (^)(id obj))block;

/**
 *  匹配
 */
- (id)match: (BOOL (^)(id obj))block;

/**
 *  化简
 *
 *  @param initial 初始值
 *  @param block handler of client's operation
 *
 *  @return result
 */
- (id)reduce:(id)initial withBlock:(id (^)(id sum, ObjectType obj))block;

@end

// inspired by https://github.com/nbasham/iOS-Collection-Utilities/blob/master/Classes/NSArray%2BPrimitive.h

/**
 *  Usage
 
 NSMutableArray* array = [NSMutableArray array];
 [array addInt:1]; // array = [1]
 [array addInt:2]; // array = [1, 2]
 int i = [array intAtIndex:0]; // i = 1
 [array swapIndex1:0 index2:1]; // array = [2, 1]
 [array replaceIntAtIndex:0 withInt:3];  // array = [3, 1]
 [array insertInt:4 atIndex:1];
 NSLog(@"%@", [array description]); // console shows [3, 4, 1]
 
 */

@interface NSArray ( Primitive )

- (BOOL)boolAtIndex:(NSUInteger)index;
- (char)charAtIndex:(NSUInteger)index;
- (int)intAtIndex:(NSUInteger)index;
- (float)floatAtIndex:(NSUInteger)index;
- (NSString*)intArrayToString;
- (NSValue*)valueAtIndex:(NSUInteger)index;
- (CGPoint)pointAtIndex:(NSUInteger)index;
- (CGSize)sizeAtIndex:(NSUInteger)index;
- (CGRect)rectAtIndex:(NSUInteger)index;
- (NSInteger)integerAtIndex:(NSUInteger)index;
- (NSUInteger)unsignedIntegerAtIndex:(NSUInteger)index;
- (CGFloat)cgFloatAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray ( Primitive )

- (void)swapIndex1:(NSUInteger)index1 index2:(NSUInteger)index2;

- (void)addBool:(BOOL)b;
- (void)insertBool:(BOOL)b atIndex:(NSUInteger)index;
- (void)replaceBoolAtIndex:(NSUInteger)index withBool:(BOOL)b;

- (void)addChar:(char)c;
- (void)insertChar:(char)c atIndex:(NSUInteger)index;
- (void)replaceCharAtIndex:(NSUInteger)index withChar:(char)c;

- (void)addInt:(int)i;
- (void)insertInt:(int)i atIndex:(NSUInteger)index;
- (void)replaceIntAtIndex:(NSUInteger)index withInt:(int)i;

- (void)addInteger:(NSInteger)i;
- (void)insertInteger:(NSInteger)i atIndex:(NSUInteger)index;
- (void)replaceIntegerAtIndex:(NSUInteger)index withInteger:(NSInteger)i;

- (void)addUnsignedInteger:(NSInteger)i;
- (void)insertUnsignedInteger:(NSInteger)i atIndex:(NSUInteger)index;
- (void)replaceUnsignedIntegerAtIndex:(NSUInteger)index withUnsignedInteger:(NSInteger)i;

- (void)addCGFloat:(CGFloat)f;
- (void)insertCGFloat:(CGFloat)f atIndex:(NSUInteger)index;
- (void)replaceCGFloatAtIndex:(NSUInteger)index withCGFloat:(CGFloat)f;

- (void)addFloat:(float)f;
- (void)insertFloat:(float)f atIndex:(NSUInteger)index;
- (void)replaceFloatAtIndex:(NSUInteger)index withFloat:(float)f;

- (void)addValue:(NSValue*)o;
- (void)insertValue:(NSValue*)o atIndex:(NSUInteger)index;
- (void)replaceValueAtIndex:(NSUInteger)index withValue:(NSValue*)o;

- (void)addPoint:(CGPoint)o;
- (void)insertPoint:(CGPoint)o atIndex:(NSUInteger)index;
- (void)replacePointAtIndex:(NSUInteger)index withPoint:(CGPoint)o;

- (void)addSize:(CGSize)o;
- (void)insertSize:(CGSize)o atIndex:(NSUInteger)index;
- (void)replaceSizeAtIndex:(NSUInteger)index withSize:(CGSize)o;

- (void)addRect:(CGRect)o;
- (void)insertRect:(CGRect)o atIndex:(NSUInteger)index;
- (void)replaceRectAtIndex:(NSUInteger)index withRect:(CGRect)o;

@end

NS_ASSUME_NONNULL_END
