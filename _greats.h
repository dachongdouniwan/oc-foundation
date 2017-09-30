#import <Foundation/Foundation.h>

// 预编译头
#import "_precompile.h"

// 基础部分
#import "_foundation.h"

// 系统部分
#import "_phone.h"

// 数据结构
#import "_stack.h"
#import "_sorted_array.h"

#import "_domain_model.h"

// 所有功能，两个体系
// app.xxxx, 专注于离散式, 但其实现在building里面
// suite.xxxx, 专注于模块式

//@namespace( greats ) // 新增greats命名空间
//@namespace( greats, logger, _Logger )
//@namespace( greats, debugger, _Debugger )
//@namespace( greats, system, _System )

@namespace( logger, _Logger )
@namespace( debugger, _Debugger )
@namespace( system, _System )

