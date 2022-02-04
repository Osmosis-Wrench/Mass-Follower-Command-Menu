Scriptname qfMGEFScript extends ActiveMagicEffect  

FormList Property qfcList Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	qfcList.AddForm(akTarget)
EndEvent
