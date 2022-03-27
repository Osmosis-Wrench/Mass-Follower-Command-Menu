Scriptname qfMGEFScript extends ActiveMagicEffect  

FormList Property qfcList Auto
FormList Property qfcBlockList Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if (!qfcBlockList.HasForm(akTarget))
		qfcList.AddForm(akTarget)
	endif
EndEvent
