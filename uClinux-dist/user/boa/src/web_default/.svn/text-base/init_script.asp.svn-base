<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("System Initial Script"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script language="javascript">
function openWindow(url, windowName)
{
	var wide=640;
	var high=800;
	if (document.all)
		var xMax = screen.width, yMax = screen.height;
	else if (document.layers)
		var xMax = window.outerWidth, yMax = window.outerHeight;
	else
	   var xMax = 640, yMax=800;

	var xOffset = (xMax - wide)/2;
	var yOffset = (yMax - high)/3;

	var settings = 'width='+wide+',height='+high+',screenX='+xOffset+',screenY='+yOffset+',top='+yOffset+',left='+xOffset+', resizable=yes, toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes';

	window.open( url, windowName, settings );
}

function ShowStartScriptClick(url)
{
	openWindow(url, 'ShowStartScript');
}

function ShowEndScriptClick(url)
{
	openWindow(url, 'ShowEndScript');
}

function confirmAction()
{
	return confirm("Are you sure to delete the script file?")
}
</script>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("System Initiating Scripts"); %></font></h2>

<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("Set scripts that are excuted in system initiating."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=8 cellpadding=0>
  <tr>
      <td colspan=4><font size=3><b>Init Start Script:</b></font></td>
      <td></td>
  </tr>
  <tr>
      <td colspan=4><font size=2>This script is used to run before system initiating.</font></td>
      <td></td>
  </tr>
  <tr>
		<form action=/boaform/formInitStartScript method=POST enctype="multipart/form-data" name="init_st_script">
		<td colspan=3><input type="file" value=<% multilang("Choose File"); %> name="start_text" size=36></td>
		<td><input type="submit" value=<% multilang("Upload"); %> name="start_upload"></td>
		</form>
  </tr>
  <tr valign="top">
		<td width=50>
			<input type="submit" value=<% multilang("Show Script Content"); %> name="start_show" onClick=ShowStartScriptClick("/StartScriptContent.asp")>&nbsp;
		</td>
		<td>
			<form action=/boaform/formInitStartScriptDel method=POST name="init_st_script_del" onSubmit="return confirmAction()">
			<input type="submit" value=<% multilang("Delete Script"); %> name="start_delete"></td>
			</form>
		</td>
		<td colspan=2>&nbsp;</td>
  </tr>
</table>

<hr size=1 noshade align=top>

<table border=0 width="500" cellspacing=8 cellpadding=0>
  <tr>
		<td colspan=4><font size=3><b>Init End Script:</b></font></td>
		<td></td>
  </tr>
  <tr>
		<td colspan=4><font size=2>This script is used to run after system initiating.</font></td>
		<td></td>
  </tr>
  <tr>
		<form action=/boaform/formInitEndScript method=POST enctype="multipart/form-data" name="init_ed_script">
		<td colspan=3><input type="file" value=<% multilang("Choose File"); %> name="end_text" size=36></td>
		<td><input type="submit" value=<% multilang("Upload"); %> name="end_upload"></td>
		</form>
  </tr>
  <tr valign="top">
		<td width=50>
			<input type="submit" value=<% multilang("Show Script Content"); %> name="end_show" onClick=ShowEndScriptClick("/EndScriptContent.asp")>&nbsp;
		</td>
		<td>
			<form action=/boaform/formInitEndScriptDel method=POST name="init_ed_script_del" onSubmit="return confirmAction()">
			<input type="submit" value=<% multilang("Delete Script"); %> name="end_delete"></td>
			</form>
		</td>
		<td colspan=2>&nbsp;</td>
  </tr>
</table>
</blockquote>
</body>
</html>

