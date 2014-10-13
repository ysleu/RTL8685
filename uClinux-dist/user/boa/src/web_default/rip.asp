<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>RIP <% multilang("Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
var ifnum;

function selected()
{
	document.rip.ripDel.disabled = false;
}

function resetClicked()
{
	document.rip.ripDel.disabled = true;
}

function disableDelButton()
{
	if (verifyBrowser() != "ns") {
		disableButton(document.rip.ripDel);
		disableButton(document.rip.ripDelAll);
	}
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">RIP <% multilang("Configuration"); %></font></h2>

<form action=/boaform/formRip method=POST name="rip">
<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("Enable the RIP if you are using this device as a RIP-enabled Router to communicate with others using the Routing Information Protocol. This page is used to select the interfaces on your device is that use RIP, and the version of the protocol used."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=0 cellpadding=0>
	<tr>
		<td><font size=2><b><% multilang("RIP"); %>:</b></font></td>
		<td><font size=2>
			<input type="radio" value="0" name="rip_on" <% checkWrite("rip-on-0"); %> ><% multilang("Disable"); %>&nbsp;&nbsp;
			<input type="radio" value="1" name="rip_on" <% checkWrite("rip-on-1"); %> ><% multilang("Enable"); %>&nbsp;&nbsp;
		</font></td>
		<td><input type="submit" value="<% multilang("Apply Changes"); %>" name="ripSet"></td>
	</tr>
</table>
<table border=0 width="500" cellspacing=0 cellpadding=0>
	<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=0 cellpadding=0> 
	<tr>
		<td><font size=2><b><% multilang("Interface"); %>:</b></td>
		<td>
			<select name="rip_if">
			<option value="65535">br0</option>
			<% if_wan_list("rt"); %>
			</select>
		</td>
	</tr>
	
	<tr>
		<td><font size=2><b><% multilang("Receive Mode"); %>:</b></td>
		<td>
			<select size="1" name="receive_mode">
			<option value="0"><% multilang("None"); %></option>
			<option value="1">RIP1</option>
			<option value="2">RIP2</option>
			<option value="3"><% multilang("Both"); %></option>
			</select>
		</td>
	</tr>
	
	<tr>
		<td><font size=2><b><% multilang("Send Mode"); %>:</b></td>
		<td>
			<select size="1" name="send_mode">
			<option value="0"><% multilang("None"); %></option>
			<option value="1">RIP1</option>
			<option value="2">RIP2</option>
			<option value="4">RIP1COMPAT</option>
		</select>
		</td>
	</tr>
</table>
	<br>
	<td><input type="submit" value="<% multilang("Add"); %>" name="ripAdd"></td>

<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr><td><hr size=1 noshade align=top></td></tr>
	<tr><td><font size=2><b><% multilang("RIP Config Table"); %>:</b></font></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>
	<% showRipIf(); %>
</table>

	<br>
	<input type="submit" value="<% multilang("Delete Selected"); %>" name="ripDel" onClick="return deleteClick()">&nbsp;&nbsp;  
	<input type="submit" value="<% multilang("Delete All"); %>" name="ripDelAll" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
	<input type="hidden" value="/rip.asp" name="submit-url">
	<script>
		<% checkWrite("ripNum"); %>
	</script>
</form>
</blockquote>
</body>

</html>
