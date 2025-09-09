<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title></title>
		<link href="Content/Hospital.css" type="text/css" rel="stylesheet" />
		<script src="Public/Function.js"></script>
		<script type="text/javascript">
        </script>
    </head>
    <body>
        <form id="form1" runat="server">
            <div style="HEIGHT: 85px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; Z-INDEX: -1; TOP: 0px; background-color:#AAC3E1">
                <p id="pPoint" runat="server" style="LEFT: 60px; TOP: 46px;FONT-SIZE: 16pt;FONT-FAMILY: 楷体_GB2312;">南京市鼓楼医院 核磁共振一室</p>
                <p style="WIDTH: 1280px; TOP: 25px;FONT-SIZE: 24pt; FONT-FAMILY: 黑体;text-align:center;">磁共振室安全云平台</p>
                <p id="pHeart" style="LEFT: 1060px; TOP: 48px;FONT-SIZE: 12pt;FONT-FAMILY: 楷体_GB2312">2023年11月10日 14:49:49</p>
            </div>
            <div style="HEIGHT: 598px; WIDTH: 1280px; POSITION: absolute; LEFT: 0px; Z-INDEX: -1; TOP: 85px; background-color:#415594">
                <div id="dManager" class="Middle">
                    <iframe id="ifManager" class="MiddleFrame" src="Main/Login.aspx"></iframe>
                </div>
            </div>
        </form>
        <script>
            disableTextSelection();
        </script>
    </body>
</html>
