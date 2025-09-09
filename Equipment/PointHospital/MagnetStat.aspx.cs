using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Equipment_PointHospital_MagnetStat : System.Web.UI.Page
{
    string m_sPoint = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        m_sPoint = CPublicFunction.GetRequestPara("Point");
        if (m_sPoint == "")
            m_sPoint = CPublicFunction.GetSessionItem("Point");
        if (m_sPoint == "")
            m_sPoint = "1";

        if (!Page.IsPostBack)
        {
            dStart.Value = DateTime.Today.ToString("yyyy-MM-dd");
            dEnd.Value = DateTime.Today.ToString("yyyy-MM-dd");
            Stat();
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
        if (nDanger.Checked)
            sEvent += ",'0'";
        string sSql = "SELECT CONCAT(A.KSSJ,' ',A.KSHM) BJSJ,C.DMMS SJJB,'' SPDZ FROM (SELECT DWBH,SJJB,JCSB,KSSJ,KSHM,JSSJ FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SUBSTR(SBLX,1,1) IN ('1','2','3')) AND SJJB IN (" + sEvent + ") AND KSSJ >= DATE('" + dStart.Value + "') AND KSSJ < DATE_ADD(DATE('" + dEnd.Value + "'),INTERVAL 1 DAY)) AS A LEFT JOIN (SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E07') AS C ON A.SJJB = C.DMZ ORDER BY A.KSSJ DESC,A.KSHM DESC";

        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9901030000", sSql, ref sFile, ref iRows);
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
}