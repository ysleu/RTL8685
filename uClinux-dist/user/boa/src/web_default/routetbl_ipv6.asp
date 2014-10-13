<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("IP Route Table"); %></title>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("IPv6 Route Table"); %></font></h2>

<table border=0 width="480" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
  <% multilang("This table shows a list of destination routes commonly accessed by your network."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>


<form action=/boaform/formIPv6RefleshRouteTbl method=POST name="formIPv6RouteTbl">
<table border='1' width="80%">
<% routeIPv6List(); %>
</table>

<input type="hidden" value="/routetbl_ipv6.asp" name="submit-url">
  <p><input type="submit" value="<% multilang("Refresh"); %>" name="refresh">&nbsp;&nbsp;
  <input type="button" value="<% multilang("Close"); %>" name="close" onClick="javascript: window.close();"></p>
</form>
</blockquote>
</body>

</html>
