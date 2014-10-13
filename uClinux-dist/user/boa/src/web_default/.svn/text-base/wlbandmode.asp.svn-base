<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Wireless Band Mode"); %><% multilang(" Configuration"); %></title>
</head>
<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Wireless Band Mode"); %><% multilang(" Configuration"); %></font></h2>


<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><font size=2>
  <!--Support switchable 802.11n dual-band radio frequency (2.4GHz/5GHz). -->
  <% multilang("This page is used to switch 802.11n single-band or dual-band radio frequency."); %>
  </tr>
  <tr><hr size=1 noshade align=top></tr>
</table>
<form action=/boaform/admin/formWlanBand2G5G method=POST name="fmWlBandMode">
<table border="0" width=500>
<!--
	<tr>
		<td width ="35%" valign="top">
		<input type="radio" value="0" name="wlBandMode" onClick="" ></input>
		<font size=2> <b> 2.4GHz Only: </b> </font>
		</td>
		<td>
			<font size=2>This mode supports 802.11 b/g/n wireless network connection.</font>
		</td>
	</tr>
	<td colspan="2" height="10"></tr>
	<tr>
		<td width ="35%" valign="top">
		<input type="radio" value="1" name="wlBandMode" onClick="" ></input>
		<font size=2> <b> 5GHz Only: </b> </font>
		</td>
		<td>
			<font size=2>This mode supports both 802.11 a/n wireless network connection.</font>
		</td>
	</tr>
	<td colspan="2" height="10"></tr>
-->	
	<tr>
		<td width ="35%" valign="top">
		<input type="radio" value="1" name="wlBandMode" onClick="" ></input>
		<font size=2> <b> <% multilang("Signle Band"); %>: </b> </font>
		</td>
		<td>
			<font size=2><% multilang("This mode can support single mode by 2x2."); %></font>
		</td>
	</tr>
	<tr><td colspan="2" height="10"></tr>
<% checkWrite("onoff_dmdphy_comment_start"); %> 
	<tr>
		<td width ="35%" valign="top">
		<input type="radio" value="0" name="wlBandMode" onClick="" ></input>
		<font size=2> <b> <% multilang("Dual Band"); %>: </b> </font>
		</td>
		<td>
			<font size=2><% multilang("This mode can simultaneously support 802.11 a/b/g/n wireless network connection."); %></font>
		</td>
	</tr>
<% checkWrite("onoff_dmdphy_comment_end"); %> 

</table>
<script>
	wlBandMode = <% checkWrite("wlanBand2G5GSelect"); %> ;
	var radioIndex=0;
	while(document.fmWlBandMode.wlBandMode[radioIndex])
	{
		if(document.fmWlBandMode.wlBandMode[radioIndex].value == wlBandMode)
		{
			document.fmWlBandMode.wlBandMode[radioIndex].defaultChecked= true;
			document.fmWlBandMode.wlBandMode[radioIndex].checked= true;
			break;
		}
		radioIndex++;
	}
</script>
  <input type="hidden" value="/admin/wlbandmode.asp" name="submit-url">
  <p><input type="submit" value="<% multilang("Apply Changes"); %>" name="apply">
&nbsp;&nbsp;
  <input type="reset" value="<% multilang("Reset"); %>" name="set" >
&nbsp;&nbsp;
</form>
</blockquote>
</font>
</body>

</html>
