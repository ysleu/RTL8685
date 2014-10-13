<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("EPON Settings"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script>
function applyclick()
{
	var mac_addr = document.formepon_llid_mac_mapping.elements["mac_addr[]"];

	for(var i=0;i<mac_addr.length;i++)
	{
		if ( (mac_addr[i].value=="") || (!mac_addr[i].value.contains(":")) || (mac_addr[i].value.length!=17))
		{
				alert("Invalid mac address!");
				mac_addr[i].focus();
				return false;
		}
	}
	return true;
}
</script>
</head>
<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("EPON Settings"); %></font></h2>
<form action=/boaform/admin/formeponConf method=POST name="formeponconf">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to configure the parameters for your EPON network access."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr>
      <td width="30%"><font size=2><b><% multilang("LOID"); %>:</b></td>
      <td width="70%"><input type="text" name="fmepon_loid" size="24" maxlength="24" value="<% fmepon_checkWrite("fmepon_loid"); %>"></td>
  </tr>
<tr>
      <td width="30%"><font size=2><b><% multilang("Password"); %>:</b></td>
      <td width="70%"><input type="text" name="fmepon_passwd" size="12" maxlength="12" value="<% fmepon_checkWrite("fmepon_passwd"); %>"></td>
  </tr>

</table>
      <input type="submit" value="<% multilang("Apply Changes"); %>" name="apply" onclick="return applyclick()">&nbsp;&nbsp;
      <input type="hidden" value="/epon.asp" name="submit-url">
</form>
<table border=0 width="600" cellspacing=4 cellpadding=0>
  <tr><font size=2><b><% multilang("LLID MAC mappping Table"); %>:</b></font></tr>
<form action=/boaform/admin/formepon_llid_mac_mapping method=POST name="formepon_llid_mac_mapping">
  <% showepon_LLID_MAC(); %> <br>
<tr><td>
      <input type="submit" value="<% multilang("Apply Changes"); %>" name="apply" onClick="return applyclick()">&nbsp;&nbsp;
      <input type="hidden" value="/epon.asp" name="submit-url">
</td></tr>
</form>
</table>
</blockquote>
</body>
</html>
