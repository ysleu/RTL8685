<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<META HTTP-EQUIV=Refresh CONTENT="10; URL=status.asp">
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Router Status"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script>
var getObj = null;
function modifyClick(url)
{
	var wide=600;
	var high=400;
	if (document.all)
		var xMax = screen.width, yMax = screen.height;
	else if (document.layers)
		var xMax = window.outerWidth, yMax = window.outerHeight;
	else
	   var xMax = 640, yMax=480;
	var xOffset = (xMax - wide)/2;
	var yOffset = (yMax - high)/3;

	var settings = 'width='+wide+',height='+high+',screenX='+xOffset+',screenY='+yOffset+',top='+yOffset+',left='+xOffset+', resizable=yes, toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes';

	window.open( url, 'Status_Modify', settings );
}

function disButton(id)
{
       getObj = document.getElementById(id);

       window.setTimeout("getObj.disabled=true", 100);
	return false;
}

function on_init()
{
	// Mason Yu for IPv6
	if (!<% checkWrite("IPv6Show"); %>) {
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('ipv6DefaultGW').style.display = 'none';
		}
		else {
			if (document.layers == false) // IE4
			{
				document.all.ipv6DefaultGW.style.display = 'none';
			}
		}
	}
	return true;
}
</script>
</head>
<body onLoad="on_init();">
<blockquote>

<h2><b><font color="#0000FF"><% multilang("Router Status"); %></font></b></h2>

<table border=0 width="500" cellspacing=0 cellpadding=0>
<tr><td><font size=2>
 <% multilang("This page shows the current status and some basic settings of the device."); %>
</font></td></tr>

<tr><td><hr size=1 noshade align=top><br></td></tr>
</table>

<form action=/boaform/admin/formStatus method=POST name="status2">
<table width=400 border=0>
  <tr>
    <td width=100% colspan="2" bgcolor="#008000"><font color="#FFFFFF" size=2><b><% multilang("System"); %></b></font></td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Alias"); %><% multilang(" Name"); %></b></td>
    <td width=60%><font size=2><% getInfo("name"); %></td>
  </tr>
  <tr bgcolor="#DDDDDD">
    <td width=40%><font size=2><b><% multilang("Uptime"); %></b></td>
    <td width=60%><font size=2><% getInfo("uptime"); %></td>
  </tr>
<!--
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Date"); %>/<% multilang("Time"); %></b></td>
    <td width=60%><font size=2><% getInfo("date"); %></td>
  </tr>
-->
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Firmware Version"); %></b></td>
    <td width=60%><font size=2><% getInfo("fwVersion"); %></td>
  </tr>
<% DSLVer(); %>
   <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Name Servers"); %></b></td>
    <td width=60%><font size=2><% getNameServer(); %></td>
  </tr>
  <tr bgcolor="#DDDDDD">
    <td width=40%><font size=2><b>IPv4 <% multilang("Default Gateway"); %></b></td>
    <td width=60%><font size=2><% getDefaultGW(); %></td>
  </tr>
  <tr id='ipv6DefaultGW' bgcolor="#EEEEEE">
    <td width=40%><font size=2><b>IPv6 <% multilang("Default Gateway"); %></b></td>
    <td width=60%><font size=2><% getDefaultGW_ipv6(); %></td>
  </tr>
</table>

<table width=400 border=0>
	<!--
  <tr>
    <td width=100% colspan="2" bgcolor="#008000"><font color="#FFFFFF" size=2><b><% multilang("ADSL"); %></b></font></td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Operational Status"); %></b></td>
    <td width=60%><font size=2><% getInfo("dslstate"); %></td>
  </tr>
  <tr bgcolor="#DDDDDD">
    <td width=40%><font size=2><b><% multilang("Upstream Speed"); %></b></td>
    <td width=60%><font size=2><% getInfo("adsl-drv-rate-us"); %>&nbsp;kbps
       &nbsp;</td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Downstream Speed"); %></b></td>
    <td width=60%><font size=2><% getInfo("adsl-drv-rate-ds"); %>&nbsp;kbps
       &nbsp;</td>
  </tr>
  -->
  <% DSLStatus(); %>
  <tr>
    <td width=100% colspan="2" bgcolor="#008000"><font color="#FFFFFF" size=2><b><% multilang("LAN"); %><% multilang("Configuration"); %></b></font></td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("IP Address"); %></b></td>
    <td width=60%><font size=2><% getInfo("lan-ip"); %></td>
  </tr>
  <tr bgcolor="#DDDDDD">
    <td width=40%><font size=2><b><% multilang("Subnet Mask"); %></b></td>
    <td width=60%><font size=2><% getInfo("lan-subnet"); %></td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b>DHCP <% multilang("Server"); %></b></td>
    <td width=60%><font size=2>
      <% checkWrite("lan-dhcp-st"); %>
    </td>
  </tr>
  <tr bgcolor="#DDDDDD">
    <td width=40%><font size=2><b><% multilang("MAC Address"); %></b></td>
    <td width=60%><font size=2><% getInfo("elan-Mac"); %></td>
  </tr>
</table>
</form>
<br>
<form action=/boaform/admin/formStatus method=POST name="status">
<table width=600 border=0>
 <tr>
    <td width=100% colspan=7 bgcolor="#008000"><font color="#FFFFFF" size=2><b><% multilang("WAN"); %><% multilang("Configuration"); %></b></font></td>
  </tr>
  <% wanConfList(); %>
</table>
  <% wan3GTable(); %>
  <% wanPPTPTable(); %>
  <% wanL2TPTable(); %>
  <% wanIPIPTable(); %>
  <input type="hidden" value="/admin/status.asp" name="submit-url">
  <input type="submit" value="Refresh" name="refresh">&nbsp;&nbsp;
  <!--
  <input type="button" value="Modify" name="modify" onClick="modifyClick('/admin/date.asp')">
  -->
</form>

</blockquote>

</body>

</html>
