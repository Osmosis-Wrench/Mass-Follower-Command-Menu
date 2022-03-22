Scriptname qfcMCMScript extends ski_configbase

FormList property qfcList Auto
FormList property qfcDisabledList auto
FormList property qfcBlockList auto
ReferenceAlias property qfcAlias auto
string fileName

event onConfigInit()
    fileName = "../../../Quick Follower Commands.json"
endEvent

event OnPageReset(String Page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("Swiftly Order Squad")
    AddKeymapOptionST("dxcode", "$qfc_Showmenuhotkey", JsonUtil.GetIntValue(fileName, "dxcode", -1))
    AddKeymapOptionST("qfc_stopWaiting", "$qfc_Stopwaitinghotkey", JsonUtil.GetIntValue(fileName, "qfc_stopWaiting", -1))
    AddKeymapOptionST("qfc_startWaiting", "$qfc_Startwaitinghotkey", JsonUtil.GetIntValue(fileName, "qfc_startWaiting", -1))
    AddKeymapOptionST("qfc_inventory", "$qfc_Showinventoryhotkey", JsonUtil.GetIntValue(fileName, "qfc_inventory", -1))
    AddKeymapOptionST("qfc_teleport", "$qfc_Teleporthotkey", JsonUtil.GetIntValue(fileName, "qfc_teleport", -1))
    SetCursorPosition(1)
    AddHeaderOption("Hide Follower:")

    Form[] arr = qfcList.ToArray()
    int n = arr.Length
    while n
        n -= 1
        actor follower = arr[n] as Actor
        AddToggleOptionST("qfc___" + follower.getFormID(), follower.GetDisplayName(), false)
    endwhile

    arr = qfcBlockList.ToArray()
    n = arr.Length
    while n
        n -= 1
        actor follower = arr[n] as Actor
        AddToggleOptionST("qfc___" + follower.getFormID(), follower.GetDisplayName(), true)
    endwhile
endEvent

event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
    JsonUtil.SetIntValue(fileName, GetState(), keyCode)
    JsonUtil.Save(fileName)
    (qfcAlias as qfcAliasScript).hotkeyRebind()
    SetKeyMapOptionValueST(keyCode)
endEvent

event OnSelectST()
    string[] stateNameFull = StringUtil.Split(GetState(), "___")
    if (stateNameFull.Length > 1)
        int formid = stateNameFull[1] as int
        form foundForm = getFormByInt(qfcList, formid)
        if (foundForm != none)
            qfcList.RemoveAddedForm(foundForm)
            qfcDisabledList.RemoveAddedForm(foundForm)
            qfcBlockList.AddForm(foundForm)
            SetToggleOptionValueST(true, false, GetState())
        else
            foundForm = getFormByInt(qfcBlockList, formid)
            if (foundForm != none)
                qfcBlockList.RemoveAddedForm(foundForm)
                qfcList.AddForm(foundForm)
                SetToggleOptionValueST(false, false, GetState())
            else
                ConsoleUtil.PrintMessage("qfc: toggled follower was not in follower lists")
            endif
        endif
    endif
endEvent

event OnHighLightST()
    string check = StringUtil.SubString(GetState(),0,6)
    if (check == "qfc___")
        SetInfoText("$qfc_followerHideInfo")
    endif
endEvent

form function getFormByInt(formlist f, int i)
    Form[] arr = f.ToArray()
    int n = arr.Length
    while n
        n -= 1
        form follower = arr[n] as form
        if (follower.GetFormID() == i)
            return follower
        endif
    endwhile
    return none
endfunction