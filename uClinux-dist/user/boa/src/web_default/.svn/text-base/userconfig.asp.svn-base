<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta HTTP-EQUIV='Pragma' CONTENT='no-cache'>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("User Account"); %><% multilang(" Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
selected=0;
sdefault = 0;

function saveChanges()
{
  /*if (document.userconfig.username.value == "admin" ||
  		document.userconfig.username.value == "user") {
	alert('Conflict user name!');
	document.userconfig.newpass.focus();
	return false;
  }*/
  if (document.userconfig.username.value.length > 0 &&
  		document.userconfig.newpass.value.length == 0) {
	alert('Password cannot be empty. Please try it again.');
	document.userconfig.newpass.focus();
	return false;
  }

   if (document.userconfig.newpass.value != document.userconfig.confpass.value) {
	alert('Password is not matched. Please type the same password between \'new\' and \'confirmed\' box.');
	document.userconfig.newpass.focus();
	return false;
  }

  if (includeSpace(document.userconfig.username.value)) {
	alert('Cannot accept space character in user name. Please try it again.');
	document.userconfig.username.focus();
	return false;
  }
  if (checkString(document.userconfig.username.value) == 0) {
	alert('Invalid user name !');
	document.userconfig.username.focus();
	return false;
  }

  if (includeSpace(document.userconfig.newpass.value)) {
	alert('Cannot accept space character in password. Please try it again.');
	document.userconfig.newpass.focus();
	return false;
  }
  if (checkString(document.userconfig.newpass.value) == 0) {
	alert('Invalid password !');
	document.userconfig.newpass.focus();
	return false;
  }

  if (sdefault == 1)
		document.userconfig.privilege.disabled = false;
  return true;
}

function modifyClick()
{
	if (!selected) {
		alert("Please select an entry to modify !");
		return false;
	}

	/*if (document.userconfig.oldpass.value != document.userconfig.hiddenpass.value) {
		alert('Incorrect old password. Please try it again.');
		document.userconfig.oldpass.focus();
		return false;
	}*/

	return saveChanges();
}

function delClick()
{
	if (!selected) {
		alert("Please select an entry to delete !");
		return false;
	}
	if (document.userconfig.username.value == document.userconfig.suser.value ||
  		document.userconfig.username.value == document.userconfig.nuser.value) {
		alert('The account cannot be deleted!');
		return false;
	}
	return true;
}

//function postEntry(user, priv, pass)
function postEntry(user, priv)
{
	document.userconfig.privilege.value = priv;
	if (user == document.userconfig.suser.value || user == document.userconfig.nuser.value) {
		document.userconfig.privilege.disabled = true;
		sdefault = 1;
		//document.userconfig.username.disabled = true;
	}
	else {
		document.userconfig.privilege.disabled = false;
		//document.userconfig.username.disabled = false;
	}
	document.userconfig.oldpass.disabled = false;
	document.userconfig.username.value = user;
//	document.userconfig.hiddenpass.value = pass;
	selected = 1;
}

function disablePriv()
{
	document.userconfig.privilege.value = 0;
	document.userconfig.privilege.disabled = true;
}

function resetConfig()
{
//	disablePriv();
	document.userconfig.privilege.value = 0;
	document.userconfig.privilege.disabled = false;
	document.userconfig.oldpass.disabled = true;
}

function checkAction()
{
//	disablePriv();
//	if (document.userconfig.hiddenpass.value.length == 0)
	if (!selected)
		document.userconfig.oldpass.disabled = true;
}
</SCRIPT>
</head>

<BODY>
<blockquote>
<h2><font color="#0000FF"><% multilang("User Account"); %><% multilang(" Configuration"); %></font></h2>

<form action=/boaform/formAccountConfig method=POST name="userconfig">
 <table border="0" cellspacing="4" width="500">
  <tr><td><font size=2>
 <% multilang("This page is used to add user account to access the web server of the Router. Empty user name or password is not allowed."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
 </table>

 <table border="0" cellspacing="4" width="500">
    <tr>
      <td width="20%"><font size=2><b><% multilang("User"); %><% multilang(" Name"); %>:</b></td>
      <td width="50%"><font size=2><input type="text" name="username" size="20" maxlength="30"></td>
    </tr>
    <tr>
      <td width="20%"><font size=2><b><% multilang("Privilege"); %>:</b></td>
      <td width="50%">
      <select size="1" name="privilege">
      <option value="0"><% multilang("User"); %></option>
      <option value="1"><% multilang("Support"); %></option>
      <option value="2"><% multilang("Admin"); %></option>
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
  <p><input type="submit" value="<% multilang("Add"); %>" name="adduser" onClick="return saveChanges()">
  <input type="submit" value="<% multilang("Modify"); %>" name="modify" onClick="return modifyClick()">
<input type="submit" value="<% multilang("Delete"); %>" name="deluser" onClick="return delClick()">
  <input type="reset" value="<% multilang("Reset"); %>" name="reset" onClick="resetConfig()"></p>
  <br><br> 
  
<table border=0 width="500">
  <tr><font size=2><b><% multilang("User Account"); %><% multilang(" Table"); %>:</b></font></tr>
  <% accountList(); %>
</table>
  <br>
   <input type="hidden" name="suser" value=<% getInfo("super-user"); %>>
   <input type="hidden" name="nuser" value=<% getInfo("normal-user"); %>>
   <input type="hidden" value="/userconfig.asp" name="submit-url">
<script>
	checkAction();
</script>  
</form>
<blockquote>
</body>
</html>


