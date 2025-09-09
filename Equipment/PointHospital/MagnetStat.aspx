<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MagnetStat.aspx.cs" Inherits="Equipment_PointHospital_MagnetStat" %>

<!DOCTYPE html>

<html>
	<head>
		<title>MagnetStat</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="../../Content/Hospital.css" type="text/css" rel="stylesheet" />
		<link href="../../Content/disableSelect.css" type="text/css" rel="stylesheet" />
		<script src="../../Public/Function.js"></script>
		<script type="text/javascript">
		    function Query()
		    {
		        form1.workflag.value = "STAT";
		        form1.submit();
		    }

		    function Jump()
		    {
		        var iOld = parseInt(GetHtmlValue("hPage", "V"));
		        var iNew = parseInt(GetHtmlValue("iPage", "V"));
		        var iTotal = parseInt(GetHtmlValue("iTotal", "V"));
		        var iRows = iTotal;
		        if (iOld != iNew)
		        {
		            var i = 0;
		            form1.hPage.value = iNew.toString();
		            if (iOld > 0)
		            {
		                iRows = iOld * 10;
		                if (iRows > iTotal)
		                    iRows = iTotal;
		                for (i = (iOld - 1) * 10 + 1;i < iRows + 1; i ++)
		                {
		                    var vItem = document.getElementById("vhRow" + i.toString());
		                    if (vItem != null)
		                        vItem.style.display = "none";

		                }
		            }
		            iRows = iNew * 10;
		            if (iRows > iTotal)
		                iRows = iTotal;
		            for (i = (iNew - 1) * 10 + 1; i < iRows + 1; i++)
		            {
		                var vItem = document.getElementById("vhRow" + i.toString());
		                if (vItem != null)
		                    vItem.style.display = "table-row";
		            }

		        }

		    }

		    function First()
		    {
		        var iPage = parseInt(GetHtmlValue("iPage", "V"));
		        if (iPage != 1)
		        {
		            var vItem = document.getElementById("iPage");
		            if (vItem != null)
		                vItem.value = "1";
		            Jump();

		        }
		    }

		    function Next()
		    {
		        var iPage = parseInt(GetHtmlValue("iPage", "V"));
		        var iPages = parseInt(GetHtmlValue("iPages", "V"));
		        if (iPage < iPages)
		        {
		            iPage ++;
		            var vItem = document.getElementById("iPage");
		            if (vItem != null)
		                vItem.value = iPage;
		            Jump();
                }

		    }

		    function Pre()
		    {
		        var iPage = parseInt(GetHtmlValue("iPage", "V"));
		        if (iPage > 1)
		        {
		            iPage --;
		            var vItem = document.getElementById("iPage");
		            if (vItem != null)
		                vItem.value = iPage;
		            Jump();

		        }
            }

		    function InitPage()
		    {
		        var vItem = document.getElementById("iPage");
                if (vItem != null)
                    vItem.value = "1";

                var sCondition = GetHtmlValue("dStart", "V") + "|" + GetHtmlValue("dEnd", "V");
                vItem = document.getElementById("iMagnetLine1");

                if (vItem != null)
                    vItem.src = "../../Public/DrawPicture.aspx?Type=11&Condi=" + sCondition + "&t=" + (new Date().getTime());
                vItem = document.getElementById("iMagnetPie1");

                if (vItem != null)
                    vItem.src = "../../Public/DrawPicture.aspx?Type=21&Condi=" + sCondition + "&t=" + (new Date().getTime());
                vItem = document.getElementById("ifMagnetEvent");
                if (vItem != null)
                    vItem.src = "MagnetEvent.aspx?Condi=" + sCondition + "&t=" + (new Date().getTime());
            }

        </script>
    </head>
    <body>
        <form id="form1" runat="server">
			<input id="workflag" type="hidden" name="workflag" runat="server"> <input id="hPage" type="hidden" name="hPage" value="0" runat="server">
			<div style="HEIGHT: 598px; WIDTH: 1280px;">
                <div class="PieceTop" style="width:530px;left:40px;top:30px;">
                    <p class="pTitle" style="width:530px;">检索管理</p>
                </div>
                <div class="PieceBottom" style="width:530px;height:512px;left:40px;top:60px;">
                    <div class="Condition" style="width:476px;left:25px;top:30px;">
                        <p class="ConditionText" style="left:10px;top:10px;">按条件检索</p>
                        <p class="ConditionText" style="left:10px;top:40px;">时间：<input id="dStart" runat="server" size="12" type="text" readonly="readonly" onfocus="Calendar(this,2);"/>至<input id="dEnd" runat="server" size="12" type="text" readonly="readonly" onfocus="Calendar(this,2);"/>
                        <p class="ConditionText" style="left:10px;top:70px;"><input  id="hDanger" runat="server" type="checkbox" checked/> 高风险&nbsp;&nbsp;<input id="mDanger"  runat="server" type="checkbox" checked/>中风险&nbsp;&nbsp;<input id="lDanger" runat="server" type="checkbox" checked/>低风险&nbsp;&nbsp;<input id="nDanger" runat="server" type="checkbox" checked/>无风险</p>
						<div class="PieButton" onclick="Query();" style="top:20px;left:300px;"><p class="ButtonText">数据检索</p></div>
                    </div>
                    <div id="vhList" runat="server" class="LVTable" style="width:478px;">
					    <table style="width:478px;text-align:center;margin:0;border-collapse:collapse;" border="1">
						    <tr style="height:30px;">
							    <td style="width: 60px;"><P style="font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">序号</p></td>
							    <td style="width:265px;"><P style="font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">报警时间</p></td>
							    <td style="width: 80px;"><P style="font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">报警等级</p></td>
							    <td style="width: 70px;"><P style="font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">操作</p></td>
						    </tr>
					    </table>
                    </div>
                     <div style="POSITION: absolute; width:476px;left:25px;top:480px;">
                        <p class="ConditionText" style="left: 2px;">共有记录<input id="iTotal" runat="server" style="text-align:center;border:0;width:20px;" readonly="readonly" type="text"/>条</p>
                        <p class="ConditionText" style="left: 120px;"><input type="button" value="首&nbsp;&nbsp;页" onclick="First();"/></p>
                        <p class="ConditionText" style="left: 200px;"><input type="button" value="上一页" onclick="Pre();"/></p>
                        <p class="ConditionText" style="left: 280px;"><input type="button" value="下一页" onclick="Next();"/></p>
                        <p class="ConditionText" style="left: 360px;"><input id="iPage" value="1"  style="text-align:center;width:20px;" type="text"/>/<input id="iPages" runat="server" style="text-align:center;border:0;width:20px;" readonly="readonly" type="text"/><input type="button" value="转页" onclick="Jump();" /></p>
                    </div>
               </div>
                <div class="PieceTop" style="width:630px;left:610px;top:30px;">
                    <p class="pTitle" style="width:630px;">警讯分析</p>
                </div>
                <div class="PieceBottom" style="width:630px;height:512px;left:610px;top:60px;">
                    <div class="MagnetLineY">报警次数</div>
					<div class="MagnetLine">
			            <img id="iMagnetLine1" class="MagnetLineI">
					</div>
                    <div class="MagnetLineX">时间</div>
					<div class="MagnetPie">
                        <img id="iMagnetPie1" class="MagnetPieI">
					</div>
                    <div class="MagnetPieX">
                    		<iframe id="ifMagnetEvent" class="MagnetPieI" src="MagnetEvent.aspx"></iframe>
                 	</div>
                </div>
            </div>
        </form>
		<script>
		    InitPage();
		    Jump();
		    disableTextSelection();
		</script>
    </body>
</html>