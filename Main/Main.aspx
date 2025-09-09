<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="Main" %>

<!DOCTYPE html>

<html>
	<head>
		<title>Main</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="../Content/Hospital.css" type="text/css" rel="stylesheet">
		<script src="../Public/Function.js"></script>
		<script type="text/javascript">
		    function Jump(sUrl) {
		        var vItem = document.getElementById("ifPage");
		        if (vItem != null)
		            vItem.src = sUrl;
		    }

		</script>
    </head>
    <body>
        <form id="form1" runat="server">
	        <div style="HEIGHT: 598px; WIDTH: 1280px;">
                <div class="PieceTop" style="width:180px;left:40px;top:30px;">
                    <p class="pTitle" style="width:180px;">功能菜单</p>
                </div>
				<div id="dvMenu" runat="server" class="PieceBottom" style="width:180px;height:512px;left:40px;top:60px;overflow:auto;">

				</div>
				<div style="width:980px;height:598px;POSITION: absolute;left:260px;">
                    <iframe id="ifPage" class="SystemFrame" src="../Permission/PriConfig.aspx"></iframe>
				</div>
        </div>
        </form>
        <script>
            disableTextSelection();
        </script>
    </body>
</html>
