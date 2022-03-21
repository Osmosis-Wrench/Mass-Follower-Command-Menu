Scriptname qfcMCMScript extends ski_configbase

formList property qfcList Auto
formlist property qfcDisabledList auto

string fileName

event onConfigInit()
    fileName = "../../../Quick Follower Commands.json"
    followHotkey = JsonUtil.GetIntValue(fileName, "qfc_follow", -1)
    waitHotkey = JsonUtil.GetIntValue(fileName, "qfc_wait", -1)
    inventoryHotkey = JsonUtil.GetIntValue(fileName, "qfc_inventory", -1)
    teleportHotkey = JsonUtil.GetIntValue(fileName, "qfc_teleport", -1)
endEvent

event OnPageReset(String Page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("Swiftly Order Squad")
    AddKeymapOptionST("dxcode", "Show menu hotkey: ", JsonUtil.GetIntValue(fileName, "dxcode", -1))
    AddKeymapOptionST("qfc_stopWaiting", "Show menu hotkey: ", JsonUtil.GetIntValue(fileName, "qfc_stopWaiting", -1))
    AddKeymapOptionST("qfc_startWaiting", "Show menu hotkey: ", JsonUtil.GetIntValue(fileName, "qfc_startWaiting", -1))
    AddKeymapOptionST("qfc_inventory", "Show menu hotkey: ", JsonUtil.GetIntValue(fileName, "qfc_inventory", -1))
    AddKeymapOptionST("qfc_teleport", "Show menu hotkey: ", JsonUtil.GetIntValue(fileName, "qfc_teleport", -1))
    SetCursorPosition(2)
    AddHeaderOption("Hide Follower:")

    Form[] arr = qfcList.ToArray()
    int n = arr.Length
    while n
        n -= 1
        follower = arr[n] as Actor
        AddToggleOptionST("qfc___" + follower.getFormID(), follower.GetDisplayName(), true)
    endwhile

    arr = qfcDisabledList.ToArray()
    n = arr.Length
    while n
        n -= 1
        follower = arr[n] as Actor
        AddToggleOptionST("qfc___" + follower.getFormID(), follower.GetDisplayName(), true)
    endwhile
endEvent

event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
    JSonUtil.SetIntValue(fileName, GetState(), keyCode)
    int rebindEvent = ModEvent.Create("QuickFollowerMenu_hotkeyRebind")
    if (rebindEvent)
         ModEvent.Send(rebindEvent)
    endif
endEvent

event OnSelectST()
    string[] stateNameFull = StringUtil.Split(GetState(), "___")
    if stateNameFull.Length > 1
        int formid = stateNameFull[1] as int
        form toggleActor = Game.GetForm(formid)
        if (qfcList.HasForm(toggleActor))
            # todo finish this part once I work out what I should be doing idk
    endif
endEvent