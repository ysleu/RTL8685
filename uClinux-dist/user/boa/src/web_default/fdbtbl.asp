<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Bridge Forwarding Database"); %></title>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Bridge Forwarding Database"); %></font></h2>

<table border=0 width="480" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
  <% multilang("This table shows a list of learned MAC addresses for this bridge."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>


<form action=/boaform/formRefleshFdbTbl method=POST name="formFdbTbl">
<table border='1' width="80%">
<tr bgcolor=#7f7f7f> <td width="10%"><font size=2><b><% multilang("Port No"); %></b></td>
<td width="20%"><font size=2><b><% multilang("MAC Address"); %></b></td>
<td width="10%"><font size=2><b><% multilang("Is Local"); %>?</b></td>
<td width="10%"><font size=2><b><% multilang("Ageing Timer"); %></b></td></tr>
<% bridgeFdbList(); %>
</table>

<input type="hidden" value="/fdbtbl.asp" name="submit-url">
  <p><input type="submit" value="<% multilang("Refresh"); %>" name="refresh">&nbsp;&nbsp;
  <input type="button" value="<% multilang("Close"); %>" name="close" onClick="javascript: window.close();"></p>
</form>
</blockquote>
</body>

</html>
