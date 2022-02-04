Scriptname MFC_Menu_alias extends ReferenceAlias
{Mass Follower Commands addon to add nice menu thing idk.}

Event onInit()
    onLoad()
endEvent

Event OnPlayerLoadGame()
    onLoad()
endEvent

Function onLoad()
    RegisterForKey(26)
    RegisterForModEvent("QuickFollowerMenu", "MenuEvent")
EndFunction

Event OnKeyDown(int keycode)
    if keycode == 26
        if !ui.IsMenuOpen("OpenCustomMenu")
            ui.OpenCustomMenu("mfc_menu")
        Else
            Ui.CloseCustomMenu()
        endif
    endif
endEvent

Event MenuEvent(string eventName, string strArg, float numArg, Form sender)
    if strArg == "StopWaiting"
        ConsoleUtil.PrintMessage("StopWaiting")
    elseif strArg == "StartWaiting"
        ConsoleUtil.PrintMessage("StartWaiting")
    elseif strArg == "Teleport"
        ConsoleUtil.PrintMessage("Teleport")
    elseif strArg == "Inventory"
        ConsoleUtil.PrintMessage("Inventory")
    endif
endEvent