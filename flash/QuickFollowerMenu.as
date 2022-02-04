import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import skyui.util.Tween;
import mx.utils.Delegate;
import skse;

class QuickFollowerMenu extends MovieClip
{
    var StopWaiting_Input:MovieClip;
    var StopWaiting_Option:MovieClip;
	var stopwaiting_icon:MovieClip;
	var StopWaiting_Width: Number;
	var StopWaiting_Height: Number;
	var StopWaiting_Color: Color;
	
    var Wait_Input:MovieClip;
    var Wait_Option:MovieClip;
	var wait_icon:MovieClip;
	var Wait_Width: Number;
	var Wait_Height: Number;
	var Wait_Color: Color;
	
    var Teleport_Input:MovieClip;
    var Teleport_Option:MovieClip;
	var teleport_icon:MovieClip;
	var Teleport_Width: Number;
	var Teleport_Height: Number;
	var Teleport_Color: Color;
	
    var Inventory_Input:MovieClip;
    var Inventory_Option:MovieClip;
	var inventory_icon:MovieClip;
	var Inventory_Width: Number;
	var Inventory_Height: Number;
	var Inventory_Color: Color;
	
	var shines_mc:MovieClip;
	var currentSelection:Number;
	
	var highlighted:Color;
	var unhighlighted:Color;


	function QuickFollowerMenu()
	{
		super();
		shines_mc._alpha = 0;
		currentSelection = 0;
		FocusHandler.instance.setFocus(this,0);
		
		StopWaiting_Color = new Color(StopWaiting_Option.stopwaiting_icon);
		Wait_Color = new Color(Wait_Option.wait_icon);
		Teleport_Color = new Color(Teleport_Option.teleport_icon);
		Inventory_Color = new Color(Inventory_Option.inventory_icon);
		
		resetColor();

		//Inventory_Option._alpha = 70;
		//Wait_Option._alpha = 70;
		//StopWaiting_Option._alpha = 70;
		//Teleport_Option._alpha = 70;
		
		//unhighlighted = new color(0xB3B3B3);
		//highlighted = new color(0xE3E3E3);

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
	
	function onLoad():Void
	{
		this._alpha = 0;
		
		StopWaiting_Width = StopWaiting_Option._width
		StopWaiting_Height = StopWaiting_Option._height
		Wait_Width = Wait_Option._width
		Wait_Height = Wait_Option._height
		Teleport_Width = Teleport_Option._width
		Teleport_Height = Teleport_Option._height
		Inventory_Width = Inventory_Option._width
		Inventory_Height = Inventory_Option._height
		
		Tween.LinearTween(this,"_alpha", this._alpha, 100, 0.3);
	}

	function onInputRectMouseOver(aiSelection:Number):Void
	{
		handleHighlight(aiSelection);
    }

    function onInputRectClick(aiSelection:Number):Void
	{
		handleSelection(aiSelection);
    }
	
	function handleInput(details: InputDetails, pathToFocus: Array): Void
	{
		if (GlobalFunc.IsKeyPressed(details)){
			if (details.navEquivalent == NavigationCode.UP)
			{
				if (currentSelection == 1){
					handleSelection(1);
				} else {
				handleHighlight(1);
				}
			}
			else if (details.navEquivalent == NavigationCode.LEFT)
			{
				if (currentSelection == 2){
					handleSelection(2);
				} else {
					handleHighlight(2);
				}
			}
			else if (details.navEquivalent == NavigationCode.RIGHT)
			{
				if (currentSelection == 3){
					handleSelection(3);
				} else {
					handleHighlight(3);
				}
			}
			else if (details.navEquivalent == NavigationCode.DOWN)
			{
				if (currentSelection == 4){
					handleSelection(4);
				} else {
					handleHighlight(4);
				}
			}
			else if (details.navEquivalent == NavigationCode.GAMEPAD_A)
			{
				handleSelection(currentSelection);
			}
			else if (details.navEquivalent == NavigationCode.GAMEPAD_B || details.navEquivalent == NavigationCode.TAB || details.navEquivalent == NavigationCode.GAMEPAD_BACK)
			{
				doClose();
			}
		}
	}
	
	function handleHighlight(aiSelection:Number):Void
	{
		trace("Highlight: "+aiSelection);
		currentSelection = aiSelection;
		//Inventory_Option._alpha = 70;
		//Wait_Option._alpha = 70;
		//StopWaiting_Option._alpha = 70;
		//Teleport_Option._alpha = 70;
		
		resetColor();
		
		shines_mc._alpha = 0;
		GameDelegate.call("HighlightMenu", [aiSelection]);
		GameDelegate.call("PlaySound",["UISkillsBackward"]);
		
		Tween.LinearTween(StopWaiting_Option,"_width", StopWaiting_Option._width, StopWaiting_Width, 0.2);
		Tween.LinearTween(StopWaiting_Option,"_height", StopWaiting_Option._height, StopWaiting_Height, 0.2);
		Tween.LinearTween(Wait_Option,"_width", Wait_Option._width, Wait_Width, 0.2);
		Tween.LinearTween(Wait_Option,"_height", Wait_Option._height, Wait_Height, 0.2);
		Tween.LinearTween(Teleport_Option,"_width", Teleport_Option._width, Teleport_Width, 0.2);
		Tween.LinearTween(Teleport_Option,"_height", Teleport_Option._height, Teleport_Height, 0.2);
		Tween.LinearTween(Inventory_Option,"_width", Inventory_Option._width, Inventory_Width, 0.2);
		Tween.LinearTween(Inventory_Option,"_height", Inventory_Option._height, Inventory_Height, 0.2);
		
		var scale: Number = 10;
		
		switch(aiSelection){
			case 1:
				StopWaiting_Color.setRGB(0xE3E3E3);
				StopWaiting_Option.stopwaiting_text.textColor = 0xE3E3E3;
				//StopWaiting_Option._alpha = 100;
				
				Tween.LinearTween(shines_mc,"_alpha", shines_mc._alpha, 10, 0.3);
				Tween.LinearTween(StopWaiting_Option,"_width", StopWaiting_Option._width, StopWaiting_Width+scale, 0.2);
				Tween.LinearTween(StopWaiting_Option,"_height", StopWaiting_Option._height, StopWaiting_Height+scale, 0.2);
				
				shines_mc._rotation = 135;
				break;
			case 2:
				Wait_Color.setRGB(0xE3E3E3);
				Wait_Option.wait_text.textColor = 0xE3E3E3;
				//Wait_Option._alpha = 100;
				
				Tween.LinearTween(shines_mc,"_alpha", shines_mc._alpha, 10, 0.3);
				Tween.LinearTween(Wait_Option,"_width", Wait_Option._width, Wait_Width+scale, 0.2);
				Tween.LinearTween(Wait_Option,"_height", Wait_Option._height, Wait_Height+scale, 0.2);
				
				shines_mc._rotation = 45;
				break;
			case 3:
				Teleport_Color.setRGB(0xE3E3E3);
				Teleport_Option.teleport_text.textColor = 0xE3E3E3;
				//Teleport_Option._alpha = 100;
				
				Tween.LinearTween(shines_mc,"_alpha", shines_mc._alpha, 10, 0.3);
				Tween.LinearTween(Teleport_Option,"_width", Teleport_Option._width, Teleport_Width+scale, 0.2);
				Tween.LinearTween(Teleport_Option,"_height", Teleport_Option._height, Teleport_Height+scale, 0.2);
				
				shines_mc._rotation = -135;
				break;
			case 4:
				Inventory_Color.setRGB(0xE3E3E3);
				Inventory_Option.inventory_text.textColor = 0xE3E3E3;
				//Inventory_Option._alpha = 100;
				
				Tween.LinearTween(shines_mc,"_alpha", shines_mc._alpha, 10, 0.3);
				Tween.LinearTween(Inventory_Option,"_width", Inventory_Option._width, Inventory_Width+scale, 0.2);
				Tween.LinearTween(Inventory_Option,"_height", Inventory_Option._height, Inventory_Height+scale, 0.2);
				
				shines_mc._rotation = -45;
				break;
		}
	}
	
	function handleSelection(aiSelection:Number):Void
	{
		trace("Select: "+aiSelection);
		GameDelegate.call("PlaySound",["UISkillsFocus"]);
		switch(aiSelection){
			case 1:
				skse.SendModEvent("QuickFollowerMenu", "StopWaiting");
				break;
			case 2:
				skse.SendModEvent("QuickFollowerMenu", "StartWaiting");
				break;
			case 3:
				skse.SendModEvent("QuickFollowerMenu", "Teleport");
				break;
			case 4:
				skse.SendModEvent("QuickFollowerMenu", "Inventory");
				break;
		}
		doClose();
	}
	
	function doClose():Void
	{
		var onFadeTweenComplete:Function = Delegate.create(this, function ()
		{
			skse.CloseMenu("CustomMenu");
		});
		Tween.LinearTween(this,"_alpha", this._alpha, 0, 0.2, onFadeTweenComplete());
	}
	
	function resetColor():Void
	{
		StopWaiting_Color.setRGB(0xB3B3B3);
		StopWaiting_Option.stopwaiting_text.textColor = 0xB3B3B3;
		Wait_Color.setRGB(0xB3B3B3);
		Wait_Option.wait_text.textColor = 0xB3B3B3;
		Teleport_Color.setRGB(0xB3B3B3);
		Teleport_Option.teleport_text.textColor = 0xB3B3B3;
		Inventory_Color.setRGB(0xB3B3B3);
		Inventory_Option.inventory_text.textColor = 0xB3B3B3;
	}

}