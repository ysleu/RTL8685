<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% checkWrite("adsl_set_title"); %></title>
<SCRIPT>

function dhcpTblClick(url) {
	openWindow(url, 'DHCPTbl' );
}

function adsltoneClick(url)
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

	window.open( url, 'ADSLTONETbl', settings );
}

function saveChanges()
{               
	if (document.set_adsl.glite.checked == false
	   && document.set_adsl.gdmt.checked == false
	   && document.set_adsl.t1413.checked == false
	   && document.set_adsl.adsl2.checked == false
<% initPage("vdsl2_check"); %>
	   && document.set_adsl.adsl2p.checked == false) {
		alert("ADSL modulation cannot be empty.");
		return false;
	}

<% initPage("vdsl2_check_profile"); %>

	return true;
}

<% initPage("vdsl2_updatefn"); %>

</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% checkWrite("adsl_set_title"); %></font></h2>

<form action=/boaform/formSetAdsl method=POST name=set_adsl>
<table border=0 width=500 cellspacing=4 cellpadding=0>
	<tr><td><font size=2>
	  <% multilang("This page is used to configure the parameters for the bands of your Router."); %>
	</font></td></tr>
	<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width=500 cellspacing=4 cellpadding=0>
<tr>
	<th align=left width=30%><font size=2><% checkWrite("xdsl_type"); %> <% multilang("Modulation"); %>:</th>
	<td width=70%></td>
</tr>
<tr <% checkWrite("anxb-cap"); %>>
	<th></th>
	<td><font size=2><input type=checkbox name=glite value=1>G.Lite</td>
</tr>
<tr>
	<th></th>
	<td><font size=2><input type=checkbox name=gdmt value=1>G.Dmt</td>
</tr>
<tr <% checkWrite("anxb-cap"); %>>
	<th></th>
	<td><font size=2><input type=checkbox name=t1413 value=1>T1.413</td>
</tr>
<tr>
	<th></th>
	<td><font size=2><input type=checkbox name=adsl2 value=1>ADSL2</td>
</tr>
<tr>
	<th></th>
	<td><font size=2><input type=checkbox name=adsl2p value=1>ADSL2+</td>
</tr>
<% initPage("vdsl2_opt"); %>
<tr <% checkWrite("anxb-cap"); %>>
	<th align=left width=30%><font size=2>AnnexL <% multilang("Option"); %>:</th>
	<td width=70%><font size=2>(<% multilang("Note: Only ADSL 2 supports AnnexL"); %>)</td>
</tr>
<tr <% checkWrite("anxb-cap"); %>>
	<th></th>
	<td><font size=2><input type=checkbox name=anxl value=1><% multilang("Enabled"); %></td>
</tr>
<tr <% checkWrite("anxb-cap"); %>>
	<th align=left width=30%><font size=2>AnnexM <% multilang("Option"); %>:</th>
	<td width=70%><font size=2>(<% multilang("Note: Only ADSL 2/2+ support AnnexM"); %>)</td>
</tr>
<tr <% checkWrite("anxb-cap"); %>>
	<th></th>
	<td><font size=2><input type=checkbox name=anxm value=1><% multilang("Enabled"); %></td>
</tr>
<tr <% checkWrite("ginp-cap"); %>>
	<th align=left width=30%><font size=2>G.INP <% multilang("Option"); %>:</font></th>
	<td></td>
</tr>
<tr <% checkWrite("ginp-cap"); %>>
	<th></th>
	<td><font size=2><input type=checkbox name=ginp value=1><% multilang("Enabled"); %></font></td>
</tr>
<% initPage("vdsl2_profile"); %>
<tr>
	<th align=left><font size=2>ADSL <% multilang("Capability"); %>:</th>
	<td></td>
</tr>
<tr>
	<th></th>
	<td><font size=2><input type=checkbox name=bswap value=1><% multilang("Enable"); %> Bitswap</td>
</tr>
<tr>
	<th></th>
	<td><font size=2><input type=checkbox name=sra value=1><% multilang("Enable"); %> SRA</td>
</tr>

<% initPage("adsl_tone_mask"); %>
<% initPage("adsl_psd_mask"); %>
<% initPage("psd_msm_mode"); %>

</table>
  <br>
	<input type=submit value="<% multilang("Apply Changes"); %>" name="save" onClick="return saveChanges()">
	<input type=hidden value="/admin/adsl-set.asp" name="submit-url">
<script>
	<% initPage("setdsl"); %>
</script>
</form>
</blockquote>
</body>

</html>
