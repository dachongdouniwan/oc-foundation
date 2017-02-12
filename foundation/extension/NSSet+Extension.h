//
//  NSSet+Extension.h
//  consumer
//
//  Created by fallen.ink on 18/10/2016.
//
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

