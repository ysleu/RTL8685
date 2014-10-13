<html>
<! Copyright (c) Realtek Semiconductor Corp., 2011. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Digital Media Server Settings"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script>
function dmsSelection()
{
	return true;
}
</script>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Digital Media Server Settings"); %></font></h2>
<form action=/boaform/formDMSConf method=POST name="formDMSconf">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to configure the parameters for your Digital Media Server."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr>
      <td width="40%"><font size=2><b><% multilang("Digital Media Server"); %>:</b></td>
      <td width="60%"><font size=2>
	      <input type="radio" name="enableDMS" value=0 <% fmDMS_checkWrite("fmDMS-enable-dis"); %> onClick="dmsSelection()" ><% multilang("Disable"); %>&nbsp;&nbsp;
	      <input type="radio" name="enableDMS" value=1 <% fmDMS_checkWrite("fmDMS-enable-en"); %>  onClick="dmsSelection()" ><% multilang("Enable"); %>
      </td>
  </tr>  
</table>
<br>
      <input type="submit" value="<% multilang("Apply Changes"); %>" name="apply">&nbsp;&nbsp;
      <!--<input type="reset" value="Undo" name="reset" onClick="window.location.reload()">-->
      <input type="hidden" value="/dms.asp" name="submit-url">
</form>
</blockquote>
</body>
</html>
