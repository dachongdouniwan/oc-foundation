//
//  NSIndexPath+Util.h
//  component
//
//  Created by fallen.ink on 4/14/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (Util)

+ (NSArray *)indexPathsInSection:(NSUInteger)section inRange:(NSRange)range;
+ (NSArray *)indexPathsInSection:(NSUInteger)section withIndexes:(NSIndexSet *)indexes;
+ (NSArray *)indexPathsForArrayToAppend:(NSUInteger)appendCount to:(NSUInteger)currentCount;

@end


@interface NSMoveIndexPath : NSObject

@property (nonatomic, readonly) NSIndexPath *from;
@property (nonatomic, readonly) NSIndexPath *to;
+ (instancetype)moveFrom:(NSIndexPath *)initial to:(NSIndexPath *)final;
+ (NSArray *)movesWithInitialIndexPaths:(NSArray *)initial andFinalIndexPaths:(NSArray *)final;

@end
