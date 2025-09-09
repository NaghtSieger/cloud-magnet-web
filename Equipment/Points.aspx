<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Points.aspx.cs" Inherits="Equipment_Points" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>Points</title>
	    <link href="../Content/Hospital.css" type="text/css" rel="stylesheet" />
	    <script src="../Public/Function.js"></script>
		<script type="text/javascript">
		    function PointHelp(iVedio) {
		        var sJump = GetHtmlValue("hJump", "V");
		        if (sJump == "0") {
		            SetHtmlValue("hJump", "V", "1");
		            StopVedio(1);
		            StopVedio(2);
		            StopVedio(3);
		            StopVedio(4);
		            window.top.location.href = "PointHospital/HospitalMain.aspx?Point=" + GetPoint(iVedio);
                }
		    }

		    function GetPoint(iVedio)
		    {
		        var iPoints = parseInt(GetHtmlValue("iTotal", "V"));
		        var iPage = parseInt(GetHtmlValue("iPage", "H"));
		        var iStart = (iPage - 1) * 4;
		        if (iStart > iPoints - 4)
		            iStart = iPoints - 4;
		        var iLoc = iStart + iVedio;
		        return GetHtmlValue("hPS_" + iLoc, "V");
		    }

		    function SetPoint(iStart,iVedio)
		    {
		        var iLoc = iStart + iVedio;
		        SetHtmlValue("pPoint_" + iVedio, "H", "<br>" + GetHtmlValue("hPN_" + iLoc, "V"));
		        StopVedio(iVedio);
		        AddPlaylist(iVedio, GetHtmlValue("hPU_" + iLoc, "V"));
		    }

		    function AddPlaylist(iVedio, sUrl) {
		        if (sUrl == "")
		            return;
		        var options = [":network-caching=300"];
		        var vlc = document.getElementById("vlcVedio_" + iVedio);
		        if (vlc != null) {
		            vlc.playlist.add(sUrl, "", options);
		            vlc.playlist.play();
		        }
		    }

		    function SetPoints(iPage)
		    {
		        SetHtmlValue("iPage", "H", iPage);
		        var iPoints = parseInt(GetHtmlValue("iTotal", "V"));
		        var iStart = (iPage - 1) * 4;
		        if (iStart > iPoints - 4)
		            iStart = iPoints - 4;
		        if (iStart < 0)
		            iStart = 0;
		        SetPoint(iStart, 1);
		        SetPoint(iStart, 2);
		        SetPoint(iStart, 3);
		        SetPoint(iStart, 4);
		    }

		    function Next() {
		        var iPage = parseInt(GetHtmlValue("iPage", "H"));
		        var iPages = parseInt(GetHtmlValue("iPages", "H"));
		        if (iPage < iPages) {
		            iPage++;
		            SetPoints(iPage);
                }
		    }

		    function Pre() {
		        var iPage = parseInt(GetHtmlValue("iPage", "H"));
		        if (iPage > 1) {
		            iPage--;
		            SetPoints(iPage);
		        }
		    }

		    function StopVedio(iVedio) {
		        var vlc = document.getElementById("vlcVedio_" + iVedio);
		        if (vlc != null) {
		            if (vlc.playlist.itemCount > 0) {
		                if (vlc.playlist.isPlaying)
		                    vlc.playlist.stop();
		                vlc.playlist.clear();
		            }
		        }
		    }

		    function InitPage() {
		        SetHtmlValue("hJump", "V", "0");
		        var iPoints = parseInt(GetHtmlValue("iTotal", "V"));
		        var iPages = 0;
		        if (iPoints > 4) {
		            if ((iPoints % 4) > 0) {
		                iPages = 1;
		                iPoints -= iPoints % 4;
		            }
		            iPages += iPoints / 4;
		        }
		        if (iPages == 0)
		            iPages = 1;
		        SetHtmlValue("iPages", "H", iPages);

		        var vItem = document.getElementById("divVedio_1");
		        if (vItem != null)
		        {
		            if (iPoints > 0)
		                vItem.style.display = "block";
		            else
		                vItem.style.display = "none";
		        }

		        vItem = document.getElementById("divVedio_2");
		        if (vItem != null) {
		            if (iPoints > 1)
		                vItem.style.display = "block";
		            else
		                vItem.style.display = "none";
		        }

		        vItem = document.getElementById("divVedio_3");
		        if (vItem != null) {
		            if (iPoints > 2)
		                vItem.style.display = "block";
		            else
		                vItem.style.display = "none";
		        }

		        vItem = document.getElementById("divVedio_4");
		        if (vItem != null) {
		            if (iPoints > 3)
		                vItem.style.display = "block";
		            else
		                vItem.style.display = "none";
		        }

		        vItem = document.getElementById("divMove");
		        if (vItem != null) {
		            if (iPages > 1)
		                vItem.style.display = "block";
		            else
		                vItem.style.display = "none";
		        }
		        SetPoints(1);
		    }
        </script>
    </head>
    <body>
        <form id="form1" runat="server">
            <input id="hJump" type="hidden" name="hJump" value="0"/> <input id="iTotal" type="hidden" name="iTotal" runat="server" value="14"/>
            <div id="vhList" runat="server" style="display:none;"></div>
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">点位预览</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <div id="divMove" style="width:10px;height:512px;left:960px;">
					    <img class="MoveList" style="top:122px;" onclick="Pre();" src="../Images/Up.png" />
                        <p id="iPage" class="ConditionText" style="width:10px;height:10px;top:236px;text-align:center;">1</p>
                        <p class="ConditionText" style="width:10px;height:10px;top:245px;text-align:center;">--</p>
                        <p id="iPages" class="ConditionText" style="width:10px;height:10px;top:259px;text-align:center;">1</p>
					    <img class="MoveList" style="top:306px;" onclick="Next();" src="../Images/Down.png" />
                    </div>
                    <div id="divVedio_1" style="width:470px;height:252px;left:10px;top:2px;" onclick="PointHelp(1);">
                        <p id="pPoint_1" class="PoinsName" style="left:3px;"><br/>核磁共振一室</p>
                        <div class="PoinsVedio" style="left:22px;">
                            <OBJECT id="vlcVedio_1" width="448px" height="252px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                type="application/x-vlc-plugin" events="True">
                                <PARAM NAME="AutoLoop" VALUE="0">
                                <PARAM NAME="AutoPlay" VALUE="-1">
                                <PARAM NAME="Toolbar" VALUE="0">
                                <PARAM NAME="MRL" VALUE="">
                                <PARAM name="BackColor" value="0">
                                <PARAM name="fullscreen" value="true">
                            </OBJECT>
                        </div>
                    </div>
                    <div id="divVedio_2" style="width:470px;height:252px;left:490px;top:2px;" onclick="PointHelp(2);">
                        <p id="pPoint_2" class="PoinsName" style="left:3px;"><br/>核磁共振二室</p>
                        <div class="PoinsVedio" style="left:22px;">
                            <OBJECT id="vlcVedio_2" width="448px" height="252px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                type="application/x-vlc-plugin" events="True">
                                <PARAM NAME="AutoLoop" VALUE="0">
                                <PARAM NAME="AutoPlay" VALUE="-1">
                                <PARAM NAME="Toolbar" VALUE="0">
                                <PARAM NAME="MRL" VALUE="">
                                <PARAM name="BackColor" value="0">
                                <PARAM name="fullscreen" value="true">
                            </OBJECT>
                        </div>
                    </div>
                    <div id="divVedio_3" style="width:470px;height:252px;left:10px;top:256px;" onclick="PointHelp(3);">
                        <p id="pPoint_3" class="PoinsName" style="left:3px;"><br/>核磁共振三室</p>
                        <div class="PoinsVedio" style="left:22px;">
                            <OBJECT id="vlcVedio_3" width="448px" height="252px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                type="application/x-vlc-plugin" events="True">
                                <PARAM NAME="AutoLoop" VALUE="0">
                                <PARAM NAME="AutoPlay" VALUE="-1">
                                <PARAM NAME="Toolbar" VALUE="0">
                                <PARAM NAME="MRL" VALUE="">
                                <PARAM name="BackColor" value="0">
                                <PARAM name="fullscreen" value="true">
                            </OBJECT>
                        </div>
                    </div>
                    <div id="divVedio_4" style="width:470px;height:252px;left:490px;top:256px;" onclick="PointHelp(4);">
                        <p id="pPoint_4" class="PoinsName" style="left:3px;"><br/>核磁共振四室</p>
                        <div class="PoinsVedio" style="left:22px;">
                            <OBJECT id="vlcVedio_4" width="448px" height="252px" classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codeBase="http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab"
                                type="application/x-vlc-plugin" events="True">
                                <PARAM NAME="AutoLoop" VALUE="0">
                                <PARAM NAME="AutoPlay" VALUE="-1">
                                <PARAM NAME="Toolbar" VALUE="0">
                                <PARAM NAME="MRL" VALUE="">
                                <PARAM name="BackColor" value="0">
                                <PARAM name="fullscreen" value="true">
                            </OBJECT>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <script>
            InitPage();
            disableTextSelection();
        </script>
    </body>
</html>
