<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PriConfig.aspx.cs" Inherits="Permission_PriConfig" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>PriConfig</title>
	    <link href="../Content/Hospital.css" type="text/css" rel="stylesheet" />
	    <script src="../Public/Function.js"></script>
		<script type="text/javascript">
		    function FormSubmit() {
		        form1.submit();
		    }

		    function CheckData() {
		        var sType = GetHtmlValue("workflag", "V");
		        if (sType == "btUpdPWD") {
		            if (GetHtmlValue("txtNewPass1", "V") != GetHtmlValue("txtNewPass2", "V")) {
		                alert("新密码与确认新密码不一致!");
		                return;
		            }
		        }
		        return 1;
		    }

		    function DisableControl() {
		        document.getElementById("ASubmitModify").disabled = true;
		        document.getElementById("ACancelModify").disabled = true;
		        var sType = GetHtmlValue("workflag", "V");
		        if (sType != "") {
		            if (sType != "ARightModify") {
		                var sOperate = GetHtmlValue(sType, "data-title");
		                document.getElementById("lbOperate").innerText = sOperate;
		            }
		            document.getElementById("ASubmitModify").disabled = false;
		            document.getElementById("ACancelModify").disabled = false;
		        }
		        else
		            document.getElementById("lbOperate").innerText = "";

		        document.getElementById("btUpdate").disabled = true;
		        document.getElementById("btUpdPWD").disabled = true;
		        document.getElementById("LogOut").disabled = true;

		        document.getElementById("txtOldPass").disabled = true;
		        document.getElementById("txtNewPass1").disabled = true;
		        document.getElementById("txtNewPass2").disabled = true;
		        document.getElementById("txtUserName").disabled = true;
		        document.getElementById("txtPhone").disabled = true;
		        document.getElementById("txtUserCode").disabled = true;
		        document.getElementById("txtIdentify").disabled = true;
		        document.getElementById("txtPoliceNo").disabled = true;
		        document.getElementById("txtDeptName").disabled = true;

		        switch (sType) {
		            case "btUpdate":
		                document.getElementById("txtPhone").disabled = false;
		                document.getElementById("txtUserCode").disabled = false;
		                document.getElementById("txtIdentify").disabled = false;
		                document.getElementById("txtPoliceNo").disabled = false;
		                break;
		            case "btUpdPWD":
		                document.getElementById("txtOldPass").disabled = false;
		                document.getElementById("txtNewPass1").disabled = false;
		                document.getElementById("txtNewPass2").disabled = false;
		                break;
		            default:
						document.getElementById("btUpdate").disabled = false;
						document.getElementById("btUpdPWD").disabled = false;
						document.getElementById("LogOut").disabled = false;
						break;

		        }
		        if (document.getElementById("ASubmitModify").disabled)
		            document.getElementById("ASubmitModify").src = "../Images/CommitU.gif";
		        else
		            document.getElementById("ASubmitModify").src = "../Images/Commit.gif";

		        if (document.getElementById("ACancelModify").disabled)
		            document.getElementById("ACancelModify").src = "../Images/CancelU.gif";
		        else
		            document.getElementById("ACancelModify").src = "../Images/Cancel.gif";

		        if (document.getElementById("btUpdate").disabled)
		            document.getElementById("btUpdate").src = "../Images/ModifyU.gif";
		        else
		            document.getElementById("btUpdate").src = "../Images/Modify.gif";

		        if (document.getElementById("btUpdPWD").disabled)
		            document.getElementById("btUpdPWD").src = "../Images/PasswardU.gif";
		        else
		            document.getElementById("btUpdPWD").src = "../Images/Passward.gif";
		    }
        </script>
	</head>
    <body>
        <form id="form1" runat="server">
            <input id="workflag" type="hidden" name="workflag" runat="server"/>
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">个人中心</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <div class="DataArea" style ="width:510px;height:380px;top:20px;left:235px;">
                        <p class="DataTile" style ="width:100px;left:90px;top:20px;">姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名：</p>
                        <input id="txtUserName" class="DataText" style ="width:200px;left:190px;top:15px;" runat="Server" disabled="disabled" maxlength="60" />
                        <p class="DataTile" style ="width:100px;left:90px;top:55px;">工作单位：</p>
                        <input id="txtDeptName" class="DataText" style ="width:200px;left:190px;top:50px;" runat="Server" disabled="disabled" maxlength="60" />
                        <p class="DataTile" style ="width:100px;left:90px;top:90px;">证件号码：</p>
                        <input id="txtIdentify" class="DataText" style ="width:200px;left:190px;top:85px;" runat="Server" disabled="disabled" maxlength="60" />
                        <p class="DataTile" style ="width:100px;left:90px;top:125px;">员工编号：</p>
                        <input id="txtPoliceNo" class="DataText" style ="width:200px;left:190px;top:120px;" runat="Server" disabled="disabled" maxlength="60" />
                        <p class="DataTile" style ="width:100px;left:90px;top:160px;">联系电话：</p>
                        <input id="txtPhone" class="DataText" style ="width:200px;left:190px;top:155px;" runat="Server" disabled="disabled" maxlength="60" />
                        <p class="DataTile" style ="width:100px;left:90px;top:195px;">用&nbsp;&nbsp;户&nbsp;&nbsp;名：</p>
                        <input id="txtUserCode" class="DataText" style ="width:200px;left:190px;top:190px;" runat="Server" disabled="disabled" maxlength="60" />
                        <p class="DataTile" style ="width:100px;left:90px;top:230px;">原&nbsp;&nbsp;口&nbsp;&nbsp;令：</p>
                        <input id="txtOldPass" class="DataText"  type="password" style ="width:200px;left:190px;top:225px;" runat="Server" disabled="disabled" maxlength="60" />
                        <p class="DataTile" style ="width:100px;left:90px;top:265px;">新&nbsp;&nbsp;口&nbsp;&nbsp;令：</p>
                        <input id="txtNewPass1" class="DataText"  type="password" style ="width:200px;left:190px;top:260px;" runat="Server" disabled="disabled" maxlength="60" />
                        <p class="DataTile" style ="width:100px;left:90px;top:300px;">确认口令：</p>
                        <input id="txtNewPass2" class="DataText"  type="password" style ="width:200px;left:190px;top:295px;" runat="Server" disabled="disabled" maxlength="60" />

						<img id="btUpdate" class="imgButton" style="left:70px;top:330px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="信息变更" />
						<img id="btUpdPWD" class="imgButton" style="left:170px;top:330px;" onclick="btNormalClick(this,true);" src="../Images/Passward.gif" data-title="密码变更" />
				        <img id="ASubmitModify" class="imgButton" style="left:270px;top:330px;" onclick="ASubmitModifyClick(this);" data-title="保存修改" src="../Images/Commit.gif" />
				        <img id="ACancelModify" class="imgButton" style="left:370px;top:330px;" onclick="ACancelModifyClick(this);" data-title="取消修改" src="../Images/Cancel.gif" />
                    </div>
                    <div id="LogOut" class="DataArea" onclick="btSubmitClick(this,true);" style ="width:510px;height:50px;top:420px;left:235px;" data-title="退出登陆">
                        <p class="pTitle" style="width:510px;top:15px;">退&nbsp;&nbsp;出&nbsp;&nbsp;登&nbsp;&nbsp;陆</p>
                    </div>
                </div>
            </div>
        </form>
		<script type="text/javascript">
			DisableControl();		
		</script>
    </body>
</html>
