<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Backup and Restore Settings"); %></title>
<script>
function resetClick()
{
	return confirm("Do you really want to reset the current settings to factory default?");
}

function uploadClick()
{		
   	if (document.saveConfig.binary.value.length == 0) {
		alert('<% multilang("Choose File"); %>!');
		document.saveConfig.binary.focus();
		return false;
	}
	return true;
}

</script>

</head>
<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Backup and Restore Settings"); %></font></h2>
  <table border="0" cellspacing="4" width="500">
  <tr><td><font size=2>
 <% multilang("This page allows you to backup current settings to a file or restore the settings from the file which was saved previously. Besides, you could reset the current settings to factory default."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
  </table>

  <table border="0" cellspacing="4" width="500">
  <form action=/boaform/formSaveConfig method=POST name="saveCSConfig">
  <tr>
    <td width="40%"><font size=2><b><% multilang("Backup Settings to File"); %>:</b></font></td>
    <td width="30%"><font size=2>
      <input type="submit" value="<% multilang("Backup"); %>..." name="save_cs">
    </font></tr>  
  </form>  

  <!--
  <form action=/boaform/formSaveConfig method=POST name="saveDSConfig">
  <tr>
    <td width="40%"><font size=2><b><% multilang("Backup Default Settings to File"); %>:</b></font></td>
    <td width="30%"><font size=2>
      <input type="submit" value="<% multilang("Backup"); %>..." name="save_ds">
    </font></tr>  
  </form>  

  <form action=/boaform/formSaveConfig method=POST name="saveHSConfig">
  <tr>
    <td width="40%"><font size=2><b><% multilang("Backup Hardware Settings to File"); %>:</b></font></td>
    <td width="30%"><font size=2>
      <input type="submit" value="<% multilang("Backup"); %>..." name="save_hs">
    </font></tr>  
  </form>  
  -->
  
  <form action=/boaform/formSaveConfig enctype="multipart/form-data" method=POST name="saveConfig">
  <tr>
    <td width="40%"><font size=2><b><% multilang("Restore Settings from File"); %>:</b></font></td>
    <td width="30%"><font size=2><input type="file" value="<% multilang("Choose File"); %>" name="binary" size=24></font></td>
    <td width="20%"><font size=2><input type="submit" value="<% multilang("Restore"); %>" name="load" onclick="return uploadClick()"></font></td>
    <input type="hidden" value="/saveconf.asp" name="submit-url">
  </tr>  
  </form> 
  
  <form action=/boaform/formSaveConfig method=POST name="resetConfig">
  <tr>
    <td width="70%"><font size=2><b><% multilang("Reset Settings to Default"); %>:</b></font></td>
    <td width="30%"><font size=2>
    <input type="submit" value="<% multilang("Reset"); %>" name="reset" onclick="return resetClick()"></font></td>
    <input type="hidden" value="/saveconf.asp" name="submit-url">
   </tr>
  </form>
</table>
</blockquote>
</body>
</html>
