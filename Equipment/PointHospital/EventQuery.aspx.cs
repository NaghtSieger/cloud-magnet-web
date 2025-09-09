using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Equipment_PointHospital_EventQuery : System.Web.UI.Page
{
    string m_sPoint = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        m_sPoint = CPublicFunction.GetRequestPara("Point");
        if (m_sPoint == "")
            m_sPoint = CPublicFunction.GetSessionItem("Point");
        if (m_sPoint == "")
            m_sPoint = "1";

        iTotal.Value = "0";
        iPages.Value = "1";
        Stat();
    }

    private void Stat()
    {
        string[] sCondition = CPublicFunction.GetRequestPara("Condi").Split(Convert.ToChar("|"));
        if (sCondition.Length < 5)
            return;
        string sEvent = "''";

        if (sCondition[2] == "1")
            sEvent += ",'3'";
        if (sCondition[3] == "1")
            sEvent += ",'2'";
        if (sCondition[4] == "1")
            sEvent += ",'1'";
        string sSql = "SELECT CONCAT(A.KSSJ,' ',A.KSHM) BJSJ,C.DMMS SJJB,B.SPDZ,CASE IFNULL(B.SPDZ,'A') WHEN 'A' THEN 'NONE' ELSE 'BLOCK' END DISP FROM (SELECT DWBH,SJJB,JCSB,KSSJ,KSHM,JSSJ FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SUBSTR(SBLX,1,1) IN ('1','2','3')) AND SJLX = '3' AND SJJB IN (" + sEvent + ") AND KSSJ >= DATE('" + sCondition[0] + "') AND KSSJ < DATE_ADD(DATE('" + sCondition[1] + "'),INTERVAL 1 DAY)) AS A LEFT JOIN EQP_EVENT_VEDIO AS B ON A.JCSB = B.SBBH AND A.KSSJ >= B.KSSJ AND A.JSSJ <= B.JSSJ LEFT JOIN (SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E07') AS C ON A.SJJB = C.DMZ ORDER BY A.KSSJ DESC,A.KSHM DESC";

        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9901010000", sSql, ref sFile, ref iRows);
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