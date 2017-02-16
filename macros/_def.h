//
// 所有宏定义，都遵循
// 名词：直接大写（避免重复
// 动词：下划线风格＋小写字母（便于阅读
// 枚举，用下划线＋关键类别名词：CellType_xxxxx，不要 k ！！！！！xxxxx部分首字母大写
// 类型：StringBlock，CellType
// 文件：下划线，并且有前置下划线
// 类名：下划线，加驼峰命名
// 全局外部变量：<modulename>Module_xxxxx, 首字母大写, "xxxxx"部分首字母小写
// 内部变量：<modulename>Module_xxxxx, 首字母大写, "xxxxx"部分首字母小写
// Block作为参数：success:(ObjectBlock)successHandler
// 类型转换宏：xxx_ify 后面跟 对象，xxx_of 后面跟code，或者基础类型
// SDk所需要的key：SdkKey + product name + client end
// 一般性字符串标识符：suite.module.spec
// 一般性key编码：key.类型名(意义名）
// 单例的实例的宏定义：xxxInst, 如 networkInst

#import <Foundation/Foundation.h>

// application：面向多应用体系的应用上下文抽象

// view
// view controller
// view model: 数据请求、数据处理、view绑定等
// api
// model(storage): 面向网络的瘦model
// entity(network): 面向本地数据库的表模型

// manager: 胶合代码，model处理等
// helper: 业务相关的工具方法

// component: 完整的包括，UI层 view、逻辑层 service、数据层 model or (manager and model)
// service:

// utility: 业务无关的工具方法

// UIViewController中，variable as 代码View，property as xib view

#import "_uidef.h"
#import "_systemdef.h"
#import "_constdef.h"
#import "_typedef.h"
#import "_coderdef.h"
#import "_stringdef.h"
#import "_appdef.h"
#import "_configdef.h"
#import "_ocdef.h"
#import "_threaddef.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#ifndef __IPHONE_7_0
#error "Samurai only available in iOS SDK 6.0 and later."
#endif
#endif
