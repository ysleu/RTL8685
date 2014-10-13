<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta HTTP-EQUIV='Pragma' CONTENT='no-cache'>
<meta HTTP-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("WLAN Basic Settings"); %></title>
<style>
.on {display:on}
.off {display:none}
</style>
<script type="text/javascript" src="share.js">
</script>
<SCRIPT>
var regDomain, defaultChan, lastBand=0, lastMode=0;
var is_regdomain_demo=<% checkWrite("is_regdomain_demo"); %>;
var WiFiTest=<% getInfo("WiFiTest"); %>;
var wlan_idx= <% checkWrite("wlan_idx"); %>;
var ssid_2g="<% checkWrite("2G_ssid"); %>";
var ssid_5g="<% checkWrite("5G_ssid"); %>";
var defaultBand=<% checkWrite("band"); %>;
var dfs_enable=<% checkWrite("dfs_enable"); %>;
var wlan_support_8812e=<% checkWrite("wlan_support_8812e"); %>;
var channel_list_5g_dfs =[[],
					  [36,40,44,48,52,56,60,64,100,104,108,112,116,136,140,149,153,157,161,165],
					  [36,40,44,48,52,56,60,64,149,153,157,161],
					  [36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140],
					  [36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140],
					  [36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140],
					  [36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140],
					  [36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140],
					  [34,38,42,46],
					  [36,40,44,48],
					  [36,40,44,48,52,56,60,64],
					  [56,60,64,100,104,108,112,116,136,140,149,153,157,161,165],
					  [36,40,44,48,52,56,60,64,132,136,140,149,153,157,161,165],
					  [36,40,44,48,52,56,60,64,149,153,157,161,165],
    			      [36,40,44,48,52,56,60,64,100,104,108,112,116,136,140,149,153,157,161,165],
    			      [36,40,44,48,52,56,60,64,100,104,108,112,116,136,140,149,153,157,161,165],
    			      [36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140,144,149,153,157,161,165,169,173,177]
					  ];


var channel_list_5g =[[],
					  [36,40,44,48,149,153,157,161,165],
					  [36,40,44,48,149,153,157,161],
					  [36,40,44,48],
					  [36,40,44,48],
					  [36,40,44,48],
					  [36,40,44,48],
					  [36,40,44,48],
					  [34,38,42,46],
					  [36,40,44,48],
					  [36,40,44,48],
					  [56,60,64,149,153,157,161,165],
					  [36,40,44,48,149,153,157,161,165],
					  [36,40,44,48,149,153,157,161,165],
    			      [36,40,44,48,149,153,157,161,165],
    			      [36,40,44,48,149,153,157,161,165],
    			      [36,40,44,48,52,56,60,64,100,104,108,112,116,120,124,128,132,136,140,144,149,153,157,161,165,169,173,177]
					  ];					  

function skip () { this.blur(); }
function openWindow(url, windowName) {
	var wide=620;
	var high=420;
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


function showMacClick(url)
{
//  if (!document.wlanSetup.wlanDisabled.checked)
	if (document.wlanSetup.wlanDisabled.value != "ON")
		openWindow(url, 'showWirelessClient' );
}

function saveChanges()
{
	var idx_value= document.wlanSetup.band.selectedIndex;
	var selectText=document.wlanSetup.band.options[idx_value].text.substr(0,1);
	if (document.wlanSetup.ssid.value=="") {
		alert('SSID cannot be empty!');
		document.wlanSetup.ssid.value = document.wlanSetup.ssid.defaultValue;
		document.wlanSetup.ssid.focus();
		return false;
	}
/*
	if (includeSpace(document.wlanSetup.ssid.value)) {
		alert('Invalid SSID.');
		document.wlanSetup.ssid.focus();
		return false;
	}
	if (checkString(document.wlanSetup.ssid.value) == 0) {
		alert('Invalid SSID.');
		document.wlanSetup.ssid.focus();
		return false;
	}
*/
	if(selectText == '2') 
		document.wlanSetup.Band2G5GSupport.value = 1;	//1:PHYBAND_2G
	else
		document.wlanSetup.Band2G5GSupport.value = 2;	//2:PHYBAND_5G
	if (document.wlanSetup.wlanDisabled.value != "ON") {
		band = document.wlanSetup.band.value + 1;
/*
	   	band = 0;
		if (document.wlanSetup.band.selectedIndex == 0)
			band = 1;
		else if (document.wlanSetup.band.selectedIndex == 1)
			band = 2;
		else if (document.wlanSetup.band.selectedIndex == 2)
			band = 3;
		else if (document.wlanSetup.band.value == 7)
			band = 8;
		else if (document.wlanSetup.band.value == 9)
			band = 10;
		else if (document.wlanSetup.band.value == 10)
			band = 11;
		else
			band = 4;
*/
		basicRate=0;
		operRate=0;
		if (band & 1) {
			basicRate|=0xf;
			operRate|=0xf;
		}
		if ( (band & 2) || (band & 4) ) {
			operRate|=0xff0;
			if (!(band & 1)) {
				if (WiFiTest)
					basicRate=0x15f;
				else
					basicRate=0x1f0;
			}
		}
		if (band & 8) {
			if (!(band & 3))
				operRate|=0xfff;	
			if (band & 1)
				basicRate=0xf;
			else if (band & 2)			
				basicRate=0x1f0;
			else
				basicRate=0xf;
		}
		operRate|=basicRate;
	
		document.wlanSetup.basicrates.value = basicRate;
		document.wlanSetup.operrates.value = operRate;
	}

	return true;
}

function disableWLAN()
{
	disableTextField(document.wlanSetup.band);
	disableTextField(document.wlanSetup.mode);
	disableTextField(document.wlanSetup.ssid);
	disableTextField(document.wlanSetup.chanwid);
	disableTextField(document.wlanSetup.ctlband);
	disableTextField(document.wlanSetup.chan);
	disableTextField(document.wlanSetup.txpower);
	disableTextField(document.wlanSetup.regdomain_demo);
	disableButton(document.wlanSetup.showMac);
	disableButton(document.wlanSetup.multipleAP);
}

function enableWLAN()
{
	enableTextField(document.wlanSetup.band);
	enableTextField(document.wlanSetup.mode);
	enableTextField(document.wlanSetup.ssid);
	enableTextField(document.wlanSetup.chanwid);
	enableTextField(document.wlanSetup.ctlband);
	enableTextField(document.wlanSetup.chan);
	enableTextField(document.wlanSetup.txpower);
	enableTextField(document.wlanSetup.regdomain_demo);
	enableButton(document.wlanSetup.showMac);
	enableButton(document.wlanSetup.multipleAP);
	enableButton(document.wlanSetup.save);
	updateMode();
}

function updateChan_channebound()
{
	var idx_value= document.wlanSetup.band.selectedIndex;
	var band_value= document.wlanSetup.band.options[idx_value].value;
	var bound = document.wlanSetup.chanwid.selectedIndex;				/* 0:20Mhz, 1:40Mhz */
	var adjust_chan;

/*	
	if(band_value == 3){
		currentBand = 2;
	}
	else if(band_value == 0 || band_value == 1 || band_value == 2 || band_value == 9 || band_value == 10 || band_value == 7 ){
		currentBand = 1;
	}else if(band_value == 4 || band_value == 5 || band_value == 6){
		currentBand = 3;
	}
*/	
	if(band_value == 3 || band_value == 11 || band_value == 63 || band_value == 71 || band_value ==75){ // 3:5g_a 11:5g_an
		currentBand = 2;
	}
	else if(band_value == 7) //7:n
	{
		if(document.wlanSetup.Band2G5GSupport.value == 1) //1:2g
			currentBand = 1;
		else
			currentBand = 2;

		if(document.wlanSetup.wlanBand2G5GSelect.value == 3)
		{
			if(idx_value != 1)
				currentBand =1;
			else
				currentBand =2;
		}

	}
	else {
		currentBand = 1;
	}

	if(band_value == 9 || band_value == 10 || band_value == 7 || band_value == 11){		/* 11n */
		if(bound == 0)
			adjust_chan = 0;
		if(bound == 1)
			adjust_chan = 1;	
	}
	else
		adjust_chan = 0;	

/*
	if (currentBand == 3) {
		showChannel2G(adjust_chan, band_value);
		showChannel5G(form, wlan_id);
	}
    	if (currentBand == 2) {
		startChanIdx[wlan_id]=0;
		showChannel5G(form, wlan_id);
	}
*/    	
  	if (currentBand == 1)
		showChannel2G(adjust_chan, band_value);
	else if (currentBand == 2) {
		//startChanIdx[wlan_id]=0;
		showChannel5G(0, adjust_chan);
	}

  	if(lastMode == 0)
  		lastMode = band_value;

  	if(band_value == 9 || band_value == 10 || band_value == 7){
	  	if(document.wlanSetup.chan.selectedIndex ==0){
	  		disableTextField(document.wlanSetup.ctlband);	
		}
	}
}

function updateBand_selectedIndex(band)
{
	var band_idx = 0;
	
	while(band_idx < document.wlanSetup.band.length) {
		if(document.wlanSetup.band.options[band_idx].value == band) {
			if(band == 7) {	//11n
				var selectText=document.wlanSetup.band.options[band_idx].text.substr(0,1);
				if( document.wlanSetup.Band2G5GSupport &&
					((document.wlanSetup.Band2G5GSupport.value == 2 && selectText == '5')	 //Band2G5GSupport=2:PHYBAND_5G
					|| (document.wlanSetup.Band2G5GSupport.value == 1 && selectText == '2')) ) {		//Band2G5GSupport=1:PHYBAND_2G
					document.wlanSetup.band.selectedIndex = band_idx;
					break;
				}
			}
			else {
				document.wlanSetup.band.selectedIndex = band_idx;
				break;
			}
		}
		band_idx++;
	}
}

function showMultipleAP(form, url)
{
	var mode_idx = form.mode.selectedIndex;
	var mode_value = form.mode.options[mode_idx].value;
	if (!form.wlanDisabled.checked
		// 802.11s Mesh NOTICE: If Mesh work with Multiple AP, Add mode_value == 4 (AP+MPP) and mode_value == 6 (MAP)
		&& (mode_value==0 || mode_value==3 || mode_value==4 || mode_value==6))
		document.location.href = url;
}

function updateIputState()
{
	var band_value = document.wlanSetup.band.value;
//	var band_idx = 0;

	if(document.wlanSetup.wlanDisabled.checked == true) {
		document.wlanSetup.wlanDisabled.value="ON";
		disableWLAN();
	}
	else {
		document.wlanSetup.wlanDisabled.value="OFF";
		enableWLAN();
	}

	if(defaultChan == 0)
		disableTextField(document.wlanSetup.ctlband);
  
	if(band_value < 7) {
		if(document.getElementById)
			document.getElementById('optionfor11n').style.display = 'none';
		else if(document.layers == false)
			document.all.optionfor11n.style.display = 'none';
	}
	else {
		if(document.getElementById)
			document.getElementById('optionfor11n').style.display = 'block';
		else if(document.layers == false)
			document.all.optionfor11n.style.display = 'block';
	}
/*  
	while(band_idx < document.wlanSetup.band.length) {
		if(document.wlanSetup.band.options[band_idx].value == band_value) {
			if(band_value == 7) {	//11n
				var selectText=document.wlanSetup.band.options[band_idx].text.substr(0,1);
				if( (document.wlanSetup.Band2G5GSupport.value == 2 && selectText == '5')	 //Band2G5GSupport=2:PHYBAND_5G
					|| (document.wlanSetup.Band2G5GSupport.value == 1 && selectText == '2') ) {		//Band2G5GSupport=1:PHYBAND_2G
					document.wlanSetup.band.selectedIndex = band_idx;
					break;
				}
			}
			else {
				document.wlanSetup.band.selectedIndex = band_idx;
				break;
			}
		}
		band_idx++;
	}
*/
	updateBand_selectedIndex(band_value);
	updateChan_channebound();
}

function updateMode()
{
	var mode_selected=0;
	var Type_selected=0;
  	mode_selected=document.wlanSetup.mode.value;
  	var chan_number_idx=document.wlanSetup.chan.selectedIndex;
	var chan_number= document.wlanSetup.chan.options[chan_number_idx].value;	
  	//if client and infrastructure mode
  	if(mode_selected ==1){
		if(Type_selected == 0){
			disableTextField(document.wlanSetup.ctlband);
			disableTextField(document.wlanSetup.chanwid);
			disableTextField(document.wlanSetup.chan);
		}else{
			enableTextField(document.wlanSetup.chanwid);
			enableTextField(document.wlanSetup.chan);
			index_channelbound=document.wlanSetup.chanwid.selectedIndex;
			if(index_channelbound ==0)
				disableTextField(document.wlanSetup.ctlband);	
			else{
				if(chan_number != 0)
					enableTextField(document.wlanSetup.ctlband);
				else
					disableTextField(document.wlanSetup.ctlband);
			}
		}
	}else{
		enableTextField(document.wlanSetup.chanwid);
		enableTextField(document.wlanSetup.chan);
		index_channelbound=document.wlanSetup.chanwid.selectedIndex;
		if(index_channelbound ==0)
			disableTextField(document.wlanSetup.ctlband);	
		else{
			if(chan_number != 0)
				enableTextField(document.wlanSetup.ctlband);
	 		else
				disableTextField(document.wlanSetup.ctlband);
		}
	}
	updateRepeaterState(document.wlanSetup);
}

/*
function showChannel5G()
{
	document.wlanSetup.chan.length=0;

	for (idx=0, chan=36; chan<=64; idx++, chan+=4) {
		document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
		if (chan == defaultChan)
			document.wlanSetup.chan.selectedIndex = idx;
	}
	document.wlanSetup.chan.length = idx;
}
*/

function showChannel5G(startChanIdx, bound_40)
{
	var sideBand_idex = document.wlanSetup.ctlband.selectedIndex;
	var sideBand = document.wlanSetup.ctlband.options[sideBand_idex].value;
	var defChanId, RFType=10;

	document.wlanSetup.chan.length = 0;
	if (startChanIdx == 0)
		defChanIdx = 0;
	else
		defChanIdx = 1;

	if (startChanIdx == 0) {
		if (dfs_enable == 1)		
			document.wlanSetup.chan.options[0] = new Option("Auto(DFS)", 0, false, false);
		else
			document.wlanSetup.chan.options[0] = new Option("Auto", 0, false, false);
			
		if (0 == defaultChan) {
			document.wlanSetup.chan.selectedIndex = 0;
			defChanIdx = 0;
		}
		startChanIdx ++;		
	}

	idx = startChanIdx;

	if(wlan_support_8812e ==1)
	{
		var bound = document.wlanSetup.chanwid.selectedIndex;
		var channel_list;
		if(dfs_enable == 1) // use dfs channel
			channel_list = channel_list_5g_dfs[regDomain];
		else
			channel_list = channel_list_5g[regDomain];

		for (chan = 0; chan < channel_list.length; idx ++, chan ++) {
			if(bound != 0 && channel_list[chan] == 165) // channel 165 only exist 20M channel bandwidth
				break;
			document.wlanSetup.chan.options[idx] = new Option(channel_list[chan], channel_list[chan], false, false);
			if (channel_list[chan] == defaultChan) {
				document.wlanSetup.chan.selectedIndex = idx;
				defChanIdx = idx;
			}
		}
	
	/*
		var bound = document.wlanSetup.chanwid.selectedIndex;
		var inc_scale;
		var chan_end;
		
		inc_scale = 4;
		chan_str = 36;

		if (dfs_enable == 1)
			chan_end = 64;
		else
			chan_end = 48;

		for (chan = chan_str; chan <= chan_end; idx ++, chan += inc_scale) {
			document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
			if (chan == defaultChan) {
				document.wlanSetup.chan.selectedIndex = idx;
				defChanIdx = idx;
			}
		}
		if (dfs_enable == 1)
		{
			chan_str = 149;
			chan_end = 161;
			var bound = document.wlanSetup.chanwid.selectedIndex;
			if(bound == 0) // 20MHz
				chan_end = 165;
		
			for (chan = chan_str; chan <= chan_end; idx ++, chan += inc_scale) {
				document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
				if (chan == defaultChan) {
					document.wlanSetup.chan.selectedIndex = idx;
					defChanIdx = idx;
				}
			}
		}
	*/
	}
	else
	if (regDomain == 1 //FCC (1)
	 || regDomain == 2 //IC (2)
	 || regDomain == 3 //ETSI (3)
	 || regDomain == 4 //SPAIN (4)
	 || regDomain == 5 //FRANCE (5)
	 || regDomain == 6 //MKK (6)
	 || regDomain == 7 //ISREAL (7)
	 || regDomain == 9 //MKK2 (9)
	 || regDomain == 10 //MKK3 (10)
	) 
	{
		var bound = document.wlanSetup.chanwid.selectedIndex;
		var inc_scale;

		if (bound == 0) //20MHz
		{
			inc_scale = 4;
			chan_str = 36;
			chan_end = 48;
		}
		else //40MHz
		{ 
			inc_scale = 8;
			if (sideBand == 0) // upper
			{
				chan_str = 40;
				chan_end = 48;
			}
			else // lower
			{
				chan_str = 36;
				chan_end = 44;
			}
		}

		for (chan = chan_str; chan <= chan_end; idx ++, chan += inc_scale) {
			document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
			if (chan == defaultChan) {
				document.wlanSetup.chan.selectedIndex = idx;
				defChanIdx = idx;
			}
		}

		if (regDomain == 1 //FCC (1)
	 		|| regDomain == 2 //IC (2)
	 	)
	 	{
	 		if (bound == 0) {		//20MHz
				inc_scale = 4;
				chan_str = 149;
				chan_end = 161;
			} else {
				inc_scale = 8;
				if (sideBand == 0) // upper
				{
					chan_str = 153;
					chan_end = 161;
				}
				else // lower
				{
					chan_str = 149;
					chan_end = 157;
				}
			}			
			for (chan = chan_str; chan <= chan_end; idx ++, chan += inc_scale) {
				document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
				if (chan == defaultChan) {
					document.wlanSetup.chan.selectedIndex = idx;
					defChanIdx = idx;
				}
			}
	 	}

		/* You can not select channel 165 in 40MHz whether upper or lower. */
	}
	else if (regDomain == 8) //MKK1 (8)
	{
		var bound = document.wlanSetup.chanwid.selectedIndex;
		var inc_scale;

		if (bound == 0) //20MHz
		{
			inc_scale = 4;
			chan_str = 34;
			chan_end = 46;
		}
		else //40MHz
		{ 
			inc_scale = 8;
			if (sideBand == 0) // upper
			{
				chan_str = 38;
				chan_end = 46;
			}
			else // lower
			{
				chan_str = 34;
				chan_end = 42;
			}
		}

		for (chan = chan_str; chan <= chan_end; idx ++, chan += inc_scale) {
			document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
			if (chan == defaultChan) {
				document.wlanSetup.chan.selectedIndex = idx;
				defChanIdx = idx;
			}
		}
	}
	else if (regDomain == 11) //NCC (11)
	{
		var bound = document.wlanSetup.chanwid.selectedIndex;
		var inc_scale;
		if (bound == 0) //20MHz
		{
			inc_scale = 4;
			chan_str = 56;
			chan_end = 64;
		}
		else //40MHz
		{
			inc_scale = 8;
			if (sideBand == 0) // upper
			{
				chan_str = 60;
				chan_end = 64;
			}
			else // lower
			{
				chan_str = 56;
				chan_end = 64;
			}
		}

		for (chan = chan_str; chan <= chan_end; idx ++, chan += inc_scale) {					
			document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
			if (chan == defaultChan) {
				document.wlanSetup.chan.selectedIndex = idx;
				defChanIdx = idx;
			}
		}

		if (bound == 0) //20MHz
		{
			inc_scale = 4;
			chan_str = 149;
			chan_end = 165;
		}
		else //40MHz
		{
			inc_scale = 8;
			if (sideBand == 0) // upper
			{
				chan_str = 153;
				chan_end = 161;
			}
			else // lower
			{
				chan_str = 149;
				chan_end = 157; /* You can not select channel 165 in 40MHz whether upper or lower. */
			}
		}

		for (chan = chan_str; chan <= chan_end; idx ++, chan += inc_scale) {					
			document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
			if (chan == defaultChan) {
				document.wlanSetup.chan.selectedIndex = idx;
				defChanIdx = idx;
			}
		}
	}
/*
	if (0 && startChanIdx==0) { // no auto selection
		form.elements["chan"+wlan_id].options[0] = new Option("Auto", 0, false, false);
		if (0 == defaultChan[wlan_id]) {
			form.elements["chan"+wlan_id].selectedIndex = 0;
			defChanIdx = 0;
		}
		startChanIdx[wlan_id]++;		
	}
*/
/*	if (regDomain==6) {	// MKK
		for (idx=startChanIdx, chan=34; chan<=64; idx++, chan+=2) {
			if ((chan==50) || (chan==54) || (chan==58) || (chan==62)) {
				idx--;
				continue;
			}
			document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
			if (chan == defaultChan) {
				document.wlanSetup.chan.selectedIndex = idx;
				defChanIdx=idx;
			}
		}
	}
	else {
		if(bound_40 == 1) {
			if(sideBand == 0) // upper
			{
				chan_str = 40;
				chan_end = 64;
			}
			else // lower
			{
				chan_str = 36;
				chan_end = 60;
			}
		}
		else {
			chan_str = 36;
			chan_end = 64;
		}
		for (idx=startChanIdx, chan=chan_str; chan<=chan_end; idx++, chan+=(4*(bound_40+1))) {
			document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
			if (chan == defaultChan) {
				document.wlanSetup.chan.selectedIndex = idx;
				defChanIdx=idx;
			}
		}
*/
/*		
		if (RFType[wlan_id] == 9) {
			// FCC, IC
			if ((regDomain[wlan_idx] == 1) || (regDomain[wlan_idx] == 2)) {
				if(sideBand == 0) // upper
				{
					chan_str = 153;
					chan_end = 165;
				}
				else // lower
				{
					chan_str = 149;
					chan_end = 161;
				}
				
				for (chan=chan_str; chan<=chan_end; idx++, chan+=4) {
					form.elements["chan"+wlan_id].options[idx] = new Option(chan, chan, false, false);
					if (chan == defaultChan[wlan_id]) {
						form.elements["chan"+wlan_id].selectedIndex = idx;
						defChanIdx=idx;
					}
				}
			}
			// ETSI, SPAIN, FRANCE, ISRAEL
			if (((regDomain[wlan_idx] >= 3) && (regDomain[wlan_idx] <= 5)) || (regDomain[wlan_idx] == 7)) {
				for (chan=100; chan<=140; idx++, chan+=4) {
					form.elements["chan"+wlan_id].options[idx] = new Option(chan, chan, false, false);
					if (chan == defaultChan[wlan_id]) {
						form.elements["chan"+wlan_id].selectedIndex = idx;
						defChanIdx=idx;
					}
				}
			}
			// MKK3
			if (regDomain[wlan_idx] == 10) {
				for (chan=183; chan<=190; idx++, chan+=1) {
					form.elements["chan"+wlan_id].options[idx] = new Option(chan, chan, false, false);
					if (chan == defaultChan[wlan_id]) {
						form.elements["chan"+wlan_id].selectedIndex = idx;
						defChanIdx=idx;
					}
				}
				for (chan=192; chan<=196; idx++, chan+=2) {
					form.elements["chan"+wlan_id].options[idx] = new Option(chan, chan, false, false);
					if (chan == defaultChan[wlan_id]) {
						form.elements["chan"+wlan_id].selectedIndex = idx;
						defChanIdx=idx;
					}
				}
				for (chan=207; chan<=212; idx++, chan+=1) {
					form.elements["chan"+wlan_id].options[idx] = new Option(chan, chan, false, false);
					if (chan == defaultChan[wlan_id]) {
						form.elements["chan"+wlan_id].selectedIndex = idx;
						defChanIdx=idx;
					}
				}
				for (chan=214; chan<=216; idx++, chan+=2) {
					form.elements["chan"+wlan_id].options[idx] = new Option(chan, chan, false, false);
					if (chan == defaultChan[wlan_id]) {
						form.elements["chan"+wlan_id].selectedIndex = idx;
						defChanIdx=idx;
					}
				}
			}
		}
	}*/
	document.wlanSetup.chan.length = idx;
	if (defChanIdx==0)
		document.wlanSetup.chan.selectedIndex = 0;
}


function showChannel2G(bound_40, band)
{
	start = 0;
	end = 0;
	if (regDomain==1 || regDomain==2) {
		start = 1;
		end = 11;
	}
	else if (regDomain==3) {
		start = 1;
		end = 13;
	}
	else if (regDomain==4) {
		start = 1;
		end = 13;
	}
	else if (regDomain==5) {
		start = 10;
		end = 13;
	}
	else if (regDomain==6) {
		start = 1;
		end = 14;
	}
	else if (regDomain==7) {
		start = 3;
		end = 13;
	}
	else if (regDomain==8 || regDomain==9 || regDomain==10) {
		start = 1;
		end = 14;
	}
	else if (regDomain==11) {
		start = 1;
		end = 11;
	}
	else if (regDomain==12) {
		start = 1;
		end = 13;
	}
	else if (regDomain==13) {
		start = 1;
		end = 13;
	}
	else if (regDomain==14) {
		start = 1;
		end = 14;
	}
	else if (regDomain==15) {
		start = 1;
		end = 13;
	}
	else if (regDomain==16) {
		start = 1;
		end = 14;
	}
	else {	//wrong regDomain ?
		start = 1;
		end = 11;
	}

	if(band == 9 || band == 10 || band == 7){
		if(bound_40 ==1){
			var sideBand_idex = document.wlanSetup.ctlband.selectedIndex;
			var sideBand = document.wlanSetup.ctlband.options[sideBand_idex].value;
			if(regDomain==5){
				if(sideBand ==0){  //upper
					start = 13;
					end = 13;
				}else{ //lower
					start = 10;
					end = 10;
				}
			}else{
				if(sideBand ==0){  //upper
					start = start+4;
					if(end==14)
						end = 13			
					
				}else{ //lower
					if(end==14)
						end = 13;
					end = end-4;
				}
			}
		}
	}

	document.wlanSetup.chan.length=0;
	idx=0;
	document.wlanSetup.chan.options[idx] = new Option("<% multilang("Auto"); %>", 0, false, false);
	if (0 == wlan_channel) {
		document.wlanSetup.chan.selectedIndex = 0;
	}
	idx++;	
	
	for (chan=start; chan<=end; chan++, idx++) {
		document.wlanSetup.chan.options[idx] = new Option(chan, chan, false, false);
		if (chan == wlan_channel)
			document.wlanSetup.chan.selectedIndex = idx;
	}
	document.wlanSetup.chan.length = idx;
	wlan_channel = document.wlanSetup.chan.options[document.wlanSetup.chan.selectedIndex].value;
}

function updateChan()
{
	var idx_value= document.wlanSetup.band.selectedIndex;
	var band_value= document.wlanSetup.band.options[idx_value].value;
/*
  if (document.wlanSetup.band.selectedIndex == 3)
     currentBand = 2;
  else
*/
	showcontrolsideband_updated(band_value, idx_value);
	showchannelbound_updated(band_value);

    if(band_value ==3 || band_value ==11 || (band_value == 7 && document.wlanSetup.Band2G5GSupport.value == 2) || band_value == 63 || band_value == 71 || band_value == 75 ){ // 3:5g_a 11:5g_an 
		currentBand = 2;
	}
	else {
		currentBand = 1;
	}


	if(band_value==9 || band_value==10 || band_value==7 || band_value ==11){
		updateChan_channebound();
	}
	else {
	  	if (currentBand == 2)
			showChannel5G(0, 0);
	  	else
			showChannel2G(0, band_value);
	}

/*
  if (document.wlanSetup.chanwid.selectedIndex == 0)
  	disableCheckBox(document.wlanSetup.elements.ctlband);
  else
  	enableCheckBox(document.wlanSetup.elements.ctlband);
*/
	updateChan_selectedIndex();

	if(band_value < 7){
		if (document.getElementById)
			document.getElementById('optionfor11n').style.display = 'none';
		else if(document.layers == false)
		document.all.optionfor11n.style.display = 'none';
	}
	else{
		if (document.getElementById)
			document.getElementById('optionfor11n').style.display = 'block';
		else if(document.layers == false)
			document.all.optionfor11n.style.display = 'block';
	}
}

function updateChan1()
{
	var chan_number_idx=document.wlanSetup.chan.selectedIndex;
	var chan_number= document.wlanSetup.chan.options[chan_number_idx].value;
	var idx_value= document.wlanSetup.band.selectedIndex;
	var band_value= document.wlanSetup.band.options[idx_value].value;
	
	if (document.wlanSetup.chanwid.selectedIndex == 0 || document.wlanSetup.chanwid.selectedIndex == 2 
		|| (wlan_support_8812e==1 && (band_value==11 || band_value==63 || band_value==71 || band_value==75 || (band_value==7 && idx_value==1))))
		disableCheckBox(document.wlanSetup.elements.ctlband);
	else
		enableCheckBox(document.wlanSetup.elements.ctlband);
	updateChan_channebound();
   //if (document.wlanSetup.chan.selectedIndex==0)
	if (chan_number_idx==0 && chan_number==0)
		disableCheckBox(document.wlanSetup.elements.ctlband);
}

function updateChan_selectedIndex()
{
	var chan_number_idx=document.wlanSetup.chan.selectedIndex;
	var chan_number= document.wlanSetup.chan.options[chan_number_idx].value;

	wlan_channel = chan_number;
	if(chan_number == 0)
		disableTextField(document.wlanSetup.ctlband);	
	else{
		if(document.wlanSetup.chanwid.selectedIndex == "0")
 			disableTextField(document.wlanSetup.ctlband);	
		else if(document.wlanSetup.chanwid.selectedIndex == "2")
 			disableTextField(document.wlanSetup.ctlband);
 		else
			enableTextField(document.wlanSetup.ctlband);		
	}

	if((wlan_support_8812e==1) && (chan_number > 14)) //8812
		disableTextField(document.wlanSetup.ctlband);	
}

function updateState(form)
{
       updateIputState();
       updateRepeaterState(form);
}

function updateRepeaterState(form)
{
       if(!form.wlanDisabled.checked &&
        (form.mode.value!=1)
        ){
               enableCheckBox(form.repeaterEnabled);
               //if (form.repeaterEnabled.checked)
               //        enableTextField(form.repeaterSSID);
               //else
                       disableTextField(form.repeaterSSID);
       }
	   /*
	   else if (form.mode.value==1){
			   enableCheckBox(form.repeaterEnabled);
			   if (form.repeaterEnabled.checked)
                       enableTextField(form.repeaterSSID);
               else
                       disableTextField(form.repeaterSSID);
       }
	   */
       else {
               disableCheckBox(form.repeaterEnabled);
               disableTextField(form.repeaterSSID);
       }
}

function Set_SSIDbyBand(form)
{
	var index=form.band.selectedIndex;
	var selectText=form.band.options[index].text.substr(0,1);
	if(selectText == '5')
		form.ssid.value = ssid_5g;
	else if(selectText == '2')
		form.ssid.value = ssid_2g;
}

function showcontrolsideband_updated(band, index)
{
	var idx=0;
	var i;
  	var controlsideband_idx = document.wlanSetup.ctlband.selectedIndex;
	var controlsideband_str = document.wlanSetup.ctlband.options[controlsideband_idx].value;

  	if(wlan_support_8812e ==1 && ((band==7 && index==1) || band ==11 || band == 63 || band == 71 || band ==75))
	{
		document.wlanSetup.ctlband.options[idx++] = new Option("Auto", "0", false, false);
		document.wlanSetup.ctlband.options[idx++] = new Option("Auto", "1", false, false);
  	}
  	else
	{
		document.wlanSetup.ctlband.options[idx++] = new Option("Upper", "0", false, false);
		document.wlanSetup.ctlband.options[idx++] = new Option("Lower", "1", false, false);
  	}
  	document.wlanSetup.ctlband.length = idx;
 
	//document.wlanSetup.ctlband.selectedIndex = controlsideband_idx;

	for (i=0; i<idx; i++) {
		if(controlsideband_str == document.wlanSetup.ctlband.options[i].value)
			document.wlanSetup.ctlband.selectedIndex = i;
	}
}


function showchannelbound_updated(band)
{
	var idx=0;
	var i;
	var channelbound_idx = document.wlanSetup.chanwid.selectedIndex;
	var channelbound_str = document.wlanSetup.chanwid.options[channelbound_idx].value;

	document.wlanSetup.chanwid.options[idx++] = new Option("20MHz", "0", false, false);
	document.wlanSetup.chanwid.options[idx++] = new Option("40MHz", "1", false, false);
	if(band == 63 || band == 71 || band == 75)
		document.wlanSetup.chanwid.options[idx++] = new Option("80MHz", "2", false, false);
	
 	document.wlanSetup.chanwid.length = idx;
 /*
	if(channelbound_idx > (idx-1))
		document.wlanSetup.chanwid.selectedIndex = idx - 1;
	else
		document.wlanSetup.chanwid.selectedIndex = channelbound_idx;
*/
	for (i=0; i<idx; i++) {
		if(channelbound_str == document.wlanSetup.chanwid.options[i].value)
			document.wlanSetup.chanwid.selectedIndex = i;
	}

}


</SCRIPT>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("WLAN Basic Settings"); %></font></h2>

<form action=/boaform/admin/formWlanSetup method=POST name="wlanSetup">
<table border=0 width="500" cellspacing=4>
  <tr><td><font size=2>
 <% multilang("This page is used to configure the parameters for WLAN clients which may connect to your Access Point. Here you may change wireless encryption settings as well as wireless network parameters."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>
<table border=0 width="500" cellspacing=4>
  <tr>
      <td width="100%" colspan=2><font size=2><b>
   	<input type="checkbox" name="wlanDisabled" value=<% wlanStatus(); %> 
   	 ONCLICK=updateState(document.wlanSetup)>&nbsp;&nbsp;<% multilang("Disable WLAN Interface"); %></b>
     </td>
  </tr>

  <tr>
      <td width="26%"><font size=2><b><% multilang("Band"); %>:</b></td>
      <td width="74%"><font size=2><select size=1 name=band onChange="updateChan(); Set_SSIDbyBand(document.wlanSetup);">
      		<% checkWrite("wlband"); %>      		
	 </select>
	 <SCRIPT>updateBand_selectedIndex(defaultBand);</SCRIPT>
      </td>
  </tr>

  <tr>
      <td width="26%"><font size=2><b><% multilang("Mode"); %>:</b></td>
      <td width="74%"><font size=2><select size="1" name="mode" onChange="updateMode()">
      		<% checkWrite("wlmode"); %>      		
      		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" value="Multiple AP" name="multipleAP" onClick="showMultipleAP(document.wlanSetup, '/admin/wlmultipleap.asp')">
      </td>
  </tr>
  
  </table>

  <table border="0" width=500>
  <tr>
      <td width="26%"><font size=2><b><% multilang("SSID"); %>:</b></td>
      <td width="74%"><font size=2><input type=text name=ssid size="25" maxlength="32" value="<% getInfo("ssid"); %>">
      </td>
  </tr>
  </table>
  <div  id="optionfor11n" style="display:none">
  <table border="0" width=500>
  <tr>
      <td width="26%"><font size=2><b><% multilang("Channel Width"); %>:</b></td>
      <td width="74%"><font size=2><select size="1" name="chanwid" onChange="updateChan1()">
            	<% checkWrite("wlchanwid"); %>
      		</select>
      </td>
  </tr>
  <tr>
      <td width="26%"><font size=2><b><% multilang("Control Sideband"); %>:</b></td>
      <td width="74%"><font size=2><select size="1" name="ctlband" onChange="updateChan_channebound()">
      	      	<% checkWrite("wlctlband"); %>      		
      		</select>
      </td>
  </tr> 
  </table>
  </div>
  <table border="0" width=500>
  <tr>
      <td width="26%"><font size=2><b><% multilang("Channel Number"); %>:</b></td>
      <td width="74%"><font size=2><select size="1" name="chan" onChange="updateChan_selectedIndex()"> </select></td>
    <SCRIPT>
    	<% checkWrite("wl_chno"); %>
    	wlan_channel = defaultChan;
		updateChan();
    </SCRIPT>
  </tr>
  <tr>
      <td width="26%"><font size=2><b><% multilang("Radio Power (%)"); %>:</b></td>
      <td width="74%"><font size=2><select size="1" name="txpower">
      		<% checkWrite("txpower"); %>      		
      		</select>
      </td>
  </tr>
  <tr>
      <td width="26%"><font size=2><b><% multilang("Associated Clients"); %>:</b></td>
      <td width="74%"><font size=2><input type="button"
      value="<% multilang("Show Active WLAN Clients"); %>" name="showMac" 
      onClick="showMacClick('/boaform/admin/formWirelessTbl?submit-url=/admin/wlstatbl.asp&wlan_idx=<% checkWrite("wlan_idx"); %>')">
      </td>
  </tr>
  <tr id="repeater_check" style="display:none">
      <td width="100%" colspan=2><font size=2><b>
       <input type="checkbox" name="repeaterEnabled" value="ON" <% checkWrite("repeaterEnabled"); %>
       ONCLICK="updateRepeaterState(document.wlanSetup)">&nbsp;&nbsp; Enable Universal Repeater Mode (Acting as AP and client simultaneouly)</b>
      </td>
  </tr>
  <tr id="repeater_SSID" style="display:none">
      <td width="100%" colspan=2><font size=2><b>SSID of Extended Interface:&nbsp;&nbsp;
      <input type="text" name="repeaterSSID" size="33" maxlength="32" value="<% getInfo("repeaterSSID"); %>">
      </td>
  </tr>
  <tr id="wifi_regdomain_demo" style="display:none">
      <td width="26%"><font size=2><b><% multilang("Regdomain "); %>:</b></td>
      <td width="74%"><font size=2><select size="1" name="regdomain_demo">
      		<% checkWrite("regdomain_list"); %>      		
      		</select>
      </td>
  </tr>

  
  </table>
  <br>
  <table border=0 width=500 cellspacing=0 cellpadding=0>
  <tr>
     <input type="hidden" value="/admin/wlbasic.asp" name="submit-url">
     <input type="submit" value="<% multilang("Apply Changes"); %>" 
     name="save" onClick="return saveChanges()">
     <input type="hidden" name="basicrates" value=0>
     <input type="hidden" name="operrates" value=0>
     <input type="hidden" name="wlan_idx" value=<% checkWrite("wlan_idx"); %>>
     <input type="hidden" name="Band2G5GSupport" value=<% checkWrite("Band2G5GSupport"); %>>
     <input type="hidden" name="wlanBand2G5GSelect" value=<% checkWrite("wlanBand2G5GSelect"); %>>
     <input type="hidden" name="dfs_enable" value=<% checkWrite("dfs_enable"); %>>
     
  </tr>
  <script>
	<% initPage("wlbasic"); %>
	updateState(document.wlanSetup);
  </script>
</table>
</form>

</blockquote>
</body>

</html>
