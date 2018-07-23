# MicroAPI

一个基于ASP.NET HttpHandler的易用、高性能、灵活的轻量级微服务组件。

## 功能特性

* 轻巧的微服务组件，让你的http接口实现起来更快速优雅

* 结构简单、高性能；提供异步版本，应对高并发场景

* 在同一HttpHandler中支持多个HttpContext操作，避免为每一个操作创建一个HttpHandler的繁琐

* 支持返回纯文本、json、xml，也支持自行处理HttpContext

* 对于json和xml，支持自定义设置序列化组件

* MIT协议，自由使用，开源开放，持续维护

## 入门须知

* MicroAPI通过`Request.PathInfo`值来匹配不同的操作，在调用时需要指定正确的PathInfo

* MicroAPI包含两个文件：MicroAPI.cs（同步版）、MicroAPIAsync.cs（异步版）

* MicroAPI包含四个类：`MicroAPI`(针对同步请求)、`MicroAPI<T>`（针对同步请求，针对需要对象参与操作的情况）、`MicroAPIAsync`（针对异步请求）、`MicroAPIAsync<T>`（针对异步请求，针对需要对象参与操作的情况）

* 使用`MicroAPI<T>`和`MicroAPIAsync<T>`之前需要先设置其GetState委托以告知如何获取T，比如当Action仅限具名用户访问、拒绝用户访问时，将T设置为用户类型，然后设置GetState为获取当前用户的逻辑，那么在调用Action之前将判断T是否为空，如果为空可能拒绝调用Action(取决于StateNullHandler配置)

* `MicroAPIAsync`和`MicroAPIAsync<T>`的注册方法为RegXXXActionAsync，之所以添加Async是为未来可能的同步和异步MicroAPI合并为单一类避免冲突、保持向后兼容

* MicroAPI提供四个方法`RegAction、RegTextAction、RegJsonAction、RegXmlAction`，分别针对不同的返回数据，包含两个参数：第一个参数为使用PathInfo匹配的字符串，区分大小写，不包含/；第二个参数为一个参数为HttpContext的委托，MicroAPI<T>和MicroAPIAsync<T>的RegXXXAction的第二个参数委托还包含T参数。定义如下：
*  `protected void RegAction(string name, Action<HttpContext> action)`
*  `protected void RegTextAction(string name, Func<HttpContext, string> action)`
*  `protected void RegJsonAction<T>(string name, Func<HttpContext, T> action)`
*  `protected void RegXmlAction<T>(string name, Func<HttpContext, T> action)`

* MicroAPI提供了JsonSerializeFunc（自定义Json序列化）、XmlSerializeFunc（自定义Xml序列化）、ExceptionHandler（自定义异常处理）三个配置项，均为静态成员，你可以在Global.asax或App_Start中设置；由于时静态成员，请注意保持您的设置方法的线程安全性

* 当前尚不支持区分get和post，敬请期待下一版本

* 支持版本>=.NET 4.0，如果你需要在.NET 2.0使用，只需要进行少量修改即可

## 简单示例

Demo文件夹中的Default.aspx包含常用的几种Demo；AsyncDemo.aspx中包含异步MicroAPI和异步版的粗略比较

服务器端示例：

```
public class Demo : MicroAPI
{
    public Demo()
    {
        RegTextAction("get_server_time", getServerTime);
        RegJsonAction("get_server_info_json", getServerInfo_json);
        RegXmlAction("get_server_info_xml", getServerInfo_xml);
    }
    string getServerTime(HttpContext context)
    {
        return DateTime.Now.ToString();
    }
    dynamic getServerInfo_json(HttpContext context)
    {
        return new
        {
            MachineName = Environment.MachineName,
            Platform = Environment.OSVersion.Platform.ToString(),
            OSVersion = Environment.OSVersion.VersionString
        };
    }
    ServerInfo getServerInfo_xml(HttpContext context)
    {
        return new ServerInfo
        {
            MachineName = Environment.MachineName,
            Platform = Environment.OSVersion.Platform.ToString(),
            OSVersion = Environment.OSVersion.VersionString
        };
    }
}
```

客户端示例，注意PathInfo段：

```
function show_server_time() {
    $.get("Demo.ashx/get_server_time", {}, function (data) {
        alert(data);
    }, "text");
}
```

## 使用方法

1. 下载本项目中MicroAPI.cs或MicroAPIAsync.cs并放到项目中

2. 创建一般处理程序（.ashx或HttpHandler类）并修改继承自IHttpHandler为MicroAPI或MicroAPIAsync

3. 编写Action逻辑，输入参数为HttpContext,输出参数为void/string/T

4. 在一般处理程序中注册Action，一般在构造函数中进行，按需调用RegAction/RegTextAction/RegJsonAction/RegXmlAction注册操作

5. 客户端访问一般处理程序，如xxx.ashx/action1

未尽之处请参见Demo，或加入QQ群:163203102

## 最佳实践

* 关于如何选择同步和异步MicroAPI：对于简单操作，建议使用同步MicroAPI,省略不必要的线程开销；对于涉及磁盘IO、网络IO、数据库操作等本身就是异步行为的操作，推荐使用异步MicroAPI

* MicroAPI默认使用`System.Web.Script.Serialization.JavaScriptSerializer`和`System.Xml.Serialization.XmlSerializer`，建议你更改为自己常用的序列化组件

* 开源不宜，长期坚持更难，如果对你有用，请不要吝啬你的关注、建议、加星、推广、捐赠

## 下一步

* 收集bug问题和修改意见，修复完善

* 增加英文文档

* 增加对get和post的区分

* 设计下一版本，初步考虑将同步和异步合并为单一类

* 研究移植到ASP.NET Core的可能性