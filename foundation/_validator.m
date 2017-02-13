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

#import "_validator.h"
#import "_encoding.h"
#import "extension/NSString+Extension.h"
#import "extension/NSObject+Extension.h"
#import "_container_safe.h"

#pragma mark -

@implementation NSObject ( Validation )

- (BOOL)validate
{
    return [[_Validator sharedInstance] validateObject:self];
}

- (BOOL)validate:(NSString *)prop
{
    return [[_Validator sharedInstance] validateObject:self property:prop];
}

@end

#pragma mark -

@implementation _Validator

@def_singleton( _Validator )

@def_prop_strong( NSString *,	lastProperty );
@def_prop_strong( NSString *,	lastError );

static __strong NSMutableDictionary * __rules = nil;

+ (void)classAutoLoad
{
    [[_Validator sharedInstance] loadRules];
}

- (void)loadRules
{
    if ( nil == __rules )
    {
        __rules = [[NSMutableDictionary alloc] init];
        
        [__rules setObject:@(ValidatorRule_Regex)		forKey:@"regex"];
        [__rules setObject:@(ValidatorRule_Accepted)	forKey:@"accepted"];
        [__rules setObject:@(ValidatorRule_In)			forKey:@"in"];
        [__rules setObject:@(ValidatorRule_NotIn)		forKey:@"notin"];
        [__rules setObject:@(ValidatorRule_Alpha)		forKey:@"alpha"];
        [__rules setObject:@(ValidatorRule_Numeric)		forKey:@"numeric"];
        [__rules setObject:@(ValidatorRule_AlphaNum)	forKey:@"alpha_num"];
        [__rules setObject:@(ValidatorRule_AlphaDash)	forKey:@"alpha_dash"];
        [__rules setObject:@(ValidatorRule_URL)			forKey:@"url"];
        [__rules setObject:@(ValidatorRule_Email)		forKey:@"email"];
        //		[__rules setObject:@(ValidatorRule_Tel)			forKey:@"tel"];
        [__rules setObject:@(ValidatorRule_Integer)		forKey:@"integer"];
        [__rules setObject:@(ValidatorRule_IP)			forKey:@"ip"];
        [__rules setObject:@(ValidatorRule_Before)		forKey:@"before"];
        [__rules setObject:@(ValidatorRule_After)		forKey:@"after"];
        [__rules setObject:@(ValidatorRule_Between)		forKey:@"between"];
        [__rules setObject:@(ValidatorRule_Same)		forKey:@"same"];
        [__rules setObject:@(ValidatorRule_Size)		forKey:@"size"];
        [__rules setObject:@(ValidatorRule_Date)		forKey:@"date"];
        [__rules setObject:@(ValidatorRule_DateFormat)	forKey:@"dateformat"];
        [__rules setObject:@(ValidatorRule_Different)	forKey:@"different"];
        [__rules setObject:@(ValidatorRule_Min)			forKey:@"min"];
        [__rules setObject:@(ValidatorRule_Max)			forKey:@"max"];
        [__rules setObject:@(ValidatorRule_Required)	forKey:@"required"];
    }
}

- (ValidatorRule)typeFromString:(NSString *)string
{
    string = [[string trim] unwrap];
    
    NSNumber * ruleType = [__rules objectForKey:string];
    if ( ruleType )
    {
        return (ValidatorRule)ruleType.integerValue;
    }
    
    return ValidatorRule_Unknown;
}

- (BOOL)validate:(NSObject *)value rule:(NSString *)rule
{
    NSUInteger offset = 0;
    
    if ( NSNotFound != [rule rangeOfString:@":"].location )
    {
        NSString * ruleName = [[rule substringFromIndex:0 untilString:@":" endOffset:&offset] trim];
        NSString * ruleValue = [[[rule substringFromIndex:offset] trim] unwrap];
        
        return [self validate:value ruleName:ruleName ruleValue:ruleValue];
    }
    else
    {
        return [self validate:value ruleName:rule ruleValue:nil];
    }
}

- (BOOL)validate:(NSObject *)value ruleName:(NSString *)ruleName ruleValue:(NSString *)ruleValue
{
    ValidatorRule ruleType = [self typeFromString:ruleName];
    
    if ( ValidatorRule_Unknown == ruleType )
    {
#if __ENABLE_STRICT_VALIDATION__
        return YES;
#else
        return NO;
#endif
    }
    
    return [self validate:value ruleType:ruleType ruleValue:ruleValue];
}

- (BOOL)validate:(NSObject *)value ruleType:(ValidatorRule)ruleType ruleValue:(NSString *)ruleValue
{
    switch ( ruleType )
    {
        case ValidatorRule_Regex:
        {
            NSString * textValue = [value toString];
            if ( nil == textValue )
            {
                return NO;
            }
            
            BOOL matched = [textValue match:ruleValue];
            if ( NO == matched )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_Accepted:
        {
            BOOL accepted = [[value toNumber] boolValue];
            if ( NO == accepted )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_In:
        {
            BOOL			matched = NO;
            EncodingType	encoding = [_Encoding typeOfObject:value];
            
            NSArray * list = [ruleValue componentsSeparatedByString:@","];
            for ( NSString * item in list )
            {
                NSString * filter = [[item trim] unwrap];
                NSObject * value2 = [filter converToType:encoding];
                
                if ( value2 && [value2 isEqual:value] )
                {
                    matched = YES;
                    break;
                }
            }
            
            if ( NO == matched )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_NotIn:
        {
            BOOL			matched = NO;
            EncodingType	encoding = [_Encoding typeOfObject:value];
            
            NSArray * list = [ruleValue componentsSeparatedByString:@","];
            for ( NSString * item in list )
            {
                NSString * filter = [[item trim] unwrap];
                NSObject * value2 = [filter converToType:encoding];
                
                if ( value2 && [value2 isEqual:value] )
                {
                    matched = YES;
                    break;
                }
            }
            
            if ( matched )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_Alpha:
        {
            NSString * textValue = [value toString];
            if ( nil == textValue )
            {
                return NO;
            }
            
            if ( NO == [textValue match:@"^([a-zA-Z]+)$"] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_Numeric:
        {
            NSString * textValue = [value toString];
            if ( nil == textValue )
            {
                return NO;
            }
            
            if ( NO == [textValue match:@"^([+\\-\\.0-9]+)$"] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_AlphaNum:
        {
            NSString * textValue = [value toString];
            if ( nil == textValue )
            {
                return NO;
            }
            
            if ( NO == [textValue match:@"^([a-zA-Z0-9]+)$"] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_AlphaDash:
        {
            NSString * textValue = [value toString];
            if ( nil == textValue )
            {
                return NO;
            }
            
            if ( NO == [textValue match:@"^([a-zA-Z_]+)$"] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_URL:
        {
            NSString * textValue = [value toString];
            if ( nil == textValue )
            {
                return NO;
            }
            
            if ( NO == [textValue isUrl] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_Email:
        {
            NSString * textValue = [value toString];
            if ( nil == textValue )
            {
                return NO;
            }
            
            if ( NO == [textValue isEmail] )
            {
                return NO;
            }
        }
            break;
            
            //	case ValidatorRule_Tel:
            //		{
            //			NSString * textValue = [value toString];
            //			if ( nil == textValue )
            //			{
            //				return NO;
            //			}
            //
            //			if ( NO == [textValue isTelephone] )
            //			{
            //				return NO;
            //			}
            //		}
            //		break;
            
        case ValidatorRule_Image:
        {
            if ( NO == [value isKindOfClass:[UIImage class]] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_Integer:
        {
            EncodingType encoding = [_Encoding typeOfObject:value];
            
            if ( EncodingType_Number != encoding )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_IP:
        {
            NSString * textValue = [value toString];
            if ( nil == textValue )
            {
                return NO;
            }
            
            if ( NO == [textValue isIPAddress] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_Before:
        {
            NSDate * dateValue = [value toDate];
            NSDate * dateValue2 = [ruleValue toDate];
            
            if ( nil == dateValue || nil == dateValue2 )
            {
                return NO;
            }
            
            if ( NSOrderedAscending != [dateValue compare:dateValue2] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_After:
        {
            NSDate * dateValue = [value toDate];
            NSDate * dateValue2 = [ruleValue toDate];
            
            if ( nil == dateValue || nil == dateValue2 )
            {
                return NO;
            }
            
            if ( NSOrderedDescending != [dateValue compare:dateValue2] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_Between:
        {
            NSNumber * numberValue = [value toNumber];
            if ( nil == numberValue )
            {
                return NO;
            }
            
            NSArray *	array = [ruleValue componentsSeparatedByString:@","];
            NSNumber *	value1 = [[[array safeObjectAtIndex:0] trim] toNumber];
            NSNumber *	value2 = [[[array safeObjectAtIndex:1] trim] toNumber];
            
            if ( nil == value1 || nil == value2 )
            {
                return NO;
            }
            
            if ( NSOrderedDescending != [numberValue compare:value1] )
            {
                return NO;
            }
            
            if ( NSOrderedAscending != [numberValue compare:value2] )
            {
                return NO;
            }
        }
            break;
            
        case ValidatorRule_Same:
        {
            TODO( "same: xxx" );
        }
            break;
            
        case ValidatorRule_Size:
        {
            EncodingType encoding = [_Encoding typeOfObject:value];
            
            if ( EncodingType_Number == encoding )
            {
                NSNumber * numberValue = (NSNumber *)value;
                
                if ( NSOrderedSame != [numberValue compare:[[ruleValue trim] toNumber]] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_String == encoding )
            {
                NSString * stringValue = (NSString *)value;
                
                if ( [stringValue length] != (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Data == encoding )
            {
                NSData * dataValue = (NSData *)value;
                
                if ( [dataValue length] != (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Url == encoding )
            {
                NSString * stringValue = [value toString];
                
                if ( [stringValue length] != (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Array == encoding )
            {
                NSArray * arrayValue = (NSArray *)value;
                
                if ( [arrayValue count] != (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Dict == encoding )
            {
                NSDictionary * dictValue = (NSDictionary *)value;
                
                if ( [dictValue count] != (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
        }
            break;
            
        case ValidatorRule_Date:
        {
            EncodingType encoding = [_Encoding typeOfObject:value];
            
            if ( EncodingType_Date != encoding )
            {
                NSDate * date = [value toDate];
                if ( nil == date )
                {
                    return NO;
                }
            }
        }
            break;
            
        case ValidatorRule_DateFormat:
        {
            TODO( "data_format: xxx" );
        }
            break;
            
        case ValidatorRule_Different:
        {
            TODO( "different: xxx" );
        }
            break;
            
        case ValidatorRule_Min:
        {
            EncodingType encoding = [_Encoding typeOfObject:value];
            
            if ( EncodingType_Number == encoding )
            {
                NSNumber * numberValue = (NSNumber *)value;
                
                if ( NSOrderedAscending == [numberValue compare:[[ruleValue trim] toNumber]] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_String == encoding )
            {
                NSString * stringValue = (NSString *)value;
                
                if ( [stringValue length] < (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Data == encoding )
            {
                NSData * dataValue = (NSData *)value;
                
                if ( [dataValue length] < (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Url == encoding )
            {
                NSString * stringValue = [value toString];
                
                if ( [stringValue length] < (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Array == encoding )
            {
                NSArray * arrayValue = (NSArray *)value;
                
                if ( [arrayValue count] < (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Dict == encoding )
            {
                NSDictionary * dictValue = (NSDictionary *)value;
                
                if ( [dictValue count] < (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
        }
            break;
            
        case ValidatorRule_Max:
        {
            EncodingType encoding = [_Encoding typeOfObject:value];
            
            if ( EncodingType_Number == encoding )
            {
                NSNumber * numberValue = (NSNumber *)value;
                
                if ( NSOrderedDescending == [numberValue compare:[[ruleValue trim] toNumber]] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_String == encoding )
            {
                NSString * stringValue = (NSString *)value;
                
                if ( [stringValue length] > (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Data == encoding )
            {
                NSData * dataValue = (NSData *)value;
                
                if ( [dataValue length] > (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Url == encoding )
            {
                NSString * stringValue = [value toString];
                
                if ( [stringValue length] > (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Array == encoding )
            {
                NSArray * arrayValue = (NSArray *)value;
                
                if ( [arrayValue count] > (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
            else if ( EncodingType_Dict == encoding )
            {
                NSDictionary * dictValue = (NSDictionary *)value;
                
                if ( [dictValue count] > (NSUInteger)[ruleValue integerValue] )
                {
                    return NO;
                }
            }
        }
            break;
            
        case ValidatorRule_Required:
        {
            if ( nil == value )
            {
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)validateObject:(NSObject *)obj
{
    Class baseClass = [[obj class] baseClass];
    if ( nil == baseClass )
    {
        baseClass = [NSObject class];
    }
    
    for ( Class clazzType = [obj class]; clazzType != baseClass; )
    {
        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
        
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            NSObject *		propertyValue = [obj valueForKey:propertyName];
            NSArray *		ruleValues = [obj extentionForProperty:propertyName arrayValueWithKey:@"Rule"];
            
            for ( NSString * ruleValue in ruleValues )
            {
                BOOL passes = [self validate:propertyValue rule:ruleValue];
                if ( NO == passes )
                {
                    self.lastProperty	= propertyName;
                    self.lastError		= @"Unknown";
                    
                    return NO;
                }
            }
        }
        
        free( properties );
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
    }
    
    return YES;
}

- (BOOL)validateObject:(NSObject *)obj property:(NSString *)property
{
    if ( nil == property )
        return NO;
    
    NSString *		propertyName = property;
    NSObject *		propertyValue = [obj valueForKey:propertyName];
    NSArray *		ruleValues = [obj extentionForProperty:propertyName arrayValueWithKey:@"Rule"];
    
    for ( NSString * ruleValue in ruleValues )
    {
        BOOL passes = [self validate:propertyValue rule:ruleValue];
        if ( NO == passes )
        {
            self.lastProperty	= propertyName;
            self.lastError		= @"Unknown";
            
            return NO;
        }
    }
    
    return YES;
}

@end
