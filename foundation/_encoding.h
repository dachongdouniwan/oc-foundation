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

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */

#pragma mark -

typedef enum {
    EncodingType_Unknown = 0,
    EncodingType_Null,
    EncodingType_Number,
    EncodingType_String,
    EncodingType_Date,
    EncodingType_Data,
    EncodingType_Url,
    EncodingType_Array,
    EncodingType_Dict
} EncodingType;

#pragma mark -

/**
 *  「武士」·「类型編碼器」
 */

@interface _Encoding : NSObject

/**
 *  判斷對象屬性是否為只讀？
 *
 *  @param attr 屬性名稱
 *
 *  @return YES或NO
 */

+ (BOOL)isReadOnly:(const char *)attr;

+ (EncodingType)typeOfAttribute:(const char *)attr;
+ (EncodingType)typeOfClassName:(const char *)clazz;
+ (EncodingType)typeOfClass:(Class)clazz;
+ (EncodingType)typeOfObject:(id)obj;

+ (NSString *)classNameOfAttribute:(const char *)attr;
+ (NSString *)classNameOfClass:(Class)clazz;
+ (NSString *)classNameOfObject:(id)obj;

+ (Class)classOfAttribute:(const char *)attr;

+ (BOOL)isAtomAttribute:(const char *)attr;
+ (BOOL)isAtomClassName:(const char *)clazz;
+ (BOOL)isAtomClass:(Class)clazz;
+ (BOOL)isAtomObject:(id)obj;

@end

