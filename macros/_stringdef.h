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

#ifndef _stringdef_h
#define _stringdef_h

/**
 *  字符串是否为空
 */
#define is_string_empty( _str_ )    is_empty( _str_ )

/**
 *  字符串是否可显示
 */
#define is_string_present( _str_ )  !is_string_empty(_str_)

#define string_from_int( _value_ )  [ NSString stringWithFormat:@"%d",(int32_t)_value_]

#define	string_format( _format_, ... )     [NSString stringWithFormat:_format_, __VA_ARGS__]

#define string_from_obj( _value_ )  [ NSString stringWithFormat:@"%@", (NSObject *)_value_]

// 构建 NSString
#define str_of_charPtr( __charPtr ) [NSString stringWithUTF8String:__charPtr]
#define str_of_type( __type )       str_of_charPtr( @encode(__type) )

#endif /* _stringdef_h */
