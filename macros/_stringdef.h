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

/**
  *  URL到字符串
  */
#define NSStringFromURL( _url_ ) [NSString stringWithFormat:@"url = {scheme: %@, host: %@, port: %@, path: %@, relative path: %@, path components as array: %@, parameter string: %@, query: %@, fragment: %@, user: %@, password: %@}", url.scheme, url.host, url.port, url.path, url.relativePath, url.pathComponents, url.parameterString, url.query, url.fragment, url.user, url.password]

#define string_format( _format_, ... )     [NSString stringWithFormat:_format_, __VA_ARGS__]

#define string_from_charPtr( _charPtr_ )    [NSString stringWithUTF8String:_charPtr_]
#define string_from_type( _type_ )  string_from_charPtr( @encode(_type_) )
#define string_from_int32( _value_ )  [NSString stringWithFormat:@"%d",(int32_t)_value_]
#define string_from_int64( _value_ )  [NSString stringWithFormat:@"%qi", (int64_t)_value_]
#define string_from_obj( _value_ )  [NSString stringWithFormat:@"%@", (NSObject *)_value_]
#define string_from_bool( _bool_ )  [NSString stringWithFormat:@"%d", _bool_]
#define string_from_float( _float_ ) [NSString stringWithFormat:@"%f", _float_]
#define string_from_double( _double_ ) [NSString stringWithFormat:@"%f", _double_]
#define string_from_selector( _selector_ ) NSStringFromSelector(_selector_)
#define string_from_char( _char_ )  [NSString stringWithFormat:@"%c", _char_]
#define string_from_short( _short_ )    [NSString stringWithFormat:@"%hi", _short_]
#define string_from_class( _class_ )    NSStringFromClass(_class_)

#endif /* _stringdef_h */
