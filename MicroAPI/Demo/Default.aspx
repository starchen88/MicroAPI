<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MicroAPI.Demo.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>MicroAPI基本示例</title>
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
    <style>
        h1 {
            color: #7070a0;
            font-size: 150%;
            margin: 0 0 1em 0;
        }

        h2 {
            color: #7070a0;
            font-size: 120%;
            margin: 2em 0 0 0;
        }

        pre {
            border: solid 1px #BBBBDD;
            background-color: #F0FFF0;
            padding: 0.5em;
        }
    </style>
</head>
<body>
    <h1>基本示例</h1>

    <h2>获取服务器时间（纯文本格式）</h2>
    <p>1.服务器端逻辑</p>
    <pre>string get_server_time(HttpContext context) {
    return DateTime.Now.ToString();
}</pre>
    <p>2.在构造函数中注册一个操作</p>
    <pre>RegTextAction("get_server_time", get_server_time);</pre>
    <p>3.客户端调用，注意设置ajax地址的pathinfo部分</p>
    <pre>function show_server_time() {
    $.get("Demo.ashx/get_server_time", {}, function (data) {
        alert(data);
    }, "text");
}</pre>
    <p>试一下：<a href="javascript:show_server_time()">点击此处返回服务器时间</a></p>
    <script>
        function show_server_time() {
            $.get("Demo.ashx/get_server_time", {}, function (data) {
                alert(data);
            }, "text");
        }
    </script>

    <h2>获取服务器信息（json格式，动态类型）</h2>
    <p>1.服务器端逻辑</p>
    <pre>dynamic getServerInfo_json(HttpContext context)
{
    return new
    {
        MachineName = Environment.MachineName,
        Platform = Environment.OSVersion.Platform.ToString(),
        OSVersion = Environment.OSVersion.VersionString
    };
}</pre>
    <p>2.在构造函数中注册一个操作</p>
    <pre>RegJsonAction("get_server_info_json", getServerInfo_json);</pre>
    <p>3.客户端调用，注意设置ajax地址的pathinfo部分</p>
    <pre>function show_server_info_json() {
    $.get("Demo.ashx/get_server_info_json", {}, function (data) {
        alert(data);
    }, "text");
}</pre>
    <p>试一下：<a href="javascript:show_server_info_json()">点击此处返回服务器信息</a></p>
    <script>
        function show_server_info_json() {
            $.get("Demo.ashx/get_server_info_json", {}, function (data) {
                alert(data);
            }, "text");
        }
    </script>
    <h2>获取服务器信息（xml格式，静态类型）</h2>
    <p>1.服务器端逻辑</p>
    <pre>ServerInfo getServerInfo_xml(HttpContext context)
{
    return new ServerInfo
    {
        MachineName = Environment.MachineName,
        Platform = Environment.OSVersion.Platform.ToString(),
        OSVersion = Environment.OSVersion.VersionString
    };
}</pre>
    <p>2.在构造函数中注册一个操作</p>
    <pre>RegXmlAction("get_server_info_xml", getServerInfo_xml);</pre>
    <p>3.客户端调用，注意设置ajax地址的pathinfo部分</p>
    <pre>function show_server_info_xml() {
    $.get("Demo.ashx/get_server_info_xml", {}, function (data) {
        alert(data);
    }, "text");
}</pre>
    <p>试一下：<a href="javascript:show_server_info_xml()">点击此处返回服务器信息</a></p>
    <script>
        function show_server_info_xml() {
            $.get("Demo.ashx/get_server_info_xml", {}, function (data) {
                alert(data);
            }, "text");
        }
    </script>

    <h2>获取当前用户名（MicroAPI&lt;TState&gt;示例）</h2>
    <p>1.服务器端逻辑</p>
    <pre>MicroAPI&lt;IPrincipal&gt;.GetState = context =>
{
    if (context.User.Identity.IsAuthenticated)
    {
        return context.User;
    }
    else
    {
        return null;
    }
};</pre>
    <pre>public Demo1()
{
    RegTextAction("get_user_name", getUserName);
}

string getUserName(HttpContext context, IPrincipal user)
{
    return user.Identity.Name;
}</pre>
    <p>3.客户端调用</p>
    <pre>function show_user_name() {
    $.get("Demo1.ashx/get_user_name", {}, function (data) {
        alert(data);
    }, "text").error(function (jqXHR, textStatus, errorThrown) {
        alert(jqXHR.responseText);
    });
}</pre>
    <p>试一下：<a href="javascript:show_user_name()">点击此处返回用户信息</a>，由于还没有登录，此操作将抛出异常</p>
    <script>
        function show_user_name() {
            $.get("Demo1.ashx/get_user_name", {}, function (data) {
                alert(data);
            }, "text").error(function (jqXHR, textStatus, errorThrown) {
                alert(jqXHR.responseText);
            });
        }
    </script>

    <h2>获取服务器信息（MicroAPI&lt;TState&gt;示例）</h2>
    <p>1.服务器端逻辑</p>
    <pre>MicroAPI&lt;ServerInfo&gt;.GetState = context =>
{
    return new ServerInfo
    {
        MachineName = Environment.MachineName,
        Platform = Environment.OSVersion.Platform.ToString(),
        OSVersion = Environment.OSVersion.VersionString
    };
};</pre>
    <pre>public Demo2()
{           
    RegJsonAction("get_server_info", getServerInfo);
}
ServerInfo getServerInfo(HttpContext context, ServerInfo state)
{
    return state;
}</pre>
    <p>3.客户端调用</p>
    <pre>function show_server_info1() {
    $.get("Demo2.ashx/get_server_info", {}, function (data) {
        alert(data);
    }, "text");
}</pre>
    <p>试一下：<a href="javascript:show_server_info1()">点击此处返回服务器信息</a>,同上面的示例有区别，此处使用GetState获取服务器信息</p>
    <script>
        function show_server_info1() {
            $.get("Demo2.ashx/get_server_info", {}, function (data) {
                alert(data);
            }, "text");
        }
    </script>
</body>
</html>
