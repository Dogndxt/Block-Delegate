# Block-Delegate

详细解析 Block 和 Delegate 的使用，协议


## Delegate 的使用

代理delegate就是委托另一个对象来帮忙完成一件事情，为什么要委托别人来做呢，这其实是MVC设计模式中的模块分工问题，例如View对象它只负责显示界面，而不需要进行数据的管理，数据的管理和逻辑是Controller的责任，所以此时View就应该将这个功能委托给Controller去实现，当然你作为码农强行让View处理数据逻辑的任务，也不是不行，只是这就违背了MVC设计模式，项目小还好，随着功能的扩展，我们就会发现越写越难写；还有一种情况，就是这件事情做不到，只能委托给其他对象来做了，项目中通过源码进行了解释。


## Block 的使用

 block有如下几种使用情况，
 
 1、作为一个本地变量（local variable）
 
     returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
 
 2、作为@property
 
     @property (nonatomic, copy) returnType (^blockName)(parameterTypes);
 
 3、作为方法的参数（method parameter）
 
     - (void)someMethodThatTakesABlock:(returnType (^)(parameterTypes))blockName;
 
 4、作为方法参数的时候被调用
 
     [someObject someMethodThatTakesABlock: ^returnType (parameters) {...}];
 
 5、使用 typedef 来定义 block 类型，可以事半功倍
 
     typedef returnType (^TypeName)(parameterTypes);
     TypeName blockName = ^returnType(parameters) {...};
