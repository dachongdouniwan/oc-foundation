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

#import <objc/runtime.h>
#import "foundation/_foundation.h"
#import "NSObject+Extension.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"


// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Extension)

+ (Class)baseClass
{
    return [NSObject class];
}

+ (id)unserializeForUnknownValue:(id)value
{
    UNUSED( value )
    
    return nil;
}

+ (id)serializeForUnknownValue:(id)value
{
    UNUSED( value )
    
    return nil;
}

- (void)deepEqualsTo:(id)obj
{
    Class baseClass = [[self class] baseClass];
    if ( nil == baseClass )
    {
        baseClass = [NSObject class];
    }
    
    for ( Class clazzType = [self class]; clazzType != baseClass; )
    {
        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
        
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            const char *	attr = property_getAttributes(properties[i]);
            
            if ( [_Encoding isReadOnly:attr] )
            {
                continue;
            }
            
            NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            NSObject * propertyValue = [(NSObject *)obj valueForKey:propertyName];
            
            [self setValue:propertyValue forKey:propertyName];
        }
        
        free( properties );
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
    }
}

- (void)deepCopyFrom:(id)obj
{
    if ( nil == obj )
    {
        return;
    }
    
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
            const char *	attr = property_getAttributes(properties[i]);
            
            if ( [_Encoding isReadOnly:attr] )
            {
                continue;
            }
            
            NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            NSObject * propertyValue = [(NSObject *)obj valueForKey:propertyName];
            
            [self setValue:propertyValue forKey:propertyName];
        }
        
        free( properties );
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
    }
}

+ (id)unserialize:(id)obj
{
    return [self unserialize:obj withClass:self];
}

+ (id)unserialize:(id)obj withClass:(Class)clazz
{
    if ( nil == obj )
    {
        return nil;
    }
    
    if ( nil == clazz )
    {
        return obj;
    }
    else if ( [obj isKindOfClass:clazz] )
    {
        return obj;
    }
    
    EncodingType type = [_Encoding typeOfObject:obj];
    
    if ( EncodingType_Array == type )
    {
        NSMutableArray * result = [NSMutableArray array];
        
        for ( id elem in (NSArray *)obj )
        {
            id subResult = [self unserialize:elem withClass:clazz];
            if ( subResult )
            {
                [result addObject:subResult];
            }
        }
        
        return result;
    }
    else if ( EncodingType_Dict == type )
    {
        NSDictionary * dict = (NSDictionary *)obj;
        if ( 0 == dict.count )
        {
            return nil;
        }
        
        id result = [[clazz alloc] init];
        if ( nil == result )
        {
            return nil;
        }
        
        Class baseClass = [[obj class] baseClass];
        if ( nil == baseClass )
        {
            baseClass = [NSObject class];
        }
        
        for ( Class clazzType = clazz; clazzType != baseClass; )
        {
            if ( [_Encoding isAtomClass:clazzType] )
            {
                break;
            }
            
            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
            
            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                const char *	name = property_getName(properties[i]);
                const char *	attr = property_getAttributes(properties[i]);
                
                BOOL readonly = [_Encoding isReadOnly:attr];
                if ( readonly )
                    continue;
                
                NSString *	propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                NSObject *	tempValue = [dict objectForKey:propertyName];
                NSObject *	value = nil;
                
                if ( tempValue )
                {
                    NSInteger propertyType = [_Encoding typeOfAttribute:attr];
                    
                    if ( EncodingType_Null == propertyType )
                    {
                        value = nil;
                    }
                    else if ( EncodingType_Number == propertyType )
                    {
                        value = [tempValue toNumber];
                    }
                    else if ( EncodingType_String == propertyType )
                    {
                        value = [tempValue toString];
                    }
                    else if ( EncodingType_Array == propertyType )
                    {
                        value = tempValue;
                        
                        __autoreleasing Class convertClass = nil;
                        
                        if ( nil == convertClass )
                        {
                            SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertClass_%@", propertyName] );
                            if ( [clazz respondsToSelector:convertSelector] )
                            {
                                //								convertClass = [clazz performSelector:convertSelector];
                                
                                NSMethodSignature * signature = [clazz methodSignatureForSelector:convertSelector];
                                NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
                                
                                [invocation setTarget:clazz];
                                [invocation setSelector:convertSelector];
                                [invocation invoke];
                                [invocation getReturnValue:&convertClass];
                            }
                        }
                        
                        if ( nil == convertClass )
                        {
                            NSString * convertClassName = [clazzType extentionForProperty:propertyName stringValueWithKey:@"Class"];
                            if ( convertClassName )
                            {
                                convertClass = NSClassFromString( convertClassName );
                            }
                        }
                        
                        if ( convertClass )
                        {
                            NSMutableArray * arrayTemp = [NSMutableArray array];
                            
                            for ( NSObject * tempObject in (NSArray *)tempValue )
                            {
                                id elem = [convertClass unserialize:tempObject];
                                if ( elem )
                                {
                                    [arrayTemp addObject:elem];
                                }
                            }
                            
                            value = arrayTemp;
                        }
                    }
                    else if ( EncodingType_Dict == propertyType )
                    {
                        value = tempValue;
                    }
                    else if ( EncodingType_Date == propertyType )
                    {
                        value = [tempValue toDate];
                    }
                    else if ( EncodingType_Data == propertyType )
                    {
                        value = [tempValue toData];
                    }
                    else if ( EncodingType_Url == propertyType )
                    {
                        value = [tempValue toURL];
                    }
                    else
                    {
                        Class classType = [_Encoding classOfAttribute:attr];
                        if ( classType )
                        {
                            if ( [tempValue isKindOfClass:classType] )
                            {
                                value = tempValue;
                            }
                            else
                            {
                                value = [classType unserialize:tempValue];
                                if ( nil == value )
                                {
                                    value = [classType unserializeForUnknownValue:tempValue];
                                }
                            }
                        }
                    }
                }
                
                NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];
                
                if ( policyValues )
                {
                    BOOL isSave = NO;
                    BOOL isLoad = NO;
                    BOOL isClear = NO;
                    
                    for ( NSString * policyValue in policyValues )
                    {
                        if ( NSOrderedSame == [policyValue compare:@"save" options:NSCaseInsensitiveSearch] )
                        {
                            isSave = YES;
                        }
                        else if ( NSOrderedSame == [policyValue compare:@"load" options:NSCaseInsensitiveSearch] )
                        {
                            isLoad = YES;
                        }
                        else if ( NSOrderedSame == [policyValue compare:@"clear" options:NSCaseInsensitiveSearch] )
                        {
                            isClear = YES;
                        }
                    }
                    
                    if ( NO == isLoad )
                        continue;
                }
                
                if ( nil != value )
                {
                    [(NSObject *)result setValue:value forKey:propertyName];
                }
            }
            
            free( properties );
            
            clazzType = class_getSuperclass( clazzType );
            if ( nil == clazzType )
                break;
        }
        
        return result;
    }
    
    return nil;
}

- (void)unserialize:(id)obj
{
    if ( nil == obj )
        return;
    
    EncodingType type = [_Encoding typeOfObject:obj];
    
    if ( EncodingType_Array == type )
    {
        TODO( "does not support array" );
        return;
    }
    else if ( EncodingType_Dict == type )
    {
        NSDictionary * dict = (NSDictionary *)obj;
        if ( 0 == dict.count )
            return;
        
        Class baseClass = [[obj class] baseClass];
        if ( nil == baseClass )
        {
            baseClass = [NSObject class];
        }
        
        for ( Class clazzType = [self class]; clazzType != baseClass; )
        {
            if ( [_Encoding isAtomClass:clazzType] )
            {
                break;
            }
            
            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
            
            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                const char *	name = property_getName(properties[i]);
                const char *	attr = property_getAttributes(properties[i]);
                
                BOOL readonly = [_Encoding isReadOnly:attr];
                if ( readonly )
                    continue;
                
                NSString *	propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                NSObject *	tempValue = [dict objectForKey:propertyName];
                NSObject *	value = nil;
                
                if ( tempValue )
                {
                    NSInteger propertyType = [_Encoding typeOfAttribute:attr];
                    
                    if ( EncodingType_Null == propertyType )
                    {
                        value = nil;
                    }
                    else if ( EncodingType_Number == propertyType )
                    {
                        value = [tempValue toNumber];
                    }
                    else if ( EncodingType_String == propertyType )
                    {
                        value = [tempValue toString];
                    }
                    else if ( EncodingType_Array == propertyType )
                    {
                        value = tempValue;
                        
                        __autoreleasing Class convertClass = nil;
                        
                        if ( nil == convertClass )
                        {
                            SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertClass_%@", propertyName] );
                            if ( [[self class] respondsToSelector:convertSelector] )
                            {
                                //								convertClass = [[self class] performSelector:convertSelector];
                                
                                NSMethodSignature * signature = [[self class] methodSignatureForSelector:convertSelector];
                                NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
                                
                                [invocation setTarget:[self class]];
                                [invocation setSelector:convertSelector];
                                [invocation invoke];
                                [invocation getReturnValue:&convertClass];
                            }
                        }
                        
                        if ( nil == convertClass )
                        {
                            NSString * convertClassName = [clazzType extentionForProperty:propertyName stringValueWithKey:@"Class"];
                            
                            if ( convertClassName )
                            {
                                convertClass = NSClassFromString( convertClassName );
                            }
                        }
                        
                        if ( convertClass )
                        {
                            NSMutableArray * arrayTemp = [NSMutableArray array];
                            
                            for ( NSObject * tempObject in (NSArray *)tempValue )
                            {
                                id elem = [convertClass unserialize:tempObject];
                                if ( elem )
                                {
                                    [arrayTemp addObject:elem];
                                }
                            }
                            
                            value = arrayTemp;
                        }
                    }
                    else if ( EncodingType_Dict == propertyType )
                    {
                        value = tempValue;
                    }
                    else if ( EncodingType_Date == propertyType )
                    {
                        value = [tempValue toDate];
                    }
                    else if ( EncodingType_Data == propertyType )
                    {
                        value = [tempValue toData];
                    }
                    else if ( EncodingType_Url == propertyType )
                    {
                        value = [tempValue toURL];
                    }
                    else
                    {
                        Class classType = [_Encoding classOfAttribute:attr];
                        if ( classType )
                        {
                            if ( [tempValue isKindOfClass:classType] )
                            {
                                value = tempValue;
                            }
                            else
                            {
                                value = [classType unserialize:tempValue];
                                if ( nil == value )
                                {
                                    value = [classType unserializeForUnknownValue:tempValue];
                                }
                            }
                        }
                    }
                }
                
                NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];
                
                if ( policyValues )
                {
                    BOOL isSave = NO;
                    BOOL isLoad = NO;
                    BOOL isClear = NO;
                    
                    for ( NSString * policyValue in policyValues )
                    {
                        if ( NSOrderedSame == [policyValue compare:@"save" options:NSCaseInsensitiveSearch] )
                        {
                            isSave = YES;
                        }
                        else if ( NSOrderedSame == [policyValue compare:@"load" options:NSCaseInsensitiveSearch] )
                        {
                            isLoad = YES;
                        }
                        else if ( NSOrderedSame == [policyValue compare:@"clear" options:NSCaseInsensitiveSearch] )
                        {
                            isClear = YES;
                        }
                    }
                    
                    if ( NO == isLoad )
                        continue;
                }
                
                if ( nil != value )
                {
                    [self setValue:value forKey:propertyName];
                }
            }
            
            free( properties );
            
            clazzType = class_getSuperclass( clazzType );
            if ( nil == clazzType )
                break;
        }
    }
}

- (id)serialize
{
    id obj = self;
    
    if ( nil == obj )
    {
        return nil;
    }
    
    EncodingType type = [_Encoding typeOfObject:obj];
    
    if ( EncodingType_Null == type )
    {
        return obj;
    }
    else if ( EncodingType_Number == type )
    {
        return obj;
    }
    else if ( EncodingType_String == type )
    {
        return obj;
    }
    else if ( EncodingType_Date == type )
    {
        return [(NSDate *)obj toString:@"yyyy/MM/dd HH:mm:ss z"];
    }
    else if ( EncodingType_Data == type )
    {
        return obj;
    }
    else if ( EncodingType_Url == type )
    {
        return [obj toString];
    }
    else if ( EncodingType_Array == type )
    {
        NSMutableArray * result = [NSMutableArray array];
        
        for ( id elem in (NSArray *)obj )
        {
            id subResult = [elem serialize];
            if ( subResult )
            {
                [result addObject:subResult];
            }
        }
        
        return result;
    }
    else if ( EncodingType_Dict == type )
    {
        NSMutableDictionary * result = [NSMutableDictionary dictionary];
        
        for ( NSString * key in [(NSDictionary *)obj allKeys] )
        {
            NSObject * value = [(NSDictionary *)obj objectForKey:key];
            if ( value )
            {
                id subResult = [value serialize];
                if ( subResult )
                {
                    [result setObject:subResult forKey:key];
                }
            }
        }
        
        return result;
    }
    else
    {
        NSMutableDictionary * result = [NSMutableDictionary dictionary];
        
        Class baseClass = [[obj class] baseClass];
        if ( nil == baseClass )
        {
            baseClass = [NSObject class];
        }
        
        for ( Class clazzType = [self class]; clazzType != baseClass; )
        {
            if ( [_Encoding isAtomClass:clazzType] )
            {
                break;
            }
            
            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
            
            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                const char *	name = property_getName(properties[i]);
                //				const char *	attr = property_getAttributes(properties[i]);
                NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                
                NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];
                
                if ( policyValues )
                {
                    BOOL isSave = NO;
                    BOOL isLoad = NO;
                    BOOL isClear = NO;
                    
                    for ( NSString * policyValue in policyValues )
                    {
                        if ( NSOrderedSame == [policyValue compare:@"save" options:NSCaseInsensitiveSearch] )
                        {
                            isSave = YES;
                        }
                        else if ( NSOrderedSame == [policyValue compare:@"load" options:NSCaseInsensitiveSearch] )
                        {
                            isLoad = YES;
                        }
                        else if ( NSOrderedSame == [policyValue compare:@"clear" options:NSCaseInsensitiveSearch] )
                        {
                            isClear = YES;
                        }
                    }
                    
                    if ( NO == isSave )
                        continue;
                }
                
                NSObject * value = [self valueForKey:propertyName];
                
                if ( value )
                {
                    id subResult = [value serialize];
                    if ( subResult )
                    {
                        [result setObject:subResult forKey:propertyName];
                    }
                }
            }
            
            free( properties );
            
            clazzType = class_getSuperclass( clazzType );
            if ( nil == clazzType )
                break;
        }
        
        return result.count ? result : nil;
    }
    
    return nil;
}

- (void)zerolize
{
    id obj = self;
    
    Class baseClass = [[obj class] baseClass];
    if ( nil == baseClass )
    {
        baseClass = [NSObject class];
    }
    
    if ( [_Encoding isAtomObject:self] )
    {
        return;
    }
    
    for ( Class clazzType = [self class]; clazzType != baseClass; )
    {
        if ( [_Encoding isAtomClass:clazzType] )
        {
            break;
        }
        
        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
        
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            const char *	attr = property_getAttributes(properties[i]);
            
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            EncodingType	propertyType = [_Encoding typeOfAttribute:attr];
            
            NSArray * policyValues = [clazzType extentionForProperty:propertyName arrayValueWithKey:@"Policy"];
            
            if ( policyValues )
            {
                BOOL isSave = NO;
                BOOL isLoad = NO;
                BOOL isClear = NO;
                
                for ( NSString * policyValue in policyValues )
                {
                    if ( NSOrderedSame == [policyValue compare:@"save" options:NSCaseInsensitiveSearch] )
                    {
                        isSave = YES;
                    }
                    else if ( NSOrderedSame == [policyValue compare:@"load" options:NSCaseInsensitiveSearch] )
                    {
                        isLoad = YES;
                    }
                    else if ( NSOrderedSame == [policyValue compare:@"clear" options:NSCaseInsensitiveSearch] )
                    {
                        isClear = YES;
                    }
                }
                
                if ( NO == isClear )
                    continue;
            }
            
            if ( EncodingType_Number == propertyType )
            {
                [self setValue:nil forKey:propertyName];
            }
            else if ( EncodingType_String == propertyType )
            {
                [self setValue:nil forKey:propertyName];
            }
            else if ( EncodingType_Date == propertyType )
            {
                [self setValue:nil forKey:propertyName];
            }
            else if ( EncodingType_Data == propertyType )
            {
                [self setValue:nil forKey:propertyName];
            }
            else if ( EncodingType_Url == propertyType )
            {
                [self setValue:nil forKey:propertyName];
            }
            else if ( EncodingType_Array == propertyType )
            {
                [self setValue:[NSMutableArray array] forKey:propertyName];
            }
            else if ( EncodingType_Dict == propertyType )
            {
                [self setValue:[NSMutableDictionary dictionary] forKey:propertyName];
            }
            else
            {
                Class clazz = [_Encoding classOfAttribute:attr];
                if ( clazz )
                {
                    NSObject * newObj = [[clazz alloc] init];
                    if ( newObj )
                    {
                        [self setValue:newObj forKey:propertyName];
                    }
                    else
                    {
                        [self setValue:nil forKey:propertyName];
                    }
                }
                else
                {
                    [self setValue:nil forKey:propertyName];
                }
            }
        }
        
        free( properties );
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
        {
            break;
        }
    }
}

- (id)clone
{
    id newObject = [[[self class] alloc] init];
    
    if ( newObject )
    {
        [newObject deepCopyFrom:self];
    }
    
    return newObject;
}

#pragma mark -

- (id)JSONEncoded
{
    NSError * error = nil;
    NSData * result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if ( nil == result )
    {
        LOG( @"%@", error );
        return nil;
    }
    
    return result;
}

- (id)JSONDecoded
{
    NSError * error = nil;
    NSObject * result = [NSJSONSerialization JSONObjectWithData:[self toData] options:NSJSONReadingAllowFragments error:&error];
    if ( nil == result )
    {
        LOG( @"%@", error );
        return nil;
    }
    
    return result;
}

- (BOOL)toBool
{
    return [[self toNumber] boolValue];
}

- (float)toFloat
{
    return [[self toNumber] floatValue];
}

- (double)toDouble
{
    return [[self toNumber] doubleValue];
}

- (NSInteger)toInteger
{
    return [[self toNumber] integerValue];
}

- (NSUInteger)toUnsignedInteger
{
    return [[self toNumber] unsignedIntegerValue];
}

- (NSURL *)toURL
{
    NSString * string = [self toString];
    if ( nil == string )
    {
        return nil;
    }
    
    return [NSURL URLWithString:string];
}

- (NSDate *)toDate
{
    EncodingType encoding = [_Encoding typeOfObject:self];
    
    if ( EncodingType_Null == encoding )
    {
        return nil;
    }
    else if ( EncodingType_Number == encoding )
    {
        NSNumber * number = (NSNumber *)self;
        return [NSDate dateWithTimeIntervalSince1970:[number doubleValue]];
    }
    else if ( EncodingType_String == encoding )
    {
        return [NSDate fromString:(NSString *)self];
    }
    else if ( EncodingType_Date == encoding )
    {
        return (NSDate *)self;
    }
    else if ( EncodingType_Data == encoding )
    {
        NSData *	data = (NSData *)self;
        NSString *	string = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
        
        return [NSDate fromString:string];
    }
    else if ( EncodingType_Url == encoding )
    {
        return nil;
    }
    else if ( EncodingType_Array == encoding )
    {
        return nil;
    }
    else if ( EncodingType_Dict == encoding )
    {
        return nil;
    }
    
    return nil;
}

- (NSData *)toData
{
    EncodingType encoding = [_Encoding typeOfObject:self];
    
    if ( EncodingType_Null == encoding )
    {
        return nil;
    }
    else if ( EncodingType_Number == encoding )
    {
        NSString * string = [(NSNumber *)self description];
        return [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ( EncodingType_String == encoding )
    {
        NSString * string = (NSString *)self;
        return [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ( EncodingType_Date == encoding )
    {
        NSString * string = [(NSDate *)self toString:@"yyyy/MM/dd HH:mm:ss z"];
        return [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ( EncodingType_Data == encoding )
    {
        return (NSData *)self;
    }
    else if ( EncodingType_Url == encoding )
    {
        NSURL * url = (NSURL *)self;
        return [[url absoluteString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ( EncodingType_Array == encoding )
    {
        NSMutableArray * array = [NSMutableArray array];
        
        for ( NSObject * elem in (NSArray *)self )
        {
            id serializedObject = [elem serialize];
            if ( serializedObject )
            {
                [array addObject:serializedObject];
            }
        }
        
        return [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:NULL];
    }
    else if ( EncodingType_Dict == encoding )
    {
        id serializedObject = [self serialize];
        if ( serializedObject )
        {
            return [NSJSONSerialization dataWithJSONObject:serializedObject options:kNilOptions error:NULL];
        }
    }
    else
    {
        id serializedObject = [self serialize];
        if ( serializedObject )
        {
            return [NSJSONSerialization dataWithJSONObject:serializedObject options:kNilOptions error:NULL];
        }
    }
    
    return nil;
}

- (NSNumber *)toNumber
{
    EncodingType encoding = [_Encoding typeOfObject:self];
    
    if ( EncodingType_Null == encoding )
    {
        return [NSNumber numberWithInt:0];
    }
    else if ( EncodingType_Number == encoding )
    {
        return (NSNumber *)self;
    }
    else if ( EncodingType_String == encoding )
    {
        NSString * string = (NSString *)self;
        
        if ( NSOrderedSame == [string compare:@"yes" options:NSCaseInsensitiveSearch] ||
            NSOrderedSame == [string compare:@"true" options:NSCaseInsensitiveSearch] ||
            NSOrderedSame == [string compare:@"on" options:NSCaseInsensitiveSearch] ||
            NSOrderedSame == [string compare:@"1" options:NSCaseInsensitiveSearch] )
        {
            return [NSNumber numberWithBool:YES];
        }
        else if ( NSOrderedSame == [string compare:@"no" options:NSCaseInsensitiveSearch] ||
                 NSOrderedSame == [string compare:@"off" options:NSCaseInsensitiveSearch] ||
                 NSOrderedSame == [string compare:@"false" options:NSCaseInsensitiveSearch] ||
                 NSOrderedSame == [string compare:@"0" options:NSCaseInsensitiveSearch] )
        {
            return [NSNumber numberWithBool:NO];
        }
        else
        {
            return [NSNumber numberWithInteger:[string integerValue]];
        }
    }
    else if ( EncodingType_Date == encoding )
    {
        NSDate * date = (NSDate *)self;
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }
    else if ( EncodingType_Data == encoding )
    {
        NSData * data = (NSData *)self;
        NSString * string = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
        if ( string )
        {
            return [NSNumber numberWithInteger:[string integerValue]];
        }
    }
    else if ( EncodingType_Url == encoding )
    {
        return nil;
    }
    else if ( EncodingType_Array == encoding )
    {
        return nil;
    }
    else if ( EncodingType_Dict == encoding )
    {
        return nil;
    }
    
    return nil;
}

- (NSString *)toString
{
    EncodingType encoding = [_Encoding typeOfObject:self];
    
    if ( EncodingType_Null == encoding )
    {
        return nil;
    }
    else if ( EncodingType_Number == encoding )
    {
        return [self description];
    }
    else if ( EncodingType_String == encoding )
    {
        return (NSString *)self;
    }
    else if ( EncodingType_Date == encoding )
    {
        return [(NSDate *)self toString:@"yyyy/MM/dd HH:mm:ss z"];
    }
    else if ( EncodingType_Data == encoding )
    {
        NSData *	data = (NSData *)self;
        NSString *	text = nil;
        
        text = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
        if ( nil == text )
        {
            text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ( nil == text )
            {
                text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            }
        }
        
        return text;
    }
    else if ( EncodingType_Url == encoding )
    {
        NSURL * url = (NSURL *)self;
        return [url absoluteString];
    }
    else if ( EncodingType_Array == encoding )
    {
        NSMutableArray * array = [NSMutableArray array];
        
        for ( NSObject * elem in (NSArray *)self )
        {
            id serializedObject = [elem serialize];
            if ( serializedObject )
            {
                [array addObject:serializedObject];
            }
        }
        
        NSData * result = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:NULL];
        if ( result )
        {
            return [result toString];
        }
    }
    else if ( EncodingType_Dict == encoding )
    {
        id serializedObject = [self serialize];
        if ( serializedObject )
        {
            NSData * result = [NSJSONSerialization dataWithJSONObject:serializedObject options:kNilOptions error:NULL];
            if ( result )
            {
                return [result toString];
            }
        }
    }
    else
    {
        id serializedObject = [self serialize];
        if ( serializedObject )
        {
            NSData * result = [NSJSONSerialization dataWithJSONObject:serializedObject options:kNilOptions error:NULL];
            if ( result )
            {
                return [result toString];
            }
        }
    }
    
    return nil;
}

#pragma mark -

+ (BOOL)isNullValue:(id)value {
    return ((NSNull *)value == [NSNull null] ||
            [@"<null>" isEqualToString:(NSString *)value] ||
            [@"(null)" isEqualToString:(NSString *)value] ||
            [@"null" isEqualToString:(NSString *)value] ||
            value == nil);
}


#pragma mark - 

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects {
    // 方法签名(方法的描述)
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        
        //可以抛出异常也可以不操作。
    }
    
    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    
    // 设置参数
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
    paramsCount = MIN(paramsCount, objects.count);
    for (NSInteger i = 0; i < paramsCount; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&object atIndex:i + 2];
    }
    
    // 调用方法
    [invocation invoke];
    
    // 获取返回值
    id returnValue = nil;
    if (signature.methodReturnLength) { // 有返回值类型，才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
    
    return returnValue;
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig)
        return;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:&arg1 atIndex:2];
    [invocation setArgument:&arg2 atIndex:3];
    [invocation retainArguments];
    
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}

- (void)performSelector:(SEL)aSelector withObjects:(NSArray *)arguments afterDelay:(NSTimeInterval)delay {
    NSMethodSignature *sig = [self methodSignatureForSelector:aSelector];
    if (!sig)
        return;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    
    [invocation setTarget:self];
    [invocation setSelector:aSelector];

    for (int i = 0; i < arguments.count; i++) {
        id argument = [arguments objectAtIndex:i];
        [invocation setArgument:&argument atIndex:2+i];
    }
    
    [invocation retainArguments];
    
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

@end
