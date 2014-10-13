<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta HTTP-EQUIV='Pragma' CONTENT='no-cache'>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>WDS <% multilang("Settings"); %></title>
<script type="text/javascript" src="share.js"> </script>
<script>
function addClick()
{
//  var str = document.formWlWdsAdd.mac.value;

//  if (!document.formWlWdsAdd.wlanWdsEnabled.checked)
//	return true;

	if (!checkMac(document.formWlWdsAdd.mac, 1))
		return false;
	if (checkString(document.formWlWdsAdd.comment.value) == 0) {
		alert('Invalid comment.');
		document.formWlWdsAdd.comment.focus();
		return false;
	}
	return true;
  /*if ( str.length == 0)
  	return true;

  if ( str.length < 12) {
	alert("Input MAC address is not complete. It should be 12 digits in hex.");
	document.formWlWdsAdd.mac.focus();
	return false;
  }

  for (var i=0; i<str.length; i++) {
    if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') ||
			(str.charAt(i) >= 'a' && str.charAt(i) <= 'f') ||
			(str.charAt(i) >= 'A' && str.charAt(i) <= 'F') )
			continue;

	alert("Invalid MAC address. It should be in hex number (0-9 or a-f).");
	document.formWlWdsAdd.mac.focus();
	return false;
  }
  return true;*/
}


function disableDelButton()
{
	disableButton(document.formWlWdsDel.deleteSelWdsMac);
	disableButton(document.formWlWdsDel.deleteAllWdsMac);
}

function enableWds()
{
  enableTextField(document.formWlWdsAdd.mac);
  enableTextField(document.formWlWdsAdd.comment);
  //enableButton(document.formWlWdsAdd.showWep);
  //enableButton(document.formWlWdsAdd.showAp);
}

function disableWds()
{
  disableTextField(document.formWlWdsAdd.mac);
  disableTextField(document.formWlWdsAdd.comment);

  	//disableButton(document.formWlWdsAdd.showWep);
  	//disableButton(document.formWlWdsAdd.showAp);
}

function updateState()
{
	if (document.formWlWdsAdd.wlanDisabled.value == "ON") {
		disableTextField(document.formWlWdsAdd.wlanWdsEnabled);
		disableButton(document.formWlWdsAdd.reset);
		disableButton(document.formWlWdsAdd.addWdsMac);
		disableButton(document.formWlWdsAdd.wdsSet);
		disableWds();
		disableDelButton();
	} else {
    //wlanDisabled = <% getMibValue("wlanDisabled"); %> ;
    //wlanMode = <% getMibValue("wlanMode"); %>;
    //if(wlanDisabled || wlanMode == 0 || wlanMode ==1){
		if(document.formWlWdsAdd.wlanWdsEnabled.disabled == true){
			disableButton(document.formWlWdsAdd.reset);
			disableButton(document.formWlWdsAdd.addWdsMac);
			disableButton(document.formWlWdsAdd.wdsSet);
			disableWds();
			disableDelButton();
		}else{
			if (document.formWlWdsAdd.wlanWdsEnabled.checked) {
				enableButton(document.formWlWdsAdd.reset);
				enableButton(document.formWlWdsAdd.addWdsMac);
				enableWds();
			}
			else {
				disableButton(document.formWlWdsAdd.reset);
				disableButton(document.formWlWdsAdd.addWdsMac);
				disableWds();
			}
		}
	}
}

function openWindow(url, windowName, w, h) {
	var wide=w;
	var high=h;
	if (document.all)
		var xMax = screen.width, yMax = screen.height;
	else if (document.layers)
		var xMax = window.outerWidth, yMax = window.outerHeight;
	else
	   var xMax = 640, yMax=500;
	var xOffset = (xMax - wide)/2;
	var yOffset = (yMax - high)/3;
	var settings = 'width='+wide+',height='+high+',screenX='+xOffset+',screenY='+yOffset+',top='+yOffset+',left='+xOffset+', resizable=yes, toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes';
	window.open( url, windowName, settings );
}
function showApClick(url)
{
  if (document.formWlWdsAdd.wlanWdsEnabled.checked)
	openWindow(url, 'showWdsStatistics',620,440 );
}

function showWepClick(url)
{
  if (document.formWlWdsAdd.wlanWdsEnabled.checked){
	openWindow(url, 'showWdsWep',620,340 );
  }
}

</script>
</head>
<body>
<blockquote>
<h2><font color="#0000FF">WDS <% multilang("Settings"); %></font></h2>
<form action=/boaform/admin/formWlWds method=POST name="formWlWdsAdd">
<table border=0 width="500" cellspacing=4 cellpadding=0>
<tr><td><font size=2>
 <% multilang("Wireless Distribution System uses wireless media to communicate with other APs, like the Ethernet does. To do this, you must set these APs in the same channel and set MAC address of other APs which you want to communicate with in the table and then enable the WDS."); %>
</font></td></tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>
	<input type=hidden name="wlanDisabled" value=<% wlanStatus(); %>>

	<tr>
	   <td><font size=2><b>
	   <input type="checkbox" name="wlanWdsEnabled" value="ON" <% checkWrite("wlanWdsEnabled"); %>  onclick="updateState()">&nbsp;&nbsp;<% multilang("Enable"); %> WDS</b></td>
	   <td><input type="submit" value="<% multilang("Apply Changes"); %>" name="wdsSet">&nbsp;&nbsp;</td>
	</tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=4 cellpadding=0>
	<tr>
		<td width="10%" nowrap><font size=2><b><% multilang("MAC Address"); %>:</b></td>
		<td><input type="text" name="mac" size="15" maxlength="12"></td>
	</tr>
	<tr id="wds_txrate">
		<td width="10%" nowrap><font size=2><b><% multilang("Data Rate"); %>:</b></td>
		<td><font size=2><select size="1" name="txRate" onChange="">
<SCRIPT>
<% checkWrite("wl_txRate"); %>


	rate_mask = [15,1,1,1,1,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,8,8,8,8,8,8,8,8];
	rate_name = ["<% multilang("Auto"); %>","1M","2M","5.5M","11M","6M","9M","12M","18M","24M","36M","48M","54M", "MCS0", "MCS1" , "MCS2", "MCS3", "MCS4", "MCS5", "MCS6", 
	"MCS7", "MCS8", "MCS9", "MCS10", "MCS11", "MCS12", "MCS13", "MCS14", "MCS15"];
	vht_rate_name=["NSS1-MCS0","NSS1-MCS1","NSS1-MCS2","NSS1-MCS3","NSS1-MCS4",
	"NSS1-MCS5","NSS1-MCS6","NSS1-MCS7","NSS1-MCS8","NSS1-MCS9",
	"NSS2-MCS0","NSS2-MCS1","NSS2-MCS2","NSS2-MCS3","NSS2-MCS4",
	"NSS2-MCS5","NSS2-MCS6","NSS2-MCS7","NSS2-MCS8","NSS2-MCS9"];

	mask = 0;

	if (auto)
		txrate=0;

	if (band & 1)
		mask |= 1;

	if ((band&2) || (band&4))
		mask |= 2;

	if (band & 8)
	{
		if (rf_num == 2)
			mask |= 12;
		else
			mask |= 4;
	}

	defidx = 0;

	for (idx=0, i=0; i<rate_name.length; i++) 
	{
		if (rate_mask[i] & mask)
		{
			if (i == 0)
				rate = 	0;
			else
				rate = (1 << (i-1));

			if (txrate == rate)
				defidx = idx;

			document.write('<option value="' + i + '">' + rate_name[i] + '\n');

			idx++;
		}
	}

	if(band & 64){
		for (i=0; i<vht_rate_name.length; i++) {
			rate = (((1 << 31)>>>0) + i);		
			if (txrate == rate)
				defidx = idx;
			if(chanwid!=0 || (i!=9 && i!=19))//no MCS9 when 20M
			{
				document.write('<option value="' + (i+30) + '">' + vht_rate_name[i] + '\n');
				idx++;
			}
		}
	}

	document.formWlWdsAdd.elements["txRate"].selectedIndex = defidx;
</SCRIPT>
		</select></td>
	</tr>
	<tr>
		<td width="10%" nowrap><b><font size=2><% multilang("Comment"); %>:</b></td>
		<td><input type="text" name="comment" size="16" maxlength="19"></font></td>
	</tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan=2>
			<input type="submit" value="<% multilang("Add"); %>" name="addWdsMac" onClick="return addClick()">&nbsp;&nbsp;
			<input type="reset" value="<% multilang("Reset"); %>" name="reset">&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" value="<% multilang("Set Security"); %>" name="showWep" onClick="showWepClick('/wlwdsenp.asp')">&nbsp;&nbsp;
			<input type="button" value="<% multilang("Show Statistics"); %>" name="showAp" onClick="showApClick('/wlwdstbl.asp')">&nbsp;&nbsp;
			<input type="hidden" value="/admin/wlwds.asp" name="submit-url">
			<input type="hidden" name="wlan_idx" value=<% checkWrite("wlan_idx"); %>>
		</td>
	</tr>
</table>
</form>

<form action=/boaform/admin/formWlWds method=POST name="formWlWdsDel">
  <table border=0 width=440>
  <tr><font size=2><b><% multilang("Current WDS AP List"); %>:</b></font></tr>
  <% wlWdsList(); %>
  </table>
  <br>
  <input type="submit" value="<% multilang("Delete Selected"); %>" name="deleteSelWdsMac" onClick="return deleteClick()">&nbsp;&nbsp;
  <input type="submit" value="<% multilang("Delete All"); %>" name="deleteAllWdsMac" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
  <input type="reset" value="<% multilang("Reset"); %>" name="reset">
  <input type="hidden" value="/admin/wlwds.asp" name="submit-url">
  <input type="hidden" name="wlan_idx" value=<% checkWrite("wlan_idx"); %>>
 <script>
 	<% initPage("wlwds"); %>
	updateState();
 	<% checkWrite("wlanWDSNum"); %>
 </script>
</form>

</blockquote>
</body>
</html>
