<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Port-Based Filter"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
function saveChanges()
{
	var ptmap = 0;
	var pmchkpt = document.getElementById("tbl_pmap");

	if (pmchkpt) {
		with (document.forms[0]) {
			for(var i = 0; i < 14; i ++) if(chkpt[i].checked == true) ptmap |= (0x1 << i);
			dhcpPortFilter.value = ptmap;
		}
	}
	return true;
}

function on_init()
{
	return true;
}
</SCRIPT>
</head>


<body onLoad="on_init();">
<blockquote>
<h2><font color="#0000FF"><% multilang("Port-Based Filter"); %></font></h2>

<table border=0 width="480" cellspacing=0 cellpadding=0>
  <tr><td><font color="#00FFFF" size=2>
 <% multilang("This page is used to configure the Port-Based Filtering."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<form action=/boaform/formmacBase method=POST name="stbIp">
	<% ShowPortBaseFiltering(); %>	
	<input type="submit" value="<% multilang("Apply Changes"); %>" name="save" onClick="return saveChanges()">&nbsp;&nbsp;
	<input type="hidden" value="/portBaseFilterDhcp.asp" name="submit-url">
	<input type="hidden" name="dhcpPortFilter" value=0>
	<input type="button" value="<% multilang("Close"); %>" name="close" onClick="javascript: window.close();">

<script>
	var mode = <% getInfo("dhcp_port_filter"); %>;	
	var pmchkpt = document.getElementById("tbl_pmap");
	with ( document.forms[0] )
	{
		//port mapping
		if (pmchkpt)
			for(var i = 0; i < 14; i ++) chkpt[i].checked = (mode & (0x1 << i));
	}
</script>

</form>
</blockquote>
</body>

</html>
