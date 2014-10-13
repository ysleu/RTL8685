<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>ALG <% multilang("On-Off"); %><% multilang(" Configuration"); %></title>
<script>
	function AlgTypeStatus()
	{
		<% checkWrite("AlgTypeStatus"); %>
		return true;
	}
</script>
</head>

<body >
<blockquote>
<h2><font color="#0000FF">ALG <% multilang("On-Off"); %><% multilang(" Configuration"); %></font></h2>

<table border=0 width=500 cellspacing=4 cellpadding=0>
<tr><td colspan=4><font size=2>
	<% multilang("This page is used to enable/disable ALG services."); %>
	<br>
 </font></td></tr>
 <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table  width=500>
<form action=/boaform/formALGOnOff method=POST name=algof>
<table>
<tr>
<td><font size=2>ALG <% multilang("Type"); %>:</font></td>
<td colspan="2">	
</td>
</tr>
<% checkWrite("GetAlgType"); %>	
<tr>
	<td ><input type=submit value="<% multilang("Apply Changes"); %>" name=apply></td>
  <td> <input type="hidden" value="/algonoff.asp" name="submit-url"></td>
  <td></td>
</tr>
</table>
</form>
<script>
AlgTypeStatus();
</script>
</table>
</blockquote>
</body>
</html>
