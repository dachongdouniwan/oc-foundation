几乎是从samurai-core中拷贝过来的，^_^

----------
### 分割

1. [suite.great](https://github.com/BinaryArtists/suite.great)
	基础部件
2. [suite.tool](https://github.com/BinaryArtists/suite.tool)
	工具部件，包括了：utility、model、network、cache、database
	(note: 需要包含include文件夹，可以单一引用)
3. [suite.module-x](https://github.com/BinaryArtists/suite.module-x)
	模块化机制，service（参考BeeFramework），mediator等
4. [suite.debug](https://github.com/BinaryArtists/suite.debug)
	调试工具，架构基于module-x中的service
6. [sutie.ui](https://github.com/BinaryArtists/suite.compo)
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

----------
### suite.great 中反人类的代码风格！！

	> 大部分文件，均为小写字母命名文件。
	> 很大可能重名的文件，以下划线开头。