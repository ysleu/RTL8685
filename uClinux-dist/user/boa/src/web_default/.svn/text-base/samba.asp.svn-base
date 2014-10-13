<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>Samba<% multilang(" Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script language="javascript">
var nbn = "<% getInfo("samba-netbios-name"); %>";
var ss = "<% getInfo("samba-server-string"); %>";

function changeSambaCap()
{
	with (document.formSamba) {
		if (sambaCap[0].checked) {
			/* Disable */
			netBIOSName.value = "";
			serverString.value = "";
			changeBlockState("conf", true);
		} else {
			/* Enable */
			netBIOSName.value = nbn;
			serverString.value = ss;
			changeBlockState("conf", false);
		}
	}
}
</script>
</head>

<body onLoad="changeSambaCap();">
<blockquote>
<h2><font color="#0000FF">Samba<% multilang(" Configuration"); %></font></h2>

<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr><td><font size=2>
	<% multilang("This page let user to config Samba."); %>
	</font></td></tr>
	<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<form action=/boaform/formSamba method=post name="formSamba">
<table>
	<tr>
	<td><font size=2><b>Samba&nbsp;:</b></font></td>
	<td><font size=2>
		<input type="radio" value="0" name="sambaCap" onClick="changeSambaCap();" <% checkWrite("samba-cap0"); %>><% multilang("Disable"); %>&nbsp;&nbsp;
		<input type="radio" value="1" name="sambaCap" onClick="changeSambaCap();" <% checkWrite("samba-cap1"); %>><% multilang("Enable"); %>
	</font></td>
	</tr>
<tbody id="conf">
	<tr <% checkWrite("nmbd-cap"); %>>
	<td><font size=2><b>NetBIOS <% multilang("Name"); %>&nbsp;:</b></font></td>
	<td><font size=2><input type="text" name="netBIOSName" maxlength="15"></font><td>
	</tr>

	<tr>
	<td><font size=2><b><% multilang("Server String"); %>&nbsp;:</b></font></td>
	<td><font size=2><input type="text" name="serverString" maxlength="31"></font></td>
	</tr>
</tbody>
</table>
<br>
<input type="submit" value="<% multilang("Apply Changes"); %>" name="apply">&nbsp;&nbsp;
<input type="hidden" value="/samba.asp" name="submit-url"> 

</form>
</blockquote>
</body>
</html>
