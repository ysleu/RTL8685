<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("DSL WAN"); %><% multilang(" Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script language="javascript">

var initConnectMode;
var pppConnectStatus=0;

var dgwstatus;
var gtwy;
var interfaceInfo = '';
var gtwyIfc ='';
var gwInterface=0;
var ipver=1;

function pppTypeSelection()
{
	if ( document.adsl.pppConnectType.selectedIndex == 2) {
		document.adsl.pppIdleTime.value = "";
		disableTextField(document.adsl.pppIdleTime);
	}
	else {
		if (document.adsl.pppConnectType.selectedIndex == 1) {
			enableTextField(document.adsl.pppIdleTime);
		}
		else {
			document.adsl.pppIdleTime.value = "";
			disableTextField(document.adsl.pppIdleTime);
		}
	}
}

function checkDefaultGW() {
	with (document.forms[0]) {
		if (droute[0].checked == false && droute[1].checked == false && gwStr[0].checked == false && gwStr[1].checked == false) {
			alert('A default gateway has to be selected.');
			return false;
		}
		if (droute[1].checked == true) {
			if (gwStr[0].checked == true) {
				if (isValidIpAddress(dstGtwy.value, "Default Gateway IP Address") == false)
					return false;
			}
		}
	}
	return true;
}

function addClick()
{
	<% checkWrite("checkVC"); %>
	return vcCheck();
}

// Jenny, check decimal
function validateInt(str)
{
	for (var i=0; i<str.length; i++) {
		if (str.charAt(i) == '.' )
			return 0;
	}
	return 1;
}

function vcCheck()
{
	var ptmap = 0;
	var pmchkpt = document.getElementById("tbl_pmap");

	if (pmchkpt) {
		with (document.forms[0]) {
			for(var i = 0; i < 14; i ++) if(chkpt[i].checked == true) ptmap |= (0x1 << i);
			itfGroup.value = ptmap;
		}
	}
	if (checkDefaultGW()==false)
		return false;

	if (validateInt(document.adsl.vpi.value) == 0) {	// Jenny,  buglist B056, check if input VPI is a decimal
		alert("Invalid VPI value! VPI shouldn't be a decimal.");
		document.adsl.vpi.value = document.adsl.vpi.defaultValue;
		document.adsl.vpi.focus();
		return false;
	}
	digitVPI = getDigit(document.adsl.vpi.value, 1);
	if ( validateKey(document.adsl.vpi.value) == 0 ||
		(digitVPI > 255 || digitVPI < 0) ) {
		alert("Invalid VPI value! You should set a value between 0-255.");
		document.adsl.vpi.focus();
		return false;
	}

	if (validateInt(document.adsl.vci.value) == 0) {	// Jenny,  buglist B056, check if input VCI is a decimal
		alert("Invalid VCI value! VCI shouldn't be a decimal.");
		document.adsl.vci.value = document.adsl.vci.defaultValue;
		document.adsl.vci.focus();
		return false;
	}
	digitVCI = getDigit(document.adsl.vci.value, 1);
	if ( validateKey(document.adsl.vci.value) == 0 ||
		(digitVCI > 65535 || digitVCI < 0) ) {
		alert("Invalid VCI value! You should set a value between 0-65535.");
		document.adsl.vci.focus();
		return false;
	}

	if ( (digitVPI == 0 && digitVCI == 0) ) {
		alert("Invalid VPI/VCI value!");
		document.adsl.vpi.focus();
		return false;
	}

	if (( document.adsl.adslConnectionMode.value == 2 ) ||
		( document.adsl.adslConnectionMode.value == 3 )) {
		if (document.adsl.pppUserName.value=="") {
			alert('PPP user name cannot be empty!');
			document.adsl.pppUserName.focus();
			return false;
		}
		if (includeSpace(document.adsl.pppUserName.value)) {
			alert('Cannot accept space character in PPP user name.');
			document.adsl.pppUserName.focus();
			return false;
		}
		if (checkString(document.adsl.pppUserName.value) == 0) {
			alert('Invalid PPP user name.');
			document.adsl.pppUserName.focus();
			return false;
		}

		if (document.adsl.pppPassword.value=="") {
			alert('PPP password cannot be empty!');
			document.adsl.pppPassword.focus();
			return false;
		}
		if (includeSpace(document.adsl.pppPassword.value)) {
			alert('Cannot accept space character in PPP password.');
			document.adsl.pppPassword.focus();
			return false;
		}
		if (checkString(document.adsl.pppPassword.value) == 0) {
			alert('Invalid PPP password.');
			document.adsl.pppPassword.focus();
			return false;
		}
		if (document.adsl.pppConnectType.selectedIndex == 1) {
			if (document.adsl.pppIdleTime.value <= 0) {
				alert('Invalid PPP idle time.');
				document.adsl.pppIdleTime.focus();
				return false;
			}
		}
	}

	// Mason Yu:20110307 ipv6 setting
	if (<% checkWrite("IPv6Show"); %>) {
		if(document.adsl.IpProtocolType.value & 1){
			if (( document.adsl.adslConnectionMode.value == 1 ) ||
				( document.adsl.adslConnectionMode.value == 4 )) {
				if (document.adsl.ipMode[0].checked) {
					if ( document.adsl.ipUnnum.disabled || ( !document.adsl.ipUnnum.disabled && !document.adsl.ipUnnum.checked )) {
						if (!checkHostIP(document.adsl.ip, 1))
							return false;
						if (document.adsl.remoteIp.visiblity == "hidden") {
							if (!checkHostIP(document.adsl.remoteIp, 1))
							return false;
						}
						if (document.adsl.adslConnectionMode.value == 1 && !checkNetmask(document.adsl.netmask, 1))
							return false;
					}
				}
			}
		}
	}

	/* Mason Yu:20110307 START ipv6 setting */
	if (<% checkWrite("IPv6Show"); %>) {
		if ( document.adsl.adslConnectionMode.value != 0 ) {
			if(document.adsl.IpProtocolType.value & 2)
			{
				if (document.adsl.adslConnectionMode.value != 0 && document.adsl.adslConnectionMode.value != 6 && document.adsl.adslConnectionMode.value != 8) {
					if(document.adsl.slacc.checked == false && document.adsl.itfenable.checked == false && document.adsl.staticIpv6.checked == false){
						alert("Please input ipv6 address or open DHCPv6 client or click SLAAC!");
						document.adsl.slacc.focus();
						return false;
					}
				}

				if(document.adsl.itfenable.checked) {
					if(document.adsl.iana.checked == false && document.adsl.iapd.checked == false ) {
						alert("Please select iana or iapd!");
						document.adsl.iana.focus();
						return false;
					}
				}

				if(document.adsl.staticIpv6.checked) {
					if(document.adsl.Ipv6Addr.value == "" || document.adsl.Ipv6PrefixLen.value == "") {
						alert("Please input ipv6 address and Prefix Length!");
						document.adsl.Ipv6Addr.focus();
						return false;
					}
					if(document.adsl.Ipv6Addr.value != ""){
						if (! isGlobalIpv6Address( document.adsl.Ipv6Addr.value) ){
							alert("Invalid ipv6 address!");
							document.adsl.Ipv6Addr.focus();
							return false;
						}
						var prefixlen= getDigit(document.adsl.Ipv6PrefixLen.value, 1);
						if (prefixlen > 128 || prefixlen <= 0) {
							alert("Invalid ipv6 prefix length!");
							document.adsl.Ipv6PrefixLen.focus();
							return false;
						}
					}
					if(document.adsl.Ipv6Gateway.value != "" ){
						if (! isUnicastIpv6Address( document.adsl.Ipv6Gateway.value) ){
							alert("Invalid ipv6 gateway address!");
							document.adsl.Ipv6Gateway.focus();
							return false;
						}
					}
				}else{
					document.adsl.Ipv6Addr.value = "";
					document.adsl.Ipv6PrefixLen.value = "";
					document.adsl.Ipv6Gateway.value = "";
				}

				if (<% checkWrite("DSLiteShow"); %>) {
					if (document.adsl.adslConnectionMode.value == 6) // DS-Lite
					{
						if(document.adsl.DSLiteLocalIP.value != ""){
							if (! isGlobalIpv6Address( document.adsl.DSLiteLocalIP.value) ){
								alert("Invalid DSLiteLocalIP address!");
								document.adsl.DSLiteLocalIP.focus();
								return false;
							}
						}

						if(document.adsl.DSLiteRemoteIP.value != ""){
							if (! isGlobalIpv6Address( document.adsl.DSLiteRemoteIP.value) ){
								alert("Invalid DSLiteRemoteIP address!");
								document.adsl.DSLiteRemoteIP.focus();
								return false;
							}
						}

						if(document.adsl.DSLiteGateway.value != ""){
							if (! isGlobalIpv6Address( document.adsl.DSLiteGateway.value) ){
								alert("Invalid DSLiteGateway address!");
								document.adsl.DSLiteGateway.focus();
								return false;
							}
						}
					}
					else{
						document.adsl.DSLiteLocalIP.value = "";
						document.adsl.DSLiteRemoteIP.value = "";
						document.adsl.DSLiteGateway.value = "";
					}
				}


			if (<% checkWrite("6rdShow"); %>) {

				if (document.adsl.adslConnectionMode.value == 8) // 6rd
				{
					if(document.adsl.SixrdBRv4IP.value == ""){
						alert("Invalid 6rdBRv4IP address!");
						document.adsl.SixrdBRv4IP.focus();
						return false;
					}

                    if(document.adsl.SixrdPrefix.value == ""){
						alert("Invalid 6rd Prefix address!");
						document.adsl.SixrdPrefix.focus();
						return false;
					}

					if(document.adsl.SixrdIPv4MaskLen.value == ""){
						alert("Invalid 6rd IPv4 Mask length address!");
						document.adsl.SixrdIPv4MaskLen.focus();
						return false;
					}

					if(document.adsl.SixrdPrefixLen.value == ""){
						alert("Invalid 6rdPrefixLen address!");
						document.adsl.SixrdPrefixLen.focus();
						return false;
					}
				}
				else{

					document.adsl.SixrdBRv4IP.value = "";
					document.adsl.SixrdPrefix.value = "";
					document.adsl.SixrdPrefixLen.value = "";
				}

			}

			}
		}
	}

	return true;
}

function setPPPConnected()
{
	pppConnectStatus = 1;
}

function disableFixedIpInput()
{
	disableTextField(document.adsl.ip);
	disableTextField(document.adsl.remoteIp);
	disableTextField(document.adsl.netmask);
}

function enableFixedIpInput()
{
	enableTextField(document.adsl.ip);
	enableTextField(document.adsl.remoteIp);
	if (document.adsl.adslConnectionMode.value == 4)
		disableTextField(document.adsl.netmask);
	else
		enableTextField(document.adsl.netmask);
}

function ipTypeSelection()
{
	if ( document.adsl.ipMode[0].checked ) {
		enableFixedIpInput();
	} else {
		disableFixedIpInput();
	}
}

function enable_pppObj()
{
	enableTextField(document.adsl.pppUserName);
	enableTextField(document.adsl.pppPassword);
	enableTextField(document.adsl.pppConnectType);
	document.adsl.gwStr[0].disabled = false;
	document.adsl.gwStr[1].disabled = false;
	enableTextField(document.adsl.dstGtwy);
	document.adsl.wanIf.disabled = false;
	pppTypeSelection();
	autoDGWclicked();
}

function pppSettingsEnable()
{
	document.getElementById('tbl_ppp').style.display='block';
	enable_pppObj();
}

function disable_pppObj()
{
	disableTextField(document.adsl.pppUserName);
	disableTextField(document.adsl.pppPassword);
	disableTextField(document.adsl.pppIdleTime);
	disableTextField(document.adsl.pppConnectType);

	document.adsl.gwStr[0].disabled = true;
	document.adsl.gwStr[1].disabled = true;
	disableTextField(document.adsl.dstGtwy);
	document.adsl.wanIf.disabled = true;
}

function pppSettingsDisable()
{
	document.getElementById('tbl_ppp').style.display='none';
	disable_pppObj();
}

function enable_ipObj()
{
	if ( document.adsl.adslConnectionMode.value == 4 ) {
		document.adsl.ipMode[0].checked = true;
		if (document.adsl.naptEnabled.checked)
			document.adsl.ipUnnum.disabled = true;
		else
			document.adsl.ipUnnum.disabled = false;
		document.adsl.ipMode[0].disabled = true;
		document.adsl.ipMode[1].disabled = true;
	}
	else {
		document.adsl.ipMode[0].disabled = false;
		document.adsl.ipMode[1].disabled = false;
	}
	document.adsl.gwStr[0].disabled = false;
	document.adsl.gwStr[1].disabled = false;
	enableTextField(document.adsl.dstGtwy);
	document.adsl.wanIf.disabled = false;
	ipTypeSelection();
	autoDGWclicked();
}

function ipSettingsEnable()
{
	if (ipver == 2)
		return;
	document.getElementById('tbl_ip').style.display='block';
	enable_ipObj();
}

function disable_ipObj()
{
	document.adsl.ipMode[0].disabled = true;
	document.adsl.ipMode[1].disabled = true;
	document.adsl.gwStr[0].disabled = true;
	document.adsl.gwStr[1].disabled = true;
	disableTextField(document.adsl.dstGtwy);
	document.adsl.wanIf.disabled = true;
	disableFixedIpInput();
}

function ipSettingsDisable()
{
	document.getElementById('tbl_ip').style.display='none';
	disable_ipObj();
}

function ipModeSelection()
{
	if (document.adsl.ipUnnum.checked) {
		disable_pppObj();
		disable_ipObj();
		document.adsl.gwStr[0].disabled = false;
		document.adsl.gwStr[1].disabled = false;
		enableTextField(document.adsl.dstGtwy);
		document.adsl.wanIf.disabled = false;
	}
	else
		enable_ipObj();
}

function adslConnectionModeSelection()
{
	document.adsl.naptEnabled.disabled = false;
	document.adsl.igmpEnabled.disabled = false;
	document.adsl.ipUnnum.disabled = true;
	document.adsl.adslEncap[0].disabled = false;
	document.adsl.adslEncap[1].disabled = false;
	<% checkWrite("naptEnable"); %>
	document.adsl.droute[0].disabled = false;
	document.adsl.droute[1].disabled = false;

	document.getElementById('tbl_ppp').style.display='none';
	document.getElementById('tbl_ip').style.display='none';
	document.getElementById('6rdDiv').style.display='none';
	if (<% checkWrite("IPv6Show"); %>) {
		ipv6SettingsEnable();
		document.getElementById('tbprotocol').style.display="block";
		document.adsl.IpProtocolType.disabled = false;
		if (<% checkWrite("DSLiteShow"); %>) {
			document.getElementById('DSLiteDiv').style.display="none";
		}
	}

	//e = document.getElementById("qosEnabled");
	//if (e) e.disabled = false;
	if (( document.adsl.adslConnectionMode.value == 2 ) ||
		( document.adsl.adslConnectionMode.value == 3 )) {

		document.getElementById('tbl_ppp').style.display='block';
		ipSettingsDisable();
		pppSettingsEnable();
	}
	else if ( document.adsl.adslConnectionMode.value == 0 || document.adsl.adslConnectionMode.value == 6) {
		// bridge mode or DS-Lite
		document.adsl.naptEnabled.disabled = true;
		document.adsl.igmpEnabled.disabled = true;
		document.adsl.droute[0].disabled = true;
		document.adsl.droute[1].disabled = true;
		pppSettingsDisable();
		ipSettingsDisable();

		//if (e) e.disabled = true;

		if (<% checkWrite("IPv6Show"); %>) {
			ipv6SettingsDisable();
			document.getElementById('tbprotocol').style.display="none";
		}

		// For DS-Lite only
		if (<% checkWrite("IPv6Show"); %> && <% checkWrite("DSLiteShow"); %>) {
			if ( document.adsl.adslConnectionMode.value == 6 )
			{
				document.getElementById('DSLiteDiv').style.display='block';
				document.adsl.droute[0].disabled = false;
				document.adsl.droute[1].disabled = false;
				//document.getElementById('tbprotocol').style.display="block";

				// Set some values for DS-Lite mer mode only
				document.adsl.IpProtocolType.value = 2;     // IPV6 only
				//document.adsl.IpProtocolType.disabled = true;
				document.adsl.slacc.checked = false;        // not use slaac
				document.adsl.staticIpv6.checked = false;   // not use static IP
				document.adsl.itfenable.checked = false;    // not enable DHCPv6 client
			}
		}
	}
	else if ( document.adsl.adslConnectionMode.value == 4 ) {
		// Route1483
		document.adsl.ipMode[0].checked = true;
		document.adsl.ipUnnum.disabled = false;
		pppSettingsDisable();
		ipSettingsEnable();
		document.adsl.ipMode[0].disabled = true;
		document.adsl.ipMode[1].disabled = true;
		disableTextField(document.adsl.netmask);
	}
	else if ( document.adsl.adslConnectionMode.value == 5 ) {
		// Route1577
		document.adsl.ipMode[0].checked = true;
		pppSettingsDisable();
		ipSettingsEnable();
		document.adsl.ipMode[0].disabled = true;
		document.adsl.ipMode[1].disabled = true;
		document.adsl.adslEncap[0].disabled = true;
		document.adsl.adslEncap[1].disabled = true;
		document.adsl.adslEncap[0].checked = true;
		document.adsl.adslEncap.value = 1;
	}
	else if ( document.adsl.adslConnectionMode.value == 8 ) {  //6rd
		if (<% checkWrite("IPv6Show"); %> && <% checkWrite("6rdShow"); %>)
		{
			document.getElementById('6rdDiv').style.display='block';
			document.adsl.droute[0].checked = false;
			document.adsl.droute[1].checked = true;
			document.adsl.IpProtocolType.value = 3;     // IPV4/IPV6
			document.adsl.slacc.checked = false;        // not use slaac
			document.adsl.staticIpv6.checked = false;   // not use static IP
			document.adsl.itfenable.checked = false;    // not enable DHCPv6 client
			ipSettingsEnable();
			enableFixedIpInput();
			ipv6SettingsDisable();
		    document.getElementById('tbprotocol').style.display="none";
		}
    }
	else {
		pppSettingsDisable();
		ipSettingsEnable();
	}
}

function naptClicked()
{
	if (document.adsl.adslConnectionMode.value == 4) {
		// Route1483
		if (document.adsl.naptEnabled.checked == true) {
			document.adsl.ipUnnum.checked = false;
			document.adsl.ipUnnum.disabled = true;
		}
		else
			document.adsl.ipUnnum.disabled = false;
		ipModeSelection();
	}
}

function clearAll()
{
	document.adsl.vpi.value = 0;
	document.adsl.vci.value = "";
	document.adsl.adslEncap.value = 1;
	document.adsl.naptEnabled.checked = false;
	document.adsl.igmpEnabled.checked = false;
	document.adsl.adslConnectionMode.value = 0;

	document.adsl.pppUserName.value = "";
	document.adsl.pppPassword.value = "";
	document.adsl.pppConnectType.value = 0;
	document.adsl.pppIdleTime.value = "";

	document.adsl.ipUnnum.checked = false;
	document.adsl.ipMode.value = 0;
	document.adsl.ip.value = "";
	document.adsl.remoteIp.value = "";
	document.adsl.netmask.value = "";
	document.adsl.adslEncap[0].disabled = false;
	document.adsl.adslEncap[1].disabled = false;
}

function postVC(vpi,vci,encap,napt,igmp,qos,mode,username,passwd,pppType,idletime,ipunnum,ipmode,ipaddr,remoteip,netmask,droute,status,enable,ptmap)
{
	var pmchkpt = document.getElementById("tbl_pmap");
	clearAll();
	document.adsl.vpi.value = vpi;
	document.adsl.vci.value = vci;
	if (encap == "LLC")
		document.adsl.adslEncap[0].checked = true;
	else
		document.adsl.adslEncap[1].checked = true;

	if (mode == "br1483")
		document.adsl.adslConnectionMode.value = 0;
	else if (mode == "mer1483")
		document.adsl.adslConnectionMode.value = 1;
	else if (mode == "PPPoE")
		document.adsl.adslConnectionMode.value = 2;
	else if (mode == "PPPoA")
		document.adsl.adslConnectionMode.value = 3;
	else if (mode == "rt1483")
		document.adsl.adslConnectionMode.value = 4;
	else if (mode == "rt1577")
		document.adsl.adslConnectionMode.value = 5;

	adslConnectionModeSelection();

	if (napt == "On")
		document.adsl.naptEnabled.checked = true;
	else
		document.adsl.naptEnabled.checked = false;

	if (igmp == "On")
		document.adsl.igmpEnabled.checked = true;
	else
		document.adsl.igmpEnabled.checked = false;

	if (qos == "On")
		document.adsl.qosEnabled.checked = true;
	else
		document.adsl.qosEnabled.checked = false;


	if (enable == 0)
		document.adsl.chEnable[1].checked = true;
	else
		document.adsl.chEnable[0].checked = true;

	if (mode == "PPPoE" || mode == "PPPoA")
	{
		document.adsl.pppUserName.value = username;
		document.adsl.pppPassword.value = passwd;

		if (pppType == "conti")
			document.adsl.pppConnectType.value = 0;
		else if (pppType == "demand")
			document.adsl.pppConnectType.value = 1;
		else
		{
			document.adsl.pppConnectType.value = 2;
		}

		pppTypeSelection();

		if (pppType == "demand")
			document.adsl.pppIdleTime.value = idletime;
	}
	else if (mode == "mer1483" || mode == "rt1483" || mode == "rt1577")
	{
		document.adsl.ipMode[ipmode].checked = true;
		ipTypeSelection();
		if (ipmode == 0)
		{
			document.adsl.ip.value=ipaddr;
			document.adsl.remoteIp.value=remoteip;
			document.adsl.netmask.value=netmask;
		}
		if (mode == "rt1483")
		{
			if (ipunnum == 1)
				document.adsl.ipUnnum.checked = true;
			else
				document.adsl.ipUnnum.checked = false;
			ipModeSelection();
			disableTextField(document.adsl.netmask);
		}
	}
	if (pmchkpt)
		for(var i = 0; i < 14; i ++) document.adsl.chkpt[i].checked = (ptmap & (0x1 << i));

	<% checkWrite("pppoeProxyEnable"); %>

	<% checkWrite("dgw"); %>
}

function postVC2(vpi,vci,encap,napt,ctype,vlan,vid,vprio,igmp,qos,mode,username,passwd,pppType,idletime,ipunnum,ipmode,ipaddr,remoteip,netmask,droute,status,enable,ptmap,
                protocoltype, ipv6type, ipv6add, ipv6gw, ipv6End, ipv6prefix, ipv6dhcpcenable, ipv6request,  SixrdBRv4IP, SixrdIPv4MaskLen,SixrdPrefix,SixrdPrefixLen)
{
	var pmchkpt = document.getElementById("tbl_pmap");
	clearAll();
	document.adsl.vpi.value = vpi;
	document.adsl.vci.value = vci;

	if (vlan == 0)
		document.adsl.vlan[0].checked = true;
	else
		document.adsl.vlan[1].checked = true;
	document.adsl.vid.value = vid;
	document.adsl.vprio.selectedIndex=vprio;
	if (document.adsl.vlan[0].checked){
		document.adsl.vid.disabled=true;
		document.adsl.vprio.disabled=true;}
	else{
		document.adsl.vid.disabled=false;
		document.adsl.vprio.disabled=false;}

	if (encap == "LLC")
		document.adsl.adslEncap[0].checked = true;
	else
		document.adsl.adslEncap[1].checked = true;

	if (mode == "br1483")
		document.adsl.adslConnectionMode.value = 0;
	else if (mode == "mer1483")
		document.adsl.adslConnectionMode.value = 1;
	else if (mode == "PPPoE")
		document.adsl.adslConnectionMode.value = 2;
	else if (mode == "PPPoA")
		document.adsl.adslConnectionMode.value = 3;
	else if (mode == "rt1483")
		document.adsl.adslConnectionMode.value = 4;
	else if (mode == "rt1577")
		document.adsl.adslConnectionMode.value = 5;
	else if (mode == "DS-Lite-mer")
		document.adsl.adslConnectionMode.value = 6;

	if (ctype == "None")
		document.adsl.ctype.value = 0;
	else if (ctype == "TR069")
		document.adsl.ctype.value = 1;
	else if (ctype == "INTERNET")
		document.adsl.ctype.value = 2;
	else if (ctype == "OTHER")
		document.adsl.ctype.value = 4;
	else if (ctype == "VOICE")
		document.adsl.ctype.value = 8;
	else if (ctype == "INTERNET_TR069")
		document.adsl.ctype.value = 3;
	else if (ctype == "VOICE_TR069")
		document.adsl.ctype.value = 9;
	else if (ctype == "VOICE_INTERNET")
		document.adsl.ctype.value = 10;
	else if (ctype == "VOICE_INTERNET_TR069")
		document.adsl.ctype.value = 11;

	adslConnectionModeSelection();
	if (mode == "DS-Lite-mer")
	{
		document.adsl.DSLiteLocalIP.value = ipv6add;
		document.adsl.DSLiteRemoteIP.value = ipv6End;
		document.adsl.DSLiteGateway.value = ipv6gw;
	}

	if (napt == "On")
		document.adsl.naptEnabled.checked = true;
	else
		document.adsl.naptEnabled.checked = false;

	if (igmp == "On")
		document.adsl.igmpEnabled.checked = true;
	else
		document.adsl.igmpEnabled.checked = false;

	if (qos == "On")
		document.adsl.qosEnabled.checked = true;
	else
		document.adsl.qosEnabled.checked = false;


	if (enable == 0)
		document.adsl.chEnable[1].checked = true;
	else
		document.adsl.chEnable[0].checked = true;

	if (mode == "PPPoE" || mode == "PPPoA")
	{
		document.adsl.pppUserName.value = username;
		document.adsl.pppPassword.value = passwd;

		if (pppType == "conti")
			document.adsl.pppConnectType.value = 0;
		else if (pppType == "demand")
			document.adsl.pppConnectType.value = 1;
		else
		{
			document.adsl.pppConnectType.value = 2;
		}

		pppTypeSelection();

		if (pppType == "demand")
			document.adsl.pppIdleTime.value = idletime;
	}
	else if (mode == "mer1483" || mode == "rt1483" || mode == "rt1577")
	{
		document.adsl.ipMode[ipmode].checked = true;
		ipTypeSelection();
		if (ipmode == 0)
		{
			document.adsl.ip.value=ipaddr;
			document.adsl.remoteIp.value=remoteip;
			document.adsl.netmask.value=netmask;
		}
		if (mode == "rt1483")
		{
			if (ipunnum == 1)
				document.adsl.ipUnnum.checked = true;
			else
				document.adsl.ipUnnum.checked = false;
			ipModeSelection();
			disableTextField(document.adsl.netmask);
		}
	}
	else if (mode == "6rd")
	{

		document.getElementById('6rdDiv').style.display='block';
		document.adsl.droute[0].checked = false;
		document.adsl.droute[1].checked = true;
		document.adsl.IpProtocolType.value = 3;     // IPV4/IPV6
		document.adsl.slacc.checked = false;        // not use slaac
		document.adsl.staticIpv6.checked = false;   // not use static IP
		document.adsl.itfenable.checked = false;    // not enable DHCPv6 client
		ipSettingsEnable();
		enableFixedIpInput();
		ipv6SettingsDisable();
		document.getElementById('tbprotocol').style.display="none";


		document.adsl.ip.value=ipaddr;
		document.adsl.remoteIp.value=remoteip;
		document.adsl.netmask.value=netmask;

		document.adsl.SixrdBRv4IP.value= SixrdBRv4IP;
		document.adsl.SixrdIPv4MaskLen.value = SixrdIPv4MaskLen;
		document.adsl.SixrdPrefix.value = SixrdPrefix;
		document.adsl.SixrdPrefixLen.value = SixrdPrefixLen;
	}

	<% checkWrite("pppoeProxyEnable"); %>

	<% checkWrite("dgw"); %>

	/* Mason Yu:20110307 START ipv6 setting */
	if(mode != "br1483" && mode != "DS-Lite-mer"){
		document.adsl.IpProtocolType.value = protocoltype;
		ipver = protocoltype;
		protocolChange();
		if(protocoltype != 1){
			//document.adsl.Ipv6AddrType.value = ipv6type;
			if ( (ipv6type & 0x1) == 0x1 )
				document.adsl.slacc.checked = true;
			if ( (ipv6type & 0x2) == 0x2 )
				document.adsl.staticIpv6.checked = true;

			//if(ipv6type == 1){
			if( (ipv6type & 0x2) == 0x2){
				document.adsl.Ipv6Addr.value = ipv6add;
				document.adsl.Ipv6PrefixLen.value = ipv6prefix;
				document.adsl.Ipv6Gateway.value = ipv6gw;
			}
			if(ipv6dhcpcenable==1)
				document.adsl.itfenable.checked = true;
			else
				document.adsl.itfenable.checked = false;

			ipv6WanUpdate();
			if(ipv6dhcpcenable==1){
				//if(ipv6requestaddr != 0)
				if( (ipv6request & 0x1) == 0x1 )
					document.adsl.iana.checked = true;
				else
					document.adsl.iana.checked = false;
				//if(ipv6requestprefix != 0)
				if( (ipv6request & 0x2) == 0x2 )
					document.adsl.iapd.checked = true;
				else
					document.adsl.iapd.checked = false;
			}
		}
	}
	/* Mason Yu:20110307 END */
	if (pmchkpt)
		for(var i = 0; i < 14; i ++) document.adsl.chkpt[i].checked = (ptmap & (0x1 << i));

}


function updatepvcState()
{
  if (document.adsl.autopvc.checked == true) {
  	document.adsl.autopvc.value="ON";
	document.adsl.enablepvc.value = 1;
	enableTextField(document.adsl.autopvcvci);
	enableTextField(document.adsl.autopvcvpi);
	enableButton(document.adsl.autopvcadd);
  } else {
  	document.adsl.autopvc.value="OFF";
	document.adsl.enablepvc.value = 0;
	disableTextField(document.adsl.autopvcvci);
	disableTextField(document.adsl.autopvcvpi);
	disableButton(document.adsl.autopvcadd);
  }
}

function updatepvcState2()
{
  if (document.adsl.autopvc.checked == true) {
  	document.adsl.autopvc.value="ON";
	document.adsl.enablepvc.value = 1;
	//enableTextField(document.adsl.autopvcvci);
	//enableTextField(document.adsl.autopvcvpi);
	//enableButton(document.adsl.autopvcadd);
  } else {
  	document.adsl.autopvc.value="OFF";
	document.adsl.enablepvc.value = 0;
	//disableTextField(document.adsl.autopvcvci);
	//disableTextField(document.adsl.autopvcvpi);
	//disableButton(document.adsl.autopvcadd);
  }
}

function autopvcCheckClick()
{
	var dVPI,dVCI;
	if (document.adsl.autopvc.checked == true) {

		document.adsl.enablepvc.value = 1;

		dVPI = getDigit(document.adsl.autopvcvpi.value, 1);
		if ( validateKey(document.adsl.autopvcvpi.value) == 0 ||
			(dVPI > 255 || dVPI < 0) ) {
			alert("Invalid VPI value! You should set a value between 0-255.");
			document.adsl.autopvcvpi.focus();
			return false;
		}

		dVCI = getDigit(document.adsl.autopvcvci.value, 1);
		if ( validateKey(document.adsl.autopvcvci.value) == 0 ||
			(dVCI > 65535 || dVCI < 0) ) {
			alert("Invalid VCI value! You should set a value between 0-65535.");
			document.adsl.autopvcvci.focus();
			return false;
		}

		if ( (dVPI == 0 && dVCI == 0) ) {
			alert("Invalid VPI/VCI value!");
			document.adsl.autopvcvpi.focus();
			return false;
		}

		document.adsl.addVPI.value = dVPI;
		document.adsl.addVCI.value = dVCI;

	}else {
		alert(" You should enable Auto-PVC search first.");
		return false;
	}
}

function hideGWInfo(hide) {
	var status = false;

	if (hide == 1)
		status = true;

	changeBlockState('gwInfo', status);

	if (hide == 0) {
		with (document.forms[0]) {
			if (dgwstatus == 255) {
				if (isValidIpAddress(gtwy) == true) {
					gwStr[0].checked = true;
					gwStr[1].checked = false;
					dstGtwy.value=gtwy;
					wanIf.disabled=true
				} else {
					gwStr[0].checked = false;
					gwStr[1].checked = true;
					dstGtwy.value = '';
				}
			}
			else if (dgwstatus != 239) {
					gwStr[1].checked = true;
					gwStr[0].checked = false;
					wanIf.disabled=false;
					wanIf.value=dgwstatus;
					dstGtwy.disabled=true;
			} else {
					gwStr[1].checked = false;
					gwStr[0].checked = true;
					wanIf.disabled=true;
					dstGtwy.disabled=false;
			}
		}
	}
}

function autoDGWclicked() {
	if (document.adsl.droute[0].checked == true) {
		hideGWInfo(1);
	} else {
		hideGWInfo(0);
	}
}

function gwStrClick() {
	with (document.forms[0]) {
		if (gwStr[1].checked == true) {
			dstGtwy.disabled = true;
			wanIf.disabled = false;
		}
		else {
			dstGtwy.disabled = false;
			wanIf.disabled = true;
		}
      	}
}

/* Mason Yu:20110307 START ipv6 setting */
function dhcp6cEnable()
{
	if(document.adsl.itfenable.checked)
		document.getElementById('dhcp6c_block').style.display="block";
	else
		document.getElementById('dhcp6c_block').style.display="none";
}

function ipv6StaticUpdate()
{
	if(document.adsl.staticIpv6.checked)
		document.getElementById('secIPv6Div').style.display="block";
	else
		document.getElementById('secIPv6Div').style.display="none";
}

function ipv6WanUpdate()
{
	ipv6StaticUpdate();
	dhcp6cEnable();
}

function ipv6SettingsDisable()
{
	document.getElementById('tbipv6wan').style.display="none";
	document.getElementById('secIPv6Div').style.display="none";
	document.getElementById('dhcp6c_ctrlblock').style.display="none";
}

function ipv6SettingsEnable()
{
	if(document.adsl.IpProtocolType.value != 1){
		document.getElementById('tbipv6wan').style.display="block";
		document.getElementById('dhcp6c_ctrlblock').style.display="block";
		ipv6WanUpdate();
  	}
}

function protocolChange()
{
	ipver = document.adsl.IpProtocolType.value;
	if(document.adsl.IpProtocolType.value == 1){
		if( document.adsl.adslConnectionMode.value ==1 ||
			document.adsl.adslConnectionMode.value ==4 ||
			document.adsl.adslConnectionMode.value ==5)
			ipSettingsEnable();
			ipv6SettingsDisable();
	}else if(document.adsl.adslConnectionMode.value !=8 ){
		if(document.adsl.IpProtocolType.value == 2){
			ipSettingsDisable();
		}else{
			if( document.adsl.adslConnectionMode.value ==1 ||
				document.adsl.adslConnectionMode.value ==4 ||
				document.adsl.adslConnectionMode.value ==5)
				ipSettingsEnable();
		}
		ipv6SettingsEnable();
	}
}
/* Mason Yu:20110307 END */
/*
function SubmitWANMode() // Magician: ADSL/Ethernet WAN mode switch
{
	var wmmap = 0;
	var config_num = 3;

	with (document.forms[0])
	{
		for(var i = 0; i < config_num; i ++)
			if(wmchkbox[i].checked == true)
				wmmap |= (0x1 << i);

		if(wmmap == 0 || wmmap == wanmode)
			return false;

		wan_mode.value = wmmap;
	}

	return confirm("It needs rebooting to change WAN mode.");
}
*/

function click1q()
{
	if (document.adsl.vlan[0].checked){
		document.adsl.vid.disabled=true;
		document.adsl.vprio.disabled=true;}
	else{
		document.adsl.vid.disabled=false;
		document.adsl.vprio.disabled=false;
		document.adsl.vprio.selectedIndex=0;}
}

function check1q(str)
{
	for (var i=0; i<str.length; i++) {
		if ((str.charAt(i) >= '0' && str.charAt(i) <= '9'))
			continue;
		return false;
	}
	d = parseInt(str, 10);
	if (d < 0 || d > 4095)
		return false;
	return true;
}

function apply1q()
{
	if (!check1q(document.adsl.vid.value)) {
		alert("Invalid VLAN ID!");
		document.adsl.vid.focus();
		return false;
	}
	return true;
}

</script>

</head>
<BODY>
<blockquote>
<h2><font color="#0000FF"><% multilang("DSL WAN"); %><% multilang("Configuration"); %></font></h2>
<form action=/boaform/admin/formWanAdsl method=POST name="adsl">
<table border="0" cellspacing="4" width="800">
 <tr><td><font size=2>
    <% multilang("This page is used to configure the parameters for DSL WAN of your Router."); %>
 </font></td></tr>
 <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<!--<table border="0" cellspacing="4" width="800" <% WANConditions(); %>>
	<tr>
		<td>
			<b><% multilang("WAN Mode"); %>:</b>
			<span <% checkWrite("wan_mode_atm"); %>><input type="checkbox" value=1 name="wmchkbox">ATM</span>
			<span <% checkWrite("wan_mode_ethernet"); %>><input type="checkbox" value=2 name="wmchkbox">Ethernet</span>
			<span <% checkWrite("wan_mode_ptm"); %>><input type="checkbox" value=4 name="wmchkbox">PTM</span>&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="hidden" name="wan_mode" value=0>
			<input type="submit" value="Submit" name="submitwan" onClick="return SubmitWANMode()">
		</td>
	</tr> 
	<tr><td><hr size=1 noshade align=top></td></tr>
</table> -->
<table border=0 width="800" cellspacing=4 cellpadding=0>
	<tr>
		<td>
			<font size=2><b>VPI: </b>
			<input type="text" name="vpi" size="4" maxlength="3" value=0>&nbsp;&nbsp;
			<b>VCI: </b>
			<input type="text" name="vci" size="6" maxlength="5"></font></td>
		<td><font size=2><b><% multilang("Encapsulation"); %>: </b>
			<input type="radio" value="1" name="adslEncap" checked>LLC&nbsp;&nbsp;
			<input type="radio" value="0" name="adslEncap">VC-Mux</font></td>
		<td>
		<% ShowChannelMode("adslcmode"); %>
		</td>
	</tr>
	<tr>
		<td>
		<% ShowNAPTSetting(); %>
		</td>
		<td <% checkWrite("IPQoS"); %>><font size=2>
			<b>Enable QoS: </b>
			<input type="checkbox" name="qosEnabled" size="2" maxlength="2" value="ON" >
		</font></td>
	</tr>
	<tr>
		<td>
			<font size=2><b><% multilang("Admin Status"); %>:</b>
			<input type="radio" value=1 name="chEnable" checked><% multilang("Enable"); %>&nbsp;&nbsp;
			<input type="radio" value=0 name="chEnable"><% multilang("Disable"); %></font>
		</td>
	</tr>
	<% ShowConnectionType() %>
</table>
<div ID=vlan_show style="display:none">
<table>
	<td><font size=2><b>Enable VLAN:</b>
		<input type=radio value=0 name="vlan" checked onClick=click1q()>Disable&nbsp;&nbsp;
		<input type=radio value=1 name="vlan"  onClick=click1q()>Enable
	</font></td><td></td>
	<td><font size=2>
		VLAN ID(0-4095):&nbsp;&nbsp;
		<input type=text name=vid size=6 maxlength=4 value=0 disabled>
	</font></td><td></td>
	<td><font size=2><% multilang("802.1p_Mark"); %>:
	  <select style="WIDTH: 60px" name="vprio">
		<option value="0" >  </option>
		<option value="1" > 0 </option>
		<option value="2" > 1 </option>
		<option value="3" > 2 </option>
		<option value="4" > 3 </option>
		<option value="5" > 4 </option>
		<option value="6" > 5 </option>
		<option value="7" > 6 </option>
		<option value="8" > 7 </option>
	  </select>
	</font></td>
</table>
</div>
<div ID=dgwshow style="display:none">
<table>
<td><font size=2><b><% multilang("Default Route"); %>:</b>
	<input type=radio value=0 name="droute"><% multilang("Disable"); %>
	<input type=radio value=1 name="droute" checked><% multilang("Enable"); %></font>
</td>
</table>
</div>

<div ID=IGMPProxy_show style="display:none">
<table>
	<% ShowIGMPSetting(); %>
</table>
</div>

<!-- Mason Yu:20110307 ipv6 setting -->
<% ShowIpProtocolType(); %>

<% ShowPPPIPSettings("atm"); %>
<% ShowDefaultGateway("p2p"); %>

<% Show6rdSetting(); %>
<!-- Mason Yu:20110307 ipv6 setting -->
<% ShowIPV6Settings(); %>
<% ShowPortMapping(); %>
<% ShowDSLiteSetting(); %>

<BR>
<input type="hidden" value=<% getInfo("url_wanadsl"); %> name="submit-url">
<input type="submit" value="<% multilang("Add"); %>" name="add" onClick="return addClick()">
<input type="submit" value="<% multilang("Modify"); %>" name="modify" onClick="return vcCheck()">
<BR>
<BR>

<table border="0" width=900>
	<tr><font size=2><b><% multilang("Current ATM VC Table"); %>:</b></font></tr>
	<% atmVcList2(); %>

</table>
<br>
<input type="submit" value="<% multilang("Delete Selected"); %>" name="delvc" onClick="return deleteClick()">

<% ShowAutoPVC(); %>

	<input type="hidden" name="itfGroup" value=0>
<script>
	initConnectMode = document.adsl.adslConnectionMode.selectedIndex;

	<% initPage("dgw"); %>
	<% GetDefaultGateway(); %>
	autoDGWclicked();
	adslConnectionModeSelection();
	<% checkWrite("devType");
	   checkWrite("vcCount"); %>
</script>
</form>

<form action=/boaform/admin/formWanAdsl method=POST name="actionForm">
<input type="hidden" value="/wanadsl.asp" name="submit-url">
<input type="hidden" name="action">
<input type="hidden" name="idx">
<!--<script>
	var wanmode = <% getInfo("wan_mode"); %>;

	if((wanmode & 1) == 1)
		document.adsl.wmchkbox[0].checked = true;

	if((wanmode & 2) == 2)
		document.adsl.wmchkbox[1].checked = true;

	if((wanmode & 4) == 4)
		document.adsl.wmchkbox[2].checked = true;
</script> -->
</form>

</blockquote>
</body>
</html>
