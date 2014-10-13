<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>ACL <% multilang("Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
function postACL( enable, interface, aclIP )
{
	document.acl.enable.checked = enable;		
	document.acl.interface.value = interface;	
	document.acl.aclIP.value = aclIP;	
}

function addClick()
{
/*	if (document.acl.aclIP.value=="") {
		alert("Enter Source Network ID !");
		document.acl.aclIP.focus();
		return false;
	}

	if (document.acl.aclMask.value=="") {
		alert("Enter Subnet Mask !");
		document.acl.aclMask.focus();
		return false;
	}
	
	if ( validateKey( document.acl.aclIP.value ) == 0 ) {
		alert("Invalid Source value.");
		document.acl.aclIP.focus();
		return false;
	}
	if( IsLoopBackIP( document.acl.aclIP.value)==1 ) {
		alert("Invalid IP address value.");
		document.acl.aclIP.focus();
		return false;
  	}
	if ( !checkDigitRange(document.acl.aclIP.value,1,0,223) ) {
		alert('Invalid Source range in 1st digit. It should be 0-223.');
		document.acl.aclIP.focus();
		return false;
	}
	if ( !checkDigitRange(document.acl.aclIP.value,2,0,255) ) {
		alert('Invalid Source range in 2nd digit. It should be 0-255.');
		document.acl.aclIP.focus();
		return false;
	}
	if ( !checkDigitRange(document.acl.aclIP.value,3,0,255) ) {
		alert('Invalid Source range in 3rd digit. It should be 0-255.');
		document.acl.aclIP.focus();
		return false;
	}
	if ( !checkDigitRange(document.acl.aclIP.value,4,0,254) ) {
		alert('Invalid Source range in 4th digit. It should be 0-254.');
		document.acl.aclIP.focus();
		return false;
	}	

	if ( validateKey( document.acl.aclMask.value ) == 0 ) {
		alert("Invalid Source value.");
		document.acl.aclMask.focus();
		return false;
	}
	if( IsLoopBackIP( document.acl.aclMask.value)==1 ) {
		alert("Invalid IP address value.");
		document.acl.aclMask.focus();
		return false;
  	}
	if ( !checkDigitRange(document.acl.aclMask.value,1,0,255) ) {
		alert('Invalid Source range in 1st digit. It should be 0-255.');
		document.acl.aclMask.focus();
		return false;
	}
	if ( !checkDigitRange(document.acl.aclMask.value,2,0,255) ) {
		alert('Invalid Source range in 2nd digit. It should be 0-255.');
		document.acl.aclMask.focus();
		return false;
	}
	if ( !checkDigitRange(document.acl.aclMask.value,3,0,255) ) {
		alert('Invalid Source range in 3rd digit. It should be 0-255.');
		document.acl.aclMask.focus();
		return false;
	}
	if ( !checkDigitRange(document.acl.aclMask.value,4,0,255) ) {
		alert('Invalid Source range in 4th digit. It should be 0-255.');
		document.acl.aclMask.focus();
		return false;
	}	
*/	
	if (!checkNetIP(document.acl.aclIP, 1))
		return false;
	if (!checkNetmask(document.acl.aclMask, 1))
		return false;
	return true;
}


	
function disableDelButton()
{
  if (verifyBrowser() != "ns") {
	disableButton(document.acl.delIP);
	disableButton(document.acl.delAllIP);
  }
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">ACL <% multilang("Configuration"); %></font></h2>

<form action=/boaform/admin/formACL method=POST name="acl">
<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to configure the IP Address for Access Control List. If ACL is enabled, only the IP address in the ACL Table can access CPE. Here you can add/delete the IP Address."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=0 cellpadding=0>
<input type="hidden" name="lan_ip" value=<% getInfo("lan-ip"); %>>
<input type="hidden" name="lan_mask" value=<% getInfo("lan-subnet"); %>>
  <tr>
      <td><font size=2><b>ACL <% multilang("Capability"); %>:</b></td>
      <td><font size=2>
      	<input type="radio" value="0" name="aclcap" <% checkWrite("acl-cap0"); %>><% multilang("Disable"); %>&nbsp;&nbsp;
     	<input type="radio" value="1" name="aclcap" <% checkWrite("acl-cap1"); %>><% multilang("Enable"); %>
      </td>
      <td><input type="submit" value="<% multilang("Apply Changes"); %>" name="apply">&nbsp;&nbsp; </td>
  </tr> 
</table>
 
 
<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=0 cellpadding=0> 
  <br>
  <tr>
      <td width="30%"><font size=2><b><% multilang("Enable"); %>:</b></td>
      <td width="70%"><input type="checkbox" name="enable" value="1" checked></td>
  </tr>
  
  <tr>
      <td width="30%"><font size=2><b><% multilang("Interface"); %>:</b></td>
      <td width="70%">
      <select size="1" name="interface">
      <option value="0"><% multilang("LAN"); %></option>
      <option value="1"><% multilang("WAN"); %></option>
      </select>
      </td>
  </tr>

  <tr>
      <td width="30%"><font size=2><b><% multilang("IP Address"); %>:</b></td>
      <td width="70%"><input type="text" name="aclIP" size="15" maxlength="15"></td>
  </tr>  
  
  <tr>
      <td width="30%"><font size=2><b><% multilang("Subnet Mask"); %>:</b></td>
      <td width="50%"><input type="text" name="aclMask" size="15" maxlength="15"></td>
      <td width="20%"><input type="submit" value="<% multilang("Add"); %>" name="addIP" onClick="return addClick()">&nbsp;&nbsp;</td>
  </tr>  
  
</table>
  
  <!--input type="submit" value="Update" name="updateACL" onClick="return addClick()">&nbsp;&nbsp;
  </tr-->
  
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><hr size=1 noshade align=top></td></tr>
  <tr><td><font size=2><b>ACL <% multilang("Table"); %>:</b></font></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <% showACLTable(); %>
</table>
  <br>
      <input type="submit" value="<% multilang("Delete Selected"); %>" name="delIP" onClick="return deleteClick()">&nbsp;&nbsp;
      <input type="submit" value="<% multilang("Delete All"); %>" name="delAllIP" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
      <input type="hidden" value="/admin/acl.asp" name="submit-url">
 <script>
 	<% checkWrite("aclNum"); %>
  </script>
</form>
</blockquote>
</body>

</html>
