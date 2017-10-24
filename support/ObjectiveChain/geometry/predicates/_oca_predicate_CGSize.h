//
//  OCAPredicate+CGSize.h
//  Objective-Chain
//
//  Created by Martin Kiss on 28.1.14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import <CoreGraphics/CGGeometry.h>
#import "_oca_predicate.h"





@interface OCAPredicate (CGSize)



+ (NSPredicate *)predicateForSize:(BOOL(^)(CGSize size))block;

+ (NSPredicate *)isSizeEqualTo:(CGSize)otherSize;
+ (NSPredicate *)isSizeZero;



@end


