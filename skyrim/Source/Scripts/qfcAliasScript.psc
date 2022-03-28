Scriptname qfcAliasScript extends ReferenceAlias  

message property qfcMessage auto
actor property playerRef auto
string property waitingText auto
string property stopWaitingText auto
FormList property qfcList Auto
FormList property qfcDisabledList auto
FormList property qfcBlockList auto
faction property PetFramework_PetFollowingFaction auto

int hotkey
int stopWaitingHotkey
int startWaitingHotkey
int inventoryHotkey
int teleportHotkey

event OnPlayerLoadGame()
	SetUp()
endEvent

event OnInit()
	SetUp()
endEvent

function SetUp()
	hotkeyRebind()
	RegisterForModEvent("QuickFollowerMenu", "MenuEvent")
	RegisterForModEvent("QuickFollowerMenu_Toggle", "ToggleEvent")
	RegisterForModEvent("QuickFollowerMenu_Delete", "RemoveEvent")
endFunction

function hotkeyRebind()
	string fileName = "../../../Quick Follower Commands.json"
	unregisterForAllKeys()

	hotkey = JsonUtil.GetIntValue(fileName, "dxcode", -1)
	stopWaitingHotkey = JsonUtil.GetIntValue(fileName, "qfc_stopWaiting", -1)
    startWaitingHotkey = JsonUtil.GetIntValue(fileName, "qfc_startWaiting", -1)
    inventoryHotkey = JsonUtil.GetIntValue(fileName, "qfc_inventory", -1)
    teleportHotkey = JsonUtil.GetIntValue(fileName, "qfc_teleport", -1)

	RegisterForKey(hotkey)
	registerforkey(stopWaitingHotkey)
    registerforkey(startWaitingHotkey)
    registerforkey(inventoryHotkey)
    registerforkey(teleportHotkey)
endfunction

state busy
	event OnKeyDown(int keyCode)
	endEvent

	function showMenu()
	endFunction
endState

event OnKeyDown(int keyCode)
	if !Utility.IsInMenuMode() && !UI.IsMenuOpen("Crafting Menu") && !UI.IsMenuOpen("RaceSex Menu") && !UI.IsMenuOpen("CustomMenu")
		if keyCode == hotkey
			showMenu()
		elseif keyCode == stopWaitingHotkey
			doCommand("StopWaiting")
		elseif keyCode == startWaitingHotkey
			doCommand("StartWaiting")
		elseif keyCode == inventoryHotkey
			doCommand("Inventory")
		elseif keyCode == teleportHotkey
			doCommand("Teleport")
		endIf
	endif
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

event RemoveEvent(string eventName, string strArg, float numArg, Form sender)
    qfcList.RemoveAddedForm(sender)
    qfcDisabledList.RemoveAddedForm(sender)
	qfcBlockList.AddForm(sender)
endEvent

Event ToggleEvent(string eventName, string strArg, float numArg, Form sender)
	if numArg == 0
		qfcDisabledList.AddForm(sender)
	else
		qfcDisabledList.RemoveAddedForm(sender)
	endif
endEvent

Event MenuEvent(string eventName, string strArg, float numArg, Form sender)
	if strArg == "CloseMenuNoChoice"
		Game.SetHudCartMode(false)
	else
		doCommand(strArg)
	endif
endEvent

Function doCommand(string command)
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

function doFollower(string command, Actor follower)
	if command == "StartWaiting"
		WaitActor(follower)
	elseIf command == "StopWaiting"
		StopWaitingActor(follower)
	elseIf command == "Inventory" 
		OpenInventoryActor(follower)
	elseIf command == "Teleport"
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