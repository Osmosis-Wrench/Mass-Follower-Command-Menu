import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import skyui.util.Tween;
import mx.utils.Delegate;
import skse;
import JSON;

class QuickFollowerMenu extends MovieClip
{
    var StopWaiting_Input:MovieClip;
    var StopWaiting_Option:MovieClip;
    var Wait_Input:MovieClip;
    var Wait_Option:MovieClip;
    var Teleport_Input:MovieClip;
    var Teleport_Option:MovieClip;
    var Inventory_Input:MovieClip;
    var Inventory_Option:MovieClip;

	function QuickFollowerMenu()
	{
		super();
		
		FocusHandler.instance.setFocus(this,0);

		StopWaiting_Input.onRollOver = function()
		{
			_parent.onInputRectMouseOver(1);
		};
		StopWaiting_Input.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(1);
			}
		};

		Wait_Input.onRollOver = function()
		{
			_parent.onInputRectMouseOver(2);
		};
		Wait_Input.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(2);
			}
		};

		Teleport_Input.onRollOver = function()
		{
			_parent.onInputRectMouseOver(3);
		};
		Teleport_Input.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(3);
			}
		};

		Inventory_Input.onRollOver = function()
		{
			_parent.onInputRectMouseOver(4);
		};
		Inventory_Input.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(4);
			}
		};
	}

	function onInputRectMouseOver(aiSelection:Number):Void
	{
        trace(aiSelection);
    }

    function onInputRectClick(aiSelection:Number):Void
	{
        trace(aiSelection);
    }

}