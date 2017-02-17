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
#import "_precompile.h"
#import "_property.h"
#import "_singleton.h"

#pragma mark -

typedef enum
{
    ValidatorRule_Unknown = 0,
    ValidatorRule_Regex,		// 验证此规则的值必须符合给定的正则表达式
    ValidatorRule_Accepted,		// 验证此规则的值必须是 yes、 on 或者是 1
    ValidatorRule_In,			// 验证此规则的值必须在给定的列表中存在
    ValidatorRule_NotIn,		// 验证此规则的值必须在给定的列表中不存在
    ValidatorRule_Alpha,		// 验证此规则的值必须全部由字母字符构成
    ValidatorRule_Numeric,		// 验证此规则的值必须是一个数字（数字）
    ValidatorRule_AlphaNum,		// 验证此规则的值必须全部由字母和数字构成（字母|数字）
    ValidatorRule_AlphaDash,	// 验证此规则的值必须全部由字母、数字、中划线或下划线字符构成（字母|数字|中划线|下划线）
    ValidatorRule_URL,			// 验证此规则的值必须是一个URL
    ValidatorRule_Email,		// 验证此规则的值必须是一个电子邮件地址
    //	ValidatorRule_Tel,			// 验证此规则的值必须是一个电话
    ValidatorRule_Image,		// 验证此规则的值必须是一个图片
    ValidatorRule_Integer,		// 验证此规则的值必须是一个整数
    ValidatorRule_IP,			// 验证此规则的值必须是一个IP地址
    ValidatorRule_Before,		// 验证此规则的值必须在给定日期之前
    ValidatorRule_After,		// 验证此规则的值必须在给定日期之后
    ValidatorRule_Between,		// 验证此规则的值必须在给定的 min 和 max 之间
    ValidatorRule_Same,			// 验证此规则的值必须与给定域的值相同
    ValidatorRule_Size,			// 验证此规则的值的大小必须与给定的 value 相同
    ValidatorRule_Date,			// 验证此规则的值必须是一个合法的日期
    ValidatorRule_DateFormat,	// 验证此规则的值必须符合给定的 format 的格式
    ValidatorRule_Different,	// 验证此规则的值必须符合给定的 format 的格式
    ValidatorRule_Min,			// 验证此规则的值必须大于最小值 value
    ValidatorRule_Max,			// 验证此规则的值必须小于最大值 value
    ValidatorRule_Required,		// 验证此规则的值必须在输入数据中存在
} ValidatorRule;

#pragma mark -

@interface NSObject ( Validation )

- (BOOL)validate;
- (BOOL)validate:(NSString *)prop;

@end

#pragma mark -

@interface _Validator : NSObject

@singleton( _Validator )

@prop_strong( NSString *,	lastProperty );
@prop_strong( NSString *,	lastError );

- (ValidatorRule)typeFromString:(NSString *)string;

- (BOOL)validate:(NSObject *)value rule:(NSString *)rule;
- (BOOL)validate:(NSObject *)value ruleName:(NSString *)ruleName ruleValue:(NSString *)ruleValue;
- (BOOL)validate:(NSObject *)value ruleType:(ValidatorRule)ruleType ruleValue:(NSString *)ruleValue;

- (BOOL)validateObject:(NSObject *)obj;
- (BOOL)validateObject:(NSObject *)obj property:(NSString *)property;

@end
