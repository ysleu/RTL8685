<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<title>RADVD <% multilang("Configuration"); %></title>
<script type="text/javascript" src="share.js">
</script>

<SCRIPT>

function resetClick()
{
	document.radvd.reset;
}

function saveChanges()
{
	if (document.radvd.MaxRtrAdvIntervalAct.value.length !=0) {
		if ( checkDigit(document.radvd.MaxRtrAdvIntervalAct.value) == 0) {
			alert("Invalid MaxRtrAdvInterval! It should be the decimal number (0-9)");	
			document.radvd.MaxRtrAdvIntervalAct.focus();
			return false;
		}
	}
	
	MaxRAI = parseInt(document.radvd.MaxRtrAdvIntervalAct.value, 10);
	if ( MaxRAI <= 4 || MaxRAI > 1800 ) {
		alert("MaxRtrAdvInterval must be no less than 4 seconds and no greater than 1800 seconds.");
		document.radvd.MaxRtrAdvIntervalAct.focus();
		return false;
	}
		
	if (document.radvd.MinRtrAdvIntervalAct.value.length !=0) {
		if ( checkDigit(document.radvd.MinRtrAdvIntervalAct.value) == 0) {
			alert("Invalid MinRtrAdvInterval! It should be the decimal number (0-9)");	
			document.radvd.MinRtrAdvIntervalAct.focus();
			return false;
		}
	}
	
	MinRAI = parseInt(document.radvd.MinRtrAdvIntervalAct.value, 10);
	MaxRAI075 = 0.75 * MaxRAI;
	if ( MinRAI <= 3 || MinRAI > MaxRAI075 ) {
		alert("MinRtrAdvInterval must be no less than 3 seconds and no greater than 0.75 * MaxRtrAdvInterval.");
		document.radvd.MinRtrAdvIntervalAct.focus();
		return false;
	}
	
	if (document.radvd.AdvCurHopLimitAct.value.length !=0) {
		if ( checkDigit(document.radvd.AdvCurHopLimitAct.value) == 0) {
			alert("Invalid AdvCurHopLimit! It should be the decimal number (0-9)");	
			document.radvd.AdvCurHopLimitAct.focus();
			return false;
		}
	} 
	
	if (document.radvd.AdvDefaultLifetimeAct.value.length !=0) {
		if ( checkDigit(document.radvd.AdvDefaultLifetimeAct.value) == 0) {
			alert("Invalid AdvDefaultLifetime! It should be the decimal number (0-9)");	
			document.radvd.AdvDefaultLifetimeAct.focus();
			return false;
		}
	}
	
	dlt = parseInt(document.radvd.AdvDefaultLifetimeAct.value, 10);	
	if ( dlt != 0 && (dlt < MaxRAI || dlt > 9000) ) {
		alert("AdvDefaultLifetime must be either zero or between MaxRtrAdvInterval and 9000 seconds.");
		document.radvd.AdvDefaultLifetimeAct.focus();
		return false;
	}
	
	if (document.radvd.AdvReachableTimeAct.value.length !=0) {
		if ( checkDigit(document.radvd.AdvReachableTimeAct.value) == 0) {
			alert("Invalid AdvReachableTime! It should be the decimal number (0-9)");	
			document.radvd.AdvReachableTimeAct.focus();
			return false;
		}
	}
	
	if (document.radvd.AdvRetransTimerAct.value.length !=0) {
		if ( checkDigit(document.radvd.AdvRetransTimerAct.value) == 0) {
			alert("Invalid AdvRetransTimer! It should be the decimal number (0-9)");	
			document.radvd.AdvRetransTimerAct.focus();
			return false;
		}
	}
	
	if (document.radvd.AdvLinkMTUAct.value.length !=0) {
		if ( checkDigit(document.radvd.AdvLinkMTUAct.value) == 0) {
			alert("Invalid AdvLinkMTU! It should be the decimal number (0-9)");	
			document.radvd.AdvLinkMTUAct.focus();
			return false;
		}
	}
	
	lmtu= parseInt(document.radvd.AdvLinkMTUAct.value, 10);	
	if ( lmtu != 0 && (lmtu < 1280 || lmtu > 1500) ) {
		alert("AdvLinkMTU must be either zero or between 1280 and 1500.");
		document.radvd.AdvLinkMTUAct.focus();
		return false;
	}	


    if(document.radvd.EnableULA[1].checked){
		if (document.radvd.ULAPrefix.value =="") {
			alert("ULA Prefix IP address cannot be empty! Format is IPV6 address. For example: fc01::");
			document.radvd.ULAPrefix.focus();
			return false;
		} else {
			if ( validateKeyV6IP(document.radvd.ULAPrefix.value) == 0) {
				alert("Invalid ULA prefix IP!");	
				document.radvd.ULAPrefix.focus();
				return false;
			}
		}
		
	   if (document.radvd.ULAPrefixlen.value =="") {
			alert("ULA Prefix length cannot be empty! For example: 64");
			document.radvd.ULAPrefixlen.focus();
			return false;
		} else {
			if ( checkDigit(document.radvd.ULAPrefixlen.value) == 0) {
				alert("Invalid ULA prefix length! It should be the decimal number (0-9)");	
				document.radvd.ULAPrefixlen.focus();
				return false;
			}
		}
		
		if (document.radvd.ULAPrefixValidTime.value =="") {
			alert("ULA Prefix Valid Time cannot be empty! Valid Range is 600~4294967295");
			document.radvd.ULAPrefixlen.focus();
			return false;
		} else if ( checkDigit(document.radvd.ULAPrefixValidTime.value) == 0) {
				alert("Invalid ULAPrefixValidTime! It should be the decimal number (0-9)");	
				document.radvd.ULAPrefixValidTime.focus();
				return false;
		}
		
		if (document.radvd.ULAPrefixPreferedTime.value =="") {
			alert("ULA Prefix Valid Time cannot be empty! Valid Range is 600~4294967295");
			document.radvd.ULAPrefixlen.focus();
			return false;
		} else if ( checkDigit(document.radvd.ULAPrefixPreferedTime.value) == 0) {
				alert("Invalid ULAPrefixPreferedTime! It should be the decimal number (0-9)");	
				document.radvd.ULAPrefixPreferedTime.focus();
				return false;
		}
    }
	
	if (document.radvd.PrefixMode.value == 1) {
		if (document.radvd.prefix_ip.value =="") {
			alert("Prefix IP address cannot be empty! Format is IPV6 address. For example: 3ffe:501:ffff:100::");
			document.radvd.prefix_ip.value = document.radvd.prefix_ip.defaultValue;
			document.radvd.prefix_ip.focus();
			return false;
		} else {
			if ( validateKeyV6IP(document.radvd.prefix_ip.value) == 0) {
				alert("Invalid prefix IP!");	
				document.radvd.prefix_ip.focus();
				return false;
			}
		}
		
		if (document.radvd.prefix_len.value =="") {
			alert("Prefix length cannot be empty!");
			document.radvd.prefix_len.value = document.radvd.prefix_len.defaultValue;
			document.radvd.prefix_len.focus();
			return false;
		} else {
			if ( checkDigit(document.radvd.prefix_len.value) == 0) {
				alert("Invalid prefix length! It should be the decimal number (0-9)");	
				document.radvd.prefix_len.focus();
				return false;
			}
		}
		
		if (document.radvd.AdvValidLifetimeAct.value.length !=0) {
			if ( checkDigit(document.radvd.AdvValidLifetimeAct.value) == 0) {
				alert("Invalid AdvValidLifetime! It should be the decimal number (0-9)");	
				document.radvd.AdvValidLifetimeAct.focus();
				return false;
			}
		}
		
		if (document.radvd.AdvPreferredLifetimeAct.value.length !=0) {
			if ( checkDigit(document.radvd.AdvPreferredLifetimeAct.value) == 0) {
				alert("Invalid AdvPreferredLifetime! It should be the decimal number (0-9)");	
				document.radvd.AdvPreferredLifetimeAct.focus();
				return false;
			}
		}		
		
		vlt = parseInt(document.radvd.AdvValidLifetimeAct.value, 10);
		plt = parseInt(document.radvd.AdvPreferredLifetimeAct.value, 10);
		if ( vlt <= plt ) {			
			alert("AdvValidLifeTime must be greater than AdvPreferredLifetime.");
			document.radvd.AdvValidLifetimeAct.focus();
			return false;
		}
	
	}
	

		if (document.radvd.RDNSS1.value !="") {
			if ( validateKeyV6IP(document.radvd.RDNSS1.value) == 0) {
				alert("Invalid RDNSS1 IP!");	
				document.radvd.RDNSS1.focus();
				return false;
			}
		}

		if (document.radvd.RDNSS2.value !="") {
			if ( validateKeyV6IP(document.radvd.RDNSS2.value) == 0) {
				alert("Invalid RDNSS2 IP!");	
				document.radvd.RDNSS2.focus();
				return false;
			}
		}

	return true;
}


function updateInput()
{	
	document.all.prefixModeDiv.style.display = 'block';

	if (document.radvd.PrefixMode.value == 1) {
		if (document.getElementById)  // DOM3 = IE5, NS6
			document.getElementById('radvdID').style.display = 'block';
			else {
			if (document.layers == false) // IE4
				document.all.radvdID.style.display = 'block';
		}
	} else {
		if (document.getElementById)  // DOM3 = IE5, NS6
			document.getElementById('radvdID').style.display = 'none';
		else {
			if (document.layers == false) // IE4
				document.all.radvdID.style.display = 'none';
		}
	}
}

function ramodechange(obj)
{
	with ( document.forms[0] ) 
	{
		if(obj.value == "0")
		{
			if (document.getElementById)  // DOM3 = IE5, NS6
			document.getElementById('radvdID').style.display = 'none';
			else {
				if (document.layers == false) // IE4
					document.all.radvdID.style.display = 'none';
			}
		}
		else
		{
			if (document.getElementById)  // DOM3 = IE5, NS6
			document.getElementById('radvdID').style.display = 'block';
			else {
			if (document.layers == false) // IE4
				document.all.radvdID.style.display = 'block';
			}
		}
	}
}

function ULASelection()
{
    if(document.radvd.EnableULA[0].checked)
    {
		document.all.ULAdiv.style.display = 'none';
    }
    else
    {
		document.all.ULAdiv.style.display = 'block';
    }
}


function on_init()
{
    if(document.radvd.EnableULA[0].checked)
    {
		document.all.ULAdiv.style.display = 'none';
    }
    else
    {
		document.all.ULAdiv.style.display = 'block';
    }

	document.all.radvdID.style.display = 'block';
	if(document.radvd.PrefixMode.value == 1)
		document.all.radvdID.style.display = 'block';
	else
		document.all.radvdID.style.display = 'none';
	
}

</SCRIPT>
</head>

<body onLoad="on_init();">
<blockquote>
<h2><font color="#0000FF">RADVD <% multilang("Configuration"); %></font></h2>

<form action=/boaform/formRadvdSetup method=POST name="radvd">
<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr><td><font size=2>
    <% multilang("This page is used to setup the RADVD's configuration of your Router."); %>
  </font></td></tr>  
  <tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="500" cellspacing=4 cellpadding=0>
  <tr>
      <td width="30%"><font size=2><b><% multilang("MaxRtrAdvInterval"); %>:</b></td>
      <td width="70%"><input type="text" name="MaxRtrAdvIntervalAct" size="15" maxlength="15" value=<% getInfo("V6MaxRtrAdvInterval"); %>></td>
  </tr>

  <tr>
      <td width="30%"><font size=2><b><% multilang("MinRtrAdvInterval"); %>:</b></td>
      <td width="70%"><input type="text" name="MinRtrAdvIntervalAct" size="15" maxlength="15" value=<% getInfo("V6MinRtrAdvInterval"); %>></td>
  </tr>
  
  <tr>
      <td width="30%"><font size=2><b><% multilang("AdvCurHopLimit"); %>:</b></td>
      <td width="70%"><input type="text" name="AdvCurHopLimitAct" size="15" maxlength="15" value=<% getInfo("V6AdvCurHopLimit"); %>></td>
  </tr>
  
  <tr>
      <td width="30%"><font size=2><b><% multilang("AdvDefaultLifetime"); %>:</b></td>
      <td width="70%"><input type="text" name="AdvDefaultLifetimeAct" size="15" maxlength="15" value=<% getInfo("V6AdvDefaultLifetime"); %>></td>
  </tr>
  
  <tr>
      <td width="30%"><font size=2><b><% multilang("AdvReachableTime"); %>:</b></td>
      <td width="70%"><input type="text" name="AdvReachableTimeAct" size="15" maxlength="15" value=<% getInfo("V6AdvReachableTime"); %>></td>
  </tr>
  
  <tr>
      <td width="30%"><font size=2><b><% multilang("AdvRetransTimer"); %>:</b></td>
      <td width="70%"><input type="text" name="AdvRetransTimerAct" size="15" maxlength="15" value=<% getInfo("V6AdvRetransTimer"); %>></td>
  </tr>
  
  <tr>
      <td width="30%"><font size=2><b><% multilang("AdvLinkMTU"); %>:</b></td>
      <td width="70%"><input type="text" name="AdvLinkMTUAct" size="15" maxlength="15" value=<% getInfo("V6AdvLinkMTU"); %>></td>
  </tr>

 
  <table border=0 width="400" cellspacing=4 cellpadding=0>
  <tr><td width=200><font size=2><b><% multilang("AdvSendAdvert"); %>:</b>&nbsp;&nbsp;</font></td>  
      <td width=200><font size=2>
   	<input type="radio" name="AdvSendAdvertAct" value=0 <% checkWrite("radvd_SendAdvert0"); %>>off&nbsp;&nbsp;
   	<input type="radio" name="AdvSendAdvertAct" value=1 <% checkWrite("radvd_SendAdvert1"); %>>on&nbsp;&nbsp;
     </font></td>
  </tr>
  </table>
  
  <table border=0 width="400" cellspacing=4 cellpadding=0>
  <tr><td width=200><font size=2><b><% multilang("AdvManagedFlag"); %>:</b>&nbsp;&nbsp;</font></td>  
      <td width=200><font size=2>
   	<input type="radio" name="AdvManagedFlagAct" value=0 <% checkWrite("radvd_ManagedFlag0"); %>>off&nbsp;&nbsp;
   	<input type="radio" name="AdvManagedFlagAct" value=1 <% checkWrite("radvd_ManagedFlag1"); %>>on&nbsp;&nbsp;
     </font></td>
  </tr>
  </table>
  
  <table border=0 width="400" cellspacing=4 cellpadding=0>
  <tr><td width=200><font size=2><b><% multilang("AdvOtherConfigFlag"); %>:</b>&nbsp;&nbsp;</font></td>  
      <td width=200><font size=2>
   	<input type="radio" name="AdvOtherConfigFlagAct" value=0 <% checkWrite("radvd_OtherConfigFlag0"); %>>off&nbsp;&nbsp;
   	<input type="radio" name="AdvOtherConfigFlagAct" value=1 <% checkWrite("radvd_OtherConfigFlag1"); %>>on&nbsp;&nbsp;
     </font></td>
  </tr>
  </table>

  <table border=0 width="400" cellspacing=4 cellpadding=0>
  <tr><td width=200><font size=2><b><% multilang("Enable ULA"); %>:</b>&nbsp;&nbsp;</font></td>  
      <td width=200><font size=2>
   	<input type="radio" name="EnableULA" value=0 <% checkWrite("radvd_EnableULAFlag0"); %> onClick="ULASelection();">off&nbsp;&nbsp;
   	<input type="radio" name="EnableULA" value=1 <% checkWrite("radvd_EnableULAFlag1"); %> onClick="ULASelection();">on&nbsp;&nbsp;
     </font></td>
  </tr>
  </table>

  <div ID="ULAdiv" style="display:none">
  <tr>
      <td width="30%"><font size=2><b><% multilang("ULA Prefix"); %>:</b></td>
      <td width="70%"><input type="text" name="ULAPrefix" size="48" maxlength="48" value=<% getInfo("V6ULAPrefix"); %>></td>
  </tr><br>

  <tr>
      <td width="30%"><font size=2><b><% multilang("ULA Prefix Len"); %>:</b></td>
      <td width="70%"><input type="text" name="ULAPrefixlen" size="10" maxlength="10" value=<% getInfo("V6ULAPrefixlen"); %>></td>
  </tr><br>
  <tr>
      <td width="30%"><font size=2><b><% multilang("ULA Prefix Valid Time"); %>:</b></td>
      <td width="70%"><input type="text" name="ULAPrefixValidTime" size="10" maxlength="10" value=<% getInfo("V6ULAPrefixValidLifetime"); %>></td>
  </tr><br>
  <tr>
      <td width="30%"><font size=2><b><% multilang("ULA Prefix Prefered Time"); %>:</b></td>
      <td width="70%"><input type="text" name="ULAPrefixPreferedTime" size="10" maxlength="10" value=<% getInfo("V6ULAPrefixPreferredLifetime"); %>></td>
  </tr><br><br>
  </div>
  
  <tr></tr><tr></tr>

</table>

  <div ID="prefixModeDiv" style="display:none">
  <tr>
      <td width=100><font size=2><% multilang("Prefix Mode"); %>:</td>
      <td><font size=2><select size="1" name="PrefixMode" id="prefixmode" onChange="ramodechange(this)">
          <OPTION VALUE="0" > <% multilang("Auto"); %></OPTION>
          <OPTION VALUE="1" > <% multilang("Manual"); %></OPTION>
	  </select>
      </td>
  </tr>

  </div>
  
  
  <div ID="radvdID" style="display:none">
       <table border=0 width="500" cellspacing=4 cellpadding=0>
         <tr><td width=150><font size=2><b><% multilang("Prefix"); %>:</b></td>
             <td width=350><input type=text name=prefix_ip size=24 maxlength=24 value=<% getInfo("V6prefix_ip"); %>></td>
         </tr>
         
         <tr><td><font size=2><b><% multilang("Prefix Length"); %>:</b></td>
             <td><input type=text name=prefix_len size=15 maxlength=15 value=<% getInfo("V6prefix_len"); %>></td>
         </tr>         
         
         <tr><td><font size=2><b><% multilang("AdvValidLifetime"); %>:</b></td>
             <td><input type=text name=AdvValidLifetimeAct size=15 maxlength=15 value=<% getInfo("V6ValidLifetime"); %>></td>
         </tr>
         
         <tr><td><font size=2><b><% multilang("AdvPreferredLifetime"); %>:</b></td>
             <td><input type=text name=AdvPreferredLifetimeAct size=15 maxlength=15 value=<% getInfo("V6PreferredLifetime"); %>></td>
         </tr>
         
         <tr><td width=200><font size=2><b><% multilang("AdvOnLink"); %>:</b>&nbsp;&nbsp;</font></td>  
             <td width=200><font size=2>
   	         <input type="radio" name="AdvOnLinkAct" value=0 <% checkWrite("radvd_OnLink0"); %>>off&nbsp;&nbsp;
   	         <input type="radio" name="AdvOnLinkAct" value=1 <% checkWrite("radvd_OnLink1"); %>>on&nbsp;&nbsp;
             </font></td>
         </tr>
  
         <tr><td width=200><font size=2><b><% multilang("AdvAutonomous"); %>:</b>&nbsp;&nbsp;</font></td>  
             <td width=200><font size=2>
   	         <input type="radio" name="AdvAutonomousAct" value=0 <% checkWrite("radvd_Autonomous0"); %>>off&nbsp;&nbsp;
   	         <input type="radio" name="AdvAutonomousAct" value=1 <% checkWrite("radvd_Autonomous1"); %>>on&nbsp;&nbsp;
             </font></td>
         </tr>
         
  <tr>
      <td width="30%"><font size=2><b><% multilang("RDNSS 1"); %>:</b></td>
      <td width="70%"><input type="text" name="RDNSS1" size="48" maxlength="48" value=<% getInfo("V6RDNSS1"); %>></td>
  </tr>


  <tr>
      <td width="30%"><font size=2><b><% multilang("RDNSS 2"); %>:</b></td>
      <td width="70%"><input type="text" name="RDNSS2" size="48" maxlength="48" value=<% getInfo("V6RDNSS2"); %>></td>
  </tr>
       </table>
  </div>

  <br>
      <input type="submit" value="<% multilang("Apply Changes"); %>" name="save" onClick="return saveChanges()">&nbsp;&nbsp;
      <!--input type="reset" value="Undo" name="reset" onClick="resetClick()"-->
      <input type="hidden" value="/radvdconf.asp" name="submit-url">


<script>
	<% initPage("radvd_conf"); %>		
</script>


 </form>
</blockquote>
</body>

</html>
