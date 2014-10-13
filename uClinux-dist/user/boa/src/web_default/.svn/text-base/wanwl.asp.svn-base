<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Wireless WAN"); %></title>
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

var curlink = null;
var ctype = 4;

var cgi = new Object();
var links = new Array();

//var wlanMode = new Array();
//var rptEnabled = new Array();

with(links){<% initPageWaneth("wlan"); %>}

function pppTypeSelection()
{
	if ( document.ethwan.pppConnectType.selectedIndex == 2) {
		document.ethwan.pppIdleTime.value = "";
		disableTextField(document.ethwan.pppIdleTime);
	}
	else {
		if (document.ethwan.pppConnectType.selectedIndex == 1) {
			enableTextField(document.ethwan.pppIdleTime);
		}
		else {
			document.ethwan.pppIdleTime.value = "";
			disableTextField(document.ethwan.pppIdleTime);
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

function check_dhcp_opts()
{
	with (document.forms[0])
	{
		/* Option 60 */
		if(typeof enable_opt_60 !== 'undefined' &&enable_opt_60.checked)
		{
			if (opt60_val.value=="") {
				alert('Vendor ID cannot be empty!');
				opt60_val.focus();
				return false;
			}
			if (checkString(opt60_val.value) == 0) {
				alert('Invalid Vendor ID.');
				opt60_val.focus();
				return false;
			}
		}

		/* Option 61 */
		if(typeof enable_opt_61 !== 'undefined'&&enable_opt_61.checked)
		{
			if (iaid.value=="") {
				alert('IAID cannot be empty!');
				iaid.focus();
				return false;
			}
			if (checkDigit(iaid.value) == 0) {
				alert('IAID should be a number.');
				iaid.focus();
				return false;
			}

			if(duid_type[1].checked)
			{
				/* Enterprise number + Identifier*/
				if (duid_ent_num.value=="") {
					alert('Enterprise number cannot be empty!');
					duid_ent_num.focus();
					return false;
				}
				if (checkDigit(duid_ent_num.value) == 0) {
					alert('Enterprise number should be a number.');
					duid_ent_num.focus();
					return false;
				}

				if (duid_id.value=="") {
					alert('DUID Identifier cannot be empty!');
					duid_id.focus();
					return false;
				}
				if (checkString(duid_id.value) == 0) {
					alert('Invalid DUID Identifier.');
					duid_id.focus();
					return false;
				}
			}
		}

		if(typeof enable_opt_125 !== 'undefined' &&enable_opt_125.checked)
		{
			if (manufacturer.value=="") {
				alert('Manufacturer OUI cannot be empty!');
				manufacturer.focus();
				return false;
			}
			if (checkString(manufacturer.value) == 0) {
				alert('Invalid Manufacturer OUI.');
				manufacturer.focus();
				return false;
			}

			if (product_class.value=="") {
				alert('Product Class cannot be empty!');
				product_class.focus();
				return false;
			}
			if (checkString(product_class.value) == 0) {
				alert('Invalid Product Class.');
				product_class.focus();
				return false;
			}

			if (model_name.value=="") {
				alert('Model Name cannot be empty!');
				model_name.focus();
				return false;
			}
			if (checkString(model_name.value) == 0) {
				alert('Invalid Model Name.');
				model_name.focus();
				return false;
			}

			if (serial_num.value=="") {
				alert('Serial Number cannot be empty!');
				serial_num.focus();
				return false;
			}
			if (checkString(serial_num.value) == 0) {
				alert('Invalid Serial Number.');
				serial_num.focus();
				return false;
			}
		}
	}
}

function applyCheck()
{
	var tmplst = "";
	var ptmap = 0;
	var pmchkpt = document.getElementById("tbl_pmap");

	if (pmchkpt) {
		with (document.forms[0]) {
			for(var i = 0; i < 9; i ++) if(chkpt[i].checked == true) ptmap |= (0x1 << i);
			itfGroup.value = ptmap;
		}
	}

	if (checkDefaultGW()==false)
		return false;

	if (document.ethwan.vlan.checked == true) {
		if (document.ethwan.vid.value == "") {
			alert('VID should not be empty!');
			document.ethwan.vid.focus();
			return false;
		}
		if (document.ethwan.vid.value <= 9)
		{
			alert('VID 0-9 are reserved!');
			document.ethwan.vid.focus();
			return false;
		}
	}

	if ( document.ethwan.adslConnectionMode.value == 2 ) {
		if (document.ethwan.pppUserName.value=="") {
			alert('PPP user name cannot be empty!');
			document.ethwan.pppUserName.focus();
			return false;
		}
		if (includeSpace(document.ethwan.pppUserName.value)) {
			alert('Cannot accept space character in PPP user name.');
			document.ethwan.pppUserName.focus();
			return false;
		}
		if (checkString(document.ethwan.pppUserName.value) == 0) {
			alert('Invalid PPP user name.');
			document.ethwan.pppUserName.focus();
			return false;
		}

		if (document.ethwan.pppPassword.value=="") {
			alert('PPP password cannot be empty!');
			document.ethwan.pppPassword.focus();
			return false;
		}
		if (includeSpace(document.ethwan.pppPassword.value)) {
			alert('Cannot accept space character in PPP password.');
			document.ethwan.pppPassword.focus();
			return false;
		}
		if (checkString(document.ethwan.pppPassword.value) == 0) {
			alert('Invalid PPP password.');
			document.ethwan.pppPassword.focus();
			return false;
		}
		if (document.ethwan.pppConnectType.selectedIndex == 1) {
			if (document.ethwan.pppIdleTime.value <= 0) {
				alert('Invalid PPP idle time.');
				document.ethwan.pppIdleTime.focus();
				return false;
			}
		}
	}

	if (<% checkWrite("IPv6Show"); %>) {
		if(document.ethwan.IpProtocolType.value & 1){
			if ( document.ethwan.adslConnectionMode.value == 1 ) {
				if (document.ethwan.ipMode[0].checked)
				{
					/*Fixed IP*/
					if ( document.ethwan.ipUnnum.disabled || ( !document.ethwan.ipUnnum.disabled && !document.ethwan.ipUnnum.checked )) {
						if (!checkHostIP(document.ethwan.ip, 1))
							return false;
						if (document.ethwan.remoteIp.visiblity == "hidden") {
							if (!checkHostIP(document.ethwan.remoteIp, 1))
							return false;
						}
						if (document.ethwan.adslConnectionMode.value == 1 && !checkNetmask(document.ethwan.netmask, 1))
							return false;
					}
				}
				else
				{
					/* DHCP */
					if(check_dhcp_opts() == false)
						return false;
				}
			}
		}
	}

	if (<% checkWrite("IPv6Show"); %>) {
		if(document.ethwan.IpProtocolType.value & 2)
		{
			if (document.ethwan.adslConnectionMode.value != 0 && document.ethwan.adslConnectionMode.value != 6 && document.ethwan.adslConnectionMode.value != 8) {
				if(document.ethwan.slacc.checked == false && document.ethwan.itfenable.checked == false && document.ethwan.staticIpv6.checked == false){
					alert("Please input ipv6 address or open DHCPv6 client or click SLAAC!");
					document.ethwan.slacc.focus();
					return false;
				}
			}
			if(document.ethwan.itfenable.checked) {
				if(document.ethwan.iana.checked == false && document.ethwan.iapd.checked == false ) {
					alert("Please select iana or iapd!");
					document.ethwan.iana.focus();
					return false;
				}
			}

			if(document.ethwan.staticIpv6.checked) {
				if(document.ethwan.Ipv6Addr.value == "" || document.ethwan.Ipv6PrefixLen.value == "") {
					alert("Please input ipv6 address and Prefix Length!");
					document.ethwan.Ipv6Addr.focus();
					return false;
				}
				if(document.ethwan.Ipv6Addr.value != ""){
					if (! isGlobalIpv6Address( document.ethwan.Ipv6Addr.value) ){
						alert("Invalid ipv6 address!");
						document.ethwan.Ipv6Addr.focus();
						return false;
					}
					var prefixlen= getDigit(document.ethwan.Ipv6PrefixLen.value, 1);
					if (prefixlen > 128 || prefixlen <= 0) {
						alert("Invalid ipv6 prefix length!");
						document.ethwan.Ipv6PrefixLen.focus();
						return false;
					}
				}
				if(document.ethwan.Ipv6Gateway.value != "" ){
					if (! isUnicastIpv6Address( document.ethwan.Ipv6Gateway.value) ){
						alert("Invalid ipv6 gateway address!");
						document.ethwan.Ipv6Gateway.focus();
						return false;
					}
				}
			}
			else{
				document.ethwan.Ipv6Addr.value = "";
				document.ethwan.Ipv6PrefixLen.value = "";
				document.ethwan.Ipv6Gateway.value = "";
			}

            if (<% checkWrite("6rdShow"); %>) {

				if (document.ethwan.adslConnectionMode.value == 8) // 6rd
				{
					if(document.ethwan.SixrdBRv4IP.value == ""){
						alert("Invalid 6rd Board Router v4IP address!");
						document.ethwan.SixrdBRv4IP.focus();
						return false;
					}

					if(document.ethwan.SixrdIPv4MaskLen.value == ""){
						alert("Invalid 6rd IPv4 Mask length address!");
						document.ethwan.SixrdIPv4MaskLen.focus();
						return false;
					}

					if(document.ethwan.SixrdPrefix.value == ""){
						alert("Invalid 6rd Prefix address!");
						document.ethwan.SixrdPrefix.focus();
						return false;
					}

					if(document.ethwan.SixrdPrefixLen.value == ""){
						alert("Invalid 6rd Prefix length address!");
						document.ethwan.SixrdPrefixLen.focus();
						return false;
					}
				}
				else{

					document.ethwan.SixrdBRv4IP.value = "";
					document.ethwan.SixrdIPv4MaskLen.value = "";
					document.ethwan.SixrdPrefix.value = "";
					document.ethwan.SixrdPrefixLen.value = "";
				}

			}

			if (<% checkWrite("DSLiteShow"); %>) {
				if (document.ethwan.adslConnectionMode.value == 6) // DS-Lite
				{
					if(document.ethwan.DSLiteLocalIP.value != ""){
						if (! isGlobalIpv6Address( document.ethwan.DSLiteLocalIP.value) ){
							alert("Invalid DSLiteLocalIP address!");
							document.ethwan.DSLiteLocalIP.focus();
							return false;
						}
					}

					if(document.ethwan.DSLiteRemoteIP.value != ""){
						if (! isGlobalIpv6Address( document.ethwan.DSLiteRemoteIP.value) ){
							alert("Invalid DSLiteRemoteIP address!");
							document.ethwan.DSLiteRemoteIP.focus();
							return false;
						}
					}

					if(document.ethwan.DSLiteGateway.value != ""){
						if (! isGlobalIpv6Address( document.ethwan.DSLiteGateway.value) ){
							alert("Invalid DSLiteGateway address!");
							document.ethwan.DSLiteGateway.focus();
							return false;
						}
					}
				}
				else{
					document.ethwan.DSLiteLocalIP.value = "";
					document.ethwan.DSLiteRemoteIP.value = "";
					document.ethwan.DSLiteGateway.value = "";
				}
			}
		}
	}

//	if(document.ethwan.lkname.value != "new") tmplst = curlink.name;
//	document.ethwan.lst.value = tmplst;

	return true;
}

function deleteCheck()
{
	var tmplst = "";

	if ( document.ethwan.lkname.value == "new" )
	{
		alert('no link selected!');
		return false;
	}

	tmplst = curlink.name;
	document.ethwan.lst.value = tmplst;

	return true;
}

function setPPPConnected()
{
	pppConnectStatus = 1;
}

function disableFixedIpInput()
{
	disableTextField(document.ethwan.ip);
	disableTextField(document.ethwan.remoteIp);
	disableTextField(document.ethwan.netmask);
}

function enableFixedIpInput()
{
	enableTextField(document.ethwan.ip);
	enableTextField(document.ethwan.remoteIp);
	if (document.ethwan.adslConnectionMode.value == 4)
		disableTextField(document.ethwan.netmask);
	else
		enableTextField(document.ethwan.netmask);
}

function ipTypeSelection()
{
	if ( document.ethwan.ipMode[0].checked ) {
		enableFixedIpInput();
		showDhcpOptSettings(0);
	} else {
		disableFixedIpInput();
		showDhcpOptSettings(1);
	}
}

function enable_pppObj()
{
	enableTextField(document.ethwan.pppUserName);
	enableTextField(document.ethwan.pppPassword);
	enableTextField(document.ethwan.pppConnectType);
	document.ethwan.gwStr[0].disabled = false;
	document.ethwan.gwStr[1].disabled = false;
	enableTextField(document.ethwan.dstGtwy);
	document.ethwan.wanIf.disabled = false;
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
	disableTextField(document.ethwan.pppUserName);
	disableTextField(document.ethwan.pppPassword);
	disableTextField(document.ethwan.pppIdleTime);
	disableTextField(document.ethwan.pppConnectType);

	document.ethwan.gwStr[0].disabled = true;
	document.ethwan.gwStr[1].disabled = true;
	disableTextField(document.ethwan.dstGtwy);
	document.ethwan.wanIf.disabled = true;
}

function pppSettingsDisable()
{
	document.getElementById('tbl_ppp').style.display='none';
	disable_pppObj();
}

function enable_ipObj()
{
	document.ethwan.ipMode[0].disabled = false;
	document.ethwan.ipMode[1].disabled = false;
	document.ethwan.gwStr[0].disabled = false;
	document.ethwan.gwStr[1].disabled = false;
	enableTextField(document.ethwan.dstGtwy);
	document.ethwan.wanIf.disabled = false;
	ipTypeSelection();
	autoDGWclicked();
}

function ipSettingsEnable()
{
	//if (ipver == 2)
	//	return;
	document.getElementById('tbl_ip').style.display='block';
	enable_ipObj();
}

function disable_ipObj()
{
	document.ethwan.ipMode[0].disabled = true;
	document.ethwan.ipMode[1].disabled = true;
	document.ethwan.gwStr[0].disabled = true;
	document.ethwan.gwStr[1].disabled = true;
	disableTextField(document.ethwan.dstGtwy);
	document.ethwan.wanIf.disabled = true;
	disableFixedIpInput();
}

function ipSettingsDisable()
{
	document.getElementById('tbl_ip').style.display='none';
	showDhcpOptSettings(0);
	disable_ipObj();
}

function showDuidType2(show)
{
	if(show == 1)
	{
		document.getElementById('duid_t2_ent').style.display = '';
		document.getElementById('duid_t2_id').style.display = '';
	}
	else
	{
		document.getElementById('duid_t2_ent').style.display = 'none';
		document.getElementById('duid_t2_id').style.display = 'none';
	}
}

function showDhcpOptSettings(show)
{
	var dhcp_opt = document.getElementById('tbl_dhcp_opt');

	if(dhcp_opt == null)
		return ;

	if(show == 1)
	{
		document.getElementById('tbl_dhcp_opt').style.display='block';

		if(document.ethwan.duid_type[1].checked == true)
			showDuidType2(1);
		else
			showDuidType2(0);
	}
	else
		document.getElementById('tbl_dhcp_opt').style.display='none';
}

function ipModeSelection()
{
	if (document.ethwan.ipUnnum.checked) {
		disable_pppObj();
		disable_ipObj();
		document.ethwan.gwStr[0].disabled = false;
		document.ethwan.gwStr[1].disabled = false;
		enableTextField(document.ethwan.dstGtwy);
		document.ethwan.wanIf.disabled = false;
	}
	else
		enable_ipObj();
}

function updateBrMode(isLinkChanged)
{
	var brmode_ops = document.getElementById('brmode');

	if(!brmode_ops)
		return ;

	// reset to transparent bridge
	if(!isLinkChanged)
	{
		document.ethwan.br.checked = false;
		brmode_ops.value = 0;
		brmode_ops.disabled = true;
	}

	if(document.ethwan.adslConnectionMode.value == 0)
	{
		document.getElementById('br_row').style.display = "none";
		brmode_ops.disabled = false;
	}
	else
	{
		document.getElementById('br_row').style.display = "";
	}
}

function brClicked()
{
	var brmode_ops = document.getElementById('brmode');

	if(!brmode_ops)
		return ;

	if(document.ethwan.br.checked)
		brmode_ops.disabled = false;
	else
		brmode_ops.disabled = true;
}

function adslConnectionModeSelection(isLinkChanged)
{
	document.ethwan.naptEnabled.disabled = false;
	document.ethwan.igmpEnabled.disabled = false;
	document.ethwan.ipUnnum.disabled = true;

	document.ethwan.droute[0].disabled = false;
	document.ethwan.droute[1].disabled = false;

	document.getElementById('tbl_ppp').style.display='none';
	document.getElementById('tbl_ip').style.display='none';

	if(document.getElementById('tbl_dhcp_opt') != null)
		document.getElementById('tbl_dhcp_opt').style.display='none';

	document.getElementById('6rdDiv').style.display='none';
	if (<% checkWrite("IPv6Show"); %>) {
		ipv6SettingsEnable();
		document.getElementById('tbprotocol').style.display="block";
		document.ethwan.IpProtocolType.disabled = false;
		if (<% checkWrite("DSLiteShow"); %>) {
			document.getElementById('DSLiteDiv').style.display="none";
		}
	}
	/*
	if(<% checkWrite("dualband_concurrent"); %>){
		document.getElementById('wanwl').style.display="";
		document.ethwan.wlwan[0].disabled = true;
		document.ethwan.wlwan[1].disabled = true;
		if(wlanMode[0]==1 || rptEnabled[0]==1){
			document.ethwan.wlwan[0].disabled = false;
		}
		if(wlanMode[1]==1 || rptEnabled[1]==1){
			document.ethwan.wlwan[1].disabled = false;
		}
	}*/

	//e = document.getElementById("qosEnabled");
	//if (e) e.disabled = false;
	//alert(document.ethwan.adslConnectionMode.value);
	switch(document.ethwan.adslConnectionMode.value){
		case '0':// bridge mode
		//case '3':// DS-Lite
		case '6':// DS-Lite
			document.ethwan.naptEnabled.disabled = true;
			document.ethwan.igmpEnabled.disabled = true;
			document.ethwan.droute[0].disabled = true;
			document.ethwan.droute[1].disabled = true;
			pppSettingsDisable();
			ipSettingsDisable();

			if (<% checkWrite("IPv6Show"); %>) {
				ipv6SettingsDisable();
				document.getElementById('tbprotocol').style.display="none";
			}

			// For DS-Lite only
			if (<% checkWrite("IPv6Show"); %> && <% checkWrite("DSLiteShow"); %>) {
				if ( document.ethwan.adslConnectionMode.value == 6 )
				{
					document.getElementById('DSLiteDiv').style.display='block';
					document.ethwan.droute[0].disabled = false;
					document.ethwan.droute[1].disabled = false;
					//document.ethwan.qosEnabled.disabled = true;
					//document.getElementById('tbprotocol').style.display="block";

					// Set some values for DS-Lite mer mode only
					document.ethwan.IpProtocolType.value = 2;     // IPV6 only
					//document.ethwan.IpProtocolType.disabled = true;
					document.ethwan.slacc.checked = false;        // not use slaac
					document.ethwan.staticIpv6.checked = false;   // not use static IP
					document.ethwan.itfenable.checked = false;    // not enable DHCPv6 client
				}
			}
			//if (e) e.disabled = false;
			break;
		case '8': //6rd
			if (<% checkWrite("IPv6Show"); %> && <% checkWrite("6rdShow"); %>)
			{
				document.getElementById('6rdDiv').style.display='block';
				document.ethwan.droute[0].checked = false;
				document.ethwan.droute[1].checked = true;
				// Set some values for DS-Lite mer mode only
				document.ethwan.IpProtocolType.value = 3;     // IPV4/IPV6
				//document.ethwan.IpProtocolType.disabled = true;
				document.ethwan.slacc.checked = false;        // not use slaac
				document.ethwan.staticIpv6.checked = false;   // not use static IP
				document.ethwan.itfenable.checked = false;    // not enable DHCPv6 client
				ipSettingsEnable();
				enableFixedIpInput();
				ipv6SettingsDisable();
				document.getElementById('tbprotocol').style.display="none";
			}
            break;
		case '1'://1483mer
			pppSettingsDisable();
			if (<% checkWrite("IPv6Show"); %>) {
				if(document.ethwan.IpProtocolType.value != 2)		// It is not IPv6 only
					ipSettingsEnable();
			}
			else
				ipSettingsEnable();
			break;
		case '2'://pppoe
			document.getElementById('tbl_ppp').style.display='block';
			ipSettingsDisable();
			pppSettingsEnable();
			break;
		default:
			pppSettingsDisable();
			ipSettingsEnable();
	}

	//updateBrMode(isLinkChanged);
}

function naptClicked()
{
	if (document.ethwan.adslConnectionMode.value == 3) {
		// Route1483
		if (document.ethwan.naptEnabled.checked == true) {
			document.ethwan.ipUnnum.checked = false;
			document.ethwan.ipUnnum.disabled = true;
		}
		else
			document.ethwan.ipUnnum.disabled = false;
		ipModeSelection();
	}
}

function vlanClicked()
{
	if (document.ethwan.vlan.checked)
	{
		document.ethwan.vid.disabled = false;
		document.ethwan.vprio.disabled = false;
	}
	else {
		document.ethwan.vid.disabled = true;
		document.ethwan.vprio.disabled = true;
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
	if (document.ethwan.droute[0].checked == true) {
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

function dhcp6cEnable()
{
	if(document.ethwan.itfenable.checked)
		document.getElementById('dhcp6c_block').style.display="block";
	else
		document.getElementById('dhcp6c_block').style.display="none";
}

function ipv6StaticUpdate()
{
	if(document.ethwan.staticIpv6.checked)
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
	if(document.ethwan.IpProtocolType.value != 1){
		document.getElementById('tbipv6wan').style.display="block";
		document.getElementById('dhcp6c_ctrlblock').style.display="block";
		ipv6WanUpdate();
  	}
}

function protocolChange()
{
	ipver = document.ethwan.IpProtocolType.value;
	if(document.ethwan.IpProtocolType.value == 1){
		if( document.ethwan.adslConnectionMode.value ==1 ||
			document.ethwan.adslConnectionMode.value ==4 ||
			document.ethwan.adslConnectionMode.value ==5)
			ipSettingsEnable();
			ipv6SettingsDisable();
	}else{
		if(document.ethwan.IpProtocolType.value == 2){
			ipSettingsDisable();
		}else{
			if( document.ethwan.adslConnectionMode.value ==1 ||
				document.ethwan.adslConnectionMode.value ==4 ||
				document.ethwan.adslConnectionMode.value ==5)
				ipSettingsEnable();
		}
		ipv6SettingsEnable();
	}
}
/* Mason Yu:20110307 END */

function on_linkchange(itlk)
{
	var pmchkpt = document.getElementById("tbl_pmap");

	with ( document.forms[0] )
	{
		if(itlk == null)
		{
			//select
			adslConnectionMode.value = pppConnectType.value /*= brmode.value*/ = 0;
			IpProtocolType.value = 1;
			// ctype
			ctype.value = 4;

			//radio
			ipMode[0].checked = droute[0].checked = true;
			chEnable[0].checked = true;

			if(typeof duid_type !== 'undefined')
				duid_type[1].checked = true;

			//checkbox
			naptEnabled.checked /*= vlan.checked = qosEnabled.checked */ = igmpEnabled.checked = false;

			if(typeof enable_opt_60 !== 'undefined')
				enable_opt_60.checked = enable_opt_61.checked = enable_opt_125.checked = false;

			//input number
			//vprio.value = vid.value = "0";
			//vid.value = "";
			//input ip
			ip.value = remoteIp.value = "0.0.0.0";
			netmask.value = "255.255.255.0";

			//input text
			pppUserName.value = pppPassword.value = "";

			//checkbox
			slacc.checked = staticIpv6.checked = itfenable.checked = false;
			//document.ethwan.br.checked = false;

			//port mapping
			if (pmchkpt)
				for(var i = 0; i < 9; i ++) chkpt[i].checked = false;
		}
		else
		{
			//sji_onchanged(document, itlk);

			//select
			adslConnectionMode.value = itlk.cmode;

			//ctype
			ctype.value = itlk.applicationtype;

			//brmode
			/*
			if(document.ethwan.br)
			{
				document.ethwan.br.checked = false;
				if(itlk.brmode == 2)
				{
					// Disable Bridge
					brmode.value = 0;
					brmode.disabled = true;
				}
				else
				{
					// Enable Bridge
					if(itlk.cmode != 0)
						document.ethwan.br.checked = true;

					brmode.value = itlk.brmode;
					brmode.disabled = false;
				}
			}
			*/

			//checkbox
			if (itlk.napt == 1)
				naptEnabled.checked = true;
			else
				naptEnabled.checked = false;
			if (itlk.enableIGMP == 1)
				igmpEnabled.checked = true;
			else
				igmpEnabled.checked = false;
			//if (itlk.enableIpQos == 1)
			//	qosEnabled.checked = true;
			//else
			//	qosEnabled.checked = false;
			//if (itlk.vlan == 1)
			//{
			//	vlan.checked = true;
			//	vid.value = itlk.vid;
			//	vprio.value = itlk.vprio;
			//}
			//else
			//	vlan.checked = false;
			//radio
			if (itlk.dgw == 1)
				droute[1].checked = true;
			else
				droute[0].checked = true;
			if (itlk.enable == 1)
				chEnable[0].checked = true;
			else
				chEnable[1].checked = true;

			//radio
			if(itlk.cmode != 0)//not bridge
			{
				IpProtocolType.value = itlk.IpProtocol;
				if (IpProtocolType.value != 1)
				{
					if (itlk.AddrMode & 1)
						slacc.checked = true;
					else
						slacc.checked = false;
					if (itlk.AddrMode & 2)
					{
						staticIpv6.checked = true;
						Ipv6Addr.value = itlk.Ipv6Addr;
						Ipv6PrefixLen.value = itlk.Ipv6AddrPrefixLen;
						Ipv6Gateway.value = itlk.RemoteIpv6Addr;
					}
					else
						staticIpv6.checked = false;

					if (itlk.Ipv6Dhcp)
					{
						itfenable.checked = true;
						if (itlk.Ipv6DhcpRequest & 1)
							iana.checked = true;
						else
							iana.checked = false;
						if (itlk.Ipv6DhcpRequest & 2)
							iapd.checked = true;
						else
							iapd.checked = false;
					}
					else
						itfenable.checked = false;

					// DS-Lite
					if (itlk.AddrMode & 4)
					{
						DSLiteLocalIP.value = itlk.Ipv6Addr;
						DSLiteRemoteIP.value = itlk.RemoteIpv6EndPointAddr;
						DSLiteGateway.value = itlk.RemoteIpv6Addr;
						adslConnectionMode.value = 6;
					}


					// 6rd
					if (itlk.AddrMode & 8)
					{
						adslConnectionMode.value = 8;
						SixrdBRv4IP.value = itlk.SixrdBRv4IP;
						SixrdIPv4MaskLen.value = itlk.SixrdIPv4MaskLen;
						SixrdPrefix.value = itlk.SixrdPrefix;
						SixrdPrefixLen.value = itlk.SixrdPrefixLen;
						ip.value = itlk.ipAddr;
						remoteIp.value = itlk.remoteIpAddr;
						netmask.value = itlk.netMask;
					}

				}

				if (itlk.cmode == 1)//IPoE
				{
					if (itlk.ipDhcp == 1)
						ipMode[1].checked = true;
					else
					{
						ipMode[0].checked = true;
						ip.value = itlk.ipAddr;
						remoteIp.value = itlk.remoteIpAddr;
						netmask.value = itlk.netMask;
					}
				}
				else if (itlk.cmode == 2)
				{
					pppUserName.value= itlk.pppUsername;
					pppPassword.value = itlk.pppPassword;
					pppConnectType.value = itlk.pppCtype;
					pppIdleTime.value = itlk.pppIdleTime;
				}
				protocolChange();
			}

			//DHCP options
			if(typeof enable_opt_60 !== 'undefined')
			{
				//assume all other elements are existed if enable_opt_60 is existed
				if(itlk.enable_opt_60)
					enable_opt_60.checked = true;

				opt60_val.value = itlk.opt60_val;

				if(itlk.enable_opt_61)
					enable_opt_61.checked = true;

				iaid.value = itlk.iaid;

				if(itlk.duid_type == 0)
					duid_type[0].checked = true;
				else
					duid_type[itlk.duid_type - 1].checked = true;
				duid_ent_num.value = itlk.duid_ent_num;
				duid_id.value = itlk.duid_id;

				if(itlk.enable_opt_125)
					enable_opt_125.checked = true;

				manufacturer.value = itlk.manufacturer;
				product_class.value = itlk.product_class;
				model_name.value = itlk.model_name;
				serial_num.value = itlk.serial_num;
			}

			//port mapping
			if (pmchkpt)
				for(var i = 0; i < 9; i ++) chkpt[i].checked = (itlk.itfGroup & (0x1 << i));

			wispItf.value = itlk.wlwan;
		}
	}
	ipver = document.ethwan.IpProtocolType.value;

	//vlanClicked();
	autoDGWclicked();
	adslConnectionModeSelection(true);
}

function on_ctrlupdate()
{
	with ( document.forms[0] )
	{
		if(lkname.value == "new")
		{
			curlink = null;
			on_linkchange(curlink);
		}
		else
		{
			curlink = links[lkname.value];
			on_linkchange(curlink);
		}
	}
}

function on_init()
{
	sji_docinit(document, cgi);

	curlink = links[0];
	on_linkchange(curlink);

/*
	with ( document.forms[0] )
	{
		for(var k in links)
		{
			var lk = links[k];
			lkname.options.add(new Option(lk.name, k));
		}
		lkname.options.add(new Option("new link", "new"));

		if(links.length > 0) lkname.selectedIndex = 0;
		on_ctrlupdate();
	}
*/
}

</script>

</head>
<BODY onLoad="on_init();">
<blockquote>
<h2><font color="#0000FF"><% multilang("Wireless WAN"); %></font></h2>
<form action=/boaform/admin/formWanEth method=POST name="ethwan">
<table border="0" cellspacing="4" width="800">
  <tr><td><font size=2>
    <% multilang("This page is used to configure the parameters for Wireless WAN of your Router."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="800" cellspacing=4 cellpadding=0>
<tr><td><% ShowWispWanItf(); %></td></tr>
<!--	<tr>
		<td>
			<select name="lkname" onChange="on_ctrlupdate()" size="1">
			<option value="new" selected>new link</option></select>
		</td>
	</tr>
-->
<!--
	<tr>
		<td>
			<font size=2><b><% multilang("Enable VLAN"); %>: </b><input type="checkbox" name="vlan" size="2" maxlength="2" value="ON" onClick=vlanClicked()>
		</td>
	</tr>
	<tr>
		<td>
			<font size=2><b><% multilang("VLAN"); %> ID:  </b><input type="text" name="vid" size="10" maxlength="15">
		</td>
		<td><font size=2><b><% multilang("802.1p_Mark"); %>  </b>
			<select style="WIDTH: 60px" name="vprio">
			<option value="0" >   </option>
			<option value="1" > 0 </option>
			<option value="2" > 1 </option>
			<option value="3" > 2 </option>
			<option value="4" > 3 </option>
			<option value="5" > 4 </option>
			<option value="6" > 5 </option>
			<option value="7" > 6 </option>
			<option value="8" > 7 </option>
			</select>
		</td>
	</tr>
-->
	<tr>

	</tr>

	<tr>
		<td>
		<% ShowChannelMode("wlancmode"); %>
		</td>
	</tr>

<!--<% ShowBridgeMode(); %> -->
	<tr>
		<td>
		<% ShowNAPTSetting(); %>
		</td>
<!--		<td <% checkWrite("IPQoS"); %>><font size=2>
			<b>Enable QoS: </b>
			<input type="checkbox" name="qosEnabled" size="2" maxlength="2" value="ON" >
		</font></td> -->
	</tr>
	<tr>
		<td><font size=2><b><% multilang("Admin Status"); %>:</b>
			<input type=radio value=1 name="chEnable">Enable
			<input type=radio value=0 name="chEnable" checked>Disable</font>
		</td>
	</tr>
	<% ShowConnectionType() %>
</table>
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

<% ShowIpProtocolType(); %>

<% ShowPPPIPSettings(""); %>
<% ShowDefaultGateway("p2p"); %>

<% Show6rdSetting(); %>
<% ShowIPV6Settings(); %>
<!--<% ShowPortMapping(); %> -->
<% ShowDSLiteSetting(); %>

<BR>
<input type="hidden" value="/wanwl.asp" name="submit-url">
<input type="hidden" value="yes" name="wlan_submit">
<input type="hidden" id="lst" name="lst" value="">
<input type="submit" value="<% multilang("Apply Changes"); %>" name="apply" onClick="return applyCheck()">&nbsp; &nbsp; &nbsp; &nbsp;
<!--<input type="submit" value="<% multilang("Delete"); %>" name="delete" onClick="return deleteCheck()"> -->
<input type="hidden" name="itfGroup" value=0>
<BR>
<BR>
<script>
	<% DisplayDGW(); %>

	var isConfigRTKRG = <% checkWrite("config_rtk_rg"); %>;

	if(isConfigRTKRG == "yes")
	{
		var mbt_dec = <% getInfo("mac_based_tag_decision"); %>-1+1;

		if(mbt_dec == 1)
			document.getElementById("div_pmap").style.display = "inline";
		else
			document.getElementById("div_pmap").style.display = "none";
	}
</script>
</form>
</blockquote>
</body>
</html>
