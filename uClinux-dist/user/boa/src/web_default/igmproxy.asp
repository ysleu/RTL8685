<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("IGMP Proxy"); %><% multilang(" Configuration"); %></title>
<SCRIPT>
function proxySelection()
{
	if (document.igmp.proxy[0].checked) {
		document.igmp.proxy_if.disabled = true;
	}
	else {
		document.igmp.proxy_if.disabled = false;
	}
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("IGMP Proxy"); %><% multilang(" Configuration"); %></font></h2>

<form action=/boaform/formIgmproxy method=POST name="igmp">
<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("IGMP proxy enables the system to issue IGMP host messages on behalf of hosts that the system discovered through standard IGMP interfaces. The system acts as a proxy for its hosts when you enable it by doing the follows"); %>:
    <br>. <% multilang("Enable IGMP proxy on WAN interface (upstream), which connects to a router running IGMP."); %>
    <br>. <% multilang("Enable IGMP on LAN interface (downstream), which connects to its hosts."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

  <tr>
      <td width><font size=2><b><% multilang("IGMP Proxy"); %>:</b></td>
      <td width><font size=2>
      	<input type="radio" value="0" name="proxy" <% checkWrite("igmpProxy0"); %> onClick="proxySelection()"><% multilang("Disable"); %>&nbsp;&nbsp;
     	<input type="radio" value="1" name="proxy" <% checkWrite("igmpProxy1"); %> onClick="proxySelection()"><% multilang("Enable"); %>
      </td>
  </tr>
  <tr>
      <td><font size=2><b><% multilang("Proxy Interface"); %>:</b></td>
      <td>
      	<select name="proxy_if" <% checkWrite("igmpProxy0d"); %>>
          <% if_wan_list("rt"); %>
      	</select>
      </td>
      <td><input type="submit" value="<% multilang("Apply Changes"); %>" name="save">&nbsp;&nbsp;</td>
  </tr>
</table>
      <input type="hidden" value="/igmproxy.asp" name="submit-url">
<script>
	ifIdx = <% getInfo("igmp-proxy-itf"); %>;
	if (ifIdx != 255)
		document.igmp.proxy_if.value = ifIdx;
	else
		document.igmp.proxy_if.selectedIndex = 0;
	
</script>
</form>
</blockquote>
</body>

</html>
