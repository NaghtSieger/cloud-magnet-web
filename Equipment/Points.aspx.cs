using CloudMagnetWeb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Equipment_Points : System.Web.UI.Page
{
    string m_sDepartment = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        m_sDepartment = CPublicFunction.GetSessionItem("Department");
        if (m_sDepartment == "")
        {
            Response.Write("<script type='text/javascript'>window.parent.location.reload();</script>");
            return;
        }
        Stat();
    }


    private void Stat()
    {
        string sSql = "SELECT A.DWBH,C.DWMC,GETXML(B.LJCS,'URL') URL FROM (SELECT DWBH,MIN(CONCAT(RIGHT(CONCAT('00000000',CONVERT(NBPX,CHAR)),8),RIGHT(CONCAT('00000000',CONVERT(SBBH,CHAR)),8))) PXH FROM EQP_EQUIPMENT WHERE SBLX LIKE '0%' GROUP BY DWBH) A LEFT JOIN EQP_EQUIPMENT B ON A.DWBH = B.DWBH AND SUBSTR(A.PXH,9,8) = B.SBBH LEFT JOIN EQP_LOCATION C ON A.DWBH = C.DWBH WHERE C.GLBM LIKE CONCAT(CJG('" + m_sDepartment + "'),'%') ORDER BY C.GLBM,A.DWBH";

        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9902080000", sSql, ref sFile, ref iRows);
        vhList.InnerHtml = sResult;
        vhList.DataBind();
        iTotal.Value = iRows.ToString();
    }
}