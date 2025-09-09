using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;


public partial class Equipment_PointHospital_HospitalMain : System.Web.UI.Page
{
    string m_sPoint = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        m_sPoint = CPublicFunction.GetRequestPara("Point");
        if (m_sPoint == "")
            m_sPoint = CPublicFunction.GetSessionItem("Point");
        if (m_sPoint == "")
            m_sPoint = hPoint.Value;
        if (m_sPoint == "")
            m_sPoint = "1";

        Session["Point"] = m_sPoint;
        hPoint.Value = m_sPoint;

        if (!Page.IsPostBack)
        {
            dStart.Value = DateTime.Today.ToString("yyyy-MM-dd");
            dEnd.Value = DateTime.Today.ToString("yyyy-MM-dd");
            dStartHis.Value = DateTime.Today.ToString("yyyy-MM-dd");
            dEndHis.Value = DateTime.Today.ToString("yyyy-MM-dd");
        }
        LoadPoint();
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

        hAI.Value = "";
        hCamUrl6.Value = "";
    }

    private void LoadPoint()
    {
        ClearPage();
        DataTable dtList = null;
        //加载点位名称
        string sSql = "SELECT CONCAT(BMMC,DWMC) DWMC FROM EQP_LOCATION A LEFT JOIN ACR_DEPARTMENT B ON A.GLBM = B.BMBM WHERE DWBH = '" + m_sPoint + "'";
        CPublicFunction.GetList(sSql, ref dtList);
        if (dtList != null && dtList.Rows.Count > 0)
        {
            pPoint.InnerText = dtList.Rows[0][0].ToString();
        }

        //加载三代设备
        sSql = "SELECT SBBH,SBMC,DMSM FROM EQP_EQUIPMENT A LEFT JOIN (SELECT DMZ,DMSM FROM SYS_STANDERNOTE WHERE ZDLX = 'E02') B ON SBLX = DMZ WHERE DWBH = '" + m_sPoint + "' AND SBLX LIKE '1%' AND YXBJ = '0' ORDER BY NBPX,SBBH";
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
        sSql = "SELECT A.SBBH,A.SBMC,IFNULL(C.SBXH,B.DMSM) SBXH,SBLX  FROM EQP_EQUIPMENT A LEFT JOIN (SELECT DMZ,DMSM FROM SYS_STANDERNOTE WHERE ZDLX = 'E02') B ON SBLX = DMZ LEFT JOIN MAG4_PARA C ON A.SBBH = C.SBBH WHERE DWBH = '" + m_sPoint + "' AND (SBLX LIKE '2%' OR SBLX LIKE '3%') AND YXBJ = '0' ORDER BY NBPX,SBBH";
        CPublicFunction.GetList(sSql, ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hType.Value = dtList.Rows[0][3].ToString();
            hLMagnet.Value = dtList.Rows[0][0].ToString();
            hLType.Value = dtList.Rows[0][2].ToString();
            hRType.Value = dtList.Rows[0][2].ToString();
        }
        if (iSize > 1)
        {
            hRMagnet.Value = dtList.Rows[1][0].ToString();
            hRType.Value = dtList.Rows[1][2].ToString();
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

        //加载室内环境监测监测设备 1-氧浓度 2-温度 3-湿度 4-烟感
        sSql = "SELECT SBBH,SBMC,B.DMZ FROM EQP_EQUIPMENT A,(SELECT DMZ FROM SYS_STANDERNOTE WHERE ZDLX = 'W03' AND DMSM = '|LX') B WHERE DWBH = '" + m_sPoint + "' AND SBLX IN (SELECT DMZ FROM SYS_STANDERNOTE WHERE ZDLX = 'E02' AND DMZ LIKE 'A%' AND DMSM LIKE '%|LX%') AND YXBJ = '0' ORDER BY NBPX,SBBH";
        CPublicFunction.GetList(sSql.Replace("|LX", "1"), ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hWost1.Value = dtList.Rows[0][0].ToString();
            hWName1.Value = dtList.Rows[0][1].ToString();
            hWType1.Value = dtList.Rows[0][2].ToString();
        }
        CPublicFunction.GetList(sSql.Replace("|LX", "2"), ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hWost2.Value = dtList.Rows[0][0].ToString();
            hWName2.Value = dtList.Rows[0][1].ToString();
            hWType2.Value = dtList.Rows[0][2].ToString();
        }
        CPublicFunction.GetList(sSql.Replace("|LX", "3"), ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hWost3.Value = dtList.Rows[0][0].ToString();
            hWName3.Value = dtList.Rows[0][1].ToString();
            hWType3.Value = dtList.Rows[0][2].ToString();
        }
        CPublicFunction.GetList(sSql.Replace("|LX", "4"), ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hWost4.Value = dtList.Rows[0][0].ToString();
            hWName4.Value = dtList.Rows[0][1].ToString();
            hWType4.Value = dtList.Rows[0][2].ToString();
        }

        //加载外部环境监测监测设备 1-氧浓度 2-温度 3-湿度 4-烟感
        sSql = "SELECT SBBH,SBMC,B.DMZ FROM EQP_EQUIPMENT A,(SELECT DMZ FROM SYS_STANDERNOTE WHERE ZDLX = 'W03' AND DMSM = '|LX') B WHERE DWBH = '" + m_sPoint + "' AND SBLX IN (SELECT DMZ FROM SYS_STANDERNOTE WHERE ZDLX = 'E02' AND DMZ LIKE 'C%' AND DMSM LIKE '%|LX%') AND YXBJ = '0' ORDER BY NBPX,SBBH";
        CPublicFunction.GetList(sSql.Replace("|LX", "1"), ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hOost1.Value = dtList.Rows[0][0].ToString();
            hOName1.Value = dtList.Rows[0][1].ToString();
            hOType1.Value = dtList.Rows[0][2].ToString();
        }
        CPublicFunction.GetList(sSql.Replace("|LX", "2"), ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hOost2.Value = dtList.Rows[0][0].ToString();
            hOName2.Value = dtList.Rows[0][1].ToString();
            hOType2.Value = dtList.Rows[0][2].ToString();
        }
        CPublicFunction.GetList(sSql.Replace("|LX", "3"), ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hOost3.Value = dtList.Rows[0][0].ToString();
            hOName3.Value = dtList.Rows[0][1].ToString();
            hOType3.Value = dtList.Rows[0][2].ToString();
        }
        CPublicFunction.GetList(sSql.Replace("|LX", "4"), ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hOost4.Value = dtList.Rows[0][0].ToString();
            hOName4.Value = dtList.Rows[0][1].ToString();
            hOType4.Value = dtList.Rows[0][2].ToString();
        }

        //加载智能预警设备
        sSql = "SELECT SBBH,GETXML(LJCS,'URLD') URL FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SBLX LIKE 'B1' AND YXBJ = '0' ORDER BY NBPX,SBBH";
        CPublicFunction.GetList(sSql, ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hAI.Value = dtList.Rows[0][0].ToString();
            hCamUrl6.Value = dtList.Rows[0][1].ToString();
        }
    }
}