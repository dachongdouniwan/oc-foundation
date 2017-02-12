//
//  _encoding.h
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

typedef enum
{
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

@interface NSObject ( Encoding )

/**
 *  對象編碼
 *
 *  @param type 目標編碼類型
 *
 *  @return 編碼後的對象
 */

- (NSObject *)converToType:(EncodingType)type;

@end

#pragma mark -

/**
 *  「武士」·「編碼器」
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

