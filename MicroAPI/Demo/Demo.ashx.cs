using System;
using System.Web;
using System.Web.SessionState;

namespace MicroAPI.Demo
{
    /// <summary>
    /// Demo 的摘要说明
    /// </summary>
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
    public class ServerInfo
    {
        public string MachineName { get; set; }
        public string Platform { get; set; }
        public string OSVersion { get; set; }
    }
}
