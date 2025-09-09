using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;

public partial class Interface_InterUser : System.Web.UI.Page
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
            LoadUserList();
        }
        else
        {
            switch (workflag.Value)
            {
                case "CancelModify":
                    if (lbxInter.SelectedIndex < 0)
                        txtUser.Value = "";
                    else
                        txtUser.Value = lbxInter.SelectedValue;
                    LoadUser();
                    bOk = true;
                    break;
                case "btNew":
                    break;
                case "btUpdate":
                    break;
                case "btDelete":
                    break;
                case "btANew":
                    break;
                case "btAUpdate":
                    break;
                case "btADelete":
                    break;
            }
        }
        if (bOk)
        {
            workflag.Value = "";
            lbOperate.Text = "";
        }
    }

    private void LoadUserList()
    {
        string sSql = "SELECT YHMC FROM INT_USER ORDER BY YHMC";
        CPublicFun.SetNewListBox(lbxInter, sSql, 1, txtUser.Value);
        lbxInter_SelectedIndexChanged(null, null);
    }

    private void ClearData()
    {
        txtIP.Value = "";
        txtMemo.Value = "";
        txtSerial.Value = "";
        txtNote.Value = "";
    }

    private void LoadUser()
    {
        ClearData();
        DataTable dtList = null;
        if (txtUser.Value != "")
        {
            CPublicFunction.GetList("SELECT SYDW,FWXL,DZXZ,BZ FROM INT_USER WHERE YHMC = '" + txtUser.Value + "'", ref dtList);
            if (dtList != null && dtList.Rows.Count > 0)
            {
                txtDepartment.Value = dtList.Rows[0][0].ToString();
                txtSerial.Value = dtList.Rows[0][1].ToString();
                txtIP.Value = dtList.Rows[0][2].ToString();
                txtNote.Value = dtList.Rows[0][3].ToString();
            }

        }
        LoadAccreditList();
        if (dtList != null)
            dtList.Dispose();
    }

    private void LoadAccreditList()
    {

    }

    protected void lbxInter_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (lbxInter.SelectedIndex >= 0)
            txtUser.Value = lbxInter.SelectedValue;
        else
            txtUser.Value = "";
        LoadUser();
    }
}