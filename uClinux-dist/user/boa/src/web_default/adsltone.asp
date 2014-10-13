<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>ADSL <% multilang("Tone Mask"); %><% multilang(" Configuration"); %></title>
<SCRIPT>

function maskAllClick()
{
   if ( !confirm('Do you really want to MASK all Tones?') ) {
	return false;
  }
  else
	return true;
}

function unmaskAllClick()
{
   if ( !confirm('Do you really want to UNMASK all Tones?') ) {
	return false;
  }
  else
	return true;
}


</SCRIPT>

</head>

<body>
<blockquote>
<h2><font color="#0000FF">ADSL <% multilang("Tone Mask"); %><% multilang(" Configuration"); %></font></h2>

<table border=0 width="480" cellspacing=0 cellpadding=0>
  <tr><td><font size=2>
  <% multilang("This page let user to mark the designate tones to be masked."); %>
  </font></td></tr>
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>


<form action=/boaform/formSetAdslTone method=POST name="formToneTbl">

<table border=0 width=400 cellspacing=4 cellpadding=0>
<% adslToneConfDiagList(); %>
</table>

<input type="submit" value="<% multilang("Apply Changes"); %>" name="apply">&nbsp;&nbsp;
<input type="submit" value="<% multilang("Mask All"); %>" name="maskAll" onClick="return maskAllClick()">&nbsp;&nbsp;&nbsp;
<input type="submit" value="<% multilang("Unmask All"); %>" name="unmaskAll" onClick="return unmaskAllClick()">&nbsp;&nbsp;&nbsp;
<input type="hidden" value="/adsltone.asp" name="submit-url"> 
<input type="button" value="<% multilang("Close"); %>" name="close" onClick="javascript: window.close();">

</form>
</blockquote>
</body>

</html>

