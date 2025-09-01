document.write('<img src="http://lead.31053633.com/tracking.php?CID=gen_hkah_776&AID=&TYPEID=visit&ACTION='+location.pathname+'" id="trackImg" width="1" height="1" border="0" alt="">');

function clickTrack(txt){
	var trackingBase = "http://lead.31053633.com/tracking.php?CID=gen_hkah_776&AID=&TYPEID=visit&ACTION="+location.pathname+"/";
	trackObj = document.getElementById('trackImg');
	trackObj.src = trackingBase+txt;
}
