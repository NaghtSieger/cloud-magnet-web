<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Employee.aspx.cs" Inherits="Permission_Employee" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<title>Employee</title>
	    <link href="../Content/Hospital.css" type="text/css" rel="stylesheet" />
	    <script src="../Public/Function.js"></script>
		<script type="text/javascript">
		    //异步调用XMLHTTP
		    var oHttpReq = [null, null, null, null, null];
		    var oTimeout = [null, null, null, null, null];
		    var iLevel = 1;

		    function GetRepCondi(iLoc) {
		        var sCondi = "";
		        if (iLoc == 0)
		            sCondi = GetRepCondition("txtDeptCode", "BMBM", "hDepartment", "txtDeptCode");
		        if (iLoc == 1)
		            sCondi = GetRepCondition("txtDeptCode", "BMMC", "hDepartment", "txtDeptName");
		        if (iLoc == 2)
		            sCondi = GetRepCondition("hPerson", "DLYH", "", "txtUserCode");
		        if (iLoc == 3)
		            sCondi = GetRepCondition("hPerson", "ZJHM", "", "txtIdentify");
		        if (iLoc == 4)
		            sCondi = GetRepCondition("hPerson", "GZBH", "", "txtPoliceNo");
		        return sCondi;
		    }

		    function GetRepOperate(iLoc) {
		        var sOperate = "";
		        if (iLoc == 0 || iLoc == 1)
		            sOperate = "CHKDEPART";
		        if (iLoc == 2 || iLoc == 3 || iLoc == 4)
		            sOperate = "CHKPERSON";
		        return sOperate;
		    }

		    function DealRepAnswer(iLoc) {
		        DealRepeatAnswer(iLoc);
		    }

		    function GetRepCheck(iLoc) {
		        var sCheck = "";
		        if (iLoc == 0)
		            sCheck = "chkDeptCode";
		        if (iLoc == 1)
		            sCheck = "chkDeptName";
		        if (iLoc == 2)
		            sCheck = "chkUserCode";
		        if (iLoc == 3)
		            sCheck = "chkIdentify";
		        if (iLoc == 4)
		            sCheck = "chkPoliceNo";
		        return sCheck;
		    }

		    function FormSubmit() {
		        document.getElementById("drpUserUnit").disabled = false;
		        form1.submit();
		    }

		    function CheckData() {
		        var sType = GetHtmlValue("workflag", "V");
		        switch (sType) {
		            case "btNew":
		            case "btUpdate":
		                if (IsNull("姓名", "txtUserName", true, "V") == 0) return;
		                break;
		            case "btDelete":
		                if (document.getElementById("drpReason").options.selectedIndex == 0) {
		                    alert("删除原因不能为空");
		                    document.getElementById("drpReason").focus();
		                    return;
		                }
		                break;
		            case "btDNew":
		            case "btDUpdate":
		                if (IsNull("机构全称", "txtDeptName", true, "V") == 0) return;
		                break;
		            case "btSort":
		                SetHtmlValue("hSort","V", GetSort("lbxUser"));
		                break;
		        }
		        return 1;
		    }

		    function DisableControl() {
		        document.getElementById("ASubmitModify").disabled = true;
		        document.getElementById("ACancelModify").disabled = true;
		        var sType = GetHtmlValue("workflag", "V");
		        if (sType != "") {
		            if (sType != "ARightModify" && sType != "btSort") {
		                var sOperate = GetHtmlValue(sType, "data-title");
		                document.getElementById("lbOperate").innerText = sOperate;
		            }
		            document.getElementById("ASubmitModify").disabled = false;
		            document.getElementById("ACancelModify").disabled = false;
		        }
		        else
		            document.getElementById("lbOperate").innerText = "";

		        document.getElementById("btDNew").disabled = true;
		        document.getElementById("btDUpdate").disabled = true;

		        document.getElementById("btNew").disabled = true;
		        document.getElementById("btUpdate").disabled = true;
		        document.getElementById("btDelete").disabled = true;
		        document.getElementById("btMove").disabled = true;
		        document.getElementById("AReset").disabled = true;
		        document.getElementById("btUp").disabled = true;
		        document.getElementById("btDown").disabled = true;

		        document.getElementById("lbxUser").disabled = true;

		        document.getElementById("txtUserCode").disabled = true;
		        document.getElementById("txtUserName").disabled = true;
		        document.getElementById("txtPhone").disabled = true;
		        document.getElementById("txtIdentify").disabled = true;
		        document.getElementById("txtPoliceNo").disabled = true;
		        document.getElementById("txtSort").disabled = true;
		        document.getElementById("drpReason").disabled = true;
		        document.getElementById("drpUserUnit").disabled = true;

		        document.getElementById("drpDepartment").disabled = true;
		        document.getElementById("txtDeptCode").disabled = true;
		        document.getElementById("txtDeptName").disabled = true;
		        document.getElementById("txtDeptName").style.display = "none";
		        document.getElementById("chkDeptName").style.display = "none";

		        document.getElementById("divRole").disabled = true;

		        var sPermission = GetHtmlValue("hPermission", "V");
		        if (sPermission == "0") {
		            document.getElementById("lbxUser").disabled = false;
		            document.getElementById("drpDepartment").disabled = false;
		        }
		        else {
		            switch (sType) {
		                case "btNew":
		                case "btUpdate":
		                    document.getElementById("txtPoliceNo").disabled = false;
		                    document.getElementById("txtUserCode").disabled = false;
		                    document.getElementById("txtUserName").disabled = false;
		                    document.getElementById("txtPhone").disabled = false;
		                    document.getElementById("txtIdentify").disabled = false;
		                    document.getElementById("txtSort").disabled = false;
		                    break;
		                case "btDNew":
		                case "btDUpdate":
		                    document.getElementById("txtDeptCode").disabled = false;
		                    document.getElementById("txtDeptName").disabled = false;
		                    document.getElementById("txtDeptName").style.display = "block";
		                    document.getElementById("chkDeptName").style.display = "block";
		                    break;
		                case "ARightModify":
		                    document.getElementById("divRole").disabled = false;
		                    break;
		                case "btMove":
		                    document.getElementById("drpUserUnit").disabled = false;
		                    break;
		                case "btDelete":
		                    document.getElementById("drpReason").disabled = false;
		                    break;
		                case "btSort":
		                    document.getElementById("btUp").disabled = false;
		                    document.getElementById("btDown").disabled = false;
		                    break;
		                default:
		                    document.getElementById("drpDepartment").disabled = false;
		                    document.getElementById("lbxUser").disabled = false;
		                    document.getElementById("btUp").disabled = false;
		                    document.getElementById("btDown").disabled = false;
		                    document.getElementById("btNew").disabled = false;
		                    document.getElementById("btDNew").disabled = false;
		                    document.getElementById("btDUpdate").disabled = false;
		                    if (document.getElementById("txtUserCode").value != "") {
		                        document.getElementById("btUpdate").disabled = false;
		                        document.getElementById("btDelete").disabled = false;
		                        document.getElementById("btMove").disabled = false;
		                        document.getElementById("AReset").disabled = false;
		                        document.getElementById("divRole").disabled = false;
		                    }
		                    break;
		            }
		        }
		        if (document.getElementById("ASubmitModify").disabled)
		            document.getElementById("ASubmitModify").src = "../Images/CommitU.gif";
		        else
		            document.getElementById("ASubmitModify").src = "../Images/Commit.gif";

		        if (document.getElementById("ACancelModify").disabled)
		            document.getElementById("ACancelModify").src = "../Images/CancelU.gif";
		        else
		            document.getElementById("ACancelModify").src = "../Images/Cancel.gif";

		        if (document.getElementById("btDNew").disabled)
		            document.getElementById("btDNew").src = "../Images/NewU.gif";
		        else
		            document.getElementById("btDNew").src = "../Images/New.gif";

		        if (document.getElementById("btDUpdate").disabled)
		            document.getElementById("btDUpdate").src = "../Images/ModifyU.gif";
		        else
		            document.getElementById("btDUpdate").src = "../Images/Modify.gif";

		        if (document.getElementById("btNew").disabled)
		            document.getElementById("btNew").src = "../Images/NewU.gif";
		        else
		            document.getElementById("btNew").src = "../Images/New.gif";

		        if (document.getElementById("btUpdate").disabled)
		            document.getElementById("btUpdate").src = "../Images/ModifyU.gif";
		        else
		            document.getElementById("btUpdate").src = "../Images/Modify.gif";

		        if (document.getElementById("btDelete").disabled)
		            document.getElementById("btDelete").src = "../Images/DeleteU.gif";
		        else
		            document.getElementById("btDelete").src = "../Images/Delete.gif";

		        if (document.getElementById("btMove").disabled)
		            document.getElementById("btMove").src = "../Images/MoveU.gif";
		        else
		            document.getElementById("btMove").src = "../Images/Move.gif";

		        if (document.getElementById("AReset").disabled)
		            document.getElementById("AReset").src = "../Images/ResetU.gif";
		        else
		            document.getElementById("AReset").src = "../Images/Reset.gif";

		        if (document.getElementById("btUp").disabled)
		            document.getElementById("btUp").src = "../Images/UpU.png";
		        else
		            document.getElementById("btUp").src = "../Images/Up.png";

		        if (document.getElementById("btDown").disabled)
		            document.getElementById("btDown").src = "../Images/DownU.png";
		        else
		            document.getElementById("btDown").src = "../Images/Down.png";

            }

		    function IsModiAccredit() {
		        if (document.getElementById("hAddRole").value != "")
		            return 0;
		        if (document.getElementById("hRelRole").value != "")
		            return 0;
		        return 1;
		    }
        </script>
    </head>
    <body>
        <form id="form1" runat="server">
            <input id="workflag" type="hidden" name="workflag" runat="server"/> <input id="hPerson" type="hidden" name="hPerson" runat="server"/> <input id="hDepartment" type="hidden" name="hDepartment" runat="server"/>
            <input id="hAddRole" type="hidden" name="hAddFunc" runat="server"/> <input id="hRelRole" type="hidden" name="hRelFunc" runat="server"/>
            <input id="hSort" type="hidden" name="hSort" runat="server"/> <input id="hPermission" type="hidden" name="hPermission" runat="server" value="0"/>
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">用户管理</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
				<img id="ASubmitModify" class="imgButton" style="left:80px;top:30px;" onclick="ASubmitModifyClick(this);" data-title="保存修改" src="../Images/Commit.gif" />
				<img id="ACancelModify" class="imgButton" style="left:180px;top:30px;" onclick="ACancelModifyClick(this);" data-title="取消修改" src="../Images/Cancel.gif" />
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <div class="DataArea" style ="width:720px;height:100px;top:20px;left:240px;">
                        <p class="DataTile" style ="top:20px;">机构编码</p>
                        <input id="txtDeptCode" class="DataText" style ="width:100px;left:80px;top:15px;" onblur="AsyncRepHttp(0)" runat="Server" disabled="disabled" maxlength="60" />
                        <img id="chkDeptCode" class="CheckRepeat" style ="left:183px;top:16px;" src="../Images/CheckN.gif" />
                        <p class="DataTile" style ="left:200px;top:20px;">机构全称</p>
                        <asp:dropdownlist id="drpDepartment" AutoPostBack="True" style="position:absolute;width:425px;height:25px;left:280px;top:15px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server" OnSelectedIndexChanged="drpDepartment_SelectedIndexChanged"></asp:dropdownlist>
                        <input id="txtDeptName" class="DataText" style ="width:400px;left:280px;top:15px;display:none;z-index:3;" onblur="AsyncRepHttp(1)" runat="Server" disabled="disabled" maxlength="128" />
                        <img id="chkDeptName" class="CheckRepeat" style ="left:685px;top:16px;display:none;z-index:3;" src="../Images/CheckN.gif" />

						<img id="btDNew" class="imgButton" style="left: 70px;top:50px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增部门" />
						<img id="btDUpdate" class="imgButton" style="left:170px;top:50px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改部门" />
                    </div>

                    <asp:listbox id="lbxUser" runat="Server" AutoPostBack="True" style="position:absolute;width:200px;height:480px;left:20px;top:20px;border:double;font-family:仿宋_GB2312,Times New Roman;font-size:16pt;" OnSelectedIndexChanged="lbxUser_SelectedIndexChanged"></asp:listbox> 
					<img id="btUp" class="MoveList" style="left:220px;top:140px;" onclick="MoveListItem('lbxUser','1');" src="../Images/Up.png" />
					<img id="btDown" class="MoveList" style="left:220px;top:300px;" onclick="MoveListItem('lbxUser','2');" src="../Images/Down.png" />
                    
                    <div class="DataArea" style ="width:720px;height:170px;top:135px;left:240px;">
                        <p class="DataTile" style ="top:20px;">用&nbsp;&nbsp;户&nbsp;&nbsp;名</p>
                        <input id="txtUserCode" class="DataText" style ="width:100px;left:80px;top:15px;" onblur="AsyncRepHttp(2)" runat="Server" disabled="disabled" maxlength="30" />
                        <img id="chkUserCode" class="CheckRepeat" style ="left:183px;top:16px;" src="../Images/CheckN.gif" />
                        <p class="DataTile" style ="left:200px;top:20px;">姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名</p>
                        <input id="txtUserName" class="DataText" style ="left:280px;top:15px;" runat="Server" disabled="disabled" maxlength="30" />
                        <p class="DataTile" style ="left:400px;top:20px;">证件号码</p>
                        <input id="txtIdentify" class="DataText" style ="width:200px;left:480px;top:15px;" onblur="AsyncRepHttp(3)" runat="Server" disabled="disabled" maxlength="18" />
                        <img id="chkIdentify" class="CheckRepeat" style ="left:683px;top:16px;" src="../Images/CheckN.gif" />

                        <p class="DataTile" style ="top:55px;">联系电话</p>
                        <input id="txtPhone" class="DataText" style ="left:80px;top:50px;" runat="Server" disabled="disabled" maxlength="20" />
                        <p class="DataTile" style ="left:200px;top:55px;">内部排序</p>
                        <input id="txtSort" class="DataText" style ="left:280px;top:50px;" runat="Server" disabled="disabled" maxlength="4" />
                        <p class="DataTile" style ="left:400px;top:55px;">员工编号</p>
                        <input id="txtPoliceNo" class="DataText" style ="width:200px;left:480px;top:50px;" onblur="AsyncRepHttp(4)" runat="Server" disabled="disabled" maxlength="20" />
                        <img id="chkPoliceNo" class="CheckRepeat" style ="left:683px;top:51px;" src="../Images/CheckN.gif" />

                        <p class="DataTile" style ="top:90px;">删除原因</p>
                        <asp:dropdownlist id="drpReason" style="position:absolute;width:125px;height:25px;left:80px;top:85px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server"></asp:dropdownlist>
                        <p class="DataTile" style ="left:200px;top:90px;">工作单位</p>
                        <asp:dropdownlist id="drpUserUnit" style="position:absolute;width:425px;height:25px;left:280px;top:85px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server"></asp:dropdownlist>

						<img id="btNew" class="imgButton" style="left:70px;top:120px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增用户" />
						<img id="btUpdate" class="imgButton" style="left:170px;top:120px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改用户" />
						<img id="btDelete" class="imgButton" style="left:270px;top:120px;" onclick="btNormalClick(this,true);" src="../Images/Delete.gif" data-title="删除用户" />
						<img id="AReset" class="imgButton" style="left:370px;top:120px;" onclick="btSubmitClick(this,true);" data-title="口令重置" src="../Images/Reset.gif" />
						<img id="btMove" class="imgButton" style="left:470px;top:120px;" onclick="btNormalClick(this);" data-title="部门调动" src="../Images/Move.gif" />
                    </div>

                    <div class="DataArea" style ="width:720px;height:170px;top:325px;left:240px;">
                        <p class="DataTile" style ="top:12px;">角色授权</p>
                        <div id="divRole" runat="server" class="SelItems" style ="width:700px;height:120px;" >
                            <input type="checkbox" class="SelItemC" checked="checked" />
                            <p class="SelItemP">用户管理</p>
                            <div class="clear"></div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
		<script type="text/javascript">
			DisableControl();		
		</script>
    </body>
</html>
