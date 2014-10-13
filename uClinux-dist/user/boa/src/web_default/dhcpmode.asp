<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>DHCP <% multilang("Mode"); %><% multilang(" Configuration"); %></title>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">DHCP <% multilang("Mode"); %><% multilang(" Configuration"); %></font></h2>

<form action=/boaform/formDhcpMode method=POST name="dhcpmode">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to set and configure the Dynamic Host Configuration Protocol mode for your router. With DHCP, IP addresses for your LAN are administered and distributed as needed by this device or an ISP device."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>

  <tr>
      <td width="30%"><font size=2><b>DHCP <% multilang("Mode"); %>:</b>
      <select size="1" name="dhcpMode">
      <% checkWrite("dhcpMode"); %>
      </select>
      </td>
  </tr>
</table>
  <br>
      <input type="submit" value="<% multilang("Apply Changes"); %>" name="save"">&nbsp;&nbsp;
      <input type="hidden" value="/dhcpmode.asp" name="submit-url">
 </form>
</blockquote>
</body>

</html>


