<%@ Application Language="C#" %>
<%@ Import Namespace="CloudMagnetWeb" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="System.Web.Routing" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        //读取配置参数
        if (ConfigurationManager.AppSettings["Connect"] != null)
            MysqlConnect.ConnString = ConfigurationManager.AppSettings["Connect"];

        RouteConfig.RegisterRoutes(RouteTable.Routes);
        BundleConfig.RegisterBundles(BundleTable.Bundles);
    }

</script>
