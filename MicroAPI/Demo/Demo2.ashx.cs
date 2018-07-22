using System;
using System.Web;

namespace MicroAPI.Demo
{
    /// <summary>
    /// Demo2 的摘要说明
    /// </summary>
    public class Demo2 : MicroAPI<ServerInfo>
    {
        static Demo2()
        {
            MicroAPI<ServerInfo>.GetState = context =>
            {
                return new ServerInfo
                {
                    MachineName = Environment.MachineName,
                    Platform = Environment.OSVersion.Platform.ToString(),
                    OSVersion = Environment.OSVersion.VersionString
                };
            };
        }
        public Demo2()
        {           
            RegJsonAction("get_server_info", getServerInfo);
        }
        ServerInfo getServerInfo(HttpContext context, ServerInfo state)
        {
            return state;
        }
    }
}
