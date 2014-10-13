<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>UPnP <% multilang("Configuration"); %></title>
<SCRIPT>
function proxySelection()
{
	if (document.upnp.daemon[0].checked) {
		document.upnp.ext_if.disabled = true;

		if(typeof(document.upnp.tr_064_sw) != "undefined")
		{
			document.upnp.tr_064_sw[0].disabled = true;
			document.upnp.tr_064_sw[1].disabled = true;
		}
	}
	else {
		document.upnp.ext_if.disabled = false;

		if(typeof(document.upnp.tr_064_sw) != "undefined")
		{
			document.upnp.tr_064_sw[0].disabled = false;
			document.upnp.tr_064_sw[1].disabled = false;
		}
	}
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2 style="color:#0000FF">UPnP <% multilang("Configuration"); %></h2>

<form action=/boaform/formUpnp method=POST name="upnp">
<table border=0 width="500" cellspacing=4 cellpadding=4 style="font-size: 13">
  <tr>
  	<td>
  		<% multilang("This page is used to configure UPnP. The system acts as a daemon when you enable it and select WAN interface (upstream) that will use UPnP."); %>
	  </td>
  </tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=4 style="font-size: 13">
	<tr>
		<td><b><% multilang("UPnP"); %>:</b></td>
		<td>
			<input type="radio" value="0" name="daemon" <% checkWrite("upnp0"); %> onClick="proxySelection()"><% multilang("Disable"); %>&nbsp;&nbsp;
			<input type="radio" value="1" name="daemon" <% checkWrite("upnp1"); %> onClick="proxySelection()"><% multilang("Enable"); %>
		</td>
	</tr>
	<% checkWrite("tr064_switch"); %>
	<tr>
		<td><b><% multilang("WAN Interface"); %>:</b></td>
		<td>
			<select name="ext_if" <% checkWrite("upnp0d"); %>>
				<% if_wan_list("rt"); %>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<input type="submit" value="<% multilang("Apply Changes"); %>" name="save">
		</td>
	</tr>
</table>
<input type="hidden" value="/upnp.asp" name="submit-url">
<script>
	initUpnpDisable = document.upnp.daemon[0].checked;
	ifIdx = <% getInfo("upnp-ext-itf"); %>;
	document.upnp.ext_if.selectedIndex = -1;

	for( i = 0; i < document.upnp.ext_if.options.length; i++ )
	{
		if( ifIdx == document.upnp.ext_if.options[i].value )
			document.upnp.ext_if.selectedIndex = i;
	}

	proxySelection();
</script>
</form>
</blockquote>
</body>

</html>
