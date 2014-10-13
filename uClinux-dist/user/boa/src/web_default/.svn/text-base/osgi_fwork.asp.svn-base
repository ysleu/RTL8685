<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Framework Info."); %></title>

</head>
<body>
<blockquote>

<h2><b><font color="#0000FF"><% multilang("Framework Info."); %></font></b></h2>

<table border=0 width="500" cellspacing=0 cellpadding=0>
<tr><td><font size=2>
 <% multilang("This page shows the OSGi framework information of the device."); %>
</font></td></tr>

<tr><td><hr size=1 noshade align=top><br></td></tr>
</table>

<form action=/boaform/admin/formStatus method=POST name="status2">
<table width=400 border=0>
  <tr>
    <td width=100% colspan="2" bgcolor="#008000"><font color="#FFFFFF" size=2><b><% multilang("OSGi Framework Information"); %></b></font></td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Framework Name"); %></b></td>
    <td width=60%><font size=2><% getOSGIInfo("fwname"); %></td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Framework Version"); %></b></td>
    <td width=60%><font size=2><% getOSGIInfo("fwver"); %></td>
  </tr>
   <tr bgcolor="#EEEEEE">
    <td width=40%><font size=2><b><% multilang("Framework Status"); %></b></td>
    <td width=60%><font size=2><% getOSGIInfo("fwstatus"); %></td>
  </tr>
</table>
</br>
 <% getOSGIBundleList("0"); %>
</form>
<br>


</blockquote>

</body>

</html>
