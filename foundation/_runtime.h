//
//  _runtime.h
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "_module.h"

#pragma mark -

// class

#undef  class_equal
#define class_equal( _inst_, _target_class_type_) [_inst_ isKindOfClass:[_target_class_type_ class]]

#undef  classnameof_instance
#define classnameof_instance( _inst_ ) NSStringFromClass([_inst_ class])

#undef  classnameof_Class
#define classnameof_Class( _Class_ )    NSStringFromClass( _Class_ )

/**
 从 代码串 转换为 Class
 
 - returns: Class
 */
#undef  classof
#define classof( x )		NSClassFromString(@ #x)

/**
 从 字符串 转换为 Class
 
 - returns: Class
 */
#undef  classify
#define classify( _classname_of_str_ ) NSClassFromString( _classname_of_str_ )

/**
 从 代码串 生成 实例
 
 - returns: 实例
 */
#undef  instanceof
#define instanceof( x )	[[NSClassFromString(@ #x) alloc] init]

#pragma mark -

@interface NSObject ( Runtime )

/**
 *  Get all classes those are loaded
 *
 *  @return should be free after use.
 */
+ (__unsafe_unretained Class *)loadedClasses;
+ (void)enumerateloadedClassesUsingBlock:(void (^)(__unsafe_unretained Class cls))block;

+ (NSArray *)subClasses;

+ (NSArray *)methods;
+ (NSArray *)methodsUntilClass:(Class)baseClass;
+ (NSArray *)methodsWithPrefix:(NSString *)prefix;
+ (NSArray *)methodsWithPrefix:(NSString *)prefix untilClass:(Class)baseClass;

+ (NSArray *)properties;
+ (NSArray *)propertiesUntilClass:(Class)baseClass;
+ (NSArray *)propertiesWithPrefix:(NSString *)prefix;
+ (NSArray *)propertiesWithPrefix:(NSString *)prefix untilClass:(Class)baseClass;

+ (NSArray *)classesWithProtocolName:(NSString *)protocolName;

+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2;

// inspired by CBExtension
/*! 该对象所遵循的协议 */
- (NSArray *)conformedProtocols;

/*! 返回对象的所有 ivar */
- (NSArray *)allIvars;

/*! 以 NSString 描述的类名 */
- (NSString *)className;

/*! 所有父类 */
- (NSArray *)parents;

@end

#pragma mark -

@interface _Runtime : NSObject

@end
