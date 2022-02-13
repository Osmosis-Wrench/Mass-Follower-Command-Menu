Scriptname qfcAliasScript extends ReferenceAlias  

message property qfcMessage auto
actor property playerRef auto
string property waitingText auto
string property stopWaitingText auto
formList property qfcList Auto
formlist property qfcDisabledList auto
faction property PetFramework_PetFollowingFaction auto

int hotkey
int commandFollow
int commandWait
int commandInventory
int commandCommand
int commandTeleport
int commandDismiss

event OnPlayerLoadGame()
	SetUp()
endEvent

event OnInit()
	SetUp()
endEvent

function SetUp()
	UnregisterForAllKeys()
	string fileName = "../../../Quick Follower Commands.json"
	hotkey = JsonUtil.GetIntValue(fileName, "dxcode", -1)
	if hotkey < 0
		return
	endIf
	RegisterForKey(hotkey)
	RegisterForModEvent("QuickFollowerMenu", "MenuEvent")
	RegisterForModEvent("QuickFollowerMenu_Toggle", "ToggleEvent")

	commandWait = 0
	commandFollow = 1
	commandInventory = 2
	commandTeleport = 3
endFunction

state busy
	event OnKeyDown(int keyCode)
	endEvent

	function showMenu()
	endFunction
endState

event OnKeyDown(int keyCode)
	if keyCode == hotkey && !Utility.IsInMenuMode() && !UI.IsMenuOpen("Crafting Menu") && !UI.IsMenuOpen("RaceSex Menu") && !UI.IsMenuOpen("CustomMenu")
		showMenu()
	endIf
endEvent

function showMenu()
	GotoState("busy")
	ui.OpenCustomMenu("mfc_menu")
	Game.SetHudCartMode(true)
	int i = checkAndSendInfo()
	UICallback.Send(i)
	while(Utility.IsInMenuMode())
		Utility.Wait(0.1)
	endWhile
	GotoState("")
endFunction

int function checkAndSendInfo()
	qfcCrosshairList.Revert()
	qfcCrosshairList.AddForm(Game.GetCurrentCrosshairRef())
	int i = UICallback.create("CustomMenu", "_root.QuickFollowerMenu_mc.getFollowersFromString")
	UiCallback.PushString(i, getFollowerString(qfcList)) ;as2 doesn't support named arguements, so we have to send all three always.
	UiCallback.PushString(i, getFollowerString(qfcDisabledList))
	return i
endFunction

string function getFollowerString(formlist f)
	string ret = ""
	Form[] arr = f.ToArray()
	int n = arr.Length
	while n
		n -= 1
		Actor follower = arr[n] as Actor
		if IsFollower(follower)
			ret += follower.GetDisplayName()+","+follower.getFormID()+","
		else
			f.RemoveAddedForm(follower)
		endIf
	endWhile
	return ret
endfunction

Event ToggleEvent(string eventName, string strArg, float numArg, Form sender)
	if numArg == 0
		qfcDisabledList.AddForm(sender)
	else
		qfcDisabledList.RemoveAddedForm(sender)
	endif
endEvent

Event MenuEvent(string eventName, string strArg, float numArg, Form sender)
	if strArg == "StopWaiting"
		doCommand(commandFollow)
	elseif strArg == "StartWaiting"
		doCommand(commandWait)
	elseif strArg == "Teleport"
		doCommand(commandTeleport)
	elseif strArg == "Inventory"
		doCommand(commandInventory)
	endif
endEvent

Function doCommand(int command)
	Game.SetHudCartMode(false)
	int n = qfcList.GetSize()
	while n
		n -= 1
		Actor follower = qfcList.GetAt(n) as Actor
		if IsFollower(follower) && !qfcDisabledList.HasForm(follower)
			doFollower(command, follower)
		endIf
	endWhile
endFunction

function doFollower(int command, Actor follower)
	if command == commandWait
		WaitActor(follower)
	elseIf command == commandFollow 
		StopWaitingActor(follower)
	elseIf command == commandInventory 
		OpenInventoryActor(follower)
	elseIf command == commandTeleport
		follower.MoveTo(playerRef)
	endIf
endFunction

function OpenInventoryActor(actor akActor)
	while Utility.IsInMenuMode()
		Utility.Wait(0.5)
	endWhile
	akActor.OpenInventory(true)
endFunction

function StopWaitingActor(actor akActor)
	if akActor.GetActorValue("WaitingForPlayer")
		akActor.SetActorValue("WaitingForPlayer", 0)
		akActor.EvaluatePackage()
		Debug.Notification(akActor.GetDisplayName() + stopWaitingText)
	endIf
endFunction

function WaitActor(actor akActor)
	if !akActor.GetActorValue("WaitingForPlayer")
		akActor.SetActorValue("WaitingForPlayer", 1)
		akActor.EvaluatePackage()
		Debug.Notification(akActor.GetDisplayName() + waitingText)
	endIf
endFunction

bool function IsFollower(actor akActor)
	return akActor && (akActor.IsPlayerTeammate() || akActor.GetFactionRank(PetFramework_PetFollowingFaction) >= 1)
endFunction