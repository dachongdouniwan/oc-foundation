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

// ----------------------------------
// Macros
// ----------------------------------

#pragma mark -

#undef  prop_instance
#define prop_instance( __type, __name ) \
        property (nonatomic, strong) __type * __name;

#undef  def_prop_instance
#define def_prop_instance( __type, __name ) \
        synthesize __name; \
        - (__type *)__name { \
            if (!__name) { \
                __name = [__type instance]; \
            } \
            return __name; \
        }

// ----------------------------------
// Class code
// ----------------------------------

#pragma mark - 

@interface NSObject ( Instance )

+ (instancetype)instance;


/**
 *  浅复制目标的所有属性
 *
 *  @param instance 目标对象
 *
 *  @return BOOL—YES:复制成功, NO:复制失败
 */
- (BOOL)easyShallowCopy:(NSObject *)instance;

/**
 *  深复制目标的所有属性
 *
 *  @param instance 目标对象
 *
 *  @return BOOL—YES:复制成功, NO:复制失败
 */
- (BOOL)easyDeepCopy:(NSObject *)instance;

@end
