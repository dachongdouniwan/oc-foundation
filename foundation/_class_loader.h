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

@interface NSObject ( ClassLoader )

/**
                                    +(void)load                 +(void)initialize
 执行时机                            在程序运行后立即执行            在类的方法第一次被调时执行
 若自身未定义，是否沿用父类的方法？       否                           是
 类别中的定义                         全都执行，但后于类中的方法       覆盖类中的方法，只执行一个
 */

+ (void)classAutoLoad; // Easy to be recognized!

@end

#pragma mark -

@interface _ClassLoader : NSObject

+ (instancetype)classLoader;

- (void)loadClasses:(NSArray *)classNames;

@end
