#include once "WndProc.bi"
#include once "Cards.bi"
#include once "win\windowsx.bi"
#include once "GameEvents.bi"
#include once "PlayerCard.bi"
#include once "Nine.rh"
#include once "IntegerToWString.bi"

' Начальные сумы денег у игроков
Const DefaultMoney As Integer = 10
' Количество денег, которое кладётся в банк в начале игры
Const ZZZMoney As Integer = 2
' Количество денег, которое кладётся в банк если у игрока нет карт для хода
Const FFFMoney As Integer = 1

' Ширина и высота карты
Dim Shared mintWidth As Integer
Dim Shared mintHeight As Integer
' Игра идёт
Dim Shared GameIsRunning As Boolean
' Рисование
Dim Shared DarkGreenBrush As HBRUSH
Dim Shared YellowPen As HPEN

' Колода
Dim Shared Deck(35) As PlayerCard
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

' Игрок может кидать карты на стол
Declare Function PlayerCanDealCard()As Boolean

Declare Sub ShuffleArray(ByVal a As Integer Ptr, ByVal length As Integer)

Function PlayerCanDealCard()As Boolean
	Return False
End Function

Sub ShuffleArray(ByVal a As Integer Ptr, ByVal length As Integer)
	For i As Integer = 0 To length - 1
		a[i] = i
	Next
	For i As Integer = length - 1 To 0 Step - 1
		Dim n As Integer = rand() Mod (i + 1)
		' Обменять номер текущей ячейки с полученным
		Dim t As Integer = a[i]
		a[i] = a[n]
		a[n] = t
	Next
End Sub

' Возвращает номер карты для отображения
Function GetCardNumber(ByVal CardSortNumber As Integer)As Integer
	' трефы
	' бубны
	' черви
	' пики
	' Шестёрка, семёрка, восьмёрка, девятка, десятка, валет, дама, король, туз
	If CardSortNumber > 3 Then
		Return CardSortNumber + Faces.Six * 4 + Suits.Clubs - 4
	End If
	Return CardSortNumber
End Function


Function WndProc(ByVal hWin As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
	Select Case wMsg
		Case WM_CREATE
			' Инициализация библиотеки
			cdtInit(@mintWidth, @mintHeight)
			' Размеры карт
			' Размеры карт врагов две трети
			Dim EnemyCardWidth As Integer = (mintWidth * 2 ) \ 3
			Dim EnemyCardHeight As Integer = (mintHeight * 2) \ 3
			For i As Integer = 0 To 11
				' Карты игрока
				PlayerDeck(i).Width = mintWidth
				PlayerDeck(i).Height = mintHeight
				' Карты врагов
				LeftEnemyDeck(i).Width = EnemyCardWidth
				LeftEnemyDeck(i).Height = EnemyCardHeight
				RightEnemyDeck(i).Width = EnemyCardWidth
				RightEnemyDeck(i).Height = EnemyCardHeight
				' Игровое поле
				Deck(i).Width = mintWidth
				Deck(i).Height = mintHeight
				' Карта лежит на рабочем столе
				Deck(i).IsUsed = True
			Next
			For i As Integer = 12 To 35
				Deck(i).Width = mintWidth
				Deck(i).Height = mintHeight
				Deck(i).IsUsed = True
			Next
			
			' Установить номер карты для отображения на игровом поле
			For k As Integer = 0 To 3
				For j As Integer = 0 To 7
					Dim i As Integer = k * 9 + j
					Deck(i).CardNumber = (Faces.Six + j) * 4 + k
				Next
			Next
			' Теперь для тузов
			For k As Integer = 0 To 3
				Dim i As Integer = k * 9 + 8
				Deck(i).CardNumber = Faces.Ace * 4 + k
			Next
			
			DarkGreenBrush = CreateSolidBrush(&h004000)
			YellowPen = CreatePen(PS_SOLID, 1, &h00FFFF)
			
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
								Dim intResult As Integer = MessageBox(0, "Игра уже идёт. Точно остановить?", "Девятка", MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2)
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
			If PlayerCanPlay Then
				Dim x As Integer = GET_X_LPARAM(lParam)
				Dim y As Integer = GET_Y_LPARAM(lParam)
				
				' Распечатать координаты курсора мыши
				' Scope
					' Dim bufX As WString * 256 = Any
					' Dim bufY As WString * 256 = Any
					
					' itow(x, @bufX, 10)
					' MessageBox(0, @bufX, @"Девятка", MB_OK + MB_ICONINFORMATION)
					' itow(y, @bufY, 10)
					' MessageBox(0, @bufY, @"Девятка", MB_OK + MB_ICONINFORMATION)
				' End Scope
				
				' Получить номер карты, на который щёлкнул пользователь
				Dim CardNumber As Integer = -1
				For i As Integer = 0 To 11
					If x > PlayerDeck(i).X And x < PlayerDeck(i).X + PlayerDeck(i).Width Then
						If y > PlayerDeck(i).Y And y < PlayerDeck(i).Y + PlayerDeck(i).Height Then
							If PlayerDeck(i).IsUsed <> False Then
								CardNumber = i
								Exit For
							End If
						End If
					End If
				Next
				
				If CardNumber >= 0 Then
					' Запретить ходить пользователю
					PlayerCanPlay = False
					' Удалить карту из массива
					PlayerDeck(CardNumber).IsUsed = False
					' Пользователь нажал на карту, отправить её на игровое поле
					SendMessage(hWin, PM_USER_DEALCARD, CardNumber, 0)
					' Передать ход левому игроку
					PostMessage(hWin, PM_LENEMYATTACK, 0, 0)
				End If
			End If
			
		Case WM_PAINT
			Dim ClientRectangle As RECT = Any
			GetClientRect(hWin, @ClientRectangle)
			
			' Рисуем игровое поле
			Dim pnt As PAINTSTRUCT = Any
			Dim hDC As HDC = BeginPaint(hWin, @pnt)
			
			' Закрасить рабочий стол зелёным цветом
			Dim oldBrush As HBRUSH = SelectObject(hDC, DarkGreenBrush)
			Dim oldPen As HPEN = SelectObject(hDC, YellowPen)
			Rectangle(hDC, 0, 0, ClientRectangle.right, ClientRectangle.bottom)
			
			' Карты игрока, врагов и игрового поля
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
					
					' Нарисовать только те, что лежат на рабочем столе
					If Deck(i).IsUsed Then
						cdtDrawExt(hDC, Deck(i).X, Deck(i).Y, Deck(i).Width, Deck(i).Height, Deck(i).CardNumber, CardViews.Normal, 0)
					Else
						Rectangle(hDC, Deck(i).X, Deck(i).Y, Deck(i).X + Deck(i).Width, Deck(i).Y + Deck(i).Height)
					End If
				Else
					' Нарисовать рамки карт игроков
					Rectangle(hDC, PlayerDeck(i).X, PlayerDeck(i).Y, PlayerDeck(i).X + PlayerDeck(i).Width, PlayerDeck(i).Y + PlayerDeck(i).Height)
					Rectangle(hDC, LeftEnemyDeck(i).X, LeftEnemyDeck(i).Y, LeftEnemyDeck(i).X + LeftEnemyDeck(i).Width, LeftEnemyDeck(i).Y + LeftEnemyDeck(i).Height)
					Rectangle(hDC, RightEnemyDeck(i).X, RightEnemyDeck(i).Y, RightEnemyDeck(i).X + RightEnemyDeck(i).Width, RightEnemyDeck(i).Y + RightEnemyDeck(i).Height)
					' Нарисовать все карты рабочего стола
					cdtDrawExt(hDC, Deck(i).X, Deck(i).Y, Deck(i).Width, Deck(i).Height, Deck(i).CardNumber, CardViews.Normal, 0)
				End If
			Next
			' Рабочий стол
			For i As Integer = 12 To 35
				If GameIsRunning Then
					' Нарисовать только те, что лежат на рабочем столе
					' Для остальных рамки
					If Deck(i).IsUsed Then
						cdtDrawExt(hDC, Deck(i).X, Deck(i).Y, Deck(i).Width, Deck(i).Height, Deck(i).CardNumber, CardViews.Normal, 0)
					Else
						Rectangle(hDC, Deck(i).X, Deck(i).Y, Deck(i).X + Deck(i).Width, Deck(i).Y + Deck(i).Height)
					End If
				Else
					' Нарисовать все карты
					cdtDrawExt(hDC, Deck(i).X, Deck(i).Y, Deck(i).Width, Deck(i).Height, Deck(i).CardNumber, CardViews.Normal, 0)
				End If
			Next
			
			Dim BkMode As Integer = SetBkMode(hDC, TRANSPARENT)
			
			' Деньги игрока, соперников и банка
			Dim buffer As WString * 256 = Any
			itow(PlayerMoney.Moneys, @buffer, 10)
			TextOut(hDC, PlayerMoney.X, PlayerMoney.Y, @buffer, lstrlen(@buffer))
			
			itow(LeftEnemyMoney.Moneys, @buffer, 10)
			TextOut(hDC, LeftEnemyMoney.X, LeftEnemyMoney.Y, @buffer, lstrlen(@buffer))
			
			itow(RightEnemyMoney.Moneys, @buffer, 10)
			TextOut(hDC, RightEnemyMoney.X, RightEnemyMoney.Y, @buffer, lstrlen(@buffer))
			
			itow(BankMoney.Moneys, @buffer, 10)
			TextOut(hDC, BankMoney.X, BankMoney.Y, @buffer, lstrlen(@buffer))
			
			' Изображения соперников и банка
			
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
			
			' Смещение относительно центра клиентской области для центрирования карт
			Dim dx As Integer = cx - (mintWidth * 9) \ 2
			Dim dy As Integer = cy - (mintHeight * 4) \ 2
			
			' Нарисовать рамки для карт и те, что уже лежат на столе
			For k As Integer = 0 To 3
				For j As Integer = 0 To 7
					Dim i As Integer = k * 9 + j
					Deck(i).X = j * mintWidth + dx
					Deck(i).Y = k * mintHeight + dy
				Next
			Next
			' Теперь для тузов
			For k As Integer = 0 To 3
				Dim i As Integer = k * 9 + 8
				Deck(i).X = 8 * mintWidth + dx
				Deck(i).Y = k * mintHeight + dy
			Next
			
			' Карты игрока
			Dim dxPlayer As Integer = cx - (mintWidth * 12) \ 2
			Dim dyPlayer As Integer = cy + (mintHeight * 5) \ 2
			For i As Integer = 0 To 11
				PlayerDeck(i).X = i * mintWidth + dxPlayer
				PlayerDeck(i).Y = dyPlayer
			Next
			
			' Карты левого врага
			Dim dxEnemyLeft As Integer = cx - (mintWidth * 13) \ 2
			Dim dyEnemyLeft As Integer = cy - (mintHeight * 4) \ 2
			For i As Integer = 0 To 5
				LeftEnemyDeck(i).X = dxEnemyLeft
				LeftEnemyDeck(i).Y = i * ((mintHeight * 2) \ 3) + dyEnemyLeft
			Next
			For i As Integer = 0 To 5
				LeftEnemyDeck(i + 6).X = dxEnemyLeft + (mintWidth * 2) \ 3
				LeftEnemyDeck(i + 6).Y = i * ((mintHeight * 2) \ 3) + dyEnemyLeft
			Next
			
			' Карты правого врага
			Dim dxEnemyRight As Integer = cx + (mintWidth * 10) \ 2
			Dim dyEnemyRight As Integer = cy - (mintHeight * 4) \ 2
			For i As Integer = 0 To 5
				RightEnemyDeck(i).X = dxEnemyRight
				RightEnemyDeck(i).Y = i * ((mintHeight * 2) \ 3) + dyEnemyRight
			Next
			For i As Integer = 0 To 5
				RightEnemyDeck(i + 6).X = dxEnemyRight + (mintWidth * 2) \ 3
				RightEnemyDeck(i + 6).Y = i * ((mintHeight * 2) \ 3) + dyEnemyRight
			Next
			
			' Деньги
			PlayerMoney.X = cx
			PlayerMoney.Y = cy + (mintHeight * 5) \ 2 - 30
			
			LeftEnemyMoney.X = dxEnemyLeft
			LeftEnemyMoney.Y = dyEnemyLeft - 30
			
			RightEnemyMoney.X = dxEnemyRight
			RightEnemyMoney.Y = LeftEnemyMoney.Y
			
			BankMoney.X = cx
			BankMoney.Y = LeftEnemyMoney.Y
			
			
		Case WM_CLOSE
			' Пользователь пытается закрыть окно
			' Если игра уже идёт, то спросить
			' уничтожаем его
			DestroyWindow(hWin)
			
		Case WM_DESTROY
			' Очистка
			DeleteObject(YellowPen)
			DeleteObject(DarkGreenBrush)
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
			
			' Событие взятия суммы у игроков
			SendMessage(hWin, PM_DEALMONEY, 0, 0)
			
			' Событие раздачи колоды карт игрокам
			SendMessage(hWin, PM_DEALPACK, 0, 0)
			
			' Найти того, у кого девятка бубен и сделать сделать его ход
			Dim NineFound As Boolean = False
			For i As Integer = 0 To 11
				If RightEnemyDeck(i).CardNumber = Faces.Nine * 4 + Suits.Diamond Then
					NineFound = True
					PostMessage(hWin, PM_RENEMYATTACK, i, True)
					Exit For
				End If
			Next
			
			If NineFound = False Then
				For i As Integer = 0 To 11
					If PlayerDeck(i).CardNumber = Faces.Nine * 4 + Suits.Diamond Then
						NineFound = True
						PostMessage(hWin, PM_USERATTACK, 0, 0)
						Exit For
					End If
				Next
			End If
			
			' Девятка не найдена у двух персонажей, значит она у третьего
			For i As Integer = 0 To 11
				If LeftEnemyDeck(i).CardNumber = Faces.Nine * 4 + Suits.Diamond Then
					PostMessage(hWin, PM_LENEMYATTACK, i, True)
					Exit For
				End If
			Next
			
			RedrawWindow(hWin, NULL, NULL, RDW_INVALIDATE)
			
		Case PM_DEFAULTMONEY
			' Событие восстановления денег
			' TODO Анимация восстановления денег
			PlayerMoney.Moneys = DefaultMoney
			LeftEnemyMoney.Moneys = DefaultMoney
			RightEnemyMoney.Moneys = DefaultMoney
			BankMoney.Moneys = 0
			
		Case PM_DEALMONEY
			' Взятие денег у персонажей
			' TODO Анимация взятия денег у игроков
			PlayerMoney.Moneys -= ZZZMoney
			LeftEnemyMoney.Moneys -= ZZZMoney
			RightEnemyMoney.Moneys -= ZZZMoney
			BankMoney.Moneys = 3 * ZZZMoney
			' Если у игрока ноль или отрицательная сумма, то он проиграл
			
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
				Deck(i).IsUsed = False
			Next
			
		Case PM_RENEMYATTACK
			' Ход правого врага
			If lParam = True Then
				' В параметре wParam номер карты
				' Удалить карту из массива
				RightEnemyDeck(wParam).IsUsed = False
			Else
				' Номер карты определить самостоятельно
				' Если найдена, то
				' lParam = True
			End If
			If lParam <> False Then
				' Отправить карту на поле
				SendMessage(hWin, PM_RENEMY_DEALCARD, wParam, 0)
				' Если на руках карт нет, то победа
				Dim WinFlag As Boolean = True
				For i As Integer = 0 To 11
					If RightEnemyDeck(i).IsUsed <> False Then
						WinFlag = False
						Exit For
					End If
				Next
				If WinFlag = False Then
					' Передать ход игроку
					PostMessage(hWin, PM_USERATTACK, 0, 0)
				Else
					PostMessage(hWin, PM_RENEMYWIN, 0, 0)
				End If
			Else
				' Правый враг не может ходить
				SendMessage(hWin, PM_RENEMYFOOL, 0, 0)
				' Передать ход игроку
				PostMessage(hWin, PM_USERATTACK, 0, 0)
			End If
			
		Case PM_USERATTACK
			' Ход игрока
			' Проверить, может ли игрок ходить
			If PlayerCanDealCard() Then
				PlayerCanPlay = True
			Else
				' У пользователя нет карт для хода
				' Забрать деньги
				PostMessage(hWin, PM_USERFOOL, 0, 0)
			End If
			
		Case PM_LENEMYATTACK
			' Ход левого врага
			
		Case PM_RENEMYFOOL
			' Взятие денег у правого врага при отсутствии карты для хода
			' TODO Анимация взятия денег
			
		Case PM_LENEMYFOOL
			' Взятие денег у левого врага при отсутствии карты для хода
			' TODO Анимация взятия денег
			
		Case PM_USERFOOL
			' Взятие денег у игрока при отсутствии карты для хода
			' TODO Анимация взятия денег
			' Передать ход левому врагу
			
		Case PM_RENEMYWIN
			' Правый враг избавился от карт
			' TODO Анимация враг забирает все деньги банка
			
		Case PM_LENEMYWIN
			' Левый враг положил последнюю карту
			' TODO Анимация враг забирает все деньги банка
			
		Case PM_USERWIN
			' Игрок положил последнюю карту
			' TODO Анимация игрок забирает все деньги банка
			
		Case PM_RENEMY_DEALCARD
			' Правый враг кидает карту на поле
			' TODO Анимация броска карты правого врага
			' Сделать карту видимой на поле
			
		Case PM_LENEMY_DEALCARD
			' Левый враг кидает карту на поле
			' TODO Анимация броска карты левого врага
			' Сделать карту видимой на поле
			
		Case PM_USER_DEALCARD
			' Игрок кидает карту на поле
			' TODO Анимация броска карты игрока
			' Сделать карту видимой на поле
			
		Case Else
			Return DefWindowProc(hWin, wMsg, wParam, lParam)    
	End Select
	Return 0
End Function
