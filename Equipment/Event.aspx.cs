using CloudMagnetWeb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Equipment_Event : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string sDepartment = CPublicFunction.GetSessionItem("Department");
        if (sDepartment == "")
        {
            Response.Write("<script type='text/javascript'>window.parent.location.reload();</script>");
            return;
        }
        if (!Page.IsPostBack)
        { 
            CPublicFun.SetCombList(drpDepartment, "SELECT BMBM,BMMC FROM ACR_DEPARTMENT WHERE BMBM = '" + sDepartment + "' OR SJG(BMBM,0) = '" + sDepartment + "'", false, 1, "");
            CPublicFun.SetCombList(drpEType, "SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E02' AND LENGTH(DMZ) = 1 AND DMZ > '0'", true, 1, "");
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
        string sEvent = "''";
        if (hDanger.Checked)
            sEvent += ",'3'";
        if (mDanger.Checked)
            sEvent += ",'2'";
        if (lDanger.Checked)
            sEvent += ",'1'";
        string sSql = "SELECT CONCAT(A.KSSJ,' ',A.KSHM) BJSJ,C.DMMS SJJB,D.DWMC,E.SBMC,B.SPDZ,CASE IFNULL(B.SPDZ,'A') WHEN 'A' THEN 'NONE' ELSE 'BLOCK' END DISP FROM (SELECT DWBH,SBBH,SJJB,JCSB,KSSJ,KSHM,JSSJ FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH IN (SELECT DWBH FROM EQP_LOCATION WHERE GLBM LIKE CONCAT(CJG('|GLBM'),'%')) |CONDI) AND SJLX = '3' AND SJJB IN (|SJJB) AND KSSJ >= DATE('|KSSJ') AND KSSJ < DATE_ADD(DATE('|JSSJ'),INTERVAL 1 DAY)) AS A LEFT JOIN EQP_EVENT_VEDIO AS B ON A.JCSB = B.SBBH AND A.KSSJ >= B.KSSJ AND A.JSSJ <= B.JSSJ LEFT JOIN (SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E07') AS C ON A.SJJB = C.DMZ LEFT JOIN EQP_LOCATION D ON A.DWBH = D.DWBH LEFT JOIN EQP_EQUIPMENT E ON A.SBBH = E.SBBH ORDER BY A.KSSJ DESC,A.KSHM DESC";

        string sCondi = "";
        if (drpPoint.SelectedValue != "")
            sCondi += " AND DWBH = '" + drpPoint.SelectedValue + "'";

        if (drpEType.SelectedValue != "")
            sCondi += " AND SBLX LIKE '" + drpEType.SelectedValue + "%'";

        sSql = sSql.Replace("|GLBM", drpDepartment.SelectedValue).Replace("|CONDI", sCondi).Replace("|SJJB", sEvent).Replace("|KSSJ", dStart.Value).Replace("|JSSJ", dEnd.Value);
        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9902050000", sSql, ref sFile, ref iRows);
        vhList.InnerHtml = sResult;
        vhList.DataBind();
        iTotal.Value = iRows.ToString();
        if ((iRows % 10) == 0)
            iRows /= 10;
        else
            iRows = (iRows - iRows % 10) / 10 + 1;
        if (iRows == 0)
            iRows = 1;
        hPage.Value = "0";
        iPages.Value = iRows.ToString();
    }

    protected void drpDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        CPublicFun.SetCombList(drpPoint, "SELECT DWBH,DWMC FROM EQP_LOCATION WHERE GLBM = '" + drpDepartment.SelectedValue + "' ORDER BY DWBH",true,1,"");
    }

}