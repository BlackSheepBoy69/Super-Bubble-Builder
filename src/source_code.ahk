;@Jan 2026, BlackSheepBoy69. AHK 1.1.37.02 32-bit. Windows XP or higher

SetWorkingDir, %A_ScriptDir%	 ;Without this, drag and drop may cause vpk build error



Gui, Main:Add, Text,, --------OPTIONAL---------`n380 x 158 startup.png`n840 x 500 bg.png`n---REQUIREMENTS---`n128 x 128 icon0.png`n------------------------------------`nTITLE, 50 characters or less.`nex: Super Mario 64
Gui, Main:Add, Edit, R2 W375 vEdit1, Edit 1
Gui, Main:Add, Text,, TITLEID, 9 capital letters or numbers.`nexample: DAEDMAR64
Gui, Main:Add, Edit, R2 W375 vEdit2, Edit 2
Gui, Main:Add, Text,, ROM FULL PATH, No backslash, no quotes, no tab, no new lines.`nex: ux0:data/DaedalusX64/Roms/Super Mario 64.z64`nex: ux0:data/dsvita/Pokemon Mystery Dungeon - Blue Rescue Team (USA).nds`nex: ux0:data/RetroFlow/ROMS/Sega - Dreamcast/Crazy Taxi 2 (USA).cue
if A_Args.Length() > 0
	Edit3Text := "ux0:" . StrReplace(SubStr(A_Args[1], 4), "\", "/")
else
	Edit3Text := "Edit 3"
Gui, Main:Add, Edit, R2 W375 vEdit3, %Edit3Text%	 ; Edit 3
Gui, Main:Add, Tab3,, Nintendo 64|RetroArch|Nintendo DS|Dreamcast
Gui, Main:Add, Button, gBuild_N64_bubble, build N64 bubble
Gui, Main:Tab, 2
Gui, Main:Add, Text,, RETROARCH CORE, must start with "app0:" and end with "_libretro.self"`nex: app0:snes9x2005_libretro.self
Gui, Main:Add, Edit, R2 W350 vEdit4, Edit 4
Gui, Main:Add, Button, gBuild_RA_bubble, Build RetroArch bubble (req v1.8.9 or higher)
Gui, Main:Tab, 3
Gui, Main:Add, Button, gBuild_NDS_bubble, build Nintendo DS bubble
Gui, Main:Tab, 4
Gui, Main:Add, Button, gBuild_DC_bubble, build Dreamcast bubble
Gui, Main:Tab  ; Future controls are not part of any tab control.
Gui, Main:Add, Picture, x882 Y2 W28 H28, assets/icon0.png
If FileExist("assets/bg.png") && FileExist("assets/startup.png") {
	Gui, Main:Add, Picture, x460 Y44, assets/bg.png
	Gui, Main:Add, Picture, x740 Y183, assets/startup.png
}
else
	Gui, Main:Add, Picture, x832 Y197 W96 H96, assets/icon0.png
Gui, Main:Show, W1350 H544
WinSetTitle, %A_ScriptName%,, Super Bubble Builder window 1
WinGetPos, mainX, mainY,,, Super Bubble Builder window 1



Gui, Secondary:New
Gui, Secondary:+E0x20 +LastFound +AlwaysOnTop
WinSet, TransColor, F0F0F0       ;make color transparent
If FileExist("assets/bg.png") && FileExist("assets/startup.png")
	Gui, Secondary:Add, Picture, x0 Y0, assets/sbb_background_advanced.png
Else
	Gui, Secondary:Add, Picture, x0 Y0, assets/sbb_background_basic.png
Gui, Secondary:Show, W1350 H544	 ; needs noactivate?
WinSetTitle, %A_ScriptName%,, Super Bubble Builder window 2



SetTimer, CheckWindowMove, 100
Return


Build_N64_bubble:
Gosub, Pre_Check
; FileAppend, os.uri("psgm:play?titleid=DEDALOX64&param=%Edit3%")`nos.exit()`n, main.lua
FileAppend, System.executeUri("psgm:play?titleid=DEDALOX64&param=%Edit3%")`nSystem.exit()`n, index.lua
Goto, Messagebox_Zone
Return

Build_RA_bubble:
Gosub, Pre_Check
;FileAppend, os.uri("psgm:play?titleid=RETROVITA&param=%Edit4%&param=%Edit3%")`nos.exit()`n, main.lua
FileAppend, System.executeUri("psgm:play?titleid=RETROVITA&param=%Edit4%&param=%Edit3%")`nSystem.exit()`n, index.lua
Goto, Messagebox_Zone
Return

Build_NDS_bubble:
Gosub, Pre_Check
;FileAppend, os.uri("psgm:play?titleid=DSVITA000&param=%Edit3%")`nos.exit()`n, main.lua
FileAppend, System.executeUri("psgm:play?titleid=DSVITA000&param=%Edit3%")`nSystem.exit()`n, index.lua
Goto, Messagebox_Zone
Return

Build_DC_bubble:
Gosub, Pre_Check
;FileAppend, os.uri("psgm:play?titleid=FLYCASTDC&param=%Edit3%")`nos.exit()`n, main.lua
FileAppend, System.executeUri("psgm:play?titleid=FLYCASTDC&param=%Edit3%")`nSystem.exit()`n, index.lua
Goto, Messagebox_Zone
Return


Pre_Check:
Gui, Main:Submit, NoHide
FileDelete, index.lua
FileDelete, param.sfo
Return


Messagebox_Zone:
If StrLen(Edit2) > 9
    msgbox, 262192, %A_ScriptName%, TITLEID too long
Else if StrLen(Edit2) < 9
    msgbox, 262192, %A_ScriptName%, TITLEID too short
Else if !(Edit2 ~= "^[A-Z0-9]+$")
    msgbox, 262192, %A_ScriptName%, TITLEID must be numbers and capital letters only
Else if !FileExist("eboot.bin")
    msgbox, 262192, %A_ScriptName%, Missing %A_ScriptDir%/eboot.bin`n`nReinstalling Super Bubble Builder will fix this issue.
Else if !FileExist("assets/icon0.png")
    msgbox, 262192, %A_ScriptName%, missing %A_ScriptDir%/assets/icon0.png
Else
    Goto, Run_Exe
Return

Run_Exe:
If FileExist("assets/bg.png") && FileExist("assets/startup.png") {
    msgbox, 262148, %A_ScriptName%, These commands will be run:`n`nvita-mksfoex -s TITLE_ID=%Edit2% "%Edit1%" param.sfo`n`nvita-pack-vpk -s param.sfo -b eboot.bin "%Edit1%.vpk" -a assets/icon0.png=sce_sys/icon0.png -a assets/bg.png=sce_sys/livearea/contents/bg.png -a assets/startup.png=sce_sys/livearea/contents/startup.png -a assets/template.xml=sce_sys/livearea/contents/template.xml -a index.lua=index.lua
    IfMsgBox Yes
    {
	RunWait, vita-mksfoex -s TITLE_ID=%Edit2% "%Edit1%" param.sfo
	RunWait, vita-pack-vpk -s param.sfo -b eboot.bin "%Edit1%.vpk" -a assets/icon0.png=sce_sys/icon0.png -a assets/bg.png=sce_sys/livearea/contents/bg.png -a assets/startup.png=sce_sys/livearea/contents/startup.png -a assets/template.xml=sce_sys/livearea/contents/template.xml -a index.lua=index.lua
	msgbox, 262144, %A_ScriptName%, done
    }
} Else {
    msgbox, 262148, %A_ScriptName%, Missing either %A_ScriptDir%\assets\bg.png (this is fine) or missing %A_ScriptDir%\assets\startup.png (this is fine). These commands will be run:`n`nvita-mksfoex -s TITLE_ID=%Edit2% "%Edit1%" param.sfo`n`nvita-pack-vpk -s param.sfo -b eboot.bin "%Edit1%.vpk" -a assets/icon0.png=sce_sys/icon0.png -a index.lua=index.lua
    IfMsgBox Yes
    {
	RunWait, vita-mksfoex -s TITLE_ID=%Edit2% "%Edit1%" param.sfo
	RunWait, vita-pack-vpk -s param.sfo -b eboot.bin "%Edit1%.vpk" -a assets/icon0.png=sce_sys/icon0.png -a index.lua=index.lua
	msgbox, 262144, %A_ScriptName%, done
    }
}
FileDelete, param.sfo
FileDelete, index.lua
Return



CheckWindowMove:
	oldX := mainX
	oldy := mainY
	WinGetPos, mainX, mainY,,, Super Bubble Builder window 1
	if (newMainX != mainX || newMainY != mainY)
		WinMove, Super Bubble Builder window 2,, mainX, mainY

;	If !(WinActive("Super Bubble Builder window 1") || WinActive("Super Bubble Builder window 2"))	 ; If neither are active
;		WinMinimize, Super Bubble Builder window 2
;	WinGet, MinMax2, MinMax, Super Bubble Builder window 2
;	If (WinActive("Super Bubble Builder window 1") && !MinMax2 = -1)
;		WinActivate, Super Bubble Builder window 2
	SetTimer, CheckWindowMove, 100
Return

MainGuiClose:
;SecondaryGuiClose:
;GuiClose:
ExitApp
