using CloudMagnetWeb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Stat_DataStat : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string sDepartment = CPublicFunction.GetSessionItem("Department");
        string m_sPerson = CPublicFunction.GetSessionItem("Person");
        if (m_sPerson == "")
        {
            Response.Write("<script type='text/javascript'>window.parent.location.reload();</script>");
            return;
        }
        if (!Page.IsPostBack)
        {
            CPublicFun.SetCombList(drpDepartment, "SELECT BMBM,BMMC FROM ACR_DEPARTMENT WHERE BMBM = '" + sDepartment + "' OR SJG(BMBM,0) = '" + sDepartment + "'", false, 1, "");
            CPublicFun.SetCombList(drpReport, "SELECT BBXH,BBMC FROM REP_DEFINE WHERE BBXH LIKE '02%' AND BBXH IN (SELECT DXXH FROM ACR_ACCREDIT WHERE ZTXH IN (SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '3' AND ZTXH = '" + m_sPerson + "') AND SQLB = '1') ORDER BY BBXH", true, 1, "");
            drpDepartment_SelectedIndexChanged(null, null);
            dStart.Value = DateTime.Today.ToString("yyyy-MM-dd");
            dEnd.Value = DateTime.Today.ToString("yyyy-MM-dd");
        }
        else
        {
            if (workflag.Value == "STAT")
                Stat();
            workflag.Value = "";
        }

    }

    private void Stat()
    {
        string sReport = "";
        if (drpReport.SelectedIndex > 0)
            sReport = drpReport.SelectedValue;
        if (sReport == "")
            return;

        string sOrganize = "";
        string sOrganizeName = "";
        if (drpDepartment.SelectedIndex >= 0)
        {
            sOrganize = drpDepartment.SelectedValue;
            sOrganizeName = drpDepartment.SelectedItem.Text;
        }
        string sPoint = "";
        string sPointName = "";
        if (drpPoint.SelectedIndex > 0)
        {
            sPoint = drpPoint.SelectedValue;
            sPointName = drpPoint.SelectedItem.Text;
        }

        string sFileName = "";
        int iRows = 0;

        string sResult = CPublicFun.Stat(sReport, sOrganize, sOrganizeName, sPoint,sPointName,dStart.Value, dEnd.Value, ref sFileName, ref iRows);
        hValue.Value = sFileName + System.DateTime.Now.ToString("yyyyMMddHHmmss");
        vhList.InnerHtml = sResult;
        vhList.DataBind();
    }
    protected void drpDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        CPublicFun.SetCombList(drpPoint, "SELECT DWBH,DWMC FROM EQP_LOCATION WHERE GLBM = '" + drpDepartment.SelectedValue + "' ORDER BY DWBH", true, 1, "");
    }
}