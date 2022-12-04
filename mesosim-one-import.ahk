; version 1.1
; Updated on 2022-12-03
; created by Ron Bertino from Trading Dominion
; https://TradingDominion.com


#SingleInstance Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Mouse, Relative


+#m::    ; Hotkey is Shift+Windows+M
	InputBox, NumTrades, "Number of trades", "Number of trades to process?"
	if ErrorLevel  ; the cancel button was pressed
		return
	WinActivate, Import Wizard
	WinWaitActive, Import Wizard

	TradeCount := 0
	Loop, %NumTrades% {
		TradeStr := "T-" . Format("{:05}", TradeCount)
		Loop {
			LineCount := A_Index
			clipboard := ""   ; Empty the clipboard
			WinActivate, Import Wizard
			WinWaitActive, Import Wizard
			SendInput, ^c   ; copy the first line to the clipboard
			ClipWait  ; Wait for the clipboard to contain text.

			Loop, Parse, Clipboard, `n, `r    ; parse the copied text
			{
				if (A_Index = 2) {    ; parse the second line
					array := StrSplit(A_LoopField, A_Tab)
					if (array[10] = TradeStr)
						SendInput, {Down}
				}
			}
		} Until (array[10] != TradeStr)

		; Select the trade rows
		WinActivate, Import Wizard
		WinWaitActive, Import Wizard
		SendInput, {Up}
		TradeRows := LineCount - 2
		SendInput +{Up %TradeRows%}
		sleep 700

		SendInput {F5}        		; press the Link button
		WinWaitActive, Import Trade Position Details
		SendInput {Tab 2}      		; focus on the trade name
		SendInput % TradeStr   		; set the trade name
		sleep 400
		MouseClick, Left, 345, 338  ; click the OK button

		TradeCount++
	}

	; process the very last trade
	WinActivate, Import Wizard
	WinWaitActive, Import Wizard
	SendInput ^a    			; select all the rows for the very last trade
	SendInput {F5}        		; press the Link button
	sleep 300
	SendInput {Tab 2}      		; focus on the trade name
	TradeStr := "T-" . Format("{:05}", TradeCount)
	SendInput % TradeStr   		; set the trade name
	sleep 300
	MouseClick, Left, 345, 338  ; click the OK button
	sleep 500
	MouseClick, Left, 879, 558	; click the Next button

	return


; Test moving the mouse to a particular set of coordinates
+#n::    ; Hotkey is Shift+Windows+N
	MouseMove 345, 338
	return
