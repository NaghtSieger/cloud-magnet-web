<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InterUser.aspx.cs" Inherits="Interface_InterUser" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>InterUser</title>
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
		            sCondi = GetRepCondition("txtUser", "YHMC", "", "txtUser");
		        return sCondi;
		    }

		    function GetRepOperate(iLoc) {
		        var sOperate = "";
		        if (iLoc == 0)
		            sOperate = "CHKIUSER";
		        return sOperate;
		    }

		    function DealRepAnswer(iLoc) {
		        DealRepeatAnswer(iLoc);
		    }

		    function GetRepCheck(iLoc) {
		        var sCheck = "";
		        if (iLoc == 0)
		            sCheck = "chkUser";
		        return sCheck;
		    }

		    function FormSubmit() {
		        form1.submit();
		    }

		    function CheckData() {
		        var sType = GetHtmlValue("workflag", "V");
		        switch (sType) {
		            case "btNew":
		            case "btUpdate":
		                if (IsNull("接口名称", "txtName", true, "V") == 0) return;
		                if (IsNull("接口编号", "txtSerial", true, "V") == 0) return;
		                break;
		            case "btNew":
		            case "btUpdate":
		                if (IsNull("输出名称", "txtIName", true, "V") == 0) return;
		                if (IsNull("输出编号", "txtISerial", true, "V") == 0) return;
		                if (IsNull("输出明细", "txtISql", true, "V") == 0) return;
		                break;
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

		        document.getElementById("lbxInter").disabled = true;

		        document.getElementById("btNew").disabled = true;
		        document.getElementById("btUpdate").disabled = true;
		        document.getElementById("btDelete").disabled = true;

		        document.getElementById("txtUser").disabled = true;
		        document.getElementById("txtIP").disabled = true;
		        document.getElementById("txtSerial").disabled = true;
		        document.getElementById("txtDepartment").disabled = true;
		        document.getElementById("txtNote").disabled = true;

		        document.getElementById("drpInter").disabled = true;
		        document.getElementById("txtNumber").disabled = true;
		        document.getElementById("btANew").disabled = true;
		        document.getElementById("btAUpdate").disabled = true;
		        document.getElementById("btADelete").disabled = true;

		        switch (sType) {
		            case "btNew":
		            case "btUpdate":
		                if (sType == "btNew")
		                    document.getElementById("txtUser").disabled = false;
		                document.getElementById("txtIP").disabled = false;
		                document.getElementById("txtSerial").disabled = false;
		                document.getElementById("txtDepartment").disabled = false;
		                document.getElementById("txtNote").disabled = false;
		                break;
		            case "btANew":
		            case "btAUpdate":
		                document.getElementById("txtNumber").disabled = false;
		                break;
		            default:
		                document.getElementById("lbxInter").disabled = false;
		                document.getElementById("btNew").disabled = false;
		                if (GetHtmlValue("txtUser", "V") != "") {
		                    document.getElementById("btUpdate").disabled = false;
		                    document.getElementById("btDelete").disabled = false;
		                    document.getElementById("drpInter").disabled = false;
		                    document.getElementById("btANew").disabled = false;
		                    document.getElementById("btAUpdate").disabled = false;
		                    document.getElementById("btADelete").disabled = false;
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

		        if (document.getElementById("btDelete").disabled)
		            document.getElementById("btDelete").src = "../Images/DeleteU.gif";
		        else
		            document.getElementById("btDelete").src = "../Images/Delete.gif";

		        if (document.getElementById("btANew").disabled)
		            document.getElementById("btANew").src = "../Images/NewU.gif";
		        else
		            document.getElementById("btANew").src = "../Images/New.gif";

		        if (document.getElementById("btAUpdate").disabled)
		            document.getElementById("btAUpdate").src = "../Images/ModifyU.gif";
		        else
		            document.getElementById("btAUpdate").src = "../Images/Modify.gif";

		        if (document.getElementById("btADelete").disabled)
		            document.getElementById("btADelete").src = "../Images/DeleteU.gif";
		        else
		            document.getElementById("btADelete").src = "../Images/Delete.gif";
            }
		</script>
    </head>
    <body>
        <form id="form1" runat="server">
            <input id="workflag" type="hidden" name="workflag" runat="server" /> <input id="hPermission" type="hidden" name="hPermission" runat="server" value="0"/>
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">接口访问者定义</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <asp:listbox id="lbxInter" runat="Server" AutoPostBack="True" style="position:absolute;width:200px;height:480px;left:20px;top:20px;border:double;font-family:仿宋_GB2312,Times New Roman;font-size:16pt;" OnSelectedIndexChanged="lbxInter_SelectedIndexChanged"></asp:listbox> 
                    <div class="DataArea" style ="width:720px;height:135px;top:20px;left:240px;">
                        <p class="DataTile" style ="top:20px;">用户名称</p>
                        <input id="txtUser" class="DataText" style ="width:100px;left:80px;top:15px;" onblur="AsyncRepHttp(0)" runat="Server" disabled="disabled" maxlength="20" />
                        <img id="chkUser" style ="width:20px;height:20px;left:183px;top:16px;" src="../Images/CheckN.gif"/>
                        <p class="DataTile" style ="left:200px;top:20px;">地址限制</p>
                        <input id="txtIP" class="DataText" style ="left:280px;top:15px;" runat="Server" disabled="disabled" maxlength="16" />
                        <p class="DataTile" style ="left:400px;top:20px;">序&nbsp;&nbsp;列&nbsp;&nbsp;号</p>
                        <input id="txtSerial" class="DataText" style ="width:200px;left:480px;top:15px;" runat="Server" disabled="disabled"/>
                        <p class="DataTile" style ="top:55px;">使用单位</p>
                        <input id="txtDepartment" class="DataText" style ="width:320px;left:80px;top:50px;" runat="Server" disabled="disabled" maxlength="128" />
                        <p class="DataTile" style ="left:400px;top:55px;">备&nbsp;&nbsp;&nbsp;&nbsp;注</p>
                        <input id="txtNote" class="DataText" style ="width:200px;left:480px;top:50px;" runat="Server" disabled="disabled"/>

                        <img id="btNew" class="imgButton" style="left: 70px;top:85px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增接口" />
                        <img id="btUpdate" class="imgButton" style="left:170px;top:85px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改接口" />
                        <img id="btDelete" class="imgButton" style="left:270px;top:85px;" onclick="btSubmitClick(this,true);" src="../Images/Delete.gif" data-title="删除接口" />
				        <img id="ASubmitModify" class="imgButton" style="left:470px;top:85px;" onclick="ASubmitModifyClick(this);" data-title="保存修改" src="../Images/Commit.gif" />
				        <img id="ACancelModify" class="imgButton" style="left:570px;top:85px;" onclick="ACancelModifyClick(this);" data-title="取消修改" src="../Images/Cancel.gif" />
                    </div>
                    <div class="DataArea" style ="width:720px;height:325px;top:170px;left:240px;">
                        <p class="DataTile" style ="left:355px;top:12px;">接口授权</p>
						<p class="DataTile" style ="top:47px;">接口名称</p>
						<asp:dropdownlist id="drpInter" AutoPostBack="True" style="position:absolute;width:280px;height:25px;left:80px;top:42px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server"></asp:dropdownlist>
						<p class="DataTile" style ="top:82px;">日访问量</p>
						<input id="txtNumber" class="DataText" style ="width:80px;left:80px;top:77px;" runat="Server" disabled="disabled" maxlength="10" />
						<p class="DataTile" style ="width:200px;left:170px;top:82px;text-align:left;">0-表示无限量访问</p>
						<p class="DataTile" style ="top:117px;">接口描述</p>
                        <textarea id="txtMemo" class="DataText" style ="width:278px;left:80px;height:70px;top:112px;overflow:auto;" runat="Server" disabled="disabled" maxlength="128" />
                        <img id="btANew" class="imgButton" style="left: 70px;top:202px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增接口授权" />
                        <img id="btAUpdate" class="imgButton" style="left:170px;top:202px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改接口授权" />
                        <img id="btADelete" class="imgButton" style="left:270px;top:202px;" onclick="btSubmitClick(this,true);" src="../Images/Delete.gif" data-title="删除接口授权" />

                        <div id="vhList" runat="server" style="width:350px;height:280px;left:370px;top:42px;">
					        <table style="width:340px;text-align:center;margin:0;border-collapse:collapse;" border="1">
				                <tr style="height:30px;">
					                <td style="width:260px;"><P style="position: static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">接口名称</p></td>
					                <td style="width: 80px;"><P style="position: static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">日访问量</p></td>
				                </tr>
				                <tr id="vhRowGETPTIME" style="height:30px;display:none;">
					                <td style="width:260px;"><P style="position: static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">点位心跳信息</p></td>
					                <td style="width: 80px;"><P style="position: static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;"></p></td>
				                </tr>
				                <tr id="vhRowGETPRESULT" style="height:30px;display:table-row;">
					                <td style="width:260px;"><P style="position: static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">点位监测信息</p></td>
					                <td style="width: 80px;"><P style="position: static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">100</p></td>
				                </tr>
			                </table>
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
