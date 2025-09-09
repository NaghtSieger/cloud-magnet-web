<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Event.aspx.cs" Inherits="Equipment_Event" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Event</title>
	    <link href="../Content/Hospital.css" type="text/css" rel="stylesheet" />
	    <script src="../Public/Function.js"></script>
		<script type="text/javascript">
		    function Query()
		    {
		        SetHtmlValue("workflag", "V", "STAT");
		        form1.submit();
		    }

		    function Jump() {
		        var iOld = parseInt(GetHtmlValue("hPage", "V"));
		        var iNew = parseInt(GetHtmlValue("iPage", "V"));
		        var iTotal = parseInt(GetHtmlValue("iTotal", "V"));
		        var iRows = iTotal;
		        if (iOld != iNew) {
		            var i = 0;
		            form1.hPage.value = iNew.toString();
		            if (iOld > 0) {
		                iRows = iOld * 10;
		                if (iRows > iTotal)
		                    iRows = iTotal;
		                for (i = (iOld - 1) * 10 + 1; i < iRows + 1; i++) {
		                    var vItem = document.getElementById("vhRow" + i.toString());
		                    if (vItem != null)
		                        vItem.style.display = "none";

		                }
		            }
		            iRows = iNew * 10;
		            if (iRows > iTotal)
		                iRows = iTotal;
		            for (i = (iNew - 1) * 10 + 1; i < iRows + 1; i++) {
		                var vItem = document.getElementById("vhRow" + i.toString());
		                if (vItem != null)
		                    vItem.style.display = "table-row";
		            }

		        }

		    }

		    function First() {
		        var iPage = parseInt(GetHtmlValue("iPage", "V"));
		        if (iPage != 1) {
		            var vItem = document.getElementById("iPage");
		            if (vItem != null)
		                vItem.value = "1";
		            Jump();

		        }
		    }

		    function Next() {
		        var iPage = parseInt(GetHtmlValue("iPage", "V"));
		        var iPages = parseInt(GetHtmlValue("iPages", "V"));
		        if (iPage < iPages) {
		            iPage++;
		            var vItem = document.getElementById("iPage");
		            if (vItem != null)
		                vItem.value = iPage;
		            Jump();
		        }

		    }

		    function Pre() {
		        var iPage = parseInt(GetHtmlValue("iPage", "V"));
		        if (iPage > 1) {
		            iPage--;
		            var vItem = document.getElementById("iPage");
		            if (vItem != null)
		                vItem.value = iPage;
		            Jump();

		        }
		    }

		    function InitPage() {
		        var vItem = document.getElementById("iPage");
		        if (vItem != null)
		            vItem.value = "1";
		    }

		    function PalyVedioHis(sUrl) {
		        var obj = document.getElementById("divVedio");
		        obj.style.display = "block";
		        var options = [":network-caching=300"];
		        var vlc = document.getElementById("vlcVedio_H");
		        if (vlc != null) {
		            if (vlc.playlist.itemCount > 0) {
		                if (vlc.playlist.isPlaying)
		                    vlc.playlist.stop();
		                vlc.playlist.clear();
		            }
		            vlc.playlist.add(sUrl, "", options);
		            vlc.playlist.play();
		        }
		    }

		    function StopPlay()
		    {
		        var vlc = document.getElementById("vlcVedio_H");
		        if (vlc != null) {
		            if (vlc.playlist.itemCount > 0) {
		                if (vlc.playlist.isPlaying)
		                    vlc.playlist.stop();
		            }
		        }
		        var obj = document.getElementById("divVedio");
		        obj.style.display = "none";
		    }
        </script>
    </head>
    <body>
        <form id="form1" runat="server">
			<input id="workflag" type="hidden" name="workflag" runat="server" /> <input id="hPage" type="hidden" name="hPage" value="0" runat="server" />
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">预警事件查询</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <div class="Condition" style="width:940px;left:20px;top:30px;">
                        <p class="DataTile" style ="top:20px;">管理部门</p>
                        <asp:dropdownlist id="drpDepartment" AutoPostBack="True" style="position:absolute;width:505px;height:25px;left:80px;top:15px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server" OnSelectedIndexChanged="drpDepartment_SelectedIndexChanged"></asp:dropdownlist>
                        <p class="DataTile" style ="left:580px;top:20px;">监测点位</p>
                        <asp:dropdownlist id="drpPoint" style="position:absolute;width:160px;height:25px;left:660px;top:15px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server"></asp:dropdownlist>
                        <p class="DataTile" style ="top:55px;">发生时间</p>
                        <input id="dStart" class="DataText" style ="width:100px;left:80px;top:50px;" runat="server" onfocus="Calendar(this,1);" />
                        <p class="DataTile" style ="width:10px;left:190px;top:55px;">至</p>
                        <input id="dEnd"  class="DataText" style ="width:100px;left:210px;top:50px;" runat="server" onfocus="Calendar(this,1);" />
                        <p class="DataTile" style ="left:300px;top:55px;">事件等级</p>
                        <p class="ConditionText" style="width:200px;left:380px;top:55px;"><input  id="hDanger" runat="server" type="checkbox" checked="checked" /> 高风险&nbsp;&nbsp;<input id="mDanger"  runat="server" type="checkbox" checked="checked" />中风险&nbsp;&nbsp;<input id="lDanger" runat="server" type="checkbox" checked="checked" />低风险</p>
                        <p class="DataTile" style ="left:580px;top:55px;">设备类型</p>
                        <asp:dropdownlist id="drpEType" style="position:absolute;width:160px;height:25px;left:660px;top:50px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server"></asp:dropdownlist>
						<div class="PieButton" onclick="Query();" style="top:20px;left:840px;"><p class="ButtonText">数据检索</p></div>
                    </div>
                    <div id="vhList" runat="server" class="LVTable" style="width:940px;">
						<table style="width:940px;text-align:center;margin:0;border-collapse:collapse;" border="1">
							<tr style="height:30px;">
								<td style="width: 60px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">序号</p></td>
								<td style="width:265px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">报警时间</p></td>
								<td style="width: 80px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">报警等级</p></td>
								<td style="width:150px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">报警点位</p></td>
								<td style="width:150px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">报警设备</p></td>
								<td style="width:230px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">操作</p></td>
							</tr>
							<tr id="vhRow|LXH" style="height:30px;display:none;">
								<td style="width: 60px;"><P style="position:static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">|LXH</p></td>
								<td style="width:265px;"><P style="position:static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">|L000</p></td>
								<td style="width: 80px;"><P style="position:static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">|L001</p></td>
								<td style="width:150px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">|L002</p></td>
								<td style="width:150px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">|L003</p></td>
								<td style="width:230px;"><div style="position:static; font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;display:block"><a onclick="PalyVedioHis('|L004');" style="CURSOR:alias; TEXT-DECORATION: none; BORDER: white thin outset; COLOR: blue; BORDER-LEFT: white thin outset">&nbsp;播放&nbsp;</a> <a style="CURSOR:alias; TEXT-DECORATION: none; BORDER: white thin outset; COLOR: blue; BORDER-LEFT: white thin outset" href="|L004">&nbsp;导出&nbsp;</a></div></td>
							</tr>
						</table>
                    </div>
                    <div style="POSITION: absolute; width:940px;left:20px;top:480px;">
                        <p class="ConditionText" style="left: 10px;">共有记录<input id="iTotal" runat="server" style="text-align:center;border:0;width:20px;" readonly="readonly" type="text"/>条</p>
                        <p class="ConditionText" style="left: 280px;""><input type="button" value="首&nbsp;&nbsp;页" onclick="First();"/></p>
                        <p class="ConditionText" style="left: 444px;""><input type="button" value="上一页" onclick="Pre();"/></p>
                        <p class="ConditionText" style="left: 688px;""><input type="button" value="下一页" onclick="Next();"/></p>
                        <p class="ConditionText" style="left: 800px;"><input id="iPage" value="1"  style="text-align:center;width:20px;" type="text"/>/<input id="iPages" runat="server" style="text-align:center;border:0;width:20px;" readonly="readonly" type="text"/><input type="button" value="转页" onclick="Jump();" /></p>
                    </div>
                    <div id="divVedio" class="DataArea" style ="width:945px;height:512px;left:20px;z-index:1;display:none;">
                        <div style="WIDTH: 912px; HEIGHT: 513px;">
                            <OBJECT id="vlcVedio_H" width="912px" height="513px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                type="application/x-vlc-plugin" events="True">
                                <PARAM NAME="AutoLoop" VALUE="0">
                                <PARAM NAME="AutoPlay" VALUE="-1">
                                <PARAM NAME="Toolbar" VALUE="0">
                                <PARAM NAME="MRL" VALUE="">
                                <PARAM name="BackColor" value="0">
                                <PARAM name="fullscreen" value="true">
                            </OBJECT>
                        </div>
                        <img style="height: 20px; width: 20px; left: 912px;" onclick="StopPlay();" src="../../Images/CheckU.gif">
                    </div>
                </div>
            </div>
        </form>
		<script>
		    InitPage();
		    Jump();
		</script>
    </body>
</html>
