<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_showHideLayers() { //v3.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function openwin(page,target,feature) {
var newwin=window.open(page,target,feature);
}

function openPictureWindow_Fever(imageName,imageWidth,imageHeight,alt,posLeft,posTop) {
	newWindow = window.open("","newWindow","width="+imageWidth+",height="+imageHeight+",left="+posLeft+",top="+posTop);
	newWindow.document.open();
	newWindow.document.write('<html><title>'+alt+'</title><body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" onBlur="self.close()">'); 
	newWindow.document.write('<img src='+imageName+' width='+imageWidth+' height='+imageHeight+' alt='+alt+'>'); 
	newWindow.document.write('</body></html>');
	newWindow.document.close();
	newWindow.focus();
}

var navmenuout = true
var navmenutimeoutID = 1

var mouseout_menuarticle = true
var menutimeoutID = 1
var pollanswer = false

function navmenu_over() {
navmenuout = false ;
clearTimeout(navmenutimeoutID);
}

function navmenu_out() {
navmenuout = true ;
navmenutimeoutID = setTimeout("autohide_menu()","800");
}

function autohide_menu() {
if (navmenuout == true) {
  MM_showHideLayers('nav01','','hide');
  MM_showHideLayers('nav02','','hide');
  MM_showHideLayers('nav03','','hide');
  MM_showHideLayers('nav04','','hide');
  MM_showHideLayers('nav05','','hide');
  MM_showHideLayers('nav06','','hide');
  MM_showHideLayers('nav07','','hide');
}
}

function MM_checkPlugin(plgIn, theURL, altURL, autoGo) { //v4.0
  var ok=false; document.MM_returnValue = false;
  with (navigator) if (appName.indexOf('Microsoft')==-1 || (plugins && plugins.length)) {
    ok=(plugins && plugins[plgIn]);
  } else if (appVersion.indexOf('3.1')==-1) { //not Netscape or Win3.1
    if (plgIn.indexOf("Flash")!=-1 && window.MM_flash!=null) ok=window.MM_flash;
    else if (plgIn.indexOf("Director")!=-1 && window.MM_dir!=null) ok=window.MM_dir;
    else ok=autoGo; }
  if (!ok) theURL=altURL; if (theURL) window.location=theURL;
}



function hideother(layername) {
if (layername != 'nav01'){
MM_showHideLayers('nav01','','hide');
}
if (layername != 'nav02'){
MM_showHideLayers('nav02','','hide');
}
if (layername != 'nav03'){
MM_showHideLayers('nav03','','hide');
}
if (layername != 'nav04'){
MM_showHideLayers('nav04','','hide');
}
if (layername != 'nav05'){
MM_showHideLayers('nav05','','hide');
}
if (layername != 'nav06'){
MM_showHideLayers('nav06','','hide');
}
if (layername != 'nav07'){
MM_showHideLayers('nav07','','hide');
}
}
