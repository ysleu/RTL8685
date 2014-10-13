<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Firmware Upgrade"); %></title>
<script>
function sendClicked()
{
	if (document.password.binary.value=="") {
		alert('Selected file cannot be empty!');
		document.password.binary.focus();
		return false;
	}
		
	if (!confirm('Do you really want to upgrade the firmware?'))
		return false;
	else
		return true;
}

</script>

</head>
<BODY>
<blockquote>
<h2><font color="#0000FF"><% multilang("Firmware Upgrade"); %></font></h2>
<form action=/boaform/admin/formUpload method=POST enctype="multipart/form-data" name="password">
<table border="0" cellspacing="4" width="500">
 <tr><td><font size=2>
 <% multilang("This page allows you upgrade the firmware to the newer version. Please note that do not power off the device during the upload because this make the system unbootable."); %>
 </font></td></tr>
 <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border="0" cellspacing="4" width="500">
  <tr>
      <td><font size=2><input type="file" value="<% multilang("Choose File"); %>" name="binary" size=20></td>
  </tr>
  </table>
    <p> <input type="submit" value="<% multilang("Upgrade"); %>" name="send" onclick="return sendClicked()">&nbsp;&nbsp;
	<input type="reset" value="<% multilang("Reset"); %>" name="reset">
    </p>
 </form>
 </blockquote>
</body>
</html>
