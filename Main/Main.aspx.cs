using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Main : System.Web.UI.Page
{
    string m_sPerson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        m_sPerson = CPublicFunction.GetSessionItem("Person");
        if (m_sPerson == "")
        {
            Response.Redirect("LogIn.aspx");
            return;
        }
        LoadMenu();

    }

    private void LoadMenu()
    {
        string sSql = "SELECT GNLX,GNMC,GLDZ FROM ACR_FUNCTION WHERE GNLX = '2' AND (KJXZ = '0' OR GNBM IN (SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '2' AND ZTXH = '|KEY' UNION SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '1' AND ZTXH IN (SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '3' AND ZTXH = '|KEY'))) ORDER BY GNBM";
        sSql = sSql.Replace("|KEY", m_sPerson);

        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9902010000", sSql, ref sFile, ref iRows);
        dvMenu.InnerHtml = sResult;

        dvMenu.DataBind();
    }

}