<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>L2TP VPN <% multilang("Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
function checkTextStr(str)
{
	for (var i=0; i<str.length; i++) 
	{
		if ( str.charAt(i) == '%' || str.charAt(i) =='&' ||str.charAt(i) =='\\' || str.charAt(i) =='?' || str.charAt(i)=='"') 
			return false;			
	}
	return true;
}

function pppAuthChange()
{
	if (document.l2tp.auth.selectedIndex==3)
	{
		document.l2tp.enctype.disabled = false;
	}
	else
	{
		document.l2tp.enctype.disabled = true;
	}
}

function tunnelAuthChange()
{
	if (document.l2tp.tunnel_auth.checked)
		document.l2tp.tunnel_secret.disabled = false;
	else
		document.l2tp.tunnel_secret.disabled = true;
}

function connTypeChange()
{
	if(document.l2tp.pppconntype.selectedIndex==1)
	{
		document.l2tp.idletime.disabled=false;
	}else{
		document.l2tp.idletime.disabled=true;
	}
}

function l2tpSelection()
{
	if (document.l2tp.l2tpen[0].checked) {
		document.l2tp.IpProtocolType.disabled = true;
		document.l2tp.server.disabled = true;
		document.l2tp.tunnel_auth.disabled = true;
		document.l2tp.tunnel_secret.disabled = true;
		document.l2tp.auth.disabled = true;
		document.l2tp.username.disabled = true;
		document.l2tp.password.disabled = true;
		document.l2tp.pppconntype.disabled = true;
		document.l2tp.idletime.disabled = true;
		document.l2tp.mtu.disabled = true;
		document.l2tp.defaultgw.disabled = true;
		document.l2tp.addL2TP.disabled = true;
		document.l2tp.enctype.disabled = true;
	}
	else {
		document.l2tp.IpProtocolType.disabled = false;
		document.l2tp.server.disabled = false;
		document.l2tp.tunnel_auth.disabled = false;
		document.l2tp.tunnel_secret.disabled = false;
		document.l2tp.auth.disabled = false;
		document.l2tp.username.disabled = false;
		document.l2tp.password.disabled = false;
		document.l2tp.pppconntype.disabled = false;
		document.l2tp.idletime.disabled = false;
		document.l2tp.mtu.disabled = false;
		document.l2tp.defaultgw.disabled = false;
		document.l2tp.addL2TP.disabled = false;
		document.l2tp.enctype.disabled = false;
	}
	tunnelAuthChange();
	pppAuthChange();
	connTypeChange()
}

function onClickL2TPEnable()
{
	l2tpSelection();
	
	if (document.l2tp.l2tpen[0].checked)
		document.l2tp.lst.value = "disable";
	else
		document.l2tp.lst.value = "enable";
	
	document.l2tp.submit();
}

function addL2TPItf()
{
	if(document.l2tp.l2tpen[0].checked)
		return false;
	
	if (document.l2tp.server.value=="") {
		alert("Please enter l2tp server address !");
		document.l2tp.server.focus();
		return false;
	}

	if (document.l2tp.IpProtocolType.value == 2)
	{
		if (! isGlobalIpv6Address( document.l2tp.server.value) )
		{
			alert("Please input ipv6 address!");
			document.l2tp.server.focus();
			return false;
		}
	}
	else if (document.l2tp.IpProtocolType.value == 1)
	{
		if (!checkTextStr(document.l2tp.server.value))
		{
			alert("Please input ipv4 address!");
			document.l2tp.server.focus();
			return false;
		}
	}

	if (document.l2tp.tunnel_auth.checked)
	{
		if (document.l2tp.tunnel_secret.value=="")
		{
			alert("Please enter l2tp tunnel authentication secret !");
			document.l2tp.tunnel_secret.focus();
			return false;
		}
		if(!checkTextStr(document.l2tp.tunnel_secret.value))
		{
			alert("Invalid value in tunnel authentication secret!");
			document.l2tp.tunnel_secret.focus();
			return false;		
		}
	}
	
	if (document.l2tp.auth.selectedIndex!=3)
	{
		if (document.l2tp.username.value=="")
		{
			alert("Please enter l2tp client username !");
			document.l2tp.username.focus();
			return false;
		}
		if(!checkTextStr(document.l2tp.username.value))
		{
			alert("Invalid value in username!");
			document.l2tp.username.focus();
			return false;		
		}
		if (document.l2tp.password.value=="") {
			alert("Please enter l2tp client password!");
			document.l2tp.password.focus();
			return false;
		}
		if(!checkTextStr(document.l2tp.password.value))
		{
			alert("Invalid value in password!");
			document.l2tp.password.focus();
			return false;		
		}
	}

	if (document.l2tp.pppconntype.selectedIndex==1)
	{
		if (document.l2tp.idletime.value=="")
		{
			alert("Please enter l2tp tunnel idle time !");
			document.l2tp.idletime.focus();
			return false;
		}
	}

	if (document.l2tp.mtu.value=="")
	{
		alert("Please enter l2tp tunnel MTU !");
		document.l2tp.mtu.focus();
		return false;
	}

	return true;
}

</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">L2TP VPN <% multilang("Configuration"); %></font></h2>

<form action=/boaform/formL2TP method=POST name="l2tp">
<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><font size=2>
    <% multilang("This page is used to configure the parameters for L2TP mode VPN."); %>
  </tr>
  <tr><hr size=1 noshade align=top></tr>

  <tr>
      <td width="40%"><font size=2><b>L2TP VPN:</b></td>
      <td width="60%"><font size=2>
      	<input type="radio" value="0" name="l2tpen" <% checkWrite("l2tpenable0"); %> onClick="onClickL2TPEnable()"><% multilang("Disable"); %>&nbsp;&nbsp;
     	<input type="radio" value="1" name="l2tpen" <% checkWrite("l2tpenable1"); %> onClick="onClickL2TPEnable()"><% multilang("Enable"); %>
      </td>
  </tr>
</table>
<input type="hidden" id="lst" name="lst" value="">
<br>

<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr>
    <td width="40%"><font size=2><b>IP <% multilang("Protocol"); %>:</b></td>
    <td width="60%"><select id="IpProtocolType" style="WIDTH: 130px" onChange="protocolChange()" name="IpProtocolType">
      <option value="1" > IPv4</option>
      <option value="2" > IPv6</option>
	</select></td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b><% multilang("Server"); %>:</b></td>
    <td width="60%"><input type="text" name="server" size="32" maxlength="256"></td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b><% multilang("Tunnel Authentication"); %>:</b></td>
    <td width="60%"><input type=checkbox name="tunnel_auth" value=1 onClick=tunnelAuthChange()></td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b><% multilang("Tunnel Authentication Secret"); %>:</b></td>
    <td width="60%"><input type="text" name="tunnel_secret" size="15" maxlength="35"></td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b>PPP <% multilang("Authentication"); %>:</b></td>
    <td width="60%"><select name="auth" onChange="pppAuthChange()">
      <option value="0"><% multilang("Auto"); %></option>
      <option value="1">PAP</option>
      <option value="2">CHAP</option>
      <option value="3">CHAPMSV2</option>
      </select>
    </td>
  </tr>
  <tr>
    <td width="30%"><font size=2></b>PPP <% multilang("Encryption"); %>:</b></td>
    <td width="70%"><select name="enctype" >
      <option value="0"><% multilang("None"); %></option>
      <option value="1">MPPE</option>
      <option value="2">MPPC</option>
      <option value="3">MPPE&MPPC</option>
      </select>
    </td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b><% multilang("User"); %><% multilang(" Name"); %>:</b></td>
    <td width="60%"><input type="text" name="username" size="15" maxlength="35"></td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b><% multilang("Password"); %>:</b></td>
    <td width="60%"><input type="text" name="password" size="15" maxlength="35"></td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b>PPP <% multilang("Connection Type"); %>:</b></td>
    <td width="60%"><select name="pppconntype" onChange="connTypeChange()">
      <option value="0"><% multilang("Persistent"); %></option>
      <option value="1"><% multilang("Dial-on-Demand"); %></option>
      <option value="2"><% multilang("Manual"); %></option>
      <option value="3"><% multilang("None"); %></option>
      </select>
    </td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b><% multilang("Idle Time (min)"); %>:</b></td>
    <td width="60%"><input type="text" name="idletime" size="32" maxlength="256"></td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b>MTU:</b></td>
    <td width="60%"><input type="text" name="mtu" size="32" maxlength="256" value="1458"></td>
  </tr>
  <tr>
    <td width="40%"><font size=2><b><% multilang("Default Gateway"); %>:</b></td>
    <td width="60%"><input type="checkbox" name="defaultgw"></td>
  </tr>
</table>

<table border=0 width="500" cellspacing=0 cellpadding=0>
  </tr>
      <td><input type="submit" value="<% multilang("Apply Changes"); %>" name="addL2TP" onClick="return addL2TPItf()">&nbsp;&nbsp;</td>
  </tr>
</table>
<br><br>

<table border=0 width="600" cellspacing=4 cellpadding=0>
  <tr><font size=2><b>L2TP <% multilang("Table"); %>:</b></font></tr>
  <tr>
    <td align=center width="3%" bgcolor="#808080"><font size=2><% multilang("Select"); %></font></td>
    <td align=center width="5%" bgcolor="#808080"><font size=2><% multilang("Interface"); %></font></td>
    <td align=center width="5%" bgcolor="#808080"><font size=2><% multilang("Server"); %></font></td>
    <td align=center width="5%" bgcolor="#808080"><font size=2><% multilang("Tunnel Authentication"); %></font></td>
    <td align=center width="5%" bgcolor="#808080"><font size=2>PPP <% multilang("Authentication"); %></font></td>
    <td align=center width="5%" bgcolor="#808080"><font size=2>MTU</font></td>
    <td align=center width="5%" bgcolor="#808080"><font size=2><% multilang("Default Gateway"); %></font></td>
    <td align=center width="8%" bgcolor="#808080"><font size=2><% multilang("Action"); %></font></td>
  </tr>
	<% l2tpList(); %>
</table>
<br>
<input type="submit" value="<% multilang("Delete Selected"); %>" name="delSel" onClick="return deleteClick()">&nbsp;&nbsp;
<input type="hidden" value="/l2tpv6.asp" name="submit-url">
<script>
	l2tpSelection();
</script>
</form>
</blockquote>
</body>
</html>
