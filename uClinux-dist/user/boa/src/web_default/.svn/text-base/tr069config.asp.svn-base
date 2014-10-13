<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>TR-069 <% multilang("Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
function resetClick()
{
   document.tr069.reset;
}

function periodicSel() {
	if ( document.tr069.enable[0].checked ) {
		disableTextField(document.tr069.interval);
	} else {
		enableTextField(document.tr069.interval);
	}
}

<% TR069ConPageShow("ShowAuthSelFun"); %>

function saveChanges()
{
  if (document.tr069.url.value=="") {
	alert("ACS URL cannot be empty!");
	document.tr069.url.value = document.tr069.url.defaultValue;
	document.tr069.url.focus();
	return false;
  }

	if (checkString(document.tr069.username.value) == 0) {
		alert('Invalid User Name !');
		document.tr069.username.focus();
		return false;
	}
	if (checkString(document.tr069.password.value) == 0) {
		alert('Invalid Password !');
		document.tr069.password.focus();
		return false;
	}
  if (document.tr069.enable[1].checked) {
	if ( document.tr069.interval.value=="") {
		alert("Please input periodic interval time.");
		document.tr069.interval.focus();
		return false;
	}
	if ( validateKey( document.tr069.interval.value ) == 0 ) {
		alert('Interval should be the decimal number (0-9).');
		document.tr069.interval.focus();
		return false;
	}
  }

	if (checkString(document.tr069.conreqname.value) == 0) {
		alert('Invalid User Name !');
		document.tr069.conreqname.focus();
		return false;
	}
	if (checkString(document.tr069.conreqpw.value) == 0) {
		alert('Invalid Password !');
		document.tr069.conreqpw.focus();
		return false;
	}
	if (checkString(document.tr069.conreqpath.value) == 0) {
		alert('Invalid Path !');
		document.tr069.conreqpath.focus();
		return false;
	}
  if (document.tr069.conreqport.value=="") {
	alert("Please input the port number for connection request.");
	document.tr069.conreqport.value = document.tr069.conreqport.defaultValue;
	document.tr069.conreqport.focus();
	return false;
  }
  if ( validateKey( document.tr069.conreqport.value ) == 0 ) {
	alert("Invalid port number of connection request. It should be 1-65535.");
	document.tr069.conreqport.value = document.tr069.conreqport.defaultValue;
	document.tr069.conreqport.focus();
	return false;
  }
  if ( !checkDigitRange(document.tr069.conreqport.value,1,1,65535) ) {
  	   	alert('Invalid port number of connection request. It should be 1-65535.');
	document.tr069.conreqport.value = document.tr069.conreqport.defaultValue;
	document.tr069.conreqport.focus();
	return false;
  }


  return true;
}

</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">TR-069 <% multilang("Configuration"); %></font></h2>

<form action=/boaform/formTR069Config method=POST name="tr069">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to configure the TR-069 CPE. Here you may change the setting for the ACS's parameters."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr>
		<td width="30%" style="font-weight: bold; font-size: 14">TR069:</td>
		<td width="70%"><font size=2>
		<input type="radio" name=autoexec value=0 <% checkWrite("tr069-autoexec-0"); %> ><% multilang("Disabled"); %>&nbsp;&nbsp;
		<input type="radio" name=autoexec value=1 <% checkWrite("tr069-autoexec-1"); %> ><% multilang("Enabled"); %></font>
		</td>
	</tr>
	<% TR069ConPageShow("ShowDataModels"); %>
</table>
<div ID=WANshow style="display:none">
<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr>
		<td width="30%" style="font-weight: bold; font-size: 14"><% multilang("WAN Interface"); %>:</td>
		<td>
			<select name="tr069_itf">
				<option value=65535>&nbsp;</option>
				<% if_wan_list("rt"); %>
			</select>
		</td>
	</tr>
</table>
</div>
<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr><td colspan=2><hr size=1 noshade align=top></td><td></td></tr>
	<tr>
		<td style="font-size: 18; font-weight: bold">ACS:</td>
	</tr>
	<tr>
		<td width="30%"><font size=2><b>URL:</b></td>
		<td width="70%"><input type="text" name="url" size="32" maxlength="256" value=<% getInfo("acs-url"); %>></td>
	</tr>
	<tr>
		<td width="30%"><font size=2><b><% multilang("User"); %><% multilang(" Name"); %>:</b></td>
		<td width="70%"><input type="text" name="username" size="32" maxlength="256" value=<% getInfo("acs-username"); %>></td>
	</tr>
	<tr>
		<td width="30%"><font size=2><b><% multilang("Password"); %>:</b></td>
		<td width="70%"><input type="text" name="password" size="32" maxlength="256" value=<% getInfo("acs-password"); %>></td>
	</tr>
	<tr>
		<td width="30%"><font size=2><b><% multilang("Periodic Inform"); %>:</b></td>
		<td width="70%"><font size=2>
		<input type="radio" name=enable value=0 <% checkWrite("tr069-inform-0"); %> onClick="return periodicSel()"><% multilang("Disabled"); %>&nbsp;&nbsp;
		<input type="radio" name=enable value=1 <% checkWrite("tr069-inform-1"); %> onClick="return periodicSel()"><% multilang("Enabled"); %></td>
	</tr>
	<tr>
		<td width="30%"><font size=2><b><% multilang("Periodic Inform Interval"); %>:</b></td>
		<td width="70%"><input type="text" name="interval" size="32" maxlength="10" value=<% getInfo("inform-interval"); %>  <% checkWrite("tr069-interval"); %> ></td>
	</tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr><td><hr size=1 noshade align=top></td></tr>
	<tr>
  	<td style="font-size: 18; font-weight: bold">
			<% multilang("Connection Request"); %>:
  	</td>
  </tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>
	<% TR069ConPageShow("ShowAuthSelect"); %>
  <tr>
		<td width="30%"><font size=2><b><% multilang("User"); %><% multilang(" Name"); %>:</b></td>
		<td width="70%"><input type="text" name="conreqname" size="32" maxlength="256" value=<% getInfo("conreq-name"); %> <% TR069ConPageShow("DisConReqName"); %> ></td>
  </tr>
  <tr>
      <td width="30%"><font size=2><b><% multilang("Password"); %>:</b></td>
      <td width="70%"><input type="text" name="conreqpw" size="32" maxlength="256" value=<% getInfo("conreq-pw"); %> <% TR069ConPageShow("DisConReqPwd"); %> ></td>
  </tr>
  <tr>
      <td width="30%"><font size=2><b><% multilang("Path"); %>:</b></td>
      <td width="70%"><input type="text" name="conreqpath" size="32" maxlength="31" value=<% getInfo("conreq-path"); %>></td>
  </tr>
  <tr>
      <td width="30%"><font size=2><b><% multilang("Port"); %>:</b></td>
      <td width="70%"><input type="text" name="conreqport" size="32" maxlength="5" value=<% getInfo("conreq-port"); %>></td>
  </tr>
</table>

<!--
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><hr size=1 noshade align=top></tr>
  <tr>
      <td width="30%"><font size=2><b>Debug:</b></td>
      <td width="70%"><b></b></td>
  </tr>
  <% TR069ConPageShow("ShowACSCertCPE"); %>
  <tr>
      <td width="30%"><font size=2><b>Show Message:</b></td>
      <td width="70%"><font size=2>
      <input type="radio" name=dbgmsg value=0 <% checkWrite("tr069-dbgmsg-0"); %> >Disabled&nbsp;&nbsp;
      <input type="radio" name=dbgmsg value=1 <% checkWrite("tr069-dbgmsg-1"); %> >Enabled
      </td>
  </tr>
  <tr>
      <td width="30%"><font size=2><b>CPE Sends GetRPC:</b></td>
      <td width="70%"><font size=2>
      <input type="radio" name=sendgetrpc value=0 <% checkWrite("tr069-sendgetrpc-0"); %> >Disabled&nbsp;&nbsp;
      <input type="radio" name=sendgetrpc value=1 <% checkWrite("tr069-sendgetrpc-1"); %> >Enabled
      </td>
  </tr>
  <tr>
      <td width="30%"><font size=2><b>Skip MReboot:</b></td>
      <td width="70%"><font size=2>
      <input type="radio" name=skipmreboot value=0 <% checkWrite("tr069-skipmreboot-0"); %> >Disabled&nbsp;&nbsp;
      <input type="radio" name=skipmreboot value=1 <% checkWrite("tr069-skipmreboot-1"); %> >Enabled
      </td>
  </tr>
  <tr>
      <td width="30%"><font size=2><b>Delay:</b></td>
      <td width="70%"><font size=2>
      <input type="radio" name=delay value=0 <% checkWrite("tr069-delay-0"); %> >Disabled&nbsp;&nbsp;
      <input type="radio" name=delay value=1 <% checkWrite("tr069-delay-1"); %> >Enabled
      </td>
  </tr>
  <tr>
      <td width="30%"><font size=2><b>Auto-Execution:</b></td>
      <td width="70%"><font size=2>
      <input type="radio" name=autoexec value=0 <% checkWrite("tr069-autoexec-0"); %> >Disabled&nbsp;&nbsp;
      <input type="radio" name=autoexec value=1 <% checkWrite("tr069-autoexec-1"); %> >Enabled
      </td>
  </tr>
  <% TR069ConPageShow("ShowCTInformExt"); %>
</table>
-->
	<br>
	<input type="submit" value=<% multilang("Apply Changes"); %> name="save" onClick="return saveChanges()">&nbsp;&nbsp;
	<input type="reset" value=<% multilang("Undo"); %> name="reset" onClick="resetClick()">
	<input type="hidden" value="/tr069config.asp" name="submit-url">
</form>

<% TR069ConPageShow("ShowMNGCertTable"); %>
<script>
	ifIdx = <% getInfo("tr069_wan_intf"); %>;
	document.tr069.tr069_itf.selectedIndex = -1;

	for( i = 0; i < document.tr069.tr069_itf.options.length; i++ )
	{
		if( ifIdx == document.tr069.tr069_itf.options[i].value )
			document.tr069.tr069_itf.selectedIndex = i;
	}
	<% DisplayTR069WAN() %>
</script>
</blockquote>
</body>
</html>
