using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Equipment_PointHospital_MagnetEvent : System.Web.UI.Page
{
    string m_sPoint = "";
    DateTime m_dStart = DateTime.Today;
    DateTime m_dEnd = DateTime.Today;
    int m_iType = 11;
    string m_sStart = "";
    string m_sEnd = "";
    private void GetParameter()
    {
        m_sPoint = CPublicFunction.GetRequestPara("Point");
        if (m_sPoint == "")
            m_sPoint = CPublicFunction.GetSessionItem("Point");
        if (m_sPoint == "")
            m_sPoint = "1";

        string sCondition = CPublicFunction.GetRequestPara("Condi");
        string[] sCondi = sCondition.Split(Convert.ToChar("|"));

        int iDays = CPublicFun.IsDate(sCondi[0]);
        if (iDays != -1000000000)
            m_dStart = m_dStart.AddDays(iDays);

        if (sCondi.Length > 1)
        {
            iDays = CPublicFun.IsDate(sCondi[1]);
            if (iDays != -1000000000)
                m_dEnd = m_dEnd.AddDays(iDays);
        }

        m_iType = CPublicFun.GetInt(CPublicFunction.GetRequestPara("Type"));
        if (m_iType % 10 == 2)
            m_dStart = m_dEnd.AddDays(-6);

        if (m_iType % 10 == 3)
            m_dStart = m_dEnd.AddMonths(-1).AddDays(1);

        m_sStart = m_dStart.ToString("yyyy-MM-dd");
        m_sEnd = m_dEnd.ToString("yyyy-MM-dd");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        GetParameter();
        Stat();

    }
    private void Stat()
    {
        string sSql = "SELECT DMMS,DMSM,SL,CASE WHEN ZL = 0 THEN '0.00%' ELSE CONCAT(FORMAT(SL * 100 /ZL,2),'%') END AS BL FROM (SELECT A.*,IFNULL(SL,0) SL,ZL FROM (SELECT DMZ,DMMS,DMSM FROM SYS_STANDERNOTE WHERE ZDLX = 'E07') AS A LEFT JOIN (SELECT IFNULL(SJJB,'0') SJLX,COUNT(*) SL FROM V_EQP_EVENT WHERE KSSJ >= DATE('" + m_sStart + "') AND KSSJ < DATE_ADD(DATE('" + m_sEnd + "'),INTERVAL 1 DAY) AND SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SUBSTR(SBLX,1,1) IN ('1','2','3')) GROUP BY SJJB) AS B ON A.DMZ = B.SJLX LEFT JOIN (SELECT COUNT(*) ZL FROM V_EQP_EVENT WHERE KSSJ >= DATE('" + m_sStart + "') AND KSSJ < DATE_ADD(DATE('" + m_sEnd + "'),INTERVAL 1 DAY) AND SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SUBSTR(SBLX,1,1) IN ('1','2','3'))) AS C ON 0 = 0) AS A ORDER BY A.DMZ";

        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9901020000", sSql, ref sFile, ref iRows);
        vhList.InnerHtml = sResult;
        vhList.DataBind();

    }
}