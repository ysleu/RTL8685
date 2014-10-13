<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Packet Dump"); %></title>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Packet Dump"); %></font></h2>

<form action=/boaform/formCapture method=POST name="ping">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
	<% multilang("This page is used to start or stop a Wireshark packet capture."); %><br>
    <% multilang("You need to return to this page to Stop it."); %><br>
	<a href ="http://www.tcpdump.org/tcpdump_man.html" target=_blank"><% multilang("Click here for the documentation of the additional arguments."); %></a>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

  <tr>
      <td width="30%"><font size=2><b><% multilang("Additional Arguments"); %>:</b></td>
      <td width="70%"><input type="text" name="tcpdumpArgs" value="-s 1500" size="50" maxlength="50"></td>
      <input type="hidden" value="yes" name="dostart">
  </tr>

</table>

  <br>
      <input type="submit" value="<% multilang("Start"); %>" name="start">
      <input type="hidden" value="/pdump.asp" name="submit-url">
 </form>
<p>

<form action=/boaform/formCapture method=POST name="ping">
      <input type="submit" value="<% multilang("Stop"); %>" name="stop">
      <input type="hidden" value="/pdump.asp" name="submit-url">
      <input type="hidden" value="no" name="dostart">
 </form>


</blockquote>
</body>

</html>
