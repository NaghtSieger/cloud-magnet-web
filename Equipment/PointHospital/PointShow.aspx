<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PointShow.aspx.cs" Inherits="Equipment_PointHospital_PointShow" %>

<!DOCTYPE html>

<HTML>
	<HEAD>
		<title>PointShow</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="../../Content/disableSelect.css" type="text/css" rel="stylesheet" />
		<script src="../../Public/Function.js"></script>
		<script type="text/javascript">
			function UnLoad()
			{
				if(window.event.screenX - window.screenLeft > document.documentElement.scrollWidth - 20 && window.event.clientY < 0 || window.event.altKey) 
				{ 
					if (document.Form1.workflag.value == "1")
					{
						GetXMLService("EXITPOST",document.Form1.hPoint.value,2);
					}
				}
			}
			
			var int = self.setInterval("SetValue()",200);
			var iCount = 0;
			function SetValue()
			{
			    var date=new Date();
			    document.getElementById("pHeart").innerHTML = date.toTimeString();

			    iCount ++;
			    if (iCount % 5 == 0)
			        SetHeart();
			    iCount %= 10;
			    var sVal = GetHtmlValue("hType", "V");

			    if (sVal == "1") {
			        GetMagnet("L");
			        GetMagnet("R");
			    }
			    if (sVal == "21" || sVal == "31")
			        GetMagnet4();
			    if (sVal == "20" || sVal == "30") {
			        GetMagnet4S("L");
			        GetMagnet4S("R");
			    }
			    SetMagnet();
			    SetPage();
            }

			function SetMagnet()
            {
			    var LColor = document.getElementById("hLLed").value;
			    var RColor = document.getElementById("hRLed").value;
			    if (RColor != "Blue" && RColor != "Orange" && RColor != "Red")
			        RColor = "Blue";
			    if (LColor != "Blue" && LColor != "Orange" && LColor != "Red")
			        LColor = "Blue";
			    if (iCount % 2 == 0)
			    {
			        document.getElementById("iLLocation0").src = "../../Images/Hospital/Location_" + LColor + "2.png";
			        document.getElementById("iLLocation1").src = "../../Images/Hospital/Location_" + LColor + "2.png";
			        document.getElementById("iLLocation2").src = "../../Images/Hospital/Location_" + LColor + "2.png";
			        document.getElementById("iLLocation3").src = "../../Images/Hospital/Location_" + LColor + "2.png";
			        document.getElementById("iLLocation4").src = "../../Images/Hospital/Location_" + LColor + "2.png";
			        document.getElementById("iRLocation0").src = "../../Images/Hospital/Location_" + RColor + "2.png";
			        document.getElementById("iRLocation1").src = "../../Images/Hospital/Location_" + RColor + "2.png";
			        document.getElementById("iRLocation2").src = "../../Images/Hospital/Location_" + RColor + "2.png";
			        document.getElementById("iRLocation3").src = "../../Images/Hospital/Location_" + RColor + "2.png";
			        document.getElementById("iRLocation4").src = "../../Images/Hospital/Location_" + RColor + "2.png";
			    }
			    else
			    {
			        document.getElementById("iLLocation0").src = "../../Images/Hospital/Location_" + LColor + "1.png";
			        document.getElementById("iLLocation1").src = "../../Images/Hospital/Location_" + LColor + "1.png";
			        document.getElementById("iLLocation2").src = "../../Images/Hospital/Location_" + LColor + "1.png";
			        document.getElementById("iLLocation3").src = "../../Images/Hospital/Location_" + LColor + "1.png";
			        document.getElementById("iLLocation4").src = "../../Images/Hospital/Location_" + LColor + "1.png";
			        document.getElementById("iRLocation0").src = "../../Images/Hospital/Location_" + RColor + "1.png";
			        document.getElementById("iRLocation1").src = "../../Images/Hospital/Location_" + RColor + "1.png";
			        document.getElementById("iRLocation2").src = "../../Images/Hospital/Location_" + RColor + "1.png";
			        document.getElementById("iRLocation3").src = "../../Images/Hospital/Location_" + RColor + "1.png";
			        document.getElementById("iRLocation4").src = "../../Images/Hospital/Location_" + RColor + "1.png";
			    }
			}
			
			function InitPage()
			{
			    var sCamera = GetHtmlValue("hCamera", "V");
			    if (sCamera == "")
			        document.getElementById("dCamera").style.display = "none";
			    else
			        document.getElementById("dCamera").style.display = "block";

			}

			function SetHeart()
			{
				if (iCount > 5)
				{
					document.getElementById("iCamera").src = "../../Images/Hospital/Camera2.png";
				}
				else
				{
					document.getElementById("iCamera").src = "../../Images/Hospital/Camera1.png";
				}
			}
			
			function GetMagnet4()
			{
			    var sValue = GetHtmlValue("pHeart","H");
			    var sEquipment = GetHtmlValue("hLEquipment", "V");
			    if (sEquipment == "")
			        return;
			    var oDoc = new ActiveXObject("MSXML2.DOMDocument");
			    oDoc.loadXML(GetXMLService("GETMRESU4", sEquipment, 2));

			    var vItem = oDoc.selectSingleNode("//root/MReuslt/COLA");
			    sValue += ";hLLed:";
			    if (vItem != null) {
			        document.getElementById("hLLed").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";

			    sValue += ";hLSign:";
			    vItem = oDoc.selectSingleNode("//root/MReuslt/IDXA");
			    if (vItem != null) {
			        document.getElementById("hLSign").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";

			    var vItem = oDoc.selectSingleNode("//root/MReuslt/POSA");
			    sValue += ";hLPos:";
			    if (vItem != null) {
			        document.getElementById("hLPos").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";

			    var vItem = oDoc.selectSingleNode("//root/MReuslt/COLB");
			    sValue += ";hRLed:";
			    if (vItem != null) {
			        document.getElementById("hRLed").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";

			    sValue += ";hRSign:";
			    vItem = oDoc.selectSingleNode("//root/MReuslt/IDXB");
			    if (vItem != null) {
			        document.getElementById("hRSign").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";

			    var vItem = oDoc.selectSingleNode("//root/MReuslt/POSB");
			    sValue += ";hRPos:";
			    if (vItem != null) {
			        document.getElementById("hRPos").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";
			    //alert(sValue);
			    //document.getElementById("pHeart").innerHTML = sValue;
			}
			
			function GetMagnet4S(sMagnet) {
			    var sValue = GetHtmlValue("pHeart", "T");

			    var sEquipment = GetHtmlValue("h" + sMagnet + "Equipment", "V");
			    if (sEquipment == "")
			        return;
			    var oDoc = new ActiveXObject("MSXML2.DOMDocument");
			    oDoc.loadXML(GetXMLService("GETMRESU4", sEquipment, 2));

			    var vItem = oDoc.selectSingleNode("//root/MReuslt/COLA");
			    sValue += ";h" + sMagnet + "Led:";
			    if (vItem != null) {
			        document.getElementById("h" + sMagnet + "Led").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";

			    sValue += ";h" + sMagnet + "Sign:";
			    vItem = oDoc.selectSingleNode("//root/MReuslt/IDXA");
			    if (vItem != null) {
			        document.getElementById("h" + sMagnet + "Sign").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";

			    var vItem = oDoc.selectSingleNode("//root/MReuslt/POSA");
			    sValue += ";h" + sMagnet + "Pos:";
			    if (vItem != null) {
			        document.getElementById("h" + sMagnet + "Pos").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";
			    //alert(sValue);
			    //document.getElementById("pHeart").innerHTML = sValue;
			}

			function GetMagnet(sMagnet)
			{
			    var sValue = GetHtmlValue("pHeart","H");
			    var sEquipment = GetHtmlValue("h" + sMagnet + "Equipment", "V");
			    var sType = GetHtmlValue("h" + sMagnet + "Type", "V");
			    if (sEquipment == "")
			        return;
			    var oDoc = new ActiveXObject("MSXML2.DOMDocument");
			    oDoc.loadXML(GetXMLService("GETMRESULT", sEquipment, 2));
			    var sColor = "Green";

			    var vItem = oDoc.selectSingleNode("//root/MReuslt/ZSDZ");
			    sValue += ";h" + sMagnet + "Led:";
			    if (vItem != null) {
			        var iLed = parseInt(vItem.nodeTypedValue);
			        if (iLed == 99)
			            sColor = "Yellow";
			        if (iLed >= 0 && iLed < 5) {
			            sColor = "Red";
			            if (sType == "Care") {
			                if (iLed == 1)
			                    iLed = 2;
			                else if (iLed == 2)
			                    iLed = 4;
			            }

			        }
			        else
			            iLed = 7;
			        document.getElementById("h" + sMagnet + "Led").value = sColor;
			        document.getElementById("h" + sMagnet + "Pos").value = iLed;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";

			    sValue += ";h" + sMagnet + "Sign:";
			    vItem = oDoc.selectSingleNode("//root/MReuslt/XHQD");
			    if (vItem != null) {
			        document.getElementById("h" + sMagnet + "Sign").value = vItem.nodeTypedValue;
			        sValue += vItem.nodeTypedValue;
			    }
			    else
			        sValue += "X";
                
				//document.getElementById("pHeart").innerHTML = sValue;
			}
			
			function SetPage()
			{
			    var vLocation = "";
			    var vLType = GetHtmlValue("hLType","V");
			    var vLLed = GetHtmlValue("hLLed","V");
			    var vLSign = parseInt(GetHtmlValue("hLSign","V"));
			    var vLPos = parseInt(GetHtmlValue("hLPos","V"));
			    var vRType = GetHtmlValue("hRType","V");
			    var vRLed = GetHtmlValue("hRLed","V");
			    var vRSign = parseInt(GetHtmlValue("hRSign","V"));
			    var vRPos = parseInt(GetHtmlValue("hRPos","V"));
			    var vLed = vLLed;
			    if (vLLed == "Red" || vRLed == "Red")
			        vLed = "Red";
			    else if (vLLed == "Orange" || vRLed == "Orange")
			        vLed = "Orange";
			    else if (vLLed == "Blue" || vRLed == "Blue")
			        vLed = "Blue";
			    else
			    {
			        vLed = vLLed;
			        if (vLed != "Green" && vLed != "Yellow")
			            vLed = "Green";
			    }
				
					
			    var vItem = document.getElementById("iBackGround");
			    if (vItem != null)
			        vItem.src = "../../Images/Hospital/Back_Hospital_" + vLed + ".png";

			    document.getElementById("dLLocation0").style.display="none";
			    document.getElementById("dLLocation1").style.display="none";
			    document.getElementById("dLLocation2").style.display="none";
			    document.getElementById("dLLocation3").style.display="none";
			    document.getElementById("dLLocation4").style.display="none";
			    document.getElementById("dRLocation0").style.display="none";
			    document.getElementById("dRLocation1").style.display="none";
			    document.getElementById("dRLocation2").style.display="none";
			    document.getElementById("dRLocation3").style.display="none";
			    document.getElementById("dRLocation4").style.display="none";
				
			    if ((vLLed == "Red" || vLLed == "Orange" || vLLed == "Blue") && vLPos >= 0 && vLPos < 5)
			    {
			        vLocation = "左侧";
			        if (vLPos == 2)
			            vLocation += "中部";
			        if (vLPos > 2)
			            vLocation += "下部";
			        if (vLPos < 2)
			        {
			            if (vLType != "Plus")
			                vLocation += "上部";
			            else
			                vLPos = 2;
			        }
			        vItem = document.getElementById("dLLocation" + vLPos);
			        if (vItem != null)
			            vItem.style.display="block";
			    }
					
			    if ((vRLed == "Red" || vRLed == "Orange" || vRLed == "Blue")  && vRPos >= 0 && vRPos < 5)
			    {
			        if (vLocation != "")
			            vLocation += "、";
			        vLocation += "右侧";
			        if (vRPos == 2)
			            vLocation += "中部";
			        if (vRPos > 2)
			            vLocation += "下部";
			        if (vRPos < 2)
			        {
			            if (vRType != "Plus")
			                vLocation += "上部";
			            else
			                vRPos = 2;
			        }
			        vItem = document.getElementById("dRLocation" + vRPos);
			        if (vItem != null)
			            vItem.style.display="block";
			    }
				
			    vItem = document.getElementById("PLocation");
			    if (vItem != null)
			    {
			        vItem.style.color = vLed;
			        vItem.innerHTML = vLocation;
			    }

			    var vAction = document.getElementById("PAction");
			    var vState = document.getElementById("PState");
			    var vAlarm = document.getElementById("PAlarm");

			    if (vAction != null)
			        vAction.style.color = vLed;
			    if (vState != null)
			        vState.style.color = vLed;
			    if (vAlarm != null)
			        vAlarm.style.color = vLed;

			    if (vLed == "Yellow")
			    {
			        if (vAction != null)
			            vAction.innerHTML = "MR检查中，请等待";
	
			        if (vState != null)
			            vState.innerHTML = "监测状态：安全!";
	
			        if (vAlarm != null)
			            vAlarm.innerHTML = "系统待机，监测中";
			    }
				
			    if (vLed == "Green")
			    {
			        if (vAction != null)
			            vAction.innerHTML = "正在进行探测";
	
			        if (vState != null)
			            vState.innerHTML = "状态：安全!";
	
			        if (vAlarm != null)
			            vAlarm.innerHTML = "未发现危险铁磁物";
			    }
				
			    if (vLed == "Blue")
			    {
			        if (vAction != null)
			            vAction.innerHTML = "正在进行探测";
	
			        if (vState != null)
			            vState.innerHTML = "危险！ 请止步!";
	
			        if (vAlarm != null)
			            vAlarm.innerHTML = "低风险铁磁物正进入！";
			    }
				
			    if (vLed == "Orange")
			    {
			        if (vAction != null)
			            vAction.innerHTML = "正在进行探测";
	
			        if (vState != null)
			            vState.innerHTML = "危险！ 请止步!";
	
			        if (vAlarm != null)
			            vAlarm.innerHTML = "中风险铁磁物正进入！";
			    }
				
			    if (vLed == "Red")
			    {
			        if (vAction != null)
			            vAction.innerHTML = "正在进行探测";
	
			        if (vState != null)
			            vState.innerHTML = "危险！ 请止步!";
	
			        if (vAlarm != null)
			            vAlarm.innerHTML = "高风险铁磁物正进入！";
			    }
			}
			
		</script>
	</HEAD>
	<body onunload="UnLoad();" bgColor="#070700" MS_POSITIONING="GridLayout" scroll="no">
		<form id="Form1" method="post" runat="server">
			<input id="workflag" type="hidden" name="workflag" runat="server"> <input id="hPoint" type="hidden" name="hPoint" runat="server"> <input id="hCamera" type="hidden" name="hCamera" runat="server"> <input id="hType" type="hidden" name="hType" runat="server">
			<input id="hLEquipment" type="hidden" name="hLEquipment" runat="server"> <input id="hLType" type="hidden" name="hLType" runat="server"> <input id="hLLed" type="hidden" value="Green" runat="server"> <input id="hLSign" type="hidden" value="0" runat="server"> <input id="hLPos" type="hidden" value="7" runat="server">
			<input id="hREquipment" type="hidden" name="hREquipment" runat="server"> <input id="hRType" type="hidden" name="hRType" runat="server"> <input id="hRLed" type="hidden" value="Green" runat="server"> <input id="hRSign" type="hidden" value="0" runat="server"> <input id="hRPos" type="hidden" value="7" runat="server">
            <div style="HEIGHT: 768px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; Z-INDEX: -1; TOP: 0px">
				<IMG id="iBackGround" src="../../Images/Hospital/Back_Hospital_R.png">
			</div>
			<div id="Logo" style="HEIGHT: 100px; WIDTH: 120px; POSITION: absolute; LEFT: 80px; TOP: 60px">
				<IMG src="../../Images/Hospital/Logo.png">
			</div>
			<div id="dCamera" style="HEIGHT: 100px; WIDTH: 100px; POSITION: absolute; LEFT: 260px; TOP: 60px">
                <IMG id="iCamera" src="../../Images/Hospital/Camera1.png">
			</div>
			<div style="HEIGHT: 768px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; TOP: 0px">
				<IMG src="../../Images/Hospital/Person.png">
			</div>
			<div style="HEIGHT: 100px; WIDTH: 360px; POSITION: absolute; LEFT: 70px; TOP: 210px">
				<p id="PAction" style="FONT-SIZE: 26pt; FONT-FAMILY: 楷体; COLOR: red"></p>
			</div>
			<div style="HEIGHT: 100px; WIDTH: 360px; POSITION: absolute; LEFT: 70px; TOP: 360px">
				<p id="PState" style="FONT-SIZE: 26pt; FONT-FAMILY: 楷体; COLOR: red"></p>
			</div>
			<div style="HEIGHT: 100px; WIDTH: 360px; POSITION: absolute; LEFT: 70px; TOP: 500px">
				<p id="PAlarm" style="FONT-SIZE: 26pt; FONT-FAMILY: 楷体; COLOR: red"></p>
			</div>
			<div style="HEIGHT: 100px; WIDTH: 360px; POSITION: absolute; LEFT: 70px; TOP: 580px">
				<p id="PLocation" style="FONT-SIZE: 26pt; FONT-FAMILY: 楷体; COLOR: red"></p>
			</div>
			<div style="HEIGHT: 100px; WIDTH: 360px; POSITION: absolute; LEFT: 80px; TOP: 650px; DISPLAY: block;">
				<p id="pStart" style="FONT-SIZE: 20pt; FONT-FAMILY: 楷体_GB2312; COLOR: blue"></p>
			</div>
			<div style="HEIGHT: 100px; WIDTH: 360px; POSITION: absolute; LEFT: 200px; TOP: 480px; ">
				<p id="pHeart" style="FONT-SIZE: 20pt; FONT-FAMILY: 楷体_GB2312; COLOR: red"></p>
			</div>
			<div id="dLLocation0" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 781px; Z-INDEX: 20; TOP: 80px">
                <IMG id="iLLocation0" src="../../Images/Hospital/Location_Red1.png">
			</div>
			<div id="dLLocation1" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 724px; Z-INDEX: 20; TOP: 200px">
                <IMG id="iLLocation1" src="../../Images/Hospital/Location_Red1.png">
			</div>
			<div id="dLLocation2" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 756px; Z-INDEX: 20; TOP: 320px">
                <IMG id="iLLocation2" src="../../Images/Hospital/Location_Red1.png">
			</div>
			<div id="dLLocation3" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 756px; Z-INDEX: 20; TOP: 440px">
                <IMG id="iLLocation3" src="../../Images/Hospital/Location_Red1.png">
			</div>
			<div id="dLLocation4" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 761px; Z-INDEX: 20; TOP: 560px">
                <IMG id="iLLocation4" src="../../Images/Hospital/Location_Red1.png">
			</div>
			<div id="dRLocation0" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 848px; Z-INDEX: 20; TOP: 80px">
                <IMG id="iRLocation0" src="../../Images/Hospital/Location_Red1.png">
			</div>
			<div id="dRLocation1" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 908px; Z-INDEX: 20; TOP: 200px">
                <IMG id="iRLocation1" src="../../Images/Hospital/Location_Red1.png">
			</div>
			<div id="dRLocation2" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 877px; Z-INDEX: 20; TOP: 320px">
                <IMG id="iRLocation2" src="../../Images/Hospital/Location_Red1.png">
			</div>
			<div id="dRLocation3" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 877px; Z-INDEX: 20; TOP: 440px">
                <IMG id="iRLocation3" src="../../Images/Hospital/Location1.png">
			</div>
			<div id="dRLocation4" style="HEIGHT: 60px; WIDTH: 60px; POSITION: absolute; LEFT: 871px; Z-INDEX: 20; TOP: 560px">
                <IMG id="iRLocation4" src="../../Images/Hospital/Location1.png">
			</div>
		</form>
		<script>
		    InitPage();
		    disableTextSelection();
		</script>
	</body>
</HTML>