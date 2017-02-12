//
//  _configdef.h
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

//  这里作为关键词，均使用大写
//

// ----------------------------------
// System Version
// ----------------------------------

// __IPHONE_8_0

// ----------------------------------
// Version
// ----------------------------------

#undef  __VERSION__
#define __VERSION__         ("0.1.0")

#define __MUST_ON__         (1)
#define __MUST_OFF__        (0)

#define __ON__              (1)
#define __OFF__             (0)
#define __AUTO__            (DEBUG)

// ----------------------------------
// Debug predefine
// ----------------------------------

#define __DEBUG__       (__ON__)   /// 調試模式
#define __TESTING__     (__OFF__)   /// 單元測試
#define __LOGGING__     (__ON__)    /// 日誌模式
#define __SERVICE__     (__ON__)    /// 後臺服務

// ----------------------------------
// Common use macros
// ----------------------------------

#ifndef	IN
#define IN
#endif

#ifndef	OUT
#define OUT
#endif

#ifndef	INOUT
#define INOUT
#endif

/**
 *  also can use #pragma unused ( __x )
 */
#ifndef	UNUSED
#define	UNUSED( __x )		{ id __unused_var__ __attribute__((unused)) = (id)(__x); }
#endif

#ifndef	ALIAS
#define	ALIAS( __a, __b )	__typeof__(__a) __b = __a;
#endif

#ifndef	DEPRECATED
#define	DEPRECATED			__attribute__((deprecated))
#endif

#ifndef deprecatedify
#define deprecatedify( _info_ ) __attribute((deprecated(_info_)))
#endif

#undef  EXTERN
#define EXTERN    extern __attribute__((visibility ("default")))

#ifndef	TODO
#define TODO( X )			_Pragma(macro_cstr(message("TODO: " X)))
#endif

#ifndef	EXTERN_C

#if defined(__cplusplus)
#   define EXTERN_C			extern "C"
#else
#   define EXTERN_C			extern
#endif

#endif

#ifndef	INLINE
#define	INLINE				__inline__ __attribute__((always_inline))
#endif

// ----------------------------------
// nullability macro
// ----------------------------------

#if !__has_feature(nullability)
#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define nullable
#define nonnull
#define null_unspecified
#define null_resettable
#define __nullable
#define __nonnull
#define __null_unspecified
#endif

// ----------------------------------
// Meta macro
// ----------------------------------

#define macro_first(...)									macro_first_( __VA_ARGS__, 0 )
#define macro_first_( A, ... )								A

#define macro_concat( A, B )								macro_concat_( A, B )
#define macro_concat_( A, B )								A##B

#define macro_count(...)									macro_at( 8, __VA_ARGS__, 8, 7, 6, 5, 4, 3, 2, 1 )
#define macro_more(...)										macro_at( 8, __VA_ARGS__, 1, 1, 1, 1, 1, 1, 1, 1 )

#define macro_at0(...)										macro_first(__VA_ARGS__)
#define macro_at1(_0, ...)									macro_first(__VA_ARGS__)
#define macro_at2(_0, _1, ...)								macro_first(__VA_ARGS__)
#define macro_at3(_0, _1, _2, ...)							macro_first(__VA_ARGS__)
#define macro_at4(_0, _1, _2, _3, ...)						macro_first(__VA_ARGS__)
#define macro_at5(_0, _1, _2, _3, _4 ...)					macro_first(__VA_ARGS__)
#define macro_at6(_0, _1, _2, _3, _4, _5 ...)				macro_first(__VA_ARGS__)
#define macro_at7(_0, _1, _2, _3, _4, _5, _6 ...)			macro_first(__VA_ARGS__)
#define macro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...)		macro_first(__VA_ARGS__)
#define macro_at(N, ...)									macro_concat(macro_at, N)( __VA_ARGS__ )

#define macro_join0( ... )
#define macro_join1( A )									A
#define macro_join2( A, B )									A##____##B
#define macro_join3( A, B, C )								A##____##B##____##C
#define macro_join4( A, B, C, D )							A##____##B##____##C##____##D
#define macro_join5( A, B, C, D, E )						A##____##B##____##C##____##D##____##E
#define macro_join6( A, B, C, D, E, F )						A##____##B##____##C##____##D##____##E##____##F
#define macro_join7( A, B, C, D, E, F, G )					A##____##B##____##C##____##D##____##E##____##F##____##G
#define macro_join8( A, B, C, D, E, F, G, H )				A##____##B##____##C##____##D##____##E##____##F##____##G##____##H
#define macro_join( ... )									macro_concat(macro_join, macro_count(__VA_ARGS__))(__VA_ARGS__)

#define macro_cstr( A )										macro_cstr_( A )
#define macro_cstr_( A )									#A

#define macro_string( A )									macro_string_( A )
#define macro_string_( A )									@(#A)



#if __has_feature(objc_generics)

#   ifndef __GENERICS
#   define __GENERICS(class, ...)      class<__VA_ARGS__>
#   endif

#   ifndef __GENERICS_TYPE
#   define __GENERICS_TYPE(type)       type
#   endif

#else
#   ifndef __GENERICS
#   define __GENERICS(class, ...)      class
#   endif

#   ifndef __GENERICS_TYPE
#   define __GENERICS_TYPE(type)       id
#   endif

#endif

