#ifndef MAINFORM_BI
#define MAINFORM_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"
#include "win\windowsx.bi"

' Идентификаторы таймеров анимации
Const RightEnemyDealCardTimer = 1
Const PlayerDealCardTimer = 2
Const LeftEnemyDealCardTimer = 3

' Анимация раздачи колоды
Const BankDealPackTimer = 4
Const BankDealPackRightEnemyTimer = 5
Const BankDealPackPlayerTimer = 6
Const BankDealPackLeftEnemyTimer = 7
Const BankDealPackFinishTimer = 8

' Анимация получения персонажем всей суммы из банка
Const BankDealMoneyTimer = 9

' Меню

Declare Sub MainFormMenuNewGame_Click(ByVal hWin As HWND)

Declare Sub MainFormMenuNewNetworkGame_Click(ByVal hWin As HWND)

Declare Sub MainFormMenuNewAIGame_Click(ByVal hWin As HWND)

Declare Sub MainFormMenuStatistics_Click(ByVal hWin As HWND)

Declare Sub MainFormMenuFileExit_Click(ByVal hWin As HWND)

Declare Sub MainFormMenuHelpContents_Click(ByVal hWin As HWND)

Declare Sub MainFormMenuHelpAbout_Click(ByVal hWin As HWND)

' Кнопки

Declare Sub PlayerCard_Click(ByVal hWin As HWND, ByVal ButtonId As Integer, ByVal hwndButton As HWND)


' События формы

Declare Sub MainForm_Load(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)

Declare Sub MainForm_UnLoad(ByVal hWin As HWND)

Declare Sub MainForm_LeftMouseDown(ByVal hWin As HWND, ByVal KeyModifier As Integer, ByVal X As Integer, ByVal Y As Integer)

Declare Sub MainForm_KeyDown(ByVal hWin As HWND, ByVal KeyCode As Integer)

Declare Sub MainForm_Paint(ByVal hWin As HWND)

Declare Sub MainForm_Resize(ByVal hWin As HWND, ByVal ResizingRequested As Integer, ByVal ClientWidth As Integer, ByVal ClientHeight As Integer)

Declare Sub MainForm_Close(ByVal hWin As HWND)

Declare Sub MainForm_StaticControlTextColor(ByVal hWin As HWND, ByVal hwndControl As HWND, ByVal hDC As HDC)

Declare Sub MainForm_DrawItem(ByVal hWin As HWND, ByVal hwndControl As HWND, ByVal pDrawItemStruct As DRAWITEMSTRUCT Ptr)

' Игровые события

Declare Sub MainForm_NewGame(ByVal hWin As HWND)

Declare Sub MainForm_NewStage(ByVal hWin As HWND)

Declare Sub MainForm_DealMoney(ByVal hWin As HWND)

Declare Sub MainForm_BankDealPack(ByVal hWin As HWND)

Declare Sub MainForm_RightEnemyAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal AssignmentFlag As Integer)

Declare Sub MainForm_LeftEnemyAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal AssignmentFlag As Integer)

Declare Sub MainForm_UserAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal AssignmentFlag As Integer)

Declare Sub MainForm_RightEnemyFool(ByVal hWin As HWND)

Declare Sub MainForm_UserFool(ByVal hWin As HWND)

Declare Sub MainForm_LeftEnemyFool(ByVal hWin As HWND)

Declare Sub MainForm_RightEnemyWin(ByVal hWin As HWND)

Declare Sub MainForm_UserWin(ByVal hWin As HWND)

Declare Sub MainForm_LeftEnemyWin(ByVal hWin As HWND)

Declare Sub MainForm_RightEnemyDealCard(ByVal hWin As HWND, ByVal CardNumber As Integer)

Declare Sub MainForm_UserDealCard(ByVal hWin As HWND, ByVal CardNumber As Integer)

Declare Sub MainForm_LeftEnemyDealCard(ByVal hWin As HWND, ByVal CardNumber As Integer)

' Таймеры анимации

Declare Sub RightEnemyDealCardTimer_Tick(ByVal hWin As HWND)

Declare Sub LeftEnemyDealCardTimer_Tick(ByVal hWin As HWND)

Declare Sub PlayerDealCardTimer_Tick(ByVal hWin As HWND)

Declare Sub BankDealPackTimer_Tick(ByVal hWin As HWND)

Declare Sub BankDealPackRightEnemyTimer_Tick(ByVal hWin As HWND)

Declare Sub BankDealPackPlayerTimer_Tick(ByVal hWin As HWND)

Declare Sub BankDealPackLeftEnemyTimer_Tick(ByVal hWin As HWND)

Declare Sub BankDealPackFinishTimer_Tick(ByVal hWin As HWND)

Declare Sub BankDealMoneyTimer_Tick(ByVal hWin As HWND)

#endif
