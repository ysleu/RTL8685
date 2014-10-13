<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Active WLAN Clients"); %></title>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Active WLAN Clients"); %></font></h2>


<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
 <% multilang("This table shows the MAC address, transmission, reception packet counters and encrypted status for each associated WLAN clients."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<form action=/boaform/admin/formWirelessTbl method=POST name="formWirelessTbl">
<table border='1' width="500">
<tr bgcolor=#7f7f7f><td width="25%"><font size=2><b><% multilang("MAC Address"); %></b></td>
<td width="15%"><font size=2><b><% multilang("Tx Packets"); %></b></td>
<td width="15%"><font size=2><b><% multilang("Rx Packets"); %></b></td>
<td width="15%"><font size=2><b><% multilang("Tx Rate (Mbps)"); %></b></td>
<td width="15%"><font size=2><b><% multilang("Power Saving"); %></b></td>
<td width="15%"><font size=2><b><% multilang("Expired Time (sec)"); %></b></td></tr>
<% wirelessClientList(); %>
</table>
<input type="hidden" name="wlan_idx" value=<% checkWrite("wlan_idx"); %>>
<input type="hidden" value="/admin/wlstatbl.asp" name="submit-url">
  <p><input type="submit" value="Refresh" name="refresh">&nbsp;&nbsp;
  <input type="button" value=" Close " name="close" onClick="javascript: window.close();"></p>
</form>
</blockquote>
</body>

</html>
