using CloudMagnetWeb;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Main_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 在此处放置用户代码以初始化页面			
        if (CPublicFunction.GetUserName() != "")
        {
            Response.Redirect("Main.aspx");
            return;
        }

        string sError = "";
        if (Page.IsPostBack)
        {
            sError = CheckUser(txtLogName.Value.ToUpper(), txtPwd.Value);

            txtLogName.Value = "";
            txtPwd.Value = "";
            if (sError != "")
                CPublicFunction.MsgBox(sError);
            else
                Response.Redirect("Main.aspx");
        }
    }

    private string CheckUser(string sUserName, string sPassward)
    {
        //string sError = "";
        string sError = CPublicFunction.Login(sUserName, sPassward);
        if (sError == "")
        {
            DataTable dtList = null;
            sError = CPublicFunction.GetList("SELECT RYXM,A.LXDH,A.BMBM,GZBH,RYBH,B.BMMC,ZJHM FROM ACR_EMPLOYEE A LEFT JOIN ACR_DEPARTMENT B ON A.BMBM = B.BMBM WHERE A.RYZT = '0' AND A.DLYH = '" + sUserName + "'", ref dtList);
            if (dtList != null)
            {
                if (dtList.Rows.Count > 0)
                {
                    Session["UserName"] = sUserName;
                    Session["Name"] = dtList.Rows[0][0].ToString();
                    Session["Phone"] = dtList.Rows[0][1].ToString();
                    Session["Department"] = dtList.Rows[0][2].ToString();
                    Session["Police"] = dtList.Rows[0][3].ToString();
                    Session["Person"] = dtList.Rows[0][4].ToString();
                    Session["DepartmentName"] = dtList.Rows[0][5].ToString();
                    Session["SerailNumber"] = dtList.Rows[0][6].ToString();
                }
                dtList.Dispose();
            }
        }
        return sError;
    }
}