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

// NSObject has +instance method
// 实例属性，而非类方法
#undef  prop_instance
#define prop_instance( __type, __name ) \
property (nonatomic, strong) __type * __name;

#undef  def_prop_instance
#define def_prop_instance( __type, __name ) \
synthesize __name; \
- (__type *)__name { \
/* _##__name */if (!__name) { \
__name = [__type instance]; \
} \
\
return __name; \
}

#pragma mark - 

@interface NSObject (Instance)

+ (instancetype)instance;

@end
