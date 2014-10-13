<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("CFM (802.1ag) Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>

<SCRIPT>
<% dot1ag_init("conf"); %>

function clear_inputs(clear_select)
{
	with(document.dot1agConf)
	{
		interface.selectedIndex= 0;
		md_name.value = "";
		md_level.selectedIndex= 0;
		ma_name.value = "";
		mep_id.value = "";
		ccm_enable.checked = true;
		ccm_interval.selectedIndex= 0;

		if(clear_select)
		{
			var radio = document.getElementsByName('select');
			for(var i=0 ; i < radio.length ; i++)
				radio[i].checked = false;
		}
	}

	update_ui();
}

function postsetting(num)
{
	clear_inputs(0);

	with(document.dot1agConf)
	{
		for(i = 0 ; i < interface.length ; i++)
		{
			if(dot1ag[num].interface == interface[i].text)	
				interface.selectedIndex = i;
		}

		md_name.value = dot1ag[num].md_name;

		md_level.selectedIndex = dot1ag[num].md_level;

		ma_name.value = dot1ag[num].ma_name;

		mep_id.value = dot1ag[num].mep_id;

		if(dot1ag[num].ccm_enable)
			ccm_enable.checked = true;
		else
			ccm_enable.checked = false;

		switch(dot1ag[num].ccm_interval)
		{
		case 1000:
			ccm_interval.selectedIndex = 0;
			break;
		case 10000:
			ccm_interval.selectedIndex = 1;
			break;
		case 60000:
			ccm_interval.selectedIndex = 2;
			break;
		case 60000:
			ccm_interval.selectedIndex = 3;
			break;
		default:
			ccm_interval.selectedIndex = 0;
			break;
		}
	}

	update_ui();
}

function init_table()
{
	var table = document.getElementById("cfm_tbl");

	for(var i = 0 ; i < dot1ag.length ; i++)
	{
		var cell;
		var row = table.insertRow(-1);

		for(var j=0 ; j < 7 ; j++)
		{
			cell = row.insertCell(j);
			cell.setAttribute("align", "center");
			cell.setAttribute("bgColor", "#C0C0C0");

			var tmp = "<font size = 2>";

			switch(j)
			{
			case 0:
				tmp += "<input type=\"radio\" name=\"select\" value=" + i + " onClick=\"postsetting(" + i + ")\">";
				break;
			case 1:
				tmp += dot1ag[i].interface;
				break;
			case 2:
				tmp += dot1ag[i].md_name;
				break;
			case 3:
				tmp += dot1ag[i].md_level;
				break;
			case 4:
				tmp += dot1ag[i].ma_name;
				break;
			case 5:
				tmp += dot1ag[i].mep_id;
				break;
			case 6:
				if(dot1ag[i].ccm_enable == 1)
					tmp += "Enabled";
				else
					tmp += "Disabled";
				break;
			}
			cell.innerHTML = tmp;
		}
	}
}

function on_init()
{
	clear_inputs(1);
	init_table();
}

function update_ui()
{
	if(document.dot1agConf.ccm_enable.checked == true)
		document.dot1agConf.ccm_interval.disabled = false;
	else
		document.dot1agConf.ccm_interval.disabled = true;
}


function addClick(action) 
{
	var selected;
	var radio = document.getElementsByName('select');
	var interface = document.dot1agConf.interface[document.dot1agConf.interface.selectedIndex].label;

	for(selected = 0 ; selected < radio.length ; selected++)
		if(radio[selected].checked == true)
			break;

	if(action != "add" && radio.length == selected)
	{
		alert('You must select an entry in table.');
		return false;
	}

	if(action == "delete")
		return true;

	//Check interface
	if(action == "add")
	for(i = 0 ; i < dot1ag.length ; i++)
	{
		if(action == "modify" && i == selected)
			continue;

		if(dot1ag[i].interface == interface)
		{
			alert("Interface is duplicated!");
			document.dot1agConf.interface.focus();
			return false;
		}
	}

	// Check MD name
	if (document.dot1agConf.md_name.value=="") {
		alert("MD Name cannot be empty!");
		document.dot1agConf.md_name.focus();
		return false;
	}
	if (checkString(document.dot1agConf.md_name.value) == 0) {
		alert('Invalid MD Name.');
		document.dot1agConf.md_name.focus();
		return false;
	}

	//Check MD Level
	for(i = 0 ; i < dot1ag.length ; i++)
	{
		if(action == "modify" && i == selected)
			continue;

		if(dot1ag[i].md_level == document.dot1agConf.md_level.selectedIndex)
		{
			alert("MD Level is duplicated!");
			document.dot1agConf.md_level.focus();
			return false;
		}
	}

	if (document.dot1agConf.ma_name.value=="") {
		alert("MA Name cannot be empty!");
		document.dot1agConf.ma_name.focus();
		return false;
	}
	if (checkString(document.dot1agConf.ma_name.value) == 0) {
		alert('Invalid MA Name.');
		document.dot1agConf.ma_name.focus();
		return false;
	}

	if (document.dot1agConf.mep_id.value == "")
	{
		alert("MEP Index cannot be empty!");
		document.dot1agConf.mep_id.focus();
		return false;
	}
	if (checkDigitRange(document.dot1agConf.mep_id.value, 1, 1, 8191) == 0)
	{
		alert('MEP Index should be a number between 1 and 8191.');
		document.dot1agConf.mep_id.focus();
		return false;
	}

	return true;
}
</SCRIPT>
</head>


<body onLoad="on_init();">
<blockquote>
<h2><font color="#0000FF"><% multilang("CFM (802.1ag) Configuration"); %></font></h2>

<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
 <% multilang("This page is used to configure IEEE 802.1ag which is also known as Connectivity Fault Management. Do not configure this page unless you know what you want."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<form action=/boaform/formDot1agConf method=POST name="dot1agConf">

<table class="flat" border="0" cellpadding="0" cellspacing="0" width=500  style="margin-bottom: 20px;">
<tr>
	<td width=30%><font size=2><% multilang("Interface"); %>:</td>
	<td><select name="interface">
		<% if_wan_list("ptm"); %>
		<% if_wan_list("eth"); %>
	</td>
</tr>
<tr>
    <td width=30%><font size=2><% multilang("MD Name"); %>:&nbsp;&nbsp;</td>
    <td><input type="text" name="md_name" size="20" maxlength="43"></td>
</tr>
<tr>
	<td width=30%><font size=2><% multilang("MD Level"); %>:</td>
	<td><select size="1" name="md_level">
		<option selected value=0>0</option>
		<option value=1>1</option>
		<option value=2>2</option>
		<option value=3>3</option>
		<option value=4>4</option>
		<option value=5>5</option>
		<option value=6>6</option>
		<option value=7>7</option>
	</td>
</tr>
<tr>
    <td width=30%><font size=2><% multilang("MA Name"); %>:&nbsp;&nbsp;</td>
    <td><input type="text" name="ma_name" size="20" maxlength="10"></td>
</tr>
<tr>
    <td width=30%><font size=2><% multilang("MEP ID"); %>:&nbsp;&nbsp;</td>
    <td><input type="text" name="mep_id" size="20" maxlength="5">(1~8191)</td>
</tr>
<tr>
	<td><font size=2><% multilang("Enable CCM"); %>:</td>
	<td><input type="checkbox" name="ccm_enable" value=1 onClick="update_ui()"></td>
</tr>
<tr>
	<td width=30%><font size=2><% multilang("CCM Interval"); %>:</td>
	<td><select size="1" name="ccm_interval">
		<option selected value=1000>1s</option>
		<option selected value=10000>10s</option>
		<option selected value=60000>1min</option>
		<option selected value=600000>10min</option>
	</td>
</tr>
</table>

<input type="submit" value="<% multilang("Add"); %>" name="action" onClick="return addClick('add')">&nbsp;&nbsp;
<input type="submit" value="<% multilang("Delete"); %>" name="action" onClick="return addClick('delete')">&nbsp;&nbsp;
<input type="submit" value="<% multilang("Modify"); %>" name="action" onClick="return addClick('modify')">&nbsp;&nbsp
<input type="button" value="<% multilang("Clear"); %>" onClick="clear_inputs(1)">&nbsp;&nbsp;
<input type="hidden" value="/dot1ag_conf.asp" name="submit-url">


<p>
<hr size=1 noshade align=top>
<font size=2><b><% multilang("CFM Instance Table"); %>:</b></font>
<table id="cfm_tbl" border=0 width="600" cellspacing=4 cellpadding=0>
<tr><font size=1>
	<th align=center bgColor="#808080"><% multilang("Select"); %></th>
	<th align=center bgColor="#808080"><% multilang("Interface"); %></th>
	<th align=center bgColor="#808080"><% multilang("MD Name"); %></th>
	<th align=center bgColor="#808080"><% multilang("MD Lvel"); %></th>
	<th align=center bgColor="#808080"><% multilang("MA Name"); %></th>
	<th align=center bgColor="#808080"><% multilang("MEP ID"); %></th>
	<th align=center bgColor="#808080"><% multilang("CCM Status"); %></th>
</font></tr>
</table>
</form>
</blockquote>
</body>

</html>
<SCRIPT>

