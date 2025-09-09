<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PointShowIn.aspx.cs" Inherits="Equipment_PointHospital_PointShowIn" %>

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
			
		    function InitPage()
		    {
		        //环境监测
		        var sVal = GetHtmlValue("hWName1", "V");
		        document.getElementById("pWost_L_1").innerHTML = sVal;
		        document.getElementById("pWost_M_1").innerHTML = sVal;
		        sVal = GetHtmlValue("hWName2", "V");
		        document.getElementById("pWost_L_2").innerHTML = sVal;
		        document.getElementById("pWost_M_2").innerHTML = sVal;
		        
		        //视频div设置

		        //视频名称
		        sVal = GetHtmlValue("hCamName1", "V");
		        document.getElementById("pLVedio_1").innerHTML = sVal;
		        sVal = GetHtmlValue("hCamName2", "V");
		        document.getElementById("pLVedio_2").innerHTML = sVal;
		        document.getElementById("pMVedio_2").innerHTML = sVal;
		        sVal = GetHtmlValue("hCamName3", "V");
		        document.getElementById("pLVedio_3").innerHTML = sVal;
		        document.getElementById("pMVedio_3").innerHTML = sVal;
		        sVal = GetHtmlValue("hCamName4", "V");
		        document.getElementById("pLVedio_4").innerHTML = sVal;
		        document.getElementById("pMVedio_4").innerHTML = sVal;
		        SetVedio("1");
		        SetVedio("2");
		        SetVedio("3");
		        SetVedio("4");
            }

		    var int = self.setInterval("SetValue()", 200);
		    var iCount = 0;
		    function SetValue()
		    {
		        var date = new Date();
		        document.getElementById("pHeart").innerHTML = date.toTimeString();
		        var sVal = GetHtmlValue("hType", "V");

		        if (sVal == "1") {
		            SetMagnet("L");
		            SetMagnet("R");
		        }
		        else
		            SetMagnet4();
		        SetWost("1");
		        SetWost("2");

		        var vLLed = GetHtmlValue("hLLed", "V");
		        var vLType = GetHtmlValue("hLType", "V");
		        var vLPos = parseInt(GetHtmlValue("hLPos", "V"));
		        var vRLed = GetHtmlValue("hRLed", "V");
		        var vRType = GetHtmlValue("hRType", "V");
		        var vRPos = parseInt(GetHtmlValue("hRPos", "V"));
		        var vLed = vLLed;
		        if (vLLed == "Red" || vRLed == "Red")
		            vLed = "Red";
		        else if (vLLed == "Orange" || vRLed == "Orange")
		            vLed = "Orange";
		        else if (vLLed == "Blue" || vRLed == "Blue")
		            vLed = "Blue";

		        var vItem = document.getElementById("iBackGround");
		        if (vItem != null)
		            vItem.src = "../../Images/Hospital/Back_Hospital_" + vLed + "1.png";

                //柱子灯色设置
		        document.getElementById("iMagnet_LRH").src = "../../Images/Hospital/Magnet_L_H_" + vRLed + ".png";
		        document.getElementById("iMagnet_LRB_0").src = "../../Images/Hospital/Magnet_L_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_LRB_1").src = "../../Images/Hospital/Magnet_L_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_LRB_2").src = "../../Images/Hospital/Magnet_L_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_LRB_3").src = "../../Images/Hospital/Magnet_L_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_LRB_4").src = "../../Images/Hospital/Magnet_L_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_LLH").src = "../../Images/Hospital/Magnet_L_H_" + vLLed + ".png";
		        document.getElementById("iMagnet_LLB_0").src = "../../Images/Hospital/Magnet_L_B_" + vLLed + ".png";
		        document.getElementById("iMagnet_LLB_1").src = "../../Images/Hospital/Magnet_L_B_" + vLLed + ".png";
		        document.getElementById("iMagnet_LLB_2").src = "../../Images/Hospital/Magnet_L_B_" + vLLed + ".png";
		        document.getElementById("iMagnet_LLB_3").src = "../../Images/Hospital/Magnet_L_B_" + vLLed + ".png";
		        document.getElementById("iMagnet_LLB_4").src = "../../Images/Hospital/Magnet_L_B_" + vLLed + ".png";

		        document.getElementById("iMagnet_MRH").src = "../../Images/Hospital/Magnet_M_H_" + vRLed + ".png";
		        document.getElementById("iMagnet_MRB_0").src = "../../Images/Hospital/Magnet_M_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_MRB_1").src = "../../Images/Hospital/Magnet_M_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_MRB_2").src = "../../Images/Hospital/Magnet_M_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_MRB_3").src = "../../Images/Hospital/Magnet_M_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_MRB_4").src = "../../Images/Hospital/Magnet_M_B_" + vRLed + ".png";
		        document.getElementById("iMagnet_MLH").src = "../../Images/Hospital/Magnet_M_H_" + vLLed + ".png";
		        document.getElementById("iMagnet_MLB_0").src = "../../Images/Hospital/Magnet_M_B_" + vLLed + ".png";
		        document.getElementById("iMagnet_MLB_1").src = "../../Images/Hospital/Magnet_M_B_" + vLLed + ".png";
		        document.getElementById("iMagnet_MLB_2").src = "../../Images/Hospital/Magnet_M_B_" + vLLed + ".png";
		        document.getElementById("iMagnet_MLB_3").src = "../../Images/Hospital/Magnet_M_B_" + vLLed + ".png";
		        document.getElementById("iMagnet_MLB_4").src = "../../Images/Hospital/Magnet_M_B_" + vLLed + ".png";

                //柱子灯位置设置
		        document.getElementById("divMagnet_LRB_0").style.display = "none";
		        document.getElementById("divMagnet_LRB_1").style.display = "none";
		        document.getElementById("divMagnet_LRB_2").style.display = "none";
		        document.getElementById("divMagnet_LRB_3").style.display = "none";
		        document.getElementById("divMagnet_LRB_4").style.display = "none";
		        document.getElementById("divMagnet_LLB_0").style.display = "none";
		        document.getElementById("divMagnet_LLB_1").style.display = "none";
		        document.getElementById("divMagnet_LLB_2").style.display = "none";
		        document.getElementById("divMagnet_LLB_3").style.display = "none";
		        document.getElementById("divMagnet_LLB_4").style.display = "none";
		        document.getElementById("divMagnet_MRB_0").style.display = "none";
		        document.getElementById("divMagnet_MRB_1").style.display = "none";
		        document.getElementById("divMagnet_MRB_2").style.display = "none";
		        document.getElementById("divMagnet_MRB_3").style.display = "none";
		        document.getElementById("divMagnet_MRB_4").style.display = "none";
		        document.getElementById("divMagnet_MLB_0").style.display = "none";
		        document.getElementById("divMagnet_MLB_1").style.display = "none";
		        document.getElementById("divMagnet_MLB_2").style.display = "none";
		        document.getElementById("divMagnet_MLB_3").style.display = "none";
		        document.getElementById("divMagnet_MLB_4").style.display = "none";

		        if (vLPos >= 0 && vLPos < 5)
		        {
		            document.getElementById("divMagnet_LLB_" + vLPos).style.display = "block";
		            document.getElementById("divMagnet_MLB_" + vLPos).style.display = "block";
		        }
		        if (vLPos == 7)
		        {
		            document.getElementById("divMagnet_LLB_0").style.display = "block";
		            document.getElementById("divMagnet_MLB_0").style.display = "block";
		            if (vLType == "Care" || vLType == "Smart")
		            {
		                document.getElementById("divMagnet_LLB_2").style.display = "block";
		                document.getElementById("divMagnet_MLB_2").style.display = "block";
		                document.getElementById("divMagnet_LLB_4").style.display = "block";
		                document.getElementById("divMagnet_MLB_4").style.display = "block";
		                if (vLType == "Smart")
		                {
		                    document.getElementById("divMagnet_LLB_1").style.display = "block";
		                    document.getElementById("divMagnet_MLB_1").style.display = "block";
		                    document.getElementById("divMagnet_LLB_3").style.display = "block";
		                    document.getElementById("divMagnet_MLB_3").style.display = "block";
		                }
                    }
		        }

		        if (vRPos >= 0 && vRPos < 5) {
		            document.getElementById("divMagnet_LRB_" + vRPos).style.display = "block";
		            document.getElementById("divMagnet_MRB_" + vRPos).style.display = "block";
		        }
		        if (vRPos == 7) {
		            document.getElementById("divMagnet_LRB_0").style.display = "block";
		            document.getElementById("divMagnet_MRB_0").style.display = "block";
		            if (vRType == "Care" || vRType == "Smart") {
		                document.getElementById("divMagnet_LRB_2").style.display = "block";
		                document.getElementById("divMagnet_MRB_2").style.display = "block";
		                document.getElementById("divMagnet_LRB_4").style.display = "block";
		                document.getElementById("divMagnet_MRB_4").style.display = "block";
		                if (vRType == "Smart") {
		                    document.getElementById("divMagnet_LRB_1").style.display = "block";
		                    document.getElementById("divMagnet_MRB_1").style.display = "block";
		                    document.getElementById("divMagnet_LRB_3").style.display = "block";
		                    document.getElementById("divMagnet_MRB_3").style.display = "block";
		                }
		            }
		        }

                //环境监测赋值
		        sVal = GetHtmlValue("hWValue1", "V");
		        document.getElementById("pWost_L_V_1").innerHTML = sVal;
		        document.getElementById("pWost_M_V_1").innerHTML = sVal;
		        sVal = GetHtmlValue("hWValue2", "V");
		        document.getElementById("pWost_L_V_2").innerHTML = sVal;
		        document.getElementById("pWost_M_V_2").innerHTML = sVal;

		        //环境监测背景
		        sVal = GetHtmlValue("hWAlarm1", "V");
		        if (sVal == "0" || sVal == "")
		        {
		            document.getElementById("iWost_L_1").src = "../../Images/Hospital/Wost_L_White.png";
		            document.getElementById("iWost_M_1").src = "../../Images/Hospital/Wost_M_White.png";
		        }
		        else
		        {
		            document.getElementById("iWost_L_1").src = "../../Images/Hospital/Wost_L_Red.png";
		            document.getElementById("iWost_M_1").src = "../../Images/Hospital/Wost_M_Red.png";
		        }

		        sVal = GetHtmlValue("hWAlarm2", "V");
		        if (sVal == "0" || sVal == "")
		        {
		            document.getElementById("iWost_L_2").src = "../../Images/Hospital/Wost_L_White.png";
		            document.getElementById("iWost_M_2").src = "../../Images/Hospital/Wost_M_White.png";
		        }
		        else {
		            document.getElementById("iWost_L_2").src = "../../Images/Hospital/Wost_L_Red.png";
		            document.getElementById("iWost_M_2").src = "../../Images/Hospital/Wost_M_Red.png";
		        }

            }

		    function SetMagnet4()
		    {
		        var sValue = "";

		        var sEquipment = GetHtmlValue("hLMagnet", "V");
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

		    function SetWost(sWost) {
		        var sValue = "";

		        var sEquipment = GetHtmlValue("hWost" + sWost,"V");
		        if (sEquipment == "")
		            return;
		        var oDoc = new ActiveXObject("MSXML2.DOMDocument");
		        oDoc.loadXML(GetXMLService("GETWRESULT", sEquipment, 2));

		        var vItem = oDoc.selectSingleNode("//root/WReuslt/JCZ");
		        sValue += ";hWValue:";
		        if (vItem != null) {
		            document.getElementById("hWValue" + sWost).value = vItem.nodeTypedValue;
		            sValue += vItem.nodeTypedValue;
		        }
		        else
		            sValue += "X";

		        sValue += ";hWAlarm:";
		        vItem = oDoc.selectSingleNode("//root/WReuslt/GJZT");
		        if (vItem != null) {
		            document.getElementById("hWAlarm" +sWost).value = vItem.nodeTypedValue;
		            sValue += vItem.nodeTypedValue;
		        }
		        else
		            sValue += "X";
		        //alert(sValue);
		        //document.getElementById("pHeart").innerHTML = sValue;
		    }

		    function SetMagnet(sMagnet)
		    {
		        var sValue = "";
		        var sEquipment = GetHtmlValue("h" + sMagnet + "Magnet", "V");
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
		        //alert(sValue);
		        //document.getElementById("pHeart").innerHTML = sValue;
		    }

		    function SetVedio(iVedio) {
		        var sUrl = GetHtmlValue("hCamUrl" + iVedio, "V");
		        if (sUrl != "") {
		            var vlc = document.getElementById("vlcLVedio_" + iVedio);
		            var options = [":network-caching=300"];
		            var itemId = -1;
		            if (vlc != null) {
		                vlc.palaylist.stop();
		                vlc.palaylist.clear();
		                itemId = vlc.playlist.add(sUrl, "", options);
		                if (itemId != -1) {
		                    vlc.playlist.playItem(itemId);
		                }
		            }
		            if (iVedio != "1") {
		                var vlc = document.getElementById("vlcMVedio_" + iVedio);
		                if (vlc != null) {
		                    vlc.palaylist.stop();
		                    vlc.palaylist.clear();
		                    itemId = vlc.playlist.add(sUrl, "", options);
		                    if (itemId != -1) {
		                        vlc.playlist.playItem(itemId);
		                    }
		                }

		            }
		        }

		        function ChangVedio(iVedio) {
		            var vItem = document.getElementById("hCamera" + iVedio);
		            if (vItem != null && vItem.value != "") {
		                var sTemp = document.getElementById("hCamera1").value;
		                document.getElementById("hCamera1").value() = vItem.value;
		                vItem.vaue = sTemp;

		                var sTemp = document.getElementById("hCamName1").value;
		                vItem = document.getElementById("hCamName" + iVedio);
		                document.getElementById("hCamName1").value() = vItem.value;
		                if (vItem != null)
		                    vItem.value = sTemp;

		                var sTemp = document.getElementById("hCamUrl1").value;
		                vItem = document.getElementById("hCamUrl" + iVedio);
		                document.getElementById("hCamUrl1").value() = vItem.value;
		                if (vItem != null)
		                    vItem.value = sTemp;
		                SetVedio("1");
		                SetVedio(iVedio);
		            }
		        }

		        function ChangeMenu(iMenu) {
		            var iOld = parseInt(document.getElementById("hMenu").value);
		            if (iMenu == iOld)
		                return;
		            switch (iOld) {
		                case 1:
		                    document.getElementById("divMagenetL").style.display = "none";
		                    document.getElementById("divMenu").style.display = "none";
		                    break;
		                case 2:
		                    document.getElementById("divWostL").style.display = "none";
		                    document.getElementById("divMenu").style.display = "none";
		                    break;
		                case 3:
		                    document.getElementById("divVedio1").style.display = "none";
		                    document.getElementById("divWostM").style.display = "none";
		                    document.getElementById("divMagnetM").style.display = "none";
		                    document.getElementById("divVedioM").style.display = "none";
		                    document.getElementById("divVersion").style.display = "none";
		                    break;
		                case 4:
		                    document.getElementById("divVedio1").style.display = "none";
		                    document.getElementById("divVedioL").style.display = "none";
		                    document.getElementById("divMenu").style.display = "none";
		                    break;
		                case 5:
		                    document.getElementById("divFunction").style.display = "none";
		                    document.getElementById("divMenu").style.display = "none";
		                    break;
		            }
		            switch (iMenu) {
		                case 1:
		                    document.getElementById("divMagenetL").style.display = "block";
		                    document.getElementById("divMenu").style.display = "block";
		                    break;
		                case 2:
		                    document.getElementById("divWostL").style.display = "block";
		                    document.getElementById("divMenu").style.display = "block";
		                    break;
		                case 3:
		                    document.getElementById("divVedio1").style.display = "block";
		                    document.getElementById("divWostM").style.display = "block";
		                    document.getElementById("divMagnetM").style.display = "block";
		                    document.getElementById("divVedioM").style.display = "block";
		                    document.getElementById("divVersion").style.display = "block";
		                    break;
		                case 4:
		                    document.getElementById("divVedio1").style.display = "block";
		                    document.getElementById("divVedioL").style.display = "block";
		                    document.getElementById("divMenu").style.display = "block";
		                    break;
		                case 5:
		                    document.getElementById("divFunction").style.display = "block";
		                    document.getElementById("divMenu").style.display = "block";
		                    break;
		            }
		            document.getElementById("hMenu").value = iMenu;
		        }
		    }

        </script>
	</HEAD>
	<body onunload="UnLoad();" bgColor="#070700" MS_POSITIONING="GridLayout" scroll="no">
		<form id="Form1" method="post"  runat="server">
			<input id="workflag" type="hidden" name="workflag" runat="server"> <input id="hPoint" type="hidden" name="hPoint" runat="server">

			<input id="hLMagnet" type="hidden" name="hLMagnet" runat="server"> <input id="hLType" type="hidden" name="hLType" runat="server"> <input id="hLLed" type="hidden" name="hLLed" value="Green" runat="server"> <input id="hLSign" type="hidden" name="hLSign" value="" runat="server"> <input id="hLPos" type="hidden" name="hLPos" value="7" runat="server"> 
            <input id="hRMagnet" type="hidden" name="hRMagnet" runat="server"> <input id="hRType" type="hidden" name="hRType" runat="server"> <input id="hRLed" type="hidden" name="hRLed" value="Green" runat="server"> <input id="hRSign" type="hidden" name="hRSign" value="" runat="server"> <input id="hRPos" type="hidden" name="hRPos" value="7" runat="server">
            <input id="hLed" type="hidden" name="hLed" value="Green" runat="server"> <input id="hType" type="hidden" name="hType" value="2" runat="server">
             
			<input id="hCamera1" type="hidden" name="hCamera1" runat="server"> <input id="hCamUrl1" type="hidden" name="hCamUrl1" runat="server"> <input id="hCamName1" type="hidden" name="hCamName1" runat="server">
            <input id="hCamera2" type="hidden" name="hCamera2" runat="server"> <input id="hCamUrl2" type="hidden" name="hCamUrl2" runat="server"> <input id="hCamName2" type="hidden" name="hCamName2" runat="server">
            <input id="hCamera3" type="hidden" name="hCamera3" runat="server"> <input id="hCamUrl3" type="hidden" name="hCamUrl3" runat="server"> <input id="hCamName3" type="hidden" name="hCamName3" runat="server">
            <input id="hCamera4" type="hidden" name="hCamera4" runat="server"> <input id="hCamUrl4" type="hidden" name="hCamUrl4" runat="server"> <input id="hCamName4" type="hidden" name="hCamName4" runat="server">

            <input id="hWost1" type="hidden" name="hWost1" runat="server"> <input id="hWValue1" type="hidden" name="hWValue1" runat="server"> <input id="hWName1" type="hidden" name="hWName1" runat="server"> <input id="hWAlarm1" type="hidden" name="hWAlarm1" runat="server"> 
            <input id="hWost2" type="hidden" name="hWost2" runat="server"> <input id="hWValue2" type="hidden" name="hWValue2" runat="server"> <input id="hWName2" type="hidden" name="hWName2" runat="server"> <input id="hWAlarm2" type="hidden" name="hWAlarm2" runat="server"> 

            <input id="hMenu" type="hidden" name="hMenu" value="3" runat="server">

			<div style="HEIGHT: 768px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; Z-INDEX: -1; TOP: 0px;">
				<IMG id="iBackGround" style="HEIGHT: 768px; WIDTH: 1280px;" src="../../Images/Hospital/Back_Hospital_Green1.png">
			</div>
			<div id="divVedio1" onclick="ChangeMenu(4);" style="HEIGHT: 666px; WIDTH: 888px; POSITION: absolute; LEFT: 10px; Z-INDEX: 0; TOP: 10px;">
			    <div id="divLVedio_1" style="HEIGHT: 666px; WIDTH: 888px; POSITION: absolute; LEFT: 0px; Z-INDEX: 1; TOP: 0px;">
			        <OBJECT id="vlcLVedio_1" width="888" height="666" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
				        type="application/x-vlc-plugin" events="True">
				        <PARAM NAME="AutoLoop" VALUE="0">
				        <PARAM NAME="AutoPlay" VALUE="-1">
				        <PARAM NAME="Toolbar" VALUE="0">
				        <PARAM NAME="MRL" VALUE="">
						<PARAM name="BackColor" value="0">
				        <PARAM name="fullscreen" value="false">
			        </OBJECT>
                </div>
 			    <div style="HEIGHT: 200px; WIDTH: 888px; POSITION: absolute; left:48px; TOP: 27px; Z-INDEX: 2;">
				    <p id="pLVedio_1" style="FONT-SIZE: 25pt; COLOR: white; FONT-FAMILY: 楷体_GB2312" >暂无视频</p>
                </div>
           </div>
			<div id="divMagenetL" style="HEIGHT: 666px; WIDTH: 630px; POSITION: absolute; LEFT: 10px; Z-INDEX: 0; TOP: 10px;DISPLAY: none;">
                <div style="height: 308px; width: 17px; position: absolute; left: 120px; z-index: 0; top: 21px; display: block;">
                    <img style="height: 600px; width: 34px; position: absolute; left: 0px; top: 15px; z-index: 1;" src="../../Images/Hospital/Magnet_L_Main.png">
                    <div id="divMagnet_LLH" style="height: 52px; width: 33px; position: absolute; left: 0px; top: 15px; z-index: 2; display: block;">
                        <img id="iMagnet_LLH" src="../../Images/Hospital/Magnet_L_H_Green.png">
                    </div>
                    <div id="divMagnet_LLB_0" style="height: 62px; width: 8px; position: absolute; left: 13px; top: 91px; z-index: 2; display: block;">
                        <img id="iMagnet_LLB_0" src="../../Images/Hospital/Magnet_L_B_Green.png">
                    </div>
                    <div id="divMagnet_LLB_1" style="height: 62px; width: 8px; position: absolute; left: 13px; top: 187px; z-index: 2; display: block;">
                        <img id="iMagnet_LLB_1" src="../../Images/Hospital/Magnet_L_B_Green.png">
                    </div>
                    <div id="divMagnet_LLB_2" style="height: 62px; width: 8px; position: absolute; left: 13px; top: 283px; z-index: 2; display: block;">
                        <img id="iMagnet_LLB_2" src="../../Images/Hospital/Magnet_L_B_Green.png">
                    </div>
                    <div id="divMagnet_LLB_3" style="height: 62px; width: 8px; position: absolute; left: 13px; top: 379px; z-index: 2; display: block;">
                        <img id="iMagnet_LLB_3" src="../../Images/Hospital/Magnet_L_B_Green.png">
                    </div>
                    <div id="divMagnet_LLB_4" style="height: 62px; width: 8px; position: absolute; left: 13px; top: 475px; z-index: 2; display: block;">
                        <img id="iMagnet_LLB_4" src="../../Images/Hospital/Magnet_L_B_Green.png">
                    </div>
                </div>
				<IMG style="HEIGHT: 579px; WIDTH: 246px;POSITION: absolute;left:196px; top:53px; Z-INDEX: 1;" src="../../Images/Hospital/Person_1.png">
			    <div style="HEIGHT: 308px; WIDTH: 17px; POSITION: absolute; LEFT: 493px; Z-INDEX: 0; TOP: 21px;DISPLAY: block;">
				    <IMG style="HEIGHT: 600px; WIDTH: 34px;POSITION: absolute;left:0px; top:15px; Z-INDEX: 1;" src="../../Images/Hospital/Magnet_L_Main.png">
				    <div id="divMagnet_LRH" style="HEIGHT: 52px; WIDTH: 33px;POSITION: absolute;left:0px; top: 15px; Z-INDEX: 2;">
					    <IMG id="iMagnet_LRH" src="../../Images/Hospital/Magnet_L_H_Green.png">
				    </div>
				    <div id="divMagnet_LRB_0" style="HEIGHT: 62px; WIDTH: 8px;POSITION: absolute;left:13px; top: 91px; Z-INDEX: 2;">
					    <IMG id="iMagnet_LRB_0" src="../../Images/Hospital/Magnet_L_B_Green.png">
				    </div>
				    <div id="divMagnet_LRB_1" style="HEIGHT: 62px; WIDTH: 8px;POSITION: absolute;left:13px; top: 187px; Z-INDEX: 2;">
					    <IMG id="iMagnet_LRB_1" src="../../Images/Hospital/Magnet_L_B_Green.png">
				    </div>
				    <div id="divMagnet_LRB_2" style="HEIGHT: 62px; WIDTH: 8px;POSITION: absolute;left:13px; top: 283px; Z-INDEX: 2;">
					    <IMG id="iMagnet_LRB_2" src="../../Images/Hospital/Magnet_L_B_Green.png">
				    </div>
				    <div id="divMagnet_LRB_3" style="HEIGHT: 62px; WIDTH: 8px;POSITION: absolute;left:13px; top: 379px; Z-INDEX: 2;">
					    <IMG id="iMagnet_LRB_3" src="../../Images/Hospital/Magnet_L_B_Green.png">
				    </div>
				    <div id="divMagnet_LRB_4" style="HEIGHT: 62px; WIDTH: 8px;POSITION: absolute;left:13px; top:475px; Z-INDEX: 2;">
					    <IMG id="iMagnet_LRB_4" src="../../Images/Hospital/Magnet_L_B_Green.png">
				    </div>
			    </div>
            </div>
			<div id="divWostL" style="HEIGHT: 666px; WIDTH: 630px; POSITION: absolute; LEFT: 10px; Z-INDEX: 0; TOP: 10px;DISPLAY: none;">
				<IMG id="iWost_L_1" style="HEIGHT: 300px; WIDTH: 400px;POSITION: absolute;left:100px; top:13px; Z-INDEX: 1;" src="../../Images/Hospital/Wost_L_White.png">
				<p id="pWost_L_1" style="POSITION: absolute; left:157px; TOP: 57px; FONT-SIZE: 32pt;Z-INDEX: 2; COLOR: white; FONT-FAMILY: 楷体_GB2312">氧气浓度监测</p>
				<p id="pWost_L_V_1" style="POSITION: absolute; left:140px; TOP: 162px; FONT-SIZE: 50pt;Z-INDEX: 2; COLOR: black; FONT-FAMILY: 楷体_GB2312">19.87%Vol</p>
				<IMG id="iWost_L_2" style="HEIGHT: 300px; WIDTH: 400px;POSITION: absolute;left:100px; top:327px;  Z-INDEX: 1;" src="../../Images/Hospital/Wost_L_White.png">
				<p id="pWost_L_2" style="POSITION: absolute; left:157px; TOP: 371px; FONT-SIZE: 32pt;Z-INDEX: 2; COLOR: white; FONT-FAMILY: 楷体_GB2312"></p>
				<p id="pWost_L_V_2" style="POSITION: absolute; left:140px; TOP: 476px; FONT-SIZE: 50pt;Z-INDEX: 2; COLOR: black; FONT-FAMILY: 楷体_GB2312"></p>
			</div>
			<div id="divFunction" style="HEIGHT: 666px; WIDTH: 1260px; POSITION: absolute; LEFT: 10px; Z-INDEX: 0; TOP: 20px;DISPLAY: none;">
				<IMG onclick="ChangeMenu(1);" style="HEIGHT: 113px; WIDTH: 400px;POSITION: absolute;left:429px; top: 60px; Z-INDEX: 1;" src="../../Images/Hospital/Function.jpg">
				<IMG onclick="ChangeMenu(2);" style="HEIGHT: 113px; WIDTH: 400px;POSITION: absolute;left:429px; top:190px; Z-INDEX: 1;" src="../../Images/Hospital/Function.jpg">
				<IMG onclick="ChangeMenu(4);" style="HEIGHT: 113px; WIDTH: 400px;POSITION: absolute;left:429px; top:320px; Z-INDEX: 1;" src="../../Images/Hospital/Function.jpg">
				<IMG style="HEIGHT: 113px; WIDTH: 400px;POSITION: absolute;left:429px; top:450px; Z-INDEX: 1;" src="../../Images/Hospital/Function.jpg">
				<p onclick="ChangeMenu(1);" style="POSITION: absolute; left:560px; TOP: 100px; FONT-SIZE: 32pt;Z-INDEX: 2; COLOR: black; FONT-FAMILY: 楷体_GB2312">铁磁安全</p>
				<p onclick="ChangeMenu(2);" style="POSITION: absolute; left:560px; TOP: 230px; FONT-SIZE: 32pt;Z-INDEX: 2; COLOR: black; FONT-FAMILY: 楷体_GB2312">环境监测</p>
				<p onclick="ChangeMenu(4);" style="POSITION: absolute; left:560px; TOP: 360px; FONT-SIZE: 32pt;Z-INDEX: 2; COLOR: black; FONT-FAMILY: 楷体_GB2312">视频监控</p>
				<p style="POSITION: absolute; left:560px; TOP: 490px; FONT-SIZE: 32pt;Z-INDEX: 2; COLOR: black; FONT-FAMILY: 楷体_GB2312">统计分析</p>
			</div>
			<div id="divVedioL" style="HEIGHT:666px; WIDTH: 372px; POSITION: absolute; LEFT: 898px; Z-INDEX: 0; TOP: 10px;DISPLAY: none;">
			    <div id="divLVedio_2" style="HEIGHT: 222px; WIDTH: 296px; POSITION: absolute; LEFT: 76px; Z-INDEX: 1; TOP: 0px;">
			        <OBJECT id="vlcLVedio_2" width="296" height="222" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
				        type="application/x-vlc-plugin" altHtml="" VIEWASTEXT="" events="True">
				        <PARAM NAME="AutoLoop" VALUE="0">
				        <PARAM NAME="AutoPlay" VALUE="-1">
				        <PARAM NAME="Toolbar" VALUE="0">
				        <PARAM NAME="MRL" VALUE="">
				        <PARAM name="fullscreen" value="false">
			        </OBJECT>
                </div>
 			    <div style="HEIGHT: 50px; WIDTH: 296px; POSITION: absolute; left:108px; TOP: 18px; Z-INDEX: 2;">
				    <p id="pLVedio_2" style="FONT-SIZE: 8pt; COLOR: white; FONT-FAMILY: 楷体_GB2312" >暂无视频</p>
                </div>
			    <div id="divLVedio_3" style="HEIGHT: 222px; WIDTH: 296px; POSITION: absolute; LEFT: 0px; Z-INDEX: 1; TOP: 222px;">
			        <OBJECT id="vlcLVedio_3" width="296" height="222" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
				        type="application/x-vlc-plugin" altHtml="" VIEWASTEXT="" events="True">
				        <PARAM NAME="AutoLoop" VALUE="0">
				        <PARAM NAME="AutoPlay" VALUE="-1">
				        <PARAM NAME="Toolbar" VALUE="0">
				        <PARAM NAME="MRL" VALUE="">
				        <PARAM name="fullscreen" value="false">
			        </OBJECT>
                </div>
 			    <div style="HEIGHT: 50px; WIDTH: 296px; POSITION: absolute; left:32px; TOP: 240px; Z-INDEX: 2;">
				    <p id="pLVedio_3" style="FONT-SIZE: 8pt; COLOR: white; FONT-FAMILY: 楷体_GB2312" >暂无视频</p>
                </div>
			    <div id="divLVedio_4" style="HEIGHT: 222px; WIDTH: 296px; POSITION: absolute; LEFT: 76px; Z-INDEX: 1; TOP: 444px;">
			        <OBJECT id="vlcLVedio_4" width="296" height="222" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
				        type="application/x-vlc-plugin" altHtml="" VIEWASTEXT="" events="True">
				        <PARAM NAME="AutoLoop" VALUE="0">
				        <PARAM NAME="AutoPlay" VALUE="-1">
				        <PARAM NAME="Toolbar" VALUE="0">
				        <PARAM NAME="MRL" VALUE="">
				        <PARAM name="fullscreen" value="false">
			        </OBJECT>
                </div>
 			    <div style="HEIGHT: 50px; WIDTH: 296px; POSITION: absolute; left:108px; TOP: 462px; Z-INDEX: 2;">
				    <p id="pLVedio_4" style="FONT-SIZE: 8pt; COLOR: white; FONT-FAMILY: 楷体_GB2312" >暂无视频</p>
                </div>
			</div>
             <div id="divWostM" onclick="ChangeMenu(2);" style="HEIGHT: 186px; WIDTH: 372px; POSITION: absolute; LEFT: 898px; Z-INDEX: 0; TOP: 10px;">
				<IMG id="iWost_M_1" style="HEIGHT: 135px; WIDTH: 180px;POSITION: absolute;left:6px; top:0px; Z-INDEX: 1;" src="../../Images/Hospital/Wost_M_White.png">
				<p id="pWost_M_1" style="POSITION: absolute; left:32px; TOP: 20px; FONT-SIZE: 16pt;Z-INDEX: 2; COLOR: white; FONT-FAMILY: 楷体_GB2312" >氧气浓度监测</p>
				<p id="pWost_M_V_1" style="POSITION: absolute; left:16px; TOP: 68px; FONT-SIZE: 25pt;Z-INDEX: 2; COLOR: black; FONT-FAMILY: 楷体_GB2312" >19.87%Vol</p>
				<IMG id="iWost_M_2" style="HEIGHT: 135px; WIDTH: 180px;POSITION: absolute;left:192px; top:0px;  Z-INDEX: 1;" src="../../Images/Hospital/Wost_M_White.png">
				<p id="pWost_M_2" style="POSITION: absolute; left:218px; TOP: 20px; FONT-SIZE: 16pt;Z-INDEX: 2; COLOR: white; FONT-FAMILY: 楷体_GB2312" ></p>
				<p id="pWost_M_V_2" style="POSITION: absolute; left:202px; TOP: 68px; FONT-SIZE: 25pt;Z-INDEX: 2; COLOR: black; FONT-FAMILY: 楷体_GB2312" ></p>
			</div>
           <div id="divMagnetM" onclick="ChangeMenu(1);" style="HEIGHT: 387px; WIDTH: 372px; POSITION: absolute; LEFT: 898px; Z-INDEX: 0; TOP: 196px;">
                <div style="HEIGHT: 308px; WIDTH: 17px; POSITION: absolute; LEFT: 80px; Z-INDEX: 0; TOP: 3px;DISPLAY: block;">
				    <IMG style="HEIGHT: 300px; WIDTH: 17px;POSITION: absolute;left:0px; top:2px; Z-INDEX: 1;" src="../../Images/Hospital/Magnet_M_Main.png">
                    <div id="divMagnet_MLH" style="HEIGHT: 26px; WIDTH: 17px;POSITION: absolute;left:0px; top: 2px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MLH" src="../../Images/Hospital/Magnet_M_H_Green.png">
				    </div>
                    <div id="divMagnet_MLB_0" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top: 40px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MLB_0" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
                    <div id="divMagnet_MLB_1" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top: 88px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MLB_1" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
                    <div id="divMagnet_MLB_2" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top:136px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MLB_2" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
                    <div id="divMagnet_MLB_3" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top:184px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MLB_3" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
                    <div id="divMagnet_MLB_4" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top:232px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MLB_4" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
			    </div>
				<IMG style="HEIGHT: 260px; WIDTH: 110px;POSITION: absolute;left:125px; top:35px; Z-INDEX: 1;" src="../../Images/Hospital/Person_1.png">
                <div style="HEIGHT: 308px; WIDTH: 17px; POSITION: absolute; LEFT: 263px; Z-INDEX: 0; TOP: 3px; DISPLAY: block;">
				    <IMG style="HEIGHT: 300px; WIDTH: 17px;POSITION: absolute;left:0px; top:2px; Z-INDEX: 1;" src="../../Images/Hospital/Magnet_M_Main.png">
                    <div id="divMagnet_MRH" style="HEIGHT: 26px; WIDTH: 17px;POSITION: absolute;left:0px; top: 2px; Z-INDEX: 1;DISPLAY: block;">
				    	<IMG id="iMagnet_MRH" src="../../Images/Hospital/Magnet_M_H_Green.png">
				    </div>
                     <div id="divMagnet_MRB_0" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top: 40px; Z-INDEX: 1;DISPLAY: block;">
				    	<IMG id="iMagnet_MRB_0" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
                    <div id="divMagnet_MRB_1" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top: 88px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MRB_1" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
                    <div id="divMagnet_MRB_2" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top:136px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MRB_2" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
                    <div id="divMagnet_MRB_3" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top:184px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MRB_3" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
                    <div id="divMagnet_MRB_4" style="HEIGHT: 32px; WIDTH: 5px;POSITION: absolute;left:6px; top:232px; Z-INDEX: 2;DISPLAY: block;">
				    	<IMG id="iMagnet_MRB_4" src="../../Images/Hospital/Magnet_M_B_Green.png">
				    </div>
			    </div>
			</div>
			<div id="divVedioM" style="HEIGHT: 93px; WIDTH: 372px; POSITION: absolute; LEFT: 898px; Z-INDEX: 0; TOP: 583px;DISPLAY: block;">
			    <div id="divMVedio_2" style="HEIGHT: 93px; WIDTH: 124px; POSITION: absolute; LEFT: 0px; Z-INDEX: 1; TOP: 0px;">
			        <OBJECT id="vlcMVedio_2" width="124" height="93" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
				        type="application/x-vlc-plugin" altHtml="" VIEWASTEXT="" events="True">
				        <PARAM NAME="AutoLoop" VALUE="0">
				        <PARAM NAME="AutoPlay" VALUE="-1">
				        <PARAM NAME="Toolbar" VALUE="0">
				        <PARAM NAME="MRL" VALUE="">
				        <PARAM name="fullscreen" value="false">
			        </OBJECT>
                </div>
 			    <div style="HEIGHT: 30px; WIDTH: 100px; POSITION: absolute; left:16px; TOP: 18px; Z-INDEX: 2;">
				    <p id="pMVedio_2" style="FONT-SIZE: 6pt; COLOR: white; FONT-FAMILY: 楷体_GB2312" >暂无视频</p>
                </div>
			    <div id="divMVedio_3" style="HEIGHT: 93px; WIDTH: 124px; POSITION: absolute; LEFT: 124px; Z-INDEX: 1; TOP: 0px;">
			        <OBJECT id="vlcMVedio_3" width="124" height="93" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
				        type="application/x-vlc-plugin" altHtml="" VIEWASTEXT="" events="True">
				        <PARAM NAME="AutoLoop" VALUE="0">
				        <PARAM NAME="AutoPlay" VALUE="-1">
				        <PARAM NAME="Toolbar" VALUE="0">
				        <PARAM NAME="MRL" VALUE="">
				        <PARAM name="fullscreen" value="false">
			        </OBJECT>
                </div>
 			    <div style="HEIGHT: 30px; WIDTH: 100px; POSITION: absolute; left:140px; TOP: 18px; Z-INDEX: 2;">
				    <p id="pMVedio_3" style="FONT-SIZE: 6pt; COLOR: white; FONT-FAMILY: 楷体_GB2312" >暂无视频</p>
                </div>
			    <div id="divMVedio_4" style="HEIGHT: 93px; WIDTH: 124px; POSITION: absolute; LEFT: 248px; Z-INDEX: 1; TOP: 0px;">
			        <OBJECT id="vlcMVedio_4" width="124" height="93" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
				        type="application/x-vlc-plugin" altHtml="" VIEWASTEXT="" events="True">
				        <PARAM NAME="AutoLoop" VALUE="0">
				        <PARAM NAME="AutoPlay" VALUE="-1">
				        <PARAM NAME="Toolbar" VALUE="0">
				        <PARAM NAME="MRL" VALUE="">
				        <PARAM name="fullscreen" value="false">
			        </OBJECT>
                </div>
 			    <div style="HEIGHT: 30px; WIDTH: 100px; POSITION: absolute; left:264px; TOP: 18px; Z-INDEX: 2;">
				    <p id="pMVedio_4" style="FONT-SIZE: 6pt; COLOR: white; FONT-FAMILY: 楷体_GB2312" >暂无视频</p>
                </div>
			</div>
			<div style="HEIGHT: 92px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; TOP: 676px; Z-INDEX: 10; ">
				<p id="pHeart" style="FONT-SIZE: 20pt; FONT-FAMILY: 楷体_GB2312; COLOR: red"></p>
			</div>

			<div id="divVersion" style="background-color:#1f78bc;HEIGHT: 92px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; Z-INDEX: 0; TOP: 676px;">
				<IMG style="HEIGHT: 90px; WIDTH: 110px;POSITION: absolute;left:30px;TOP: 2px;  Z-INDEX: 1;" src="../../Images/Hospital/Logo.png">
				<p style="POSITION: absolute; left:150px; TOP: 10px; FONT-SIZE: 25pt; COLOR: black; FONT-FAMILY: 楷体_GB2312" >核磁共振室铁磁探测系统 V1.0</p>
				<p style="POSITION: absolute; left:150px; TOP: 52px; FONT-SIZE: 20pt; COLOR: black; FONT-FAMILY: 楷体_GB2312" >南京云磁电子科技有限公司 联系电话：025-57796665</p>
			</div>
			<div id="divMenu" style="background-color:#1f78bc; HEIGHT: 92px; WIDTH: 1280px; Z-INDEX: 0; POSITION: absolute; LEFT: 0px; TOP: 676px; DISPLAY: none;">
			    <div id="divMenu1"  onclick="ChangeMenu(1);" style="HEIGHT: 92px; WIDTH: 254px;POSITION: absolute;left:0px;  Z-INDEX: 1;">
				    <p style="POSITION: absolute; left:60px; TOP: 29px; FONT-SIZE: 25pt; COLOR: black; FONT-FAMILY: 楷体_GB2312" >铁磁安全</p>
			    </div>
                <div style="HEIGHT: 92px; WIDTH: 2px;POSITION: absolute;left:254px; border:1px solid white; Z-INDEX: 1;"></div>
			    <div id="divMenu2" onclick="ChangeMenu(2);" style="HEIGHT: 92px; WIDTH: 254px;POSITION: absolute; left:256px; Z-INDEX: 1;">
				    <p style="POSITION: absolute; left:60px; TOP: 29px; FONT-SIZE: 25pt; COLOR: black; FONT-FAMILY: 楷体_GB2312" >环境监测</p>
			    </div>
                <div style="HEIGHT: 92px; WIDTH: 2px;POSITION: absolute;left:510px; border:1px solid white; Z-INDEX: 1;"></div>
			    <div id="divMenu3" onclick="ChangeMenu(3);" style="HEIGHT: 92px; WIDTH: 254px;POSITION: absolute; left:512px; Z-INDEX: 1;">
				    <IMG style="HEIGHT: 55px; WIDTH: 55px;POSITION: absolute;TOP: 3px;left:96px;  Z-INDEX: 1;" src="../../Images/Hospital/Logo.png">
				    <p style="POSITION: absolute; left:83px; TOP: 54px; FONT-SIZE: 20pt; COLOR: black; FONT-FAMILY: 楷体_GB2312" >&nbsp;主&nbsp;&nbsp;页&nbsp;</p>
			    </div>
                <div style="HEIGHT: 92px; WIDTH: 2px;POSITION: absolute;left:766px; border:1px solid white; Z-INDEX: 1;"></div>
			    <div id="divMenu4" onclick="ChangeMenu(4);" style="HEIGHT: 92px; WIDTH: 256px;POSITION: absolute; left:765px; Z-INDEX: 1;">
				    <p style="POSITION: absolute; left:60px; TOP: 27px; FONT-SIZE: 25pt; COLOR: black; FONT-FAMILY: 楷体_GB2312" >视频监控</p>
			    </div>
                <div style="HEIGHT: 92px; WIDTH: 2px;POSITION: absolute;left:1022px; border:1px solid white; Z-INDEX: 1;"></div>
			    <div id="divMenu5" onclick="ChangeMenu(5);" style="HEIGHT: 92px; WIDTH: 254px;POSITION: absolute; left:1020px; Z-INDEX: 1;">
				    <p style="POSITION: absolute; left:48px; TOP: 27px; FONT-SIZE: 25pt; COLOR: black; FONT-FAMILY: 楷体_GB2312" >功能与参数</p>
			    </div>
			</div>
        </form>
		<script>	
		    InitPage();
		    disableTextSelection();
		</script>
	</body>
</HTML>