using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Public_OpenWindow : System.Web.UI.Page
{
    protected string strTitle = "";
    protected string strInfo = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string strWork = CPublicFunction.GetRequestPara("PWORK").ToUpper();
            switch (strWork)
            {
                case "CALENDAR":
                    strTitle = "日期选择";
                    strInfo = "SelectDay.aspx";
                    //iWinOpen.Style.Add("width", "250px");
                    //iWinOpen.Style.Add("height", "265px");
                    break;
            }
        }
        Page.DataBind();
    }
}