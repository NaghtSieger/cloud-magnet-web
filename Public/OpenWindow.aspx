<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OpenWindow.aspx.cs" Inherits="Public_OpenWindow" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title><%#strTitle%></title>
	    <link href="../Content/Hospital.css" type="text/css" rel="stylesheet" />
    </head>
    <body>
        <div style="width:100%;height:100%;">
            <iframe id="iWinOpen" style="width:100%;height:100%;border:0px;" src="<%#strInfo%>"></iframe>
        </div>
    </body>
</html>
