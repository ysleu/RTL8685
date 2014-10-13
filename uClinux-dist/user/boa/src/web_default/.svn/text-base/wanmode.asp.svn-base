<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("WAN Mode Selection"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script language="javascript">

function SubmitWANMode()
{
	var wmmap = 0;

	with (document.forms[0])
	{	

		for(var i = 0; i < 4; i ++)
			if(wmchkbox[i].checked == true)
				//wmmap |= (0x1 << i);
				wmmap |= wmchkbox[i].value;
			
		if(wmmap == 0 || wmmap == wanmode)
			return false;
		wan_mode.value = wmmap;
	}

	return confirm("It needs rebooting to change WAN mode.");
}
</script>

</head>
<BODY>
<blockquote>
<h2><font color="#0000FF"><% multilang("WAN Mode"); %></font></h2>
<form action=/boaform/admin/formWanMode method=POST name="wanmode">
<table border="0" cellspacing="4" width="800">
  <tr><td><font size=2>
    <% multilang("This page is used to configure which WAN to use of your Router."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border="0" cellspacing="4" width="800">
	<tr>
		<td>
			<b><% multilang("WAN Mode"); %>:</b>
			<span <% checkWrite("wan_mode_atm"); %>><input type="checkbox" value=1 name="wmchkbox">ATM</span>
			<span <% checkWrite("wan_mode_ethernet"); %>><input type="checkbox" value=2 name="wmchkbox">Ethernet</span>
			<span <% checkWrite("wan_mode_ptm"); %>><input type="checkbox" value=4 name="wmchkbox">PTM</span>
			<span <% checkWrite("wan_mode_wireless"); %>><input type="checkbox" value=16 name="wmchkbox" <% ShowWanMode("wlan"); %>>Wireless</span>&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="hidden" name="wan_mode" value=0>
			<input type="submit" value="Submit" name="submitwan" onClick="return SubmitWANMode()">
		</td>
	</tr>
	<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<BR>
<input type="hidden" value="/wanmode.asp" name="submit-url">
<BR>
<BR>
<script>
	var wanmode = <% getInfo("wan_mode"); %>;

	if((wanmode & 1) == 1)
		document.wanmode.wmchkbox[0].checked = true;

	if((wanmode & 2) == 2)
		document.wanmode.wmchkbox[1].checked = true;
	
	if((wanmode & 4) == 4)
		document.wanmode.wmchkbox[2].checked = true;

	if((wanmode & 16) == 16)
		document.wanmode.wmchkbox[3].checked = true;
</script>
</form>
</blockquote>
</body>
</html>
