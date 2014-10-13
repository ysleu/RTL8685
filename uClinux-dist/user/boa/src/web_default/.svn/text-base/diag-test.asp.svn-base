<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("ADSL Connection Diagnostics"); %></title>
</head>
<script type="text/javascript" src="share.js">
</script>
<script>
var initInf;

function itfSelected()
{
	initInf = document.diagtest.wan_if.value;
}
</script>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("ADSL Connection Diagnostics"); %></font></h2>

<form action=/boaform/formDiagTest method=POST name=diagtest>
<table border=0 width=500 cellspacing=4 cellpadding=0>
	<tr><td><font size=2>
	  <% multilang("The Router is capable of testing your connection. The individual tests are listed below. If a test displays a fail status, click 'Go' button again to make sure the fail status is consistent."); %>
	</font></td></tr>
	<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr>
    <td><font size=2><% multilang("Select the ADSL Connection"); %>: 
		<select name="wan_if"  onChange="itfSelected()">
		<% if_wan_list("adsl"); %>
		</select>
    </td>
    <td><input type=submit value="<% multilang("Go"); %>" name="start"></td>
  </tr>
</table>
<p>
<!-- Nic and switch are always linked!
<table width=400 border=0>
	<% lanTest(); %>
</table>
-->
<p>
<table width=400 border=0>
	<% adslTest(); %>
</table>
<p>
<table width=400 border=0>
	<% internetTest(); %>
</table>
  <br>
<input type=hidden value="/diag-test.asp" name="submit-url">
</form>
<script>
	<% initPage("diagTest"); %>
</script>
</blockquote>
</body>

</html>
