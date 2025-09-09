using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;
using System.Data;

public partial class Equipment_PointHospital_PointShow : System.Web.UI.Page
{
    string m_sPoint = "";
    private void Page_Load(object sender, System.EventArgs e)
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

    #region Web 窗体设计器生成的代码
    override protected void OnInit(EventArgs e)
    {
        //
        // CODEGEN: 该调用是 ASP.NET Web 窗体设计器所必需的。
        //

        //trOrganize.Attributes.Add("onclick", "javascript:return ClickTree(this,'txtDeptCode');");
        InitializeComponent();
        base.OnInit(e);
    }

    /// <summary>
    /// 设计器支持所需的方法 - 不要使用代码编辑器修改
    /// 此方法的内容。
    /// </summary>
    private void InitializeComponent()
    {
        this.Load += new System.EventHandler(this.Page_Load);

    }
    #endregion

    private void ClearPage()
    {
        hLEquipment.Value = "";
        hLType.Value = "";
        hREquipment.Value = "";
        hRType.Value = "";
        hCamera.Value = "";
    }

    private void LoadPoint()
    {
        ClearPage();
        //加载三代设备
        string sSql = "SELECT SBBH,GLSB,DMSM FROM EQP_EQUIPMENT A LEFT JOIN (SELECT DMZ,DMSM FROM SYS_STANDERNOTE WHERE ZDLX = 'E02') B ON SBLX = DMZ WHERE DWBH = '" + hPoint.Value + "' AND SBLX LIKE '1%' AND YXBJ = '0' ORDER BY NBPX,SBBH";
        DataTable dtList = null;
        CPublicFunction.GetList(sSql, ref dtList);
        int iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hType.Value = "1";
            hLEquipment.Value = dtList.Rows[0][0].ToString();
            if (hCamera.Value == "")
                hCamera.Value = dtList.Rows[0][1].ToString();
            hLType.Value = dtList.Rows[0][2].ToString();
        }
        if (iSize > 1)
        {
            hREquipment.Value = dtList.Rows[1][0].ToString();
            hRType.Value = dtList.Rows[1][2].ToString();
            if (hCamera.Value == "")
                hCamera.Value = dtList.Rows[0][1].ToString();
        }

        //加载四代设备
        sSql = "SELECT A.SBBH,A.GLSB,IFNULL(C.SBXH,B.DMSM) SBXH,SBLX FROM EQP_EQUIPMENT A LEFT JOIN (SELECT DMZ,DMSM FROM SYS_STANDERNOTE WHERE ZDLX = 'E02') B ON SBLX = DMZ LEFT JOIN MAG4_PARA C ON A.SBBH = C.SBBH WHERE DWBH = '" + hPoint.Value + "' AND (SBLX LIKE '2%' OR SBLX LIKE '3%') AND YXBJ = '0' ORDER BY NBPX,SBBH";
        CPublicFunction.GetList(sSql, ref dtList);
        iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        if (iSize > 0)
        {
            hType.Value = dtList.Rows[0][3].ToString();
            hLEquipment.Value = dtList.Rows[0][0].ToString();
            hLType.Value = dtList.Rows[0][2].ToString();
            hRType.Value = dtList.Rows[0][2].ToString();
            if (hCamera.Value == "")
                hCamera.Value = dtList.Rows[0][1].ToString();
        }
        if (iSize > 1)
        {
            hREquipment.Value = dtList.Rows[1][0].ToString();
            hRType.Value = dtList.Rows[1][2].ToString();
            if (hCamera.Value == "")
                hCamera.Value = dtList.Rows[1][1].ToString();
        }
    }
}