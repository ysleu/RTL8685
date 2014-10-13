<html>
<head>
<title><% multilang("Add IP QoS Traffic Shaping Rule"); %></title>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">

<script language="javascript" src="common.js"></script>
<script language="javascript" type="text/javascript">
//var waniflst = new it_nr("waniflst");
//<% ifWanList_tc(); %>

function on_init_page() {
	//with(document.forms[0]) {
	//for(var i in waniflst){
	//	if(i == "name"||i=="undefined" ||(typeof waniflst[i] != "string" && typeof waniflst[i] != "number")) continue;
	//	inflist.options.add(new Option(waniflst[i],i));
	//}
	//}
	
	if ( <% checkWrite("IPv6Show"); %> )
	{
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('ipprotbl').style.display = 'block';						
		}
		else {
			if (document.layers == false) // IE4
			{
				document.all.ipprotbl.style.display = 'block';						
			}
		}
	}
}

function on_apply() {
	with(document.forms[0]) {
		if (inflist.value == " ")
		{
			inflist.focus();
			alert("wan interface not assigned!");
			return;
		}
		if(srcip.value != "" && sji_checkip(srcip.value) == false)
		{
			srcip.focus();
			alert("Source IP"+srcip.value+" invalid!");
			return;
		}
		
		if(dstip.value != "" && sji_checkip(dstip.value) == false)
		{
			dstip.focus();
			alert("Destination IP"+dstip.value+" invalid");
			return;
		}
		
		if(srcnetmask.value != "" && sji_checkip(srcnetmask.value) == false)
		{
			srcnetmask.focus();
			alert("Source IP Mask"+srcnetmask.value+" invalid");
			return;
		}
		
		if(dstnetmask.value != "" && sji_checkip(dstnetmask.value) == false)
		{
			dstnetmask.focus();
			alert("Destination IP Mask"+dstnetmask.value+" invalid");
			return;
		}
		if(sport.value <0 || sport.value > 65536)
		{
			sport.focus();
			alert("Source Port "+ sport.value + " invalid");
			return;
		}
		if (sport.value > 0 && sport.value < 65535)
		{
			if (protolist.value!= 1 && protolist.value!= 2 && protolist.value!= 4) {
				sport.focus();
				alert("Please assign TCP/UDP!");
				return;
			}
		}
		if(dport.value <0 || dport.value > 65536)
		{
			dport.focus();
			alert("Destination Port "+ dport.value + " invalid");
			return;
		}
		if (dport.value > 0 && dport.value<65535)
		{
			if (protolist.value!= 1 && protolist.value!= 2 && protolist.value!= 4) {
				dport.focus();
				alert("Please assign TCP/UDP!");
				return;
			}
		}
		if(uprate.value<0)
		{
			uprate.focus();
			alert("uplink rate "+ uprate.value + " invalid");
			return;
		}		

		
		if ( <% checkWrite("IPv6Show"); %> ) {
			// For IPv6
			if(document.forms[0].IpProtocolType.value == 2) {
				if(sip6.value != ""){
					if (! isGlobalIpv6Address(sip6.value) ){
						alert("Invalid Source IPv6 address!");					
						return;
					}
					if ( sip6PrefixLen.value != "" ) {
						var prefixlen= getDigit(sip6PrefixLen.value, 1);
						if (prefixlen > 128 || prefixlen <= 0) {
							alert("Invalid Source IPv6 prefix length!");							
							return;
						}
					}
				}
				
				if(dip6.value != ""){
					if (! isGlobalIpv6Address(dip6.value) ){
						alert("Invalid Destination IPv6 address!");					
						return;
					}
					if ( dip6PrefixLen.value != "" ) {
						var prefixlen= getDigit(dip6PrefixLen.value, 1);
						if (prefixlen > 128 || prefixlen <= 0) {
							alert("Invalid Destination IPv6 prefix length!");							
							return;
						}
					}
				}
			}
		}
		
		// For IPv4 and IPv6
		if ( <% checkWrite("IPv6Show"); %> ) {
			// For IPv4
			if(document.forms[0].IpProtocolType.value == 1){				
				lst.value = "inf="+inflist.value+"&proto="+protolist.value+"&IPversion="+IpProtocolType.value+"&srcip="+srcip.value+"&srcnetmask="+srcnetmask.value+
					"&dstip="+dstip.value+"&dstnetmask="+dstnetmask.value+"&sport="+sport.value+"&dport="+dport.value+"&uprate="+uprate.value;
			}
			// For IPv6
			else if (document.forms[0].IpProtocolType.value == 2) {				
				lst.value = "inf="+inflist.value+"&proto="+protolist.value+"&IPversion="+IpProtocolType.value+"&sip6="+sip6.value+"&sip6PrefixLen="+sip6PrefixLen.value+
					"&dip6="+dip6.value+"&dip6PrefixLen="+dip6PrefixLen.value+"&sport="+sport.value+"&dport="+dport.value+"&uprate="+uprate.value;
			}
		}
		// For IPv4 only
		else
		{
				lst.value = "inf="+inflist.value+"&proto="+protolist.value+"&srcip="+srcip.value+"&srcnetmask="+srcnetmask.value+
					"&dstip="+dstip.value+"&dstnetmask="+dstnetmask.value+"&sport="+sport.value+"&dport="+dport.value+"&uprate="+uprate.value;
		}		
		submit();				
	}
}

function protocolChange()
{	
	// If protocol is IPv4 only.
	if(document.forms[0].IpProtocolType.value == 1){			
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('ip4tbl').style.display = 'block';
			document.getElementById('ip6tbl').style.display = 'none';						
		}
		else {
			if (document.layers == false) // IE4
			{
				document.all.ip4tbl.style.display = 'block';
				document.all.ip6tbl.style.display = 'none';						
			}
		}			
	}
	// If protocol is IPv6 only.
	else if(document.forms[0].IpProtocolType.value == 2){			
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('ip4tbl').style.display = 'none';
			document.getElementById('ip6tbl').style.display = 'block';						
		}
		else {
			if (document.layers == false) // IE4
			{
				document.all.ip4tbl.style.display = 'none';
				document.all.ip6tbl.style.display = 'block';						
			}
		}
	}	
}

</script>
</head>
<body  topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" alink="#000000" link="#000000" vlink="#000000" onLoad="on_init_page();">
<blockquote>
	<DIV align="left" style="padding-left:20px; padding-top:5px;">
		<form id="form" action="/boaform/admin/formQosTraffictlEdit" method="post">
			<h2><font color="#0000FF">Add IP QoS Traffic Shaping Rule</font></h2>			
			
			<div id='ipprotbl' style="display:none">
			<table cellSpacing="1" cellPadding="0" border="0">								
				<tr><td width="150px">IP <% multilang("Version"); %>:</td>
					<td><select id="IpProtocolType" onChange="protocolChange()" name="IpProtocolType">						
						<option value="1" > IPv4</option>
						<option value="2" > IPv6</option>
						</select>
					</td>
				</tr>					
			</table>
			</div>
			
			<table cellSpacing="1" cellPadding="0" border="0">		
				<tr>
					<td width="150px"><% multilang("Interface"); %>:</td>
					<td><select id="inflist"><% if_wan_list("queueITF-without-Any"); %></select></td>
				</tr>
				<tr>
					<td width="150px"><% multilang("Protocol"); %>:</td>
					<td>
			  			<select name="protolist">
							<option value="0"><% multilang("None"); %></option>							
							<option value="1">TCP </option>
							<option value="2">UDP </option>
							<option value="3">ICMP</option>
							<option value="4">TCP/UDP</option>
		      			</select>
					</td>
				</tr>
			</table>
			
			<div id='ip4tbl' style="display:block;">
			<table cellSpacing="1" cellPadding="0" border="0">
				<tr>
					<td width="150px"><% multilang("Source"); %> IP:</td>
					<td><input type="text" name="srcip" size="15" maxlength="15" style="width:150px"></td>
				</tr>
				<tr>
					<td width="150px"><% multilang("Source Mask"); %>:</td>
					<td><input type="text" name="srcnetmask" size="15" maxlength="15" style="width:150px"></td>
				</tr>
				<tr>
					<td width="150px"><% multilang("Destination"); %> IP:</td>
					<td><input type="text" name="dstip" size="15" maxlength="15" style="width:150px"></td>
				</tr>
				<tr>
					<td width="150px"><% multilang("Destination Mask"); %>:</td>
					<td><input type="text" name="dstnetmask" size="15" maxlength="15" style="width:150px"></td>
				</tr>
			</table>
			</div>
			
			<div id='ip6tbl' style="display:none;">
			<table cellSpacing="1" cellPadding="0" border="0">
				<tr>
					<td width="150px"><% multilang("Source"); %> IP:</td>
					<td><input type="text" name="sip6" size="26" maxlength="39" style="width:150px"></td>
				</tr>
				<tr>
			  		<td width="150px"><% multilang("Source Prefix Length"); %>:</td>
					<td><input type="text" name="sip6PrefixLen" size="15" maxlength="15" style="width:150px"></td>
				</tr>
				<tr>
					 <td width="150px"><% multilang("Destination"); %> IP:</td>
					<td><input type="text" name="dip6" size="26" maxlength="39" style="width:150px"></td>
				</tr>
				<tr>
			  		<td width="150px"><% multilang("Destination Prefix Length"); %>:</td>
					<td><input type="text" name="dip6PrefixLen" size="15" maxlength="15" style="width:150px"></td>
				</tr>
			</table>
			</div>
			
			<table cellSpacing="1" cellPadding="0" border="0">
				<tr>
					<td width="150px"><% multilang("Source Port"); %>:</td>
					<td><input type="text" name="sport" size="6" style="width:80px"></td>
				</tr>
				<tr>
			  		<td width="150px"><% multilang("Destination Port"); %>:</td>
					<td><input type="text" name="dport" size="6" style="width:80px"></td>
				</tr>
				<tr>
					 <td width="150px"><% multilang("Uplink Rate"); %>:</td>
					<td><input type="text" name="uprate" size="6" style="width:80px"> kb/s</td>
				</tr>
			</table><br><br>
			<input type="button" name="return" value="<% multilang("Close"); %>" onClick="location.href='/net_qos_traffictl.asp';" style="width:80px">
		<input type="button" name="apply" value="<% multilang("Apply Changes"); %>" onClick="on_apply();" style="width:80px">
			<input type="hidden" name="lst" id="lst" value="">
			<input type="hidden" name="submit-url" value="/net_qos_traffictl.asp">
		</form>
	</DIV>
</blockquote>
</body>
</html>
