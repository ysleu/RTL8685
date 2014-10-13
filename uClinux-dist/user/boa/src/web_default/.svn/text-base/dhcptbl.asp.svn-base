<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Active DHCP Clients"); %></title>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Active DHCP Clients"); %></font></h2>

<table border=0 width="480" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
  <% multilang("This table shows the assigned IP address, MAC address and time expired for each DHCP leased client."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>


<form action=/boaform/formReflashClientTbl method=POST name="formClientTbl">
<table border='1' width="80%">
<tr bgcolor=#7f7f7f> <td width="30%"><font size=2><b><% multilang("IP Address"); %></b></td>
<td width="40%"><font size=2><b><% multilang("MAC Address"); %></b></td>
<td width="30%"><font size=2><b><% multilang("Expired Time (sec)"); %></b></td></tr>
<% dhcpClientList(); %>
</table>

<input type="hidden" value="/dhcptbl.asp" name="submit-url">
  <p><input type="submit" value="<% multilang("Refresh"); %>" name="refresh">&nbsp;&nbsp;
  <input type="button" value="<% multilang("Close"); %>" name="close" onClick="javascript: window.close();"></p>
</form>
</blockquote>
</body>

</html>
