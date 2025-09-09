using CloudMagnetWeb;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Equipment_Point : System.Web.UI.Page
{
    string m_sPerson = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        m_sPerson = CPublicFunction.GetSessionItem("Person");
        if (m_sPerson == "")
        {
            Response.Write("<script type='text/javascript'>window.parent.location.reload();</script>");
            return;
        }
        bool bOk = false;
        if (!Page.IsPostBack)
            InitPage();
        else if (hSubmit.Value == "1")
        {
            switch (workflag.Value)
            {
                case "CancelModify":
                    LoadPointItem();
                    bOk = true;
                    break;
                case "btPNew":
                    bOk = UpdatePoint(true);
                    break;
                case "btPUpdate":
                    bOk = UpdatePoint(false);
                    break;
                case "btPDelete":
                    bOk = DeletePoint();
                    break;
                case "btPReset":
                    bOk = ResetPoint();
                    break;
                case "btPCopy":
                    bOk = CopyPoint();
                    break;
                case "btENew":
                    bOk = UpdateEquipment(true);
                    break;
                case "btEUpdate":
                    bOk = UpdateEquipment(false);
                    break;
                case "btEDelete":
                    bOk = DeleteEquipment();
                    break;
                case "btECheck":
                    bOk = CheckEquipment();
                    break;
                case "btEStop":
                    bOk = StopEquipment();
                    break;
                case "btSort":
                    SortEquipment();
                    bOk = true;
                    break;
            }
        }
        if (bOk)
        {
            workflag.Value = "";
            lbOperate.Text = "";
        }
        hSubmit.Value = "0";
    }

    private void InitPage()
    {
        hPermission.Value = "0";
        if (CPublicFunction.CheckPermission("0100000000") || CPublicFunction.CheckPermission("0101010100"))
            hPermission.Value = "1";
        hDepartment.Value = CPublicFunction.GetSessionItem("Department");
        CPublicFun.SetCombList(drpDepartment, "SELECT BMBM,BMMC FROM ACR_DEPARTMENT WHERE BMBM = '" + hDepartment.Value + "' OR SJG(BMBM,0) = '" + hDepartment.Value + "'", false, 1, hDepartment.Value);
        CPublicFun.SetCombList(drpEType, "SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E02' AND ZT = '0' AND LENGTH(DMZ) = 1 ORDER BY DMZ", false, 1,"");
        drpEType_SelectedIndexChanged(null, null);
        CPublicFun.SetCombList(drpEState, "SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E03' AND ZT = '0' ORDER BY DMZ", false, 1,"");
        CPublicFun.SetCombList(drpEConnect, "SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E08' AND ZT = '0' ORDER BY DMZ", false, 1,"");
        CPublicFun.SetCombList(Connect2_Parity, "SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E04' AND ZT = '0' ORDER BY DMZ", false, 1, "");
        CPublicFun.SetCombList(Connect2_StopBits, "SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E05' AND ZT = '0' ORDER BY DMZ", false, 1, "");
        LoadPointList();
    }

    private void LoadPointList()
    {
        CPublicFun.SetNewListBox(lbxPoint, "SELECT DWBH,DWMC FROM EQP_LOCATION WHERE GLBM = '" + hDepartment.Value + "' ORDER BY DWBH", 2, txtPSerial.Value);
        LoadPointItem();
    }

    private void ClearData(short iType)
    {
        if (iType == 1)
        {
            txtPName.Value = "";
            txtPLocation.Value = "";
            txtPIP.Value = "";
            txtPPort.Value = "";
            txtPHeart.Value = "";
            txtPStart.Value = "";
            txtPState.Value = "";
        }
        else
        {
            txtEFactory.Value = "";
            txtEName.Value = "";
            txtENumber.Value = "";
            txtEOverhaul.Value = "";
            txtEPerson.Value = "";
            txtEPhone.Value = "";
            txtESort.Value = "";
            drpEConnect.SelectedIndex = -1;
            drpERelation.SelectedIndex = -1;
            drpEState.SelectedIndex = 0;
            if (drpEModel.Items.Count > 0)
                drpEModel.Items.Clear();
            drpEType.SelectedIndex = -1;
        }
    }
    
    private void LoadPointItem()
    {
        if (lbxPoint.SelectedIndex >= 0)
            txtPSerial.Value = lbxPoint.SelectedValue.ToString();
        else
            txtPSerial.Value = "";

        ClearData(1);

        DataTable dtList = null;
        CPublicFunction.GetList("SELECT A.*,B.DMMS FROM (SELECT A.DWBH,A.DWMC,A.DWWZ,B.GLFW,B.GLDK,B.DWZT,B.QDSJ,B.XTSJ,B.CTCS FROM EQP_LOCATION AS A LEFT JOIN EQP_LOCATION_LOG AS B ON A.DWBH = B.DWBH WHERE A.DWBH = '" + txtPSerial.Value + "') AS A LEFT JOIN (SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E01') AS B ON A.DWZT = B.DMZ", ref dtList);

        if (dtList != null && dtList.Rows.Count > 0)
        {
            txtPName.Value = dtList.Rows[0][1].ToString();
            txtPLocation.Value = dtList.Rows[0][2].ToString();
            txtPIP.Value = dtList.Rows[0][3].ToString();
            txtPPort.Value = dtList.Rows[0][4].ToString();
            txtPHeart.Value = dtList.Rows[0][7].ToString();
            txtPStart.Value = dtList.Rows[0][6].ToString();
            txtPState.Value = dtList.Rows[0][9].ToString();
            txtPConflict.Value = dtList.Rows[0][8].ToString();
        }
        LoadEquipmentList();
        if (dtList != null)
            dtList.Dispose();
    }

    private void LoadEquipmentList()
    {
        CPublicFun.SetCombList(drpERelation, "SELECT SBBH,SBMC FROM EQP_EQUIPMENT WHERE DWBH = '" + txtPSerial.Value + "' AND YXBJ = '0' AND SBZT = '0' AND SBLX LIKE '0%' ORDER BY NBPX,SBBH", true, 1, "");
        CPublicFun.SetNewListBox(lbxEquipment, "SELECT SBBH,SBMC FROM EQP_EQUIPMENT WHERE DWBH = '" + txtPSerial.Value + "' ORDER BY YXBJ,NBPX,SBBH", 2, txtESerial.Value);
        LoadEquipmentItem();
    }

    private void SetConnectPara(string sXML)
    {
        DataSet dsList = null;
        CPublicFun.ReadXML(sXML,ref dsList);
        if (dsList != null && dsList.Tables.Count > 0 && dsList.Tables[0].Rows.Count > 0)
        {
            string sType = drpEConnect.SelectedValue;
            int iSize = dsList.Tables[0].Columns.Count;
            for (int i = 0; i < iSize; i++)
            {
                string sValue = dsList.Tables[0].Rows[0][i].ToString();
                Control ctlConnect = FindControl("Connect" + sType + "_" + dsList.Tables[0].Columns[i].ColumnName);
                if (ctlConnect != null)
                {
                    switch (ctlConnect.GetType().Name)
                    {
                        case "DropDownList":
                            ((System.Web.UI.WebControls.DropDownList)ctlConnect).SelectedValue = sValue;
                            break;
                        case "HtmlTextArea":
                            ((System.Web.UI.HtmlControls.HtmlTextArea)ctlConnect).Value = sValue;
                            break;
                        case "HtmlInputText":
                            ((System.Web.UI.HtmlControls.HtmlInputText)ctlConnect).Value = sValue;
                            break;
                    }
                }
            }
        }
    }

    private void LoadEquipmentItem()
    {
        if (lbxEquipment.SelectedIndex >= 0)
            txtESerial.Value = lbxEquipment.SelectedValue.ToString();
        else
            txtESerial.Value = "";

        ClearData(2);
        DataTable dtList = null;
        CPublicFunction.GetList("SELECT SBBH,SBMC,SBXLH,SUBSTR(SBLX,1,1) AS SBLX1,SBLX,SCCS,JXRQ,ZRR,LXDH,NBPX,GLSB,YXBJ,LJFS,LJCS FROM EQP_EQUIPMENT WHERE SBBH = '" + txtESerial.Value + "'", ref dtList);

        if (dtList != null && dtList.Rows.Count > 0)
        {
            txtEName.Value = dtList.Rows[0][1].ToString();
            txtENumber.Value = dtList.Rows[0][2].ToString();
            drpEType.SelectedValue = dtList.Rows[0][3].ToString();
            drpEType_SelectedIndexChanged(null, null);
            drpEModel.SelectedValue = dtList.Rows[0][4].ToString();
            txtEFactory.Value = dtList.Rows[0][5].ToString();
            txtEOverhaul.Value = dtList.Rows[0][6].ToString();
            txtEPerson.Value = dtList.Rows[0][7].ToString();
            txtEPhone.Value = dtList.Rows[0][8].ToString();
            txtESort.Value = dtList.Rows[0][9].ToString();
            drpERelation.SelectedValue = dtList.Rows[0][10].ToString();
            drpEState.SelectedValue = dtList.Rows[0][11].ToString();
            drpEConnect.SelectedValue = dtList.Rows[0][12].ToString();
            SetConnectPara(dtList.Rows[0][13].ToString());
        }

        if (dtList != null)
            dtList.Dispose();
    }

    protected void drpEType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (drpEType.SelectedIndex >= 0)
        {
            CPublicFun.SetCombList(drpEModel, "SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'E02' AND ZT = '0' AND LENGTH(DMZ) = 2 AND DMZ LIKE '" + drpEType.SelectedValue +"%' ORDER BY DMZ", false, 1,"");
        }
    }

    protected void drpDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (drpDepartment.SelectedIndex >= 0)
        {
            hDepartment.Value = drpDepartment.SelectedValue;
            if (workflag.Value == "")
                LoadPointList();
        }
    }

    protected void drpEConnect_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

    protected void lbxEquipment_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadEquipmentItem();
    }

    protected void lbxPoint_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadPointItem();
    }

    private string CheckPRepeat(string sPoint,string sType,string sValue, string sName)
    {
        if (sValue == "")
            return "";
        string sError = "";
        DataTable dtList = null;
        sError = CPublicFunction.GetList("SELECT DWBH FROM EQP_LOCATION WHERE GLBM = '" + hDepartment.Value + "' AND " + sType + " = '" + sValue + "' AND DWBH <> '" + sPoint + "'", ref dtList);
        if (sError == "" && dtList != null && dtList.Rows.Count > 0)
            sError = sName + "重复，请核实";
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    private bool UpdatePoint(bool bInsert)
    {
        bool bOk = false;
        string sError = Update_Point(bInsert);
        if (sError == "")
        {
            bOk = true;
            if (bInsert)
                sError = "点位新增成功！";
            else
                sError = "点位修改成功！";
            LoadPointList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private string Update_Point(bool bInsert)
    {
        string sError = "";

        RowItem[] saData = CPublicFunction.MakeRowItems(4);
        saData[0].SetData("N", 0, txtPSerial.Value);
        saData[1].SetData("C", 60, txtPName.Value.Trim());
        saData[2].SetData("C", 128, txtPLocation.Value.Trim());
        saData[3].SetData("C", 12, hDepartment.Value);


        string sSql = "UPDATE EQP_LOCATION SET DWMC = ?1,DWWZ = ?2,GXSJ  = NOW() WHERE DWBH = ?0";
        string sKey = txtPSerial.Value;
        if (bInsert)
        {
            sSql = "INSERT INTO EQP_LOCATION(DWMC,DWWZ,GLBM,GXSJ) VALUES(?1,?2,?3,NOW())";
            sKey = "0";
        }

        //CheckData
        if (txtPName.Value.Trim() == "")
            sError = "点位名称不能为空";
        if (sError == "")
            sError = CheckPRepeat(sKey,"DWMC",txtPName.Value.Trim(),"点位名称");

        //UpdateData
        if (sError == "")
            sError = CPublicFunction.UpdateRow(sSql, saData, 4, ref sKey);

        if (sError == "")
        {
            if (bInsert)
                txtPSerial.Value = sKey;
        }
        return sError;
    }

    private bool DeletePoint()
    {
        bool bOk = false;
        string sError = CPublicFunction.ExecSql("DELETE FROM EQP_LOCATION_HIS WHERE DWBH IN (SELECT DWBH FROM EQP_LOCATION WHERE DWBH = '" + txtPSerial.Value + "')");
        if (sError == "")
            sError = CPublicFunction.ExecSql("INSERT INTO EQP_LOCATION_HIS(DWBH, DWMC, DWWZ, GLBM, GXSJ, RKSJ) SELECT DWBH, DWMC, DWWZ, GLBM, GXSJ, RKSJ FROM EQP_LOCATION WHERE DWBH = '" + txtPSerial.Value + "'");
        if (sError == "")
            sError = CPublicFunction.ExecSql("DELETE FROM EQP_LOCATION WHERE DWBH = '" + txtPSerial.Value + "'");
        if (sError == "")
            sError = CPublicFunction.ExecSql("DELETE FROM EQP_EQUIPMENT_HIS WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + txtPSerial.Value + "')");
        if (sError == "")
            sError = CPublicFunction.ExecSql("INSERT INTO EQP_EQUIPMENT_HIS(SBBH,DWBH,SBMC,SBXLH,AZWZ,SBLX,SCCS,SBPP,SBXH,HGZS,JXRQ,ZRR,LXDH,GLSB,GLCS,SBCS,LJCS,SBZT,YXBJ,LJFS,NBPX,GXSJ,RKSJ) SELECT SBBH,DWBH,SBMC,SBXLH,AZWZ,SBLX,SCCS,SBPP,SBXH,HGZS,JXRQ,ZRR,LXDH,GLSB,GLCS,SBCS,LJCS,SBZT,YXBJ,LJFS,NBPX,GXSJ,RKSJ FROM EQP_EQUIPMENT WHERE DWBH = '" + txtPSerial.Value + "'");
        if (sError == "")
            sError = CPublicFunction.ExecSql("DELETE FROM EQP_EQUIPMENT WHERE DWBH = '" + txtPSerial.Value + "'");

        if (sError == "")
        {
            bOk = true;
            sError = "点位删除成功！";
            LoadPointList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool ResetPoint()
    {
        bool bOk = false;
        string sError = CPublicFunction.ExecSql("UPDATE EQP_LOCATION_LOG SET CTCS = '0' WHERE DWBH = '" + txtPSerial.Value + "'");
        if (sError == "")
        {
            bOk = true;
            sError = "点位重置成功！";
            txtPConflict.Value = "0";
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool CopyPoint()
    {
        bool bOk = false;
        string sPName = txtPName.Value;
        string sPoint = txtPSerial.Value;
        txtPName.Value = sPName + "复制";
        string sError = Update_Point(true);
        if (sError != "")
            txtPName.Value = sPName;
        else
            sError = CPublicFunction.ExecSql("INSERT INTO EQP_EQUIPMENT(DWBH,SBMC,SBXLH,AZWZ,SBLX,SCCS,SBXH,LJCS,LJFS,YXBJ,NBPX) SELECT '" + txtPSerial.Value + "' DWBH,SBMC,SBXLH,AZWZ,SBLX,SCCS,SBXH,LJCS,LJFS,YXBJ,NBPX FROM EQP_EQUIPMENT WHERE DWBH = '" + sPoint + "' ORDER BY YXBJ,NBPX");
        if (sError == "")
        {
            bOk = true;
            sError = "点位复制成功！";
            LoadPointList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private string CheckERepeat(string sEquipment, string sType, string sValue, string sName)
    {
        if (sValue == "")
            return "";
        string sError = "";
        DataTable dtList = null;
        sError = CPublicFunction.GetList("SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + txtPSerial.Value + "' AND " + sType + " = '" + sValue + "' AND SBBH <> '" + sEquipment + "'", ref dtList);
        if (sError == "" && dtList != null && dtList.Rows.Count > 0)
            sError = sName + "重复，请核实";
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    private bool UpdateEquipment(bool bInsert)
    {
        bool bOk = false;
        RowItem[] saData = CPublicFunction.MakeRowItems(13);
        saData[0].SetData("N", 0, txtESerial.Value);
        saData[1].SetData("N", 0, txtPSerial.Value);
        saData[2].SetData("C", 60, txtEName.Value.Trim());
        saData[3].SetData("C", 2, drpEModel.SelectedValue);
        saData[4].SetData("C", 128, txtEFactory.Value.Trim());
        saData[5].SetData("C", 30, txtEPerson.Value.Trim());
        saData[6].SetData("C", 20, txtEPhone.Value.Trim());
        saData[7].SetData("C", 60, drpEModel.SelectedItem.Text.Trim());
        saData[8].SetData("C", 60, txtENumber.Value.Trim());
        saData[9].SetData("C", 1, drpEConnect.SelectedValue);
        saData[10].SetData("S", 0, hConnect.Value.Replace("[","<").Replace("]",">"));
        saData[11].SetData("N", 0, drpERelation.SelectedValue);
        saData[12].SetData("N", 0, txtESort.Value);


        string sSql = "UPDATE EQP_EQUIPMENT SET SBMC = ?2,SBLX = ?3,SCCS = ?4,ZRR = ?5,LXDH = ?6,SBXH = ?7,SBXLH = ?8,LJFS=?9,LJCS = ?10,GLSB=?11,NBPX=?12,GXSJ = NOW() WHERE SBBH = ?0";
        string sKey = txtESerial.Value;
        if (bInsert)
        {
            sSql = "INSERT INTO EQP_EQUIPMENT(DWBH,SBMC,SBLX,SCCS,ZRR,LXDH,SBXH,SBXLH,LJFS,LJCS,GLSB,NBPX,GXSJ) VALUES(?1,?2,?3,?4,?5,?6,?7,?8,?9,?10,?11,?12,NOW())";
            sKey = "0";
        }

        //CheckData
        string sError = "";
        if (txtEName.Value.Trim() == "")
            sError = "设备名称不能为空";
        if (drpEModel.SelectedIndex < 0)
            sError = "设备型号不能为空";
        if (sError == "")
            sError = CheckERepeat(sKey,"SBMC",txtEName.Value.Trim(),"设备名称");

        //UpdateData
        if (sError == "")
            sError = CPublicFunction.UpdateRow(sSql, saData, 13, ref sKey);

        if (sError == "")
        {
            bOk = true;
            if (bInsert)
            {
                txtESerial.Value = sKey;
                sError = "设备新增成功！";
            }
            else
                sError = "设备修改成功！";
            LoadEquipmentList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool CheckEquipment()
    {
        bool bOk = true;
        string sError = CPublicFunction.ExecSql("UPDATE EQP_EQUIPMENT SET JXRQ = CURDATE() WHERE SBBH = '" + txtESerial.Value + "'");
        if (sError == "")
        {
            bOk = true;
            sError = "设备检修完成！";
            txtEOverhaul.Value = System.DateTime.Today.ToString("yyyy-MM-dd");
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool StopEquipment()
    {
        bool bOk = true;
        string sError = CPublicFunction.ExecSql("UPDATE EQP_EQUIPMENT SET YXBJ = CASE WHEN YXBJ = '0' THEN '1' ELSE '0' END WHERE SBBH = '" + txtESerial.Value + "'");
        if (sError == "")
        {
            bOk = true;
            sError = "设备启停成功！";
            if (drpEState.SelectedIndex > 0)
                drpEState.SelectedIndex = 0;
            else
                drpEState.SelectedIndex = 1;
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool DeleteEquipment()
    {
        bool bOk = true;
        string sError = CPublicFunction.ExecSql("DELETE FROM EQP_EQUIPMENT_HIS WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE SBBH = '" + txtESerial.Value + "')");
        if (sError == "")
            sError = CPublicFunction.ExecSql("INSERT INTO EQP_EQUIPMENT_HIS(SBBH,DWBH,SBMC,SBXLH,AZWZ,SBLX,SCCS,SBPP,SBXH,HGZS,JXRQ,ZRR,LXDH,GLSB,GLCS,SBCS,LJCS,SBZT,YXBJ,LJFS,NBPX,GXSJ,RKSJ) SELECT SBBH,DWBH,SBMC,SBXLH,AZWZ,SBLX,SCCS,SBPP,SBXH,HGZS,JXRQ,ZRR,LXDH,GLSB,GLCS,SBCS,LJCS,SBZT,YXBJ,LJFS,NBPX,GXSJ,RKSJ FROM EQP_EQUIPMENT WHERE SBBH = '" + txtESerial.Value + "'");
        if (sError == "")
            sError = CPublicFunction.ExecSql("DELETE FROM EQP_EQUIPMENT WHERE SBBH = '" + txtESerial.Value + "'");
        if (sError == "")
        {
            bOk = true;
            sError = "设备删除成功！";
            LoadEquipmentList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private void SortEquipment()
    {
        string[] sSort = hSort.Value.Replace("[", "").Split(Convert.ToChar("]"));
        for (int i = 0; i < sSort.Length; i++)
        {
            CPublicFunction.ExecSql("UPDATE EQP_EQUIPMENT SET NBPX = '" + (i * 3 + 1).ToString() + "' WHERE SBBH = '" + sSort[i] + "'");
        }
        LoadEquipmentList();
    }
}