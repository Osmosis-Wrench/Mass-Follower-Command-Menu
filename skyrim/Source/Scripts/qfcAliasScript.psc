Scriptname qfcAliasScript extends ReferenceAlias  

message property qfcMessage auto
actor property playerRef auto
string property waitingText auto
string property stopWaitingText auto
formList property qfcList Auto
faction property PetFramework_PetFollowingFaction auto

form[] disabledActors
form[] ActorsCrosshair
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

	if (!disabledActors)
		disabledActors = Utility.CreateFormArray(0)
	endif
	if (!ActorsCrosshair)
		ActorsCrosshair = Utility.CreateFormArray(0)
	endif

	commandWait = 0
	commandFollow = 1
	commandInventory = 2
	commandTeleport = 3
endFunction

state busy
	event OnKeyDown(int keyCode)
	endEvent

	Function doCommand(int command)
	endFunction
endState

event OnKeyDown(int keyCode)
	if keyCode == hotkey && !Utility.IsInMenuMode() && !UI.IsMenuOpen("Crafting Menu") && !UI.IsMenuOpen("RaceSex Menu") && !UI.IsMenuOpen("CustomMenu")
		ui.OpenCustomMenu("mfc_menu")
		checkAndSendInfo()
	endIf
endEvent

function checkAndSendInfo()
	; all of these strings can probably be cached or something to speed everything up. makes way more sense to build once and not every single time, but I cant work out a way to do it :(
	Actor crosshairActor = Game.GetCurrentCrosshairRef() as Actor
	string crosshairString = ""
	if IsFollower(crosshairActor)
		ActorsCrosshair = Utility.CreateFormArray(0)
		ActorsCrosshair = PapyrusUtil.PushForm(ActorsCrosshair, crosshairActor)
		crosshairString = crosshairActor.GetDisplayName()+","+crosshairActor.getFormID()
	endif
	Debug.Trace("CrosshairString "+crosshairString) 
	

	string followerString = ""
	int n = qfcList.GetSize()
	while n
		n -= 1
		Actor follower = qfcList.GetAt(n) as Actor
		if IsFollower(follower)
			followerString += follower.GetDisplayName()+","+follower.getFormID()+","
		endIf
	endWhile
	Debug.Trace("followerString "+followerString); we strip of the trailing ',' in flash because it's faster to do it there.
	; this might be something like "Jenassa,924585,"
	
	string disabledString = ""
	n = disabledActors.length
	while n
		n -= 1
		Actor Follower = disabledActors[n] as Actor
		if IsFollower(follower)
			disabledString += follower.GetDisplayName()+","+follower.getFormID()+","
		endif
	endwhile
	Debug.Trace("disabledString "+disabledString)

	int i = UICallback.create("CustomMenu", "_root.QuickFollowerMenu_mc.getFollowersFromString")
		UiCallback.PushString(i, followerString) ;as2 doesn't support named arguements, so we have to send all three always.
		UiCallback.PushString(i, disabledString)
		UiCallback.PushString(i, crosshairString)
		UICallback.Send(i)
endFunction

Event ToggleEvent(string eventName, string strArg, float numArg, Form sender)
	;eventName = QuickFollowerMenu_Toggle
	;strArg = normal OR crosshair
	;numArg = 1 or 0
	;sender = form record for follower we are toggling
	
	if strArg == "normal"
		if numArg == 1
			disabledActors = PapyrusUtil.PushForm(disabledActors,sender)
		else
			disabledActors = PapyrusUtil.RemoveForm(disabledActors,sender)
		endif
	else
		if numArg == 1
			ActorsCrosshair = PapyrusUtil.PushForm(ActorsCrosshair,sender)
		else
			ActorsCrosshair = PapyrusUtil.RemoveForm(ActorsCrosshair,sender)
		endif
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
	GotoState("busy")
	
	int n = qfcList.GetSize()
	while n
		n -= 1
		Actor follower = qfcList.GetAt(n) as Actor
		if IsFollower(follower)
			doFollower(command, follower)
		endIf
	endWhile
	
	GotoState("")
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