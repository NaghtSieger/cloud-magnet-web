<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SelectDay.aspx.cs" Inherits="Public_SelectDay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>SelectDay</title>
	<link href="../Content/Hospital.css" type="text/css" rel="stylesheet" />
    <script src="Function.js"></script>
    <script>
        function MouseClick(event) {
            SetHtmlValue("hY","V",event.clientY);
        }
        document.onclick = MouseClick;

        function GetValue() {
            var sValue = GetHtmlValue("hValue", "V");
            var sValue1 = GetHtmlValue("hValue1", "V");
            if (sValue == sValue1 && sValue != "")
            {
                window.parent.returnValue = sValue;
                window.parent.close();
            }
        };
    </script>
</head>
<body>
	<form id="Form1" method="post" runat="server" style="margin:0px;" autocomplete="on">
        <input id="hValue" type="hidden" name="hValue" runat="server" />
        <input id="hValue1" type="hidden" name="hValue1" runat="server" />
        <input id="hX" type="hidden" name="hX" runat="server" value="67" />
        <input id="hY" type="hidden" name="hY" runat="server" />

        <div style="width:224px;height:244px;margin:0px;left:20px;top:10px;">
	        <asp:Calendar ID="Calendar2" runat="server" BackColor="#FFFFCC" BorderColor="#FFCC66" BorderWidth="1px" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="#663399" Height="118px" ShowGridLines="True" Width="220px"  OnSelectionChanged="Calendar2_SelectionChanged">
                <DayHeaderStyle BackColor="#FFCC66" Font-Bold="True" Height="1px" />
                <NextPrevStyle Font-Size="19pt" ForeColor="#FFFFCC" />
                <OtherMonthDayStyle ForeColor="#CC9966" />
                <SelectedDayStyle BackColor="#CCCCFF" Font-Bold="True" />
                <SelectorStyle BackColor="#FFCC66" />
                <TitleStyle BackColor="#990000" Font-Bold="True" Font-Size="9pt" ForeColor="#FFFFCC" />
                <TodayDayStyle BackColor="#FFCC66" ForeColor="White" />
            </asp:Calendar>
        </div>
    </form>
    <script>
        GetValue();
    </script>
</body>
</html>
