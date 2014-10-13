<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Device"); %> <% multilang("IP Range"); %><% multilang(" Table"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
var pool_ipprefix;
<% initPage("dhcp-iprange"); %>

function postsetting(devname,devicetype, startip, endip, gwip,option,optCode,optStr)
{
	document.ipRange.name.value = devname;
	document.ipRange.sIp.value = startip;
	document.ipRange.dIp.value = endip;
	document.ipRange.gwIp.value = gwip;
	document.ipRange.Opt60.value = option;
	document.ipRange.dhcpDeviceType.value = devicetype;
	
	deviceTypeSelect();	
	if(document.ipRange.dhcpDeviceType.selectedIndex==3) //STB
	{
		document.ipRange.OptStr240.value = optStr;
	}
	else if(document.ipRange.dhcpDeviceType.selectedIndex!=5) //PC Phone Camera HGW ...
	{
		document.ipRange.reservedOption.value = optCode;
		document.ipRange.OptStr.value = optStr;
	}
}

function checkInputIP(client)
{
	var pool_ip, mask;
	var i, mask_d, ip_d, pool_d;
	var pool_ip_d, client_d;
	
	if (pool_ipprefix) {
		pool_ip = document.ipRange.lan_ip.value;
		mask = document.ipRange.lan_mask.value;
	}
	else {
		pool_ip = document.ipRange.lan_dhcpRangeStart.value;
		mask = document.ipRange.lan_dhcpSubnetMask.value;
	}
	
	for( i=1;i<5;i++ ) {
		mask_d = getDigit(mask, i);
		pool_ip_d = getDigit(pool_ip, i);
		client_d = getDigit(client, i);

		if( (pool_ip_d & mask_d) != (client_d & mask_d ) ) {
			return false;
		}
	}
	
	if (pool_ipprefix) {
		if( (parseInt(document.ipRange.lan_dhcpRangeStart.value, 10) > client_d) ||
			(parseInt(document.ipRange.lan_dhcpRangeEnd.value, 10) < client_d) ) {
			return false;
		}
	}
		
	return true;
}

function deviceTypeSelect()
{
	if(document.ipRange.dhcpDeviceType.selectedIndex==3) //STB
	{
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('option240').style.display = 'block';
			document.getElementById('option241').style.display = 'none';
		}
		else {
			if (document.layers == false) // IE4
			{
				document.all.option240.style.display = 'block';
				document.all.option241.style.display = 'none';
			}
		}
	}
	else if(document.ipRange.dhcpDeviceType.selectedIndex==5)//Unkown 
	{
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('option240').style.display = 'none';
			document.getElementById('option241').style.display = 'none';
		}
		else {
			if (document.layers == false) // IE4
			{
				document.all.option240.style.display = 'none';
				document.all.option241.style.display = 'none';
			}
		}
	}
	else //other device
	{
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('option240').style.display = 'none';
			document.getElementById('option241').style.display = 'block';
		}
		else {
			if (document.layers == false) // IE4
			{
				document.all.option240.style.display = 'none';
				document.all.option241.style.display = 'block';
			}
		}
	}
}

function addClick() 
{
	if (document.ipRange.name.value=="") {
		alert("device name cannot be NULL!");
		document.ipRange.name.focus();
		return false;
	}
	
	if (checkString(document.ipRange.name.value) == 0) {
		alert('Invalid device name.');
		document.ipRange.name.focus();
		return false;
	}
	if (checkPrintableString(document.ipRange.Opt60.value) == 0) {
		alert('Invalid option60 string.');
		document.ipRange.Opt60.focus();
		return false;
	}
	if (checkPrintableString(document.ipRange.OptStr.value) == 0) {
		alert('Invalid option string.');
		document.ipRange.OptStr.focus();
		return false;
	}
	if (!checkHostIP(document.ipRange.sIp, 1)) {
		document.ipRange.sIp.focus();
		return false;
	}
	
	if (!checkHostIP(document.ipRange.dIp, 1)) {
		document.ipRange.dIp.focus();
		return false;
	}
	
	if (document.ipRange.Opt60.value=="") {
		alert("option60 cannot be NULL!");
		document.ipRange.Opt60.focus();
		return false;
	}

	if ( !checkInputIP(document.ipRange.sIp.value ) ) {
		alert('Invalid Source range of IP Address. It should be in IP pool range.');
		document.ipRange.sIp.focus();
		return false;
	}

	if ( !checkInputIP(document.ipRange.dIp.value ) ) {
		alert('Invalid Destination range of IP Address. It should be in IP pool range.');
		document.ipRange.dIp.focus();
		return false;
	}

	if(document.ipRange.dhcpDeviceType.selectedIndex==3) {
		if (document.ipRange.stbdns1.value == "") {
			alert("Enter STBs DNS value!");
			document.ipRange.stbdns1.focus();
			return false;
		}
		if  (!checkIP(document.ipRange.stbdns1)) {
			document.ipRange.stbdns1.focus();
			return false;
		}
		if (document.ipRange.stbdns2.value != "") {
			if  (!checkIP(document.ipRange.stbdns2)) {
				document.ipRange.stbdns2.focus();
				return false;
			}
		}
		if (document.ipRange.opchaddr.value == "") {
			alert("Enter STBs OPCH address value!");
			document.ipRange.opchaddr.focus();
			return false;
		}
		if  (!checkIP(document.ipRange.opchaddr)) {
			document.ipRange.opchaddr.focus();
			return false;
		}
		if (document.ipRange.opchport.value == "") {
			alert("Enter STBs OPCH port value!");
			document.ipRange.opchport.focus();
			return false;
		}
		if ( !checkDigitRange(document.ipRange.opchport.value,1,1,65535) ) {
		  	alert('Invalid opch port. It should be 1-65535.');
			document.ipRange.opchport.focus();
			return false;
		}
	}
	else if(document.ipRange.dhcpDeviceType.selectedIndex!=5)
	{
		if(document.ipRange.OptStr.value == "") {
			alert("Enter option string value!");
			document.ipRange.OptStr.focus();
			return false;
		}
	}
	return true;
}
	
</SCRIPT>
</head>


<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Device"); %> <% multilang("IP Range"); %><% multilang(" Table"); %></font></h2>

<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
 <% multilang("This page is used to configure the IP address range based on device type."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<form action=/boaform/formIpRange method=POST name="ipRange">

<input type="hidden" name="lan_ip" value=<% getInfo("dhcplan-ip"); %>>
<input type="hidden" name="lan_mask" value=<% getInfo("dhcplan-subnet"); %>>
<input type="hidden" name="lan_dhcpRangeStart" value=<% getInfo("lan-dhcpRangeStart"); %>>
<input type="hidden" name="lan_dhcpRangeEnd" value=<% getInfo("lan-dhcpRangeEnd"); %>>
<input type="hidden" name="lan_dhcpSubnetMask" value=<% getInfo("lan-dhcpSubnetMask"); %>>
<table class="flat" border="0" cellpadding="0" cellspacing="0" width=500>
<tr>
    <td width=30%><font size=2><% multilang("Device"); %><% multilang(" Name"); %>:&nbsp;&nbsp;</td>
    <td><input type="text" name="name" size="20" maxlength="20"></td>
</tr>
    <td><font size=2><% multilang("Start Address"); %>:&nbsp;&nbsp;</td>
    <td><input type="text" name="sIp" size="20" maxlength="15"></td>
</tr>
<tr>
    <td><font size=2><% multilang("End Address"); %>:&nbsp;&nbsp;</td>
    <td><input type="text" name="dIp" size="20" maxlength="15"></td>
</tr>
<tr>
    <td><font size=2><% multilang("Gateway address"); %>:&nbsp;&nbsp;</td>
    <td><input type="text" name="gwIp" size="20" maxlength="15"></td>
</tr>
<tr>
    <td><font size=2><% multilang("Option60"); %>:&nbsp;&nbsp;</td>
    <td><input type="text" name="Opt60" size="20" maxlength="100"></td>
</tr>
<!--<tr>
    <td><font size=2>STB:&nbsp;&nbsp;</td>
    <td><input type="checkbox" name="isSTB"  value="ON"></td>
</tr> -->
<tr>
	<td width=30%><font size=2><% multilang("Device Type"); %>:&nbsp;&nbsp;</td>
	<td><select size="1" name="dhcpDeviceType" onChange="deviceTypeSelect()">
		<option selected value=0><% multilang("PC"); %></option>
		<option value=1><% multilang("Camera"); %></option>
		<option value=2><% multilang("HGW"); %></option>
		<option value=3><% multilang("STB"); %></option>
		<option value=4><% multilang("Phone"); %></option>
		<option value=100><% multilang("Unknown"); %></option></select>
	</td>
</tr>
</table>

<div id="option241" style="display:block">
<table border=0 width="500" cellspacing=0 cellpadding=0>
	 <tr>
		<td width=30%><font size=2><% multilang("Reserved Option"); %>:&nbsp;&nbsp;</td>
		<td><select size="1" name="reservedOption">
			<option selected value=241>Option 241</option>
			<option value=242>Option 242</option>
			<option value=243>Option 243</option>
			<option value=244>Option 244</option>
			<option value=245>Option 245</option></select>
		</td>
	 </tr>
	 <tr>
		<td><font size=2><% multilang("Option String"); %></td>
		<td><input type="text" name="OptStr"  size="20" maxlength="100"></td>
	 </tr>
</table>
</div>

<div id="option240" style="display:none">
<table border=0 width="500" cellspacing=0 cellpadding=0>	
	<tr>
		<td width=30%><font size=2><% multilang("reserved option"); %>:&nbsp;&nbsp;</td>
		<td><input type="text" name="reservedOption240"  size="20" maxlength="20" value="Option 240" readonly></td>
	 </tr>
	 <tr>
		<td><font size=2><% multilang("option string"); %>:&nbsp;&nbsp;</td>
		<td><input type="text" name="OptStr240"  size="20" maxlength="100"></td>
	 </tr>
	 
	 <tr>
	 	<td><font size=2><% multilang("DNS1"); %>:</td>
	 	<td><input type="text" name="stbdns1" value=<% getInfo("stb-dns1"); %>></td>
	 </tr>
	 <tr>
	 	<td><font size=2><% multilang("DNS2"); %>:</td>
	 	<td><input type="text" name="stbdns2" value=<% getInfo("stb-dns2"); %>></td>
	 </tr>
</table>
</div>

<input type="submit" value="<% multilang("Add"); %>" name="add" onClick="return addClick()">&nbsp;&nbsp;
<input type="submit" value="<% multilang("Delete"); %>" name="del">&nbsp;&nbsp;
<input type="submit" value="<% multilang("Modify"); %>" name="mod" onClick="return addClick()">&nbsp;&nbsp
<input type="hidden" value="/devicetbl.asp" name="submit-url">
<input type="button" value="<% multilang("Close"); %>" name="close" onClick="javascript: window.close();">

<p>
<tr><hr size=1 noshade align=top></tr>
<table border=0 width="500" cellspacing=4 cellpadding=0>
<tr><font size=2><b><% multilang("Device"); %> <% multilang("IP Range"); %><% multilang(" Table"); %>:</b></font></tr>
    <% showDeviceIpTable(); %>
</table>

<script>
</script>
</form>
</blockquote>
</body>

</html>
