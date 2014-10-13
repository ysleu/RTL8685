<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>Ping <% multilang("Diagnostics"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
function goClick()
{
	if (!checkHostIP(document.ping.pingAddr, 1))
		return false;
/*	if (document.ping.pingAddr.value=="") {
		alert("Enter host address !");
		document.ping.pingAddr.focus();
		return false;
	}
	
	return true;*/
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">Ping <% multilang("Diagnostics"); %></font></h2>

<form action=/boaform/formPing method=POST name="ping">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to send ICMP ECHO_REQUEST packets to network host. The diagnostic result will then be displayed."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>

  <tr>
      <td width="30%"><font size=2><b><% multilang("Host Address"); %>: </b></td>
      <td width="70%"><input type="text" name="pingAddr" size="15" maxlength="30"></td>
  </tr>

</table>
  <br>
      <input type="submit" value=" <% multilang("Go"); %> ! " name="go" onClick="return goClick()">
      <input type="hidden" value="/ping.asp" name="submit-url">
 </form>
</blockquote>
</body>

</html>
