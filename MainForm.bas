#include "MainForm.bi"
#include "AboutDialogProc.bi"
#include "Cards.bi"
#include "Drawing.bi"
#include "DisplayError.bi"
#include "GdiGraphics.bi"
#include "IntegerToWString.bi"
#include "MainFormEvents.bi"
#include "NetworkParamDialogProc.bi"
#include "PlayerCard.bi"
#include "Resources.rh"
#include "ThreadProc.bi"

Const DefaultBackColor As Integer = &h006400
Const DefaultForeColor As Integer = &hFFF8F0

' Начальные сумы денег у игроков
Const DefaultMoney As Integer = 20
' Количество денег, которое кладётся в банк в начале игры
Const ZZZMoney As Integer = 2
' Количество денег, которое кладётся в банк если у игрока нет карт для хода
Const FFFMoney As Integer = 1

' Количество частей в траектории анимации карты
' Const DealCardAnimationPartsCount As Integer = 32

' Количество миллисекунд таймера
' Const DealCardTimerElapsedTime As Integer = 25
' Const DealPackTimerElapsedTime As Integer = 25

Const FramePaddingSpaceWidth As Integer = 20
Const FramePaddingSpaceHeight As Integer = 25

Enum GameModes
	Stopped
	Normal
	AI
	Online
End Enum

Type WinApiPlaingCard
	Dim Card As PlayerCard
	Dim Left As Integer
	Dim Top As Integer
	Dim HwndCard As HWND
	Dim hCardBitmap As HBITMAP
End Type

Type WinApiMoney
	Dim Money As Money
	Dim Left As Integer
	Dim Top As Integer
	Dim Width As Integer
	Dim Height As Integer
	Dim HwndMoney As HWND
End Type

Dim Shared CardBitmap(36) As HBITMAP

Dim Shared CurrencyChar As WString * 16

Dim Shared CharacterDealCardAnimationEnabled As Boolean
Dim Shared BankDealPackAnimationEndbled As Boolean

' Игра идёт
Dim Shared GameMode As GameModes

' Рисование

' Dim Shared MemoryGraphics As GdiGraphics
' Dim Shared AnimationGraphics As GdiGraphics
' Dim Shared RealGraphics As GdiGraphics

' Dim Shared BackColorBrush As HBRUSH
' Dim Shared BackColorPen As HPEN

' Колода
Dim Shared BankDeck(35) As WinApiPlaingCard

' Карты
Dim Shared PlayerDeck(11) As WinApiPlaingCard
Dim Shared LeftEnemyDeck(11) As WinApiPlaingCard
Dim Shared RightEnemyDeck(11) As WinApiPlaingCard

' Деньги
Dim Shared RightEnemyMoney As WinApiMoney
Dim Shared PlayerMoney As WinApiMoney
Dim Shared LeftEnemyMoney As WinApiMoney
Dim Shared BankMoney As WinApiMoney

' Игрок может щёлкать по своим картам
Dim Shared PlayerCanPlay As Boolean

Sub UpdateMoney(ByVal hwndControl As HWND, ByVal cm As WinApiMoney Ptr, ByVal NewValue As Integer)
	
	Dim buffer As WString * (Money.MaxCharacterNameLength * 2 + 1) = Any
	GetMoneyString(@buffer, NewValue, @cm->Money.CharacterName)
	
	cm->Money.Value = NewValue
	
	SetWindowText(hwndControl, @buffer)
	
End Sub


Sub MainFormMenuNewGame_Click(ByVal hWin As HWND)
	
	If GameMode = GameModes.Normal OrElse GameMode = GameModes.Online Then
		
		Dim WarningMsg As WString * 1024 = Any
		LoadString(GetModuleHandle(0), IDS_NEWGAMEWARNING, @WarningMsg, 1024 - 1)
		
		Dim MessageBoxTitle As WString * 1024 = Any
		LoadString(GetModuleHandle(0), IDS_WINDOWTITLE, @MessageBoxTitle, 1024 - 1)
		
		If MessageBox(hWin, @WarningMsg, @MessageBoxTitle, MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2) <> IDYES Then
			Exit Sub
		End If
		
	End If
	
	GameMode = GameModes.Normal
	PostMessage(hWin, PM_NEWGAME, 0, 0)
	
End Sub

Sub MainFormMenuNewAIGame_Click(ByVal hWin As HWND)
	
	If GameMode = GameModes.Normal OrElse GameMode = GameModes.Online Then
		
		Dim WarningMsg As WString * 1024 = Any
		LoadString(GetModuleHandle(0), IDS_NEWGAMEWARNING, @WarningMsg, 1024 - 1)
		
		Dim MessageBoxTitle As WString * 1024 = Any
		LoadString(GetModuleHandle(0), IDS_WINDOWTITLE, @MessageBoxTitle, 1024 - 1)
		
		If MessageBox(hWin, @WarningMsg, @MessageBoxTitle, MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2) <> IDYES Then
			Exit Sub
		End If
		
	End If
	
	GameMode = GameModes.AI
	PostMessage(hWin, PM_NEWGAME, 0, 0)
	
End Sub

Sub MainFormMenuNewNetworkGame_Click(ByVal hWin As HWND)
	
	' TODO Сделать сетевой режим
	If GameMode = GameModes.Normal OrElse GameMode = GameModes.Online Then
		
		Dim WarningMsg As WString * 1024 = Any
		LoadString(GetModuleHandle(0), IDS_NEWGAMEWARNING, @WarningMsg, 1024 - 1)
		
		Dim MessageBoxTitle As WString * 1024 = Any
		LoadString(GetModuleHandle(0), IDS_WINDOWTITLE, @MessageBoxTitle, 1024 - 1)
		
		If MessageBox(hWin, @WarningMsg, @MessageBoxTitle, MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2) <> IDYES Then
			Exit Sub
		End If
		
	End If
	
	If DialogBoxParam(GetModuleHandle(NULL), MAKEINTRESOURCE(IDD_DLG_NETWORK), hWin, @NetworkParamDialogProc, 0) <> IDOK Then
		Exit Sub
	End If
	
End Sub

Sub MainFormMenuFileExit_Click(ByVal hWin As HWND)
	
	DestroyWindow(hWin)
	
End Sub

Sub MainFormMenuHelpContents_Click(ByVal hWin As HWND)
	
	Dim NineWindowTitle As WString * (511 + 1) = Any
	LoadString(GetModuleHandle(0), IDS_WINDOWTITLE, @NineWindowTitle, 511)
	
	Dim HelpMessage As WString * (511 + 1) = Any
	LoadString(GetModuleHandle(0), IDS_NOTIMPLEMENTED, @HelpMessage, 511)
	
	MessageBox(hWin, @HelpMessage, @NineWindowTitle, MB_OK + MB_ICONINFORMATION)
	
End Sub

Sub MainFormMenuHelpAbout_Click(ByVal hWin As HWND)
	
	' Dim MessageBoxTitle As WString * 1024 = Any
	' LoadString(GetModuleHandle(0), IDS_WINDOWTITLE, @MessageBoxTitle, 1024 - 1)
	' ShellAbout(hWin, @MessageBoxTitle, "Девятка", LoadIcon(GetModuleHandle(0), Cast(WString Ptr, IDR_ICON)))
	
	DialogBoxParam(GetModuleHandle(NULL), MAKEINTRESOURCE(IDD_DLG_ABOUT), hWin, @AboutDialogProc, 0)
	
End Sub


Sub MainForm_Load(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)
	
	' Ники игроков
	LoadString(GetModuleHandle(0), IDS_RIGHTENEMYNICK, @RightEnemyMoney.Money.CharacterName, Money.MaxCharacterNameLength)
	LoadString(GetModuleHandle(0), IDS_USERNICK, @PlayerMoney.Money.CharacterName, Money.MaxCharacterNameLength)
	LoadString(GetModuleHandle(0), IDS_LEFTENEMYNICK, @LeftEnemyMoney.Money.CharacterName, Money.MaxCharacterNameLength)
	LoadString(GetModuleHandle(0), IDS_BANKNICK, @BankMoney.Money.CharacterName, Money.MaxCharacterNameLength)
	
	LoadString(GetModuleHandle(0), IDS_CURRENCYCHAR, @CurrencyChar, 8)
	
	' Инициализация случайных чисел
	Dim dtNow As SYSTEMTIME = Any
	GetSystemTime(@dtNow)
	srand(dtNow.wMilliseconds - dtNow.wSecond + dtNow.wMinute + dtNow.wHour)
	
	' Инициализация библиотеки
	cdtInit(@DefautlCardWidth, @DefautlCardHeight)
	
	' BackColorBrush = CreateSolidBrush(DefaultBackColor)
	' BackColorPen = CreatePen(PS_SOLID, 1, DefaultBackColor)
	
	' Dim hDefaultFont As HFONT = GetStockObject(DEFAULT_GUI_FONT)
	
	' Scope
		' Dim oFont As LOGFONT = Any
		' GetObject(hDefaultFont, SizeOf(LOGFONT), @oFont)
		' oFont.lfHeight *= 4
		' DefaultFont = CreateFontIndirect(@oFont)
	' End Scope
	
	' InitializeGraphics(@AnimationGraphics, hWin, BackColorPen, BackColorBrush, hDefaultFont)
	' InitializeGraphics(@MemoryGraphics, hWin, BackColorPen, BackColorBrush, hDefaultFont)
	' InitializeGraphics(@RealGraphics, hWin, BackColorPen, BackColorBrush, hDefaultFont)
	
	Dim hDCWin As HDC = GetDC(hWin)
	Dim hDCmem As HDC = CreateCompatibleDC(hDCWin)
	
	For i As Integer = 0 To 35
		
		CardBitmap(i) = CreateCompatibleBitmap(hDCWin, DefautlCardWidth, DefautlCardHeight)
		
		Dim hOldBitmap As HBITMAP = SelectObject(hDCmem, CardBitmap(i))
		
		cdtDrawExt(hDCMem, 0, 0, DefautlCardWidth, DefautlCardHeight, GetCardNumber(i), CardViews.Normal, 0)
		
		SelectObject(hDCmem, hOldBitmap)
		
	Next
	
	Scope
		CardBitmap(36) = CreateCompatibleBitmap(hDCWin, DefautlCardWidth, DefautlCardHeight)
		
		Dim hOldBitmap As HBITMAP = SelectObject(hDCmem, CardBitmap(36))
		
		cdtDrawExt(hDCMem, 0, 0, DefautlCardWidth, DefautlCardHeight, Backs.Sky, CardViews.Back, 0)
		
		SelectObject(hDCmem, hOldBitmap)
	End Scope
	
	DeleteDC(hDCmem)
	ReleaseDC(hWin, hDCWin)
	
	Scope
		RightEnemyMoney.Width = DefautlCardWidth + FramePaddingSpaceWidth * 2
		RightEnemyMoney.Height = DefautlCardHeight * 4 + FramePaddingSpaceHeight * 2
		
		RightEnemyMoney.HwndMoney = CreateWindow( _
			"BUTTON", @RightEnemyMoney.Money.CharacterName, _
			WS_TABSTOP Or WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX, _
			0, 0, RightEnemyMoney.Width, RightEnemyMoney.Height, _
			hWin, NULL, NULL, NULL _
		)
	End Scope
	
	Scope
		PlayerMoney.Width = DefautlCardWidth * 12 + FramePaddingSpaceWidth * 2
		PlayerMoney.Height = DefautlCardHeight + FramePaddingSpaceHeight * 2
		
		PlayerMoney.HwndMoney = CreateWindow( _
			"BUTTON", @PlayerMoney.Money.CharacterName, _
			WS_TABSTOP Or WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX, _
			0, 0, PlayerMoney.Width, PlayerMoney.Height, _
			hWin, NULL, NULL, NULL _
		)
	End Scope
	
	Scope
		LeftEnemyMoney.Width = DefautlCardWidth + FramePaddingSpaceWidth * 2
		LeftEnemyMoney.Height = DefautlCardHeight * 4 + FramePaddingSpaceHeight * 2
		
		LeftEnemyMoney.HwndMoney = CreateWindow( _
			"BUTTON", @LeftEnemyMoney.Money.CharacterName, _
			WS_TABSTOP Or WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX, _
			0, 0, LeftEnemyMoney.Width, LeftEnemyMoney.Height, _
			hWin, NULL, NULL, NULL _
		)
	End Scope
	
	Scope
		BankMoney.Width = DefautlCardWidth * 9 + FramePaddingSpaceWidth * 2
		BankMoney.Height = DefautlCardHeight * 4 + FramePaddingSpaceHeight * 2
		
		BankMoney.HwndMoney = CreateWindow( _
			"BUTTON", @BankMoney.Money.CharacterName, _
			WS_TABSTOP Or WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX, _
			0, 0, BankMoney.Width, BankMoney.Height, _
			hWin, NULL, NULL, NULL _
		)
	End Scope
	
	For i As Integer = 0 To 35
		
		BankDeck(i).Card.IsUsed = True
		BankDeck(i).Card.CardNumber = GetCardNumber(i)
		BankDeck(i).Card.CardSortNumber = i
		
		BankDeck(i).HwndCard = CreateWindow( _
			"BUTTON", "Девятка", _
			WS_TABSTOP Or WS_CHILD Or WS_VISIBLE Or BS_BITMAP Or BS_PUSHBUTTON, _
			FramePaddingSpaceWidth + DefautlCardWidth * (i Mod 9), _
			FramePaddingSpaceHeight + DefautlCardHeight * (i \ 9), _
			DefautlCardWidth, DefautlCardHeight, _
			BankMoney.HwndMoney, Cast(HMENU, IDC_PLAING_CARD_01), NULL, NULL _
		)
		
		SendMessage(BankDeck(i).HwndCard, BM_SETIMAGE, IMAGE_BITMAP, Cast(LPARAM, CardBitmap(i)))
		
	Next
	
End Sub

Sub MainForm_UnLoad(ByVal hWin As HWND)
	
	' UnInitializeGraphics(@RealGraphics)
	' UnInitializeGraphics(@MemoryGraphics)
	' UnInitializeGraphics(@AnimationGraphics)
	
	' DeleteObject(DefaultFont)
	' DeleteObject(BackColorPen)
	' DeleteObject(BackColorBrush)
	
	cdtTerm()
	
End Sub

Sub Button_Click(ByVal hWin As HWND, ByVal ButtonId As Integer, ByVal hwndButton As HWND)
	' MessageBox(hWin, "IDC_PLAING_CARD_01", "IDC_PLAING_CARD_01", MB_OK)
End Sub

Sub MainForm_LeftMouseDown(ByVal hWin As HWND, ByVal KeyModifier As Integer, ByVal X As Integer, ByVal Y As Integer)
	
End Sub

Sub MainForm_KeyDown(ByVal hWin As HWND, ByVal KeyCode As Integer)
	
End Sub

Sub MainForm_Paint(ByVal hWin As HWND)
	
End Sub

Sub MainForm_Resize(ByVal hWin As HWND, ByVal ResizingRequested As Integer, ByVal ClientWidth As Integer, ByVal ClientHeight As Integer)
	
	Dim cx As Integer = ClientWidth \ 2
	Dim cy As Integer = ClientHeight \ 2
	
	Scope
		BankMoney.Left = cx - BankMoney.Width \ 2
		BankMoney.Top = FramePaddingSpaceHeight
		MoveWindow(BankMoney.HwndMoney, BankMoney.Left, BankMoney.Top, BankMoney.Width, BankMoney.Height, 0)
	End Scope
	
	Scope
		RightEnemyMoney.Left = cx + FramePaddingSpaceWidth * 2 + BankMoney.Width \ 2
		RightEnemyMoney.Top = FramePaddingSpaceHeight
		MoveWindow(RightEnemyMoney.HwndMoney, RightEnemyMoney.Left, RightEnemyMoney.Top, RightEnemyMoney.Width, RightEnemyMoney.Height, 0)
	End Scope
	
	Scope
		LeftEnemyMoney.Left = cx - FramePaddingSpaceWidth * 2 - LeftEnemyMoney.Width - BankMoney.Width \ 2
		LeftEnemyMoney.Top = FramePaddingSpaceHeight
		MoveWindow(LeftEnemyMoney.HwndMoney, LeftEnemyMoney.Left, LeftEnemyMoney.Top, LeftEnemyMoney.Width, LeftEnemyMoney.Height, 0)
	End Scope
	
	Scope
		PlayerMoney.Left = cx - PlayerMoney.Width \ 2
		PlayerMoney.Top = BankMoney.Top + BankMoney.Height + FramePaddingSpaceHeight
		MoveWindow(PlayerMoney.HwndMoney, PlayerMoney.Left, PlayerMoney.Top, PlayerMoney.Width, PlayerMoney.Height, 0)
	End Scope
	
	UpdateMoney(RightEnemyMoney.HwndMoney, @RightEnemyMoney, RightEnemyMoney.Money.Value)
	UpdateMoney(PlayerMoney.HwndMoney, @PlayerMoney, PlayerMoney.Money.Value)
	UpdateMoney(LeftEnemyMoney.HwndMoney, @LeftEnemyMoney, PlayerMoney.Money.Value)
	UpdateMoney(BankMoney.HwndMoney, @BankMoney, BankMoney.Money.Value)
	
End Sub

Sub MainForm_Close(ByVal hWin As HWND)
	
	DestroyWindow(hWin)
	
End Sub

Sub MainForm_StaticControlTextColor(ByVal hWin As HWND, ByVal hwndControl As HWND, ByVal hDC As HDC)
	
	SetTextColor(hDC, DefaultForeColor)
	SetBkColor(hDC, DefaultBackColor)
	
End Sub


Sub MainForm_NewGame(ByVal hWin As HWND)
	
End Sub

Sub MainForm_NewStage(ByVal hWin As HWND)
	
End Sub

Sub MainForm_DealMoney(ByVal hWin As HWND)
	
End Sub

Sub MainForm_BankDealPack(ByVal hWin As HWND)
	
End Sub


Sub MainForm_RightEnemyAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal IsUsed As Integer)
	
End Sub

Sub MainForm_UserAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal IsUsed As Integer)
	
End Sub

Sub MainForm_LeftEnemyAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal IsUsed As Integer)
	
End Sub


Sub MainForm_RightEnemyFool(ByVal hWin As HWND)
	
End Sub

Sub MainForm_UserFool(ByVal hWin As HWND)
	
End Sub

Sub MainForm_LeftEnemyFool(ByVal hWin As HWND)
	
End Sub


Sub MainForm_RightEnemyWin(ByVal hWin As HWND)
	
End Sub

Sub MainForm_UserWin(ByVal hWin As HWND)
	
End Sub

Sub MainForm_LeftEnemyWin(ByVal hWin As HWND)
	
End Sub


Sub RightEnemyDealCardTimer_Tick(ByVal hWin As HWND)
	
End Sub

Sub PlayerDealCardTimer_Tick(ByVal hWin As HWND)
	
End Sub

Sub LeftEnemyDealCardTimer_Tick(ByVal hWin As HWND)
	
End Sub


Sub BankDealPackTimer_Tick(ByVal hWin As HWND)
	
End Sub

Sub BankDealPackRightEnemyTimer_Tick(ByVal hWin As HWND)
	
End Sub

Sub BankDealPackPlayerTimer_Tick(ByVal hWin As HWND)
	
End Sub

Sub BankDealPackLeftEnemyTimer_Tick(ByVal hWin As HWND)
	
End Sub

Sub BankDealPackFinishTimer_Tick(ByVal hWin As HWND)
	
End Sub
