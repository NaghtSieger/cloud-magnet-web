using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Accredit_Role : System.Web.UI.Page
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
        bool bOk = true;
        if (!Page.IsPostBack)
            LoadRoleList();
        else
        {
            switch (workflag.Value)
            {
                case "CancelModify":
                    if (lbxRole.SelectedIndex < 0)
                        txtRoleCode.Value = "0";
                    else
                        txtRoleCode.Value = lbxRole.SelectedValue;
                    LoadRoleItem();
                    break;
                case "btNew":
                    bOk = UpdateRole(true);
                    break;
                case "btUpdate":
                    bOk = UpdateRole(false);
                    break;
                case "ARightModify":
                    bOk = RightModify();
                    break;
            }
        }
        if (bOk)
        {
            workflag.Value = "";
            lbOperate.Text = "";
        }

    }

    private void LoadRoleList()
    {
        string sSql = "SELECT JSBM,JSMC FROM ACR_ROLE ORDER BY JSBM";
        CPublicFun.SetNewListBox(lbxRole, sSql, 2, txtRoleCode.Value);
        if (lbxRole.SelectedIndex >= 0)
            txtRoleCode.Value = lbxRole.SelectedValue;
        LoadRoleItem();
    }

    private void ClearData()
    {
        txtRoleMemo.Value = "";
        txtRoleName.Value = "";
        hAddFunc.Value = "";
        hRelFunc.Value = "";
        hAddRept.Value = "";
        hRelRept.Value = "";
    }

    private void LoadRoleItem()
    {
        ClearData();
        DataTable dtList = null;
        int iRoleCode = CPublicFun.GetInt(txtRoleCode.Value);
        if (iRoleCode > 0)
        {
            CPublicFunction.GetList("SELECT JSMS,JSMC FROM ACR_ROLE WHERE JSBM = '" + iRoleCode.ToString() + "'", ref dtList);
            if (dtList != null && dtList.Rows.Count > 0)
            {
                txtRoleMemo.Value = dtList.Rows[0][0].ToString();
                txtRoleName.Value = dtList.Rows[0][1].ToString();
            }

        }

        LoadPermission();

        if (dtList != null)
            dtList.Dispose();
    }

    private void LoadPermission()
    {
        string sSql = "SELECT GNBM,GNMC,CASE WHEN SQ = 'A' THEN '' ELSE 'checked' END AS SQ FROM (SELECT A.*,IFNULL(B.DXXH,'A') SQ FROM (SELECT GNBM,GNMC FROM ACR_FUNCTION WHERE GNLX > '1' AND KJXZ = '1') AS A LEFT JOIN (SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '1' AND ZTXH = '" + txtRoleCode.Value + "') AS B ON A.GNBM = B.DXXH) A ORDER BY GNBM";
        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9902020000", sSql, ref sFile, ref iRows);

        divFunc.InnerHtml = sResult;
        divFunc.DataBind();

        sSql = "SELECT BBXH,BBMC,CASE WHEN SQ = 'A' THEN '' ELSE 'checked' END AS SQ FROM (SELECT A.*,IFNULL(B.DXXH,'A') SQ FROM (SELECT BBXH,BBMC FROM REP_DEFINE WHERE BBXH LIKE '02%' ) AS A LEFT JOIN (SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '1' AND ZTXH = '" + txtRoleCode.Value + "') AS B ON A.BBXH = B.DXXH) A ORDER BY BBXH";
        sResult = CPublicFun.QStat("9902030000", sSql, ref sFile, ref iRows);

        divRept.InnerHtml = sResult;
        divRept.DataBind();
    }

    protected void lbxRole_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lbxRole.SelectedIndex < 0)
            txtRoleCode.Value = "0";
        else
            txtRoleCode.Value = lbxRole.SelectedValue;
        LoadRoleItem();
    }

    private string CheckRRepeat(string sRole, string sType, string sValue, string sName)
    {
        if (sValue == "")
            return "";
        string sError = "";
        DataTable dtList = null;
        sError = CPublicFunction.GetList("SELECT JSBM FROM ACR_ROLE WHERE " + sType + " = UPPER('" + sValue + "') AND JSBM <> " + sRole, ref dtList);
        if (sError == "" && dtList != null && dtList.Rows.Count > 0)
            sError = sName + "重复，请核实";
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    private bool UpdateRole(bool bInsert)
    {
        bool bOk = false;
        RowItem[] saData = CPublicFunction.MakeRowItems(3);
        saData[0].SetData("N", 0, txtRoleCode.Value);
        saData[1].SetData("C", 60, txtRoleName.Value.Trim());
        saData[2].SetData("C", 128, txtRoleMemo.Value.Trim());

        string sSql = "UPDATE ACR_ROLE SET JSMC = ?1,JSMS = ?2,GXSJ = NOW() WHERE JSBM = ?0";
        string sKey = txtRoleCode.Value;
        if (bInsert)
        {
            sSql = "INSERT INTO ACR_ROLE(JSMC,JSMS,GXSJ) VALUES(?1,?2,NOW())";
            sKey = "0";
        }

        string sError = "";
        if (txtRoleName.Value.Trim() == "")
            sError = "角色名称不能为空";
        if (sError == "")
            sError = CheckRRepeat(sKey, "JSMC", txtRoleName.Value.Trim(), "角色名称");
        ;

        if (sError == "")
            sError = CPublicFunction.UpdateRow(sSql, saData, 4, ref sKey);

        if (sError == "")
        {
            bOk = true;
            if (bInsert)
            {
                sError = "新建角色成功！";
                txtRoleCode.Value = sKey;
            }
            else
                sError = "修改角色成功！";
            LoadRoleList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool RightModify()
    {
        string sError = "";
        RowItem[] saData = CPublicFunction.MakeRowItems(3);
        saData[0].Len = 12;
        saData[1].SetData("C", 12, txtRoleCode.Value);
        saData[2].DataValue = "1";

        string sSql = "INSERT INTO ACR_ACCREDIT(DXXH,ZTXH,SQLB) VALUES(?0,?1,?2)";
        int i = 0;

        string[] sAccredit = hAddFunc.Value.Replace("[","").Split(Convert.ToChar("]"));
        int iSize = sAccredit.Length - 1;
        for (; i < iSize; i++)
        {
            saData[0].DataValue = sAccredit[i];
            sError = CPublicFunction.UpdateRow(sSql, saData, 3);
        }

        sAccredit = hAddRept.Value.Replace("[", "").Split(Convert.ToChar("]")); 
        iSize = sAccredit.Length - 1;
        for (i = 0; i < iSize; i++)
        {
            saData[0].DataValue = sAccredit[i];
            sError = CPublicFunction.UpdateRow(sSql, saData, 3);
        }

        sSql = "DELETE FROM ACR_ACCREDIT WHERE DXXH = ?0 AND ZTXH = ?1 AND SQLB = ?2";
        sAccredit = hRelRept.Value.Replace("[", "").Split(Convert.ToChar("]"));
        iSize = sAccredit.Length - 1;
        for (i = 0; i < iSize; i++)
        {
            saData[0].DataValue = sAccredit[i];
            sError = CPublicFunction.UpdateRow(sSql, saData, 3);
        }

        saData[1].DataValue = txtRoleCode.Value;
        sAccredit = hRelFunc.Value.Replace("[", "").Split(Convert.ToChar("]"));
        iSize = sAccredit.Length - 1;
        for (i = 0; i < iSize; i++)
        {
            saData[0].DataValue = sAccredit[i];
            sError = CPublicFunction.UpdateRow(sSql, saData, 3);
        }

        hAddFunc.Value = "";
        hRelFunc.Value = "";
        hAddRept.Value = "";
        hRelRept.Value = "";

        LoadPermission();
        return true;
    }


}