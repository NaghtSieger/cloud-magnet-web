using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CloudMagnetWeb;
using System.Data;


public partial class Permission_Employee : System.Web.UI.Page
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
        else
        {
            switch (workflag.Value)
            {
                case "CancelModify":
                    LoadOrganItem();
                    LoadUserItem();
                    bOk = true;
                    break;
                case "btDNew":
                    bOk = UpdateOrganize(true);
                    break;
                case "btDUpdate":
                    bOk = UpdateOrganize(false);
                    break;
                case "btNew":
                    bOk = UpdateUser(true);
                    break;
                case "btUpdate":
                    bOk = UpdateUser(false);
                    break;
                case "btDelete":
                    bOk = DeleteUser();
                    break;
                case "btMove":
                    bOk = MoveUser();
                    break;
                case "AReset":
                    bOk = ResetUser();
                    break;
                case "btSort":
                    SortUser();
                    bOk = true;
                    break;
                case "ARightModify":
                    bOk = RightModify();
                    break;
            }
        }
        if (bOk)
        {
            hSort.Value = "";
            workflag.Value = "";
            lbOperate.Text = "";
        }
    }

    private void InitPage()
    {
        hDepartment.Value = CPublicFunction.GetSessionItem("Department");
        hPermission.Value = "0";
        if (CPublicFunction.CheckPermission("0100000000") || CPublicFunction.CheckPermission("0102010100"))
            hPermission.Value = "1";
        LoadOrganList();
        CPublicFun.SetCombList(drpReason, "SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = 'A01' AND ZT = '0' AND DMSM = '2' ORDER BY DMZ", true, 1,"");
        LoadUserList();
    }

    private void LoadOrganList()
    {
        CPublicFun.SetCombList(drpDepartment, "SELECT BMBM,BMMC FROM ACR_DEPARTMENT WHERE BMBM = '" + hDepartment.Value + "' OR SJG(BMBM,0) = '" + hDepartment.Value + "'", false, 1, txtDeptCode.Value);
        LoadOrganItem();
        CPublicFun.SetCombList(drpUserUnit, "SELECT BMBM,BMMC FROM ACR_DEPARTMENT WHERE BMBM = '" + hDepartment.Value + "' OR SJG(BMBM,0) = '" + hDepartment.Value + "'", false, 1, txtDeptCode.Value);
    }

    private void LoadOrganItem()
    {
        if (drpDepartment.SelectedIndex >= 0)
        {
            txtDeptCode.Value = drpDepartment.SelectedValue;
            txtDeptName.Value = drpDepartment.SelectedItem.Text;
        }
        else
        {
            txtDeptCode.Value = "";
            txtDeptName.Value = "";
        }
    }

    private void LoadUserList()
    {
        string sSql = "SELECT RYBH,RYXM FROM ACR_EMPLOYEE WHERE BMBM = '" + txtDeptCode.Value + "' AND RYZT = '0' ORDER BY NBPX,RYBH";
        CPublicFun.SetNewListBox(lbxUser, sSql, 2, hPerson.Value);
        LoadUserItem();
    }

    private void LoadUserItem()
    {
        if (lbxUser.SelectedIndex >= 0)
            hPerson.Value = lbxUser.SelectedValue.ToString();
        else
            hPerson.Value = "";
        ClearData();
        DataTable dtList = null;
        if (hPerson.Value != "")
        {
            CPublicFunction.GetList("SELECT DLYH,RYXM,ZJHM,GZBH,LXDH,NBPX FROM ACR_EMPLOYEE WHERE RYBH = '" + hPerson.Value + "' AND RYZT = '0'", ref dtList);
            if (dtList != null && dtList.Rows.Count > 0)
            {
                txtUserCode.Value = dtList.Rows[0][0].ToString();
                txtUserName.Value = dtList.Rows[0][1].ToString();
                txtIdentify.Value = dtList.Rows[0][2].ToString();
                txtPoliceNo.Value = dtList.Rows[0][3].ToString();
                txtPhone.Value = dtList.Rows[0][4].ToString();
                txtSort.Value = dtList.Rows[0][5].ToString();
            }

        }

        LoadPermission();

        if (dtList != null)
            dtList.Dispose();
    }

    private void LoadPermission()
    {
        string sSql = "";
        if (CPublicFunction.CheckPermission("0100000000"))
            sSql = "SELECT JSBM,JSMC,CASE WHEN DXXH = 'A' THEN '' ELSE 'checked' END SQ FROM (SELECT JSBM,JSMC,IFNULL(DXXH,'A') DXXH FROM ACR_ROLE AS A LEFT JOIN (SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '3' AND ZTXH = '" + hPerson.Value + "') AS B ON A.JSBM = B.DXXH) A ORDER BY JSBM";
        else
            sSql = "SELECT JSBM,JSMC,CASE WHEN DXXH = 'A' THEN '' ELSE 'checked' END SQ FROM (SELECT JSBM,JSMC,IFNULL(DXXH,'A') DXXH FROM (SELECT JSBM,JSMC FROM ACR_ROLE WHERE JSBM IN (SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '3' AND ZTXH = '" + m_sPerson + "')) AS A LEFT JOIN (SELECT DXXH FROM ACR_ACCREDIT WHERE SQLB = '3' AND ZTXH = '" + hPerson.Value + "') AS B ON A.JSBM = B.DXXH) A ORDER BY JSBM";

        string sFile = "";
        int iRows = 0;
        string sResult = CPublicFun.QStat("9902040000", sSql, ref sFile, ref iRows);

        divRole.InnerHtml = sResult;
        divRole.DataBind();
    }

    private void ClearData()
    {
        //Employee
        txtPoliceNo.Value = "";
        txtUserName.Value = "";
        txtUserCode.Value = "";
        txtPhone.Value = "";
        txtIdentify.Value = "";
        txtSort.Value = "0";
        drpReason.SelectedIndex = 0;
        hAddRole.Value = "";
        hRelRole.Value = "";
        drpUserUnit.SelectedIndex = drpDepartment.SelectedIndex;
    }

    protected void drpDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadOrganItem();
        drpUserUnit.SelectedIndex = drpDepartment.SelectedIndex;
        LoadUserList();
    }

    protected void lbxUser_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadUserItem();
    }

    private string CheckNewDCode(string sDepart)
    {
        DataTable dtList = null;
        string sError = "";
        if (sDepart == "")
            sError = "机构编码不能为空";
        if (sError == "")
            sError = CPublicFunction.GetList("SELECT BM,BMBM FROM (SELECT SJG('" + sDepart + "',0) BM UNION SELECT '" + sDepart + "' BM) A LEFT JOIN ACR_DEPARTMENT B ON A.BM = B.BMBM ORDER BY BM", ref dtList);
        if (sError == "" && (dtList == null || dtList.Rows.Count < 2))
            sError = "数据校验出错";
        if (sError == "" && dtList.Rows[0][1].ToString() == "")
            sError = "该机构编码的上级部门不存在，请核实";
        if (sError == "" && dtList.Rows[1][1].ToString() != "")
            sError = "该机构编码已经存在，请核实";
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    private string CheckUpdDName(string sDepart, string sName)
    {
        DataTable dtList = null;
        string sError = "";
        if (sName == "")
            sError = "机构名称不能为空";
        if (sError == "")
            sError = CPublicFunction.GetList("SELECT BMBM FROM V_DEPARTMENT A,(SELECT SJG(BM,0) SBM,BM FROM (SELECT '" + sDepart + "' BM) A) B WHERE SJBM = SBM AND BMBM <> BM AND BMMC = '" + sName + "'", ref dtList);
        if (sError == "" && dtList != null && dtList.Rows.Count > 0)
            sError = "同级机构中机构名称重复，请核实";
        return sError;
    }

    private bool UpdateOrganize(bool bInsert)
    {
        bool bOk = false;
        RowItem[] saData = CPublicFunction.MakeRowItems(2);
        saData[0].SetData("C", 12, txtDeptCode.Value.Trim());
        saData[1].SetData("C", 60, txtDeptName.Value.Trim());
        string sError = "";
        string sSql = "UPDATE ACR_DEPARTMENT SET BMMC = ?1,GXSJ = NOW() WHERE BMBM = ?0";
        if (bInsert)
        {
            //验证新编码符合规范及重复性
            sError = CheckNewDCode(txtDeptCode.Value.Trim());
            sSql = "INSERT INTO ACR_DEPARTMENT(BMBM,BMMC,GXSJ) VALUES(?0,?1,NOW())";
        }

        if (sError == "") //验证机构名称重复性
            sError = CheckUpdDName(txtDeptCode.Value.Trim(), txtDeptName.Value.Trim());
        if (sError == "")
            sError = CPublicFunction.UpdateRow(sSql, saData, 2);

        if (sError == "")
        {
            bOk = true;
            LoadOrganList();
            if (bInsert)
            {
                sError = "部门新增成功！";
                LoadUserList();
            }
            else
                sError = "部门修改成功！";
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool RightModify()
    {
        string sError = "";
        RowItem[] saData = CPublicFunction.MakeRowItems(3);
        saData[0].Len = 12;
        saData[1].SetData("C", 12, hPerson.Value);
        saData[2].DataValue = "3";

        string sSql = "INSERT INTO ACR_ACCREDIT(DXXH,ZTXH,SQLB) VALUES(?0,?1,?2)";
        int i = 0;

        string[] sAccredit = hAddRole.Value.Replace("[", "").Split(Convert.ToChar("]"));
        int iSize = sAccredit.Length - 1;
        for (; i < iSize; i++)
        {
            saData[0].DataValue = sAccredit[i];
            sError = CPublicFunction.UpdateRow(sSql, saData, 3);
        }

        sSql = "DELETE FROM ACR_ACCREDIT WHERE DXXH = ?0 AND ZTXH = ?1 AND SQLB = ?2";
        sAccredit = hRelRole.Value.Replace("[", "").Split(Convert.ToChar("]"));
        iSize = sAccredit.Length - 1;
        for (i = 0; i < iSize; i++)
        {
            saData[0].DataValue = sAccredit[i];
            sError = CPublicFunction.UpdateRow(sSql, saData, 3);
        }

        hAddRole.Value = "";
        hRelRole.Value = "";
        LoadPermission();
        return true;
    }

    private string DeleteUser(string sReason)
    {
        string sError = CPublicFunction.ExecSql("UPDATE ACR_EMPLOYEE SET RYZT = '" + sReason + "' WHERE RYZT = '0' AND RYBH = " + hPerson.Value);
        if (sError == "")
            sError = CPublicFunction.ExecSql("DELETE FROM ACR_ACCREDIT WHERE ZTXH = '" + hPerson.Value + "' AND SQLB = '3'");
        return sError;
    }

    private bool MoveUser()
    {
        if (drpUserUnit.SelectedValue == txtDeptCode.Value)
            return true;
        bool bOk = false;
        string sError = DeleteUser("1");
        if (sError == "")
            sError = CPublicFunction.ExecSql("INSERT INTO ACR_EMPLOYEE(RYXM,ZJHM,GZBH,BMBM,LXDH,DLYH,DLMM,GXSJ) SELECT RYXM,ZJHM,GZBH,'" + drpUserUnit.SelectedValue + "' BMB,LXDH,DLYH,DLMM,NOW() FROM ACR_EMPLOYEE WHERE RYBH = '" + hPerson.Value + "'");
        if (sError == "")
        {
            bOk = true;
            sError = "员工调动成功！";
        }
        LoadUserList();
        if (sError != "")
            CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool DeleteUser()
    {
        bool bOk = false;
        string sError = DeleteUser(drpReason.SelectedValue);
        if (sError == "")
        {
            bOk = true;
            sError = "员工删除成功！";
            LoadUserList();
        }
        if (sError != "")
            CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private bool ResetUser()
    {
        bool bOk = false;
        string sError = CPublicFunction.UpdatePassward(txtUserCode.Value, "000000");
        if (sError == "")
        {
            bOk = true;
            sError = "口令重置成功！";
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
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

    private bool UpdateUser(bool bInsert)
    {
        bool bOk = false;
        RowItem[] saData = CPublicFunction.MakeRowItems(8);
        saData[0].SetData("N", 0, hPerson.Value);
        saData[1].SetData("C", 30, txtUserName.Value.Trim());
        saData[2].SetData("C", 18, txtIdentify.Value.Trim().ToUpper());
        saData[3].SetData("C", 20, txtPoliceNo.Value.Trim().ToUpper());
        saData[4].SetData("C", 12, drpUserUnit.SelectedValue);
        saData[5].SetData("C", 20, txtPhone.Value.Trim());
        saData[6].SetData("C", 30, txtUserCode.Value.Trim().ToUpper());
        saData[7].SetData("N", 0, txtSort.Value);


        string sSql = "UPDATE ACR_EMPLOYEE SET RYXM = ?1,ZJHM = ?2,GZBH = ?3,LXDH = ?5,DLYH = ?6,NBPX = ?7,GXSJ = NOW() WHERE RYBH = ?0";
        string sKey = hPerson.Value;
        if (bInsert)
        {
            sSql = "INSERT INTO ACR_EMPLOYEE(RYXM,ZJHM,GZBH,BMBM,LXDH,DLYH,NBPX,GXSJ) VALUES(?1,?2,?3,?4,?5,?6,?7,NOW())";
            sKey = "0";
        }

        //CheckUserData
        string sError = "";
        if (txtUserName.Value.Trim() == "")
            sError = "姓名不能为空";
        if (sError == "")
            sError = CheckURepeat(sKey, "DLYH", txtUserCode.Value.Trim(), "用户名");
        if (sError == "")
            sError = CheckURepeat(sKey, "ZJHM", txtIdentify.Value.Trim(), "证件号码");
        if (sError == "")
            sError = CheckURepeat(sKey, "GZBH", txtPoliceNo.Value.Trim(), "员工编号");

        //UpdateUserData
        if (sError == "")
            sError = CPublicFunction.UpdateRow(sSql, saData, 8, ref sKey);

        if (sError == "")
        {
            bOk = true;
            if (bInsert)
            {
                hPerson.Value = sKey;
                sError = "员工新增成功！";
            }
            else
                sError = "员工修改成功！";
            LoadUserList();
        }
        CPublicFunction.MsgBox(sError);
        return bOk;
    }

    private void SortUser()
    {
        string[] sSort = hSort.Value.Replace("[", "").Split(Convert.ToChar("]"));
        for (int i = 0; i < sSort.Length; i ++)
        {
            CPublicFunction.ExecSql("UPDATE ACR_EMPLOYEE SET NBPX = '" + (i * 3 + 1).ToString() + "' WHERE RYBH = '" + sSort[i] + "'");
        }
        LoadUserList();
    }
}