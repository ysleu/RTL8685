<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Interface Statisitcs"); %></title>
<script>
function resetClick() {
	with ( document.forms[0] ) {
		reset.value = 1;
		submit();
	}
}
</script>
</head>
<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Interface Statisitcs"); %></font></h2>

<table border=0 width="500" cellpadding=0>
  <tr><td><font size=2>
 <% multilang("This page shows the packet statistics for transmission and reception regarding to network interface."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<form action=/boaform/formStats method=POST name="formStats">
<table border="1" width="500">
	<% pktStatsList(); %>
</table>
  <br>
  <br><br>
  <input type="hidden" value="/stats.asp" name="submit-url">
  <input type="submit" value="<% multilang("Refresh"); %>" name="refresh">
  <input type="hidden" value="0" name="reset">
  <input type="button" onClick="resetClick()" value="<% multilang("Reset Statistics"); %>">
</form>
</blockquote>
</body>

</html>
