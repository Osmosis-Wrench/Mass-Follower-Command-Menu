﻿import gfx.io.GameDelegate;
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
	var names_input:MovieClip;
	var StopWaiting_Input:MovieClip;
	var StopWaiting_Option:MovieClip;
	var stopwaiting_icon:MovieClip;
	var StopWaiting_Width:Number;
	var StopWaiting_Height:Number;
	var StopWaiting_Color:Color;

	var Wait_Input:MovieClip;
	var Wait_Option:MovieClip;
	var wait_icon:MovieClip;
	var Wait_Width:Number;
	var Wait_Height:Number;
	var Wait_Color:Color;

	var Teleport_Input:MovieClip;
	var Teleport_Option:MovieClip;
	var teleport_icon:MovieClip;
	var Teleport_Width:Number;
	var Teleport_Height:Number;
	var Teleport_Color:Color;

	var Inventory_Input:MovieClip;
	var Inventory_Option:MovieClip;
	var inventory_icon:MovieClip;
	var Inventory_Width:Number;
	var Inventory_Height:Number;
	var Inventory_Color:Color;

	var shines_mc:MovieClip;
	var currentSelection:Number;

	var highlighted:Color;
	var unhighlighted:Color;

	var followerList:MovieClip;
	var followers:Array = new Array();
	var followersSymbols:Array = new Array();
	var followersSelectionIndex:Number = -1;
	var followersShown:Boolean = false;
	var menuShown:Boolean = false;
	var buttonHeldTime:Number;
	var bg: MovieClip;
	var tNote: MovieClip;
	
	function QuickFollowerMenu()
	{
		super();
		followersSymbols.push(followerList.follower0);
		followersSymbols.push(followerList.follower1);
		followersSymbols.push(followerList.follower2);
		followersSymbols.push(followerList.follower3);
		followersSymbols.push(followerList.follower4);
		followersSymbols.push(followerList.follower5);
		followersSymbols.push(followerList.follower6);
		followersSymbols.push(followerList.follower7);
		followersSymbols.push(followerList.follower8);
		followersSymbols.push(followerList.follower9);
		followersSymbols.push(followerList.follower10);

		shines_mc._alpha = 0;
		currentSelection = 0;
		FocusHandler.instance.setFocus(this,0);

		StopWaiting_Color = new Color(StopWaiting_Option.stopwaiting_icon);
		Wait_Color = new Color(Wait_Option.wait_icon);
		Teleport_Color = new Color(Teleport_Option.teleport_icon);
		Inventory_Color = new Color(Inventory_Option.inventory_icon);

		resetColor();
		
		tNote.translatorName.translatorNameText.autoSize = "left";
		_parent.tNote.translatorName._alpha = 100;
		tNote.hereForMouseOverOnly.onRollOver = function()
		{
			_parent.translatorName._alpha = 100;
		}
		tNote.hereForMouseOverOnly.onRollOut = function()
		{
			_parent.translatorName._alpha = 0;
		}

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
		var stageObj = new Object();
		Stage.addListener(stageObj);
		stageObj.onResize = function()
		{
			_root.QuickFollowerMenu_mc.bg._width = Stage.width;
			_root.QuickFollowerMenu_mc.bg._height = Stage.height;
		};
		stageObj.onResize();
		Stage.addListener(stageObj);
		
		this._alpha = 0;
		followerList._alpha = 0;
		StopWaiting_Width = StopWaiting_Option._width;
		StopWaiting_Height = StopWaiting_Option._height;
		Wait_Width = Wait_Option._width;
		Wait_Height = Wait_Option._height;
		Teleport_Width = Teleport_Option._width;
		Teleport_Height = Teleport_Option._height;
		Inventory_Width = Inventory_Option._width;
		Inventory_Height = Inventory_Option._height;
		Tween.LinearTween(this,"_alpha",this._alpha,100,0.3);
		//getFollowersFromString("au1ri,12343,lucien,6432314","");
		menuShown = true;
	}

	function getFollowersFromString(followerString:String, followerStringDisabled:String):Void
	{
		followerString = clean(followerString);
		var parse = followerString.split(",");
		for (var i = 0; i < parse.length; i += 2)
		{
			addFollower(parse[i],true,parse[i + 1]);
		}
		if (followerStringDisabled != "")
		{
			followerStringDisabled = clean(followerStringDisabled);
			parse = followerStringDisabled.split(",");
			for (var i = 0; i < parse.length; i += 2)
			{
				for (var x = 0; x < followers.length; x++)
				{
					if (followers[x][2] == parse[i + 1])
					{
						followers[x][1] = false;
					}
				}
			}
		}
		if (followerString != "")
		{
			Tween.LinearTween(followerList,"_alpha",followerList._alpha,100,0.3);
			buildFollowersSection();
		}
	};

	function addFollower(followerName:String, followerEnabled:Boolean, followerFormId:String)
	{
		followerName = followerName.charAt(0).toUpperCase() + followerName.substring(1, followerName.length);
		var newFollower = [followerName, followerEnabled, followerFormId, false];
		followers.push(newFollower);
	}

	function buildFollowersSection():Void
	{
		for (var i = 0; i < followersSymbols.length; i++)
		{
			followersSymbols[i].reset();
		}
		var startingIndex = -1;
		if (followers.length < 11)
		{
			startingIndex =+ Math.ceil(11 / followers.length);
		}
		if (followers.length == 1)
		{
			startingIndex = +Math.floor(11 / 2);
		}
		if (followers.length == 2){
			startingIndex = 5;
		}
		for (var i = 0; i < followers.length; i++)
		{
			followersSymbols[startingIndex].setFollower(followers[i][0],followers[i][1],i,followers[i][3]);
			startingIndex++;
		}
		followersShown = true;
	}

	function FollowerCallback(arg)
	{
		followers[arg][1] = !followers[arg][1];
		trace("You clicked on follower " + followers[arg][0] + " toggling them to " + followers[arg][1]);
		if (followers[arg][1])
		{
			skse.SendModEvent("QuickFollowerMenu_Toggle","false to true",1,parseInt(followers[arg][2]));
		}
		else
		{
			skse.SendModEvent("QuickFollowerMenu_Toggle","true to false",0,parseInt(followers[arg][2]));
		}

		buildFollowersSection();
	}

	function FollowerDisableCallback(arg):Void
	{
		skse.SendModEvent("QuickFollowerMenu_Delete","follower to remove",1,parseInt(followers[arg][2]));
		trace(followers);
		delete followers[arg];
		followers.sort();
		followers.pop();
		trace(followers);
		this.buildFollowersSection();
	}

	function onInputRectMouseOver(aiSelection:Number):Void
	{
		if (menuShown)
		{
			handleHighlight(aiSelection);
		}
	}

	function onInputRectClick(aiSelection:Number):Void
	{
		if (menuShown)
		{
			handleSelection(aiSelection);
		}
	}

	function handleInput(details:InputDetails, pathToFocus:Array):Void
	{
		//test1.text = "value=" + details.value+ "navEquivalent=" + details.navEquivalent;
		if (GlobalFunc.IsKeyPressed(details) && menuShown && followersSelectionIndex == -1)
		{
			if (details.navEquivalent == NavigationCode.UP)
			{
				if (currentSelection == 1)
				{
					handleSelection(1);
				}
				else
				{
					handleHighlight(1);
				}
			}
			else if (details.navEquivalent == NavigationCode.LEFT)
			{
				if (currentSelection == 2)
				{
					handleSelection(2);
				}
				else
				{
					handleHighlight(2);
				}
			}
			else if (details.navEquivalent == NavigationCode.RIGHT)
			{
				if (currentSelection == 3)
				{
					handleSelection(3);
				}
				else
				{
					handleHighlight(3);
				}
			}
			else if (details.navEquivalent == NavigationCode.DOWN)
			{
				if (currentSelection == 4)
				{
					handleSelection(4);
				}
				else
				{
					handleHighlight(4);
				}
			}
			else if (details.navEquivalent == NavigationCode.GAMEPAD_A)
			{
				handleSelection(currentSelection);
			}
			else if (details.navEquivalent == NavigationCode.GAMEPAD_X || details.navEquivalent == NavigationCode.GAMEPAD_L1 || details.code == 16)
			{
				followersSelectionIndex = 0;
				handleHighlight(-1);
				followers[followersSelectionIndex][3] = true;
				buildFollowersSection();
			}
			else if (details.navEquivalent == NavigationCode.GAMEPAD_B || details.navEquivalent == NavigationCode.TAB || details.navEquivalent == NavigationCode.GAMEPAD_BACK)
			{
				doClose();
			}
		}
		else if (menuShown && followersShown && followersSelectionIndex != -1)
		{
			if (details.value == "keyDown")
			{
				if (details.navEquivalent == NavigationCode.UP)
				{
					followers[followersSelectionIndex][3] = false;
					followersSelectionIndex = followersSelectionIndex - 1;
					if (followersSelectionIndex <= -1)
					{
						var len = followers.length;
						followersSelectionIndex = len - 1;
					}
					followers[followersSelectionIndex][3] = true;
					buildFollowersSection();
				}
				else if (details.navEquivalent == NavigationCode.DOWN)
				{
					followers[followersSelectionIndex][3] = false;
					followersSelectionIndex = followersSelectionIndex + 1;
					if (followersSelectionIndex >= followers.length)
					{
						followersSelectionIndex = 0;
					}
					followers[followersSelectionIndex][3] = true;
					buildFollowersSection();
				}
				else if (details.navEquivalent == NavigationCode.GAMEPAD_A)
				{
					var time = new Date();
					time.getTime();
					buttonHeldTime = time.valueOf();
				}
				else if (details.navEquivalent == NavigationCode.GAMEPAD_X || details.navEquivalent == NavigationCode.GAMEPAD_B || details.navEquivalent == NavigationCode.RIGHT || details.navEquivalent == NavigationCode.TAB || details.navEquivalent == NavigationCode.GAMEPAD_R1 || details.code == 16)
				{
					followers[followersSelectionIndex][3] = false;
					handleHighlight(0);
					followersSelectionIndex = -1;
					buildFollowersSection();
				}
			} 
            else if (details.value == "keyUp")
				{
					if (details.navEquivalent == NavigationCode.GAMEPAD_A)
					{
						var time = new Date();
						time.getTime();
						if (time - buttonHeldTime >= 2000)
						{
							FollowerDisableCallback(followersSelectionIndex);
							if (followers.length > 0){
								followersSelectionIndex = 0;
							} else {
								followersSelectionIndex = -1;
							}
						}
						else
						{
							FollowerCallback(followersSelectionIndex);
						}
					}
				}

        }
    }	

	function handleHighlight(aiSelection:Number):Void
	{
		trace("Highlight: " + aiSelection);
		currentSelection = aiSelection;

		resetColor();

		shines_mc._alpha = 0;
		Tween.LinearTween(followerList.art,"_alpha",followerList.art._alpha,40,0.2);

		GameDelegate.call("HighlightMenu",[aiSelection]);
		GameDelegate.call("PlaySound",["UISkillsBackward"]);

		Tween.LinearTween(StopWaiting_Option,"_width",StopWaiting_Option._width,StopWaiting_Width,0.2);
		Tween.LinearTween(StopWaiting_Option,"_height",StopWaiting_Option._height,StopWaiting_Height,0.2);
		Tween.LinearTween(Wait_Option,"_width",Wait_Option._width,Wait_Width,0.2);
		Tween.LinearTween(Wait_Option,"_height",Wait_Option._height,Wait_Height,0.2);
		Tween.LinearTween(Teleport_Option,"_width",Teleport_Option._width,Teleport_Width,0.2);
		Tween.LinearTween(Teleport_Option,"_height",Teleport_Option._height,Teleport_Height,0.2);
		Tween.LinearTween(Inventory_Option,"_width",Inventory_Option._width,Inventory_Width,0.2);
		Tween.LinearTween(Inventory_Option,"_height",Inventory_Option._height,Inventory_Height,0.2);

		var scale:Number = 10;

		switch (aiSelection)
		{
			case -1 :
				shines_mc._alpha = 0;
				Tween.LinearTween(followerList.art,"_alpha",followerList.art._alpha,70,0.2);
				Tween.LinearTween(shines_mc,"_alpha",shines_mc._alpha,0,0.3);
				break;
			case 0 :
				shines_mc._alpha = 0;
				Tween.LinearTween(shines_mc,"_alpha",shines_mc._alpha,0,0.3);
				break;
			case 1 :
				StopWaiting_Color.setRGB(0xE3E3E3);
				StopWaiting_Option.stopwaiting_text.textColor = 0xE3E3E3;

				Tween.LinearTween(shines_mc,"_alpha",shines_mc._alpha,10,0.3);
				Tween.LinearTween(StopWaiting_Option,"_width",StopWaiting_Option._width,StopWaiting_Width + scale,0.2);
				Tween.LinearTween(StopWaiting_Option,"_height",StopWaiting_Option._height,StopWaiting_Height + scale,0.2);

				shines_mc._rotation = 135;
				break;
			case 2 :
				Wait_Color.setRGB(0xE3E3E3);
				Wait_Option.wait_text.textColor = 0xE3E3E3;

				Tween.LinearTween(shines_mc,"_alpha",shines_mc._alpha,10,0.3);
				Tween.LinearTween(Wait_Option,"_width",Wait_Option._width,Wait_Width + scale,0.2);
				Tween.LinearTween(Wait_Option,"_height",Wait_Option._height,Wait_Height + scale,0.2);

				shines_mc._rotation = 45;
				break;
			case 3 :
				Teleport_Color.setRGB(0xE3E3E3);
				Teleport_Option.teleport_text.textColor = 0xE3E3E3;

				Tween.LinearTween(shines_mc,"_alpha",shines_mc._alpha,10,0.3);
				Tween.LinearTween(Teleport_Option,"_width",Teleport_Option._width,Teleport_Width + scale,0.2);
				Tween.LinearTween(Teleport_Option,"_height",Teleport_Option._height,Teleport_Height + scale,0.2);

				shines_mc._rotation = -135;
				break;
			case 4 :
				Inventory_Color.setRGB(0xE3E3E3);
				Inventory_Option.inventory_text.textColor = 0xE3E3E3;

				Tween.LinearTween(shines_mc,"_alpha",shines_mc._alpha,10,0.3);
				Tween.LinearTween(Inventory_Option,"_width",Inventory_Option._width,Inventory_Width + scale,0.2);
				Tween.LinearTween(Inventory_Option,"_height",Inventory_Option._height,Inventory_Height + scale,0.2);

				shines_mc._rotation = -45;
				break;
		}
	}

	function handleSelection(aiSelection:Number):Void
	{
		trace("Select: " + aiSelection);
		GameDelegate.call("PlaySound",["UISkillsFocus"]);
		switch (aiSelection)
		{
			case 1 :
				skse.SendModEvent("QuickFollowerMenu","StopWaiting");
				break;
			case 2 :
				skse.SendModEvent("QuickFollowerMenu","StartWaiting");
				break;
			case 3 :
				skse.SendModEvent("QuickFollowerMenu","Teleport");
				break;
			case 4 :
				skse.SendModEvent("QuickFollowerMenu","Inventory");
				break;
		}
		doClose();
	}

	function doClose():Void
	{
		skse.SendModEvent("QuickFollowerMenu","CloseMenuNoChoice");
		var onFadeTweenComplete:Function = Delegate.create(this, function ()
		{
		skse.CloseMenu("CustomMenu");
		});
		Tween.LinearTween(this,"_alpha",this._alpha,0,0.2,onFadeTweenComplete());
	}

	function clean(str):String
	{
		if (str.charAt(str.length - 1) == ",")
		{
			str = str.substring(0, str.length - 1);
		}
		return str;
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

	function resetAll():Void
	{
		followersSymbols[0].reset();
		followersSymbols[1].reset();
		followersSymbols[2].reset();
		followersSymbols[3].reset();
		followersSymbols[4].reset();
		followersSymbols[5].reset();
		followersSymbols[6].reset();
		followersSymbols[7].reset();
		followersSymbols[8].reset();
		followersSymbols[9].reset();
		followersSymbols[10].reset();
	}

	function constructFollowerStringOld():String
	{
		var ret:String = "";
		for (var i = 0; i < followers.length; i++)
		{
			var color;
			var active = "<FONT FACE=\"$SkyrimSymbolsFont\" SIZE=\"20\">] ]</FONT>";
			followers[i][1] ? color = "0xB3B3B3" : color = "#3A3A3A";
			if (followers[i][3])
			{
				followers[i][1] ? color = "#00ff13" : color = "#ff2d00";
				active = "<FONT FACE=\"$SkyrimSymbolsFont\" SIZE=\"20\">]]6</FONT>";
			}
			ret = ret + " <FONT FACE=\"$EverywhereBoldFont\" COLOR=\"" + color + "\">" + "<A HREF=\"asfunction:_parent.FollowerCallback," + i + "\">" + followers[i][0] + "</A>" + "</FONT>" + active + "<br>";
		}
		ret = ret.substring(0, ret.length - 4);
		return ret;
	}

}