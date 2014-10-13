<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>IPv6 <% multilang("Status"); %></title>
<script type="text/javascript" src="share.js">
</script>
</head>
<body>
<blockquote>

<h2><b><font color="#0000FF">IPv6 <% multilang("Status"); %></font></b></h2>

<table border=0 width="500" cellspacing=0 cellpadding=0>
<tr><td><font size=2>
 <% multilang("This page shows the current system status of IPv6."); %>
</font></td></tr>

<tr><td><hr size=1 noshade align=top><br></td></tr>
</table>

<table width=400 border=0>
  <tr>
    <td width=100% colspan="2" bgcolor="#008000"><font color="#FFFFFF" size=2><b><% multilang("LAN"); %><% multilang(" Configuration"); %></b></font></td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("IPv6 Address"); %></b></td>
    <td width=60%><font size=2><% getInfo("ip6_global"); %></td>
  </tr>
  <tr bgcolor="#DDDDDD">
    <td width=40%><font size=2><b><% multilang("IPv6 Link-Local Address"); %></b></td>
    <td width=60%><font size=2><% getInfo("ip6_ll"); %></td>
  </tr>
</table>
<br>
<table width=400 border=0>
  <tr>
    <td width=100% colspan="2" bgcolor="#008000"><font color="#FFFFFF" size=2><b><% multilang("Prefix Delegation"); %></b></font></td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Prefix"); %></b></td>
    <td width=60%><font size=2><% checkWrite("prefix_delegation_info"); %></td>
  </tr>
</table>
<br>
<form action=/boaform/admin/formStatus_ipv6 method=POST name="status_ipv6">
<table width=600 border=0>
 <tr>
    <td width=100% colspan=6 bgcolor="#008000"><font color="#FFFFFF" size=2><b><% multilang("WAN"); %><% multilang(" Configuration"); %></b></font></td>
  </tr>
  <% wanip6ConfList(); %>
</table>
  <input type="hidden" value="/admin/status_ipv6.asp" name="submit-url">
  <input type="submit" value="Refresh" name="refresh">&nbsp;&nbsp;
</form>
</blockquote>
</body>
</html>
