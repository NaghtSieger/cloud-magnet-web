using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Equipment_PointHospital_AISmall : System.Web.UI.Page
{
    string m_sSerial = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        m_sSerial = CPublicFunction.GetRequestPara("Serial");
        Stat();

    }

    private void Stat()
    {
        string sSql = "SELECT B.DMMS,CONCAT(SL,B.DMSM) SL FROM (SELECT CLASS_ID JCJG,COUNT(*) SL FROM DET_OBJECT WHERE DET_INFO_ID = '|Serial' GROUP BY CLASS_ID) AS A LEFT JOIN (SELECT DMZ,DMMS,DMSM FROM SYS_STANDERNOTE WHERE ZDLX = 'I01') AS B ON A.JCJG = B.DMZ ORDER BY A.JCJG";

        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9901040000", sSql.Replace("|Serial",m_sSerial), ref sFile, ref iRows);
        vhList.InnerHtml = sResult;
        vhList.DataBind();

    }
}