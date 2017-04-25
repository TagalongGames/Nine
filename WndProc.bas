#include once "WndProc.bi"
#include once "Cards.bi"
#include once "win\windowsx.bi"
#include once "GameEvents.bi"
#include once "PlayerCard.bi"
#include once "Nine.rh"
#include once "IntegerToWString.bi"
#include once "crt.bi"

' Тёмно‐зелёный цвет
Const DarkGreenColor As Integer = &h00FFFF

' Начальные сумы денег у игроков
Const DefaultMoney As Integer = 10
' Количество денег, которое кладётся в банк в начале игры
Const ZZZMoney As Integer = 2
' Количество денег, которое кладётся в банк если у игрока нет карт для хода
Const FFFMoney As Integer = 1

' Количество миллисекунд таймера
Const TimerElapsedTime As Integer = 25
' Таймер анимации хода игрока
Const PlayerDealCardTimerId As Integer = 1

' Массив точек для анимации карты игрока
Dim Shared PlayerDealCardAnimationPointStart As Point
Dim Shared PlayerDealCardAnimationCardSortNumber As Integer
Dim Shared PlayerDealCardAnimationCardIncrementX As Integer
Dim Shared PlayerDealCardAnimationCardIncrementY As Integer
Dim Shared PlayerDealCardAnimationPointStartCount As Integer
Dim Shared PlayerDealCardAnimationHDC As HDC
Dim Shared PlayerDealCardAnimationBitmap As HBITMAP

' Ширина и высота карты
Dim Shared mintWidth As Integer
Dim Shared mintHeight As Integer
' Игра идёт
Dim Shared GameIsRunning As Boolean
' Рисование
Dim Shared DarkGreenBrush As HBRUSH
Dim Shared YellowPen As HPEN

' Колода
Dim Shared BankDeck(35) As PlayerCard
' Карты
Dim Shared PlayerDeck(11) As PlayerCard
Dim Shared LeftEnemyDeck(11) As PlayerCard
Dim Shared RightEnemyDeck(11) As PlayerCard
' Деньги
Dim Shared PlayerMoney As Money
Dim Shared LeftEnemyMoney As Money
Dim Shared RightEnemyMoney As Money
Dim Shared BankMoney As Money

' Игрок может щёлкать по своим картам
Dim Shared PlayerCanPlay As Boolean

Sub DrawCharactersPack(ByVal hDC As HDC)
	For i As Integer = 0 To 11
		If GameIsRunning Then
			' Нарисовать карты
			' Только те, что на руках у персонажей
			If PlayerDeck(i).IsUsed Then
				cdtDrawExt(hDC, PlayerDeck(i).X, PlayerDeck(i).Y, PlayerDeck(i).Width, PlayerDeck(i).Height, PlayerDeck(i).CardNumber, CardViews.Normal, 0)
			End If
			If LeftEnemyDeck(i).IsUsed Then
				cdtDrawExt(hDC, LeftEnemyDeck(i).X, LeftEnemyDeck(i).Y, LeftEnemyDeck(i).Width, LeftEnemyDeck(i).Height, LeftEnemyDeck(i).CardNumber, CardViews.Normal, 0)
			End If
			If RightEnemyDeck(i).IsUsed Then
				cdtDrawExt(hDC, RightEnemyDeck(i).X, RightEnemyDeck(i).Y, RightEnemyDeck(i).Width, RightEnemyDeck(i).Height, RightEnemyDeck(i).CardNumber, CardViews.Normal, 0)
			End If
		' Else
			' Нарисовать рамки карт игроков
			' Rectangle(hDC, PlayerDeck(i).X, PlayerDeck(i).Y, PlayerDeck(i).X + PlayerDeck(i).Width, PlayerDeck(i).Y + PlayerDeck(i).Height)
			' Rectangle(hDC, LeftEnemyDeck(i).X, LeftEnemyDeck(i).Y, LeftEnemyDeck(i).X + LeftEnemyDeck(i).Width, LeftEnemyDeck(i).Y + LeftEnemyDeck(i).Height)
			' Rectangle(hDC, RightEnemyDeck(i).X, RightEnemyDeck(i).Y, RightEnemyDeck(i).X + RightEnemyDeck(i).Width, RightEnemyDeck(i).Y + RightEnemyDeck(i).Height)
		End If
	Next
End Sub

Sub DrawBankPack(ByVal hDC As HDC)
	For i As Integer = 0 To 35
		If GameIsRunning Then
			' Нарисовать только те, что лежат на рабочем столе
			' Для остальных рамки
			If BankDeck(i).IsUsed Then
				cdtDrawExt(hDC, BankDeck(i).X, BankDeck(i).Y, BankDeck(i).Width, BankDeck(i).Height, BankDeck(i).CardNumber, CardViews.Normal, 0)
			' Else
				' Rectangle(hDC, BankDeck(i).X, BankDeck(i).Y, BankDeck(i).X + BankDeck(i).Width, BankDeck(i).Y + BankDeck(i).Height)
			End If
		Else
			' Нарисовать все карты
			cdtDrawExt(hDC, BankDeck(i).X, BankDeck(i).Y, BankDeck(i).Width, BankDeck(i).Height, BankDeck(i).CardNumber, CardViews.Normal, 0)
		End If
	Next
End Sub

Function WndProc(ByVal hWin As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
	Select Case wMsg
		Case WM_CREATE
			' Инициализация библиотеки
			cdtInit(@mintWidth, @mintHeight)
			' Размеры карт
			' Dim EnemyCardWidth As Integer = (mintWidth * 2 ) \ 3
			' Dim EnemyCardHeight As Integer = (mintHeight * 2) \ 3
			For i As Integer = 0 To 11
				' Карты игрока
				PlayerDeck(i).Width = mintWidth
				PlayerDeck(i).Height = mintHeight
				' Карты врагов
				LeftEnemyDeck(i).Width = mintWidth
				LeftEnemyDeck(i).Height = mintHeight
				RightEnemyDeck(i).Width = mintWidth
				RightEnemyDeck(i).Height = mintHeight
				' Игровое поле
				BankDeck(i).Width = mintWidth
				BankDeck(i).Height = mintHeight
				' Карта лежит на рабочем столе
				BankDeck(i).IsUsed = True
				BankDeck(i).CardNumber = GetCardNumber(i)
				BankDeck(i).CardSortNumber = i
			Next
			For i As Integer = 12 To 35
				BankDeck(i).Width = mintWidth
				BankDeck(i).Height = mintHeight
				BankDeck(i).IsUsed = True
				BankDeck(i).CardNumber = GetCardNumber(i)
				BankDeck(i).CardSortNumber = i
			Next
			
			' Объекты GDI
			DarkGreenBrush = CreateSolidBrush(&h004000)
			YellowPen = CreatePen(PS_SOLID, 1, DarkGreenColor)
			
			PlayerDealCardAnimationHDC = CreateCompatibleDC(0)
			If PlayerDealCardAnimationHDC = 0 Then
				' MessageBox(hWin, @"Не могу создать контекст устройства", @"Девятка", MB_ICONINFORMATION)
			End If
			
			Dim hDCmem As HDC = GetDC(hWin)
			PlayerDealCardAnimationBitmap = CreateCompatibleBitmap(hDCmem,  GetDeviceCaps(PlayerDealCardAnimationHDC, HORZRES),  GetDeviceCaps(PlayerDealCardAnimationHDC, VERTRES))
			If PlayerDealCardAnimationBitmap = 0 Then
				' MessageBox(hWin, @"Не могу создать изображение", @"Девятка", MB_ICONINFORMATION)
			End If
			If SelectObject(PlayerDealCardAnimationHDC, PlayerDealCardAnimationBitmap) = 0 Then
				' MessageBox(hWin, @"Не могу выбрать изображение", @"Девятка", MB_ICONINFORMATION)
			End If
			If DeleteDC(hDCmem) = 0 Then
				' MessageBox(hWin, @"Не могу удалить контекст", @"Девятка", MB_ICONINFORMATION)
			End If
			
		Case WM_COMMAND
			' События от нажатий кнопок и меню
			Select Case HiWord(wParam)
				Case BN_CLICKED, 1
					Select Case LoWord(wParam)
						Case IDM_GAME_NEW
							' Новая игра
							If GameIsRunning Then
								' Игра идёт
								' Спросить у пользователя
								' желает ли он прервать текущую игру
								' Dim WarningMsg As WString *256
								' LoadString(hInst, IDS_NEWGAMEWARNING, WarningMsg, 256)
								Dim intResult As Integer = MessageBox(hWin, "Игра уже идёт. Точно остановить?", "Девятка", MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2)
								If intResult = IDYES Then
									' Начинаем заново
									PostMessage(hWin, PM_NEWGAME, 0, 0)
								End If
							Else
								PostMessage(hWin, PM_NEWGAME, 0, 0)
							End If
						Case IDM_FILE_EXIT
							' Выход
							DestroyWindow(hWin)
						Case IDM_HELP_CONTENTS
							' Справка - содержание
						Case IDM_HELP_ABOUT
							' Сообщение "О программе"
							' Dim AboutMsg As WString *256
							' LoadString(hInst, IDS_ABOUT, AboutMsg, 256)
							' О программе
							' MessageBox(hWin, AboutMsg, strTitle, MB_OK + MB_ICONINFORMATION)
					End Select
			End Select
			
		Case WM_LBUTTONDOWN
			' If PlayerCanPlay Then
				' Получить номер карты, на который щёлкнул пользователь
				Dim CardNumber As Integer = GetClickPlayerCardNumber(@PlayerDeck(0), GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam))
				If CardNumber >= 0 Then
					' Проверить правильность хода пользователя
					' If ValidatePlayerCardNumber(PlayerDeck(CardNumber).CardSortNumber, @BankDeck(0)) Then
						
						' Dim hDC2 As HDC = CreateCompatibleDC(0)
						' Dim hDCmem As HDC = GetDC(hWin)
						' Dim hbmScreen As HBITMAP = CreateCompatibleBitmap(hDCmem,  GetDeviceCaps(hDC2, HORZRES),  GetDeviceCaps(hDC2, VERTRES))
						' SelectObject(hDC2, hbmScreen)
						' Scope
							' Dim hDC As HDC = GetDC(hWin)
							' BitBlt(PlayerDealCardAnimationHDC, 0, 0, PlayerDeck(0).Width * 3, PlayerDeck(0).Height, hDC, PlayerDeck(0).X, PlayerDeck(0).Y, SRCCOPY)
							' BitBlt(hDC, 0, 0, PlayerDeck(0).Width * 3, PlayerDeck(0).Height, PlayerDealCardAnimationHDC, 0, 0, SRCCOPY)
							
							' Нарисовать
							' cdtDrawExt(PlayerDealCardAnimationHDC, 0, 0, mintWidth, mintHeight, 1, CardViews.Normal, 0)
							' BitBlt(hDC, 0, 0, mintWidth, mintHeight, PlayerDealCardAnimationHDC, 0, 0, NOTSRCCOPY)
							
							' Стереть
							' Dim intRop As Integer = SetROP2(hDC, R2_XORPEN)
							' cdtDrawExt(hDC, 0, 0, mintWidth, mintHeight, 1, CardViews.Normal, 0)
							' BitBlt(hDC, 0, 0, mintWidth, mintHeight, PlayerDealCardAnimationHDC, 0, 0, DSTINVERT)
							' SetROP2(hDC, intRop)
							' ReleaseDC(hWin, hDC)
						' End Scope
						' If DeleteObject(hbmScreen) = 0 Then
							' MessageBox(hWin, @"Не могу удалить картинку", @"Девятка", MB_ICONINFORMATION)
						' End If
						' If DeleteDC(hDCmem) = 0 Then
							' MessageBox(hWin, @"Не могу удалить контекст", @"Девятка", MB_ICONINFORMATION)
						' End If
						' If DeleteDC(hDC2) = 0 Then
							' MessageBox(hWin, @"Не могу удалить контекст", @"Девятка", MB_ICONINFORMATION)
						' End If
						
						' Запретить ходить пользователю
						PlayerCanPlay = False
						' Удалить карту из массива
						PlayerDeck(CardNumber).IsUsed = False
						' Пользователь нажал на карту, отправить её на игровое поле
						SendMessage(hWin, PM_USER_DEALCARD, CardNumber, 0)
						' Если карт больше нет, то это победа
						If IsPlayerWin(@PlayerDeck(0)) = False Then
							' Передать ход левому врагу
							' PostMessage(hWin, PM_LENEMYATTACK, 0, 0)
						Else
							' Победа
							' PostMessage(hWin, PM_USERWIN, 0, 0)
						End If
					' Else
						' MessageBox(hWin, @"Неправильный номер карты", @"Девятка", MB_ICONINFORMATION)
					' End If
				End If
			' End If
		Case WM_TIMER
			' Анимация
			Select Case wParam
				Case PlayerDealCardTimerId
					' Анимация передвижения карты игрока
					' В таймере рисовать изображение по точкам
					
					Dim hDC As HDC = GetDC(hWin)
					' Где‐то нарисовать старое изображение
					Select Case PlayerDealCardAnimationPointStartCount
						Case 0
							' Положить в память старое изображение
							' cdtDrawExt(hDC, PlayerDealCardAnimationPointStart.X, PlayerDealCardAnimationPointStart.Y, mintWidth, mintHeight, BankDeck(PlayerDealCardAnimationCardSortNumber).CardNumber, CardViews.Normal, 0)
							PlayerDealCardAnimationPointStartCount = 1
							Exit Select
						Case 1
							' Восстановить изображение из памяти
							' Поместить в память изображение взяв оттуда где будет новое
							' Нарисовать новое
							
							' Dim intRop As Integer = SetROP2(hDC, R2_XORPEN)
							' cdtDrawExt(hDC, PlayerDealCardAnimationPointStart.X, PlayerDealCardAnimationPointStart.Y, mintWidth, mintHeight, BankDeck(PlayerDealCardAnimationCardSortNumber).CardNumber, CardViews.Normal, 0)
							' SetROP2(hDC, intRop)
							
							' Нарисовать новое
							' Если координата X больше, то увеличить
							' Иначе уменьшить
							' If BankDeck(PlayerDealCardAnimationCardSortNumber).X > PlayerDealCardAnimationPointStart.X Then
								' PlayerDealCardAnimationPointStart.X += PlayerDealCardAnimationCardIncrementX
							' Else
								' PlayerDealCardAnimationPointStart.X -= PlayerDealCardAnimationCardIncrementX
							' End If
							' Если коордитата Y больше, то уменьшить
							' Иначе увеличить
							' If BankDeck(PlayerDealCardAnimationCardSortNumber).Y > PlayerDealCardAnimationPointStart.Y Then
								' PlayerDealCardAnimationPointStart.Y += PlayerDealCardAnimationCardIncrementY
							' Else
								' PlayerDealCardAnimationPointStart.Y -= PlayerDealCardAnimationCardIncrementY
							' End If
							
							' cdtDrawExt(hDC, PlayerDealCardAnimationPointStart.X, PlayerDealCardAnimationPointStart.Y, mintWidth, mintHeight, BankDeck(PlayerDealCardAnimationCardSortNumber).CardNumber, CardViews.Normal, 0)
							
							' Dim dx As Integer = Abs(BankDeck(PlayerDealCardAnimationCardSortNumber).X - PlayerDealCardAnimationPointStart.X)
							' Dim dy As Integer = Abs(BankDeck(PlayerDealCardAnimationCardSortNumber).Y - PlayerDealCardAnimationPointStart.Y)
							' If dx < Abs(PlayerDealCardAnimationCardIncrementX) OrElse dy < Abs(PlayerDealCardAnimationCardIncrementY) Then
								' Как только будет достигнута последняя точка, то остановить таймер
								PlayerDealCardAnimationPointStartCount = 2
								Exit Select
							' End If
						Case 2
							KillTimer(hWin, PlayerDealCardTimerId)
							' Восстановить из памяти изображение
							
							' Dim intRop As Integer = SetROP2(hDC, R2_XORPEN)
							' cdtDrawExt(hDC, PlayerDealCardAnimationPointStart.X, PlayerDealCardAnimationPointStart.Y, mintWidth, mintHeight, BankDeck(PlayerDealCardAnimationCardSortNumber).CardNumber, CardViews.Normal, 0)
							' SetROP2(hDC, intRop)
							
							' Сделать карту видимой на поле
							' BankDeck(PlayerDealCardAnimationCardSortNumber).IsUsed = True
							' Нарисовать карту
							' cdtDrawExt(hDC, PlayerDealCardAnimationPointStart.X, PlayerDealCardAnimationPointStart.Y, mintWidth, mintHeight, BankDeck(PlayerDealCardAnimationCardSortNumber).CardNumber, CardViews.Normal, 0)
					End Select
					
					ReleaseDC(hWin, hDC)
					
			End Select
		Case WM_PAINT
			Dim ClientRectangle As RECT = Any
			GetClientRect(hWin, @ClientRectangle)
			
			' Рисуем игровое поле
			Dim pnt As PAINTSTRUCT = Any
			Dim hDC As HDC = BeginPaint(hWin, @pnt)
			
			' Закрасить рабочий стол зелёным цветом
			Dim oldBrush As HBRUSH = SelectObject(hDC, DarkGreenBrush)
			Dim oldPen As HPEN = SelectObject(hDC, YellowPen)
			FloodFill(hDC, 0, 0, &h004000)
			
			' Карты игрока и врагов
			DrawCharactersPack(hDC)
			' Рабочий стол
			DrawBankPack(hDC)
			
			Dim BkMode As Integer = SetBkMode(hDC, TRANSPARENT)
			
			' Деньги игрока, соперников и банка
			Dim buffer As WString * 256 = Any
			itow(PlayerMoney.Value, @buffer, 10)
			TextOut(hDC, PlayerMoney.X, PlayerMoney.Y, @buffer, lstrlen(@buffer))
			
			itow(LeftEnemyMoney.Value, @buffer, 10)
			TextOut(hDC, LeftEnemyMoney.X, LeftEnemyMoney.Y, @buffer, lstrlen(@buffer))
			
			itow(RightEnemyMoney.Value, @buffer, 10)
			TextOut(hDC, RightEnemyMoney.X, RightEnemyMoney.Y, @buffer, lstrlen(@buffer))
			
			itow(BankMoney.Value, @buffer, 10)
			TextOut(hDC, BankMoney.X, BankMoney.Y, @buffer, lstrlen(@buffer))
			
			' TODO Изображения соперников и банка
			
			' Очистка
			SetBkMode(hDC, BkMode)
			SelectObject(hDC, oldPen)
			SelectObject(hDC, oldBrush)
			EndPaint(hWin, @pnt)
			
		Case WM_SIZE
			' Изменение размеров окна, пересчитать координаты карт
			
			' Центр клиентской области
			Dim ClientRectangle As RECT = Any
			GetClientRect(hWin, @ClientRectangle)
			Dim cx As Integer = ClientRectangle.right \ 2
			Dim cy As Integer = ClientRectangle.bottom \ 2
			
			Scope
				' Карты банка
				' Смещение относительно центра клиентской области для центрирования карт
				Dim dx As Integer = cx - (mintWidth * 9) \ 2
				Dim dy As Integer = mintHeight
				
				For k As Integer = 0 To 3
					For j As Integer = 0 To 8
						Dim i As Integer = k * 9 + j
						BankDeck(i).X = j * mintWidth + dx
						BankDeck(i).Y = k * mintHeight + dy
					Next
				Next
				' Деньги банка
				BankMoney.X = cx
				BankMoney.Y = mintHeight \ 2
			End Scope
			
			Scope
				' Карты игрока
				Dim dxPlayer As Integer = cx - (mintWidth * 12) \ 2
				Dim dyPlayer As Integer = mintHeight * 6 - mintHeight \ 3
				For i As Integer = 0 To 11
					PlayerDeck(i).X = i * mintWidth + dxPlayer
					PlayerDeck(i).Y = dyPlayer
				Next
				' Деньги игрока
				PlayerMoney.X = cx
				PlayerMoney.Y = mintHeight * 6 - 2 * mintHeight \ 3
			End Scope
			
			Scope
				' Карты левого врага
				Dim dxEnemyLeft As Integer = cx - (mintWidth * 9) \ 2 - mintWidth - mintWidth \ 2
				Dim dyEnemyLeft As Integer = mintHeight - mintHeight \ 3
				For i As Integer = 0 To 11
					LeftEnemyDeck(i).X = dxEnemyLeft
					LeftEnemyDeck(i).Y = i * (mintHeight \ 3) + dyEnemyLeft
				Next
				' Деньги левого врага
				LeftEnemyMoney.X = dxEnemyLeft
				LeftEnemyMoney.Y = mintHeight \ 3
			End Scope
			
			Scope
				' Карты правого врага
				Dim dxEnemyRight As Integer = cx + (mintWidth * 9) \ 2 + mintWidth \ 2
				Dim dyEnemyRight As Integer = mintHeight - mintHeight \ 3
				For i As Integer = 0 To 11
					RightEnemyDeck(i).X = dxEnemyRight
					RightEnemyDeck(i).Y = i * (mintHeight \ 3) + dyEnemyRight
				Next
				' Деньги правого врага
				RightEnemyMoney.X = dxEnemyRight
				RightEnemyMoney.Y = mintHeight \ 3
			End Scope
			
		Case WM_CLOSE
			' Пользователь пытается закрыть окно
			' Если игра уже идёт, то спросить
			DestroyWindow(hWin)
			
		Case WM_DESTROY
			' Очистка
			If DeleteObject(PlayerDealCardAnimationBitmap) = 0 Then
				MessageBox(hWin, @"Не могу удалить картинку", @"Девятка", MB_ICONINFORMATION)
			End If
			If DeleteDC(PlayerDealCardAnimationHDC) = 0 Then
				MessageBox(hWin, @"Не могу удалить устройство рисования", @"Девятка", MB_ICONINFORMATION)
			End If
			If DeleteObject(YellowPen) = 0 Then
				' MessageBox(hWin, @"Не могу удалить перо", @"Девятка", MB_ICONINFORMATION)
			End If
			If DeleteObject(DarkGreenBrush) = 0 Then
				' MessageBox(hWin, @"Не могу удалить кисть", @"Девятка", MB_ICONINFORMATION)
			End If
			cdtTerm()
			' Окно уничтожается
			PostQuitMessage(0)
			
		Case PM_NEWGAME
			' Начинаем новую игру
			GameIsRunning = True
			
			' Событие восстановления суммы денег
			SendMessage(hWin, PM_DEFAULTMONEY, 0, 0)
			
			' Начать новый раунд
			PostMessage(hWin, PM_NEWSTAGE, 0, 0)
			
		Case PM_NEWSTAGE
			' Новый раунд игры
			If PlayerMoney.Value <= 0 Then
				' Проигрыш
				' TODO Анимация проигрыша
				GameIsRunning = False
			Else
				' Событие взятия суммы у игроков
				SendMessage(hWin, PM_DEALMONEY, 0, 0)
				
				' Событие раздачи колоды карт игрокам
				SendMessage(hWin, PM_DEALPACK, 0, 0)
				
				' Найти того, у кого девятка бубен и сделать сделать его ход
				Dim cn As CharacterWithNine = GetNinePlayerNumber(@RightEnemyDeck(0), @PlayerDeck(0), @LeftEnemyDeck(0))
				Select Case cn.Char
					Case Characters.RightCharacter
						' MessageBox(hWin, @"Девятка у правого врага", @"Девятка", MB_ICONINFORMATION)
						PostMessage(hWin, PM_RENEMYATTACK, cn.NineIndex, True)
					Case Characters.Player
						' MessageBox(hWin, @"Девятка у игрока", @"Девятка", MB_ICONINFORMATION)
						PostMessage(hWin, PM_USERATTACK, cn.NineIndex, True)
					Case Characters.LeftCharacter
						' MessageBox(hWin, @"Девятка у левого врага", @"Девятка", MB_ICONINFORMATION)
						PostMessage(hWin, PM_LENEMYATTACK, cn.NineIndex, True)
				End Select
			End If
			
		Case PM_DEFAULTMONEY
			' Событие восстановления денег
			' TODO Анимация восстановления денег
			PlayerMoney.Value = DefaultMoney
			LeftEnemyMoney.Value = DefaultMoney
			RightEnemyMoney.Value = DefaultMoney
			BankMoney.Value = 0
			
		Case PM_DEALMONEY
			' Взятие денег у персонажей
			' TODO Анимация взятия денег у игроков
			PlayerMoney.Value -= ZZZMoney
			LeftEnemyMoney.Value -= ZZZMoney
			RightEnemyMoney.Value -= ZZZMoney
			BankMoney.Value = 3 * ZZZMoney
			
		Case PM_DEALPACK
			' Раздача колоды
			' TODO Анимация раздачи колоды
			
			' Перемешивание массива
			Dim RandomNumbers(35) As Integer = Any
			ShuffleArray(@RandomNumbers(0), 36)
			
			' Выдача игрокам
			For i As Integer = 0 To 11
				PlayerDeck(i).IsUsed = True
				PlayerDeck(i).CardSortNumber = RandomNumbers(i)
				PlayerDeck(i).CardNumber = GetCardNumber(RandomNumbers(i))
			Next
			For i As Integer = 0 To 11
				LeftEnemyDeck(i).IsUsed = True
				LeftEnemyDeck(i).CardSortNumber = RandomNumbers(i + 12)
				LeftEnemyDeck(i).CardNumber = GetCardNumber(RandomNumbers(i + 12))
			Next
			For i As Integer = 0 To 11
				RightEnemyDeck(i).IsUsed = True
				RightEnemyDeck(i).CardSortNumber = RandomNumbers(i + 2 * 12)
				RightEnemyDeck(i).CardNumber = GetCardNumber(RandomNumbers(i + 2 * 12))
			Next
			For i As Integer = 0 To 35
				BankDeck(i).IsUsed = False
			Next
			
			Scope
				Dim hDC As HDC = GetDC(hWin)
				' Карты игрока и врагов
				DrawCharactersPack(hDC)
				' Карты банка
				DrawBankPack(hDC)
				ReleaseDC(hWin, hDC)
			End Scope
			
		Case PM_RENEMYATTACK
			' Ход правого врага
			If lParam = False Then
				' Номер карты определить самостоятельно
				' Если найдена, то установить
				' lParam = True
				' wParam — индекс в массиве карт
				MessageBox(hWin, @"Определяю номер карты правого врага", @"Девятка", MB_ICONINFORMATION)
				Dim CardIndex As Integer = GetPlayerDealCard(@RightEnemyDeck(0), @BankDeck(0))
				If CardIndex >= 0 Then
					MessageBox(hWin, @"Номер карты положительный", @"Девятка", MB_ICONINFORMATION)
					wParam = CardIndex
					lParam = True
				Else
					lParam = False
				End If
			End If
			If lParam <> False Then
				' В параметре wParam номер карты
				' Удалить карту из массива
				RightEnemyDeck(wParam).IsUsed = False
				' Отправить карту на поле
				SendMessage(hWin, PM_RENEMY_DEALCARD, wParam, 0)
				' Если на руках карт нет, то победа
				If IsPlayerWin(@RightEnemyDeck(0)) = False Then
					' Передать ход игроку
					PostMessage(hWin, PM_USERATTACK, 0, 0)
				Else
					PostMessage(hWin, PM_RENEMYWIN, 0, 0)
				End If
			Else
				' Правый враг не может ходить
				MessageBox(hWin, @"Правый враг не может ходить", @"Девятка", MB_ICONINFORMATION)
				SendMessage(hWin, PM_RENEMYFOOL, 0, 0)
				' Передать ход игроку
				PostMessage(hWin, PM_USERATTACK, 0, 0)
			End If
			
		Case PM_USERATTACK
			' Ход игрока
			If lParam <> False Then
				' Ходить девяткой бубен
				' Запретить ходить пользователю
				PlayerCanPlay = False
				' Удалить карту из массива
				PlayerDeck(wParam).IsUsed = False
				' Пользователь нажал на карту, отправить её на игровое поле
				SendMessage(hWin, PM_USER_DEALCARD, wParam, 0)
				' TODO Передать ход левому игроку
				' PostMessage(hWin, PM_LENEMYATTACK, 0, 0)
			Else
				' Проверить, может ли игрок ходить
				If GetPlayerDealCard(@PlayerDeck(0), @BankDeck(0)) >= 0 Then
					PlayerCanPlay = True
				Else
					' У пользователя нет карт для хода
					MessageBox(hWin, @"Игрок не может ходить", @"Девятка", MB_ICONINFORMATION)
					SendMessage(hWin, PM_USERFOOL, 0, 0)
					' TODO Передать ход левому игроку
					' PostMessage(hWin, PM_LENEMYATTACK, 0, 0)
				End If
			End If
			
		Case PM_LENEMYATTACK
			' Ход левого врага
			If lParam = False Then
				' Определить номер карты, которой можно ходить
				' Если найдена, то установить
				' lParam = True
				' wParam — индекс в массиве карт
				MessageBox(hWin, @"Определяю номер карты левого врага", @"Девятка", MB_ICONINFORMATION)
				Dim CardIndex As Integer = GetPlayerDealCard(@LeftEnemyDeck(0), @BankDeck(0))
				If CardIndex >= 0 Then
					MessageBox(hWin, @"Номер карты положительный", @"Девятка", MB_ICONINFORMATION)
					wParam = CardIndex
					lParam = True
				Else
					lParam = False
				End If
			End If
			If lParam <> False Then
				' В параметре wParam номер карты
				' Удалить карту из массива
				LeftEnemyDeck(wParam).IsUsed = False
				' Отправить карту на поле
				SendMessage(hWin, PM_LENEMY_DEALCARD, wParam, 0)
				' Если на руках карт нет, то победа
				If IsPlayerWin(@LeftEnemyDeck(0)) = False Then
					' Передать ход правому врагу
					PostMessage(hWin, PM_RENEMYATTACK, 0, 0)
				Else
					' Победа
					PostMessage(hWin, PM_LENEMYWIN, 0, 0)
				End If
			Else
				' Левый враг не может ходить
				MessageBox(hWin, @"Левый враг не может ходить", @"Девятка", MB_ICONINFORMATION)
				SendMessage(hWin, PM_LENEMYFOOL, 0, 0)
				' TODO Передать правому врагу
				PostMessage(hWin, PM_RENEMYATTACK, 0, 0)
			End If
			
		Case PM_RENEMYFOOL
			' Взятие денег у правого врага при отсутствии карты для хода
			' TODO Анимация взятия денег
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			RightEnemyMoney.Value -= FFFMoney
			BankMoney.Value += FFFMoney
			
		Case PM_LENEMYFOOL
			' Взятие денег у левого врага при отсутствии карты для хода
			' TODO Анимация взятия денег
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			LeftEnemyMoney.Value -= FFFMoney
			BankMoney.Value += FFFMoney
			
		Case PM_USERFOOL
			' Взятие денег у игрока при отсутствии карты для хода
			' TODO Анимация взятия денег
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			PlayerMoney.Value -= FFFMoney
			BankMoney.Value += FFFMoney
			
		Case PM_RENEMYWIN
			' Правый враг избавился от карт
			' TODO Анимация враг забирает все деньги банка
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			RightEnemyMoney.Value += BankMoney.Value
			BankMoney.Value = 0
			' Начать новый раунд
			' PostMessage(hWin, PM_NEWSTAGE, 0, 0)
			
		Case PM_LENEMYWIN
			' Левый враг положил последнюю карту
			' TODO Анимация враг забирает все деньги банка
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			LeftEnemyMoney.Value += BankMoney.Value
			BankMoney.Value = 0
			' Начать новый раунд
			' PostMessage(hWin, PM_NEWSTAGE, 0, 0)
			
		Case PM_USERWIN
			' Игрок положил последнюю карту
			' TODO Анимация игрок забирает все деньги банка
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			PlayerMoney.Value += BankMoney.Value
			BankMoney.Value = 0
			' Начать новый раунд
			' PostMessage(hWin, PM_NEWSTAGE, 0, 0)
			
		Case PM_RENEMY_DEALCARD
			' Правый враг кидает карту на поле
			' TODO Анимация броска карты правого врага
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			' Сделать карту видимой на поле
			BankDeck(RightEnemyDeck(wParam).CardSortNumber).IsUsed = True
			
		Case PM_LENEMY_DEALCARD
			' Левый враг кидает карту на поле
			' TODO Анимация броска карты левого врага
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			' Сделать карту видимой на поле
			BankDeck(LeftEnemyDeck(wParam).CardSortNumber).IsUsed = True
			
		Case PM_USER_DEALCARD
			' Игрок кидает карту на поле
			' wParam содержит индекс в массиве карт
			' Начальная точка
			PlayerDealCardAnimationPointStart.X = PlayerDeck(wParam).X
			PlayerDealCardAnimationPointStart.Y = PlayerDeck(wParam).Y
			' Конечная точка
			PlayerDealCardAnimationCardSortNumber = PlayerDeck(wParam).CardSortNumber
			' Приращение аргумента
			PlayerDealCardAnimationCardIncrementX = Abs((BankDeck(PlayerDealCardAnimationCardSortNumber).X - PlayerDeck(wParam).X) \ 25)
			PlayerDealCardAnimationCardIncrementY = Abs((BankDeck(PlayerDealCardAnimationCardSortNumber).Y - PlayerDeck(wParam).Y) \ 25)
			' Запустить таймер
			SetTimer(hWin, PlayerDealCardTimerId, TimerElapsedTime, NULL)
			
		Case Else
			Return DefWindowProc(hWin, wMsg, wParam, lParam)    
	End Select
	Return 0
End Function
