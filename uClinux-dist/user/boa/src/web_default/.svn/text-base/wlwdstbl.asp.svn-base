<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>WDS AP <% multilang("Table"); %></title>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">WDS AP <% multilang("Table"); %></font></h2>


<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
 <% multilang("This table shows the MAC address, transmission, reception packet counters and state information for each configured WDS AP."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<form action=/boaform/formWirelessTbl method=POST name="formWirelessTbl">
<table border='1' width="500">
<tr bgcolor=#7f7f7f><td width="30%"><font size=2><b><% multilang("MAC Address"); %></b></td>
<td width="15%"><font size=2><b><% multilang("Tx Packets"); %></b></td>
<td width="15%"><font size=2><b><% multilang("Tx Errors"); %></b></td>
<td width="15%"><font size=2><b><% multilang("Rx Packets"); %></b></td>
<td width="25%"><font size=2><b><% multilang("Tx Rate (Mbps)"); %></b></td></tr>
<% wdsList(); %>
</table>

<input type="hidden" name="wlan_idx" value=<% checkWrite("wlan_idx"); %>>
<input type="hidden" value="/wlwdstbl.asp" name="submit-url">
  <p><input type="submit" value="<% multilang("Refresh"); %>" name="refresh">&nbsp;&nbsp;
  <input type="button" value="<% multilang("Close"); %>" name="close" onClick="javascript: window.close();"></p>
</form>
</blockquote>
</body>

</html>
