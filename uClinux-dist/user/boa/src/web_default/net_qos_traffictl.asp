<html>
<head>
<TITLE>IP QoS <% multilang("Traffic Shaping"); %></TITLE>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<!--系统公共脚本-->
<SCRIPT language="javascript" src="common.js"></SCRIPT>
<SCRIPT language="javascript" type="text/javascript">

var protos = new Array("", "TCP", "UDP", "ICMP", "TCP/UDP", "RTP");
<!--var protos = new Array("", "ICMP", "TCP", "UDP", "TCP/UDP", "RTP");-->
var traffictlRules = new Array();
var totalBandwidth = 1000;
var totalBandWidthEn = 0;
<% initTraffictlPage(); %>

function on_chkdel(index) {
	if(index<0 || index>=traffictlRules.length)
		return;
	traffictlRules[index].select = !traffictlRules[index].select;
}

/********************************************************************
**          on document load
********************************************************************/
function on_init_page(){
	if (totalBandWidthEn == 0) {//to apply
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('apply').style.display = 'block';
			document.getElementById('cancel').style.display = 'none';
		} else {
			document.all.apply.style.display = 'block';
			document.all.cancel.style.display = 'none';
		}
	} else {//to cancel
		if (document.getElementById)  // DOM3 = IE5, NS6
		{
			document.getElementById('apply').style.display = 'none';
			document.getElementById('cancel').style.display = 'block';
		} else {
			document.all.apply.style.display = 'none';
			document.all.cancel.style.display = 'block';
		}
	}
	
	with(document.forms[0]) {
		totalbandwidth.value = totalBandwidth;
		if(traffictl_tbl.rows){
			while(traffictl_tbl.rows.length > 1) 
				traffictl_tbl.deleteRow(1);
		}
	
		for(var i = 0; i < traffictlRules.length; i++)
		{
			var row = traffictl_tbl.insertRow(i + 1);
		
			row.nowrap = true;
			row.vAlign = "center";
			row.align = "left";

			var cell = row.insertCell(0);
			cell.innerHTML = traffictlRules[i].id;
			cell = row.insertCell(1);
			cell.innerHTML = traffictlRules[i].inf;
			cell = row.insertCell(2);
			cell.innerHTML = protos[traffictlRules[i].proto];
			cell = row.insertCell(3);
			if (traffictlRules[i].sport == "0")
				cell.innerHTML = "";
			else
				cell.innerHTML = traffictlRules[i].sport;
			cell = row.insertCell(4);
			if (traffictlRules[i].dport == "0")
				cell.innerHTML = "";
			else
				cell.innerHTML = traffictlRules[i].dport;
		
			cell = row.insertCell(5);
			// For IPv4 and IPv6 
			if ( <% checkWrite("IPv6Show"); %> ) {		
				// For IPv4
				if ( traffictlRules[i].IpProtocolType == "1 ") {
					if (traffictlRules[i].srcip == "0.0.0.0")
						cell.innerHTML = "";
					else
						cell.innerHTML = traffictlRules[i].srcip;
				}
				// For IPv6
				else if ( traffictlRules[i].IpProtocolType == "2" ) {
					if (traffictlRules[i].sip6 == "::")
						cell.innerHTML = "";
					else {							
						cell.innerHTML = traffictlRules[i].sip6;											
					}
				}				
			}
			// For IPv4
			else {			
				if (traffictlRules[i].srcip == "0.0.0.0")
					cell.innerHTML = "";
				else
					cell.innerHTML = traffictlRules[i].srcip;				
			}
			
			cell = row.insertCell(6);				
			// For IPv4 and IPv6 
			if ( <% checkWrite("IPv6Show"); %> ) {		
				// For IPv4
				if ( traffictlRules[i].IpProtocolType == "1 ") {
					if (traffictlRules[i].dstip == "0.0.0.0")
						cell.innerHTML = "";
					else
						cell.innerHTML = traffictlRules[i].dstip;
				}
				// For IPv6
				else if ( traffictlRules[i].IpProtocolType == "2" ) {
					if (traffictlRules[i].dip6 == "::")
						cell.innerHTML = "";
					else {							
						cell.innerHTML = traffictlRules[i].dip6;											
					}
				}				
			}
			// For IPv4
			else {			
				if (traffictlRules[i].dstip == "0.0.0.0")
					cell.innerHTML = "";
				else
					cell.innerHTML = traffictlRules[i].dstip;				
			}
			
			cell = row.insertCell(7);
			cell.innerHTML = traffictlRules[i].uprate;
			cell = row.insertCell(8);
			cell.align = "center";
			cell.innerHTML = "<input type=\"checkbox\" onClick=\"on_chkdel(" + i + ");\">";
			
			cell = row.insertCell(9);
			if ( <% checkWrite("IPv6Show"); %> ) {			
				if (traffictlRules[i].IpProtocolType == "1")
					cell.innerHTML = "IPv4";
				else if (traffictlRules[i].IpProtocolType == "2")
					cell.innerHTML = "IPv6";
			}
			else {				
				cell.innerHTML = "IPv4";		
			}			
		}
	}
}


function on_apply_bandwidth(){
	
	with(document.forms[0]) {
		var sbmtstr = "";
		var bandwidth = -1;
		bandwidth = parseInt(totalbandwidth.value);
		if(bandwidth<0 || bandwidth >Number.MAX_VALUE)
			return;
		sbmtstr = "applybandwidth&bandwidth="+bandwidth;
		lst.value = sbmtstr;
		submit();
	}
}

function on_cancel_bandwidth(){
	with(document.forms[0]) {
		var sbmtstr = "";
		sbmtstr = "cancelbandwidth";
		lst.value = sbmtstr;
		submit();
	}
}

function on_submit(){
	var sbmtstr = "applysetting#id=";
	var firstFound = true;
	for(var i=0; i<traffictlRules.length; i++)
	{
		if(traffictlRules[i].select)
		{
			if(!firstFound)
				sbmtstr += "|";
			else
				firstFound = false;
			sbmtstr += traffictlRules[i].id;
		}
	}
	document.forms[0].lst.value = sbmtstr;
	document.forms[0].submit();
}
</SCRIPT>
</head>

<body onLoad="on_init_page();">
<blockquote>
<DIV align="left" style="padding-left:20px; padding-top:5px;">
	<form id="form" action="/boaform/admin/formQosTraffictl" method="post">
			<h2><font color="#0000FF">IP QoS <% multilang("Traffic Shaping"); %></font></h2>			
			
			<p><% multilang("Total Bandwidth Limit"); %>:<input type="text" id="totalbandwidth" value="1005">Kb</p>
			<table class="flat" id="traffictl_tbl" border="1" cellpadding="0" cellspacing="1">
				   <tr class="hdb" align="center" nowrap bgcolor="#CCCCCC">
						<td><% multilang("ID"); %></td>
						<td><% multilang("WAN Interface"); %></td>
						<td><% multilang("Protocol"); %></td>
						<td><% multilang("Source Port"); %></td>
						<td><% multilang("Destination Port"); %></td>
						<td><% multilang("Source"); %> IP</td>
						<td><% multilang("Destination"); %> IP</td>
						<td><% multilang("Rate"); %>(kb/s)</td>
						<td><% multilang("Delete"); %></td>
						<td>IP <% multilang("Version"); %></td>
					</tr>
			</table>
			<table><tr align="left">
			<td><input type="button" class="button" onClick="location.href='net_qos_traffictl_edit.asp';" value="<% multilang("Add"); %>"></td>
			<td><input type="button" class="button" onClick="on_submit();" value="<% multilang("Apply Changes"); %>"></td>
			<td>
			<div  id="apply"  style="display:none">
			<input type="button" class="button" onClick="on_apply_bandwidth();" value="<% multilang("Apply Total Bandwidth Limit"); %>">
			</div>
			<div  id="cancel" style="display:none">
			<input type="button" class="button" onClick="on_cancel_bandwidth();" value="<% multilang("Cancel Total Bandwidth Limit"); %>">
			</div></td>
			</tr></table>
			<input type="hidden" id="lst" name="lst" value="">
			<input type="hidden" name="submit-url" value="/net_qos_traffictl.asp">
	</form>
</DIV>
</blockquote>
</body>
</html>
