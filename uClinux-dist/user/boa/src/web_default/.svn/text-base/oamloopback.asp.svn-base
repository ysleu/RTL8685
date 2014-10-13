<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("ATM Loopback Diagnostics"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
function isHexDecimal(num)
{
	var string="1234567890ABCDEF";
	if (string.indexOf(num.toUpperCase()) != -1)
	{
		return true;
	}

	return false;
}

function isValidID(val)
{
	for(var i=0; i < val.length; i++)
	{
		if  ((!isHexDecimal(val.charAt(i))))
		{
			return false;
		}
	}

	return true;
}

function goClick()
{
	retval = isValidID(document.oamlb.oam_llid.value);
	if((document.oamlb.oam_llid.value=="")|| (retval==false))
	{
		alert("Invalid Loopback Location ID!")
		document.oamlb.oam_llid.focus()
		return false
	}

	return true;
}
</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("ATM Loopback Diagnostics"); %> - <% multilang("Connectivity Verification"); %></font></h2>

<form action=/boaform/formOAMLB method=POST name="oamlb">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("Connectivity verification is supported by the use of the ATM OAM loopback capability for both VP and VC connections. This page is used to perform the VCC loopback function to check the connectivity of the VCC."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td>
      <font size=2><b><% multilang("Select"); %> PVC:</b></font>
        <% oamSelectList(); %>
      </td>
  </tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr>
  	<td>
		<font size=2><b><% multilang("Flow Type"); %>:</b>
		</td>
		<td>
		<input type="radio" value="3" name="oam_flow"><% multilang("F4 Segment"); %>&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="radio" value="4" name="oam_flow" ><% multilang("F4 End-to-End"); %>
		</td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
		<td>
		<input type="radio" value="0" name="oam_flow" checked><% multilang("F5 Segment"); %>&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="radio" value="1" name="oam_flow" ><% multilang("F5 End-to-End"); %>
		</td>
  </tr>

  <tr><td colspan=2>
      <font size=2><b><% multilang("Loopback Location ID"); %>: </b>
      <input type="text" name="oam_llid" value="FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" size=40 maxlength=32 onFocus="this.select()">
      </td>
  </tr>
</table>
  <br>
      <input type="submit" value=" <% multilang("Go"); %> ! " name="go" onClick="return goClick()">
      <input type="hidden" value="/oamloopback.asp" name="submit-url">
</form>
</blockquote>
</body>

</html>
