<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Other Advanced"); %><% multilang(" Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
function saveChanges()
{
	if ( checkDigit(document.others.ltime.value) == 0) {
		alert("Invalid lease time!");	
		document.others.ltime.focus();
		return false;
	}
	return true;
}

function ipptSelected()
{
	document.others.ltime.value = <% getInfo("ippt-lease"); %>;
	
	//if (document.others.ippt.value == 255) {
	if (document.others.ippt.value == 65535) {
		document.others.ltime.disabled = true;
		document.others.lan_acc.disabled = true;
		/* open it, if need singlePC
		// check dependency
		if (document.others.singlePC.checked && document.others.IPtype[1].checked) {
			document.others.singlePC.checked=false;
			document.others.IPtype[0].disabled = true;
		}
		document.others.IPtype[1].disabled = true;
		*/
	}
	else {
		document.others.ltime.disabled = false;
		document.others.lan_acc.disabled = false;
		/* open it, if need singlePC
		// check dependency
		if (document.others.singlePC.checked)
			document.others.IPtype[1].disabled = false;
		*/
	}
}

function singlePCSelected()
{
	if (document.others.singlePC.checked) {
		document.others.IPtype[0].disabled = false;
		// check dependency
		//if (document.others.ippt.value==255) {
		if (document.others.ippt.value==65535) {
			document.others.IPtype[1].disabled = true;
			document.others.IPtype[0].checked = true;
		}
		else
			document.others.IPtype[1].disabled = false;
	}
	else {
		document.others.IPtype[0].disabled = true;
		document.others.IPtype[1].disabled = true;
	}
}

</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Other Advanced"); %><% multilang(" Configuration"); %></font></h2>

<form action=/boaform/formOthers method=POST name="others">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("Here you can set some other advanced settings."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>

  <tr>
      <th align=left><font size=2><b><% multilang("IP PassThrough"); %>:</b></th>
      <td>
      	<select name="ippt" onChange=ipptSelected()>
      	  <option value=65535><% multilang("None"); %></option>
          <% if_wan_list("p2p"); %>
      	</select>&nbsp;&nbsp;&nbsp;&nbsp;
      	<% multilang("Lease Time"); %>:&nbsp;&nbsp;
        <input type="text" name="ltime" size=10 maxlength=9 value="<% getInfo("ippt-lease"); %>"> <% multilang("seconds"); %>
      </td>
  </tr>
  <tr>
      <th></th>
      <td>
       	<input type="checkbox" name="lan_acc" value="ON">&nbsp;&nbsp;<% multilang("Allow LAN access"); %>
      </td>
  </tr>
</table>
  <br>
      <input type=submit value="<% multilang("Apply Changes"); %>" name="save" onClick="return saveChanges()">
<!--
      <input type=reset value="Undo" name="reset">
-->
      <input type=hidden value="/others.asp" name="submit-url">
  <script>
	ifIdx = <% getInfo("ippt-itf"); %>;

	document.others.ippt.selectedIndex = -1;

	for( i = 0; i < document.others.ippt.options.length; i++ )
	{
		if( ifIdx == document.others.ippt.options[i].value )
			document.others.ippt.selectedIndex = i;
	}

	<% initPage("others"); %>
  </script>
</form>
</blockquote>
</body>

</html>
