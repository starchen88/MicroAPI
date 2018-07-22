using System.Security.Principal;
using System.Web;

namespace MicroAPI.Demo
{
    /// <summary>
    /// Demo1 的摘要说明
    /// </summary>
    public class Demo1 : MicroAPI<IPrincipal>
    {
        static Demo1()
        {
            MicroAPI<IPrincipal>.GetState = context =>
            {
                if (context.User.Identity.IsAuthenticated)
                {
                    return context.User;
                }
                else
                {
                    return null;
                }
            };
        }
        public Demo1()
        {
            RegTextAction("get_user_name", getUserName);
        }

        string getUserName(HttpContext context, IPrincipal user)
        {
            return user.Identity.Name;
        }
    }
}