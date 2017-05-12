Reference：(Thanks & がんばって<罗马音：ganbatte 中文近似读音：gan ba dei>)

* [hackers-painters/samurai-native](https://github.com/hackers-painters/samurai-native), 很有趣，“黑客与画家”，Joe Zhou named this orgnization “二进制艺术家”, Cheers。
* [shaojiankui/JKCategories](https://github.com/shaojiankui/JKCategories)

----------
### 系列

1. [suite.great](https://github.com/BinaryArtists/suite.great)
	基础部件
2. [suite.tool](https://github.com/BinaryArtists/suite.tool)
	工具部件，包括了：utility、model、network、cache、database
	(note: 需要包含include文件夹，可以单一引用)
3. [suite.module-x](https://github.com/BinaryArtists/suite.module-x)
	模块化机制，service（参考BeeFramework），mediator等
4. [suite.debug](https://github.com/BinaryArtists/suite.debug)
	调试工具，架构基于module-x中的service
6. [sutie.ui](https://github.com/BinaryArtists/suite.ui)
	UI组件，主要分两部分：对系统视图层的扩展，和用到的第三方UI组件
7. [suite.hybrid](https://github.com/BinaryArtists/suite.hybrid)
	混合框架使用，该框架以weex为蓝本；兼顾对其他开源方案的学习与尝试

----------
### 分块

1. 基础类：类加载、容器的安全访问、调试、编码、异常、键值观察、命名空间、通知、性能、属性定义、协议预定义、运行时处理、单例辅助类、字符串生成器、方法交换、线程类、定时器、校验、拦截器
2. 宏：有关于应用、归档、颜色、注释、全局配置、常量、设备、字体、oc语言、忽略特定警告、字符串、系统、线程、类型预定义、UI
3. 系统：错误、本地化、日志、沙箱、系统信息、任务、测试
4. 事件：
5. 资源：枚举所有的警告内容、
6. 其他支持：block使用集、声明式响应式处理、状态机、类型相关的信号处理

引用：
	[软件架构入门](http://www.ruanyifeng.com/blog/2016/09/software-architecture.html)

----------
### suite.great 中反人类的代码风格！！

	> 大部分文件，均为小写字母命名文件。
	> 很大可能重名的文件，以下划线开头。

结论：它注定不会被他人使用，😄，然而为什么会写成这样？

	> 厌烦各种前缀缩写，于是有了"_"
	> "_" 加上驼峰在文件名上，很难看，于是就："_ui_core.h"，而类名：_Namespace
    > 那么，主框架内：
    >> 类名：_ClassName
    >> 内部方法名：__methodName
    >> 外部方法名：methodname
    >> 全局变量：禁止，用宏替换，单例等
    >> 属性名：propertyName
    >> 文件名：_file_name.h
    >> 宏定义：动作类：macro_operation( _name_ )，环境变量类：MACRO_ENV (我更偏向于全小写，想想巧办法)

引用：
	[为什么文件名要小写？](http://www.ruanyifeng.com/blog/2017/02/filename-should-be-lowercase.html)

语言元素命名规则建议：

    > 协议命名：代理模式下, XXXXDelegate；接口定义下：XXXXProtocol
    > 还没有添加，需要将_def.h中的清理出来，整理并规范

----------
### 使用建议

*	头文件引用，优先使用局部头文件，如：#import "_foundation.h" #import "_easycoding.h"

----------
### 后续建议
* [PonyCui/PPEtcHosts](https://github.com/PonyCui/PPEtcHosts)，应用内实现域名Host绑定，开发利器。
* [iOS单元测试：Specta + Expecta + OCMock + OHHTTPStubs + KIF](http://blog.csdn.net/colorapp/article/details/47007431)
* [JxbDebugTool](https://github.com/JxbSir/JxbDebugTool), 一个iOS调试工具，监控所有HTTP请求，自动捕获Crash分析。
* [A/B test search](https://github.com/search?l=Objective-C&q=a%2Fb+testing&ref=searchresults&type=Repositories&utf8=✓)
