#include once "WndProc.bi"
#include once "Cards.bi"

' Ширина и высота карты
Dim Shared mintWidth As Integer
Dim Shared mintHeight As Integer
' Игра идёт
Dim Shared GameIsRunning As Boolean
' Рисование
Dim Shared DarkGreenBrush As HBRUSH
Dim Shared YellowPen As HBRUSH

Function WndProc(ByVal hWin As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
	Select Case wMsg
		Case WM_CREATE
			' Инициализация библиотеки
			cdtInit(@mintWidth, @mintHeight)
			DarkGreenBrush = CreateSolidBrush(&h004000)
			YellowPen = CreateSolidBrush(&hFF0000)' CreatePen(PS_SOLID, 1, &hFF0000)
			' Раздаём карты банку
		Case WM_COMMAND
			' События от нажатий кнопок и меню
			Select Case HiWord(wParam)
				Case BN_CLICKED, 1
					Select Case LoWord(wParam)
						Case 10001
							' Новая игра
							' Нужно проверить, идёт ли сейчас игра
							If GameIsRunning Then
								' Игра идёт
								' Спросить у пользователя
								' желает ли он прервать текущую игру
								' Dim WarningMsg As WString *256
								' LoadString(hInst, IDS_NEWGAMEWARNING, WarningMsg, 256)
								' Dim intResult As Integer = MessageBox(hWin, WarningMsg, strTitle, MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2)
								' If intResult = IDYES Then
									' Начинаем заново
									REM NewGame()
								' End If
							Else
								' Начинаем новую игру
								GameIsRunning = True
								UpdateWindow(hWin)
								REM NewGame()
							End If
						Case 10002
							' Выход
							DestroyWindow(hWin)
						Case 10101
							' Справка - содержание
						Case 10102
							' Сообщение "О программе"
							' Dim AboutMsg As WString *256
							' LoadString(hInst, IDS_ABOUT, AboutMsg, 256)
							' О программе
							' MessageBox(hWin, AboutMsg, strTitle, MB_OK + MB_ICONINFORMATION)
					End Select
			End Select
		Case WM_LBUTTONDOWN
			' MessageBox(hWin, AboutMsg, strTitle, MB_OK + MB_ICONINFORMATION)
		Case WM_PAINT
			' Рисуем игровое поле
			
			' Координаты центра
			Dim ClientRectangle As RECT = Any
			GetClientRect(hWin, @ClientRectangle)
			Dim cx As Integer = ClientRectangle.right \ 2
			Dim cy As Integer = ClientRectangle.bottom \ 2
			
			Dim pnt As PAINTSTRUCT = Any
			Dim hDC As HDC = BeginPaint(hWin, @pnt)
			
			' Закрасить рабочий стол зелёным цветом
			Dim oldBrush As HBRUSH = SelectObject(hDC, DarkGreenBrush)
			Rectangle(hDC, 0, 0, ClientRectangle.right, ClientRectangle.bottom)
			
			' Смещение относительно центра клиентской области для центрирования карт
			Dim dx As Integer = cx - (mintWidth * 9) \ 2
			Dim dy As Integer = cy - (mintHeight * 4) \ 2
			
			If GameIsRunning Then
				' Нарисовать рамки для карт и те, что уже лежат на столе
				Dim oldPen As HBRUSH = SelectObject(hDC, YellowPen)
				For Y As Integer = 0 To 3
					For X As Integer = 0 To 7
						Rectangle(hDC, X * mintWidth + dx, Y * mintHeight + dy, X * mintWidth + dx + mintWidth, Y * mintHeight + dy + mintHeight)
						' cdtDrawExt(hDC, X * mintWidth + dx, Y * mintHeight + dy, mintWidth, mintHeight, ((Faces.Six + X) * 4) + Y, CardViews.Normal, 0)
					Next
				Next
				' Теперь для тузов
				For Y As Integer = 0 To 3
					Rectangle(hDC, 8 * mintWidth + dx, Y * mintHeight + dy, 8 * mintWidth + dx + mintWidth, Y * mintHeight + dy + mintHeight)
					' cdtDrawExt(hDC, 8 * mintWidth + dx, Y * mintHeight + dy, mintWidth, mintHeight, Y, CardViews.Normal, 0)
				Next
				SelectObject(hDC, oldPen)
			Else
				' Нарисовать все карты на столе
				' Начиная с шестёрки и заканчивая королём
				For Y As Integer = 0 To 3
					For X As Integer = 0 To 7
						cdtDrawExt(hDC, X * mintWidth + dx, Y * mintHeight + dy, mintWidth, mintHeight, ((Faces.Six + X) * 4) + Y, CardViews.Normal, 0)
					Next
				Next
				' Теперь для тузов
				For Y As Integer = 0 To 3
					cdtDrawExt(hDC, 8 * mintWidth + dx, Y * mintHeight + dy, mintWidth, mintHeight, Y, CardViews.Normal, 0)
				Next
			End If
			SelectObject(hDC, oldBrush)
			
			' Карты игрока
			' Карты соперников
			' Деньги игрока, соперников и банка
			' Банк
			' Изображения соперников и банка
			
			EndPaint(hWin, @pnt)
		Case WM_SIZE
			' Перерисовываем окно
			' UpdateWindow(hWin)
		Case WM_CLOSE
			' Пользователь пытается закрыть окно
			' уничтожаем его
			DestroyWindow(hWin)
		Case WM_DESTROY
			' Очистка
			cdtTerm()
			DeleteObject(DarkGreenBrush)
			DeleteObject(YellowPen)
			' Окно уничтожается
			PostQuitMessage(0)
		Case Else
			' Используем функцию по умолчанию
			Return DefWindowProc(hWin, wMsg, wParam, lParam)    
	End Select
	Return 0
End Function
