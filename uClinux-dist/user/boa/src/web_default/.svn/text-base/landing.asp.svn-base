<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Landing Page"); %><% multilang(" Configuration"); %></title>
<script>
function saveClick()
{		
	alert("Please commit and reboot this system for take effect the Landing Page!");
}

</script>

</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Landing Page"); %><% multilang(" Configuration"); %></font></h2>

<form action=/boaform/formLanding method=POST name="landing">
<table border=0 width="500" cellspacing=0 cellpadding=0> 
  <tr><td><font size=2>
    <% multilang("This page is used to configure the time interval of Landing Page."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=0 cellpadding=0> 
  <tr>
      <td width="30%"><font size=2><b><% multilang("Time Interval"); %>:</b></font></td>
      <td width="70%"><input type="text" name="interval" size="15" maxlength="15" value=<% getInfo("landing-page-time"); %>>(<% multilang("seconds"); %>)</td>
  </tr>   
</table>
      <br>
      <input type="submit" value="<% multilang("Apply Changes"); %>" name="save" onClick="return saveClick()">&nbsp;&nbsp;
      <input type="hidden" value="/landing.asp" name="submit-url">

</form>
</blockquote>
</body>

</html>
