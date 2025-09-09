<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Public_Test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>TestWindow</title>
	    <link href="../Content/Hospital.css" type="text/css" rel="stylesheet" />
		<script src="../Public/Function.js"></script>
        <style>
            body {
                overflow:hidden;
                margin:0px;
            }

            form {
                margin:0px;
                border:0px;
            }

            div {
                POSITION: absolute;
                margin:0px;
            }

            p {
                POSITION: absolute;
                margin:0px;
                COLOR: black;
                text-align:center;
            }

            img {
                POSITION: absolute;
                margin:0px;
            }
            .PieceTop
            {
                border-radius:10px 10px 0px 0px;
                background-color:#118BC8;
                width:1000px;
                height: 30px;
            }

            .PieceBottom {
                border-radius:0px 0px 10px 10px;
                background-color: #F2F8F8;
                width:1000px;
                height:160px;
            }

             .pTitle
            {
                TOP: 6px;
                FONT-SIZE: 14pt;
                FONT-FAMILY: 楷体_GB2312;
                font-weight:bold;
                text-align:center;
            }

           .PieceBlock
            {
                border-radius:5px;
                background-color:#94D0F4;
                height: 120px;
                width:296px;
            }

            .PieceBlock1
            {
                background-color:#118BC8;
                height: 4px;
                width:296px;
                z-index:3;
            }

            .pTitle1
            {
                width:296px;
                FONT-SIZE: 24pt;
                FONT-FAMILY: 楷体_GB2312;
                font-weight:bold;
                text-align:center;
            }

            .pImage
            {
                height:120px;
                width:208px;
                left:396px;
                top:20px;
            }
        </style>
		<script type="text/javascript">
		    var interval = null;
		    var oHttpReq = [null, null, null, null, null];
		    var oTimeout = [null, null, null, null, null];

		    function AddLog(sLog)
		    {
		        var date = new Date();
		        var options = { year: 'numeric', month: '2-digit', day: '2-digit', hour12: false, hour: '2-digit', minute: '2-digit', second: '2-digit' };
		        SetHtmlValue("tLog", "V", date.toLocaleString('zh-CN', options) + " " + sLog + "\r\n" + GetHtmlValue("tLog", "V"))
		    }

		    function TestHttp()
		    {
		        var i = 0;
		        //for (; i < 5; i ++)
		        //{
		            AskHttp(i);
		        //}
		    }

		    function AddValue(sObject)
		    {
		        SetHtmlValue(sObject, "V", parseInt(GetHtmlValue(sObject, "V")) + 1)
		    }

		    function AskHttp(iLoc)
		    {
		        if (oHttpReq.length > iLoc)
		        {
		            var sUrl = "../Services/XmlServer.aspx?PTYPE=GETPRESULT&PCOND=1&t=" + (new Date().getTime());

		            //var sUrl = "../Services/XmlServer.aspx?PTYPE=GETMRESULT&PCOND=1&t=" + (new Date().getTime());
		            if (oHttpReq[iLoc])
		            {
		                //跳
		                AddLog("跳 " + iLoc);
		                return;
		            }
		            AddValue("iTotal");
		            oHttpReq[iLoc] = new ActiveXObject("MSXML2.XMLHTTP");
		            oHttpReq[iLoc].onreadystatechange = function () {

		                if (oHttpReq[iLoc] && oHttpReq[iLoc].readyState == 4 && oHttpReq[iLoc].status == 200) {
		                    DealHttpAnswer(iLoc);
		                }
		            }
		            oHttpReq[iLoc].open("POST", sUrl, true);
		            oHttpReq[iLoc].send("");
		        }
		        if (oTimeout.length > iLoc) {
		            oTimeout[iLoc] = setTimeout(TimeHandle,1000,iLoc);
		        }
		    }

		    function DealHttpAnswer(iLoc)
		    {
		        AddLog("答 " + iLoc);
		        AddValue("iAnswer");
		        if (oHttpReq.length > iLoc && oHttpReq[iLoc]) {
		            SetHtmlValue("tResult", "V", oHttpReq[iLoc].responseText)
		            //alert(iLoc + oHttpReq[iLoc].responseText);
		            oHttpReq[iLoc] = null;
		        }
		        if (oTimeout.length > iLoc && oTimeout[iLoc]) {
		            clearTimeout(oTimeout[iLoc]);
		            oTimeout[iLoc] = null;
		        }
            }

		    function TimeHandle(iLoc)
		    {
		        if (oHttpReq.length > iLoc && oHttpReq[iLoc]) {
		            AddValue("iTimeout");
		            AddLog("超 " + iLoc);
		            oHttpReq[iLoc].abort();
		            AddLog("Abort " + iLoc);
		            oHttpReq[iLoc] = null;
		        }
		    } 

		    function Test1() {
		        interval = self.setInterval("TestHttp()",1500);
		        return;
		        try
		        {
		            var vlc = document.getElementById("vlcVedio_5");
		            var options = [":network-caching=300"];
		            if (vlc != null) {
		                alert(vlc.playlist.itemCount);
		                if (vlc.playlist.itemCount > 0) {
		                    if (vlc.playlist.isPlaying)
		                        vlc.playlist.stop();
		                    vlc.playlist.clear();
		                }
		                vlc.playlist.add("../Images/Demo.mp4", "", options);
		                vlc.playlist.play();
		                alert("play");
		            }
		        }
		        catch (ce)
		        {
		          
		        }
		        alert("End");
		        /*
		        var aA = document.getElementById("A1");
		        aA.pause();
		        var sFile = GetHtmlValue("AN", "V");
		        aA.src = "../Audio/" + sFile + ".mp3";
		        aA.play();
                */
		    }

		    function Test2() {
		        clearInterval(interval);
		        return;
		            var vlc = document.getElementById("vlcVedio_5");
		            if (vlc != null) {
		                if (vlc.playlist.itemCount > 0)
		                {
		                    if (vlc.playlist.isPlaying)
		                        vlc.playlist.stop();
		                }
		            }
		        /*
		        var aA = document.getElementById("A1");
		        aA.pause();
                */
		    }

		</script>
    </head>
    <body>
        <form id="form1" runat="server">

            <input type="button" onclick="Test1()" value="播放"/>
            <input type="button" onclick="Test2()" value="停止"/>
            <input id="iTotal" type="text" value="0"/>
            <input id="iAnswer" type="text" value="0"/>
            <input id="iTimeout" type="text" value="0"/>
            <textarea id="tResult" style="POSITION: absolute;width:1000px;height:140px;top:60px;left:0px;"></textarea>

            <textarea id="tLog" style="POSITION: absolute;width:1000px;height:500px;top:200px;left:0px;"></textarea>
            <!--
            <div>
                <audio id="A1" loop></audio>
                <audio id="aAlarm" loop></audio>
                <input id="AN" type="text" value="Alarm1" />
                <input type="button" onclick="Test1()" value="播放"/>
                <input type="button" onclick="Test2()" value="停止"/>
            </div>

            <div class="PieceBottom" style="width:912px;height:512px;left:50px;top:60px;">
                <div id="divVedio_5" style="WIDTH: 912px; HEIGHT: 513px; POSITION: absolute; Z-INDEX: 1;">
                    <OBJECT id="vlcVedio_5" width="912px" height="513px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                        type="application/x-vlc-plugin" events="True">
                        <PARAM NAME="AutoLoop" VALUE="false">
                        <PARAM NAME="AutoPlay" VALUE="true">
                        <PARAM NAME="Toolbar" VALUE="false">
                        <PARAM NAME="src" VALUE="../Images/Demo.mp4">
                        <PARAM name="BackColor" value="#FFFFFF">
                        <PARAM name="fullscreen" value="true">
                    </OBJECT>
                </div>
            </div>
            <asp:TreeView ID="TreeView1" runat="server">
            </asp:TreeView>
            !-->
        </form>
        <script>
            TestHttp();
        </script>
    </body>
</html>
