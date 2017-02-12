//
//  NSIndexSet+Util.h
//  component
//
//  Created by fallen.ink on 4/14/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

// inspired by https://github.com/ThePantsThief/Objc-Foundation-Extensions/blob/master/Pod/Classes/NSIndexSet%2BUtil.m

@interface NSIndexSet (Util)

+ (instancetype)indexSetByInvertingRange:(NSRange)range withLength:(NSUInteger)length;
+ (instancetype)indexSetWithoutIndexes:(NSIndexSet *)indexes inRange:(NSRange)range;
+ (instancetype)indexPathsInFirstSectionInCollection:(NSArray<NSIndexPath*> *)collection;

@end
