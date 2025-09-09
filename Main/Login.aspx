<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Main_Login" %>

<!DOCTYPE html>

<html>
	<head>
		<title>LogIn</title>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="../Content/Hospital.css" type="text/css" rel="stylesheet">
		<script src="../Public/Function.js"></script>
		<script type="text/javascript">


		    function KeyDown()
			{
				var keycode=event.keyCode;
				if (keycode==13)
				{
					event.keyCode=9;
				}			
			}
			
			// 用户验证 
			function ChkUser()
			{
			    if (IsNull("用户名", "txtLogName", true, "V") == 0)
					return;
			    form1.submit();
			}
			
			//支持回车
			function ChkUserKey()
			{
				var keycode=event.keyCode;
				if (keycode==13)
				    ChkUser();
				window.parent.parent.location.href = "";
			}		
			
			document.onkeydown= KeyDown;
		</script>
    </head>
    <body>
        <form id="form1" runat="server">
	        <div style="HEIGHT: 598px; WIDTH: 1280px;">
                <IMG style="position:absolute;top:180px;left:520px;height: 200px; WIDTH: 240px;" src="../Images/Hospital/Logo.png">
				<div class="Login">
					<p class="LoginText" style="top:40px;">用户名:</p>
					<p class="LoginText" style="top:90px;">口&nbsp;&nbsp;&nbsp;&nbsp;令:</p>
                    <input id="txtLogName" runat="server" class="LoginInp" style="top:40px;" autocomplete="on" maxlength="30"/>
                    <input id="txtPwd" runat="server" class="LoginInp" style="top:90px;" type="password" autocomplete="on" maxlength="30"/>
					<map name="FPMap0">
						<area tabIndex="3" onkeydown="ChkUserKey()" onclick="ChkUser();return false;" shape="CIRCLE" coords="40,40,36">
					</map>
					<IMG class="LoginImg" src="../images/UserLogin.jpg" useMap="#FPMap0" border="0">
				</div>
        </div>
        </form>
        <script>
            disableTextSelection();
        </script>
    </body>
</html>
