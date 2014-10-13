<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title><% multilang("Connection Limit"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script>
function skip () { this.blur(); }

function addClick()
{

  if (document.formConnLimitAdd.connLimitcap[0].checked)
  	return false;
 
 if (document.formConnLimitAdd.ip.value=="") {
	alert("IP address cannot be empty! It should be filled with 4 digit numbers as xxx.xxx.xxx.xxx.");
	document.formConnLimitAdd.ip.focus();
	return false;
  }
   	
   	num1 = parseInt(document.formConnLimitAdd.tcpconnlimit.value,10);
   	num4 = parseInt(document.formConnLimitAdd.udpconnlimit.value,10);
   	num2 = parseInt(document.formConnLimitAdd.connnum.value,10);
   	num3 = parseInt(document.formConnLimitAdd.protocol.value,10);
   	if ((num1!=0)&&( num3 == 0) && ( num2 > num1)){
   		alert("Max Limitation Ports should be lower than Global TCP Connection Limit");
   		document.formConnLimitAdd.connnum.focus();
   		return false;
   	}
   	else if ((num4 != 0)&&( num3 == 1)&&( num2 > num4)){
   		alert("Max Limitation Ports should be lower than Global UDP Connection Limit");
   		document.formConnLimitAdd.connnum.focus();
   		return false;
   	}


  if ( !checkDigitRange(document.formConnLimitAdd.ip.value,1,0,255) ) {
      	alert('Invalid IP address range in 1st digit. It should be 0-255.');
	document.formConnLimitAdd.ip.focus();
	return false;
  }
  if ( !checkDigitRange(document.formConnLimitAdd.ip.value,2,0,255) ) {
      	alert('Invalid IP address range in 2nd digit. It should be 0-255.');
	document.formConnLimitAdd.ip.focus();
	return false;
  }
  if ( !checkDigitRange(document.formConnLimitAdd.ip.value,3,0,255) ) {
      	alert('Invalid IP address range in 3rd digit. It should be 0-255.');
	document.formConnLimitAdd.ip.focus();
	return false;
  }
  if ( !checkDigitRange(document.formConnLimitAdd.ip.value,4,1,254) ) {
      	alert('Invalid IP address range in 4th digit. It should be 1-254.');
	document.formConnLimitAdd.ip.focus();
	return false;
  }   		
  return true;
}

function disableDelButton()
{

  if (verifyBrowser() != "ns") {
	disableButton(document.formConnLimitDel.deleteSelconnLimit);
	disableButton(document.formConnLimitDel.deleteAllconnLimit);
  }

}

function updateState()
{
	
//  if (document.formConnLimitAdd.enabled.checked) {
  if (document.formConnLimitAdd.connLimitcap[1].checked) {
 	enableTextField(document.formConnLimitAdd.ip);
	enableTextField(document.formConnLimitAdd.protocol);
	enableTextField(document.formConnLimitAdd.connnum);	
	//enableTextField(document.formConnLimitAdd.cnlm_enable);
  }
  else {
 	disableTextField(document.formConnLimitAdd.ip);
	disableTextField(document.formConnLimitAdd.protocol);
	disableTextField(document.formConnLimitAdd.connnum);
	//disableTextField(document.formConnLimitAdd.cnlm_enable);
  }

}



</script>
</head>

<body>
<blockquote>
<h2><font color="#0000FF"><% multilang("Connection Limit"); %></font></h2>
<form action=/boaform/formConnlimit method=POST name="formConnLimitAdd">
<table border=0 width="500" cellspacing=0 cellpadding=0>
<tr><td><font size=2>
 <% multilang("Entries in this table allow you to limit the number of TCP/UDP ports used by internal users."); %>
</font></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=0 cellpadding=0>




<tr><td><font size=2><b><% multilang("Connection Limit"); %>:</b>
	<input type="radio" value="0" name="connLimitcap" <% checkWrite("connLimit-cap0"); %> onClick="updateState()"><% multilang("Disable"); %>&nbsp;&nbsp;
	<input type="radio" value="1" name="connLimitcap" <% checkWrite("connLimit-cap1"); %> onClick="updateState()"><% multilang("Enable"); %>&nbsp;&nbsp;
	
</font></td></tr>
<tr><td><font size=2><b><% multilang("Global"); %> TCP <% multilang("Connection Limit"); %>:</b>
	<input type="text" name="tcpconnlimit" size="4" maxlength="4" value=<% getInfo("connLimit-tcp"); %>> &nbsp;(<% multilang("0 for no limit"); %>) &nbsp; </td>
</font></td></tr>
<tr><td><font size=2><b><% multilang("Global"); %> UDP <% multilang("Connection Limit"); %>:</b>
	<input type="text" name="udpconnlimit" size="4" maxlength="4" value=<% getInfo("connLimit-udp"); %> > &nbsp;(<% multilang("0 for no limit"); %>) &nbsp; </td>
</font></tr>
<tr><td><input type="submit" value="<% multilang("Apply Changes"); %>" name="apply">&nbsp;&nbsp;
	<input type="hidden" value="/connlimit.asp" name="submit-url"></td></tr>


</table>
<table border=0 width="500" cellspacing=0 cellpadding=0>
	<tr><td><hr size=1 noshade align=top></td></tr>
	<tr>
		<td><font size=2>
			<b><% multilang("Protocol"); %>:</b>
				<select name="protocol">
					<option select value=0>TCP</option>
					<option value=1>UDP</option>
				</select>&nbsp;			
		</td>
	</tr>
	<tr>
		<td><font size=2><b><% multilang("Local"); %> <% multilang("IP Address"); %>:&nbsp;</b>
				<input type="text" name="ip" size="10" maxlength="15">&nbsp;&nbsp;&nbsp;
			<font size=2><b><% multilang("Max Limitation Ports"); %>:</b>
				<input type="text" name="connnum" size="3" maxlength="5">
		</td>
	</tr>
	<tr>
		<td>
			<input type="submit" value="<% multilang("Add"); %>" name="addconnlimit" onClick="return addClick()">
			<input type="hidden" value="/fw-portfw.asp" name="submit-url">
		</td>
	</tr>
<script> updateState(); </script>
</form>
</table>


<br>
<form action=/boaform/formConnlimit method=POST name="formConnLimitDel">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><hr size=1 noshade align=top></td></tr>
  <tr><td><font size=2><b><% multilang("Current Connection Limit Table"); %>:</b></font></td></tr>
</table>
<table border=0 width=500>
<% connlmitList(); %>
</table>

 <br><input type="submit" value="<% multilang("Delete Selected"); %>" name="deleteSelconnLimit" onClick="return deleteClick()">&nbsp;&nbsp;
     <input type="submit" value="<% multilang("Delete All"); %>" name="deleteAllconnLimit" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
     <input type="hidden" value="/connlimit.asp" name="submit-url">
 <script>
   	<% checkWrite("connLimitNum"); %>
 </script>
     
</form>

</td></tr></table>

</blockquote>
</body>
</html>
