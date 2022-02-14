import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import skyui.util.Tween;
import mx.utils.Delegate;
import skse;

class FollowerSymbol extends MovieClip
{
	var f_name: String;
	var f_state: Boolean;
	var f_highlighted: Boolean;
	var f_callback: Number = -1;
	var FollowerName: TextField;
	var followerInputRect: MovieClip;
	var mouseHeldTime: Number;
	var selector: MovieClip;
	
	function FollowerSymbol()
	{
		this._alpha = 0;
		followerInputRect.onRollOver = function ()
		{
			_parent.doHoverEffect(true);
		}
		followerInputRect.onRollOut = function ()
		{
			_parent.doHoverEffect(false);
		}
		followerInputRect.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this && f_callback != -1)
			{
				_parent.doClickEvent();
			}

		}
		followerInputRect.onMouseUp = function()
		{
			if (Mouse.getTopMostEntity() == this && f_callback != -1)
			{
				_parent.doHoldCheck();
			}
		}
		
	}
	
	function onLoad():Void
	{
		
	}
	
	function reset(): Void
	{
		this._alpha = 0;
	}
	
	function setFollower(newName:String, newState:Boolean, newCallback:Number, newHighlighted: Boolean)
	{
		reset();
		f_name = newName;
		f_state = newState;
		f_callback = newCallback;
		f_highlighted = newHighlighted;
		buildTextField();
	}
	
	function buildTextField(): Void
	{
		var color;
		f_state ? color =  "0xB3B3B3" : color = "#3A3A3A";
		FollowerName.htmlText = " <FONT FACE=\"$EverywhereBoldFont\" COLOR=\""+color+"\">"+f_name+"</FONT>";
		f_highlighted ? doHoverEffect(true) : doHoverEffect(false);
		this._alpha = 100;
	}
	
	function doClickEvent(): Void
	{
		var time = new Date();
		time.getTime();
		mouseHeldTime = time.valueOf();
	}
	
	function doHoldCheck(): Void
	{
		var time = new Date();
		time.getTime();
		trace(time - mouseHeldTime);
		if (time - mouseHeldTime >= 2000)
		{
			_parent._parent.FollowerDisableCallback(f_callback);
		} else {
			_parent._parent.FollowerCallback(f_callback);
		}
	}
	
	function doHoverEffect(isHovered: Boolean): Void
	{
		_parent._parent.onInputRectMouseOver(-1);
		if (f_name){
			if (isHovered){
				selector._alpha = 100;
				f_highlighted = true;
			} else {
				selector._alpha = 0;
				f_highlighted = false;
			}
		}
	}
		
}