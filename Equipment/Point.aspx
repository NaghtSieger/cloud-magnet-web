<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Point.aspx.cs" Inherits="Equipment_Point" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Point</title>
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
		            sCondi = GetRepCondition("txtPSerial", "DWMC", "hDepartment", "txtPName");
		        if (iLoc == 1)
		            sCondi = GetRepCondition("txtESerial", "SBMC", "txtPSerial", "txtEName");
		        return sCondi;
		    }

		    function GetRepOperate(iLoc) {
		        var sOperate = "";
		        if (iLoc == 0)
		            sOperate = "CHKPOINT";
		        if (iLoc == 1)
		            sOperate = "CHKEQUIP";
		        return sOperate;
		    }

		    function DealRepAnswer(iLoc)
		    {
		        DealRepeatAnswer(iLoc);
		    }

		    function GetRepCheck(iLoc) {
		        var sCheck = "";
		        if (iLoc == 0)
		            sCheck = "chkPName";
		        if (iLoc == 1)
		            sCheck = "chkEName";
		        return sCheck;
		    }

		    function FormSubmit() {
		        SetHtmlValue("hSubmit", "V", "1");
		        document.getElementById("drpEState").disabled = false;
		        form1.submit();
		    }

		    function CheckData() {
		        var sType = GetHtmlValue("workflag", "V");
		        switch (sType) {
		            case "btPNew":
		            case "btPUpdate":
		                if (IsNull("点位名称", "txtPName", true, "V") == 0) return;
		                break;
		            case "btENew":
		            case "btEUpdate":
		                if (IsNull("设备名称", "txtEName", true, "V") == 0) return;
		                if (IsNull("设备型号", "drpEModel", true, "V") == 0) return;
		                SetHtmlValue("hConnect", "V", GetConnect());
		                break;
		            case "btSort":
		                SetHtmlValue("hSort", "V", GetSort("lbxEquipment"));
		                break;
		        }
		        return 1;
		    }

		    function GetConnect()
		    {
		        var sConnect = "";
		        var sProxy = "Connect" + GetHtmlValue("drpEConnect", "V") + "_";
		        var oConnects = document.getElementsByTagName("*");
		        for (var i = 0; i < oConnects.length; i++)
		        {
		            if (oConnects[i].id.indexOf(sProxy) == 0)
		            {
		                var sNode = oConnects[i].id.replace(sProxy, "");
		                sConnect += "\t[" + sNode + "]" + oConnects[i].value + "[/" + sNode + "]" + "\r\n";
		            }
		        }
		        if (sConnect != "")
		            sConnect = "[Connect]\r\n" + sConnect + "[/Connect]";
		        return sConnect;
		    }

		    function DisableControl() {
		        document.getElementById("ASubmitModify").disabled = true;
		        document.getElementById("ACancelModify").disabled = true;
		        var sType = GetHtmlValue("workflag", "V");
		        if (sType != "") {
		            if (sType != "btSort") {
		                var sOperate = GetHtmlValue(sType, "data-title");
		                document.getElementById("lbOperate").innerText = sOperate;
		            }
		            document.getElementById("ASubmitModify").disabled = false;
		            document.getElementById("ACancelModify").disabled = false;
		        }
		        else
		            document.getElementById("lbOperate").innerText = "";

		        document.getElementById("btPNew").disabled = true;
		        document.getElementById("btPUpdate").disabled = true;
		        document.getElementById("btPDelete").disabled = true;
		        document.getElementById("btPReset").disabled = true;
		        document.getElementById("btPHelp").disabled = true;
		        document.getElementById("btPCopy").disabled = true;

		        document.getElementById("btENew").disabled = true;
		        document.getElementById("btEUpdate").disabled = true;
		        document.getElementById("btEDelete").disabled = true;
		        document.getElementById("btECheck").disabled = true;
		        document.getElementById("btESet").disabled = true;
		        document.getElementById("btEStop").disabled = true;

		        document.getElementById("lbxPoint").disabled = true;
		        document.getElementById("drpDepartment").disabled = true;
		        document.getElementById("txtPName").disabled = true;
		        document.getElementById("txtPLocation").disabled = true;

		        document.getElementById("lbxEquipment").disabled = true;
		        document.getElementById("btUp").disabled = true;
		        document.getElementById("btDown").disabled = true;

		        document.getElementById("txtEName").disabled = true;
		        document.getElementById("txtESort").disabled = true;
		        document.getElementById("drpEType").disabled = true;
		        document.getElementById("drpEModel").disabled = true;
		        document.getElementById("drpEState").disabled = true;
		        document.getElementById("drpERelation").disabled = true;
		        document.getElementById("drpEConnect").disabled = true;
		        document.getElementById("txtENumber").disabled = true;
		        document.getElementById("txtEPerson").disabled = true;
		        document.getElementById("txtEPhone").disabled = true;
		        document.getElementById("txtEFactory").disabled = true;
		        document.getElementById("dvConnect").disabled = true;

		        var sPermission = GetHtmlValue("hPermission", "V");
		        if (sPermission == "0") {
		            document.getElementById("lbxPoint").disabled = false;
		            document.getElementById("drpDepartment").disabled = false;
		            document.getElementById("lbxEquipment").disabled = false;
		        }
		        else {
		            switch (sType) {
		                case "btPNew":
		                case "btPUpdate":
		                    document.getElementById("txtPName").disabled = false;
		                    document.getElementById("txtPLocation").disabled = false;
		                    break;
		                case "btENew":
		                case "btEUpdate":
		                    document.getElementById("txtEName").disabled = false;
		                    document.getElementById("txtESort").disabled = false;
		                    document.getElementById("drpEType").disabled = false;
		                    document.getElementById("drpEModel").disabled = false;
		                    document.getElementById("drpERelation").disabled = false;
		                    document.getElementById("txtENumber").disabled = false;
		                    document.getElementById("txtEPerson").disabled = false;
		                    document.getElementById("txtEPhone").disabled = false;
		                    document.getElementById("txtEFactory").disabled = false;
		                    document.getElementById("dvConnect").disabled = false;
		                    document.getElementById("drpEConnect").disabled = false;
		                    break;
		                case "btPCopy":
		                    document.getElementById("drpDepartment").disabled = false;
		                    break;
		                case "btSort":
		                    document.getElementById("btUp").disabled = false;
		                    document.getElementById("btDown").disabled = false;
		                    break;
		                default:
		                    document.getElementById("drpDepartment").disabled = false;
		                    document.getElementById("lbxPoint").disabled = false;
		                    document.getElementById("btPNew").disabled = false;
		                    document.getElementById("btPUpdate").disabled = false;
		                    if (document.getElementById("txtPSerial").value != "") {
		                        document.getElementById("btPDelete").disabled = false;
		                        document.getElementById("btPReset").disabled = false;
		                        document.getElementById("btPHelp").disabled = false;
		                        document.getElementById("btPCopy").disabled = false;
		                        document.getElementById("btENew").disabled = false;
		                        document.getElementById("lbxEquipment").disabled = false;
		                        document.getElementById("btUp").disabled = false;
		                        document.getElementById("btDown").disabled = false;

		                        if (document.getElementById("txtESerial").value != "") {

		                            document.getElementById("btEUpdate").disabled = false;
		                            document.getElementById("btEDelete").disabled = false;
		                            document.getElementById("btEStop").disabled = false;
		                            document.getElementById("btECheck").disabled = false;
		                            document.getElementById("btESet").disabled = false;
		                        }
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

		        if (document.getElementById("btPNew").disabled)
		            document.getElementById("btPNew").src = "../Images/NewU.gif";
		        else
		            document.getElementById("btPNew").src = "../Images/New.gif";

		        if (document.getElementById("btPUpdate").disabled)
		            document.getElementById("btPUpdate").src = "../Images/ModifyU.gif";
		        else
		            document.getElementById("btPUpdate").src = "../Images/Modify.gif";

		        if (document.getElementById("btPDelete").disabled)
		            document.getElementById("btPDelete").src = "../Images/DeleteU.gif";
		        else
		            document.getElementById("btPDelete").src = "../Images/Delete.gif";

		        if (document.getElementById("btPReset").disabled)
		            document.getElementById("btPReset").src = "../Images/ResetU.gif";
		        else
		            document.getElementById("btPReset").src = "../Images/Reset.gif";

		        if (document.getElementById("btPHelp").disabled)
		            document.getElementById("btPHelp").src = "../Images/HelpU.gif";
		        else
		            document.getElementById("btPHelp").src = "../Images/Help.gif";

		        if (document.getElementById("btPCopy").disabled)
		            document.getElementById("btPCopy").src = "../Images/CopyU.png";
		        else
		            document.getElementById("btPCopy").src = "../Images/Copy.png";

		        if (document.getElementById("btENew").disabled)
		            document.getElementById("btENew").src = "../Images/NewU.gif";
		        else
		            document.getElementById("btENew").src = "../Images/New.gif";

		        if (document.getElementById("btEUpdate").disabled)
		            document.getElementById("btEUpdate").src = "../Images/ModifyU.gif";
		        else
		            document.getElementById("btEUpdate").src = "../Images/Modify.gif";

		        var sEState = GetHtmlValue("drpEState", "V");
		        if (sEState == "0")
		            sEState = "Stop";
		        else
		            sEState = "Employee";

		        if (document.getElementById("btEStop").disabled)
		            document.getElementById("btEStop").src = "../Images/" + sEState + "U.png";
		        else
		            document.getElementById("btEStop").src = "../Images/" + sEState + ".png";

		        if (document.getElementById("btEDelete").disabled)
		            document.getElementById("btEDelete").src = "../Images/DeleteU.gif";
		        else
		            document.getElementById("btEDelete").src = "../Images/Delete.gif";

		        if (document.getElementById("btECheck").disabled)
		            document.getElementById("btECheck").src = "../Images/CheckU.png";
		        else
		            document.getElementById("btECheck").src = "../Images/Check.png";

		        if (document.getElementById("btESet").disabled)
		            document.getElementById("btESet").src = "../Images/SetU.gif";
		        else
		            document.getElementById("btESet").src = "../Images/Set.gif";

		        if (document.getElementById("btUp").disabled)
		            document.getElementById("btUp").src = "../Images/UpU.png";
		        else
		            document.getElementById("btUp").src = "../Images/Up.png";

		        if (document.getElementById("btDown").disabled)
		            document.getElementById("btDown").src = "../Images/DownU.png";
		        else
		            document.getElementById("btDown").src = "../Images/Down.png";

		        DisableConnect();
            }

		    function DisableConnect()
		    {
		        var sConnect = GetHtmlValue("drpEConnect", "V");
		        document.getElementById("Connect_1").style.display = "none";
		        document.getElementById("Connect_2").style.display = "none";
		        document.getElementById("Connect_3").style.display = "none";
		        document.getElementById("Connect_4").style.display = "none";
		        document.getElementById("Connect_5").style.display = "none";
		        var obj = document.getElementById("Connect_" + sConnect);
		        if (obj != null)
		            obj.style.display = "block";
		    }

		    function PointHelp()
		    {
		        var sPoint = GetHtmlValue("txtPSerial", "V");
		        window.top.location.href = "PointHospital/HospitalMain.aspx?Point=" + sPoint;
		    }

		    function EquipmentPara()
		    {
		        window.event.screenY;
            }
        </script>
	</head>
    <body>
        <form id="form1" runat="server">
            <input id="workflag" type="hidden" name="workflag" runat="server"/> <input id="hDepartment" type="hidden" name="hDepartment" runat="server"/>
            <input id="hSort" type="hidden" name="hSort" runat="server"/> <input id="hConnect" type="hidden" name="hConnect" runat="server"/>
            <input id="hSubmit" type="hidden" name="hSubmit" runat="server" value="0" />  <input id="hPermission" type="hidden" name="hPermission" runat="server" value="0"/>
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">点位管理</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
				<img id="ASubmitModify" class="imgButton" style="left:80px;top:30px;" onclick="ASubmitModifyClick(this);" data-title="保存修改" src="../Images/Commit.gif" />
				<img id="ACancelModify" class="imgButton" style="left:180px;top:30px;" onclick="ACancelModifyClick(this);" data-title="取消修改" src="../Images/Cancel.gif" />
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <asp:listbox id="lbxPoint" runat="Server" AutoPostBack="True" style="position:absolute;width:200px;height:180px;left:20px;top:20px;border:double;font-family:仿宋_GB2312,Times New Roman;font-size:16pt;" OnSelectedIndexChanged="lbxPoint_SelectedIndexChanged"></asp:listbox> 
                    <asp:listbox id="lbxEquipment" runat="Server" AutoPostBack="True" style="position:absolute;width:200px;height:280px;left:20px;top:220px;border:double;font-family:仿宋_GB2312,Times New Roman;font-size:16pt;" OnSelectedIndexChanged="lbxEquipment_SelectedIndexChanged"></asp:listbox> 
					<img id="btUp" class="MoveList" style="left:220px;top:260px;" onclick="MoveListItem('lbxEquipment','1');" src="../Images/Up.png" />
					<img id="btDown" class="MoveList" style="left:220px;top:380px;" onclick="MoveListItem('lbxEquipment','2');" src="../Images/Down.png" />

                    <div class="DataArea" style ="width:720px;height:175px;top:20px;left:240px;">
                        <p class="DataTile" style ="top:20px;">管理部门</p>
                        <asp:dropdownlist id="drpDepartment" AutoPostBack="True" style="position:absolute;width:325px;height:25px;left:80px;top:15px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server" OnSelectedIndexChanged="drpDepartment_SelectedIndexChanged"></asp:dropdownlist>
                        <p class="DataTile" style ="left:400px;top:20px;">点位节点</p>
                        <input id="txtPSerial" class="DataText" style ="width:40px;left:480px;top:15px;" runat="Server" disabled="disabled" />
                        <input id="txtPName" class="DataText" style ="width:160px;left:520px;top:15px;" onblur="AsyncRepHttp(0)" runat="Server" disabled="disabled" maxlength="60" />
                        <img id="chkPName" style ="width:20px;height:20px;left:683px;top:16px;" src="../Images/CheckN.gif" />

                        <p class="DataTile" style ="top:55px;">物理位置</p>
                        <input id="txtPLocation" class="DataText" style ="width:320px;left:80px;top:50px;" runat="Server" disabled="disabled" maxlength="128" />
                        <p class="DataTile" style ="left:400px;top:55px;">心跳时间</p>
                        <input id="txtPHeart" class="DataText" style ="width:220px;left:480px;top:50px;" runat="Server" disabled="disabled" maxlength="128" />

                        <p class="DataTile" style ="top:90px;">采集服务</p>
                        <input id="txtPIP" class="DataText" style ="width:110px;left:80px;top:85px;" runat="Server" disabled="disabled" maxlength="128" />
                        <input id="txtPPort" class="DataText" style ="width:45px;left:190px;top:85px;" runat="Server" disabled="disabled" maxlength="128" />
                        <p class="DataTile" style ="left:230px;top:90px;">服务状态</p>
                        <input id="txtPState" class="DataText" style ="width:60px;left:310px;top:85px;" runat="Server" disabled="disabled" maxlength="128" />
                        <input id="txtPConflict" class="DataText" style ="width:30px;left:370px;top:85px;" runat="Server" disabled="disabled" maxlength="128" />
                        <p class="DataTile" style ="left:400px;top:90px;">启动时间</p>
                        <input id="txtPStart" class="DataText" style ="width:220px;left:480px;top:85px;" runat="Server" disabled="disabled" maxlength="128" />

                        <img id="btPNew" class="imgButton" style="left:70px;top:120px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增点位" />
                        <img id="btPUpdate" class="imgButton" style="left:170px;top:120px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改点位" />
                        <img id="btPDelete" class="imgButton" style="left:270px;top:120px;" onclick="btSubmitClick(this,true);" src="../Images/Delete.gif" data-title="删除点位" />
                        <img id="btPReset" class="imgButton" style="left:370px;top:120px;" onclick="btSubmitClick(this,true);" data-title="点位重置" src="../Images/Reset.gif" />
                        <img id="btPHelp" class="imgButton" style="left:570px;top:120px;" onclick="PointHelp();" data-title="实时预览" src="../Images/Help.gif" />
                        <img id="btPCopy" class="imgButton" style="left:470px;top:120px;" onclick="btNormalClick(this);" data-title="复制点位" src="../Images/Copy.png" />
                    </div>

                    <div class="DataArea" style ="width:720px;height:275px;top:220px;left:240px;">
                        <p class="DataTile" style ="top:20px;">设备名称</p>
                        <input id="txtESerial" class="DataText" style ="left:80px;top:15px;" runat="Server" disabled="disabled"/>
                        <input id="txtEName" class="DataText" style ="left:120px;top:15px;" runat="Server" onblur="AsyncRepHttp(1)" disabled="disabled" maxlength="60" />
                        <img id="chkEName" style ="width:20px;height:20px;left:243px;top:16px;" src="../Images/CheckN.gif" />
                        <p class="DataTile" style ="left:260px;top:20px;">内部排序</p>
                        <input id="txtESort" class="DataText" style ="left:340px;width:60px;top:15px;" runat="Server" disabled="disabled"/>
                        <p class="DataTile" style ="top:55px;">设备类型</p>
                        <asp:dropdownlist id="drpEType"  AutoPostBack="True" style="position:absolute;width:135px;height:25px;left:80px;top:50px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server" OnSelectedIndexChanged="drpEType_SelectedIndexChanged"></asp:dropdownlist>
                        <p class="DataTile" style ="left:210px;top:55px;">设备型号</p>
                        <asp:dropdownlist id="drpEModel" style="position:absolute;width:115px;height:25px;left:290px;top:50px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server"></asp:dropdownlist>
                        <p class="DataTile" style ="top:90px;">联动设备</p>
                        <asp:dropdownlist id="drpERelation" style="position:absolute;width:135px;height:25px;left:80px;top:85px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server"></asp:dropdownlist>
                        <p class="DataTile" style ="left:210px;top:90px;">设备状态</p>
                        <asp:dropdownlist id="drpEState" style="position:absolute;width:115px;height:25px;left:290px;top:85px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server"></asp:dropdownlist>
                        <p class="DataTile" style ="top:125px;">设备串号</p>
                        <input id="txtENumber" class="DataText" style ="width:130px;left:80px;top:120px;" runat="Server" disabled="disabled"/>
                        <p class="DataTile" style ="left:210px;top:125px;">连接方式</p>
                        <asp:dropdownlist id="drpEConnect" AutoPostBack="True" style="position:absolute;width:115px;height:25px;left:290px;top:120px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server" OnSelectedIndexChanged="drpEConnect_SelectedIndexChanged"></asp:dropdownlist>
                        <p class="DataTile" style ="top:160px;">联系电话</p>
                        <input id="txtEPhone" class="DataText" style ="width:130px;left:80px;top:155px;" runat="Server" disabled="disabled"/>
                        <p class="DataTile" style ="left:210px;top:160px;">责&nbsp;&nbsp;任&nbsp;&nbsp;人</p>
                        <input id="txtEPerson" class="DataText" style ="width:110px;left:290px;top:155px;" runat="Server" disabled="disabled"/>
                        <p class="DataTile" style ="top:195px;">设备厂商</p>
                        <input id="txtEFactory" class="DataText" style ="width:130px;left:80px;top:190px;" runat="Server" disabled="disabled"/>
                        <p class="DataTile" style ="left:210px;top:195px;">检修时间</p>
                        <input id="txtEOverhaul" class="DataText" style ="width:110px;left:290px;top:190px;" runat="Server" disabled="disabled"/>

                        <div class="PieceTop" style="width:300px;left:410px;top:10px;background-color:#E0E6E6;">
                            <p class="pTitle" style="width:300px;">连接参数</p>
                        </div>
                        <div id="dvConnect" class="ConnectPara" style="left:410px;top:50px;display:block"> 
                            <div id="Connect_1" class="ConnectPara" style="display:block">
                                <p class="DataTile" style ="top:5px;">IP地址</p>
                                <input id="Connect1_IP" class="DataText" style ="left:80px;" runat="Server"/>
                                <p class="DataTile" style ="top:40px;">端口号</p>
                                <input id="Connect1_Port" class="DataText" style ="left:80px;top:35px;" runat="Server"/>
                            </div>
                            <div id="Connect_2" class="ConnectPara">
                                <p class="DataTile" style ="top:5px;">端口号</p>
                                <input id="Connect2_Name" class="DataText" style ="left:80px;" runat="Server"/>
                                <p class="DataTile" style ="top:40px;">波特率</p>
                                <input id="Connect2_BaudRate" class="DataText" style ="left:80px;top:35px;" runat="Server"/>
                                <p class="DataTile" style ="top:75px;">字节长度</p>
                                <input id="Connect2_ByteSize" class="DataText" style ="left:80px;top:70px;" runat="Server"/>
                                <p class="DataTile" style ="top:110px;">奇偶校验</p>
                                <asp:dropdownlist id="Connect2_Parity" style="position:absolute;width:125px;height:25px;left:80px;top:105px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server"></asp:dropdownlist>
                                <p class="DataTile" style ="top:145px;">停止位</p>
                                <asp:dropdownlist id="Connect2_StopBits" style="position:absolute;width:125px;height:25px;left:80px;top:140px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;" runat="server"></asp:dropdownlist>
                            </div>
                            <div id="Connect_3" class="ConnectPara">
                                <p class="DataTile" style ="top:5px;">通道号</p>
                                <input id="Connect3_Chanel" class="DataText" style ="left:80px;" runat="Server"/>
                            </div>
                            <div id="Connect_4" class="ConnectPara">
                                <p class="DataTile" style ="top:5px;">流地址</p>
                                <textarea id="Connect4_Url" class="DataText" style ="width:200px;height:35px;left:80px;" runat="Server"/>
                            </div>
                            <div id="Connect_5" class="ConnectPara">
                                <p class="DataTile" style ="top:5px;">输入流</p>
                                <textarea id="Connect5_UrlS" class="DataText" style ="width:200px;height:30px;left:80px;" runat="Server"/>
                                <p class="DataTile" style ="top:40px;">输出流</p>
                                <textarea id="Connect5_UrlD" class="DataText" style ="width:200px;height:30px;left:80px;top:36px;" runat="Server"/>
                                <p class="DataTile" style ="top:75px;">模型文件</p>
                                <textarea id="Connect5_model" class="DataText" style ="width:200px;height:30px;left:80px;top:72px;" runat="Server"/>
                                <p class="DataTile" style ="top:110px;">检测周期</p>
                                <input id="Connect5_stride" class="DataText" style ="left:80px;top:108px;" runat="Server"/>
                                <p class="DataTile" style ="top:145px;">检测区域</p>
                                <input id="Connect5_rect" class="DataText" style ="width:200px;left:80px;top:140px;" runat="Server"/>
                            </div>
                        </div>
                        <img id="btENew" class="imgButton" style="left:70px;top:220px;" onclick="btNormalClick(this);" src="../Images/New.gif" data-title="新增设备" />
                        <img id="btEUpdate" class="imgButton" style="left:170px;top:220px;" onclick="btNormalClick(this);" src="../Images/Modify.gif" data-title="修改设备" />
                        <img id="btEDelete" class="imgButton" style="left:270px;top:220px;" onclick="btSubmitClick(this,true);" src="../Images/Delete.gif" data-title="删除设备" />
                        <img id="btECheck" class="imgButton" style="left:470px;top:220px;" onclick="btSubmitClick(this,true);" data-title="设备检修" src="../Images/Check.png" />
                        <img id="btESet" class="imgButton" style="left:570px;top:220px;" onclick="EquipmentPara();" data-title="参数配置" src="../Images/Set.gif" />
                        <img id="btEStop" class="imgButton" style="left:370px;top:220px;" onclick="btSubmitClick(this,true);" data-title="设备启停" src="../Images/Stop.png" />
                    </div>
                </div>
            </div>
        </form>
		<script type="text/javascript">
			DisableControl();		
		</script>
    </body>
</html>
