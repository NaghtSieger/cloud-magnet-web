using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;
public partial class Public_SelectDay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
        }
        else
        {
            if (CPublicFun.GetInt(hY.Value) > CPublicFun.GetInt(hX.Value))
                hValue.Value = hValue1.Value;
        }

    }

    protected void Calendar2_SelectionChanged(object sender, EventArgs e)
    {
        hValue1.Value = Calendar2.SelectedDate.ToString("yyyy-MM-dd");
    }
}