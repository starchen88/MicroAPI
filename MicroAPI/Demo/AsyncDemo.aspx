<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AsyncDemo.aspx.cs" Inherits="MicroAPI.Demo.AsyncDemo1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MicroAPI异步HttpHandler示例</title>
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
    <h1>异步HttpHandler示例</h1>
    <h2>使用方法</h2>
    <pre>public class AsyncDemo : MicroAPIAsync
{
    public AsyncDemo()
    {
        RegActionAsync("preview", preview);
    }

    public static void preview(HttpContext context)
    {
        var path = context.Server.MapPath("win7.jpg");
        using (var oldImage = new Bitmap(path))
        {
            using (Bitmap newImage = new Bitmap(150, 100))
            {
                System.Drawing.Drawing2D.InterpolationMode interpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                using (Graphics g = Graphics.FromImage(newImage))
                {
                    g.InterpolationMode = interpolationMode;
                    g.DrawImage(oldImage, new Rectangle(0, 0, newImage.Width, newImage.Height));

                    Font f = new Font("宋体", 14f);
                    g.DrawString(DateTime.Now.ToString("HH:mm:ss ffffff"), f, new SolidBrush(Color.White), 0f, 0f);
                }
                newImage.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                context.Response.ContentType = "image/jpeg";

            }
        }

    }
}</pre>
    <pre>public class SyncDemo : MicroAPI
{
    public SyncDemo()
    {
        RegAction("preview", AsyncDemo.preview);
    }
}</pre>
    <h2>异步演示</h2>
    <p>下面分别用异步和同步MicroAPI加载1000张缩略图，服务器段将加载图片并使用GDI+缩小尺寸并转换为jpg格式然后发送到客户端</p>
    <p>为了避免页面太大，对图片做了缩小展示，但使用原始尺寸展示首尾图片，你可以根据图片中显示的时间差粗略计算同步和异步的差距，用10年老龄ThinkPad测试异步比同步快40秒左右</p>
    <p>注意：由于浏览器本身的连接并发数限制，该示例并不能发挥异步请求的最大优势</p>
    <div>
        <script>
            for (var i = 0; i < 1000; i++) {
                if (i == 0 || i == 999) {
                    document.write("<img src='asyncdemo.ashx/preview?k=" + i + "' />");
                }
                else {
                    document.write("<img width=10 height=10 src='asyncdemo.ashx/preview?k=" + i + "' />");
                }
            }
        </script>
    </div>
    <h2>同步演示</h2>
    <div>
        <script>
            for (var i = 0; i < 1000; i++) {
                if (i == 0 || i == 999) {
                    document.write("<img src='syncdemo.ashx/preview?k=" + i + "' />");
                }
                else {
                    document.write("<img width=10 height=10 src='syncdemo.ashx/preview?k=" + i + "' />");
                }
            }
        </script>
    </div>
</body>
</html>
