
#iOS规范

## 代码

1. 类头文件中写明该类的作用
2. 不易理解的业务逻辑需要文字说明
3. 修改一个不易理解的bug需要文字说明
4. 类.m中的方法需要分类放置.见参考1
5. 如果界面有输入框,注意是否禁用粘贴等功能
6. 如果你开启了一个延迟执行方法,注意要在适当的时机取消掉
7. 使用 `[[someClass alloc] init]` 不要使用 `[class new]`
8. 为一个类添加属性时,空格分割跟apple类一样, like this: `@property (nonatomic, readonly, strong) UILabel *textLabel`
9. 当使用`setter` `getter`方法的时候尽量使用点符号
10. 我们应该要在我们的`category`方法前加上自己的小写前缀以及下划线,比如 `- (id)noee_myCategoryMethod`
11. 当使用`enum`的时候,建议使用新的固定的基础类型定义`NS_ENUM()...`
12. 数据容器需要告知类型 `@property (nonatomic, readonly, strong) NSArray <NOEEBannerItem*>* contentItems`
13. 使用方法参数或者通过调用api获取的对象用于字典数组等时,必须判空处理,推荐使用 `<SafeObject.h>`
14. 绝不要使用以ab等跟业务毫无关系的命名常量变量或者方法
15. 当你有一个复杂的`if`子句的时候，你应该把它们提取出来赋给一个`BOOL`变量，这样可以让逻辑更清楚，而且让每个子句的意义体现出来
16. 条件语句体应该总是被大括号包围  
17. 除以一个数(通过接口获取),要加非零判断
```
if (!error) {
     return success;
}
```  

17. 在使用条件语句编程时尽量使用多个return可以避免增加循环的复杂度,并提高代码的可读性。因为方法的重要部分没有嵌套在分支里面，并且你可以很清楚地找到相关的代码  

```
    if (!urlString.length) {
        return;
    }  
    // do something...
```  

#### 方法分类参考

```
- pragma mark - View Lifecycle
- (void)dealloc {...}
- (instancetype)init {...}
- (void)viewDidLoad {...}
- (void)viewWillAppear:(BOOL)animated {...}
- (void)didReceiveMemoryWarning {...}
- (void)layoutSubViews {...}
...
 
#pragma mark - Super method
...

#pragma mark - setter
- (void)setCustomProperty:(id)value{...}
...

#pragma mark - Public
...

#pragma mark - Private
- (void)setUpViews {...}
- (void)doBusiness {...}
...

#pragma mark - Click Event
...
 
#pragma mark - Delegate
...
 
#pragma mark - Notice
...
 
#pragma mark - Getter
- (id)customProperty {...}
...

#pragma mark - Property
- (id)customProperty {...}
```

## Git

###Git Commit Message
格式: **type(scope): subject**  

**type** 表示类别,包括以下几点

1. **feat**: 新功能
2. **fix**: 修复bug 修复开发版本的bug **fix(dev)** 修复发布版本的bug **fix(dis)**
3. **style**: 格式
4. **refactor**: 代码重构
5. **chore**: 项目构建,打包

**scope** 表示范围或者开发环境还是发布环境

**subject** 表示具体描述  

### 修复线上bug
线上bug的修复必须切换到**fix**分支进行,修复完成后合并到开发分支上.提交信息需要带上bug引入的版本和当前修复时的版本.以方便查询修复历史.  

### Tag
在当前版本通过测试,确认发包后,打上带信息的tag,如: **v1.1.1**,tag的信息为当前版本开发的主要功能.