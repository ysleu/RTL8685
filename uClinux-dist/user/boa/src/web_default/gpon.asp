<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("GPON Settings"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script>

function applyclick()
{
	/*LOID*/
	if (document.formgponconf.fmgpon_loid.value=="") {
		alert('Loid password cannot be empty!');
		document.formgponconf.fmgpon_loid.focus();
		return false;
	}
	/*loid password*/
	if (document.formgponconf.fmgpon_loid_password.value=="") {
		alert('Loid password cannot be empty!');
		document.formgponconf.fmgpon_loid_password.focus();
		return false;
	}
	if (includeSpace(document.formgponconf.fmgpon_loid_password.value)) {
		alert('Cannot accept space character in Password.');
		document.formgponconf.fmgpon_loid_password.focus();
		return false;
	}
	if (checkString(document.formgponconf.fmgpon_loid_password.value) == 0) {
		alert('Invalid Password.');
		document.formgponconf.fmgpon_loid_password.focus();
		return false;
	}
	/*password*/
	if (document.formgponconf.fmgpon_password.value=="") {
		alert('PLOAM password cannot be empty!');
		document.formgponconf.fmgpon_password.focus();
		return false;
	}
	if (includeSpace(document.formgponconf.fmgpon_password.value)) {
		alert('Cannot accept space character in Password.');
		document.formgponconf.fmgpon_password.focus();
		return false;
	}
	if (checkString(document.formgponconf.fmgpon_password.value) == 0) {
		alert('Invalid Password.');
		document.formgponconf.fmgpon_password.focus();
		return false;
	}
	if( !(document.formgponconf.fmgpon_password.value.length==10) )
	{
		alert('PLOAM password should be 10 characters!');
		document.formgponconf.fmgpon_password.focus();
		return false;
	}

	/*serial number*/
	if( !(document.formgponconf.fmgpon_sn.value.length==12) )
	{
		alert('Serial number should be 12 characters!');
		document.formgponconf.fmgpon_sn.focus();
		return false;
	}
	return true;
}
</script>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("GPON Settings"); %></font></h2>
<form action=/boaform/admin/formgponConf method=POST name="formgponconf">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to configure the parameters for your GPON network access."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>

<tr>
      <td width="30%"><font size=2><b><% multilang("LOID"); %>:</b></td>
      <td width="70%"><input type="text" name="fmgpon_loid" size="24" maxlength="24" value="<% fmgpon_checkWrite("fmgpon_loid"); %>"></td>
  </tr>
<tr>
      <td width="30%"><font size=2><b><% multilang("LOID Password"); %>:</b></td>
      <td width="70%"><input type="text" name="fmgpon_loid_password" size="12" maxlength="12" value="<% fmgpon_checkWrite("fmgpon_loid_password"); %>"></td>
  </tr>
  
  <tr>
      <td width="30%"><font size=2><b><% multilang("PLOAM Password"); %>:</b></td>
      <td width="70%"><input type="text" name="fmgpon_password" size="10" maxlength="10" value="<% fmgpon_checkWrite("fmgpon_password"); %>" </td>
  </tr>
  <tr>
      <td width="30%"><font size=2><b><% multilang("Serial Number"); %>:</b></td>
      <td width="70%"><input type="text" name="fmgpon_sn" size="12" maxlength="12" value="<% fmgpon_checkWrite("fmgpon_sn"); %>"></td>
  </tr>
</table>
<br>
      <input type="submit" value="<% multilang("Apply Changes"); %>" name="apply" onClick="return applyclick()">&nbsp;&nbsp;
      <input type="hidden" value="/gpon.asp" name="submit-url">
</form>
</blockquote>
</body>
</html>
