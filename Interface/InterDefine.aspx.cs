using CloudMagnetWeb;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Interface_InterDefine : System.Web.UI.Page
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
        {
            if (CPublicFunction.CheckPermission("0100000000"))
                hPermission.Value = "1";
            else
                hPermission.Value = "0";
            LoadInterList();
        }
        else
        {
            switch (workflag.Value)
            {
                case "CancelModify":
                    if (lbxInter.SelectedIndex < 0)
                        txtSerial.Value = "";
                    else
                        txtSerial.Value = lbxInter.SelectedValue;
                    LoadInterface();
                    bOk = true;
                    break;
                case "btINew":
                    bOk = UpdateItem(true);
                    break;
                case "btIUpdate":
                    bOk = UpdateItem(false);
                    break;
                case "btIDelete":
                    bOk = DeleteItem();
                    break;
                case "btNew":
                    bOk = UpdateInterface(true);
                    break;
                case "btUpdate":
                    bOk = UpdateInterface(false);
                    break;
                case "btDelete":
                    bOk = DeleteInterface();
                    break;

            }
        }
        if (bOk)
        {
            workflag.Value = "";
            lbOperate.Text = "";
        }
    }

    private void LoadInterList()
    {
        string sSql = "SELECT JKBH,XSMC FROM INT_DEFINE ORDER BY JKBH";
        if (hPermission.Value != "1")
            sSql = "SELECT JKBH,XSMC FROM INT_DEFINE WHERE KJXZ = '1' ORDER BY JKBH";
        CPublicFun.SetNewListBox(lbxInter, sSql, 2, txtSerial.Value);
        lbxInter_SelectedIndexChanged(null, null);
    }

    private void ClearData(short iType)
    {
        if (iType == 1)
        {
            txtName.Value = "";
            txtMemo.Value = "";
            chSystem.Checked = false;
        }

        if (iType == 2)
        {
            txtIName.Value = "";
            txtIMemo.Value = "";
            txtINote.Value = "";
            txtISql.Value = "";
        }

    }

    private void LoadInterface()
    {
        ClearData(1);
        DataTable dtList = null;
        if (txtSerial.Value != "")
        {
            CPublicFunction.GetList("SELECT XSMC,JKSM,KJXZ FROM INT_DEFINE WHERE JKBH = '" + txtSerial.Value + "'", ref dtList);
            if (dtList != null && dtList.Rows.Count > 0)
            {
                txtName.Value = dtList.Rows[0][0].ToString();
                txtMemo.Value = dtList.Rows[0][1].ToString();
                if (dtList.Rows[0][2].ToString() == "0")
                    chSystem.Checked = true;
                else
                    chSystem.Checked = false;
            }

        }
        LoadItemList();
        if (dtList != null)
            dtList.Dispose();
    }

    private void LoadItemList()
    {
        CPublicFun.SetCombList(drpItem, "SELECT SCBH FROM INT_ITEM WHERE JKBH = '" + txtSerial.Value + "' ORDER BY SCBH", true, 2, txtISerial.Value);
        if (drpItem.SelectedIndex > 0)
            txtISerial.Value = drpItem.SelectedValue;
        else
            txtISerial.Value = "";
        LoadItem();
    }

    private void LoadItem()
    {
        ClearData(2);
        DataTable dtList = null;
        if (txtSerial.Value != "")
        {
            CPublicFunction.GetList("SELECT XSMC,SCMS,JDMC,SJLY FROM INT_ITEM WHERE JKBH = '" + txtSerial.Value + "' AND SCBH = '" + txtISerial.Value + "'", ref dtList);
            if (dtList != null && dtList.Rows.Count > 0)
            {
                txtIName.Value = dtList.Rows[0][0].ToString();
                txtIMemo.Value = dtList.Rows[0][1].ToString();
                txtINote.Value = dtList.Rows[0][2].ToString();
                txtISql.Value = dtList.Rows[0][3].ToString();

            }

        }
        if (dtList != null)
            dtList.Dispose();
    }

    protected void lbxInter_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lbxInter.SelectedIndex >= 0)
            txtSerial.Value = lbxInter.SelectedValue.ToString();
        else
            txtSerial.Value = "";
        LoadInterface();
    }

    protected void drpItem_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (drpItem.SelectedIndex > 0)
            txtISerial.Value = drpItem.SelectedValue;
        else
            txtISerial.Value = "";
        LoadItem();
    }

    private string CheckDRepeat(string sInter, string sType, string sValue, string sName)
    {
        if (sValue == "")
            return "";
        string sError = "";
        DataTable dtList = null;
        sError = CPublicFunction.GetList("SELECT JKBH FROM INT_DEFINE WHERE " + sType + " = UPPER('" + sValue + "') AND JKBH <> '" + sInter + "'", ref dtList);
        if (sError == "" && dtList != null && dtList.Rows.Count > 0)
            sError = sName + "重复，请核实";
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    private bool UpdateInterface(bool bInsert)
    {
        bool bOk = false;

        RowItem[] saData = CPublicFunction.MakeRowItems(4);
        saData[0].SetData("C", 10, txtSerial.Value.Trim().ToUpper());
        saData[1].SetData("C", 30, txtName.Value.Trim());
        saData[2].SetData("C", 128, txtMemo.Value.Trim());
        saData[3].SetData("C", 1, "1");
        if (this.chSystem.Checked)
            saData[3].DataValue = "0";


        string sKey = txtSerial.Value.Trim().ToUpper();
        string sError = "";
        if (sKey == "")
            sError = "接口编码不能为空";

        string sSql = "UPDATE INT_DEFINE SET XSMC = ?1,JKSM = ?2,KJXZ = ?3,GXSJ = NOW() WHERE JKBH = ?0";
        if (bInsert)
        {
            sSql = "INSERT INTO INT_DEFINE(JKBH,XSMC,JKSM,KJXZ,GXSJ) VALUES(?0,?1,?2,?3,NOW())";
            sKey = "";
            if (sError == "")
                sError = CheckDRepeat(sKey, "JKBH", txtSerial.Value.Trim().ToUpper(), "接口编码");
        }

        if (txtName.Value.Trim() == "")
            sError = "接口名称不能为空";
        if (sError == "")
            sError = CheckDRepeat(sKey, "XSMC", txtName.Value.Trim(), "接口名称");

        if (sError == "")
            sError = CPublicFunction.UpdateRow(sSql, saData, 4);
        if (sError == "")
        {
            bOk = true;
            if (bInsert)
                sError = "新增接口定义成功!";
            else
                sError = "修改接口定义成功!";
            LoadInterList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool DeleteInterface()
    {
        bool bOk = false;
        if (txtSerial.Value == "")
            return true;
        string sError = CPublicFunction.ExecSql("DELETE FROM INT_ITEM WHERE JKBH = '" + txtSerial.Value + "'");
        if (sError == "")
            sError = CPublicFunction.ExecSql("DELETE FROM INT_DEFINE WHERE JKBH = '" + txtSerial.Value + "'");
        if (sError == "")
        {
            bOk = true;
            sError = "删除接口成功!";
            txtSerial.Value = "";
            LoadInterList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private string CheckRRepeat(string sItem, string sType, string sValue, string sName)
    {
        if (sValue == "")
            return "";
        string sError = "";
        DataTable dtList = null;
        sError = CPublicFunction.GetList("SELECT SCBH FROM INT_ITEM WHERE JKBH = '" + txtSerial.Value.Trim() + "' AND " + sType + " = UPPER('" + sValue + "') AND SCBH <> " + sItem, ref dtList);
        if (sError == "" && dtList != null && dtList.Rows.Count > 0)
            sError = sName + "重复，请核实";
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    private bool UpdateItem(bool bInsert)
    {
        if (txtSerial.Value == "")
            return true;
        bool bOk = false;
        RowItem[] saData = CPublicFunction.MakeRowItems(6);

        saData[0].SetData("C", 10, txtSerial.Value.Trim());
        saData[1].SetData("N", 10, txtISerial.Value.Trim());
        saData[2].SetData("C", 60, txtIName.Value.Trim());
        saData[3].SetData("C", 128, txtIMemo.Value.Trim());
        saData[4].SetData("S", 0, txtISql.Value.Trim());
        saData[5].SetData("C", 30, txtINote.Value.Trim());

        string sError = "";
        string sKey = txtISerial.Value.Trim();
        if (sKey == "")
            sError = "输出序号不能为空";
        if (sError == "" && txtIName.Value.Trim() == "")
            sError = "输出名称不能为空";
        if (sError == "" && txtISql.Value.Trim() == "")
            sError = "输出来源不能为空";

        // SCMS,JDMC,SJLY,XSMC
        string sSql = "UPDATE INT_ITEM SET XSMC = ?2,SCMS = ?3,SJLY = ?4,JDMC = ?5,GXSJ = NOW() WHERE JKBH = ?0 AND SCBH = ?1";
        if (bInsert)
        {
            sSql = "INSERT INTO INT_ITEM(JKBH,SCBH,XSMC,SCMS,SJLY,JDMC,GXSJ) VALUES(?0,?1,?2,?3,?4,?5,NOW())";
            sKey = "-100";

            if (sError == "")
                sError = CheckRRepeat(sKey, "SCBH", txtISerial.Value.Trim(), "输出序号");
        }

        if (sError == "")
            sError = CheckRRepeat(sKey, "XSMC", txtIName.Value.Trim(), "输出名称");


        if (sError == "")
            sError = CPublicFunction.UpdateRow(sSql, saData, 6);
        if (sError == "")
        {
            bOk = true;
            if (bInsert)
            {
                sError = "新增输出明细成功!";
                LoadItemList();
            }
            else
                sError = "修改输出明细成功!";
            LoadItemList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool DeleteItem()
    {
        bool bOk = false;
        if (txtSerial.Value == "" || txtISerial.Value == "")
            return true;
        string sError = CPublicFunction.ExecSql("DELETE FROM INT_ITEM WHERE JKBH = '" + txtSerial.Value + "' AND SCBH = " + txtISerial.Value);
        if (sError == "")
        {
            bOk = true;
            sError = "删除输出明细成功!";
            txtISerial.Value = "";
            LoadItemList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }
}