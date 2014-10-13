<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Domain Blocking"); %><% multilang(" Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>

function addClick()
{
	if (document.domainblk.blkDomain.value=="") {
		alert("Please enter the Blocked Domain !");
		document.domainblk.blkDomain.focus();
		return false;
	}
	
	if ( document.domainblk.blkDomain.value.length == 0 ) {
		if ( !confirm('Domain string is empty.\nPlease enter the blocked Domain') ) {
			document.domainblk.blkDomain.focus();
			return false;
  		}
		else
			return true;
  	}
  	
  	if ( includeSpace(document.domainblk.blkDomain.value)) {
		alert('Cannot accept space character in Blocked Domain. Please try it again.');
		document.domainblk.blkDomain.focus();
		return false;
 	}
	if (checkString(document.domainblk.blkDomain.value) == 0) {
		alert('Invalid Blocked Domain !');
		document.domainblk.blkDomain.focus();
		return false;
	}
  	
	return true;
}


	
function disableDelButton()
{
  if (verifyBrowser() != "ns") {
	disableButton(document.domainblk.delDomain);
	disableButton(document.domainblk.delAllDomain);
  }
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Domain Blocking"); %><% multilang(" Configuration"); %></font></h2>

<form action=/boaform/formDOMAINBLK method=POST name="domainblk">
<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to configure the Blocked domain. Here you can add/delete the blocked domain."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=0 cellpadding=0>
  
  <tr>
	<td><font size=2><b><% multilang("Domain Blocking"); %>:</b></td>
	<td><font size=2>
		<input type="radio" value="0" name="domainblkcap" <% checkWrite("domainblk-cap0"); %>><% multilang("Disable"); %>&nbsp;&nbsp;
		<input type="radio" value="1" name="domainblkcap" <% checkWrite("domainblk-cap1"); %>><% multilang("Enable"); %>
	</td>
	<td><input type="submit" value="<% multilang("Apply Changes"); %>" name="apply">&nbsp;&nbsp;</td>
  </tr>  
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

	<font size=2><b><% multilang("Domain"); %>:</b>
	<input type="text" name="blkDomain" size="15" maxlength="50">&nbsp;&nbsp;
	<input type="submit" value="<% multilang("Add"); %>" name="addDomain" onClick="return addClick()">
<br>
<br>
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><font size=2><b><% multilang("Domain Blocking"); %><% multilang(" Configuration"); %>:</b></font></tr>
  <% showDOMAINBLKTable(); %>
</table>
<br>
	<input type="submit" value="<% multilang("Delete Selected"); %>" name="delDomain" onClick="return deleteClick()">&nbsp;&nbsp;
	<input type="submit" value="<% multilang("Delete All"); %>" name="delAllDomain" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
	<input type="hidden" value="/domainblk.asp" name="submit-url">
 <script>
 	<% checkWrite("domainNum"); %>
  </script>
</form>
</blockquote>
</body>

</html>
