//delegate : http://www.terrainformatica.com/?p=13#comments
function delegate( that, thatMethod )
{
	if(arguments.length > 2)
	{
	  var _params = [];
	  for(var n = 2; n < arguments.length; ++n) _params.push(arguments[n]);
	  return function() { return thatMethod.apply(that,_params); }
	}
	else
	  return function() { return thatMethod.call(that); }
}

function ScrollObject(name)
{
	this.speed = 10;
	this.loop;
	this.timer;

    this.el = document.getElementById(name+'_content');
    this.css = document.getElementById(name+'_content').style;
    this.scrollHeight = this.el.offsetHeight;
    this.scrollWidth = this.el.offsetWidth;
    this.clipHeight= this.el.offsetHeight;
    this.clipWidth= this.el.offsetWidth;

	this.moveSpeed = 1;

	this.objContainer = document.getElementById(name+'_container');
	this.upButton     = document.getElementById(name+'_up');
	this.downButton   = document.getElementById(name+'_down');

	this.upButton.onmouseover = delegate(this, this.performScroll, -1);
	this.upButton.onmouseout = delegate(this, this.ceaseScroll);
	this.downButton.onmouseover = delegate(this, this.performScroll, 1);
	this.downButton.onmouseout = delegate(this, this.ceaseScroll);

	this.x; 
	this.y;

	this.moveArea(0,0);
    this.objContainer.style.visibility='visible';
}

ScrollObject.prototype.moveArea = function(x,y)
{
    this.x = x;
	this.y = y;
    this.css.left = this.x + 'px';
    this.css.top = this.y + 'px';
}

ScrollObject.prototype.down = function(move)
{
/*
	console.log('DOWN');
	console.log('Y: '+this.y);
	console.log('Scroll height: '+this.scrollHeight);
	console.log('Clip height: '+this.objContainer.offsetHeight);
*/
	if(this.y > -this.scrollHeight + this.objContainer.offsetHeight)
	{
	    this.moveArea(0,this.y - move);
	    if (this.loop)
			this.timer = window.setTimeout(delegate(this, this.down, move), this.speed);
	}
	else
	{
		this.ceaseScroll();
	}
}

ScrollObject.prototype.up = function(move)
{
	if(this.y < 0)
	{
	    this.moveArea(0,this.y - move);
	    if (this.loop)
			this.timer = window.setTimeout(delegate(this, this.up, move), this.speed);
	}
	else
	{
		this.ceaseScroll();
	}
}

ScrollObject.prototype.performScroll = function(move)
{
	this.ceaseScroll();
	this.loop = true;
	if (move > 0)
		this.down(move);
	else 
		this.up(move);
}


ScrollObject.prototype.ceaseScroll = function()
{
    this.loop=false;
    if (this.timer) clearTimeout(this.timer);
}

var scrollables = new Array();

function InitialiseScrollableArea(count)
{
	for (var i = 1; i <= count ; i++)
	{
		scrollables[i] = new ScrollObject('scroller'+i);
	}
}
