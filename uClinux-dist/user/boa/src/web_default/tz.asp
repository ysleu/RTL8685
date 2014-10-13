<html>
<! Copyright (c) Realtek Semiconductor Corp., 2004. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Time Zone"); %><% multilang(" Configuration"); %></title>
<script type="text/javascript" src="share.js"> </script>
<script>

var ntp_zone_index=4;

function ntp_entry(name, value) { 
	this.name = name ;
	this.value = value ;
} 

function setNtpServer(field, ntpServer){
    field.selectedIndex = 0 ;
    for(i=0 ;i < field.options.length ; i++){
    	if(field.options[i].value == ntpServer){
		field.options[i].selected = true;
		break;
	}
    }
}

function checkEmpty(field){
	if(field.value.length == 0){
		alert(field.name + " field can't be empty\n");
		field.value = field.defaultValue;
		field.focus();
		return false;
	}
	else
		return true;
}
function checkNumber(field){
    str =field.value ;
    for (var i=0; i<str.length; i++) {
    	if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9'))
                        continue;
	field.value = field.defaultValue;
        alert("Invalid " +field.name + " Number. It should be in number (0-9).");
        return false;
    }	
	return true;
}
function checkMonth(str) {
  d = parseInt(str, 10);
  if (d < 0 || d > 12)
      	return false;
  return true;
}
function checkDay(str, month) {
  d = parseInt(str, 10);
  m = parseInt (month, 10);
  if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) {
  	if (d < 0 || d > 31)
      		return false;
  }
  else if (m == 4 || m == 6 || m == 9 || m == 11) {
  	if (d < 0 || d > 31)
      		return false;
  }
  else if (m == 2) {
  	if (d < 0 || d > 29)
      		return false;
  }
  else
  	return false;
  return true;
}
function checkHour(str) {
  d = parseInt(str, 10);
  if (d < 0 || d >= 24)
      	return false;
  return true;
}
function checkTime(str) {
  d = parseInt(str, 10);
  if (d < 0 || d >= 60)
      	return false;
  return true;
}
function saveChanges(form){
	if((checkEmpty(form.year)& checkEmpty(form.month) & checkEmpty(form.hour)
	 & checkEmpty(form.day) &checkEmpty(form.minute) & checkEmpty(form.second))== false)
	 	return false;

	if((checkNumber(form.year)& checkNumber(form.month) & checkNumber(form.hour)
	 & checkNumber(form.day) &checkNumber(form.minute) & checkNumber(form.second))== false)
	 	return false;
	if(form.month.value == '0'){
		form.month.value = form.month.defaultValue;
        	alert("Invalid month Number. It should be in  number (1-9).");
		return false;
	}
	if (!checkMonth(form.month.value)) {
		alert("Invalid month setting!");	
		form.month.focus();
		return false;
	}
	if (!checkDay(form.day.value, form.month.value)) {
		alert("Invalid day setting!");	
		form.day.focus();
		return false;
	}
	if (!checkHour(form.hour.value)) {
		alert("Invalid hour setting!");	
		form.hour.focus();
		return false;
	}
	if (!checkTime(form.minute.value) || !checkTime(form.second.value)) {
		alert("Invalid time setting!");	
		return false;
	}
	if (form.enabled.checked && form.ntpServerId[1].checked && form.ntpServerHost2.value != form.ntpServerHost2.defaultValue) {
		if (form.ntpServerHost2.value == "" || !checkString(form.ntpServerHost2.value)) {
			alert("Invalid server string !");
			form.ntpServerHost2.value = form.ntpServerHost2.defaultValue;
			form.ntpServerHost2.focus();
			return false;
		}
	}	
	return true;
}
function updateState(form)
{
	if(form.enabled.checked){
		enableTextField(form.ntpServerHost1);
		if(form.ntpServerHost2 != null)
			enableTextField(form.ntpServerHost2);
	}
	else{
		disableTextField(form.ntpServerHost1);
		if(form.ntpServerHost2 != null)
			disableTextField(form.ntpServerHost2);
	}
}
</script>
</head>
<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Time Zone"); %><% multilang(" Configuration"); %></font></h2>
<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
  <% multilang("You can maintain the system time by synchronizing with a public time server over the Internet."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
  </table>
<form action=/boaform/formNtp method=POST name="time">
<table border="0" width=520>
	<tr>
	<td width ="25%">
	<font size=2> <b> <% multilang("Current Time"); %> : </b> </font>
	</td>
	<td width ="75%">
                <font size =2> <b>
                Year <input type="text" name="year" value="<% getInfo("year"); %>" size="4" maxlength="4">
                Mon <input type="text" name="month" value="<% getInfo("month"); %>" size="2" maxlength="2">
                Day <input type="text" name="day" value="<% getInfo("day"); %>" size="2" maxlength="2">
		<br>
                Hour <input type="text" name="hour" value="<% getInfo("hour"); %>" size="2" maxlength="2">
                Min <input type="text" name="minute" value="<% getInfo("minute"); %>" size="2" maxlength="2">
                Sec <input type="text" name="second" value="<% getInfo("second"); %>" size="2" maxlength="2">
                </b> </font>
        </td>
	</tr>
	
	<tr><td width="25%"><font size=2> <b><% multilang("Time Zone Select"); %> : </b> </font></td>
	    <td width="75%">
            <select name="timeZone">
	    	<% timeZoneList(); %>
            </select>
	    </td>
	</tr>	
	<tr ><td height=10> </td> </tr>

	<tr><td colspan="2"><font size=2><b>
		<input type="checkbox" name="dst_enabled" 
		value="ON">&nbsp;&nbsp;<% multilang("Enable Daylight Saving Time"); %></b></font><br>
	    </td>
	</tr>

	<tr><td colspan="2"><font size=2><b>
		<input type="checkbox" name="enabled" 
		value="ON" 
		ONCLICK=updateState(document.time)>&nbsp;&nbsp;<% multilang("Enable SNTP Client Update"); %></b><br>
	    </td>
	</tr>
	<tr>
	<td width ="25%">
	<font size=2> <b> SNTP <% multilang("Server"); %> : </b> </font>
	</td>
	<td width ="75%">
		<input type="radio" value="0" name="ntpServerId"></input>
		<select name="ntpServerHost1">
			<option value="192.5.41.41">192.5.41.41    - North America</option>
			<option value="192.5.41.209">192.5.41.209   - North America</option>
			<option value="130.149.17.8">130.149.17.8   - Europe</option>
			<option value="203.117.180.36"> 203.117.180.36 - Asia Pacific</option>
		</select>
	</td>
	</tr>
	<td width ="25%"> <font size=2><b> </b></font>
	</td>
	<td width ="75%">
	<input type="radio" value="1" name="ntpServerId"></input>
	<!--ping_zhang:20081217 START:patch from telefonica branch to support WT-107-->
	<input type="text" name="ntpServerHost2" size="15" maxlength="30" value=<% getInfo("ntpServerHost2"); %>> <font size=2> (<% multilang("Manual Setting"); %>) </font>
		</td>
	</tr>
</table>
  <input type="hidden" value="/tz.asp" name="submit-url">
  <p><input type="submit" value="<% multilang("Apply Changes"); %>" name="save" onClick="return saveChanges(document.time)">
&nbsp;&nbsp;
  <input type="button" value="<% multilang("Refresh"); %>" name="refresh" onClick="javascript: window.location.reload()">
</form>
<script>
		<% initPage("ntp"); %>
		setNtpServer(document.time.ntpServerHost1, "<% getInfo("ntpServerHost1"); %>");	
		updateState(document.time);
</script>
</blockquote>
</font>
</body>

</html>
