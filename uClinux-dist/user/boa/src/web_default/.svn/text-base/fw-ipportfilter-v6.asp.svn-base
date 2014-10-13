<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>IPv6 IP/Port <% multilang("Filtering"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script>
function skip () { this.blur(); }

function protocolSelection()
{
	if ( document.formFilterAdd.protocol.selectedIndex == 2 )
	{
		document.formFilterAdd.sportStart.disabled = true;
		document.formFilterAdd.sportEnd.disabled = true;
		document.formFilterAdd.dportStart.disabled = true;
		document.formFilterAdd.dportEnd.disabled = true;
	}
	else
	{
		document.formFilterAdd.sportStart.disabled = false;
		document.formFilterAdd.sportEnd.disabled = false;
		document.formFilterAdd.dportStart.disabled = false;
		document.formFilterAdd.dportEnd.disabled = false;
	}
}

function addClick()
{
	if (document.formFilterAdd.sip6Start.value == "" && document.formFilterAdd.sip6PrefixLen.value == ""
		&& document.formFilterAdd.dip6Start.value == "" && document.formFilterAdd.dip6PrefixLen.value == ""
		&& document.formFilterAdd.sfromPort.value == "" && document.formFilterAdd.dfromPort.value == "") {
		alert("Filter Rules can't be empty");
		document.formFilterAdd.sip6Start.focus();
		return false;
	}

	with ( document.forms[1] )	{
	if(sip6Start.value != ""){
		if (! isGlobalIpv6Address(sip6Start.value) ){
			alert("Invalid Source IPv6 Start address!");
			document.formFilterAdd.sip6Start.focus();
			return false;
		}
		if ( sip6PrefixLen.value != "" ) {
			if ( validateKey( document.formFilterAdd.sip6PrefixLen.value ) == 0 ) {
				alert("Invalid Source IPv6 prefix length! It must be 0-9!");
				document.formFilterAdd.sip6PrefixLen.focus();
				return false;
			}

			var prefixlen= getDigit(sip6PrefixLen.value, 1);
			if (prefixlen > 64 || prefixlen < 0) {
				alert("Invalid Source IPv6 prefix length! It must be 0-64!");
				document.formFilterAdd.sip6PrefixLen.focus();
				return false;
			}
		}
	}

	if(sip6End.value != ""){
		if (! isGlobalIpv6Address(sip6End.value) ){
			alert("Invalid Source IPv6 End address!");
			document.formFilterAdd.sip6End.focus();
			return false;
		}
	}

	if(dip6Start.value != ""){
		if (! isGlobalIpv6Address(dip6Start.value) ){
			alert("Invalid Destination IPv6 Start address!");
			document.formFilterAdd.dip6Start.focus();
			return false;
		}
		if ( dip6PrefixLen.value != "" ) {
			if ( validateKey( document.formFilterAdd.dip6PrefixLen.value ) == 0 ) {
				alert("Invalid destination IPv6 prefix length! It must be 0-9!");
				document.formFilterAdd.dip6PrefixLen.focus();
				return false;
			}

			var prefixlen= getDigit(dip6PrefixLen.value, 1);
			if (prefixlen > 64 || prefixlen < 0) {
				alert("Invalid destination IPv6 prefix length! It must be 0-64!");
				document.formFilterAdd.dip6PrefixLen.focus();
				return false;
			}
		}
	}

	if(dip6End.value != ""){
		if (! isGlobalIpv6Address(dip6End.value) ){
			alert("Invalid Destination IPv6 End address!");
			document.formFilterAdd.dip6End.focus();
			return false;
		}
	}

	if ( document.formFilterAdd.sfromPort.value!="" ) {
		if ( validateKey( document.formFilterAdd.sfromPort.value ) == 0 ) {
			alert("Invalid source port!");
			document.formFilterAdd.sfromPort.focus();
			return false;
		}

		d1 = getDigit(document.formFilterAdd.sfromPort.value, 1);
		if (d1 > 65535 || d1 < 1) {
			alert("Invalid source port number!");
			document.formFilterAdd.sfromPort.focus();
			return false;
		}

		if ( document.formFilterAdd.stoPort.value!="" ) {
			if ( validateKey( document.formFilterAdd.stoPort.value ) == 0 ) {
				alert("Invalid source port!");
				document.formFilterAdd.stoPort.focus();
				return false;
			}

			d1 = getDigit(document.formFilterAdd.stoPort.value, 1);
			if (d1 > 65535 || d1 < 1) {
				alert("Invalid source port number!");
				document.formFilterAdd.stoPort.focus();
				return false;
			}
		}
	}

	if ( document.formFilterAdd.dfromPort.value!="" ) {
		if ( validateKey( document.formFilterAdd.dfromPort.value ) == 0 ) {
			alert("Invalid destination port!");
			document.formFilterAdd.dfromPort.focus();
			return false;
		}

		d1 = getDigit(document.formFilterAdd.dfromPort.value, 1);
		if (d1 > 65535 || d1 < 1) {
			alert("Invalid destination port number!");
			document.formFilterAdd.dfromPort.focus();
			return false;
		}

		if ( document.formFilterAdd.dtoPort.value!="" ) {
			if ( validateKey( document.formFilterAdd.dtoPort.value ) == 0 ) {
				alert("Invalid destination port!");
				document.formFilterAdd.dtoPort.focus();
				return false;
			}

			d1 = getDigit(document.formFilterAdd.dtoPort.value, 1);
			if (d1 > 65535 || d1 < 1) {
				alert("Invalid destination port number!");
				document.formFilterAdd.dtoPort.focus();
				return false;
			}
		}
	}
	}
	return true;
}

function disableDelButton()
{
  if (verifyBrowser() != "ns") {
	disableButton(document.formFilterDel.deleteSelFilterIpPort);
	disableButton(document.formFilterDel.deleteAllFilterIpPort);
  }
}

</script>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">IPv6 IP/Port <% multilang("Filtering"); %></font></h2>

<table border=0 width="600" cellspacing=0 cellpadding=0>
<tr><td><font size=2>
 <% multilang("Entries in this table are used to restrict certain types of data packets through the Gateway. Use of such filters can be helpful in securing or restricting your local network."); %>
</font></td></tr>

<tr <% checkWrite("rg_hidden_function"); %>><td><hr size=1 noshade align=top></td></tr>

<form action=/boaform/formFilterV6 method=POST name="formFilterDefault">
<tr <% checkWrite("rg_hidden_function"); %>><td><font size=2><b><% multilang("Outgoing Default Action"); %></b>&nbsp;&nbsp;
   	<input type="radio" name="outAct" value=0 <% checkWrite("v6_ipf_out_act0"); %>><% multilang("Deny"); %>&nbsp;&nbsp;
   	<input type="radio" name="outAct" value=1 <% checkWrite("v6_ipf_out_act1"); %>><% multilang("Allow"); %>&nbsp;&nbsp;
</font></td><tr>
<tr <% checkWrite("rg_hidden_function"); %>><td><font size=2><b><% multilang("Incoming Default Action"); %></b>&nbsp;&nbsp;
   	<input type="radio" name="inAct" value=0 <% checkWrite("v6_ipf_in_act0"); %>><% multilang("Deny"); %>&nbsp;&nbsp;
   	<input type="radio" name="inAct" value=1 <% checkWrite("v6_ipf_in_act1"); %>><% multilang("Allow"); %>&nbsp;&nbsp;
	<input type="submit" value="<% multilang("Apply Changes"); %>" name="setDefaultAction">&nbsp;&nbsp;
	<input type="hidden" value="/fw-ipportfilter-v6.asp" name="submit-url">
</font></td></tr>
</form>
</table>
<table border=0 width="600" cellspacing=0 cellpadding=0>
<tr><td><hr size=1 noshade align=top></td></tr>
<form action=/boaform/formFilterV6 method=POST name="formFilterAdd">
<tr>
	<td width="600"><font size=2>
	<b><% multilang("Direction"); %>: </b>
		<select name=dir>
			<option select value=0><% multilang("Outgoing"); %></option>
			<option value=1><% multilang("Incoming"); %></option>
		</select>&nbsp;&nbsp;
	<b><% multilang("Protocol"); %>: </b>
		<select name="protocol" onChange="protocolSelection()">
			<option select value=1>TCP</option>
			<option value=2>UDP</option>
			<option value=3>ICMPV6</option>
		</select>&nbsp;&nbsp;
	<b><% multilang("Rule Action"); %></b>
   		<input type="radio" name="filterMode" value="Deny" checked>&nbsp;<% multilang("Deny"); %>
   		<input type="radio" name="filterMode" value="Allow">&nbsp;&nbsp;<% multilang("Allow"); %>
	</font></td>
</tr>

<table cellSpacing="1" cellPadding="0" border="0">
   <tr>
	  <td width="150px"><font size=2><b><% multilang("Source"); %> <% multilang("IP Address"); %>:</b></td>
	  <td><input type="text" size="16" name="sip6Start" style="width:150px"> - <input type="text" size="16" name="sip6End" style="width:150px"></td>
   </tr>

   <tr>
	  <td width="150px"><font size=2><b><% multilang("Source"); %> <% multilang("Prefix Length"); %>:</b></td>
	  <td><input type="text" size="16" name="sip6PrefixLen" style="width:150px"></td>
   </tr>
   <tr>
	  <td width="150px"><font size=2><b><% multilang("Destination"); %> <% multilang("IP Address"); %>:</b></td>
	  <td><input type="text" size="16" name="dip6Start" style="width:150px"> - <input type="text" size="16" name="dip6End" style="width:150px"></td>
   </tr>
   <tr>
	  <td width="150px"><font size=2><b><% multilang("Destination"); %> <% multilang("Prefix Length"); %>:</b></td>
	  <td><input type="text" size="16" name="dip6PrefixLen" style="width:150px"></td>
   </tr>
</table>

<table cellSpacing="1" cellPadding="0" border="0">
   <tr>
	  <td width="150px"><font size=2><b><% multilang("Source"); %> <% multilang("Port"); %>:</b></td>
	  <td><input type="text" size="6" name="sfromPort" style="width:150px"> - <input type="text" size="6" name="stoPort" style="width:150px"></td>
   </tr>
   <tr>
	  <td width="150px"><font size=2><b><% multilang("Destination"); %> <% multilang("Port"); %>:</b></td>
	  <td><input type="text" size="6" name="dfromPort" style="width:150px"> - <input type="text" size="6" name="dtoPort" style="width:150px"></td>
   </tr>
</table>

<tr>
	<td>
	<input type="submit" value="<% multilang("Add"); %>" name="addFilterIpPort" onClick="return addClick()">
	<input type="hidden" value="/fw-ipportfilter-v6.asp" name="submit-url">
	</td>
</tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</form>
</table>

<form action=/boaform/formFilterV6 method=POST name="formFilterDel">
	<table border="0" width=600>
	<tr><font size=2><b><% multilang("Current Filter Table"); %>:</b></font></tr>
	<% ipPortFilterListV6(); %>
	</table>
	<br>
	<input type="submit" value="<% multilang("Delete Selected"); %>" name="deleteSelFilterIpPort" onClick="return deleteClick()">&nbsp;&nbsp;
	<input type="submit" value="<% multilang("Delete All"); %>" name="deleteAllFilterIpPort" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
	<input type="hidden" value="/fw-ipportfilter-v6.asp" name="submit-url">
	<script>
		<% checkWrite("ipFilterNumV6"); %>
	</script>
</form>

</blockquote>
</body>
</html>
