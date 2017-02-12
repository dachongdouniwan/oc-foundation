# suite.great
oc framework 之 foundation , replace suite.oc/suite.basis.

----------
### 分割

1. [suite.basis](https://github.com/BinaryArtists/suite.basis)
	基础部件
2. [suite.tool](https://github.com/BinaryArtists/suite.tool)
	工具部件，包括了：utility、model、network、cache、database
	(note: 需要包含include文件夹，可以单一引用)
3. [suite.module-x]()
	模块化机制，service（参考BeeFramework），mediator等
4. [suite.debug](https://github.com/BinaryArtists/suite.debug)
	调试工具，架构基于module-x中的service
6. [sutie.ui](https://github.com/BinaryArtists/suite.compo)
	UI组件，主要分两部分：对系统视图层的扩展，和用到的第三方UI组件
7. [suite.hybrid](https://github.com/BinaryArtists/suite.hybrid)
	混合框架使用，该框架以weex为蓝本；兼顾对其他开源方案的学习与尝试
----------
### 使用注意

1. 设置头文件搜索路径
2. 包含以下系统库：









---------- 以下是无聊的成分，有空将其删除



----------
### suite.component 之 功能组件（

*有关于组件* 我要将组件类型分为：功能组件 package，UI组件 component，工具组件 service,

功能组件中有：
--business
----|XXManager: handle workflow
----|XXService: as dao
--View
----|XXViewController
----|XXView
--ViewModel
----|XXVM

----------

### suite.component 之 UI组件

    1. 二维码
        * [简书的讲解](http://www.jianshu.com/p/4772d3cb6a43)
        * [MQRCodeReaderViewController](https://github.com/zhengjinghua/MQRCodeReaderViewController)

    2. 

----------

### suite.oc 代码风格

	> 大部分文件，均为小写字母命名文件。
	> 很大可能重名的文件，以下划线开头。

1. 宏定义

	> _def.h：包裹所有宏定义文件

		>> _

	> 其他业务模块相关的定义文件，可以类似命名为：（当然，主要还是遵循iOS命名风格）

	> 写的比较全，当然也略显臃肿：https://github.com/6david9/CBExtension/tree/master/CBExtension/CBExtension/UtilityMacro

		>> AppDef.h：app相关定义，app版本，AppDelegate，等等
		>> UIDef.h：
		>> NetworkDef.h：网络模块，如果接口异常多，则再细化为ProtocolDef.h或者ApiDef.h
		>> NotificationDef.h：假设喜欢通知写在一起，则需要这个。
		>> TypeDef.h：各种类型定义

2. 文件命名、及其类命名
------------

### suite.oc 中的 “思考点”

1. 模块化中的粒度细分，和责任预想（做得不够简练，保留很多思考，保留冗余）

2. 不同的消息传送机制，及其选择时机
	* Block
	* delegate
	* target-action
	* KVO
	* Notification
	* signal


	* 参考：[iOS开发——OC篇消息传递机制（KVO／NOtification／Block／代理／Target－Action）](http://www.lxway.com/459448682.htm)、[IOS 如何选择delegate、notification、KVO？](http://blog.csdn.net/dqjyong/article/details/7685933)

3. Native、React-native、Hybrid中的合作，与技术选型，以及重要技术点

4. 网络模块
	* 参考YKNetwork的设计特点
		> Response can be cached by expiration time
		> Response can be cached by version number
		> Set common base URL and CDN URL
		> Validate JSON response
		> Resume download
		> block and delegate callback
		> Batch requests (see YTKBatchRequest)
		> Chain requests (see YTKChainRequest)
		> URL filter, replace part of URL, or append common parameter 
		> Plugin mechanism, handle request start and finish. A plugin for show "Loading" HUD is provided

	* 当前布置的特性：


