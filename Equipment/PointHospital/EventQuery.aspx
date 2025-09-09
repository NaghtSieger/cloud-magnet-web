<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EventQuery.aspx.cs" Inherits="Equipment_PointHospital_EventQuery" %>

<!DOCTYPE html>

<html>
	<head>
		<title>EventQuery</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="../../Content/Hospital.css" type="text/css" rel="stylesheet" />
	    <link href="../../Content/disableSelect.css" type="text/css" rel="stylesheet" />
		<script src="../../Public/Function.js"></script>
		<script type="text/javascript">
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

		    function PlayHistory(sUrl)
		    {

		    }

		    function PalyVedioHis(sUrl)
		    {
		        window.parent.PlayHistory(sUrl);
		    }

		    function InitPage()
		    {
		        var vItem = document.getElementById("iPage");
                if (vItem != null)
                    vItem.value = "1";
                PalyVedioHis("../../Images/Demo.mp4");
		    }
        </script>
    </head>
    <body>
        <form id="form1" runat="server">
			<input id="workflag" type="hidden" name="workflag" runat="server"> <input id="hPage" type="hidden" name="hPage" value="0" runat="server"> <input id="hSource" type="hidden" name="hSource" value="0" runat="server">
			<div style="HEIGHT: 367px; WIDTH: 640px;">
                <div id="vhList" runat="server" style="width:638px;">
					<table style="width:638px;text-align:center;margin:0;border-collapse:collapse;" border="1">
						<tr style="height:30px;">
							<td style="width: 60px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">序号</p></td>
							<td style="width:265px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">报警时间</p></td>
							<td style="width: 80px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">报警等级</p></td>
							<td style="width:230px;"><P style="position:static;font-size:12pt;font-family:仿宋_GB2312,Times New Roman;margin:0;">操作</p></td>
						</tr>
					</table>
                </div>
                <div style="POSITION: absolute; width:636px;left:25px;top:335px;">
                    <p class="ConditionText" style="left: 10px;">共有记录<input id="iTotal" runat="server" style="text-align:center;border:0;width:20px;" readonly="readonly" type="text"/>条</p>
                    <p class="ConditionText" style="left: 200px;""><input type="button" value="首&nbsp;&nbsp;页" onclick="First();"/></p>
                    <p class="ConditionText" style="left: 284px;""><input type="button" value="上一页" onclick="Pre();"/></p>
                    <p class="ConditionText" style="left: 368px;""><input type="button" value="下一页" onclick="Next();"/></p>
                    <p class="ConditionText" style="left: 520px;"><input id="iPage" value="1"  style="text-align:center;width:20px;" type="text"/>/<input id="iPages" runat="server" style="text-align:center;border:0;width:20px;" readonly="readonly" type="text"/><input type="button" value="转页" onclick="Jump();" /></p>
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
