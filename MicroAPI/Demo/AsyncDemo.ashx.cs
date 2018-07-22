using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;

namespace MicroAPI.Demo
{
    /// <summary>
    /// AsyncDemo 的摘要说明
    /// </summary>
    public class AsyncDemo : MicroAPIAsync
    {
        public AsyncDemo()
        {
            RegActionAsync("preview", preview);
        }
        string getServerTime(HttpContext context)
        {
            return DateTime.Now.ToString();
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
    }
}