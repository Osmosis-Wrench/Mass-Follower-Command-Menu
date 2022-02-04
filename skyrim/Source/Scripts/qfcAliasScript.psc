Scriptname qfcAliasScript extends ReferenceAlias  

message property qfcMessage auto
actor property playerRef auto
string property waitingText auto
string property stopWaitingText auto
formList property qfcList Auto

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
	endIf
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
		if follower && follower.IsPlayerTeammate()
			if command == commandWait
				WaitActor(follower)
			elseIf command == commandFollow 
				StopWaitingActor(follower)
			elseIf command == commandInventory 
				follower.OpenInventory()
				Utility.Wait(0.01)
			elseIf command == commandTeleport
				follower.MoveTo(playerRef)
			endIf
		endIf
	endWhile
	GotoState("")
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
