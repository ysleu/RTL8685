<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("MAC-Based Assignment"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
var pool_ipprefix;

function checkInputIP(client)
{
	var pool_ip, pool_ipstart, pool_ipend, mask;
	var i, mask_d, pool_start_d, pool_end_d;
	
	if (pool_ipprefix) {
		pool_ip = document.macBase.lan_ip.value;
		mask = document.macBase.lan_mask.value;
	}
	else {
		pool_ipstart = document.macBase.lan_dhcpRangeStart.value;
		pool_ipend = document.macBase.lan_dhcpRangeEnd.value;
		mask = document.macBase.lan_dhcpSubnetMask.value;
	}
	
	for( i=1;i<5;i++ ) {
		mask_d = getDigit(mask, i);
		pool_start_d = getDigit(pool_ipstart, i);
		pool_end_d = getDigit(pool_ipend, i);
		client_d = getDigit(client, i);
	
		if( (pool_start_d & mask_d) != (client_d & mask_d ) ) {
			return false;
		}
		if (client_d < pool_start_d || client_d > pool_end_d)
			return false;
	}
	
	if (pool_ipprefix) {
		if( (parseInt(document.macBase.lan_dhcpRangeStart.value, 10) > client_d) ||
			(parseInt(document.macBase.lan_dhcpRangeEnd.value, 10) < client_d) ) {
			return false;
		}
	}
	
	return true;
}

function addClick()
{
	var str = document.macBase.hostMac.value;
	var macdigit = 0;

  	if ( str.length != 17) {
		alert("Input Host MAC address is not complete. It should be 17 digits in hex.");
		document.macBase.hostMac.focus();
		return false;
  	}	
 	
	if (document.macBase.hostMac.value=="") {
		alert("Enter Host MAC Addres !");
		document.macBase.hostMac.focus();
		return false;
	}
	
	for (var i=0; i<str.length; i++) {
		if ((str.charAt(i) == 'f') || (str.charAt(i) == 'F'))
			macdigit ++;
		else
			continue;
	}
	if (macdigit == 12 || str == "00-00-00-00-00-00") {
		alert("Invalid MAC address.");
		document.macBase.hostMac.focus();
		return false;
	}

	if (!checkHostIP(document.macBase.hostIp, 1))
		return false;
	
	if ( validateKey2( document.macBase.hostMac.value ) == 0 ) {
		alert("Invalid Host MAC Address. It should be in hex number (0-9 or a-f or A-F)");
		document.macBase.hostMac.focus();
		return false;
	}

	//cathy, for  bug B017
	if ( !checkInputIP(document.macBase.hostIp.value ) ) {
		alert('Invalid IP Address. It should be in IP pool range.');
		document.macBase.hostIp.focus();
		return false;
	}
	
	if ( !checkDigitRangeforMac(document.macBase.hostMac.value,1,0,255) ) {
		alert('Invalid Source range in 1st hex number of Host MAC Address. It should be 0x00-0xff.');
		document.macBase.hostMac.focus();
		return false;
	}
	
	if ( !checkDigitRangeforMac(document.macBase.hostMac.value,2,0,255) ) {
		alert('Invalid Source range in 2nd hex number of Host MAC Address. It should be 0x00-0xff.');
		document.macBase.hostMac.focus();
		return false;
	}
	
	if ( !checkDigitRangeforMac(document.macBase.hostMac.value,3,0,255) ) {
		alert('Invalid Source range in 3rd hex number of Host MAC Address. It should be 0x00-0xff.');
		document.macBase.hostMac.focus();
		return false;
	}
	
	if ( !checkDigitRangeforMac(document.macBase.hostMac.value,4,0,254) ) {
		alert('Invalid Source range in 4th hex number of Host MAC Address. It should be 0x00-0xff.');
		document.macBase.hostMac.focus();
		return false;
	}
	
	if ( !checkDigitRangeforMac(document.macBase.hostMac.value,5,0,255) ) {
		alert('Invalid Source range in 5rd hex number of Host MAC Address. It should be 0x00-0xff.');
		document.macBase.hostMac.focus();
		return false;
	}
	
	if ( !checkDigitRangeforMac(document.macBase.hostMac.value,6,0,255) ) {
		alert('Invalid Source range in 6th hex number of Host MAC Address. It should be 0x00-0xff.');
		document.macBase.hostMac.focus();
		return false;
	}		
	return true;
}


	
</SCRIPT>
</head>


<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("MAC-Based Assignment"); %></font></h2>

<table border=0 width="480" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
 <% multilang("This page is used to configure the static IP base on MAC Address. You can assign/delete the static IP. The Host MAC Address, please input a string with hex number. Such as "00-d0-59-c6-12-43". The Assigned IP Address, please input a string with digit. Such as "192.168.1.100"."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<form action=/boaform/formmacBase method=POST name="macBase">
<input type="hidden" name="lan_ip" value=<% getInfo("dhcplan-ip"); %>>
<input type="hidden" name="lan_mask" value=<% getInfo("dhcplan-subnet"); %>>
<input type="hidden" name="lan_dhcpRangeStart" value=<% getInfo("lan-dhcpRangeStart"); %>>
<input type="hidden" name="lan_dhcpRangeEnd" value=<% getInfo("lan-dhcpRangeEnd"); %>>
<input type="hidden" name="lan_dhcpSubnetMask" value=<% getInfo("lan-dhcpSubnetMask"); %>>
<tr><td>
     <p><font size=2>        
        <b><% multilang("MAC Address"); %> (xx-xx-xx-xx-xx-xx): </b> <input type="text" name="hostMac" size="20" maxlength="17">&nbsp;&nbsp;
     </p>
     <p><font size=2>        
        <b><% multilang("Assigned IP Address"); %> (xxx.xxx.xxx.xxx): </b> <input type="text" name="hostIp" size="20" maxlength="15">&nbsp;&nbsp;
     </p>
</td></tr>

<input type="submit" value="<% multilang("Assign"); %> IP" name="addIP" onClick="return addClick()">&nbsp;&nbsp;
<input type="submit" value="<% multilang("Delete Assigned IP"); %>" name="delIP">&nbsp;&nbsp; 
<input type="hidden" value="/macIptbl.asp" name="submit-url">
<input type="button" value="<% multilang("Close"); %>" name="close" onClick="javascript: window.close();">

<tr><hr size=1 noshade align=top></tr>
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><font size=2><b><% multilang("MAC-Based Assignment"); %><% multilang(" Table"); %>:</b></font></tr>
  <% showMACBaseTable(); %>
</table>

<script>
	<% initPage("dhcp-macbase"); %>
</script>

</form>
</blockquote>
</body>

</html>
