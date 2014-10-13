<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>DHCPv6 <% multilang("Settings"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>

function showDhcpv6Svr()
{
	var html;

	if (document.dhcpd.dhcpdenable[0].checked == true)
		document.getElementById('displayDhcpSvr').innerHTML=
			'<input type="submit" value="<% multilang("Apply Changes"); %>" name="save">&nbsp;&nbsp;';
	else if (document.dhcpd.dhcpdenable[1].checked == true)
		document.getElementById('displayDhcpSvr').innerHTML=
			'<table border=0 width="500" cellspacing=4 cellpadding=0>'+
			'<tr><font color="#000000" size=2>'+
			'<% multilang("This page is used to configure the upper interface (server link) for DHCPv6 Relay."); %>'+
			'</font></tr>'+
			'<tr><td><hr size=1 noshade align=top></td></tr>'+
			'</table>'+
			'<table border=0 width="500" cellspacing=4 cellpadding=0>'+
			'<tr>'+
			'<td width="30%"><font size=2><b><% multilang("Upper Interface"); %>:</b></font></td>'+
			'<td width="35%">'+
			'<select name="upper_if">'+
			'<% if_wan_list("all2"); %>'+    	                           
			'</select>'+     	
			'</td>'+
			'</tr>'+			   
			'</table>'+			
			'<input type="submit" value="<% multilang("Apply Changes"); %>" name="save">&nbsp;&nbsp;';

	else if (document.dhcpd.dhcpdenable[2].checked == true) {
		html=
			'<table border=0 width="500" cellspacing=4 cellpadding=0>'+
			'<tr><font color="#000000" size=2>'+
			'<% multilang("Enable the DHCPv6 Server if you are using this device as a DHCPv6 server. This page lists the IP address pools available to hosts on your LAN. The device distributes numbers in the pool to hosts on your network as they request Internet access."); %>'+

			'</table>'+
			'<table border=0 width="500" cellspacing=4 cellpadding=0>'+
			'<tr>'+
			'<td width="30%"><font size=2><b><% multilang("IP Pool Range"); %>:</b></td>';
		html+=
			'<td width="70%"><input type="text" name="dhcpRangeStart" size=40 maxlength=39 value="<% getInfo("dhcpv6s_range_start"); %>">'+
			'<font face="Arial" size="5">- <input type="text" name="dhcpRangeEnd" size=40 maxlength=39 value="<% getInfo("dhcpv6s_range_end"); %>">&nbsp;';
		html+=	'</td>'+
			'</tr>';		

		html += '<tr>'+
			'<td width="30%"><font size=2><b><% multilang("Prefix Length"); %>:</b></font></td>'+
			'<td width="70%"><font size=2>'+
			'<input type="text" name="prefix_len" size=10 maxlength=3 value="<% getInfo("dhcpv6s_prefix_length"); %>">'+
			'</td>'+
			'</tr>';
		html += '<tr>'+
			'<td width="30%"><font size=2><b><% multilang("Valid Lifetime"); %>:</b></td>'+
			'<td width="70%"><font size=2>'+
			'<input type="text" name="Dltime" size=10 maxlength=9 value="<% getInfo("dhcpv6s_default_LTime"); %>"><b> <% multilang("seconds"); %></b>'+
			'</td>'+
			'</tr>'+
			'<tr>'+
			'<td width="30%"><font size=2><b><% multilang("Preferred Lifetime"); %>:</b></td>'+
			'<td width="70%"><font size=2>'+
			'<input type="text" name="PFtime" size=10 maxlength=9 value="<% getInfo("dhcpv6s_preferred_LTime"); %>"><b> <% multilang("seconds"); %></b>'+
			'</td>'+
			'</tr>'+
			'<tr>'+
			'<td width="30%"><font size=2><b><% multilang("Renew Time"); %>:</b></td>'+
			'<td width="70%"><font size=2>'+
			'<input type="text" name="RNtime" size=10 maxlength=9 value="<% getInfo("dhcpv6s_renew_time"); %>"><b> <% multilang("seconds"); %></b>'+
			'</td>'+
			'</tr>'+
			'<tr>'+
			'<td width="30%"><font size=2><b><% multilang("Rebind Time"); %>:</b></td>'+
			'<td width="70%"><font size=2>'+
			'<input type="text" name="RBtime" size=10 maxlength=9 value="<% getInfo("dhcpv6s_rebind_time"); %>"><b> <% multilang("seconds"); %></b>'+
			'</td>'+
			'</tr>'+
			'<tr>'+
			'<td width="30%"><font size=2><b><% multilang("Client"); %> DUID:</b></td>'+
			'<td width="70%"><font size=2>'+
			'<input type="text" name="clientID" size=42 maxlength=41 value="<% getInfo("dhcpv6s_clientID"); %>">'+
			'</td>'+
			'</tr>'+							
			'</table>'+
			'<input type="submit" value="<% multilang("Apply Changes"); %>" name="save" onClick="return saveChanges()">&nbsp;&nbsp;'+

			'<tr><hr size=1 noshade align=top></tr>'+
			'<tr>'+
			'<td><font size=2><b><% multilang("Domain"); %>:</b></td>'+
			'<td><input type="text" name="domainStr" size="15" maxlength="50">&nbsp;&nbsp;</td>'+
			'<td><input type="submit" value="<% multilang("Add"); %>" name="addDomain">&nbsp;&nbsp;</td>'+
			'</tr>'+ 
			'<br>'+
			'<br>'+
			'<table border=0 width="300" cellspacing=4 cellpadding=0>'+
			'<tr><font size=2><b><% multilang("Domain Search Table"); %>:</b></font></tr>'+
			<% showDhcpv6SDOMAINTable(); %>
			'</table>'+
			'<br>'+	
			'<input type="submit" value="<% multilang("Delete Selected"); %>" name="delDomain">&nbsp;&nbsp;'+
			'<input type="submit" value="<% multilang("Delete All"); %>" name="delAllDomain">&nbsp;&nbsp;&nbsp;'+

			'<br>'+
			'<br>'+	
			'<tr><hr size=1 noshade align=top></tr>'+

			'<tr>'+
			'<td><font size=2><b><% multilang("Name Server"); %> IP:</b></td>'+
			'<td><input type="text" name="nameServerIP" size="15" maxlength="40">&nbsp;&nbsp;</td>'+
			'<td><input type="submit" value="<% multilang("Add"); %>" name="addNameServer">&nbsp;&nbsp;</td>'+
			'</tr>'+ 
			'<br>'+
			'<br>'+
			'<table border=0 width="300" cellspacing=4 cellpadding=0>'+
			'<tr><font size=2><b><% multilang("Name Server Table"); %>:</b></font></tr>'+
			<% showDhcpv6SNameServerTable(); %>
			'</table>'+
			'<br>'+	
			'<input type="submit" value="<% multilang("Delete Selected"); %>" name="delNameServer">&nbsp;&nbsp;'+
			'<input type="submit" value="<% multilang("Delete All"); %>" name="delAllNameServer">&nbsp;&nbsp;&nbsp;';

		document.getElementById('displayDhcpSvr').innerHTML=html;		
	}
	else if (document.dhcpd.dhcpdenable[3].checked == true)
		document.getElementById('displayDhcpSvr').innerHTML=
			'<tr><font color="#000000" size=2>'+
			'<% multilang("Auto Config by Prefix Delegation for DHCPv6 Server."); %>'+
			'</tr>'+
			'<input type="submit" value="<% multilang("Apply Changes"); %>" name="save">&nbsp;&nbsp;';
}

function checkDigitRange_leaseTime(str, min)
{
  d = parseInt(str, 10);
  if ( d < min || d == 0)
      	return false;
  return true;
}

function validateKey_leasetime(str)
{
   for (var i=0; i<str.length; i++) {
    if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') ||
    		(str.charAt(i) == '-' ) )
			continue;
	return 0;
  }
  return 1;
}


function saveChanges()
{
	if (document.dhcpd.dhcpRangeStart.value =="") {
		alert("Start IP address cannot be empty! Format is IPV6 address. For example: 2000:0200::10");
		document.dhcpd.dhcpRangeStart.value = document.dhcpd.dhcpRangeStart.defaultValue;
		document.dhcpd.dhcpRangeStart.focus();
		return false;
	} else {
		if ( validateKeyV6IP(document.dhcpd.dhcpRangeStart.value) == 0) {
			alert("Invalid Start IP!");	
			document.dhcpd.dhcpRangeStart.focus();
			return false;
		}
	}
	
	if (document.dhcpd.dhcpRangeEnd.value =="") {
		alert("End IP address cannot be empty! Format is IPV6 address. For example: 2000:0200::20");
		document.dhcpd.dhcpRangeEnd.value = document.dhcpd.dhcpRangeEnd.defaultValue;
		document.dhcpd.dhcpRangeEnd.focus();
		return false;
	} else {
		if ( validateKeyV6IP(document.dhcpd.dhcpRangeEnd.value) == 0) {
			alert("Invalid End IP!");	
			document.dhcpd.dhcpRangeEnd.focus();
			return false;
		}
	}
	
	if ( document.dhcpd.prefix_len.value=="") {
		alert("Please input IP prefix length.");
		document.dhcpd.prefix_len.focus();
		return false;
	}
	if ( document.dhcpd.Dltime.value=="") {
		alert("Please input dhcp default lease time.");
		document.dhcpd.Dltime.focus();
		return false;
	}
	if ( validateKey_leasetime( document.dhcpd.Dltime.value ) == 0 ) {
		alert("Invalid DHCP Server default lease time number.");
		document.dhcpd.Dltime.value = document.dhcpd.Dltime.defaultValue;
		document.dhcpd.Dltime.focus();
		return false;
	}
	if ( !checkDigitRange_leaseTime(document.dhcpd.Dltime.value, 0) ) {
	  	alert('Invalid DHCP Server default lease time.');
		document.dhcpd.Dltime.value = document.dhcpd.Dltime.defaultValue;
		document.dhcpd.Dltime.focus();
		return false;
	}	 	
	
	if ( document.dhcpd.PFtime.value=="") {
		alert("Please input dhcp Prefered-lifetime.");
		document.dhcpd.PFtime.focus();
		return false;
	}
	if ( validateKey_leasetime( document.dhcpd.PFtime.value ) == 0 ) {
		alert("Invalid DHCP Server Prefered-lifetime number.");
		document.dhcpd.PFtime.value = document.dhcpd.PFtime.defaultValue;
		document.dhcpd.PFtime.focus();
		return false;
	}
	if ( !checkDigitRange_leaseTime(document.dhcpd.PFtime.value, 0) ) {
	  	alert('Invalid DHCP Server Prefered-lifetime.');
		document.dhcpd.PFtime.value = document.dhcpd.PFtime.defaultValue;
		document.dhcpd.PFtime.focus();
		return false;
	}
	if ( document.dhcpd.RNtime.value=="") {
		alert("Please input dhcp Renew Time.");
		document.dhcpd.RNtime.focus();
		return false;
	}
	if ( document.dhcpd.RBtime.value=="") {
		alert("Please input dhcp Rebind Time.");
		document.dhcpd.RBtime.focus();
		return false;
	}
	if ( document.dhcpd.clientID.value=="") {
		alert("Please input dhcp Client OUID.");
		document.dhcpd.clientID.focus();
		return false;
	}
	
	return true;
}

function enabledhcpd()
{
	document.dhcpd.dhcpdenable[2].checked = true;
	//ip = ShowIP(document.dhcpd.lan_ip.value);
	showDhcpv6Svr();
}

function disabledhcpd()
{
	document.dhcpd.dhcpdenable[0].checked = true;
	showDhcpv6Svr();
}

function enabledhcprelay()
{
	document.dhcpd.dhcpdenable[1].checked = true;
	showDhcpv6Svr();
}

function autodhcpd()
{
	document.dhcpd.dhcpdenable[3].checked = true;
	showDhcpv6Svr();
}

</SCRIPT>
</head>

<body>
<blockquote>

<h2><font color="#0000FF">DHCPv6 <% multilang("Settings"); %></font></h2>

<form action=/boaform/formDhcpv6Server method=POST name="dhcpd">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font color="#000000" size=2>
    <% multilang("This page is used to configure DHCPv6 Server and DHCPv6 Relay."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>

</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr>
  <td><font size=2><b>DHCPv6 <% multilang("Mode"); %>: </b>
  <% checkWrite("dhcpV6Mode"); %>

  </td>
  </tr>
</table>

<table border="0" width="500" cellpadding="0" cellspacing="0">
  <tr><td><hr size=2 noshade align=top></td></tr>
  <tr><td ID="displayDhcpSvr"></td></tr>
</table>

   <br>
      <input type="hidden" value="/dhcpdv6.asp" name="submit-url">

<script>
	<% initPage("dhcpv6-mode"); %>
	showDhcpv6Svr();
</script>


 </form>
</blockquote>
</body>

</html>
