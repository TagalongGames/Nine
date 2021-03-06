#include "MainForm.bi"
#include "win\shellapi.bi"
#include "win\commctrl.bi"

#include "MainFormWndProc.bi"
' #include "CardControl.bi"
#include "Cards.bi"
#include "DisplayError.bi"
#include "MainFormEvents.bi"
#include "NetworkParamDialogProc.bi"
#include "PlayerCard.bi"
#include "Registry.bi"
#include "Resources.RH"
#include "StatisticsDialogProc.bi"

#include "SimpleDebug.bi"

Const DefaultBackColor As Integer = &h006400
Const DefaultForeColor As Integer = &hFFF8F0

' Начальные сумы денег у игроков
Const DefaultMoney As Integer = 20
' Количество денег, которое кладётся в банк в начале игры
Const ZZZMoney As Integer = 2
' Количество денег, которое кладётся в банк если у игрока нет карт для хода
Const FFFMoney As Integer = 1

Const FramePaddingSpaceWidth As Integer = 20
Const FramePaddingSpaceHeight As Integer = 25

Enum GameModes
	Stopped
	Normal
	AI
	Online
End Enum

Type WinApiPlaingCard
	Dim Left As Integer
	Dim Top As Integer
	Dim hWin As HWND
End Type

Type WinApiMoney
	Dim Money As Money
	Dim Left As Integer
	Dim Top As Integer
	Dim Width As Integer
	Dim Height As Integer
	Dim hWin As HWND
End Type

Common Shared OldRightEnemyGroupBoxProc As WndProc
Common Shared OldUserGroupBoxProc As WndProc
Common Shared OldLeftEnemyGroupBoxProc As WndProc
Common Shared OldBankGroupBoxProc As WndProc

Dim Shared CardBitmap(36) As HBITMAP

Dim Shared CurrencyChar As WString * 16

Dim Shared GameMode As GameModes

Dim Shared BankDeck(35) As PlayerCard
Dim Shared RightEnemyDeck(11) As PlayerCard
Dim Shared PlayerDeck(11) As PlayerCard
Dim Shared LeftEnemyDeck(11) As PlayerCard

Dim Shared RightEnemyWinApiDeck(11) As WinApiPlaingCard
Dim Shared PlayerWinApiDeck(11) As WinApiPlaingCard
Dim Shared LeftEnemyWinApiDeck(11) As WinApiPlaingCard
Dim Shared BankWinApiDeck(35) As WinApiPlaingCard

Dim Shared RightEnemyGroupBox As WinApiMoney
Dim Shared PlayerGroupBox As WinApiMoney
Dim Shared LeftEnemyGroupBox As WinApiMoney
Dim Shared BankGroupBox As WinApiMoney

Dim Shared PlayerCanPlay As Boolean

Dim Shared RandomNumbers(35) As Integer

Sub InitializeCardBitmaps(ByVal hWin As HWND)
	
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

End Sub

Sub UninitializeCardBitmaps()
	
	For i As Integer = 0 To 36
		DeleteObject(CardBitmap(i))
	Next
	
End Sub

Sub GetMoneyString( _
		ByVal buffer As WString Ptr, _
		ByVal MoneyValue As Integer, _
		ByVal CharacterName As WString Ptr _
	)
	' TODO Отображать валюту по текущим языковым стандартам
	Dim bufferMoney As WString * 256 = Any
	_itow(MoneyValue, @bufferMoney, 10)
	
	lstrcpy(buffer, CharacterName)
	lstrcat(Buffer, ": ")
	
	lstrcat(buffer, bufferMoney)
	' lstrcat(buffer, " ")
	
	' lstrcat(buffer, CurrencyChar)
End Sub

Sub UpdateMoney(ByVal cm As WinApiMoney Ptr, ByVal NewValue As Integer)
	
	Dim buffer As WString * (Money.MaxCharacterNameLength * 2 + 1) = Any
	GetMoneyString(@buffer, NewValue, @cm->Money.CharacterName)
	
	LoadString(GetModuleHandle(0), IDS_CURRENCYCHAR, @buffer[lstrlen(buffer)], 255)
	
	cm->Money.Value = NewValue
	
	SetWindowText(cm->hWin, @buffer)
	
End Sub

Function GetCharacterLoose( _
		ByVal pRightMoney As WinApiMoney Ptr, _
		ByVal pPlayerGroupBox As WinApiMoney Ptr, _
		ByVal pLeftMoney As WinApiMoney Ptr, _
		ByVal pChar As Characters Ptr _
	)As Boolean
	
	If pRightMoney->Money.Value <= 0 Then
		*pChar = Characters.RightCharacter
		Return True
	End If
	
	If pPlayerGroupBox->Money.Value <= 0 Then
		*pChar = Characters.Player
		Return True
	End If
	
	If pLeftMoney->Money.Value <= 0 Then
		*pChar = Characters.LeftCharacter
		Return True
	End If
	
	Return False
	
End Function


Sub MainFormMenuNewGame_Click(ByVal hWin As HWND)
	
	If GameMode = GameModes.Normal OrElse GameMode = GameModes.Online Then
		
		Dim hInst As HINSTANCE = GetModuleHandle(0)
		
		Dim WarningMsg As WString * (1023 + 1) = Any
		LoadString(hInst, IDS_NEWGAMEWARNING, @WarningMsg, 1023)
		
		Dim MessageBoxTitle As WString * (1023 + 1) = Any
		LoadString(hInst, IDS_WINDOWTITLE, @MessageBoxTitle, 1023)
		
		If MessageBox(hWin, @WarningMsg, @MessageBoxTitle, MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2) <> IDYES Then
			Exit Sub
		End If
		
	End If
	
	GameMode = GameModes.Normal
	POST_MESSAGE_PM_NEWGAME(hWin)
	
End Sub

Sub MainFormMenuNewAIGame_Click(ByVal hWin As HWND)
	
	If GameMode = GameModes.Normal OrElse GameMode = GameModes.Online Then
		
		Dim hInst As HINSTANCE = GetModuleHandle(0)
		
		Dim WarningMsg As WString * (1023 + 1) = Any
		LoadString(hInst, IDS_NEWGAMEWARNING, @WarningMsg, 1023)
		
		Dim MessageBoxTitle As WString * (1023 + 1) = Any
		LoadString(hInst, IDS_WINDOWTITLE, @MessageBoxTitle, 1023)
		
		If MessageBox(hWin, @WarningMsg, @MessageBoxTitle, MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2) <> IDYES Then
			Exit Sub
		End If
		
	End If
	
	GameMode = GameModes.AI
	POST_MESSAGE_PM_NEWGAME(hWin)
	
End Sub

Sub MainFormMenuNewNetworkGame_Click(ByVal hWin As HWND)
	
	Dim hInst As HINSTANCE = GetModuleHandle(0)
	
	If GameMode = GameModes.Normal OrElse GameMode = GameModes.Online Then
		
		Dim WarningMsg As WString * (1023 + 1) = Any
		LoadString(hInst, IDS_NEWGAMEWARNING, @WarningMsg, 1023)
		
		Dim MessageBoxTitle As WString * (1023 + 1) = Any
		LoadString(hInst, IDS_WINDOWTITLE, @MessageBoxTitle, 1023)
		
		If MessageBox(hWin, @WarningMsg, @MessageBoxTitle, MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2) <> IDYES Then
			Exit Sub
		End If
		
	End If
	
	Dim DialogBoxParamResult As INT_PTR = DialogBoxParam(hInst, MAKEINTRESOURCE(IDD_DLG_NETWORK), hWin, @NetworkParamDialogProc, 0)
	
	If DialogBoxParamResult = 0 OrElse DialogBoxParamResult = -1 Then
		Exit Sub
	End If
	
	Dim pNetworkParams As NetworkParams Ptr = CPtr(NetworkParams Ptr, DialogBoxParamResult)
	
	If pNetworkParams->ResultCode <> IDOK Then
		Exit Sub
	End If
	
	HeapFree(GetProcessHeap(), 0, pNetworkParams)
	
	GameMode = GameModes.Online
	POST_MESSAGE_PM_NEWGAME(hWin)
	
End Sub

Sub MainFormMenuStatistics_Click(ByVal hWin As HWND)
	
	Dim pParam As StatisticParams Ptr = HeapAlloc(GetProcessHeap(), 0, SizeOf(StatisticParams))
	
	If pParam = NULL Then
		Exit Sub
	End If
	
	GetRegistryDWORD(RegistryUserWinsCountKey, @pParam->WinsCount)
	GetRegistryDWORD(RegistryUserFailsCountKey, @pParam->FailsCount)
	
	Dim hInst As HINSTANCE = GetModuleHandle(0)
	
	Dim DialogBoxParamResult As INT_PTR = DialogBoxParam(hInst, MAKEINTRESOURCE(IDD_DLG_STATISTICS), hWin, @StatisticsDialogProc, Cast(LPARAM, pParam))
	
	If DialogBoxParamResult = 0 OrElse DialogBoxParamResult = -1 Then
		Exit Sub
	End If
	
End Sub

Sub MainFormMenuFileExit_Click(ByVal hWin As HWND)
	
	DestroyWindow(hWin)
	
End Sub

Sub MainFormMenuHelpContents_Click(ByVal hWin As HWND)
	
	Dim hInst As HINSTANCE = GetModuleHandle(0)
	
	Dim NineWindowTitle As WString * (1023 + 1) = Any
	LoadString(hInst, IDS_WINDOWTITLE, @NineWindowTitle, 1023)
	
	Dim HelpMessage As WString * (1023 + 1) = Any
	LoadString(hInst, IDS_NOTIMPLEMENTED, @HelpMessage, 1023)
	
	MessageBox(hWin, @HelpMessage, @NineWindowTitle, MB_OK + MB_ICONINFORMATION)
	
End Sub

Sub MainFormMenuHelpAbout_Click(ByVal hWin As HWND)
	
	Dim hInst As HINSTANCE = GetModuleHandle(0)
	
	Dim MessageBoxTitle As WString * (1023 + 1) = Any
	LoadString(hInst, IDS_WINDOWTITLE, @MessageBoxTitle, 1023)
	
	ShellAbout(hWin, @MessageBoxTitle, @MessageBoxTitle, LoadIcon(hInst, Cast(WString Ptr, IDR_ICON)))
	
	' DialogBoxParam(GetModuleHandle(NULL), MAKEINTRESOURCE(IDD_DLG_ABOUT), hWin, @AboutDialogProc, 0)
	
End Sub


Sub MainForm_Load(ByVal hWin As HWND, ByVal wParam As WPARAM, ByVal lParam As LPARAM)
	
	Dim hInst As HINSTANCE = GetModuleHandle(0)
	
	Dim dtNow As SYSTEMTIME = Any
	GetSystemTime(@dtNow)
	srand(dtNow.wMilliseconds)
	
	LoadString(hInst, IDS_USERNICK, @PlayerGroupBox.Money.CharacterName, Money.MaxCharacterNameLength)
	LoadString(hInst, IDS_BANKNICK, @BankGroupBox.Money.CharacterName, Money.MaxCharacterNameLength)
	
	Scope
		Dim EnemyNickId1 As Integer = rand() Mod (IDS_ENEMYNICK_01 - IDS_ENEMYNICK_12)
		Dim EnemyNickId2 As Integer = Any
		
		Do
			EnemyNickId2 = rand() Mod (IDS_ENEMYNICK_01 - IDS_ENEMYNICK_12)
		Loop While EnemyNickId1 = EnemyNickId2
		
		LoadString(hInst, EnemyNickId1 + IDS_ENEMYNICK_01, @RightEnemyGroupBox.Money.CharacterName, Money.MaxCharacterNameLength)
		LoadString(hInst, EnemyNickId2 + IDS_ENEMYNICK_01, @LeftEnemyGroupBox.Money.CharacterName, Money.MaxCharacterNameLength)
	End Scope
	
	LoadString(hInst, IDS_CURRENCYCHAR, @CurrencyChar, 8)
	
	
	cdtInit(@DefautlCardWidth, @DefautlCardHeight)
	
	InitializeCardBitmaps(hWin)
	
	Dim rcClient As RECT = Any
	GetClientRect(hWin, @rcClient)
	
	Dim cx As Integer = rcClient.right \ 2
	' Dim cy As Integer = rcClient.bottom \ 2
	
	'BankGroupBox
	Scope
		BankGroupBox.Width = DefautlCardWidth * 9 + FramePaddingSpaceWidth * 2
		BankGroupBox.Height = DefautlCardHeight * 4 + FramePaddingSpaceHeight * 2
		BankGroupBox.Left = cx - BankGroupBox.Width \ 2
		BankGroupBox.Top = FramePaddingSpaceHeight
		
		BankGroupBox.hWin = CreateWindow( _
			WC_BUTTON, @BankGroupBox.Money.CharacterName, _
			WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX, _
			BankGroupBox.Left, BankGroupBox.Top, BankGroupBox.Width, BankGroupBox.Height, _
			hWin, Cast(HMENU, IDC_BANK_GROUPBOX), hInst, NULL _
		)
		
		OldBankGroupBoxProc = Cast(WndProc, GetWindowLongPtr(BankGroupBox.hWin, GWLP_WNDPROC))
		SetWindowLongPtr(BankGroupBox.hWin, GWLP_WNDPROC, Cast(LONG_PTR, @BankGroupBoxProc))
	End Scope
	
	'RightEnemyGroupBox
	Scope
		RightEnemyGroupBox.Width = DefautlCardWidth + FramePaddingSpaceWidth * 2
		RightEnemyGroupBox.Height = DefautlCardHeight * 4 + FramePaddingSpaceHeight * 2
		RightEnemyGroupBox.Left = cx + FramePaddingSpaceWidth * 2 + BankGroupBox.Width \ 2
		RightEnemyGroupBox.Top = FramePaddingSpaceHeight
		
		RightEnemyGroupBox.hWin = CreateWindow( _
			WC_BUTTON, @RightEnemyGroupBox.Money.CharacterName, _
			WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX, _
			RightEnemyGroupBox.Left, RightEnemyGroupBox.Top, RightEnemyGroupBox.Width, RightEnemyGroupBox.Height, _
			hWin, Cast(HMENU, IDC_RIGHT_GROUPBOX), hInst, NULL _
		)
		
		OldRightEnemyGroupBoxProc = Cast(WndProc, GetWindowLongPtr(RightEnemyGroupBox.hWin, GWLP_WNDPROC))
		SetWindowLongPtr(RightEnemyGroupBox.hWin, GWLP_WNDPROC, Cast(LONG_PTR, @RightEnemyGroupBoxProc))
	End Scope
	
	'PlayerGroupBox
	Scope
		PlayerGroupBox.Width = DefautlCardWidth * 12 + FramePaddingSpaceWidth * 2
		PlayerGroupBox.Height = DefautlCardHeight + FramePaddingSpaceHeight * 2
		PlayerGroupBox.Left = cx - PlayerGroupBox.Width \ 2
		PlayerGroupBox.Top = BankGroupBox.Top + BankGroupBox.Height + FramePaddingSpaceHeight
		
		PlayerGroupBox.hWin = CreateWindow( _
			WC_BUTTON, @PlayerGroupBox.Money.CharacterName, _
			WS_TABSTOP Or WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX, _
			PlayerGroupBox.Left, PlayerGroupBox.Top, PlayerGroupBox.Width, PlayerGroupBox.Height, _
			hWin, Cast(HMENU, IDC_PLAYER_GROUPBOX), hInst, NULL _
		)
		
		OldUserGroupBoxProc = Cast(WndProc, GetWindowLongPtr(PlayerGroupBox.hWin, GWLP_WNDPROC))
		SetWindowLongPtr(PlayerGroupBox.hWin, GWLP_WNDPROC, Cast(LONG_PTR, @UserGroupBoxProc))
	End Scope
	
	'LeftEnemyGroupBox
	Scope
		LeftEnemyGroupBox.Width = DefautlCardWidth + FramePaddingSpaceWidth * 2
		LeftEnemyGroupBox.Height = DefautlCardHeight * 4 + FramePaddingSpaceHeight * 2
		LeftEnemyGroupBox.Left = cx - FramePaddingSpaceWidth * 2 - LeftEnemyGroupBox.Width - BankGroupBox.Width \ 2
		LeftEnemyGroupBox.Top = FramePaddingSpaceHeight
		
		LeftEnemyGroupBox.hWin = CreateWindow( _
			WC_BUTTON, @LeftEnemyGroupBox.Money.CharacterName, _
			WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX, _
			LeftEnemyGroupBox.Left, LeftEnemyGroupBox.Top, LeftEnemyGroupBox.Width, LeftEnemyGroupBox.Height, _
			hWin, Cast(HMENU, IDC_LEFT_GROUPBOX), hInst, NULL _
		)
		
		OldLeftEnemyGroupBoxProc = Cast(WndProc, GetWindowLongPtr(LeftEnemyGroupBox.hWin, GWLP_WNDPROC))
		SetWindowLongPtr(LeftEnemyGroupBox.hWin, GWLP_WNDPROC, Cast(LONG_PTR, @LeftEnemyGroupBoxProc))
	End Scope
	
	'RightEnemyDeck
	For i As Integer = 0 To 11
		
		RightEnemyDeck(i).IsUsed = False
		RightEnemyDeck(i).CardSortNumber = i
		RightEnemyDeck(i).CardNumber = GetCardNumber(i)
		
		Dim wCardNumber As WString * (15 + 1) = Any
		CardNumberToString(RightEnemyDeck(i).CardNumber, wCardNumber)
		
		RightEnemyWinApiDeck(i).hWin = CreateWindow( _
			WC_BUTTON, wCardNumber, _
			WS_CHILD Or BS_BITMAP Or BS_PUSHBUTTON Or WS_CLIPSIBLINGS, _
			FramePaddingSpaceWidth, _
			FramePaddingSpaceHeight + (DefautlCardHeight \ 3) * i, _
			DefautlCardWidth, DefautlCardHeight, _
			RightEnemyGroupBox.hWin, Cast(HMENU, IDC_RIGHTENEMY_CARD_01 + i), hInst, NULL _
		)
		
		SendMessage(RightEnemyWinApiDeck(i).hWin, BM_SETIMAGE, IMAGE_BITMAP, Cast(LPARAM, CardBitmap(36)))
		
	Next
	
	'PlayerDeck
	For i As Integer = 0 To 11
		
		PlayerDeck(i).IsUsed = False
		PlayerDeck(i).CardSortNumber = i + 1 * 12
		PlayerDeck(i).CardNumber = GetCardNumber(i + 1 * 12)
		
		Dim wCardNumber As WString * (15 + 1) = Any
		CardNumberToString(PlayerDeck(i).CardNumber, wCardNumber)
		
		PlayerWinApiDeck(i).hWin = CreateWindow( _
			WC_BUTTON, wCardNumber, _
			WS_CHILD Or BS_BITMAP Or BS_PUSHBUTTON Or WS_DISABLED Or WS_CLIPSIBLINGS, _
			FramePaddingSpaceWidth + DefautlCardWidth * i, _
			FramePaddingSpaceHeight, _
			DefautlCardWidth, DefautlCardHeight, _
			PlayerGroupBox.hWin, Cast(HMENU, IDC_PLAING_CARD_01 + i), hInst, NULL _
		)
		
		SendMessage(PlayerWinApiDeck(i).hWin, BM_SETIMAGE, IMAGE_BITMAP, Cast(LPARAM, CardBitmap(36)))
		
	Next
	
	'LeftEnemyDeck
	For i As Integer = 0 To 11
		LeftEnemyDeck(i).IsUsed = False
		LeftEnemyDeck(i).CardSortNumber = i + 2 * 12
		LeftEnemyDeck(i).CardNumber = GetCardNumber(i + 2 * 12)
		
		Dim wCardNumber As WString * (15 + 1) = Any
		CardNumberToString(LeftEnemyDeck(i).CardNumber, wCardNumber)
		
		LeftEnemyWinApiDeck(i).hWin = CreateWindow( _
			WC_BUTTON, wCardNumber, _
			WS_CHILD Or BS_BITMAP Or BS_PUSHBUTTON Or WS_CLIPSIBLINGS, _
			FramePaddingSpaceWidth, _
			FramePaddingSpaceHeight  + (DefautlCardHeight \ 3) * i, _
			DefautlCardWidth, DefautlCardHeight, _
			LeftEnemyGroupBox.hWin, Cast(HMENU, IDC_LEFTENEMY_CARD_01 + i), hInst, NULL _
		)
		
		SendMessage(LeftEnemyWinApiDeck(i).hWin, BM_SETIMAGE, IMAGE_BITMAP, Cast(LPARAM, CardBitmap(36)))
		
	Next
	
	'BankDeck
	For i As Integer = 0 To 35
		
		BankDeck(i).IsUsed = True
		BankDeck(i).CardNumber = GetCardNumber(i)
		BankDeck(i).CardSortNumber = i
		
		Dim wCardNumber As WString * (15 + 1) = Any
		CardNumberToString(BankDeck(i).CardNumber, wCardNumber)
		
		BankWinApiDeck(i).hWin = CreateWindow( _
			WC_BUTTON, wCardNumber, _
			WS_CHILD Or WS_VISIBLE Or BS_BITMAP Or BS_PUSHBUTTON Or WS_CLIPSIBLINGS, _
			FramePaddingSpaceWidth + DefautlCardWidth * (i Mod 9), _
			FramePaddingSpaceHeight + DefautlCardHeight * (i \ 9), _
			DefautlCardWidth, DefautlCardHeight, _
			BankGroupBox.hWin, Cast(HMENU, IDC_BANK_CARD_01 + i), hInst, NULL _
		)
		
		SendMessage(BankWinApiDeck(i).hWin, BM_SETIMAGE, IMAGE_BITMAP, Cast(LPARAM, CardBitmap(i)))
		
	Next
	
	' CreateWindow( _
		' CardControlClassName, "", _
		' WS_CHILD Or WS_VISIBLE Or WS_CLIPSIBLINGS, _
		' 10, _
		' 10, _
		' DefautlCardWidth, DefautlCardHeight, _
		' hWin, Cast(HMENU, 105), hInst, NULL _
	' )
	
End Sub

Sub MainForm_UnLoad(ByVal hWin As HWND)
	
	UninitializeCardBitmaps()
	cdtTerm()
	
End Sub

Sub MainForm_Resize(ByVal hWin As HWND, ByVal ResizingRequested As Integer, ByVal ClientWidth As Integer, ByVal ClientHeight As Integer)
	
	Dim cx As Integer = ClientWidth \ 2
	' Dim cy As Integer = ClientHeight \ 2
	
	Scope
		BankGroupBox.Left = cx - BankGroupBox.Width \ 2
		BankGroupBox.Top = FramePaddingSpaceHeight
		MoveWindow(BankGroupBox.hWin, BankGroupBox.Left, BankGroupBox.Top, BankGroupBox.Width, BankGroupBox.Height, 0)
	End Scope
	
	Scope
		RightEnemyGroupBox.Left = cx + FramePaddingSpaceWidth * 2 + BankGroupBox.Width \ 2
		RightEnemyGroupBox.Top = FramePaddingSpaceHeight
		MoveWindow(RightEnemyGroupBox.hWin, RightEnemyGroupBox.Left, RightEnemyGroupBox.Top, RightEnemyGroupBox.Width, RightEnemyGroupBox.Height, 0)
	End Scope
	
	Scope
		LeftEnemyGroupBox.Left = cx - FramePaddingSpaceWidth * 2 - LeftEnemyGroupBox.Width - BankGroupBox.Width \ 2
		LeftEnemyGroupBox.Top = FramePaddingSpaceHeight
		MoveWindow(LeftEnemyGroupBox.hWin, LeftEnemyGroupBox.Left, LeftEnemyGroupBox.Top, LeftEnemyGroupBox.Width, LeftEnemyGroupBox.Height, 0)
	End Scope
	
	Scope
		PlayerGroupBox.Left = cx - PlayerGroupBox.Width \ 2
		PlayerGroupBox.Top = BankGroupBox.Top + BankGroupBox.Height + FramePaddingSpaceHeight
		MoveWindow(PlayerGroupBox.hWin, PlayerGroupBox.Left, PlayerGroupBox.Top, PlayerGroupBox.Width, PlayerGroupBox.Height, 0)
	End Scope
	
End Sub

Sub MainForm_Close(ByVal hWin As HWND)
	
	DestroyWindow(hWin)
	
End Sub

Sub MainForm_StaticControlTextColor(ByVal hWin As HWND, ByVal hwndControl As HWND, ByVal hDC As HDC)
	
	SetTextColor(hDC, DefaultForeColor)
	SetBkColor(hDC, DefaultBackColor)
	
End Sub

Sub PlayerCard_Click(ByVal hWin As HWND, ByVal ButtonId As Integer, ByVal hwndButton As HWND)
	
	If PlayerCanPlay Then
		
		Dim CardIndex As Integer = ButtonId - IDC_PLAING_CARD_01
		
		' Print "CardIndex", CardIndex
		
		PlayerCanPlay = False
		POST_MESSAGE_PM_ASSIGNMENT_USERATTACK(hWin, CardIndex)
		
	End If
	
End Sub


Sub MainForm_NewGame(ByVal hWin As HWND)
	
	UpdateMoney(@RightEnemyGroupBox, DefaultMoney)
	UpdateMoney(@PlayerGroupBox, DefaultMoney)
	UpdateMoney(@LeftEnemyGroupBox, DefaultMoney)
	UpdateMoney(@BankGroupBox, 0)
	
	POST_MESSAGE_PM_NEWSTAGE(hWin)
	
End Sub

Sub MainForm_NewStage(ByVal hWin As HWND)
	
	Dim hInst As HINSTANCE = GetModuleHandle(0)
	
	Dim OldGameMode As GameModes = GameMode
	
	Dim NineWindowTitle As WString * (511 + 1) = Any
	LoadString(hInst, IDS_WINDOWTITLE, @NineWindowTitle, 511)
	
	Dim CharacterLoose As Characters = Any
	If GetCharacterLoose(@RightEnemyGroupBox, @PlayerGroupBox, @LeftEnemyGroupBox, @CharacterLoose) Then
		
		Dim CharacterFail As WString * (511 + 1) = Any
		LoadString(hInst, IDS_CHARACTERFAIL, @CharacterFail, 511)
		
		Dim TryAgain As WString * (511 + 1) = Any
		LoadString(hInst, IDS_TRYAGAIN, @TryAgain, 511)
		
		Dim FailMessageText As WString * (511 * 3 + 1) = Any
		
		Select Case CharacterLoose
			
			Case Characters.RightCharacter
				lstrcpy(@FailMessageText, @RightEnemyGroupBox.Money.CharacterName)
				
			Case Characters.Player
				IncrementRegistryDWORD(RegistryUserFailsCountKey)
				lstrcpy(@FailMessageText, @PlayerGroupBox.Money.CharacterName)
				
			Case Characters.LeftCharacter
				lstrcpy(@FailMessageText, @LeftEnemyGroupBox.Money.CharacterName)

		End Select
		
		lstrcat(@FailMessageText, @CharacterFail)
		lstrcat(@FailMessageText, @TryAgain)
		
		GameMode = GameModes.Stopped
		
		If MessageBox(hWin, @FailMessageText, @NineWindowTitle, MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON1) = IDYES Then
			' Начинаем заново
			GameMode = OldGameMode
			POST_MESSAGE_PM_NEWGAME(hWin)
		End If
		
	Else
		
		UpdateMoney(@RightEnemyGroupBox, RightEnemyGroupBox.Money.Value - ZZZMoney)
		UpdateMoney(@PlayerGroupBox, PlayerGroupBox.Money.Value - ZZZMoney)
		UpdateMoney(@LeftEnemyGroupBox, LeftEnemyGroupBox.Money.Value - ZZZMoney)
		UpdateMoney(@BankGroupBox, 3 * ZZZMoney)
		
		For i As Integer = 0 To 35
			BankDeck(i).IsUsed = False
			ShowWindow(BankWinApiDeck(i).hWin, SW_HIDE)
		Next
		
		For i As Integer = 0 To 11
			RightEnemyDeck(i).IsUsed = False
			ShowWindow(RightEnemyWinApiDeck(i).hWin, SW_HIDE)
		Next
		
		For i As Integer = 0 To 11
			PlayerDeck(i).IsUsed = False
			ShowWindow(PlayerWinApiDeck(i).hWin, SW_HIDE)
		Next
		
		For i As Integer = 0 To 11
			LeftEnemyDeck(i).IsUsed = False
			ShowWindow(LeftEnemyWinApiDeck(i).hWin, SW_HIDE)
		Next
		
		ShuffleArray(@RandomNumbers(0), 36)
		
		' BubbleSortArray(@RandomNumbers(12 * 0), 12)
		BubbleSortArray(@RandomNumbers(12 * 1), 12)
		' BubbleSortArray(@RandomNumbers(12 * 2), 12)
		
		' DebugMessageBoxArray(@RandomNumbers(0), 36, "Перемешанный массив")
		
		For i As Integer = 0 To 11
			RightEnemyDeck(i).IsUsed = True
			RightEnemyDeck(i).CardSortNumber = RandomNumbers(i + 0 * 12)
			RightEnemyDeck(i).CardNumber = GetCardNumber(RandomNumbers(i + 0 * 12))
			
			Dim wCardNumber As WString * (15 + 1) = Any
			CardNumberToString(RightEnemyDeck(i).CardNumber, wCardNumber)
			
			SetWindowText(RightEnemyWinApiDeck(i).hWin, wCardNumber)
			ShowWindow(RightEnemyWinApiDeck(i).hWin, SW_SHOW)
			
		Next
		
		For i As Integer = 0 To 11
			PlayerDeck(i).IsUsed = True
			PlayerDeck(i).CardSortNumber = RandomNumbers(i + 1 * 12)
			PlayerDeck(i).CardNumber = GetCardNumber(RandomNumbers(i + 1 * 12))
			
			Dim wCardNumber As WString * (15 + 1) = Any
			CardNumberToString(PlayerDeck(i).CardNumber, wCardNumber)
			
			SetWindowText(PlayerWinApiDeck(i).hWin, wCardNumber)
			ShowWindow(PlayerWinApiDeck(i).hWin, SW_SHOW)
			
			SendMessage(PlayerWinApiDeck(i).hWin, BM_SETIMAGE, IMAGE_BITMAP, Cast(LPARAM, CardBitmap(RandomNumbers(i + 1 * 12))))
			
		Next
		
		For i As Integer = 0 To 11
			LeftEnemyDeck(i).IsUsed = True
			LeftEnemyDeck(i).CardSortNumber = RandomNumbers(i + 2 * 12)
			LeftEnemyDeck(i).CardNumber = GetCardNumber(RandomNumbers(i + 2 * 12))
			
			Dim wCardNumber As WString * (15 + 1) = Any
			CardNumberToString(LeftEnemyDeck(i).CardNumber, wCardNumber)
			
			SetWindowText(LeftEnemyWinApiDeck(i).hWin, wCardNumber)
			ShowWindow(LeftEnemyWinApiDeck(i).hWin, SW_SHOW)
			
		Next
		
		Dim cn As CharacterWithNine = GetNinePlayerNumber(@RightEnemyDeck(0), @PlayerDeck(0), @LeftEnemyDeck(0))
		
		Select Case cn.Character
			
			Case Characters.RightCharacter
				EnableWindow(RightEnemyWinApiDeck(cn.NineIndex).hWin, True)
				POST_MESSAGE_PM_ASSIGNMENT_RENEMYATTACK(hWin, cn.NineIndex)
				
			Case Characters.Player
				EnableWindow(PlayerWinApiDeck(cn.NineIndex).hWin, True)
				POST_MESSAGE_PM_ASSIGNMENT_USERATTACK(hWin, cn.NineIndex)
				
			Case Characters.LeftCharacter
				EnableWindow(LeftEnemyWinApiDeck(cn.NineIndex).hWin, True)
				POST_MESSAGE_PM_ASSIGNMENT_LENEMYATTACK(hWin, cn.NineIndex)
				
		End Select
		
	End If
	
End Sub


Sub MainForm_RightEnemyAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal AssignmentFlag As Integer)
	
	If AssignmentFlag = CardNotAssignment Then
		
		Dim CardIndex As Integer = GetPlayerDealCard(@RightEnemyDeck(0), @BankDeck(0))
		
		If CardIndex >= 0 Then
			CardNumber = CardIndex
			AssignmentFlag = CardAssignment
		End If
		
	End If
	
	If AssignmentFlag = CardNotAssignment Then
		POST_MESSAGE_PM_RENEMYFOOL(hWin)
	Else
		' Карта найдена, скинуть её на стол
		RightEnemyDeck(CardNumber).IsUsed = False
		ShowWindow(RightEnemyWinApiDeck(CardNumber).hWin, SW_HIDE)
		
		' Сделать карту видимой на поле
		BankDeck(RightEnemyDeck(CardNumber).CardSortNumber).IsUsed = True
		ShowWindow(BankWinApiDeck(RightEnemyDeck(CardNumber).CardSortNumber).hWin, SW_SHOW)
		
		' Передать ход игроку
		If IsPlayerWin(@RightEnemyDeck(0)) Then
			POST_MESSAGE_PM_RENEMYWIN(hWin)
		Else
			
			Select Case GameMode	
				
				Case GameModes.Normal
					POST_MESSAGE_PM_NOTASSIGNMENT_USERATTACK(hWin)
					
				Case GameModes.AI
					Dim CardIndex As Integer = GetPlayerDealCard(@PlayerDeck(0), @BankDeck(0))
					
					If CardIndex >= 0 Then
						POST_MESSAGE_PM_ASSIGNMENT_USERATTACK(hWin, CardIndex)
					Else
						POST_MESSAGE_PM_NOTASSIGNMENT_USERATTACK(hWin)
					End If
					
					
				Case GameModes.Online
					
				Case Else
					POST_MESSAGE_PM_NOTASSIGNMENT_USERATTACK(hWin)
					
			End Select
			
		End If
		
	End If
	
End Sub

Sub MainForm_UserAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal AssignmentFlag As Integer)
	
	If AssignmentFlag = CardNotAssignment Then
		
		' Ищем и включаем карты, которые можно скинуть на стол
		For i As Integer = 0 To 11
			
			If PlayerDeck(i).IsUsed = True Then
			
				If ValidatePlayerCardNumber(PlayerDeck(i).CardSortNumber, @BankDeck(0)) Then
					PlayerCanPlay = True
					EnableWindow(PlayerWinApiDeck(i).hWin, TRUE)
				End If
				
			End If
			
		Next
		
		' Карта не найдена, персонаж не может ходить
		If PlayerCanPlay = False Then
			POST_MESSAGE_PM_USERFOOL(hWin)
		End If
		
	Else
		
		' Карта назначена, скинуть её на стол
		PlayerDeck(CardNumber).IsUsed = False
		EnableWindow(PlayerWinApiDeck(CardNumber).hWin, 0)
		ShowWindow(PlayerWinApiDeck(CardNumber).hWin, SW_HIDE)
		
		' Сделать карту видимой на поле
		BankDeck(PlayerDeck(CardNumber).CardSortNumber).IsUsed = True
		ShowWindow(BankWinApiDeck(PlayerDeck(CardNumber).CardSortNumber).hWin, SW_SHOW)
		
		' Передать ход левому врагу
		If IsPlayerWin(@PlayerDeck(0)) Then
			POST_MESSAGE_PM_PLAYERWIN(hWin)
		Else
			POST_MESSAGE_PM_NOTASSIGNMENT_LENEMYATTACK(hWin)
		End If
		
	End If
	
End Sub

Sub MainForm_LeftEnemyAttack(ByVal hWin As HWND, ByVal CardNumber As Integer, ByVal AssignmentFlag As Integer)
	
	If AssignmentFlag = CardNotAssignment Then
		
		Dim CardIndex As Integer = GetPlayerDealCard(@LeftEnemyDeck(0), @BankDeck(0))
		
		If CardIndex >= 0 Then
			CardNumber = CardIndex
			AssignmentFlag = CardAssignment
		End If
		
	End If
	
	If AssignmentFlag = CardNotAssignment Then
		POST_MESSAGE_PM_LENEMYFOOL(hWin)
	Else
		
		' Карта найдена, скинуть её на стол
		LeftEnemyDeck(CardNumber).IsUsed = False
		ShowWindow(LeftEnemyWinApiDeck(CardNumber).hWin, SW_HIDE)
		
		' Сделать карту видимой на поле
		BankDeck(LeftEnemyDeck(CardNumber).CardSortNumber).IsUsed = True
		ShowWindow(BankWinApiDeck(LeftEnemyDeck(CardNumber).CardSortNumber).hWin, SW_SHOW)
		
		' Передать ход правому врагу
		If IsPlayerWin(@LeftEnemyDeck(0)) Then
			POST_MESSAGE_PM_LENEMYWIN(hWin)
		Else
			POST_MESSAGE_PM_NOTASSIGNMENT_RENEMYATTACK(hWin)
		End If
		
	End If

End Sub


Sub MainForm_RightEnemyFool(ByVal hWin As HWND)
	
	UpdateMoney(@RightEnemyGroupBox, RightEnemyGroupBox.Money.Value - FFFMoney)
	UpdateMoney(@BankGroupBox, BankGroupBox.Money.Value + FFFMoney)
	
	Select Case GameMode
		
		Case GameModes.Normal
			POST_MESSAGE_PM_NOTASSIGNMENT_USERATTACK(hWin)
			
		Case GameModes.AI
			Dim AssignmentFlag As Integer = CardNotAssignment
			
			Dim CardIndex As Integer = GetPlayerDealCard(@PlayerDeck(0), @BankDeck(0))
			
			If CardIndex >= 0 Then
				AssignmentFlag = CardAssignment
			End If
			
			POST_MESSAGE_PM_USERATTACK(hWin, CardIndex, AssignmentFlag)
			
		Case GameModes.Online
			' TODO Ход игрока при сетевой игре
			
	End Select
End Sub

Sub MainForm_UserFool(ByVal hWin As HWND)
	
	UpdateMoney(@PlayerGroupBox, PlayerGroupBox.Money.Value - FFFMoney)
	UpdateMoney(@BankGroupBox, BankGroupBox.Money.Value + FFFMoney)
	
	POST_MESSAGE_PM_NOTASSIGNMENT_LENEMYATTACK(hWin)

End Sub

Sub MainForm_LeftEnemyFool(ByVal hWin As HWND)
	
	UpdateMoney(@LeftEnemyGroupBox, LeftEnemyGroupBox.Money.Value - FFFMoney)
	UpdateMoney(@BankGroupBox, BankGroupBox.Money.Value + FFFMoney)
	
	POST_MESSAGE_PM_NOTASSIGNMENT_RENEMYATTACK(hWin)
	
End Sub


Sub MainForm_RightEnemyWin(ByVal hWin As HWND)
	
	UpdateMoney(@RightEnemyGroupBox, RightEnemyGroupBox.Money.Value + BankGroupBox.Money.Value)
	UpdateMoney(@BankGroupBox, 0)
	
	POST_MESSAGE_PM_NEWSTAGE(hWin)
	
End Sub

Sub MainForm_UserWin(ByVal hWin As HWND)
	
	IncrementRegistryDWORD(RegistryUserWinsCountKey)
	
	UpdateMoney(@PlayerGroupBox, PlayerGroupBox.Money.Value + BankGroupBox.Money.Value)
	UpdateMoney(@BankGroupBox, 0)
	
	POST_MESSAGE_PM_NEWSTAGE(hWin)
	
End Sub

Sub MainForm_LeftEnemyWin(ByVal hWin As HWND)
	
	UpdateMoney(@LeftEnemyGroupBox, LeftEnemyGroupBox.Money.Value + BankGroupBox.Money.Value)
	UpdateMoney(@BankGroupBox, 0)
	
	POST_MESSAGE_PM_NEWSTAGE(hWin)
	
End Sub
