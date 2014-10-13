
<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Logout"); %></title>

<SCRIPT>
function confirmlogout()
{
   if ( !confirm('do you confirm to logout?') ) {
	return false;
  }
  else
	return true;
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Logout"); %></font></h2>

<form action=/boaform/admin/formLogout method=POST name="cmlogout">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to logout from the Router."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
  <br>
      <input type="submit" value="<% multilang("Logout"); %>" name="save" onclick="return confirmlogout()">&nbsp;&nbsp;
      <input type="hidden" value="/admin/logout.asp" name="submit-url">
 </form>
</blockquote>
</body>

</html>

