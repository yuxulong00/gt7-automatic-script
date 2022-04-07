[General]
SyntaxVersion=2
BeginHotkey=120
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=f60e535b-8551-482b-8e01-d1f2ab491e3f
Description=PS5_GT7_PA_图像识别
Enable=1
AutoRun=0
[Repeat]
Type=1
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
// ========== Settings ==========
Dim QMScriptFolder
QMScriptFolder = "C:\Program Files (x86)\按键精灵\按键精灵2014"

Dim sDelay, nDelay, lDelay, uDelay // 设定常用Delay变量

sDelay = 100 // shortDelay，用于快速切换按键延迟
nDelay = 1000 // normalDelay，用于有一些动画效果的切换延迟
lDelay = 3000 // longDelay，用于有略微加载的延迟
uDelay = 10000// ulterDelay，用于读图等超大延迟

// ========== Global Variable ==========
Dim arrowX, arrowY // 箭头x,y坐标
Dim continueX, continueY // 继续x,y坐标
Dim bmbX, bmbY // BlueMoonBay坐标
Dim dtnX, dtnY // Daytona坐标
Dim rankX, rankY// Rank坐标

// ========== Main ==========
Call main()
EndScript

// ========== Functions ==========
// 主方法
Function main()
	Call gotoPanAm() // 泛美
	Delay uDelay // 读图进第一场
	Call race1() // 进入第一场
	Delay lDelay // 读图开跑
	Call racing() // 跑路中
	Delay nDelay // 跑完，稍微延迟下
	Call settlement() // 结算
	Delay lDelay // 读图进第二场
	Call race2() // 进入并离开第二场
	EndScript // 先停了再说
End Function

// 查找并进入泛美锦标赛
Function gotoPanAm()
	Dim loopTimes
	loopTimes = 0
	Do
		Call getArrowPosition()
		Call getBmbPosition()
		If checkArrowPosition(100, 70, 800, 100) Then // 在上方菜单栏
			KeyPress "Down", 1
		ElseIf checkArrowPosition(490, 500, 1450, 540) Then // 在洲际选择
			KeyPress "Down", 1
		ElseIf checkArrowPosition(235, 950, 700, 990) Then // 在锦标赛选择左侧
			KeyPress "Right", 1
		ElseIf checkArrowPosition(1175, 950, 1710, 990) Then // 在锦标赛选择右侧
			KeyPress "Left", 1
		ElseIf checkArrowPosition(925, 950, 955, 990) Then // 在泛美上
			KeyPress "Enter", 1
		ElseIf checkArrowPosition(960, 930, 1340, 970) Then// 在泛美详情页，但是不在进入按钮上
			KeyPress "Left", 1
		ElseIf checkArrowPosition(610, 930, 635, 970) Then // 在泛美详情页，并且在进入按钮上
			KeyPress "Enter", 1
		ElseIf checkBmbPosition(915, 450, 1000, 530) Then// 进入了第一站
			Exit Do
		End If
		Delay sDelay
		loopTimes = loopTimes + 1
	Loop
End Function

// 进入第一场并开始
Function race1()
	Dim loopTimes
	loopTimes = 0
	Do
		Call getBmbPosition()
		Call getArrowPosition()
		Call getRankPosition()
		If checkBmbPosition(915, 450, 1000, 530) Then // 第一站，继续
			KeyPress "Enter", 1
		ElseIf checkArrowPosition(595, 925, 920, 960) Then // 开始
			KeyPress "Enter", 1
			Exit Do
		ElseIf checkRankPosition(200, 100, 240, 130) Then // 已经开始了，立即前往racing
			Exit Do
		Else 
			TracePrint "race1: 无法识别图像"
		End If
		Delay sDelay
		loopTimes = loopTimes + 1
	Loop
End Function

// 开跑
Function racing()
	Dim loopTimes
	loopTimes = 0
	Dim nonRankTimes // 没找到Rank的次数
	nonRankTimes = 0
	Dim lastNonRankLoopTimes // 上次没找到Rank的Loop次数
	lastNonRankLoopTimes = 0
	Dim isGas
	isGas = False
	Do
		If isGas = True Then 
			KeyPress "Right", 1
		End If
		Call getRankPosition()
		If checkRankPosition(200, 100, 240, 130) Then // 找到Rank
			If isGas = False Then 
				TracePrint "Race Start"
				KeyDown "Up", 1
				isGas = True				
			End If
		Else // 没有找到Rank 
			If isGas = True Then 
				If nonRankTimes >= 10 Then // 连续大于n次
					If loopTimes >= 1100 Then // Loop次数大于1100（约4分多钟），结束比赛（待优化）
						TracePrint "Finish"
						KeyUp "Up", 1
						isGas = False
						Exit Do
					Else 
						nonRankTimes = 0
					End If
				Else // 没有连续大于n次，判断是否要累加或清零
					If loopTimes = lastNonRankLoopTimes + 1 Then 
						nonRankTimes = nonRankTimes + 1
					Else 
					    nonRankTimes = 0
					End If
					lastNonRankLoopTimes = loopTimes
				End If
			Else 
				TracePrint "racing: 无法识别图像"
			End If
		End If
		Delay sDelay
		loopTimes = loopTimes + 1
	Loop
End Function

// 结算
Function settlement()
	Dim loopTimes
	loopTimes = 0
	Dim enterFlag
	enterFlag = False
	Do
		Call getArrowPosition()
		Call getDtnPosition()
		If checkArrowPosition(815, 955, 850, 995) Then // 按右选择下一站
			KeyPress "Right", 1
		ElseIf checkArrowPosition(820, 845, 845, 885) Then // 按ESC取消回放选单（待优化）
			KeyPress "Esc", 1
		ElseIf checkArrowPosition(1100, 955, 1125, 995) Then // 点击进入第二站
			KeyPress "Enter", 1
			enterFlag = True
		ElseIf checkDtnPosition(930, 450, 1050, 495) Then // 真的进第二站了
			Exit Do
		ElseIf enterFlag = False // 保护机制（待优化）
			KeyPress "Enter", 1
		Else 
			TracePrint "settlement: 无法识别图像"
		End If
		Delay nDelay
		loopTimes = loopTimes + 1
	Loop
End Function

// 进入第二场并退出比赛
Function race2()
	Dim loopTimes
	loopTimes = 0
	Do
		Call getDtnPosition()
		Call getArrowPosition()
		If checkDtnPosition(930, 450, 1050, 495) Then // 第二站，继续
			KeyPress "Enter", 1
		ElseIf checkArrowPosition(590, 925, 1185, 965) Then // 要往右
			KeyPress "Esc", 1
		ElseIf checkArrowPosition(1375, 925, 1405, 965) Then // 离开
			KeyPress "Enter", 1
		ElseIf checkArrowPosition(1105, 710, 1140, 750) Then // 确认离开
			KeyPress "Enter", 1
		ElseIf checkArrowPosition(490, 500, 520, 545) Then // 光标回到美洲了
			Exit Do
		Else 
			TracePrint "race2: 无法识别图像"
		End If
		Delay nDelay
		loopTimes = loopTimes + 1
	Loop
End Function

// ========== Tools ==========
// 取得arrow位置
Function getArrowPosition()
	FindPic 0, 0, 1920, 1080, QMScriptFolder & "\QMScript\PS5_GT7\arrow.bmp", 0.5, arrowX, arrowY
End Function

// 检查arrow是否在坐标范围内
Function checkArrowPosition(x1,y1,x2,y2)
	If x1 <= arrowX And x2 >= arrowX And y1 <= arrowY And y2 >= arrowY Then
		checkArrowPosition = True
	Else 
		checkArrowPosition = False
	End If
End Function

// 取得BlueMoonBay位置
Function getBmbPosition()
	FindPic 0, 0, 1920, 1080, QMScriptFolder & "\QMScript\PS5_GT7\blue_moon_bay.bmp", 0.5, bmbX, bmbY
End Function

// 检查BlueMoonBay是否在坐标范围内
Function checkBmbPosition(x1,y1,x2,y2)
	If x1 <= bmbX And x2 >= bmbX And y1 <= bmbY And y2 >= bmbY Then
		checkBmbPosition = True
	Else 
		checkBmbPosition = False
	End If
End Function

// 取得Daytona位置
Function getDtnPosition()
	FindPic 0, 0, 1920, 1080, QMScriptFolder & "\QMScript\PS5_GT7\daytona.bmp", 0.5, dtnX, dtnY
End Function

// 检查Daytona是否在坐标范围内
Function checkDtnPosition(x1,y1,x2,y2)
	If x1 <= dtnX And x2 >= dtnX And y1 <= dtnY And y2 >= dtnY Then
		checkDtnPosition = True
	Else 
		checkDtnPosition = False
	End If
End Function

// 取得Rank位置
Function getRankPosition()
	FindPic 0, 0, 1920, 1080, QMScriptFolder & "\QMScript\PS5_GT7\rank.bmp", 0.6, rankX, rankY
End Function

// 检查Rank是否在坐标范围内
Function checkRankPosition(x1,y1,x2,y2)
	If x1 <= rankX And x2 >= rankX And y1 <= rankY And y2 >= rankY Then
		checkRankPosition = True
	Else 
		checkRankPosition = False
	End If
End Function