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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


/**
 * Block 预定义
 */

/**
 @knowledge
 
 *  避免滥用block
 
 *  好处：定义简单，并可以捕获上下文变量，还有大部分时候，便于代码顺序阅读
 
 *  滥用：
 1. 忽视循环引用（相反，delegate会比较安全）
 2. 对block生命周期不熟悉，多见于多线程情况下。
 3. 复杂逻辑用多层block嵌套实现，导致调试困难
 */

typedef void(^ Block)(void);
typedef void(^ BlockBlock)(Block block);
typedef void(^ BOOLBlock)(BOOL b);
typedef void(^ ObjectBlock)(id obj);
typedef void(^ ArrayBlock)(NSArray *array);
typedef void(^ MutableArrayBlock)(NSMutableArray *array);
typedef void(^ DictionaryBlock)(NSDictionary *dic);
typedef void(^ ErrorBlock)(NSError *error);
typedef void(^ IndexBlock)(NSInteger index);
typedef void(^ ListItemBlock) (NSInteger index, id param);
typedef void(^ FloatBlock)(CGFloat afloat);
typedef void(^ StringBlock)(NSString *str);
typedef void(^ ImageBlock)(UIImage *image);
typedef void(^ ProgressBlock)(NSProgress *progress);
typedef void(^ PercentBlock)(double percent); // 0~100

typedef void(^ Event)(id event, NSInteger type, id object);

typedef void(^ CancelBlock)(id viewController);
typedef void(^ FinishedBlock)(id viewController, id object);

typedef void(^ SendRequestAndResendRequestBlock)(id sendBlock, id resendBlock);

/*
 * 结构定义
 */

/**
 操作类型：OperationType
 操作类型可用key：如下
 */
#define OperationTypeKey @"key.OperationType"
typedef enum : NSUInteger {
    OperationType_Add = 0,
    OperationType_Delete,
    OperationType_Edit,
    OperationType_Query,
} OperationType;
