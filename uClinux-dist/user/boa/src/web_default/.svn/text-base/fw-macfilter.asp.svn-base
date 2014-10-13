<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>MAC <% multilang("Filtering"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script>
function skip () { this.blur(); }
function addClick()
{
//  if (document.formFilterAdd.srcmac.value=="" )
//	return true;
  if (document.formFilterAdd.srcmac.value=="" && document.formFilterAdd.dstmac.value=="") {
	alert("Input MAC address.");
	return false;
  }

	if (document.formFilterAdd.srcmac.value != "") {
		if (!checkMac(document.formFilterAdd.srcmac, 0))
			return false;
	}
	if (document.formFilterAdd.dstmac.value != "") {
		if (!checkMac(document.formFilterAdd.dstmac, 0))
			return false;
	}
	return true;
/*  var str = document.formFilterAdd.srcmac.value;
  if ( str.length < 12) {
	alert("Input MAC address is not complete. It should be 12 digits in hex.");
	document.formFilterAdd.srcmac.focus();
	return false;
  }

  for (var i=0; i<str.length; i++) {
    if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') ||
			(str.charAt(i) >= 'a' && str.charAt(i) <= 'f') ||
			(str.charAt(i) >= 'A' && str.charAt(i) <= 'F') )
			continue;

	alert("Invalid MAC address. It should be in hex number (0-9 or a-f).");
	document.formFilterAdd.srcmac.focus();
	return false;
  }
  return true;*/
}

function disableDelButton()
{
  if (verifyBrowser() != "ns") {
	disableButton(document.formFilterDel.deleteSelFilterMac);
	disableButton(document.formFilterDel.deleteAllFilterMac);
  }
}

</script>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("MAC Filtering for bridge mode"); %></font></h2>

<table border=0 width="500" cellspacing=0 cellpadding=0>
<tr><td><font size=2>
 <% multilang("Entries in this table are used to restrict certain types of data packets from your local network to Internet through the Gateway.  Use of such filters can be helpful in securing or restricting your local network."); %>
</font></td></tr>

<tr><td><hr size=1 noshade align=top></td></tr>

<form action=/boaform/admin/formFilter method=POST name="formFilterDefault">
<tr><td><font size=2><b><% multilang("Outgoing Default Action"); %></b>&nbsp;&nbsp;
   	<input type="radio" name="outAct" value=0 <% checkWrite("macf_out_act0"); %>><% multilang("Deny"); %>&nbsp;&nbsp;
   	<input type="radio" name="outAct" value=1 <% checkWrite("macf_out_act1"); %>><% multilang("Allow"); %>&nbsp;&nbsp;
</font></td><tr>
<tr><td><font size=2><b><% multilang("Incoming Default Action"); %></b>&nbsp;&nbsp;
   	<input type="radio" name="inAct" value=0 <% checkWrite("macf_in_act0"); %>><% multilang("Deny"); %>&nbsp;&nbsp;
   	<input type="radio" name="inAct" value=1 <% checkWrite("macf_in_act1"); %>><% multilang("Allow"); %>&nbsp;&nbsp;
	<input type="submit" value="<% multilang("Apply Changes"); %>" name="setMacDft">&nbsp;&nbsp;
	<input type="hidden" value="/admin/fw-macfilter.asp" name="submit-url">
</font></td></tr>
</form>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=0 cellpadding=0>
<form action=/boaform/admin/formFilter method=POST name="formFilterAdd">

<br>
<tr>
	<td><font size=2>
	<b><% multilang("Direction"); %>: </b></font>
	</td>
	<td>
	<select name=dir>
		<option select value=0><% multilang("Outgoing"); %></option>
		<option value=1><% multilang("Incoming"); %></option>
	</select>
	</td>
</tr>

<tr>
	<td><font size=2>
	<b><% multilang("Source"); %> <% multilang("MAC Address"); %>: </b></font>
	</td>
	<td>
	<input type="text" name="srcmac" size="15" maxlength="12">&nbsp;&nbsp;
	</td>
</tr>
<tr>
	<td><font size=2>
        <b><% multilang("Destination"); %> <% multilang("MAC Address"); %>: </b></font>
        </td>
        <td>
        <input type="text" name="dstmac" size="15" maxlength="12">&nbsp;&nbsp;
	</td>
</tr>
<tr>
	<td><font size=2>
	<b>	<% multilang("Rule Action"); %></b></font>
	</td>
	<td><font size=2>
	<input type="radio" name="filterMode" value="Deny" checked>&nbsp;&nbsp;<% multilang("Deny"); %>
	<input type="radio" name="filterMode" value="Allow">&nbsp;&nbsp;<% multilang("Allow"); %></b><br></font>
	</td>
	<td><font size=2>
	<input type="submit" value="<% multilang("Add"); %>" name="addFilterMac" onClick="return addClick()">&nbsp;&nbsp;
	<input type="hidden" value="/admin/fw-macfilter.asp" name="submit-url"></font>
	</td>
</tr>
<tr><td colspan=3><hr size=1 noshade align=top></td></tr>
</form>
</table>

<form action=/boaform/admin/formFilter method=POST name="formFilterDel">
	<table border="0" width=500>
	<tr><font size=2><b><% multilang("Current Filter Table"); %>:</b></font></tr>
	<% macFilterList(); %>
	</table>
	<br>
	<input type="submit" value="<% multilang("Delete Selected"); %>" name="deleteSelFilterMac" onClick="return deleteClick()">&nbsp;&nbsp;
	<input type="submit" value="<% multilang("Delete All"); %>" name="deleteAllFilterMac" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
	<input type="hidden" value="/admin/fw-macfilter.asp" name="submit-url">
	<script>
		<% checkWrite("macFilterNum"); %>
	</script>
</form>

</blockquote>
</body>
</html>
