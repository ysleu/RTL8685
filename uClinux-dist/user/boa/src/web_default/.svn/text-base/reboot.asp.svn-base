<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Commit and Reboot"); %></title>
<SCRIPT>
function saveClick()
{
   if ( !confirm('Do you really want to commit the current settings?') ) {
	return false;
  }
  else
	return true;
}

function resetClick()
{
   if ( !confirm('Do you really want to reset the current settings to default?') ) {
	return false;
  }
  else
	return true;
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Commit and Reboot"); %></font></h2>

<form action=/boaform/admin/formReboot method=POST name="cmboot">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to commit changes to system memory and reboot your system."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>
<!--
  <tr>
      <td width="30%"><font size=2><b>Reboot from:</b>
      <select size="1" name="rebootMode">
           <option selected value=0>Last Configuration</option>
           <option value=1>Default Configuration</option>
           <option value=2>Upgrade Configuration</option>
      </select>
      </td>
  </tr>
-->
</table>
  <br>
      <input type="submit" value="<% multilang("Commit and Reboot"); %>" name="save" onclick="return saveClick()">&nbsp;&nbsp;
<!--	// Jenny,  buglist B031, B032, remove reset to default button from commit/reboot webpage
      <input type="submit" value="Reset to Default" name="reset" onclick="return resetClick()">
      <input type="submit" value="Reboot" name="reboot">
      <input type="hidden" value="/reboot.asp" name="submit-url">
  <script>
-->
 </form>
</blockquote>
</body>

</html>
