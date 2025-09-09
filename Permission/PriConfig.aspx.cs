using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;
using System.Data;

public partial class Permission_PriConfig : System.Web.UI.Page
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
        {
            LoadUserItem();
        }
        else
        {
            switch (workflag.Value)
            {
                case "btUpdate":
                    bOk = UpdateData();
                    break;
                case "btUpdPWD":
                    bOk = UpdatePass();
                    break;
                case "LogOut":
                    CPublicFunction.Logout(txtUserCode.Value);
                    Session["UserName"] = "";
                    Session["Name"] = "";
                    Session["Police"] = "";
                    Session["Phone"] = "";
                    Session["SerailNumber"] = "";
                    Session["DepartmentName"] = "";
                    Session["Department"] = "";
                    Session["Person"] = "";
                    Response.Write("<script type='text/javascript'>window.parent.location.reload();</script>");
                    break;
            }
        }
        if (bOk)
        {
            LoadUserItem();
            workflag.Value = "";
            lbOperate.Text = "";
        }
    }
    private void LoadUserItem()
    {
        txtDeptName.Value = CPublicFunction.GetSessionItem("DepartmentName");
        txtUserCode.Value = CPublicFunction.GetSessionItem("UserName");
        txtUserName.Value = CPublicFunction.GetSessionItem("Name");
        txtPoliceNo.Value = CPublicFunction.GetSessionItem("Police");
        txtPhone.Value = CPublicFunction.GetSessionItem("Phone");
        txtIdentify.Value = CPublicFunction.GetSessionItem("SerailNumber");
        txtOldPass.Value = "";
        txtNewPass1.Value = "";
        txtNewPass2.Value = "";
    }

    private string CheckURepeat(string sPerson, string sType, string sValue, string sName)
    {
        if (sValue == "")
            return "";
        string sError = "";
        DataTable dtList = null;
        sError = CPublicFunction.GetList("SELECT RYBH FROM ACR_EMPLOYEE WHERE RYZT = '0' AND " + sType + " = UPPER('" + sValue + "') AND RYBH <> " + sPerson, ref dtList);
        if (sError == "" && dtList != null && dtList.Rows.Count > 0)
            sError = sName + "重复，请核实";
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    protected bool UpdateData()
    {
        bool bOk = false;
        RowItem[] saData = CPublicFunction.MakeRowItems(5);
        saData[0].SetData("N", 16, m_sPerson);
        saData[1].SetData("C", 20, txtPhone.Value.Trim());
        saData[2].SetData("C", 18, txtIdentify.Value.Trim().ToUpper());
        saData[3].SetData("C", 20, txtPoliceNo.Value.Trim().ToUpper());
        saData[4].SetData("C", 30, txtUserCode.Value.Trim().ToUpper());

        string sError = CheckURepeat(m_sPerson, "DLYH", txtUserCode.Value.Trim(), "用户名");
        if (sError == "")
            sError = CheckURepeat(m_sPerson, "ZJHM", txtIdentify.Value.Trim(), "证件号码");
        if (sError == "")
            sError = CheckURepeat(m_sPerson, "GZBH", txtPoliceNo.Value.Trim(), "员工编号");

        string sSql = "UPDATE ACR_EMPLOYEE SET LXDH = ?1,ZJHM = ?2, DLYH = ?4,GZBH = ?3,GXSJ = NOW() WHERE RYBH = ?0";
        if (sError == "")
            sError = CPublicFunction.UpdateRow(sSql, saData, 5);

        if (sError == "")
        {
            bOk = true;
            sError = "修改用户信息成功！";
            Session["Phone"] = txtPhone.Value;
            txtUserCode.Value = txtUserCode.Value.Trim().ToUpper();
            Session["UserName"] = txtUserCode.Value;
            txtPoliceNo.Value = txtPoliceNo.Value.Trim().ToUpper();
            Session["Police"] = txtPoliceNo.Value;
            txtIdentify.Value = txtIdentify.Value.Trim().ToUpper();
            Session["SerailNumber"] = txtIdentify.Value;
        }
        if (sError != "")
            CPublicFunction.MsgBox(sError);
        return bOk;
    }

    protected bool UpdatePass()
    {
        bool bOk = false;
        string sError = CPublicFunction.CheckPassward(txtUserCode.Value, txtOldPass.Value);
        if (sError == "")
            sError = CPublicFunction.UpdatePassward(txtUserCode.Value, txtNewPass1.Value);
        if (sError == "")
        {
            bOk = true;
            sError = "密码修改成功！";
        }
        if (sError != "")
            CPublicFunction.MsgBox(sError);
        return bOk;
    }

}