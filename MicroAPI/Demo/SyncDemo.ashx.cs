using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MicroAPI.Demo
{
    /// <summary>
    /// SyncDemo 的摘要说明
    /// </summary>
    public class SyncDemo : MicroAPI
    {
        public SyncDemo()
        {
            RegAction("preview", AsyncDemo.preview);
        }
    }
}