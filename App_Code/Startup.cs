using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CloudMagnetWeb.Startup))]
namespace CloudMagnetWeb
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
