//
//  _runtime.m
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <objc/runtime.h>

#import "_runtime.h"

#pragma mark -

@implementation NSObject ( Runtime )

+ (NSArray *)loadedClassNames {
    static dispatch_once_t		once;
    static NSMutableArray *		classNames;
    
    dispatch_once( &once, ^ {
                      classNames = [[NSMutableArray alloc] init];
                      
                      unsigned int 	classesCount = 0;
                      Class *		classes = objc_copyClassList( &classesCount );
                      
                      for ( unsigned int i = 0; i < classesCount; ++i ) {
                          Class classType = classes[i];
                          
                          if ( class_isMetaClass( classType ) )
                              continue;
                          
                          Class superClass = class_getSuperclass( classType );
                          
                          if ( nil == superClass )
                              continue;
                          
                          [classNames addObject:[NSString stringWithUTF8String:class_getName(classType)]];
                      }
                      
                      [classNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                          return [obj1 compare:obj2];
                      }];
                      
                      free( classes );
                  });
    
    return classNames;
}

+ (__unsafe_unretained Class *)loadedClasses {
    int numClasses;
    Class *classes = NULL;
    
    numClasses = objc_getClassList(NULL,0);
    
    if (numClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        
        numClasses = objc_getClassList(classes, numClasses);
    }
    
    return classes;
}

+ (void)enumerateloadedClassesUsingBlock:(void (^)(__unsafe_unretained Class))block {
    for ( NSString * className in [self loadedClassNames] ) {
        Class classType = NSClassFromString( className );
        
        if (block) block(classType);
    }
}

+ (NSArray *)subClasses {
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for ( NSString * className in [self loadedClassNames] ) {
        Class classType = NSClassFromString( className );
        if ( classType == self )
            continue;
        
        if ( NO == [classType isSubclassOfClass:self] )
            continue;
        
        [results addObject:[classType description]];
    }
    
    return results;
}

+ (NSArray *)methods
{
    return [self methodsUntilClass:[self superclass]];
}

+ (NSArray *)methodsUntilClass:(Class)baseClass
{
    NSMutableArray * methodNames = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    
    baseClass = baseClass ?: [NSObject class];
    
    while ( NULL != thisClass )
    {
        unsigned int	methodCount = 0;
        Method *		methodList = class_copyMethodList( thisClass, &methodCount );
        
        for ( unsigned int i = 0; i < methodCount; ++i )
        {
            SEL selector = method_getName( methodList[i] );
            if ( selector )
            {
                const char * cstrName = sel_getName(selector);
                if ( NULL == cstrName )
                    continue;
                
                NSString * selectorName = [NSString stringWithUTF8String:cstrName];
                if ( NULL == selectorName )
                    continue;
                
                [methodNames addObject:selectorName];
            }
        }
        
        free( methodList );
        
        thisClass = class_getSuperclass( thisClass );
        
        if ( nil == thisClass || baseClass == thisClass )
        {
            break;
        }
    }
    
    return methodNames;
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix
{
    return [self methodsWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix untilClass:(Class)baseClass
{
    NSArray * methods = [self methodsUntilClass:baseClass];
    
    if ( nil == methods || 0 == methods.count )
    {
        return nil;
    }
    
    if ( nil == prefix )
    {
        return methods;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for ( NSString * selectorName in methods )
    {
        if ( NO == [selectorName hasPrefix:prefix] )
        {
            continue;
        }
        
        [result addObject:selectorName];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return result;
}

+ (NSArray *)properties
{
    return [self propertiesUntilClass:[self superclass]];
}

+ (NSArray *)propertiesUntilClass:(Class)baseClass
{
    NSMutableArray * propertyNames = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    
    baseClass = baseClass ?: [NSObject class];
    
    while ( NULL != thisClass )
    {
        unsigned int		propertyCount = 0;
        objc_property_t *	propertyList = class_copyPropertyList( thisClass, &propertyCount );
        
        for ( unsigned int i = 0; i < propertyCount; ++i )
        {
            const char * cstrName = property_getName( propertyList[i] );
            if ( NULL == cstrName )
                continue;
            
            NSString * propName = [NSString stringWithUTF8String:cstrName];
            if ( NULL == propName )
                continue;
            
            [propertyNames addObject:propName];
        }
        
        free( propertyList );
        
        thisClass = class_getSuperclass( thisClass );
        
        if ( nil == thisClass || baseClass == thisClass )
        {
            break;
        }
    }
    
    return propertyNames;
}

+ (NSArray *)propertiesWithPrefix:(NSString *)prefix
{
    return [self propertiesWithPrefix:prefix untilClass:[self superclass]];
}

+ (NSArray *)propertiesWithPrefix:(NSString *)prefix untilClass:(Class)baseClass
{
    NSArray * properties = [self propertiesUntilClass:baseClass];
    
    if ( nil == properties || 0 == properties.count )
    {
        return nil;
    }
    
    if ( nil == prefix )
    {
        return properties;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for ( NSString * propName in properties )
    {
        if ( NO == [propName hasPrefix:prefix] )
        {
            continue;
        }
        
        [result addObject:propName];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return result;
}

+ (NSArray *)classesWithProtocolName:(NSString *)protocolName
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    Protocol * protocol = NSProtocolFromString(protocolName);
    for ( NSString *className in [self loadedClassNames] )
    {
        Class classType = NSClassFromString( className );
        if ( classType == self )
            continue;
        
        if ( NO == [classType conformsToProtocol:protocol] )
            continue;
        
        [results addObject:[classType description]];
    }
    
    return results;
}

+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2
{
    Method method = class_getInstanceMethod( self, sel1 );
    
    IMP implement = (IMP)method_getImplementation( method );
    IMP implement2 = class_getMethodImplementation( self, sel2 );
    
    method_setImplementation( method, implement2 );
    
    return (void *)implement;
}

#pragma mark -

- (NSArray *)conformedProtocols {
    unsigned int outCount = 0;
    Class obj_class = [self class];
    __unsafe_unretained Protocol **protocols = class_copyProtocolList(obj_class, &outCount);
    
    NSMutableArray *protocol_array = nil;
    if (outCount > 0) {
        protocol_array = [[NSMutableArray alloc] initWithCapacity:outCount];
        
        for (NSInteger i = 0; i < outCount; i++) {
            NSString *protocol_name_string;
            const char *protocol_name = protocol_getName(protocols[i]);
            protocol_name_string = [[NSString alloc] initWithCString:protocol_name
                                                            encoding:NSUTF8StringEncoding];
            [protocol_array addObject:protocol_name_string];
        }
    }
    
    return protocol_array;
}

- (NSArray *)allIvars {
    unsigned int count = 0;
    Ivar *ivar_ptr = NULL;
    ivar_ptr = class_copyIvarList([self class], &count);
    
    if ( !ivar_ptr ) {
        return [NSArray array];
    }
    
    NSMutableArray *all = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        @autoreleasepool {
            NSString *ivar = ivarName(ivar_ptr[i]);
            [all addObject:ivar];
        }
    }
    free(ivar_ptr);
    return all;
}

- (NSArray *)parents {
    Class selfClass = object_getClass(self);
    NSMutableArray *all = [[NSMutableArray alloc] initWithCapacity:0];
    
    Class aClass = class_getSuperclass(selfClass);
    while (aClass != nil) {
        @autoreleasepool {
            [all addObject: NSStringFromClass(aClass) ];
            aClass = class_getSuperclass(aClass);
        }
    }
    return all;
}

- (NSString *)className {
    return NSStringFromClass(object_getClass(self));
}

#pragma mark - Inline method

/*! 以 NSString 类型返回 property名称 */
static inline NSString *propertyName(objc_property_t property) {
    const char *name = property_getName(property);
    return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
}

/*! 以 NSString 类型返回 ivar 名称 */
static inline NSString *ivarName(Ivar ivar) {
    const char *name = ivar_getName(ivar);
    return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
}

/*! 以 NSString 类型返回 method 名称 */
static inline NSString *methodName(Method m) {
    return NSStringFromSelector(method_getName(m));
}


@end

#pragma mark -

@implementation _Runtime

@end
