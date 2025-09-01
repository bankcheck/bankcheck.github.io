//function change lang. of url: from from_lang to to_lang
function ChangeLang(from_lang,to_lang)
{
	tempurl = window.location.href
	if (tempurl.search("/"+from_lang+"/") != -1)
	{
		tempurl = tempurl.replace("/"+from_lang+"/", "/"+to_lang+"/") ;
		//alert(tempurl);
		window.location.href = tempurl
	}
}