#include once "WndProc.bi"
#include once "win\windowsx.bi"
#include once "GameEvents.bi"
#include once "Nine.rh"
#include once "MainForm.bi"

Function WndProc(ByVal hWin As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
	Select Case wMsg
		Case WM_CREATE
			MainForm_Load(hWin, wParam, lParam)
			
		Case WM_COMMAND
			' События от нажатий кнопок и меню
			Select Case HiWord(wParam)
				Case BN_CLICKED, 1
					Select Case LoWord(wParam)
						Case IDM_GAME_NEW
							MainFormMenuNewGame_Click(hWin, lParam)
							
						Case IDM_GAME_NEW_NETWORK
							MainFormMenuNewNetworkGame_Click(hWin, lParam)
							
						Case IDM_GAME_NEW_AI
							MainFormMenuNewAIGame_Click(hWin, lParam)
							
						Case IDM_FILE_EXIT
							MainFormMenuFileExit_Click(hWin, lParam)
							
						Case IDM_HELP_CONTENTS
							MainFormMenuHelpContents_Click(hWin, lParam)
							
						Case IDM_HELP_ABOUT
							MainFormMenuHelpAbout_Click(hWin, lParam)
							
					End Select
			End Select
			
		Case WM_LBUTTONDOWN
			MainForm_LeftMouseDown(hWin, wParam, lParam)
			
		Case WM_KEYDOWN
			MainForm_KeyDown(hWin, wParam, lParam)
			
		Case WM_TIMER
			Select Case wParam
				Case LeftEnemyDealCardTimerId
					LeftEnemyDealCardTimer_Tick(hWin, lParam)
					
				Case PlayerDealCardTimerId
					PlayerDealCardTimer_Tick(hWin, lParam)
					
				Case RightEnemyDealCardTimerId
					RightEnemyDealCardTimer_Tick(hWin, lParam)
					
				Case BankDealCardTimerId
					BankDealCardTimer_Tick(hWin, lParam)
					
			End Select
			
		Case WM_PAINT
			MainForm_Paint(hWin, wParam, lParam)
			
		Case WM_SIZE
			MainForm_ReSize(hWin, wParam, lParam)
			
		Case WM_CLOSE
			MainForm_Close(hWin, wParam, lParam)
			
		Case WM_DESTROY
			MainForm_UnLoad(hWin, wParam, lParam)
			PostQuitMessage(0)
			
		Case PM_NEWGAME
			MainForm_NewGame(hWin, wParam, lParam)
			
		Case PM_NEWSTAGE
			MainForm_NewStage(hWin, wParam, lParam)
			
		Case PM_DEFAULTMONEY
			MainForm_DefaultMoney(hWin, wParam, lParam)
			
		Case PM_DEALMONEY
			MainForm_DealMoney(hWin, wParam, lParam)
			
		Case PM_DEALPACK
			MainForm_DealPack(hWin, wParam, lParam)
			
		Case PM_RENEMYATTACK
			MainForm_RightEnemyAttack(hWin, wParam, lParam)
			
		Case PM_USERATTACK
			MainForm_UserAttack(hWin, wParam, lParam)
			
		Case PM_LENEMYATTACK
			MainForm_LeftEnemyAttack(hWin, wParam, lParam)
			
		Case PM_FOOL
			MainForm_Fool(hWin, wParam, lParam)
			
		Case PM_WIN
			MainForm_Win(hWin, wParam, lParam)
			
		Case PM_DEALCARD
			MainForm_DealCard(hWin, wParam, lParam)
			
		Case Else
			Return DefWindowProc(hWin, wMsg, wParam, lParam)
			
	End Select
	
	Return 0
End Function
