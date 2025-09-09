<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Role.aspx.cs" Inherits="Accredit_Role" %>

<!DOCTYPE html>

<html>
	<head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<title>Role</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="../Content/Hospital.css" type="text/css" rel="stylesheet">
		<script src="../Public/Function.js"></script>
		<script type="text/javascript">
		    //异步调用XMLHTTP
		    var oHttpReq = [null, null, null, null, null];
		    var oTimeout = [null, null, null, null, null];
		    var iLevel = 1;

		    function GetRepCondi(iLoc) {
		        var sCondi = "";
		        if (iLoc == 0)
		            sCondi = GetRepCondition("txtRoleCode", "JSMC", "", "txtRoleName");
		        return sCondi;
		    }

		    function GetRepOperate(iLoc) {
		        var sOperate = "";
		        if (iLoc == 0)
		            sOperate = "CHKROLE";
		        return sOperate;
		    }

		    function DealRepAnswer(iLoc) {
		        DealRepeatAnswer(iLoc);
		    }

		    function GetRepCheck(iLoc) {
		        var sCheck = "";
		        if (iLoc == 0)
		            sCheck = "chkRoleName";
		        return sCheck;
		    }

		    function FormSubmit() {
		        form1.submit();
		    }

		    function CheckData() {
		        if (IsNull("角色名称", "txtRoleName", true, "V") == 0) return;
		        if (IsNull("角色编码", "txtRoleCode", true, "V") == 0) return;
		        return 1;
		    }

		    function DisableControl() {
		        document.getElementById("ASubmitModify").disabled = true;
		        document.getElementById("ACancelModify").disabled = true;
		        var sType = GetHtmlValue("workflag","V");
		        if (sType != "") {
		            if (sType != "ARightModify")
		            {
		                var sOperate = GetHtmlValue(sType, "data-title");
		                document.getElementById("lbOperate").innerText = sOperate;
		            }
		            document.getElementById("ASubmitModify").disabled = false;
		            document.getElementById("ACancelModify").disabled = false;
		        }
		        else
		            document.getElementById("lbOperate").innerText = "";

		        document.getElementById("btNew").disabled = true;
		        document.getElementById("btUpdate").disabled = true;

		        document.getElementById("lbxRole").disabled = true;

		        document.getElementById("txtRoleName").disabled = true;
		        document.getElementById("txtRoleMemo").disabled = true;

		        document.getElementById("divFunc").disabled = true;
		        document.getElementById("divRept").disabled = true;
		        switch (sType) {
		            case "btNew":
		            case "btUpdate":
		                document.getElementById("txtRoleName").disabled = false;
		                document.getElementById("txtRoleMemo").disabled = false;
		                break;
		            case "ARightModify":
		                document.getElementById("divFunc").disabled = false;
		                document.getElementById("divRept").disabled = false;
		                break;
		            default:
		                document.getElementById("lbxRole").disabled = false;
		                document.getElementById("btNew").disabled = false;
		                if (document.getElementById("txtRoleCode").value > "0") {
		                    document.getElementById("btUpdate").disabled = false;
		                    document.getElementById("divFunc").disabled = false;
		                    document.getElementById("divRept").disabled = false;
                        }
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

		        if (document.getElementById("btNew").disabled)
		            document.getElementById("btNew").src = "../Images/NewU.gif";
		        else
		            document.getElementById("btNew").src = "../Images/New.gif";

		        if (document.getElementById("btUpdate").disabled)
		            document.getElementById("btUpdate").src = "../Images/ModifyU.gif";
		        else
		            document.getElementById("btUpdate").src = "../Images/Modify.gif";
		    }

		    function IsModiAccredit() {
		        if (document.getElementById("hAddRept").value != "")
		            return 0;
		        if (document.getElementById("hRelRept").value != "")
		            return 0;
		        if (document.getElementById("hRelFunc").value != "")
		            return 0;
		        if (document.getElementById("hAddFunc").value != "")
		            return 0;
		        return 1;
		    }
		</script>
    </head>
    <body>
        <form id="form1" runat="server">
            <input id="workflag" type="hidden" name="workflag" runat="server"/> <input id="txtRoleCode" type="hidden" name="txtRoleCode" runat="server"/>
            <input id="hAddFunc" type="hidden" name="hAddFunc" runat="server"/> <input id="hRelFunc" type="hidden" name="hRelFunc" runat="server"/>
            <input id="hAddRept" type="hidden" name="hAddRept" runat="server"/> <input id="hRelRept" type="hidden" name="hRelRept" runat="server"/>
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">角色管理</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <asp:listbox id="lbxRole" runat="Server" AutoPostBack="True" style="position:absolute;width:200px;height:480px;left:20px;top:20px;border:double;font-family:仿宋_GB2312,Times New Roman;font-size:16pt;" OnSelectedIndexChanged="lbxRole_SelectedIndexChanged"></asp:listbox> 
                    <div class="DataArea" style ="width:720px;height:100px;top:20px;left:240px;">
                        <p class="DataTile" style ="top:20px;">角色名称</p>
                        <input id="txtRoleName" class="DataText" style ="left:80px;top:15px;" onblur="AsyncRepHttp(0)" runat="Server" disabled="disabled" maxlength="60" />
                        <img id="chkRoleName" style ="width:20px;height:20px;left:203px;top:16px;" src="../Images/CheckN.gif">
                        <p class="DataTile" style ="left:220px;top:20px;">角色描述</p>
                        <input id="txtRoleMemo" class="DataText" style ="width:405px;left:300px;top:15px;" runat="Server" disabled="disabled" maxlength="128" />
						<img id="btNew" class="imgButton" style="left: 70px;top:50px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增角色" />
						<img id="btUpdate" class="imgButton" style="left:170px;top:50px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改角色" />
					    <img id="ASubmitModify" class="imgButton" style="left:470px;top:50px;" onclick="ASubmitModifyClick(this);" data-title="保存修改" src="../Images/Commit.gif" />
					    <IMG id="ACancelModify" class="imgButton" style="left:570px;top:50px;" onclick="ACancelModifyClick(this);" data-title="取消修改" src="../Images/Cancel.gif" />
                    </div>
                    <div class="DataArea" style ="width:720px;height:170px;top:135px;left:240px;">
                        <p class="DataTile" style ="top:12px;">功能授权</p>
                        <div id="divFunc" runat="server" class="SelItems" style ="width:700px;height:120px;" >
                            <input type="checkbox" class="SelItemC" onclick="MPermission(this, '0101000000', 'Func');" checked />
                            <p class="SelItemP">用户管理</p>
                            <div class="clear"></div>
                        </div>
                    </div>
                    <div class="DataArea" style ="width:720px;height:170px;top:325px;left:240px;">
                        <p class="DataTile" style ="top:12px;">报表授权</p>
                        <div id="divRept" runat="server" class="SelItems" style ="width:700px;height:120px;" >
                            <input type="checkbox" class="SelItemC" checked />
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
