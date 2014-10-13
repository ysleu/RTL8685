<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta HTTP-EQUIV='Pragma' CONTENT='no-cache'>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Password"); %><% multilang(" Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>

function saveChanges()
{
/*   if ( document.password.username.value.length == 0 ) {
	if ( !confirm('User account is empty.\nDo you want to disable the password protection?') ) {
		document.password.username.focus();
		return false;
  	}
	else
		return true;
  }*/

   if ( document.password.newpass.value != document.password.confpass.value) {
	alert('Password is not matched. Please type the same password between \'new\' and \'confirmed\' box.');
	document.password.newpass.focus();
	return false;
  }

//  if ( document.password.username.value.length > 0 &&
//  		document.password.newpass.value.length == 0 ) {
  if (	document.password.newpass.value.length == 0) {
	alert('Password cannot be empty. Please try it again.');
	document.password.newpass.focus();
	return false;
  }

/*  if ( includeSpace(document.password.username.value)) {
	alert('Cannot accept space character in user name. Please try it again.');
	document.password.username.focus();
	return false;
  }*/

  if (includeSpace(document.password.newpass.value)) {
	alert('Cannot accept space character in password. Please try it again.');
	document.password.newpass.focus();
	return false;
  }
  if (checkString(document.password.newpass.value) == 0) {
	alert('Invalid password !');
	document.password.newpass.focus();
	return false;
  }

  return true;
}

</SCRIPT>
</head>

<BODY>
<blockquote>
<h2><font color="#0000FF"><% multilang("Password"); %><% multilang(" Configuration"); %></font></h2>

<form action=/boaform/formPasswordSetup method=POST name="password">
 <table border="0" cellspacing="4" width="500">
  <tr><td><font size=2>
 <% multilang("This page is used to set the account to access the web server of your Router. Empty user name and password will disable the protection."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
  </table>

  <table border="0" cellspacing="4" width="500">
    <tr>
      <td width="20%"><font size=2><b><% multilang("User"); %><% multilang(" Name"); %>:</b>
      <select size="1" name="userMode">
      <% checkWrite("userMode"); %>
      </select>
      </td>
    </tr>
    <tr>
      <td width="20%"><font size=2><b><% multilang("Old Password"); %>:</b></td>
      <td width="50%"><font size=2><input type="password" name="oldpass" size="20" maxlength="30"></td>
    </tr>
    <tr>
      <td width="20%"><font size=2><b><% multilang("New Password"); %>:</b></td>
      <td width="50%"><font size=2><input type="password" name="newpass" size="20" maxlength="30"></td>
    </tr>
    <tr>
      <td width="20%"><font size=2><b><% multilang("Confirmed Password"); %>:</b></td>
      <td width="50%"><font size=2><input type="password" name="confpass" size="20" maxlength="30"></td>
    </tr>
  </table>
   <input type="hidden" value="/password.asp" name="submit-url">
  <p><input type="submit" value="<% multilang("Apply Changes"); %>" name="save" onClick="return saveChanges()">&nbsp;&nbsp;
  <input type="reset" value="  <% multilang("Reset"); %>  " name="reset"></p>
</form>
<blockquote>
</body>
</html>


