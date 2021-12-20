# IMPProtocol

为`@protocol`提供默认实现。

也可有自定义实现，**优先级**：自定义实现 > 默认实现。

## 使用

### 协议

``` objc
@protocol NSJsoning <NSObject>

- (nullable NSDictionary *)toDict;

- (void)fromDict:(NSDictionary *)dict;

@end
```

### 实现

写`@impprotocol`与写`@implementation`一样。

**注意**：不能调用`@protocol`中未声明的方法，否则编译报错（找不到该方法）。

**处理**：如果有`@protocol`中未声明的方法，那么将此方法改为C语言函数。

``` objc
#import "IMPProtocol.h"

@impprotocol(NSJsoning)

- (nullable NSDictionary *)toDict {
    //  处理
    return nil;
}

- (void)fromDict:(NSDictionary *)dict {
    //  处理
    return nil;
}

@end
```

## 举例

### .h文件

采用协议即可。需要导入协议文件，否则调用时找不到协议中的方法。

``` objc
#import "NSJsoning.h"

@interface TestObject : NSObject <NSJsoning>

@property (nonatomic) NSString *name;
@property (nonatomic) int age;

@end
```

### .m文件

`@impprotocol`提供了默认的实现，因此不需要再写实现。

如果写了自定义实现，那么自定义实现有更高优先级（当提供了自定义实现时，实际上就没有默认方法了）。

``` objc
@implementation TestObject
@end
```

### 调用

``` objc
TestObject *t =  [TestObject new];
NSDictionary *dict = [t toDict];
```

## 扩展

默认提供了`NSCopying`、`NSCoding`、`NSJsoning`，可以自行扩展。


