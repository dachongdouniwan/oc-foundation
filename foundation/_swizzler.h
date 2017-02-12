// JRSwizzle.h semver:1.0
//   Copyright (c) 2007-2011 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/MIT
//   https://github.com/rentzsch/jrswizzle

#import <Foundation/Foundation.h>

@interface NSObject ( Swizzle )

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;
+ (BOOL)swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_;

// add by fallenink
+ (BOOL)copyMethod:(SEL)origSel_  toMethod:(SEL)dstSel_ error:(NSError **)error_;
+ (BOOL)copyClassMethod:(SEL)origSel_  toClassMethod:(SEL)dstSel_ error:(NSError **)error_;

@end
