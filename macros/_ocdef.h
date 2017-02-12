//
//  _ocdef.h
//  component
//
//  Created by fallen.ink on 5/24/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//
//  oc语言级，便于使用的宏控

#ifndef _ocdef_h
#define _ocdef_h

// 调试代码块
#ifdef DEBUG

#   define LOG( s, ... ) fprintf(stderr,"%s, %d, %s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String]);
#   define debug_code( __code_fragment ) { __code_fragment }

#else

#   define LOG( s, ... )
#   define debug_code()

#endif

// 大小
#ifndef MAX3
#   define MAX3(a,b,c) ((a) > (b) ? ((a) > (c) ? (a) : (c)) : ((b) > (c) ? (b) : (c)))
#endif

#ifndef MIN3
#   define MIN3(a,b,c) ((a) < (b) ? ((a) < (c) ? (a) : (c)) : ((b) < (c) ? (b) : (c)))
#endif

// 判断某个方法是否覆写
#define is_method_overrided( _subclass_ , _class_ , _selector_ ) [_subclass_ instanceMethodForSelector:_selector_] != [_class_ instanceMethodForSelector:_selector_]

// 判断某个方法是否实现
#define is_method_implemented( _instance, _method_ ) [_instance respondsToSelector:@selector(_method_)]

// 判断某个协议是否被实现
#define is_protocol_implemented( _instance_, _protocol_ ) [_instance_ conformsToProtocol:@protocol(_protocol_)]

// compiler help
#define invalidate_timer( _timer_ ) { [_timer_ invalidate]; _timer_ = nil; }
#define verified_class( _className_ ) ((_className_ *) NSClassFromString(@"" # _className_))

// 判断任何容器是否为空
// http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html
static inline BOOL is_empty(id thing) {
    return thing == nil ||
    ([thing isEqual:[NSNull null]]) ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

#endif /* _ocdef_h */
