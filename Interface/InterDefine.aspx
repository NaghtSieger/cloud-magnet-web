<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InterDefine.aspx.cs" Inherits="Interface_InterDefine" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>InterDefine</title>
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
		            sCondi = GetRepCondition("txtSerial", "JKBH", "", "txtSerial");
		        if (iLoc == 1)
		            sCondi = GetRepCondition("txtSerial", "XSMC", "", "txtName");
		        if (iLoc == 2)
		            sCondi = GetRepCondition("txtISerial", "SCBH", "txtSerial", "txtISerial");
		        if (iLoc == 3)
		            sCondi = GetRepCondition("txtISerial", "XSMC", "txtSerial", "txtIName");
		        return sCondi;
		    }

		    function GetRepOperate(iLoc) {
		        var sOperate = "";
		        if (iLoc == 0 || iLoc == 1)
		            sOperate = "CHKIDEFINE";
		        if (iLoc == 2 || iLoc == 3)
		            sOperate = "CHKIITEM";
		        return sOperate;
		    }

		    function DealRepAnswer(iLoc) {
		        DealRepeatAnswer(iLoc);
		    }

		    function GetRepCheck(iLoc) {
		        var sCheck = "";
		        if (iLoc == 0)
		            sCheck = "chkSerail";
		        if (iLoc == 1)
		            sCheck = "chkName";
		        if (iLoc == 2)
		            sCheck = "chkISerial";
		        if (iLoc == 3)
		            sCheck = "chkIName";
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

		        document.getElementById("btNew").disabled = true;
		        document.getElementById("btUpdate").disabled = true;
		        document.getElementById("btDelete").disabled = true;

		        document.getElementById("lbxInter").disabled = true;
		        document.getElementById("txtSerial").disabled = true;
		        document.getElementById("chSystem").disabled = true;
		        document.getElementById("txtName").disabled = true;
		        document.getElementById("txtMemo").disabled = true;

		        document.getElementById("btINew").disabled = true;
		        document.getElementById("btIUpdate").disabled = true;
		        document.getElementById("btIDelete").disabled = true;
		        
		        document.getElementById("drpItem").disabled = true;
		        document.getElementById("txtISerial").disabled = true;
		        document.getElementById("txtINote").disabled = true;
		        document.getElementById("txtIName").disabled = true;
		        document.getElementById("txtIMemo").disabled = true;
		        document.getElementById("txtISql").disabled = true;

		        switch (sType) {
		            case "btNew":
		            case "btUpdate":
                        if (sType == "btNew")
    		                document.getElementById("txtSerial").disabled = false;
		                if (GetHtmlValue("hPermission", "V") == "1")
		                    document.getElementById("chSystem").disabled = false;
		                document.getElementById("txtName").disabled = false;
		                document.getElementById("txtMemo").disabled = false;
		                break;
		            case "btINew":
		            case "btIUpdate":
		                if (sType == "btINew")
		                    document.getElementById("txtISerial").disabled = false;
		                document.getElementById("txtINote").disabled = false;
		                document.getElementById("txtIName").disabled = false;
		                document.getElementById("txtIMemo").disabled = false;
		                document.getElementById("txtISql").disabled = false;
		                break;
		            default:
		                document.getElementById("lbxInter").disabled = false;
		                document.getElementById("btNew").disabled = false;
		                if (GetHtmlValue("txtSerial","V") != "") {
		                    document.getElementById("btUpdate").disabled = false;
		                    document.getElementById("btDelete").disabled = false;
		                    document.getElementById("btINew").disabled = false;
		                    document.getElementById("drpItem").disabled = false;
		                    if (GetHtmlValue("txtISerial", "V") != "") {
		                        document.getElementById("btIUpdate").disabled = false;
		                        document.getElementById("btIDelete").disabled = false;
		                    }
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

                if (document.getElementById("btINew").disabled)
                    document.getElementById("btINew").src = "../Images/NewU.gif";
                else
                    document.getElementById("btINew").src = "../Images/New.gif";

                if (document.getElementById("btIUpdate").disabled)
                    document.getElementById("btIUpdate").src = "../Images/ModifyU.gif";
                else
                    document.getElementById("btIUpdate").src = "../Images/Modify.gif";

                if (document.getElementById("btIDelete").disabled)
                    document.getElementById("btIDelete").src = "../Images/DeleteU.gif";
                else
                    document.getElementById("btIDelete").src = "../Images/Delete.gif";

            }
		</script>
    </head>
    <body>
        <form id="form1" runat="server">
            <input id="workflag" type="hidden" name="workflag" runat="server" /> <input id="hPermission" type="hidden" name="hPermission" runat="server" value="0"/>
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">接口定义</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
				<img id="ASubmitModify" class="imgButton" style="left:80px;top:30px;" onclick="ASubmitModifyClick(this);" data-title="保存修改" src="../Images/Commit.gif" />
				<img id="ACancelModify" class="imgButton" style="left:180px;top:30px;" onclick="ACancelModifyClick(this);" data-title="取消修改" src="../Images/Cancel.gif" />
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <asp:listbox id="lbxInter" runat="Server" AutoPostBack="True" style="position:absolute;width:200px;height:480px;left:20px;top:20px;border:double;font-family:仿宋_GB2312,Times New Roman;font-size:16pt;" OnSelectedIndexChanged="lbxInter_SelectedIndexChanged"></asp:listbox> 
                    <div class="DataArea" style ="width:720px;height:100px;top:20px;left:240px;">
                        <p class="DataTile" style ="top:20px;">接口编号</p>
                        <input id="txtSerial" class="DataText" style ="left:80px;top:15px;" onblur="AsyncRepHttp(0)" runat="Server" disabled="disabled" maxlength="60" />
                        <img id="chkSerail" style ="width:20px;height:20px;left:203px;top:16px;" src="../Images/CheckN.gif" />
                        <p class="DataTile" style ="width:40px;text-align:left;left:220px;top:20px;">系统</p>
                        <input id="chSystem" type="checkbox"  class="DataText" style ="width:20px;left:255px;top:15px;" runat="Server" />
                        <p class="DataTile" style ="left:270px;top:20px;">接口名称</p>
                        <input id="txtName" class="DataText" style ="width:110px;left:350px;top:15px;" onblur="AsyncRepHttp(1)" runat="Server" disabled="disabled" maxlength="60" />
                        <img id="chkName" style ="width:20px;height:20px;left:463px;top:16px;" src="../Images/CheckN.gif" />
                        <p class="DataTile" style ="left:480px;top:20px;">角色描述</p>
                        <textarea id="txtMemo" class="DataText" style ="width:140px;height:30px;left:560px;top:15px;overflow:auto;" runat="Server" disabled="disabled" maxlength="128" />
                        <img id="btNew" class="imgButton" style="left: 70px;top:50px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增接口" />
                        <img id="btUpdate" class="imgButton" style="left:170px;top:50px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改接口" />
                        <img id="btDelete" class="imgButton" style="left:270px;top:50px;" onclick="btSubmitClick(this,true);" src="../Images/Delete.gif" data-title="删除接口" />
                    </div>
                    <div class="DataArea" style ="width:720px;height:360px;top:135px;left:240px;">
						<p class="DataTile" style ="top:20px;">输出节点</p>
						<asp:dropdownlist id="drpItem" AutoPostBack="True" style="position:absolute;width:35px;height:25px;left:80px;top:15px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server" OnSelectedIndexChanged="drpItem_SelectedIndexChanged"></asp:dropdownlist>
						<input id="txtISerial" class="DataText" style ="width:20px;left:117px;top:15px;" onblur="AsyncRepHttp(2)" runat="Server" disabled="disabled" maxlength="2"/>
						<img id="chkISerial" style ="width:20px;height:20px;left:140px;top:16px;" src="../Images/CheckN.gif" />
						<input id="txtINote" class="DataText" style ="width:110px;left:162px;top:15px;" runat="Server" disabled="disabled" maxlength="30" value=""/>
						<p class="DataTile" style ="left:270px;top:20px;">输出名称</p>
						<input id="txtIName" class="DataText" style ="width:110px;left:350px;top:15px;" onblur="AsyncRepHttp(3)" runat="Server" disabled="disabled" maxlength="60" />
						<img id="chkIName" style ="width:20px;height:20px;left:463px;top:16px;" src="../Images/CheckN.gif" />
						<p class="DataTile" style ="left:480px;top:20px;">输出描述</p>
                        <textarea id="txtIMemo" class="DataText" style ="width:140px;height:30px;left:560px;top:15px;overflow:auto;" runat="Server" disabled="disabled" maxlength="128" />
						<img id="btINew" class="imgButton" style="left: 70px;top:50px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增输出" />
						<img id="btIUpdate" class="imgButton" style="left:170px;top:50px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改输出" />
						<img id="btIDelete" class="imgButton" style="left:270px;top:50px;" onclick="btSubmitClick(this,true);" src="../Images/Delete.gif" data-title="删除输出" />
                        <p class="DataTile" style ="top:60px;left:625px;">输出明细</p>
                        <textarea id="txtISql" class="DataText" style ="width:690px;height:240px;left:10px;top:85px;overflow:auto;" runat="Server"/>
                    </div>
                 </div>
            </div>
        </form>
		<script type="text/javascript">
			DisableControl();		
		</script>
    </body>
</html>
