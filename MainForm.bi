#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "win\windowsx.bi"

' Таймер анимации хода игрока
Const RightEnemyDealCardTimerId As Integer = 1
Const PlayerDealCardTimerId As Integer = 2
Const LeftEnemyDealCardTimerId As Integer = 3
' Анимация раздачи колоды
Const BankDealCardTimerId As Integer = 4
' Анимация получения персонажем всей суммы из банка
Const BankDealMoneyTimerId As Integer = 5

Declare Sub MainForm_Load(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_UnLoad(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainFormMenuNewGame_Click(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub MainFormMenuNewNetworkGame_Click(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub MainFormMenuNewAIGame_Click(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub MainFormMenuFileExit_Click(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub MainFormMenuHelpContents_Click(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub MainFormMenuHelpAbout_Click(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub MainForm_LeftMouseDown(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_KeyDown(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_Paint(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_ReSize(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_Close(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_NewGame(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_NewStage(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_DefaultMoney(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_DealMoney(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_DealPack(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_RightEnemyAttack(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_LeftEnemyAttack(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_UserAttack(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_Fool(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_Win(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_DealCard(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub RightEnemyDealCardTimer_Tick(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub LeftEnemyDealCardTimer_Tick(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub PlayerDealCardTimer_Tick(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub BankDealCardTimer_Tick(ByVal hWin As HWND, ByVal lParam As LPARAM)

Declare Sub BankDealMoneyTimer_Tick(ByVal hWin As HWND, ByVal lParam As LPARAM)
