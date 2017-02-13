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

#import "_precompile.h"
#import <Foundation/Foundation.h>

#pragma mark -

@interface NSString (Wrapper)
@end

#pragma mark -

@interface NSString (Extension)

- (NSString *)trim;
- (NSString *)trimBy:(NSString *)str;
/**
 *  @desc   去掉浮点数尾部的0和.
 
 *  如：1.00 ==> 1, 0.00 ==> 0, 0.50 ==> 0.5
 */
- (NSString *)trimFloatPointNumber;

- (NSString *)unwrap;
- (NSString *)normalize;
- (NSString *)repeat:(NSUInteger)count;

- (BOOL)match:(NSString *)expression;
- (BOOL)matchAnyOf:(NSArray *)array;
- (NSString *)matchGroupAtIndex:(NSUInteger)idx forRegex:(NSString *)regex;
- (NSArray *)allMatchesForRegex:(NSString *)regex;
- (NSString *)stringByReplacingMatchesForRegex:(NSString *)regex withString:(NSString *)replacement;
- (NSString *)stringByRegex:(NSString*)pattern substitution:(NSString*)substitute;

- (BOOL)contains:(NSString *)str;
- (BOOL)contains:(NSString *)str options:(NSStringCompareOptions)option;

- (BOOL)startsWith:(NSString*)prefix;
- (BOOL)endsWith:(NSString*)suffix;

/**  Return the char value at the specified index. */
- (unichar)charAt:(int)index;
- (int)indexOfChar:(unichar)ch;
- (int)indexOfChar:(unichar)ch fromIndex:(int)index;
- (int)indexOfString:(NSString *)str;
- (int)indexOfString:(NSString *)str fromIndex:(int)index;
- (int)lastIndexOfChar:(unichar)ch;
- (int)lastIndexOfChar:(unichar)ch fromIndex:(int)index;
- (int)lastIndexOfString:(NSString *)str;
- (int)lastIndexOfString:(NSString *)str fromIndex:(int)index;

- (NSString *)toLowerCase;
- (NSString *)toUpperCase;

- (NSString *)replaceAll:(NSString *)origin with:(NSString *)replacement;
- (NSArray *)split:(NSString *)separator;

- (BOOL)empty;
- (BOOL)notEmpty;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;
- (BOOL)equalsIgnoreCase:(NSString *)anotherString;

/**
 * Compares two strings lexicographically.
 * the value 0 if the argument string is equal to this string;
 * a value less than 0 if this string is lexicographically less than the string argument;
 * and a value greater than 0 if this string is lexicographically greater than the string argument.
 */
- (int)compareTo:(NSString *)anotherString;
- (int)compareToIgnoreCase:(NSString *)str;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

/**
 *  Validator
 */

- (BOOL)isNumber;
- (BOOL)isNumberWithUnit:(NSString *)unit;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isIPAddress;
- (BOOL)isPureInt;    // 判断是否为整形
- (BOOL)isPureFloat;  // 判断是否为浮点形
- (BOOL)isMobileNumber;
- (BOOL)isContainsEmoji; // 是否包含表情

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string;
- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset;

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

- (NSString *)substringFromIndex:(int)beginIndex toIndex:(int)endIndex;

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset;

- (NSArray *)pairSeparatedByString:(NSString *)separator;

@end

#pragma mark - Formatter

@interface NSString ( Formatter )

- (NSString *)stringRepresentationForBool:(BOOL)aBool;
- (NSString *)stringRepresentationForInt:(int)anInt;
- (NSString *)stringRepresentationForFloat:(float)aFloat;
- (NSString *)stringRepresentationForDouble:(double)aDouble;
- (NSString *)stringRepresentationForSelector:(SEL)aSelector;
- (NSString *)stringRepresentationForChar:(char)aChar;
- (NSString *)stringRepresentationForShort:(short)aShort;
- (NSString *)stringRepresentationForCppBool:(bool)aCppBool;
- (NSString *)stringRepresentationForUChar:(unsigned char)aUChar;
- (NSString *)stringRepresentationForUShort:(unsigned short)aUShort;
- (NSString *)stringRepresentationForLong:(long)aLong;
- (NSString *)stringRepresentationForLongLong:(long long)aLongLong;
- (NSString *)stringRepresentationForUInt:(unsigned int)aUInt;
- (NSString *)stringRepresentationForULong:(unsigned long)aULong;
- (NSString *)stringRepresentationForULongLong:(unsigned long long)aULongLong;
- (NSString *)stringRepresentationForCharPtr:(long long)aCharPtr;
- (NSString *)stringRepresentationForObject:(id)anObject;
- (NSString *)stringRepresentationForClass:(Class)aClass;
- (NSString *)stringRepresentationForNSInteger:(NSInteger)aNSInteger;
- (NSString *)stringRepresentationForNSUInteger:(NSUInteger)aNSUInteger;
- (NSString *)stringRepresentationForCGFloat:(CGFloat)aCGFloat;
- (NSString *)stringRepresentationForPointer:(void *)aPointer;

@end

#define NSStringFromBool( _bool_ ) [NSString stringRepresentationForBool:_bool_]

#pragma mark - Pinyin

@interface NSString ( Pinyin )

- (NSString *)chinese2pinyin;

@end

#pragma mark - Encoding

@interface NSString ( Encoding )

- (NSData *)utf8EncodedData;
- (NSData *)base64DecodedData;
- (NSString *)base64Encode;
- (NSString *)base64Decode;
- (NSString *)sha256Hash;
- (NSData *)sha256HashRaw;

+ (NSData *)hashHMac:(NSString *)data key:(NSString *)key;
+ (NSString *)hashHMacToString:(NSString *)data key:(NSString *)key;

- (NSString *)MD5Hash;

@end

#pragma mark - REST

@interface NSString (REST)

// 从URL中解析出参数字典
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

// 从JSON字符串解析出参数字典
- (NSDictionary *)JSONDictionary;

// URL转义
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

// 对参数列表生成URL编码后字符串
+ (NSString *)makeQueryStringFromArgs:(NSDictionary *)args;

@end

#pragma mark - Attributed 

@interface NSString (Attributed)

- (NSAttributedString *)attributedString;

- (NSAttributedString *)withColor:(UIColor *)color;

- (NSMutableAttributedString *)withSubString:(NSString *)subString color:(UIColor *)color;

- (NSString *)stringByDeletingCharacterAtIndex:(NSUInteger)idx;

@end
