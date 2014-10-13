<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<meta http-equiv="refresh" content="10" > 
<title><% multilang("CFM (802.1ag) Status"); %></title>
<script type="text/javascript" src="share.js">
</script>
<script>
<% dot1ag_status_init() %>

function show_table()
{
	var table = document.getElementById("mep_tbl");

	for(var i = 0 ; i < meps.length ; i++)
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
				tmp += meps[i].interface;
				break;
			case 1:
				tmp += meps[i].status;
				break;
			case 2:
				tmp += meps[i].md_name;
				break;
			case 3:
				tmp += meps[i].ma_name;
				break;
			case 4:
				tmp += meps[i].mep_id;
				break;
			case 5:
				tmp += meps[i].mac;
				break;
			}
			cell.innerHTML = tmp;
		}
	}
}
</script>

</head>


<body onLoad="show_table();">
<blockquote>
<h2><font color="#0000FF"><% multilang("CFM (802.1ag) Status"); %></font></h2>

<font size=2><b><% multilang("Remote MEP"); %>:</b></font>
<table id="mep_tbl" border=0 width="600" cellspacing=4 cellpadding=0>
<tr><font size=1>
	<th align=center bgColor="#808080"><% multilang("Interface"); %></th>
	<th align=center bgColor="#808080"><% multilang("Status"); %></th>
	<th align=center bgColor="#808080"><% multilang("MD Name"); %></th>
	<th align=center bgColor="#808080"><% multilang("MA Name"); %></th>
	<th align=center bgColor="#808080"><% multilang("Remote MEP ID"); %></th>
	<th align=center bgColor="#808080"><% multilang("Src MAC Address"); %></th>
</font></tr>
</table>
</body>

</html>
<SCRIPT>

