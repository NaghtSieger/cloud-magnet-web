<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DataStat.aspx.cs" Inherits="Stat_DataStat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title></title>
		<link href="../Content/Hospital.css" type="text/css" rel="stylesheet" />
		<script src="../Public/Function.js"></script>
		<script type="text/javascript">
		    function Query() {
		        SetHtmlValue("workflag", "V", "STAT");
		        form1.submit();
		    }

		    function Export()
		    {
		        var sFile = GetHtmlValue("hValue", "V");
		        if (sFile != "")
		            saveFile(GetHtmlValue("vhList", "H"), sFile + ".xls");
		    }

		    function Print() {
		        var old_str = document.body.innerHTML; //获得原本页面的代码
		        document.body.innerHTML = GetHtmlValue("vhList", "H"); //构建新网页 
		        window.print(); //打印刚才新建的网页
		        document.body.innerHTML = old_str;

                /*
		        var sContext = GetHtmlValue("vhList", "H");
		        if (sContext != "")
		            PrintHtml(sContext);
                */
		    }

        </script>
    </head>
    <body>
        <form id="form1" runat="server">
			<input id="workflag" type="hidden" name="workflag" runat="server" />  <input id="hValue" type="hidden" name="hValue" runat="server" />
            <div style="HEIGHT: 598px; WIDTH: 980px;">
                <div class="PieceTop" style="width:980px;top:30px;">
                    <p class="pTitle" style="width:980px;">数据分析</p>
					<p class="pOperate" style="left:800px;"><asp:label id="lbOperate" runat="Server" Width="100%"></asp:label></p>
                </div>
                <div class="PieceBottom" style="width:980px;height:512px;top:60px;">
                    <div class="Condition" style="width:940px;left:20px;top:30px;">
                        <p class="DataTile" style ="top:20px;">统计报表</p>
                        <asp:dropdownlist id="drpReport" AutoPostBack="True" style="position:absolute;width:405px;height:25px;left:80px;top:15px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server"></asp:dropdownlist>
                        <p class="DataTile" style ="top:55px;">统计单位</p>
                        <asp:dropdownlist id="drpDepartment" AutoPostBack="True" style="position:absolute;width:405px;height:25px;left:80px;top:50px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server" OnSelectedIndexChanged="drpDepartment_SelectedIndexChanged"></asp:dropdownlist>
                        <p class="DataTile" style ="left:480px;top:20px;">统计时间</p>
                        <input id="dStart" class="DataText" style ="width:100px;left:560px;top:15px;" runat="server" readonly="readonly" onfocus="Calendar(this,1);" />
                        <p class="DataTile" style ="width:10px;left:670px;top:15px;">至</p>
                        <input id="dEnd"  class="DataText" style ="width:100px;left:690px;top:15px;" runat="server" readonly="readonly" onfocus="Calendar(this,1);" />
                        <p class="DataTile" style ="left:480px;top:55px;">统计点位</p>
                        <asp:dropdownlist id="drpPoint" style="position:absolute;width:235px;height:25px;left:560px;top:50px;font-family:仿宋_GB2312,Times New Roman;font-size:12pt;z-index:1" runat="server"></asp:dropdownlist>
						<div class="PieButton" onclick="Query();" style="top:20px;left:805px;"><p class="ButtonText">数据分析</p></div>
						<div class="PieButton" onclick="Print();" style="top:20px;left:870px;"><p class="ButtonText">打印导出</p></div>
                    </div>
                    <div id="vhList" runat="server" class="LVTable" style="width:930px;height:360px;overflow:auto;">

                    </div>
                </div>
            </div>
        </form>
    </body>
</html>
