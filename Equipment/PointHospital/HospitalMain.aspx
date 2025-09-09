<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HospitalMain.aspx.cs" Inherits="Equipment_PointHospital_HospitalMain" %>

<!DOCTYPE html>

<HTML>
	<HEAD>
		<title>HospitalMain</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="../../Content/Hospital.css" type="text/css" rel="stylesheet" />
		<link href="../../Content/disableSelect.css" type="text/css" rel="stylesheet" />
		<script src="../../Public/Function.js"></script>
		<script type="text/javascript">
		    //let n = setInterval("SetValue1()", 200);
		    var int = self.setInterval("SetValue1()", 500);
		    setTimeout("InitVedio()", 10000);

		    var disKeys = [];
		    var disCtrKeys = [];
		    var disAltKeys = [];

		    var iCount = 0;
		    var iHeart = 0;
            var iStart = 0;

            var sAlarm = "";


            var oHttpReq = [null, null, null, null, null];
            var oTimeout = [null, null, null, null, null];
            var iLevel = 2;

            function GetRepCondi(iLoc) {
                var sCondi = "";
                if (iLoc == 0)
                    sCondi = GetHtmlValue("hPoint", "V");
                return sCondi;
            }

            function GetRepOperate(iLoc) {
                var sOperate = "";
                if (iLoc == 0)
                    sOperate = "GETPRESULT";
                if (iLoc == 1)
                    sOperate = "GETPCONFIG";
                return sOperate;
            }

            function DealRepAnswer(iLoc) {
                DealHttpAnswer(iLoc);
            }

            function DealHttpAnswer(iLoc) {
                if (oHttpReq.length > iLoc && oHttpReq[iLoc]) {
                    var oDoc = new ActiveXObject("MSXML2.DOMDocument");
                    oDoc.loadXML(oHttpReq[iLoc].responseText);
                    if (iLoc == 0) {
                        AnalysisPointResult(oDoc);
                    }

                    if (iLoc == 1) {
                    }

                    oHttpReq[iLoc] = null;
                }
                if (oTimeout.length > iLoc && oTimeout[iLoc]) {
                    clearTimeout(oTimeout[iLoc]);
                }
            }

            function InitVedio()
            {
                iStart = 1;

                if (!IsAI()) {
                    document.getElementById("divVedio_4").style.display = "block";
                    document.getElementById("divAI").style.display = "none";
                }

                SetVedio("1");
                SetVedio("2");
                SetVedio("3");
                SetVedio("4");
                SetVedio("5");
                SetVedio("6");
            }

            function SetValue1()
            {
                var date = new Date();
                var options = { year: 'numeric', month: '2-digit', day: '2-digit', hour12: false, hour: '2-digit', minute: '2-digit', second: '2-digit' };
                SetHtmlValue("pHeart","H",date.toLocaleString('zh-CN', options));

                AsyncRepHttp(0);

                SetAudio();
                if (iHeart % 300 == 0)
                    SetHeart();
                iHeart++;
                iCount++;
                if (iCount > 10000)
                    iCount = 1;
            }

            function FindDocment(vItems,sValue)
            {
                var i = 0;
                for (;i < vItems.length; i ++)
                {
                    if (vItems[i].nodeTypedValue == sValue)
                        break;
                }
                if (vItems.length > 0 && i < vItems.length)
                    return i;
                return -1;
            }
			
            function AnalysisPointResult(oDoc)
            {
                var sVal = GetHtmlValue("hType", "V");

                sAlarm = "";

                if (sVal == "1") {
                    AnalysisMagnet(oDoc,"L");
                    AnalysisMagnet(oDoc, "R");
                }
                if (sVal == "21" || sVal == "31")
                    AnalysisMagnet4(oDoc);
                if (sVal == "20" || sVal == "30") {
                    AnalysisMagnet4S(oDoc,"L");
                    AnalysisMagnet4S(oDoc,"R");
                }

                SetMagnet();

                AnalysisWost(oDoc, "1", "");
                AnalysisWost(oDoc, "2", "");
                AnalysisWost(oDoc, "3", "");
                AnalysisWost(oDoc, "4", "");
                AnalysisWost(oDoc, "1", "O");
                AnalysisWost(oDoc, "2", "O");
                AnalysisWost(oDoc, "3", "O");
                AnalysisWost(oDoc, "4", "O");

                SetWost();


                AnalysisAI(oDoc);
                SetAI();
            }

            function AnalysisMagnet4(oDoc) {
                var sValue = GetHtmlValue("pHeart", "T");

                var sEquipment = GetHtmlValue("hLMagnet", "V");
                if (sEquipment == "")
                    return;

                var vItems = oDoc.getElementsByTagName("M4SBBH");
                var iLoc = FindDocment(vItems,sEquipment);
                if (iLoc < 0)
                    return;

                vItems = oDoc.getElementsByTagName("M4COLA");
                sValue += ";hLLed:";
                if (vItems.length > iLoc) {
                    SetHtmlValue("hLLed","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";

                vItems = oDoc.getElementsByTagName("M4IDXA");
                sValue += ";hLSign:";
                if (vItems.length > iLoc) {
                    SetHtmlValue("hLSign","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";

                vItems = oDoc.getElementsByTagName("M4POSA");
                sValue += ";hLPos:";
                if (vItems.length > iLoc) {
                    SetHtmlValue("hLPos","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";


                vItems = oDoc.getElementsByTagName("M4COLB");
                sValue += ";hRLed:";
                if (vItems.length > iLoc) {
                    SetHtmlValue("hRLed","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";


                vItems = oDoc.getElementsByTagName("M4IDXB");
                sValue += ";hRSign:";
                if (vItems.length > iLoc) {
                    SetHtmlValue("hRSign","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";

                vItems = oDoc.getElementsByTagName("M4POSB");
                sValue += ";hRPos:";
                if (vItems.length > iLoc) {
                    SetHtmlValue("hRPos","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";

                //alert(sValue);
                //SetHtmlValue("pHeart","H",sValue);
            }

            function AnalysisMagnet4S(oDoc,sMagnet) {
                var sValue = GetHtmlValue("pHeart", "T");

                var sEquipment = GetHtmlValue("h" + sMagnet + "Magnet", "V");
                if (sEquipment == "")
                    return;
                    
                var vItems = oDoc.getElementsByTagName("M4SBBH");
                var iLoc = FindDocment(vItems,sEquipment);
                if (iLoc < 0)
                    return;


                vItems = oDoc.getElementsByTagName("M4COLA");
                sValue += "h" + sMagnet + "Led";
                if (vItems.length > iLoc) {
                    SetHtmlValue("h" + sMagnet + "Led","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";

                vItems = oDoc.getElementsByTagName("M4IDXA");
                sValue += "h" + sMagnet + "Sign";
                if (vItems.length > iLoc) {
                    SetHtmlValue("h" + sMagnet + "Sign","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";

                vItems = oDoc.getElementsByTagName("M4POSA");
                sValue += "h" + sMagnet + "Pos";
                if (vItems.length > iLoc) {
                    SetHtmlValue("h" + sMagnet + "Pos","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";
                    
                //alert(sValue);
                //SetHtmlValue("pHeart","H",sValue);
            }


            function AnalysisMagnet(oDoc,sMagnet) {
                var sValue = GetHtmlValue("pHeart", "T");
                
                var sEquipment = GetHtmlValue("h" + sMagnet + "Magnet", "V");
                var sType = GetHtmlValue("h" + sMagnet + "Type", "V");
                if (sEquipment == "")
                    return;
                    
                var vItems = oDoc.getElementsByTagName("M3SBBH");
                var iLoc = FindDocment(vItems,sEquipment);
                if (iLoc < 0)
                    return;

                var sColor = "Green";

                vItems = oDoc.getElementsByTagName("M3ZSDZ");
                sValue += "h" + sMagnet + "Led";
                if (vItems.length > iLoc) {
                    var iLed = parseInt(vItems[iLoc].nodeTypedValue);
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

                    SetHtmlValue("h" + sMagnet + "Led","V",sColor);
                    SetHtmlValue("h" + sMagnet + "Pos","V",iLed);

                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";

                vItems = oDoc.getElementsByTagName("M3XHQD");
                sValue += "h" + sMagnet + "Sign";
                if (vItems.length > iLoc) {
                    SetHtmlValue("h" + sMagnet + "Sign","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";
                //alert(sValue);
                //SetHtmlValue("pHeart","H",sValue);
            }
            
            function AnalysisWost(oDoc,sWost,sType) {
                //sWost 1-氧浓度-1 2-温度-8 3-湿度-9 4-烟感-0
                //sType -室内 O-室外
                var sValue = GetHtmlValue("pHeart", "T");

                var sWost1 = "";
                if (sWost == "1")
                    sWost1 = "1";
                if (sWost == "2")
                    sWost1 = "8";
                if (sWost == "3")
                    sWost1 = "9";
                if (sWost == "4")
                    sWost1 = "0";
                var vItems = oDoc.getElementsByTagName("W" + sType + "QTDW");
                var iLoc = FindDocment(vItems,sWost1);
                if (iLoc < 0)
                    return;


                vItems = oDoc.getElementsByTagName("W" + sType + "JCZ");
                sValue += ";hW" + sType + "Value" + sWost + ":";
                if (vItems.length > iLoc) {
                    SetHtmlValue("hW" + sType + "Value" + sWost,"V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }


                sValue += ";hW" + sType + "Alarm" + sWost + ":";
                vItems = oDoc.getElementsByTagName("W" + sType + "GJZT");
                if (vItems.length > iLoc) {
                    SetHtmlValue("hW" + sType + "Alarm" + sWost,"V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";


                //alert(sValue);
                //SetHtmlValue("pHeart","H",sValue);
            }
	
            function AnalysisAI(oDoc) {
                var sValue = GetHtmlValue("pHeart", "T");

                var sEquipment = GetHtmlValue("hAI", "V");
                if (sEquipment == "")
                    return;

                var vItems = oDoc.getElementsByTagName("AISBBH");
                var iLoc = FindDocment(vItems,sEquipment);
                if (iLoc < 0)
                    return;

                vItems = oDoc.getElementsByTagName("AIJCXL");
                sValue += ";hAIValue:";
                if (vItems.length > iLoc) {
                    SetHtmlValue("hAIValue","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                }
                else
                    sValue += "X";

                sValue += ";hAIAlarm:";
                vItems = oDoc.getElementsByTagName("AIJCJG");
                if (vItems.length > iLoc) {
                    var sAIAlarm = GetHtmlValue("hAIAlarm", "V");
                    SetHtmlValue("hAIAlarm","V",vItems[iLoc].nodeTypedValue);
                    sValue += vItems[iLoc].nodeTypedValue;
                    if (sAIAlarm != vItems[iLoc].nodeTypedValue)
                        FreshAI();
                }
                else
                    sValue += "X";

                //alert(sValue);
                //SetHtmlValue("pHeart","H",sValue);
            }

            function SetValue() {
                var date = new Date();
                var options = { year: 'numeric', month: '2-digit', day: '2-digit', hour12: false, hour: '2-digit', minute:'2-digit', second: '2-digit' };
                SetHtmlValue("pHeart","H",date.toLocaleString('zh-CN', options));
                var sVal = GetHtmlValue("hType", "V");
				
                sAlarm = "";

                if (sVal == "1") {
                    GetMagnet("L");
                    GetMagnet("R");
                }
                if (sVal == "21" || sVal == "31")
                    GetMagnet4();
                if (sVal == "20" || sVal == "30")
                {
                    GetMagnet4S("L");
                    GetMagnet4S("R");
                }
                SetMagnet();
	                  
                GetWost("1");
                GetWost("2");
                SetWost();

                GetAI();
                SetAI();
                SetAudio();
                if (iCount % 300 == 0)
                    SetHeart();
                iCount++;
                if (iCount > 10000)
                    iCount = 1;
            }

            function SetHeart()
            {
                iHeart = 1;
                var iMenu = parseInt(document.getElementById("hMenu").value);
                var vItem = null;
                //主页面 
                if (iMenu == 1) {
                    vItem = document.getElementById("ifAISmall");
                    if (vItem != null)
                        vItem.src = "AISmall.aspx?Serial=" + GetHtmlValue("hAIValue", "V") + "&t=" + (new Date().getTime());
                }

                //铁磁安全
                if (iMenu == 2) {
                    vItem = document.getElementById("iMagnetLine1");
                    if (vItem != null)
                        vItem.src = "../../Public/DrawPicture.aspx?Point=" + GetHtmlValue("hPoint", "V") + "&Type=11&t=" + (new Date().getTime());
                    vItem = document.getElementById("iMagnetPie1");
                    if (vItem != null)
                        vItem.src = "../../Public/DrawPicture.aspx?Point=" + GetHtmlValue("hPoint", "V") + "&Type=21&t=" + (new Date().getTime());
                    vItem = document.getElementById("ifMagnetEvent");
                    if (vItem != null)
                        vItem.src = "MagnetEvent.aspx?Point=" + GetHtmlValue("hPoint","V") + "&t=" + (new Date().getTime());
                }

                //环境监测
                if (iMenu == 5) {
                    vItem = document.getElementById("iWostLine1");
                    if (vItem != null)
                        vItem.src = "../../Public/DrawPicture.aspx?Point=" + GetHtmlValue("hPoint", "V") + "&Type=31&t=" + (new Date().getTime());
                }

                //AI智能
                if (iMenu == 7) {
                    vItem = document.getElementById("ifAILarge");
                    if (vItem != null)
                        vItem.src = "AILarge.aspx?Serial=" + GetHtmlValue("hAIValue", "V") + "&t=" + (new Date().getTime());
                }
            }

            function SetMagnet() {

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

                /*
                if (vLed == "Blue" || vLed == "Orange" || vLed == "Red") {
                document.getElementById("divMenu2").style.backgroundColor = "red";
                }
                else {
                document.getElementById("divMenu2").style.backgroundColor = "#C5E6F6";
                }
                */
                
                if (vLed == "Blue" || vLed == "Orange" || vLed == "Red") {
                    document.getElementById("divMenu2R").style.display = "block";
                    sAlarm = "1";
                }
                else {
                    document.getElementById("divMenu2R").style.display = "none";
                }

                //柱子灯色设置
                document.getElementById("iMagnet_LRH").src = "../../Images/Hospital/Magnet_H_" + vRLed + ".png";
                document.getElementById("iMagnet_LRB_0").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_LRB_1").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_LRB_2").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_LRB_3").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_LRB_4").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_LLH").src = "../../Images/Hospital/Magnet_H_" + vLLed + ".png";
                document.getElementById("iMagnet_LLB_0").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";
                document.getElementById("iMagnet_LLB_1").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";
                document.getElementById("iMagnet_LLB_2").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";
                document.getElementById("iMagnet_LLB_3").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";
                document.getElementById("iMagnet_LLB_4").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";

                document.getElementById("iMagnet_MRH").src = "../../Images/Hospital/Magnet_H_" + vRLed + ".png";
                document.getElementById("iMagnet_MRB_0").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_MRB_1").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_MRB_2").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_MRB_3").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_MRB_4").src = "../../Images/Hospital/Magnet_B_" + vRLed + ".png";
                document.getElementById("iMagnet_MLH").src = "../../Images/Hospital/Magnet_H_" + vLLed + ".png";
                document.getElementById("iMagnet_MLB_0").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";
                document.getElementById("iMagnet_MLB_1").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";
                document.getElementById("iMagnet_MLB_2").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";
                document.getElementById("iMagnet_MLB_3").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";
                document.getElementById("iMagnet_MLB_4").src = "../../Images/Hospital/Magnet_B_" + vLLed + ".png";

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

                if (vLPos >= 0 && vLPos < 5) {
                    document.getElementById("divMagnet_LLB_" + vLPos).style.display = "block";
                    document.getElementById("divMagnet_MLB_" + vLPos).style.display = "block";
                }
                if (vLPos == 7) {
                    document.getElementById("divMagnet_LLB_0").style.display = "block";
                    document.getElementById("divMagnet_MLB_0").style.display = "block";
                    if (vLType == "Care" || vLType == "Smart") {
                        document.getElementById("divMagnet_LLB_2").style.display = "block";
                        document.getElementById("divMagnet_MLB_2").style.display = "block";
                        document.getElementById("divMagnet_LLB_4").style.display = "block";
                        document.getElementById("divMagnet_MLB_4").style.display = "block";
                        if (vLType == "Smart") {
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
            }

            function SetWost() {
                //环境监测赋值
                var sVal = GetHtmlValue("hWValue1", "V");
                SetHtmlValue("pWostValue1", "H", sVal);
                SetHtmlValue("pWValue1", "H", sVal);

                sVal = GetHtmlValue("hWValue2", "V");
                SetHtmlValue("pWostValue2", "H", sVal);
                SetHtmlValue("pWostOValue2", "H", sVal);
                SetHtmlValue("pWValue2", "H", sVal);

                sVal = GetHtmlValue("hWValue3", "V");
                SetHtmlValue("pWostValue3", "H", sVal);
                SetHtmlValue("pWostOValue3", "H", sVal);
                SetHtmlValue("pWValue3", "H", sVal);

                sVal = GetHtmlValue("hWValue4", "V");
                SetHtmlValue("pWostValue4", "H", sVal);

                sVal = GetHtmlValue("hWOValue2", "V");
                SetHtmlValue("pOWostValue2", "H", sVal);

                sVal = GetHtmlValue("hWOValue3", "V");
                SetHtmlValue("pOWostValue3", "H", sVal);

                sVal = GetHtmlValue("hWOValue4", "V");
                SetHtmlValue("pOWostValue4", "H", sVal);

                //环境监测背景
                sVal = GetHtmlValue("hWAlarm1", "V");
                if (sVal == "0" || sVal == "")
                    sVal = GetHtmlValue("hWOAlarm1", "V");
                if (sVal == "0" || sVal == "") {
                    document.getElementById("dWost1").style.background = "linear-gradient(#E0E6E6, #F2F8F8)";
                }
                else {
                    document.getElementById("dWost1").style.background = "linear-gradient(red, #F2F8F8)";
                }

                sVal = GetHtmlValue("hWAlarm2", "V");
                if (sVal == "0" || sVal == "")
                    sVal = GetHtmlValue("hWAlarm3", "V");
                if (sVal == "0" || sVal == "")
                    sVal = GetHtmlValue("hWAlarm4", "V");
                if (sVal == "0" || sVal == "")
                    sVal = GetHtmlValue("hWOAlarm1", "V");
                if (sVal == "0" || sVal == "")
                    sVal = GetHtmlValue("hWOAlarm2", "V");
                if (sVal == "0" || sVal == "")
                    sVal = GetHtmlValue("hWOAlarm3", "V");
                if (sVal == "0" || sVal == "")
                    sVal = GetHtmlValue("hWOAlarm4", "V");
                if (sVal == "0" || sVal == "") {
                    document.getElementById("dWost2").style.background = "linear-gradient(#E0E6E6, #F2F8F8)";
                    document.getElementById("dWost3").style.background = "linear-gradient(#E0E6E6, #F2F8F8)";
                }
                else {
                    document.getElementById("dWost2").style.background = "linear-gradient(red, #F2F8F8)";
                    document.getElementById("dWost3").style.background = "linear-gradient(red, #F2F8F8)";
                }

                if (sVal == "0" || sVal == "") {
                    sVal = GetHtmlValue("hWAlarm1", "V");
                    if (sVal == "0" || sVal == "")
                        sVal = GetHtmlValue("hWOAlarm1", "V");
                }

                if (sVal == "0" || sVal == "") {
                    document.getElementById("divMenu5R").style.display = "none";
                }
                else {
                    document.getElementById("divMenu5R").style.display = "block";
                    sAlarm = "2";
                }
            }

            function SetAI() {
                //环境监测背景
                var sVal = GetHtmlValue("hAIAlarm", "V");
                if (sVal == "0" || sVal == "") {
                    document.getElementById("divAI").style.background = "linear-gradient(#E0E6E6, #F2F8F8)";
                    document.getElementById("divMenu7R").style.display = "none";
                }
                else {
                    document.getElementById("divAI").style.background = "linear-gradient(red, #F2F8F8)";
                    document.getElementById("divMenu7R").style.display = "block";
                    sAlarm = "3";
                }
            }

            function FreshAI() {
                sAISerial = GetHtmlValue("hAIValue", "V");
                var vItem = document.getElementById("ifAISmall");
                if (vItem != null)
                    vItem.src = "AISmall.aspx?Serial=" + sAISerial + "&t=" + (new Date().getTime());
                vItem = document.getElementById("ifAILarge");
                if (vItem != null)
                    vItem.src = "AILarge.aspx?Serial=" + sAISerial + "&t=" + (new Date().getTime());
            }

            function SetAudio()
            {
                var aA = document.getElementById("aAlarm");
                aA.pause();
                if (sAlarm != "") {
                    aA.src = "../../Audio/Alarm" + sAlarm + ".mp3";
                    aA.play();
                }
            }

            function GetMagnet4() {
                var sValue = GetHtmlValue("pHeart", "T");

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
                //SetHtmlValue("pHeart","H",sValue);
            }

            function GetMagnet4S(sMagnet) {
                var sValue = GetHtmlValue("pHeart", "T");

                var sEquipment = GetHtmlValue("h" + sMagnet + "Magnet", "V");
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
                //SetHtmlValue("pHeart","H",sValue);
            }

            function GetWost(sWost) {
                var sValue = GetHtmlValue("pHeart", "T");

                var sEquipment = GetHtmlValue("hWost" + sWost, "V");
                if (sEquipment == "")
                    return;
                var oDoc = new ActiveXObject("MSXML2.DOMDocument");
                oDoc.loadXML(GetXMLService("GETWRESULT", sEquipment, 2));

                var vItem = oDoc.getElementsByTagName("JCZ");
                sValue += ";hWValue:";
                if (vItem.length > 0) {
                    document.getElementById("hWValue" + sWost).value = vItem[0].nodeTypedValue;
                    sValue += vItem[0].nodeTypedValue;
                }
                else
                    sValue += "X";

                if (vItem.length > 1 && sWost == "2")
                {
                    document.getElementById("hWValue3").value = vItem[1].nodeTypedValue;
                    sValue += "/" + vItem[1].nodeTypedValue;
                }

                sValue += ";hWAlarm:";
                vItem = oDoc.getElementsByTagName("GJZT");
                if (vItem.length > 0) {
                    document.getElementById("hWAlarm" + sWost).value = vItem[0].nodeTypedValue;
                    sValue += vItem[0].nodeTypedValue;
                }
                else
                    sValue += "X";

                if (vItem.length > 1 && sWost == "2") {
                    document.getElementById("hWAlarm3").value = vItem[1].nodeTypedValue;
                    sValue += "/" + vItem[1].nodeTypedValue;
                }
                //alert(sValue);
                //SetHtmlValue("pHeart","H",sValue);
            }
	
            function GetAI() {
                var sValue = GetHtmlValue("pHeart", "T");

                var sEquipment = GetHtmlValue("hAI", "V");
                if (sEquipment == "")
                    return;
                var oDoc = new ActiveXObject("MSXML2.DOMDocument");
                var sResult = GetXMLService("GETDRESULT", sEquipment, 2);
                oDoc.loadXML(sResult);

                var vItem = oDoc.selectSingleNode("//root/DResult/JCXL");
                sValue += ";hAIValue:";
                if (vItem != null) {
                    document.getElementById("hAIValue").value = vItem.nodeTypedValue;
                    sValue += vItem.nodeTypedValue;
                }
                else
                    sValue += "X";

                sValue += ";hAIAlarm:";
                vItem = oDoc.selectSingleNode("//root/DResult/JCJG");
                if (vItem != null) {
                    var sAIAlarm = GetHtmlValue("hAIAlarm", "V");
                    document.getElementById("hAIAlarm").value = vItem.nodeTypedValue;
                    sValue += vItem.nodeTypedValue;
                    if (sAIAlarm != vItem.nodeTypedValue)
                        FreshAI();
                }
                else
                    sValue += "X";

                //alert(sValue);
                //SetHtmlValue("pHeart","H",sValue);
            }

            function GetMagnet(sMagnet) {
                var sValue = GetHtmlValue("pHeart", "T");
                
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
                //SetHtmlValue("pHeart","H",sValue);
            }

            function InitPage() {
                //页面初始化
                //var sVal = GetHtmlValue("hWName1", "V");
                //SetHtmlValue("pWostName1", "H", sVal);
                //sVal = GetHtmlValue("hWName2", "V");
                //SetHtmlValue("pWostName2", "H", sVal);
								
				var sVal = GetHtmlValue("hOost1","V");
				if (sVal == "")
					sVal = GetHtmlValue("hOost2","V");
				if (sVal == "")
					sVal = GetHtmlValue("hOost3","V");
				if (sVal == "")
				    sVal = GetHtmlValue("hOost4", "V");

                //判断是否有设备间环境监测
				if (sVal == "")
				{
                    document.getElementById("dWost2").style.display = "none";
                    document.getElementById("dWost3").style.display = "block";
				}
				else
				{
                    document.getElementById("dWost3").style.display = "none";
                    document.getElementById("dWost2").style.display = "block";
				}
								

                SetVedio("1");
                SetVedio("2");
                SetVedio("3");
                SetVedio("4");
                SetVedio("5");
                SetVedio("6");
                SetVedio("7");

                if (!IsAI()) {
                    document.getElementById("divMenu7").style.display = "none";
                }

                var vItem = document.getElementById("ifMagnetStat");
                if (vItem != null)
                    vItem.src = "MagnetStat.aspx?Point=" + GetHtmlValue("hPoint", "V");
            }

            function StopVedio(iVedio)
            {
                var vlc = document.getElementById("vlcVedio_" + iVedio);
                if (vlc != null)
                {
                    if (vlc.playlist.itemCount > 0) {
                        if (vlc.playlist.isPlaying)
                            vlc.playlist.stop();
                        vlc.playlist.clear();
                    }
                }
            }

            function AddPlaylist(iVedio,sUrl)
            {
                var iMenu = parseInt(document.getElementById("hMenu").value);
                var options = [":network-caching=300"];
                var vlc = document.getElementById("vlcVedio_" + iVedio);
                if (vlc != null) {
                    vlc.playlist.add(sUrl, "", options);
                    if ((iMenu == 1 && (iVedio < 4 || (iVedio == 4 && !IsAI()))) || (iMenu == 3 && iVedio > 1 && iVedio < 6) || (iMenu == 7 && iVedio == 6) || (iMenu == 4 && iVedio == 7))
                    {
                        vlc.playlist.play();
                    }
                }
            }
			
            function IsAI()
            {
                var sAI = GetHtmlValue("hAI", "V");
                if (sAI == "")
                    return false;
                return true;
            }

            function IsVedio(iVedio)
            {
                var sUrl = GetVedioUrl(iVedio);
                if (sUrl == "")
                    return false;
                return true;
            }

            function GetVedioUrl(iVedio)
            {
                if (iVedio == "5")
                    iVedio = "1";
                return GetHtmlValue("hCamUrl" + iVedio, "V");
            }

            function SetVedio(iVedio) {

                if (iStart == 0)
                    return;
                StopVedio(iVedio);
                var sUrl = GetVedioUrl(iVedio);
                if (sUrl != "") {
                    AddPlaylist(iVedio,sUrl);
                }
                else {
                    if (iVedio > 1 && iVedio < 5) {
                        var vItem = document.getElementById("divVedio_" + iVedio);
                        if (vItem != null)
                            vItem.style.display = "none";
                    }
                }
            }
				
            function ChangeVedio(iVedio)
            {
                if (iVedio > 1 && iVedio < 5)
                {
                    var vItem = document.getElementById("divVedio_" + iVedio);
                    if (vItem != null && vItem.style.display != "none")
                    {
                        ChangeHtmlValue("hCamera" + iVedio,"hCamera1","V");
                        ChangeHtmlValue("hCamUrl" + iVedio,"hCamUrl1","V");
                        ChangeHtmlValue("hCamName" + iVedio,"hCamName1","V");
                        SetVedio(iVedio);
                        SetVedio(1);
                        SetVedio(5);
                    }
                }
            }

            function GetMenu()
            {
                return parseInt(GetHtmlValue("hMenu", "V"));
            }
        
            function ChangeMenu(iMenu) {
                var iOld = GetMenu();
                if (iMenu == iOld) {
                    return;
                }

                //菜单变色
                var pMenu = document.getElementById("pMenu" + iOld);
                if (pMenu != null)
                {
                    pMenu.style.color = "darkgray";
                    pMenu.style.fontWeight = "normal";
                }
                pMenu = document.getElementById("pMenu" + iMenu);
                if (pMenu != null)
                {
                    pMenu.style.color = "black";
                    pMenu.style.fontWeight = "bolder";
                }

                //切换区域
                switch (iOld) {
                    case 1:
                        document.getElementById("dMain").style.display = "none";
                        StopVedio(1);
                        StopVedio(2);
                        StopVedio(3);
                        StopVedio(4);
                        document.getElementById("dCamraSmall").style.display = "none";
                        break;
                    case 2:
                        document.getElementById("dMagnet").style.display = "none";
                        document.getElementById("dMagnetStat").style.display = "none";
                        break;
                    case 3:
                        document.getElementById("dCamraLarge").style.display = "none";
                        StopVedio(5);
                        StopVedio(2);
                        StopVedio(3);
                        StopVedio(4);
                        document.getElementById("dCamraSmall").style.display = "none";
                        break;
                    case 4:
                        StopVedio(7);
                        document.getElementById("dCamraHistory").style.display = "none";
                        break;
                    case 5:
                        document.getElementById("dWost").style.display = "none";
                        break;
                    case 6:
                        document.getElementById("dManager").style.display = "none";
                        break;
                    case 7:
                        StopVedio(6);
                        document.getElementById("dAI").style.display = "none";
                        break;
                }
                document.getElementById("hMenu").value = iMenu;
                switch (iMenu) {
                    case 1:
                        document.getElementById("dMain").style.display = "block";
                        document.getElementById("dCamraSmall").style.display = "block";
                        document.getElementById("divAI").style.display = "none";
                        document.getElementById("divVedio_4").style.display = "none";
                        if (IsAI())
                        {
                            document.getElementById("divAI").style.display = "block";
                        }
                        else
                        {
                            document.getElementById("divVedio_4").style.display = "block";
                            SetVedio(4);
                        }
                        SetVedio(1);
                        SetVedio(2);
                        SetVedio(3);
                        SetHeart();
                        break;
                    case 2:
                        document.getElementById("dMagnet").style.display = "block";
                        SetHeart();
                        break;
                    case 3:
                        document.getElementById("dCamraLarge").style.display = "block";
                        document.getElementById("dCamraSmall").style.display = "block";
                        document.getElementById("divAI").style.display = "none";
                        document.getElementById("divVedio_4").style.display = "block";
                        SetVedio(2);
                        SetVedio(3);
                        SetVedio(4);
                        SetVedio(5);
                        break;
                    case 4:
                        document.getElementById("dCamraHistory").style.display = "block";
                        SetVedio(7);
                        break;
                    case 5:
                        document.getElementById("dWost").style.display = "block";
                        SetHeart();
                        break;
                    case 6:
                        document.getElementById("dManager").style.display = "block";
                        break;
                    case 7:
                        document.getElementById("dAI").style.display = "block";
                        SetVedio(6);
                        SetHeart();
                        break;
                }
            }
		    
            function ChangeMagnet(iLocation)
            {
                if (iLocation == 1)
                {
                    document.getElementById("dMagnetStat").style.display = "block";
                    document.getElementById("dMagnet").style.display = "none";
                }
                else
                {
                    document.getElementById("dMagnet").style.display = "block";
                    document.getElementById("dMagnetStat").style.display = "none";
                }
            }
		    
            function WostQuery()
            {
                var vItem = document.getElementById("hO2");
                var vType = 0;
                if (vItem != null && vItem.checked)
                    vType = 1;
                vItem = document.getElementById("hWD");
                if (vItem != null && vItem.checked)
                    vType += 2;
                var sCondition = GetHtmlValue("dStart", "V") + "|" + GetHtmlValue("dEnd", "V");

                vItem = document.getElementById("iWostLine2");
                if (vItem != null)
                    vItem.src = "../../Public/DrawPicture.aspx?Point=" + GetHtmlValue("hPoint", "V") + "&Type=34&Condi=" + sCondition + "&DataType=" + vType + "&t=" + (new Date().getTime());
            }
		    
            function PlayHistory(sUrl)
            {
                SetHtmlValue("hCamUrl7","V",sUrl);
                SetVedio(7);
            }

            function HistoryQuery()
            {
                var sCondition = GetHtmlValue("dStartHis", "V") + "|" + GetHtmlValue("dEndHis", "V");
                var vItem = document.getElementById("hDanger");
                if (vItem != null && vItem.checked == true)
                    sCondition = sCondition + "|1";
                else
                    sCondition = sCondition + "|0";

                vItem = document.getElementById("mDanger");
                if (vItem != null && vItem.checked == true)
                    sCondition = sCondition + "|1";
                else
                    sCondition = sCondition + "|0";

                vItem = document.getElementById("lDanger");
                if (vItem != null && vItem.checked == true)
                    sCondition = sCondition + "|1";
                else
                    sCondition = sCondition + "|0";

                vItem = document.getElementById("ifCamraHistory");
                if (vItem != null)
                    vItem.src = "EventQuery.aspx?Point=" + GetHtmlValue("hPoint","V") + "&Condi=" + sCondition + "&t=" + (new Date().getTime());
            }
        </script>
    </HEAD>    
    <body>
        <form id="form1" method="post" runat="server">
            <audio id="aAlarm" loop></audio>

            <input id="workflag" type="hidden" name="workflag" runat="server"/> <input id="hPoint" type="hidden" name="hPoint" runat="server"/>

            <input id="hLMagnet" type="hidden" name="hLMagnet" runat="server"/> <input id="hLType" type="hidden" name="hLType" runat="server"/> <input id="hLLed" type="hidden" name="hLLed" value="Green" runat="server"/> <input id="hLSign" type="hidden" name="hLSign" value="" runat="server"/> <input id="hLPos" type="hidden" name="hLPos" value="7" runat="server"/> 
            <input id="hRMagnet" type="hidden" name="hRMagnet" runat="server"/> <input id="hRType" type="hidden" name="hRType" runat="server"/> <input id="hRLed" type="hidden" name="hRLed" value="Green" runat="server"/> <input id="hRSign" type="hidden" name="hRSign" value="" runat="server"/> <input id="hRPos" type="hidden" name="hRPos" value="7" runat="server"/>
            <input id="hLed" type="hidden" name="hLed" value="Green" runat="server"/> <input id="hType" type="hidden" name="hType" value="2" runat="server"/>

            <input id="hCamera1" type="hidden" name="hCamera1" runat="server"/> <input id="hCamUrl1" type="hidden" name="hCamUrl1" runat="server"/> <input id="hCamName1" type="hidden" name="hCamName1" runat="server"/>
            <input id="hCamera2" type="hidden" name="hCamera2" runat="server"/> <input id="hCamUrl2" type="hidden" name="hCamUrl2" runat="server"/> <input id="hCamName2" type="hidden" name="hCamName2" runat="server"/>
            <input id="hCamera3" type="hidden" name="hCamera3" runat="server"/> <input id="hCamUrl3" type="hidden" name="hCamUrl3" runat="server"/> <input id="hCamName3" type="hidden" name="hCamName3" runat="server"/>
            <input id="hCamera4" type="hidden" name="hCamera4" runat="server"/> <input id="hCamUrl4" type="hidden" name="hCamUrl4" runat="server"/> <input id="hCamName4" type="hidden" name="hCamName4" runat="server"/>

            <input id="hWost1" type="hidden" name="hWost1" runat="server"/> <input id="hWName1" type="hidden" name="hWName1" runat="server"/> <input id="hWType1" type="hidden" name="hWType1" runat="server"/> <input id="hWValue1" type="hidden" name="hWValue1"/> <input id="hWAlarm1" type="hidden" name="hWAlarm1"/>
            <input id="hWost2" type="hidden" name="hWost2" runat="server"/> <input id="hWName2" type="hidden" name="hWName2" runat="server"/> <input id="hWType2" type="hidden" name="hWType2" runat="server"/> <input id="hWValue2" type="hidden" name="hWValue2"/> <input id="hWAlarm2" type="hidden" name="hWAlarm2"/>
            <input id="hWost3" type="hidden" name="hWost3" runat="server"/> <input id="hWName3" type="hidden" name="hWName3" runat="server"/> <input id="hWType3" type="hidden" name="hWType3" runat="server"/> <input id="hWValue3" type="hidden" name="hWValue3"/> <input id="hWAlarm3" type="hidden" name="hWAlarm3"/>
            <input id="hWost4" type="hidden" name="hWost4" runat="server"/> <input id="hWName4" type="hidden" name="hWName4" runat="server"/> <input id="hWType4" type="hidden" name="hWType4" runat="server"/> <input id="hWValue4" type="hidden" name="hWValue4"/> <input id="hWAlarm4" type="hidden" name="hWAlarm4"/>

            <input id="hOost1" type="hidden" name="hOost1" runat="server"/> <input id="hOName1" type="hidden" name="hOName1" runat="server"/> <input id="hOType1" type="hidden" name="hOType1" runat="server"/> <input id="hWOValue1" type="hidden" name="hWOValue1"/> <input id="hWOAlarm1" type="hidden" name="hWOAlarm1"/>
            <input id="hOost2" type="hidden" name="hOost2" runat="server"/> <input id="hOName2" type="hidden" name="hOName2" runat="server"/> <input id="hOType2" type="hidden" name="hOType2" runat="server"/> <input id="hWOValue2" type="hidden" name="hWOValue2"/> <input id="hWOAlarm2" type="hidden" name="hWOAlarm2"/>
            <input id="hOost3" type="hidden" name="hOost3" runat="server"/> <input id="hOName3" type="hidden" name="hOName3" runat="server"/> <input id="hOType3" type="hidden" name="hOType3" runat="server"/> <input id="hWOValue3" type="hidden" name="hWOValue3"/> <input id="hWOAlarm3" type="hidden" name="hWOAlarm3"/>
            <input id="hOost4" type="hidden" name="hOost4" runat="server"/> <input id="hOName4" type="hidden" name="hOName4" runat="server"/> <input id="hOType4" type="hidden" name="hOType4" runat="server"/> <input id="hWOValue4" type="hidden" name="hWOValue4"/> <input id="hWOAlarm4" type="hidden" name="hWOAlarm4"/>
            
            <input id="hAI" type="hidden" name="hAI" runat="server"/> <input id="hAIValue" type="hidden" name="hAIValue" runat="server"/> <input id="hCamUrl6" type="hidden" name="hCamUrl6" runat="server"/> <input id="hAIAlarm" type="hidden" name="hAIAlarm" runat="server"/>

            <input id="hCamUrl7" type="hidden" name="hCamUrl7" value="../../Images/Demo.mp4"/>

            <input id="hMenu" type="hidden" name="hMenu" value="1" runat="server"/> <input id="hMenu1" type="hidden" name="hMenu1" value="1" runat="server"/>

            <div style="HEIGHT: 85px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; Z-INDEX: -1; TOP: 0px; background-color:#AAC3E1">
                <p id="pPoint" runat="server" style="LEFT: 60px; TOP: 46px;FONT-SIZE: 16pt;FONT-FAMILY: 楷体_GB2312;">南京市鼓楼医院 核磁共振一室</p>
                <p style="WIDTH: 1280px; TOP: 25px;FONT-SIZE: 24pt; FONT-FAMILY: 黑体;text-align:center;">磁共振室安全云平台</p>
                <p id="pHeart" style="LEFT: 1060px; TOP: 48px;FONT-SIZE: 12pt;FONT-FAMILY: 楷体_GB2312">2023年11月10日 14:49:49</p>
            </div>
            <div style="HEIGHT: 598px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; Z-INDEX: -1; TOP: 85px; background-color:#415594">
                <div id="dMain" class="Middle" style="display:block;">
                    <div class="PieceTop" style="width:230px;left:40px;top:30px;">
                        <p id="pWostName1" class="pTitle" style="width:230px;">氧气浓度监测</p>
                    </div>
                    <div id="dWost1" class="PieceBottom" style="width:230px;height:100px;left:40px;top:60px;">
                        <p id="pWostValue1" class="pTextKT" style="width:230px;top:30px;FONT-SIZE: 26pt;"></p>
                    </div>
                    <div class="PieceTop" style="width:230px;left:40px;top:176px;">
                        <p id="pWostName2" class="pTitle" style="width:230px">环境监测</p>
                    </div>
                    <div id="dWost3" class="PieceBottom" style="width:230px;height:100px;left:40px;top:206px;">
                        <p id="pWostOValue2" class="pTextKT" style="width:230px;top:10px;FONT-SIZE: 26pt;"></p>
                        <p id="pWostOValue3" class="pTextKT" style="width:230px;top:50px;FONT-SIZE: 26pt;"></p>
                    </div>
                    <div id="dWost2" class="PieceBottom" style="width:230px;height:100px;left:40px;top:206px;">
                        <p class="pTextKT" style="width:20px;top:20px;left:5px;FONT-SIZE: 11pt;">SR</p>
                        <p id="pWostValue2" class="pTextKT" style="width:70px;top:20px;left:20px;FONT-SIZE: 11pt;"></p>
                        <p id="pWostValue3" class="pTextKT" style="width:70px;top:20px;left:90px;FONT-SIZE: 11pt;"></p>
                        <p id="pWostValue4" class="pTextKT" style="width:70px;top:20px;left:160px;FONT-SIZE: 11pt;"></p>
                        <p class="pTextKT" style="width:20px;top:60px;left:5px;FONT-SIZE: 11pt;">ER</p>
                        <p id="pOWostValue2" class="pTextKT" style="width:70px;top:60px;left:20px;FONT-SIZE: 11pt;"></p>
                        <p id="pOWostValue3" class="pTextKT" style="width:70px;top:60px;left:90px;FONT-SIZE: 11pt;"></p>
                        <p id="pOWostValue4" class="pTextKT" style="width:70px;top:60px;left:160px;FONT-SIZE: 11pt;"></p>
                        <!--
                        <p id="pWostValue2" class="pTextKT" style="width:230px;top:10px;FONT-SIZE: 26pt;"></p>
                        <p id="pWostValue3" class="pTextKT" style="width:230px;top:50px;FONT-SIZE: 26pt;"></p>
                        //-->
                    </div>
                    <div class="PieceTop" style="width:230px;left:40px;top:322px;">
                        <p class="pTitle" style="width:230px;">铁磁检测</p>
                    </div>
                    <div class="PieceBottom" style="width:230px;height:220px;left:40px;top:352px;">
                        <img style="height: 210px; width: 12px; position: absolute; left: 30px; top: 8px; z-index: 1;" src="../../Images/Hospital/Magnet_Main.png">
                        <div id="divMagnet_MLH" class="MagnetHeadM" style="left: 30px; top: 8px; z-index: 2; display: block;">
                            <img id="iMagnet_MLH" class="MagnetHeadM" src="../../Images/Hospital/Magnet_H_Green.png">
                        </div>
                        <div id="divMagnet_MLB_0" class="MagnetPieceM" style="left: 35px; top: 38px; display: block;">
                            <img id="iMagnet_MLB_0" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_MLB_1" class="MagnetPieceM" style="left: 35px; top: 69px; display: block;">
                            <img id="iMagnet_MLB_1" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_MLB_2" class="MagnetPieceM" style="left: 35px; top: 100px; display: block;">
                            <img id="iMagnet_MLB_2" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_MLB_3" class="MagnetPieceM" style="left: 35px; top: 131px; display: block;">
                            <img id="iMagnet_MLB_3" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_MLB_4" class="MagnetPieceM" style="left: 35px; top: 162px; display: block;">
                            <img id="iMagnet_MLB_4" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <IMG style="HEIGHT: 127px; WIDTH: 59px;POSITION: absolute;left:85px; top:60px; Z-INDEX: 1;" src="../../Images/Hospital/Person_2.png">
                        <img style="height: 210px; width: 12px; position: absolute; left: 188px; top: 8px; z-index: 1;" src="../../Images/Hospital/Magnet_Main.png">
                        <div id="divMagnet_MRH" class="MagnetHeadM" style="left: 188px; top: 8px;display: block;">
                            <img id="iMagnet_MRH" class="MagnetHeadM" src="../../Images/Hospital/Magnet_H_Green.png">
                        </div>
                        <div id="divMagnet_MRB_0" class="MagnetPieceM" style="left: 192px; top: 38px; display: block;">
                            <img id="iMagnet_MRB_0" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_MRB_1" class="MagnetPieceM" style="left: 192px; top: 69px; display: block;">
                            <img id="iMagnet_MRB_1" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_MRB_2" class="MagnetPieceM" style="left: 192px; top: 100px; display: block;">
                            <img id="iMagnet_MRB_2" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_MRB_3" class="MagnetPieceM" style="left: 192px; top: 131px; display: block;">
                            <img id="iMagnet_MRB_3" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_MRB_4" class="MagnetPieceM" style="left: 192px; top: 162px; display: block;">
                            <img id="iMagnet_MRB_4" class="MagnetPieceM" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                    </div>
                    <div class="PieceTop" style="width:680px;left:300px;top:30px;">
                        <p class="pTitle" style="width:680px;">视频监控</p>
                    </div>
                    <div class="PieceBottom" style="width:680px;height:512px;left:300px;top:60px;">
                        <div id="divVedio_1" style=" WIDTH: 640px; HEIGHT: 480px; POSITION: absolute; LEFT: 20px; TOP: 17px; Z-INDEX: 1;">
                            <OBJECT id="vlcVedio_1" width="640px" height="480px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                type="application/x-vlc-plugin" events="True">
                                <PARAM NAME="AutoLoop" VALUE="false">
                                <PARAM NAME="AutoPlay" VALUE="true">
                                <PARAM NAME="Toolbar" VALUE="false">
                                <PARAM NAME="MRL" VALUE="../../Images/Demo.mp4">
                                <PARAM name="BackColor" value="#000000">
                                <PARAM name="fullscreen" value="true">
                            </OBJECT>
                        </div>
                    </div>
                </div>
                <div id="dCamraSmall" class="Middle" style="display:block;">
                    <div class="PieceTop" style="width:230px;left:1010px;top:30px;">
                        <p class="pTitle" style="width:230px;">视频监控</p>
                    </div>
                    <div class="PieceBottom" style="width:230px;height:512px;left:1010px;top:60px;">
                        <div id="divVedio_2" class="VedioM1" style="TOP: 17px;">
                            <div style="width:200px;height:150px">
                                <OBJECT id="vlcVedio_2" width="200px" height="150px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                    type="application/x-vlc-plugin" events="True">
                                    <PARAM NAME="AutoLoop" VALUE="false">
                                    <PARAM NAME="AutoPlay" VALUE="false">
                                    <PARAM NAME="Toolbar" VALUE="false">
                                    <PARAM NAME="MRL" VALUE="">
                                    <PARAM name="BackColor" value="#FFFFFF">
                                    <PARAM name="fullscreen" value="false">
                                    <PARAM name="windowless" value="true">
                                </OBJECT>
                            </div> 
                            <div class="VedioButton" onclick="ChangeVedio(2);">&lt;&gt;</div>
                        </div>
                        <div id="divVedio_3" class="VedioM1" style="TOP: 182px;">
                            <div class="VedioM">
                                <OBJECT id="vlcVedio_3" width="200px" height="150px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                    type="application/x-vlc-plugin" events="True">
                                    <PARAM NAME="AutoLoop" VALUE="false">
                                    <PARAM NAME="AutoPlay" VALUE="false">
                                    <PARAM NAME="Toolbar" VALUE="false">
                                    <PARAM NAME="MRL" VALUE="">
                                    <PARAM name="BackColor" value="#FFFFFF">
                                    <PARAM name="fullscreen" value="false">
                                </OBJECT>
                            </div>
                            <div class="VedioButton" onclick="ChangeVedio(3);">&lt;&gt;</div>
                        </div>
                        <div id="divVedio_4" class="VedioM1" style="TOP: 347px;display:none;">
                            <div class="VedioM">
                                <OBJECT id="vlcVedio_4" width="200px" height="150px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                    type="application/x-vlc-plugin" events="True">
                                    <PARAM NAME="AutoLoop" VALUE="false">
                                    <PARAM NAME="AutoPlay" VALUE="false">
                                    <PARAM NAME="Toolbar" VALUE="false">
                                    <PARAM NAME="MRL" VALUE="">
                                    <PARAM name="BackColor" value="#FFFFFF">
                                    <PARAM name="fullscreen" value="false">
                                </OBJECT>
                            </div>
                            <div class="VedioButton" onclick="ChangeVedio(4);">&lt;&gt;</div>
                        </div>
                        <div id="divAI" class="PieceBottom" style="width: 200px;height:165px;TOP: 347px;left:15px;">
                            <iframe id="ifAISmall" class="MiddleFrame" src="AISmall.aspx?Serial=0"></iframe>
                        </div>
                    </div>
                </div>
                <div id="dCamraLarge" class="Middle" style="display:none;">
                    <div class="PieceTop" style="width:912px;left:50px;top:30px;">
                        <p class="pTitle" style="width:912px;">视频监控</p>
                    </div>
                    <div class="PieceBottom" style="width:912px;height:512px;left:50px;top:60px;">
                        <div id="divVedio_5" style="WIDTH: 912px; HEIGHT: 513px; POSITION: absolute; Z-INDEX: 1;">
                            <OBJECT id="vlcVedio_5" width="912px" height="513px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                type="application/x-vlc-plugin" events="True">
                                <PARAM NAME="AutoLoop" VALUE="false">
                                <PARAM NAME="AutoPlay" VALUE="false">
                                <PARAM NAME="Toolbar" VALUE="false">
                                <PARAM NAME="MRL" VALUE="">
                                <PARAM name="BackColor" value="#FFFFFF">
                                <PARAM name="fullscreen" value="true">
                            </OBJECT>
                        </div>
                    </div>
                </div>
                <div id="dMagnet" class="Middle" style="display:none;">
                    <div class="PieceTop" style="width:530px;left:40px;top:30px;">
                        <p class="pTitle" style="width:530px;">铁磁检测</p>
                    </div>
                    <div class="PieceBottom" style="width:530px;height:512px;left:40px;top:60px;">
                        <img style="height: 480px; width: 27px; position: absolute; left: 70px; top: 22px; z-index: 1;" src="../../Images/Hospital/Magnet_Main.png">
                        <div id="divMagnet_LLH" class="MagnetHeadL" style="left: 70px; top: 22px; z-index: 2; display: block;">
                            <img id="iMagnet_LLH" class="MagnetHeadL" src="../../Images/Hospital/Magnet_H_Green.png">
                        </div>
                        <div id="divMagnet_LLB_0" class="MagnetPieceL" style="left: 82px; top: 90px; display: block;">
                            <img id="iMagnet_LLB_0" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_LLB_1" class="MagnetPieceL" style="left: 82px; top: 163px; display: block;">
                            <img id="iMagnet_LLB_1" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_LLB_2" class="MagnetPieceL" style="left: 82px; top: 236px; display: block;">
                            <img id="iMagnet_LLB_2" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_LLB_3" class="MagnetPieceL" style="left: 82px; top: 309px; display: block;">
                            <img id="iMagnet_LLB_3" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_LLB_4" class="MagnetPieceL" style="left: 82px; top: 382px; display: block;">
                            <img id="iMagnet_LLB_4" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <IMG style="HEIGHT: 296px; WIDTH: 137px;POSITION: absolute;left:198px; top:140px; Z-INDEX: 1;" src="../../Images/Hospital/Person_2.png">
                        <img style="height: 480px; width: 27px; position: absolute; left: 461px; top: 22px; z-index: 1;" src="../../Images/Hospital/Magnet_Main.png">
                        <div id="divMagnet_LRH" class="MagnetHeadL" style="left: 461px; top: 22px;display: block;">
                            <img id="iMagnet_LRH" class="MagnetHeadL" src="../../Images/Hospital/Magnet_H_Green.png">
                        </div>
                        <div id="divMagnet_LRB_0" class="MagnetPieceL" style="left: 472px; top: 90px; display: block;">
                            <img id="iMagnet_LRB_0" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_LRB_1" class="MagnetPieceL" style="left: 472px; top: 163px; display: block;">
                            <img id="iMagnet_LRB_1" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_LRB_2" class="MagnetPieceL" style="left: 472px; top: 236px; display: block;">
                            <img id="iMagnet_LRB_2" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_LRB_3" class="MagnetPieceL" style="left: 472px; top: 309px; display: block;">
                            <img id="iMagnet_LRB_3" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                        <div id="divMagnet_LRB_4" class="MagnetPieceL" style="left: 472px; top: 382px; display: block;">
                            <img id="iMagnet_LRB_4" class="MagnetPieceL" src="../../Images/Hospital/Magnet_B_Green.png">
                        </div>
                    </div>
                    <div class="PieceTop" style="width:630px;left:610px;top:30px;">
                        <p class="pTitle" style="width:630px;">今日警讯</p>
                    </div>
                    <div class="PieceBottom" style="width:630px;height:512px;left:610px;top:60px;">
                        <div class="MagnetLineY">次</div>
                        <div class="MagnetLine">
                            <img id="iMagnetLine1" class="MagnetLineI">
                        </div>
                        <div class="MagnetLineX">时间</div>
                        <div class="MagnetPie">
                            <img id="iMagnetPie1" class="MagnetPieI">
                        </div>
                        <div class="PieButton" onclick="ChangeMagnet(1)" style="top:254px;left:280px;"><p class="ButtonText">铁磁统计</p></div>
                        <div class="MagnetPieX">
                            <iframe id="ifMagnetEvent" class="MagnetPieI" src="MagnetEvent.aspx"></iframe>
                        </div>
                    </div>
                </div>
                <div id="dMagnetStat" class="Middle" style="display:none;">
                    <iframe id="ifMagnetStat" class="MiddleFrame" src="MagnetStat.aspx"></iframe>
                    <div class="PieButton" onclick="ChangeMagnet(2)" style="top:314px;left:890px;Z-INDEX: 3;"><p class="ButtonText">铁磁安全</p></div>
                </div>
                <div id="dCamraHistory" class="Middle" style="display:none;">
					<div class="PieceTop" style="width:690px;left:40px;top:30px;">
						<p class="pTitle" style="width:690px;">检索管理</p>
					</div>
					<div class="PieceBottom" style="width:690px;height:512px;left:40px;top:60px;">
						<div class="Condition" style="width:636px;left:25px;top:30px;">
							<p class="ConditionText" style="left:10px;top:10px;"">按条件检索</p>
							<p class="ConditionText" style="left:10px;left;top:40px;">时间：<input id="dStartHis" runat="server" size="12" type="text" readonly="readonly" onfocus="Calendar(this,2);" />至<input id="dEndHis" runat="server" size="12" readonly="readonly" type="text" onfocus="Calendar(this,2);" />
							<p class="ConditionText" style="left:10px;top:70px;"><input id="hDanger" type="checkbox" checked/> 高风险&nbsp;&nbsp;<input id="mDanger" type="checkbox" checked/>中风险&nbsp;&nbsp;<input id="lDanger" type="checkbox" checked/>低风险</p>
							<div class="PieButton" onclick="HistoryQuery();" style="top:20px;left:300px;"><p class="ButtonText">数据检索</p></div>
						</div>
                        <iframe id="ifCamraHistory" class="LVTable" style="width:690px;height:367px;" src="EventQuery.aspx"></iframe>
					</div>
					<div class="PieceTop" style="width:480px;left:750px;top:30px;">
						<p class="pTitle" style="width:480px;">视频监控</p>
					</div>
					<div class="PieceBottom" style="width:480px;height:512px;left:750px;top:60px;">
						<div id="divVedio_7" style="width:480px;height:345px;left:10px;top:85px;">
							<OBJECT id="vlcVedio_7" width="460px" height="345px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
								type="application/x-vlc-plugin" events="True">
								<PARAM NAME="AutoLoop" VALUE="true">
								<PARAM NAME="AutoPlay" VALUE="false">
								<PARAM NAME="Toolbar" VALUE="true">
								<PARAM NAME="MRL" VALUE="">
								<PARAM name="BackColor" value="#FFFFFF">
								<PARAM name="fullscreen" value="false">
								<PARAM name="windowless" value="true">
							</OBJECT>
						</div>
					</div>
                </div>
                <div id="dManager" class="Middle" style="display:none;">
                    <iframe id="ifManager" class="MiddleFrame" src="../../Main/Login.aspx"></iframe>
                </div>
                <div id="dWost" class="Middle" style="display:none;">
                    <div class="PieceTop" style="width:690px;left:40px;top:30px;">
                        <p class="pTitle" style="width:690px;">实时监测</p>
                    </div>
                    <div class="PieceBottom" style="width:690px;height:512px;left:40px;top:60px;">
                        <div class="WostLine1" style="top:195px;left:25px;">
                            <img id="iWostLine1" class="WostLine1">
                        </div>
                        <div class="PieMax" style="top:20px;left:50px;background-color:#2A2D3E;">
                            <div class="PieMin" style="top:10px;left:10px;background-color:red;">
                                <p id="pWValue1" class="pTextKT"  style="width:140px;top:30px;FONT-SIZE: 26pt;"></p>
                                <p class="pTextKT"  style="width:140px;top:80px;FONT-SIZE: 18pt;">氧气浓度</p>
                            </div>
                        </div>
                        <div class="PieMax" style="top:20px;left:260px;background-color:#2A2D3E;">
                            <div class="PieMin" style="top:10px;left:10px;background-color:yellow;">
                                <p id="pWValue2" class="pTextKT"  style="width:140px;top:30px;FONT-SIZE: 26pt;"></p>
                                <p class="pTextKT"  style="width:140px;top:80px;FONT-SIZE: 18pt;">温度</p>
                            </div>
                        </div>
                        <div class="PieMax" style="top:20px;left:470px;background-color:#2A2D3E;">
                            <div class="PieMin" style="top:10px;left:10px;background-color:blue;">
                                <p id="pWValue3" class="pTextKT"  style="width:140px;top:30px;FONT-SIZE: 26pt;"></p>
                                <p class="pTextKT"  style="width:140px;top:80px;FONT-SIZE: 18pt;">湿度</p>
                            </div>
                        </div>
                        <p class="WostLine1P" style="text-align:left;left:60px;color:white;">近一小时实时数据</p>
                    </div>
                    <div class="PieceTop" style="width:480px;left:750px;top:30px;">
                        <p class="pTitle" style="width:480px;">报警统计</p>
                    </div>
                    <div class="PieceBottom" style="width:480px;height:512px;left:750px;top:60px;">
                        <div class="WostLine2">
                            <img id="iWostLine2" class="WostLine2I">
                        </div>
                        <div class="Condition" style="width:400px;left:40px;top:330px;">
                            <p class="ConditionText" style="left:10px;top:10px;">按条件检索</p>
                            <p class="ConditionText" style="left:10px;top:40px;">时间：<input id="dStart" runat="server" size="12" type="text" readonly="readonly" onfocus="Calendar(this,2);"/>至<input id="dEnd" runat="server" size="12" type="text" readonly="readonly" onfocus="Calendar(this,2);"/>
                            <p class="ConditionText" style="left:10px;top:70px;"><input  id="hO2" type="checkbox" checked/><span style="background-color:red;font-size:12pt;">氧浓度报警</span>&nbsp;&nbsp;<input id="hWD"  type="checkbox" checked/><span style="background-color:yellow;font-size:12pt;">温湿度报警</span></p>
                            <div class="PieButton" onclick="WostQuery();" style="top:20px;left:300px;"><p class="ButtonText">数据检索</p></div>
                        </div>
                    </div>
                </div>
                <div id="dAI" class="Middle" style="display:none;">
                    <div class="PieceTop" style="width:680px;left:40px;top:30px;">
                        <p class="pTitle" style="width:680px;">智能预警</p>
                    </div>
                    <div class="PieceBottom" style="width:680px;height:512px;left:40px;top:60px;">
                        <div id="divVedio_6" style=" WIDTH: 640px; HEIGHT: 480px; POSITION: absolute; LEFT: 20px; TOP: 17px; Z-INDEX: 1;">
                            <OBJECT id="vlcVedio_6" width="640px" height="480px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                type="application/x-vlc-plugin" events="True">
                                <PARAM NAME="AutoLoop" VALUE="false">
                                <PARAM NAME="AutoPlay" VALUE="false">
                                <PARAM NAME="Toolbar" VALUE="false">
                                <PARAM NAME="MRL" VALUE="">
                                <PARAM name="BackColor" value="#FFFFFF">
                                <PARAM name="fullscreen" value="true">
                            </OBJECT>
                        </div>
                    </div>
                    <div class="PieceTop" style="width:520px;left:730px;top:30px;">
                        <p class="pTitle" style="width:520px;">高风险物体</p>
                    </div>
                    <div class="PieceBottom" style="width:520px;height:512px;left:730px;top:60px;">
                        <iframe id="ifAILarge" class="AILarge" src="AILarge.aspx?Serial=0"></iframe>
                    </div>
                </div>
            </div>
            <div style="HEIGHT: 85px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; Z-INDEX: -1; TOP: 683px; background-color:#C5E6F6">
                <IMG style="HEIGHT: 70px; WIDTH: 84px;POSITION: absolute;left:50px; top: 5px; Z-INDEX: 1;" src="../../Images/Hospital/Logo.png">
                <div id="divMenu1" class= "Menu" style="LEFT: 178px; TOP: 22px;">
                    <p id="pMenu1" onclick="ChangeMenu(1);" class= "MenuText" style="COLOR: black;font-weight:bolder;">&nbsp;主&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;页</p>
                </div>
                <div id="divMenu2" class= "Menu" style="LEFT: 332px; TOP: 22px;">
                    <p id="pMenu2" onclick="ChangeMenu(2);" class= "MenuText" style="COLOR: gray; Z-INDEX: 1;">铁磁安全</p>
                </div>
                <div id="divMenu2R" style="HEIGHT: 85px;WIDTH: 156px;POSITION: absolute;Z-INDEX: 0;LEFT: 332px;background-color:red;display:none;">
                </div>
                <div id="divMenu3" class= "Menu" style="LEFT: 486px; TOP: 22px;">
                    <p id="pMenu3" onclick="ChangeMenu(3);" class= "MenuText" style="COLOR: gray;">视频监控</p>
                </div>
                <div id="divMenu4" class= "Menu" style="LEFT: 640px; TOP: 22px;">
                    <p id="pMenu4"  onclick="ChangeMenu(4);" class= "MenuText" style="COLOR: gray;">视频联动</p>
                </div>
                <div id="divMenu5" class= "Menu" style="LEFT: 794px; TOP: 22px; Z-INDEX: 1;">
                    <p id="pMenu5" onclick="ChangeMenu(5);" class= "MenuText" style="COLOR: gray;">环境监测</p>
                </div>
                <div id="divMenu5R" style="HEIGHT: 85px;WIDTH: 156px;POSITION: absolute;Z-INDEX: 0;LEFT: 794px;background-color:red;display:none;">
                </div>
                <div id="divMenu6" class= "Menu" style="LEFT: 948px; TOP: 22px;">
                    <p id="pMenu6" onclick="ChangeMenu(6);" class= "MenuText" style="COLOR: gray;">&nbsp;管&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;理</p>
                </div>
                <div id="divMenu7" class= "Menu" style="LEFT: 1102px; TOP: 22px;">
                    <p id="pMenu7" onclick="ChangeMenu(7);" class= "MenuText" style="COLOR: gray; Z-INDEX: 1;">智能预警</p>
                </div>
                <div id="divMenu7R" style="HEIGHT: 85px;WIDTH: 156px;POSITION: absolute;Z-INDEX: 0;LEFT: 1102px;background-color:red;display:none;">
                </div>
            </div>
        </form>
        <script>
            InitPage();
            //disableTextSelection();
            document.onkeydown = disableFuncKey;
            document.onkeypress = disableFuncKey;
        </script>
    </body>
</html>
