using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Equipment_PointHospital_PointShowIn : System.Web.UI.Page
{
    string m_sPoint = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        m_sPoint = CPublicFunction.GetRequestPara("Point");
        if (m_sPoint == "")
            m_sPoint = CPublicFunction.GetSessionItem("Point");
        if (m_sPoint == "")
            m_sPoint = "1";

        Session["Point"] = m_sPoint;
        hPoint.Value = m_sPoint;

        if (!Page.IsPostBack)
        {
            LoadPoint();
        }

    }

    private void ClearPage()
    {
        hLMagnet.Value = "";
        hLType.Value = "";
        hRMagnet.Value = "";
        hRType.Value = "";
        hType.Value = "";

        hCamera1.Value = "";
        hCamera2.Value = "";
        hCamera3.Value = "";
        hCamera4.Value = "";

        hCamName1.Value = "";
        hCamName2.Value = "";
        hCamName3.Value = "";
        hCamName4.Value = "";

        hWost1.Value = "";
        hWName1.Value = "";
        hWost2.Value = "";
        hWName2.Value = "";
    }

    private void LoadPoint()
    {
        ClearPage();
        //加载三代设备
        string sSql = "SELECT SBBH,SBMC,DMSM FROM EQP_EQUIPMENT A LEFT JOIN (SELECT DMZ,DMSM FROM SYS_STANDERNOTE WHERE ZDLX = 'E02') B ON SBLX = DMZ WHERE DWBH = '" + m_sPoint + "' AND SBLX LIKE '1%' AND YXBJ = '0' ORDER BY NBPX,SBBH";
        DataTable dtList = null;
        CPublicFunction.GetList(sSql, ref dtList);
        int iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hType.Value = "1";
            hLMagnet.Value = dtList.Rows[0][0].ToString();
            hLType.Value = dtList.Rows[0][2].ToString();
        }
        if (iSize > 1)
        {
            hRMagnet.Value = dtList.Rows[1][0].ToString();
            hRType.Value = dtList.Rows[1][2].ToString();
        }

        //加载四代设备
        sSql = "SELECT A.SBBH,A.SBMC,IFNULL(C.SBXH,B.DMSM) SBXH  FROM EQP_EQUIPMENT A LEFT JOIN (SELECT DMZ,DMSM FROM SYS_STANDERNOTE WHERE ZDLX = 'E02') B ON SBLX = DMZ LEFT JOIN MAG4_PARA C ON A.SBBH = C.SBBH WHERE DWBH = '" + m_sPoint + "' AND SBLX LIKE '2%' AND YXBJ = '0' ORDER BY NBPX,SBBH";
        CPublicFunction.GetList(sSql, ref dtList);
        if (dtList != null && dtList.Rows.Count > 0)
        {
            hType.Value = "2";
            hLMagnet.Value = dtList.Rows[0][0].ToString();
            hLType.Value = dtList.Rows[0][2].ToString();
            hRType.Value = dtList.Rows[0][2].ToString();
        }

        //加载摄像头
        sSql = "SELECT SBBH,SBMC,GETXML(LJCS,'URL') URL FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SBLX LIKE '0%' AND YXBJ = '0' ORDER BY NBPX,SBBH";
        CPublicFunction.GetList(sSql, ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hCamera1.Value = dtList.Rows[0][0].ToString();
            hCamName1.Value = dtList.Rows[0][1].ToString();
            hCamUrl1.Value = dtList.Rows[0][2].ToString();
        }
        if (iSize > 1)
        {
            hCamera2.Value = dtList.Rows[1][0].ToString();
            hCamName2.Value = dtList.Rows[1][1].ToString();
            hCamUrl2.Value = dtList.Rows[1][2].ToString();
        }
        if (iSize > 2)
        {
            hCamera3.Value = dtList.Rows[2][0].ToString();
            hCamName3.Value = dtList.Rows[2][1].ToString();
            hCamUrl3.Value = dtList.Rows[2][2].ToString();
        }
        if (iSize > 3)
        {
            hCamera4.Value = dtList.Rows[3][0].ToString();
            hCamName4.Value = dtList.Rows[3][1].ToString();
            hCamUrl4.Value = dtList.Rows[3][2].ToString();
        }

        //加载环境监测设备
        sSql = "SELECT SBBH,SBMC FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SBLX LIKE 'A%' AND YXBJ = '0' ORDER BY NBPX,SBBH";
        CPublicFunction.GetList(sSql, ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hWost1.Value = dtList.Rows[0][0].ToString();
            hWName1.Value = dtList.Rows[0][1].ToString();
        }
        if (iSize > 1)
        {
            hWost2.Value = dtList.Rows[0][0].ToString();
            hWName2.Value = dtList.Rows[0][1].ToString();
        }
    }
}