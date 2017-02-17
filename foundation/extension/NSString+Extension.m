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

#import "NSString+Extension.h"
#import "NSObject+Extension.h"
#import "regex.h"
#import "NSData+Extension.h"
#import <CommonCrypto/CommonHMAC.h>

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

/*
 * Replaces all occurences and stores it in buf
 */
int rreplace (char *buf, int size, regex_t *re, char *rp) {
    char *pos;
    long long sub, so, n;
    regmatch_t pmatch [10]; /* regoff_t is int so size is int */
    
    if (regexec (re, buf, 10, pmatch, 0)) return 0;
    for (pos = rp; *pos; pos++) {
        if (*pos == '\\' && *(pos + 1) > '0' && *(pos + 1) <= '9') {
            so = pmatch [*(pos + 1) - 48].rm_so;
            n = pmatch [*(pos + 1) - 48].rm_eo - so;
            if (so < 0 || strlen (rp) + n - 1 > size) return 1;
            memmove (pos + n, pos + 2, strlen (pos) - 1);
            memmove (pos, buf + so, n);
            pos = pos + n - 2;
        }
    }
    
    sub = pmatch [1].rm_so; /* no repeated replace when sub >= 0 */
    for (pos = buf; !regexec (re, pos, 1, pmatch, 0); ) {
        n = pmatch [0].rm_eo - pmatch [0].rm_so;
        pos += pmatch [0].rm_so;
        if (strlen (buf) - n + strlen (rp) + 1 > size) return 1;
        memmove (pos + strlen (rp), pos + n, strlen (pos) - n + 1);
        memmove (pos, rp, strlen (rp));
        pos += strlen (rp);
        if (sub >= 0) break;
    }
    
    return 0;
}

@implementation NSString (Extension)

- (NSString *)trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap {
	if ( self.length >= 2 ) {
		if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] ) {
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}

		if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] ) {
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}
	}

	return self;
}

- (NSString *)normalize {
	NSArray * lines = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	if ( lines && lines.count ) {
		NSMutableString * mergedString = [NSMutableString string];
		
		for ( NSString * line in lines ) {
			NSString * trimed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			if ( trimed && trimed.length ) {
				[mergedString appendString:trimed];
			}
		}
		
		return mergedString;
	}

	return nil;
}

- (NSString *)repeat:(NSUInteger)count {
	if ( 0 == count )
		return @"";

	NSMutableString * text = [NSMutableString string];
	
	for ( NSUInteger i = 0; i < count; ++i ) {
		[text appendString:self];
	}
	
	return text;
}

- (NSString *)strongify {
	return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)match:(NSString *)expression {
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
																			options:NSRegularExpressionCaseInsensitive
																			  error:nil];
	if ( nil == regex )
		return NO;
	
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
														options:0
														  range:NSMakeRange(0, self.length)];
	if ( 0 == numberOfMatches )
		return NO;
	
	return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array {
	for ( NSString * str in array ) {
		if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] ) {
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)empty {
	return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty {
	return [self length] > 0 ? YES : NO;
}

- (BOOL)is:(NSString *)other {
	return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other {
	return NO == [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array {
	return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens {
	NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
	
	for ( NSObject * obj in array ) {
		if ( NO == [obj isKindOfClass:[NSString class]] )
			continue;
		
		if ( NSOrderedSame == [(NSString *)obj compare:self options:option] )
			return YES;
	}
	
	return NO;
}

- (BOOL)isNumber {
	NSString *		regex = @"-?[0-9.]+";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isNumberWithUnit:(NSString *)unit {
	NSString *		regex = [NSString stringWithFormat:@"-?[0-9.]+%@", unit];
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

- (BOOL)isEmail {
	NSString *		regex = @"[A-Z0-9a-z._\%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

	return [pred evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isUrl {
	return ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) ? YES : NO;
}

- (BOOL)isIPAddress {
	NSArray *			components = [self componentsSeparatedByString:@"."];
	NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];

	if ( [components count] == 4 ) {
		NSString *part1 = [components objectAtIndex:0];
		NSString *part2 = [components objectAtIndex:1];
		NSString *part3 = [components objectAtIndex:2];
		NSString *part4 = [components objectAtIndex:3];
		
		if ( 0 == [part1 length] ||
			0 == [part2 length] ||
			0 == [part3 length] ||
			0 == [part4 length] ) {
			return NO;
		}
		
		if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			[part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			[part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
			[part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound ) {
			if ( [part1 intValue] <= 255 &&
				[part2 intValue] <= 255 &&
				[part3 intValue] <= 255 &&
				[part4 intValue] <= 255 ) {
				return YES;
			}
		}
	}
	
	return NO;
}

- (BOOL)isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isMobileNumber {
    //手机号以13， 15，18,17开头，八个 \d 数字字符
    NSString *regEx = @"^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$";
    NSPredicate* checkMobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regEx];
    
    return [checkMobilePredicate evaluateWithObject:self] && (self.length >= 11);
}

- (BOOL)isContainsEmoji {
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    
    return isEomji;
}

//added end
- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string {
	return [self substringFromIndex:from untilString:string endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string endOffset:(NSUInteger *)endOffset {
	if ( 0 == self.length )
		return nil;
	
	if ( from >= self.length )
		return nil;
	
	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfString:string options:NSCaseInsensitiveSearch range:range];
	
	if ( NSNotFound == range2.location ) {
		if ( endOffset ) {
			*endOffset = range.location + range.length;
		}
		
		return [self substringWithRange:range];
	} else {
		if ( endOffset ) {
			*endOffset = range2.location + range2.length;
		}
		
		return [self substringWithRange:NSMakeRange(from, range2.location - from)];
	}
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset {
	return [self substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
	if ( 0 == self.length )
		return nil;
	
	if ( from >= self.length )
		return nil;

	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];

	if ( NSNotFound == range2.location )
	{
		if ( endOffset )
		{
			*endOffset = range.location + range.length;
		}
		
		return [self substringWithRange:range];
	}
	else
	{
		if ( endOffset )
		{
			*endOffset = range2.location + range2.length;
		}

		return [self substringWithRange:NSMakeRange(from, range2.location - from)];
	}
}

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset
{
	if ( 0 == self.length )
		return 0;
	
	if ( from >= self.length )
		return 0;
	
	NSCharacterSet * reversedCharset = [charset invertedSet];

	NSRange range = NSMakeRange( from, self.length - from );
	NSRange range2 = [self rangeOfCharacterFromSet:reversedCharset options:NSCaseInsensitiveSearch range:range];

	if ( NSNotFound == range2.location )
	{
		return self.length - from;
	}
	else
	{
		return range2.location - from;		
	}
}

- (NSArray *)pairSeparatedByString:(NSString *)separator
{
	if ( nil == separator )
		return nil;
	
	NSUInteger	offset = 0;
	NSString *	key = [self substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:separator] endOffset:&offset];
	NSString *	val = nil;

	if ( nil == key || offset >= self.length )
		return nil;
	
	val = [self substringFromIndex:offset];
	if ( nil == val )
		return nil;

	return [NSArray arrayWithObjects:key, val, nil];
}

#define NotFoundEx -1

/**  Java-like method. Returns the char value at the specified index. */
- (unichar) charAt:(int)index {
    return [self characterAtIndex:index];
}

/**
 * Java-like method. Compares two strings lexicographically.
 * the value 0 if the argument string is equal to this string;
 * a value less than 0 if this string is lexicographically less than the string argument;
 * and a value greater than 0 if this string is lexicographically greater than the string argument.
 */
- (int) compareTo:(NSString*) anotherString {
    return [self compare:anotherString];
}

/** Java-like method. Compares two strings lexicographically, ignoring case differences. */
- (int) compareToIgnoreCase:(NSString*) str {
    return [self compare:str options:NSCaseInsensitiveSearch];
}

/** Java-like method. Returns true if and only if this string contains the specified sequence of char values. */
- (BOOL) contains:(NSString*) str {
    NSRange range = [self rangeOfString:str];
    return (range.location != NSNotFound);
}

- (BOOL) contains:(NSString*) str options:(NSStringCompareOptions)option {
    NSRange range = [self rangeOfString:str options:option];
    return (range.location != NSNotFound);
}

- (BOOL) startsWith:(NSString*)prefix {
    return [self hasPrefix:prefix];
}

- (BOOL) endsWith:(NSString*)suffix {
    return [self hasSuffix:suffix];
}

- (BOOL)equalsIgnoreCase:(NSString *)anotherString {
    return [[self toLowerCase] is:[anotherString toLowerCase]];
}

- (int)indexOfChar:(unichar)ch {
    return [self indexOfChar:ch fromIndex:0];
}

- (int)indexOfChar:(unichar)ch fromIndex:(int)index {
    int len = (int)self.length;
    for (int i = index; i < len; ++i) {
        if (ch == [self charAt:i]) {
            return i;
        }
    }
    return NotFoundEx;
}

- (int)indexOfString:(NSString*)str {
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound) {
        return NotFoundEx;
    }
    return (int)range.location;
}

- (int) indexOfString:(NSString*)str fromIndex:(int)index {
    NSRange fromRange = NSMakeRange(index, self.length - index);
    NSRange range = [self rangeOfString:str options:NSLiteralSearch range:fromRange];
    if (range.location == NSNotFound) {
        return NotFoundEx;
    }
    return (int)range.location;
}

- (int) lastIndexOfChar:(unichar)ch {
    int len = (int)self.length;
    for (int i = len-1; i >=0; --i) {
        if ([self charAt:i] == ch) {
            return i;
        }
    }
    return NotFoundEx;
}

- (int) lastIndexOfChar:(unichar)ch fromIndex:(int)index {
    int len = (int)self.length;
    if (index >= len) {
        index = len - 1;
    }
    for (int i = index; i >= 0; --i) {
        if ([self charAt:i] == ch) {
            return index;
        }
    }
    return NotFoundEx;
}

- (int) lastIndexOfString:(NSString*)str {
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return NotFoundEx;
    }
    return (int)range.location;
}

- (int) lastIndexOfString:(NSString*)str fromIndex:(int)index {
    NSRange fromRange = NSMakeRange(0, index);
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch range:fromRange];
    if (range.location == NSNotFound) {
        return NotFoundEx;
    }
    return (int)range.location;
}

- (NSString *) substringFromIndex:(int)beginIndex toIndex:(int)endIndex {
    if (endIndex <= beginIndex) {
        return @"";
    }
    NSRange range = NSMakeRange(beginIndex, endIndex - beginIndex);
    return [self substringWithRange:range];
}

- (NSString *) toLowerCase {
    return [self lowercaseString];
}

- (NSString *) toUpperCase {
    return [self uppercaseString];
}

- (NSString *)trimBy:(NSString *)str {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:str];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)delZero:(NSString *)src { // 去掉当前字符串的0，不同于[self trimBy:@"0"]
    if ([src endsWith:@"0"]) {
        return [self delZero:[src substringFromIndex:0 toIndex:(int)[src length]-1]];
    } else {
        return src;
    }
}

- (NSString *)trimFloatPointNumber {
    return [[self delZero:self] trimBy:@"."];
}

- (NSString *) replaceAll:(NSString*)origin with:(NSString*)replacement {
    return [self stringByReplacingOccurrencesOfString:origin withString:replacement];
}

- (NSArray *)split:(NSString *)separator {
    return [self componentsSeparatedByString:separator];
}


////////////////////////////

- (NSString *)matchGroupAtIndex:(NSUInteger)idx forRegex:(NSString *)regex {
    NSArray *matches = [self matchesForRegex:regex];
    if (matches.count == 0) return nil;
    NSTextCheckingResult *match = matches[0];
    if (idx >= match.numberOfRanges) return nil;
    
    return [self substringWithRange:[match rangeAtIndex:idx]];
}

- (NSArray *)matchesForRegex:(NSString *)pattern {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
        return nil;
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (matches.count == 0)
        return nil;
    
    return matches;
}

- (NSArray *)allMatchesForRegex:(NSString *)regex {
    NSArray *matches = [self matchesForRegex:regex];
    if (matches.count == 0) return @[];
    
    NSMutableArray *strings = [NSMutableArray new];
    for (NSTextCheckingResult *result in matches)
        [strings addObject:[self substringWithRange:[result rangeAtIndex:1]]];
    
    return strings;
}

- (NSString *)stringByReplacingMatchesForRegex:(NSString *)pattern withString:(NSString *)replacement {
    return [self stringByReplacingOccurrencesOfString:pattern withString:replacement options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)stringByRegex:(NSString*)pattern substitution:(NSString*)substitute {
    regex_t preg;
    NSString *result = nil;
    
    // compile pattern
    int err = regcomp(&preg, [pattern UTF8String], 0 | REG_ICASE | REG_EXTENDED);
    if (err) {
        char errmsg[256];
        regerror(err, &preg, errmsg, sizeof(errmsg));
        //		[NSException raise:@"AFRegexStringException"
        //					format:@"Regex compilation failed for \"%@\": %s", pattern, errmsg];
        return [NSString stringWithString:self];
    } else {
        char buffer[4096];
        char *buf = buffer;
        const char *utf8String = [self UTF8String];
        
        if(strlen(utf8String) >= sizeof(buffer))
            buf = malloc(strlen(utf8String) + 1);
        
        strcpy(buf, utf8String);
        char *replaceStr = (char*)[substitute UTF8String];
        
        if (rreplace (buf, 4096, &preg, replaceStr)) {
            //			[NSException raise:@"AFRegexStringException"
            //						format:@"Replace failed"];
            result = [NSString stringWithString:self];
        } else {
            result = [NSString stringWithUTF8String:buf];
        }
        
        if(buf != buffer)
            free(buf);
    }
    
    
    regfree(&preg);  // fixme: used to be commented
    return result;
}

@end

#pragma mark - Formatter

//  inspired by https://github.com/nst/nsarray-functional

@implementation NSString ( Formatter )

- (NSString *)stringRepresentationForBool:(BOOL)aBool {
    return [NSString stringWithFormat:@"%d", aBool];
}

- (NSString *)stringRepresentationForInt:(int)anInt {
    return [NSString stringWithFormat:@"%d", anInt];
}

- (NSString *)stringRepresentationForFloat:(float)aFloat {
    return [NSString stringWithFormat:@"%f", aFloat];
}

- (NSString *)stringRepresentationForDouble:(double)aDouble {
    return [NSString stringWithFormat:@"%f", aDouble];
}

- (NSString *)stringRepresentationForSelector:(SEL)aSelector {
    return NSStringFromSelector(aSelector);
}

- (NSString *)stringRepresentationForChar:(char)aChar {
    return [NSString stringWithFormat:@"%c", aChar];
}

- (NSString *)stringRepresentationForShort:(short)aShort {
    return [NSString stringWithFormat:@"%hi", aShort];
}

- (NSString *)stringRepresentationForCppBool:(bool)aCppBool {
    return [NSString stringWithFormat:@"%d", aCppBool];
}

- (NSString *)stringRepresentationForUChar:(unsigned char)aUChar {
    return [NSString stringWithFormat:@"%c", aUChar];
}

- (NSString *)stringRepresentationForUShort:(unsigned short)aUShort {
    return [NSString stringWithFormat:@"%hu", aUShort];
}

- (NSString *)stringRepresentationForLong:(long)aLong {
    return [NSString stringWithFormat:@"%ld", aLong];
}

- (NSString *)stringRepresentationForLongLong:(long long)aLongLong {
    return [NSString stringWithFormat:@"%qi", aLongLong];
}

- (NSString *)stringRepresentationForUInt:(unsigned int)aUInt {
    return [NSString stringWithFormat:@"%u", aUInt];
}

- (NSString *)stringRepresentationForULong:(unsigned long)aULong {
    return [NSString stringWithFormat:@"%ld", aULong];
}

- (NSString *)stringRepresentationForULongLong:(unsigned long long)aULongLong {
    return [NSString stringWithFormat:@"%qu", aULongLong];
}

- (NSString *)stringRepresentationForCharPtr:(long long)aCharPtr {
    return [NSString stringWithFormat:@"%s", (char *)aCharPtr];
}

- (NSString *)stringRepresentationForObject:(id)anObject {
    return [anObject description];
}

- (NSString *)stringRepresentationForClass:(Class)aClass {
    return NSStringFromClass(aClass);
}

- (NSString *)stringRepresentationForNSInteger:(NSInteger)aNSInteger {
    return [NSString stringWithFormat:@"%ld", (long)aNSInteger];
}

- (NSString *)stringRepresentationForNSUInteger:(NSUInteger)aNSUInteger {
    return [NSString stringWithFormat:@"%lu", (unsigned long)aNSUInteger];
}

- (NSString *)stringRepresentationForCGFloat:(CGFloat)aCGFloat {
    return [NSString stringWithFormat:@"%.02f", aCGFloat];
}

- (NSString *)stringRepresentationForPointer:(void *)aPointer {
    return [NSString stringWithFormat:@"%p", aPointer];
}

@end

#pragma mark - Pinyin

@implementation NSString ( Pinyin )

- (NSString *)chinese2pinyin {
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [self mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    //返回最近结果
    return pinyin;
}

@end

#pragma mark - Encoding

@implementation NSString (Encoding)

- (NSData *)utf8EncodedData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)base64DecodedData {
    return [[NSData alloc] initWithBase64EncodedString:self options:0];
}

- (NSString *)base64Encode {
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [stringData base64EncodedStringWithOptions:0];
}

- (NSString *)base64Decode {
    return [[NSString alloc] initWithData:self.base64DecodedData encoding:NSUTF8StringEncoding];
}

- (NSString *)sha256Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256Hash];
}

- (NSData *)sha256HashRaw {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (unsigned int)data.length, result);
    
    data = [[NSData alloc] initWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
    
    return data;
}

+ (NSString *)hashHMacToString:(NSString *)data key:(NSString *)key {
    return [[self hashHMac:data key:key] base64EncodedStringWithOptions:0];
}

+ (NSData *)hashHMac:(NSString *)data key:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

- (NSString *)MD5Hash {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

#pragma mark - REST

@implementation NSString (REST)

- (NSString *)URLEncodedString {
    __autoreleasing NSString *encodedString;
    NSString *originalString = (NSString *)self;
    encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (__bridge CFStringRef)originalString,
                                                                                          NULL,
                                                                                          (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                          kCFStringEncodingUTF8
                                                                                          );
    return encodedString;
}

- (NSString *)URLDecodedString {
    __autoreleasing NSString *decodedString;
    NSString *originalString = (NSString *)self;
    decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                          NULL,
                                                                                                          (__bridge CFStringRef)originalString,
                                                                                                          CFSTR(""),
                                                                                                          kCFStringEncodingUTF8
                                                                                                          );
    return decodedString;
}

// 从URL中解析出参数字典
- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString *key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            
            if (kvPair.count == 1) {
                [pairs setObject:[NSNull null] forKey:key];
                
            } else if (kvPair.count == 2) {
                NSString *value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                
                [pairs setObject:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}


- (NSString *)removeUnescapedCharacter {
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [self rangeOfCharacterFromSet:controlChars]; //获取那些特殊字符
    
    //寻找字符串中有没有这些特殊字符
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:self];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range]; //去掉这些特殊字符
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return self;
}

- (NSDictionary *)JSONDictionary {
    NSError *error = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error]; //json数据当中没有 \n \r \t 等制表符
    
    
    if (error) {
        LOG(@"%@", error);
        
        NSString *filteredString = [self removeUnescapedCharacter]; // json 里面的特殊控制字符，需要过滤
        jsonObject = [NSJSONSerialization JSONObjectWithData:[filteredString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        if (error) {
            return nil;
        }
    }
    
    return jsonObject;
}

// 对参数列表生成URL编码后字符串
+ (NSString *)makeQueryStringFromArgs:(NSDictionary *)args {
    NSMutableString *formatString = nil;
    
    for (NSString *key in args) {
        if (formatString == nil) {
            formatString = [NSMutableString stringWithFormat:@"%@=%@", key, [[args valueForKey:key] URLEncodedString]];
        } else {
            [formatString appendFormat:@"&%@=%@", key, [[args valueForKey:key] URLEncodedString]];
        }
    }
    
    return [NSString stringWithString:formatString];
}

@end

#pragma mark - 

@implementation NSString (Attributed)

- (NSAttributedString *)attributedString { return [[NSAttributedString alloc] initWithString:self]; }

- (NSAttributedString *)withColor:(UIColor *)color {
    NSParameterAssert(color);
    return [[NSAttributedString alloc] initWithString:self attributes:@{NSForegroundColorAttributeName: color}];
}

- (NSMutableAttributedString *)withSubString:(NSString *)subString color:(UIColor *)color {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self];
    
    if (![subString length]) return [[self withColor:color] mutableCopy];
    
    NSRange keyRange   = [self rangeOfString:subString];
    if (keyRange.location == NSNotFound) return [[self withColor:color] mutableCopy];
    
    // Attribute setting
    while (keyRange.location != NSNotFound) {
        [attributedText addAttribute:NSForegroundColorAttributeName
                               value:color
                               range:keyRange];
        
        // find next sub string
        NSUInteger nextIndex   = keyRange.location+keyRange.length;
        keyRange    = [self rangeOfString:subString
                                  options:NSLiteralSearch
                                    range:NSMakeRange(nextIndex, self.length-nextIndex)];
    }
    
    return attributedText;
}

- (NSString *)stringByDeletingCharacterAtIndex:(NSUInteger)idx {
    NSMutableString *string = self.mutableCopy;
    [string replaceCharactersInRange:NSMakeRange(idx, 1) withString:@""];
    return string;
}

@end
