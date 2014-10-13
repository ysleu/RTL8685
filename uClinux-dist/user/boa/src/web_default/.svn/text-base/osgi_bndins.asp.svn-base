<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Bundle Installation"); %></title>
<script>

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
<h2><font color="#0000FF"><% multilang("Bundle Installation"); %></font></h2>
  <table border="0" cellspacing="4" width="500">
  <tr><td><font size=2>
 <% multilang("This page allows you to install new bundle."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
  </table>

  <table border="0" cellspacing="4" width="500">
  
  <form action=/boaform/formOsgiUpload enctype="multipart/form-data" method=POST name="saveConfig">
  <tr>
    <td width="40%"><font size=2><b><% multilang("Install bundle from file"); %>:</b></font></td>
    <td width="30%"><font size=2><input type="file" value="<% multilang("Choose File"); %>" name="binary" size=24></font></td>
    <td width="20%"><font size=2><input type="submit" value="<% multilang("Install"); %>" name="load" onclick="return uploadClick()"></font></td>
    <input type="hidden" value="/osgi_bndins.asp" name="submit-url">
  </tr>  
  </form> 
  
</table>
</blockquote>
</body>
</html>
