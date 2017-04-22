#ifndef unicode
#define unicode
#endif
#include once "windows.bi"

Const MainWindowClassName = "Девятка"

' Возвращает номер карты
Declare Function CardNumber(ByVal Suit As Integer, ByVal Face As Integer) As Integer
' Получаем временную колоду
Declare Sub MakePack()
' Начинаем новую игру
Declare Sub NewGame()
Declare Function GetRandom(ByVal Mini As Integer, ByVal Maxi As Integer)As Integer
' Заполнить массив случайными числами
Declare Function FillArray(ByVal Array As Integer Ptr, ByVal ArrayLength As Integer, ByVal MinValue As Integer, ByVal MaxValue As Integer)As Integer


' Идентификатор главного окна
Dim Shared hWndMain As HWND

' Ширина и высота карты
Dim Shared mintWidth As Integer
Dim Shared mintHeight As Integer


' Банк
'Common Shared PlayerBank As Bank Ptr


	REM ' Игрок ходит (определённой картой)
	REM ' Если карта не существует, возвращаем false
	REM ' TODO доделать
	REM Public Function Player.Eject(ByVal Value As Card) As Boolean
		REM ' Если число карт равно нулю, возвращаем FALSE
		REM If intCardsCount = 0 Then
			REM Return FALSE
		REM Else
			REM ' Счётчики
			REM Dim i As Integer
			REM Dim j As Integer
			REM Dim k As Integer
			
			REM ' Алгоритм:
			REM ' Проходим весь массив карт на руках у игрока
			REM ' сравниваем карту, кооторую нужно удалить
			REM ' если есть совпадение, то удаляем и возвращаем TRUE
			REM ' иначе возвращаем False
			REM '
			REM ' Алгоритм удаления карт:
			REM ' Создаём массив карт на 1 меньше чем число карт у игрока
			REM ' Проходим весь массив карт на руках у игрока
			REM For i = 0 To intCardsCount - 1
				
				REM ' Если совпадают масть и ранг карты
				REM If m_Cards(i).Face = Value.Face AndAlso m_Cards(i).Suit = Value.Suit Then
					REM ' Теперь на руках у игрока на одну карту меньше
					REM 'intCardsCount -= 1
					
					REM ' Создаём временную колоду,
					REM ' Куда будем копировать карты
					REM ' (Так как массив начинается с нуля то на 1 меньше чем карт у игрока) 
					REM Dim mTempColoda(intCardsCount - 1) As Card
					
					REM ' Обходим все карты на руках у игрока
					REM For j = 0 To intCardsCount - 1
						
						REM If m_Cards(j).Suit <> Value.Suit OrElse m_Cards(j).Face <> Value.Face Then
							
							REM mTempColoda(k) = m_Cards(j)
							
							REM If m_Cards(j).Face = Value.Face AndAlso m_Cards(j).Suit = Value.Suit Then
								REM 'Throw New Exception("????? ?? ???????!")
							REM End If
							REM k += 1
						REM End If
					REM Next
					
					REM ReDim m_Cards(intCardsCount - 1)
					REM m_Cards = mColoda
					REM Erase mTempColoda
					
					REM Return True
				REM End If
			REM Next
			
		REM EndIf
	REM End Function


REM ' Добавление карты к игроку
REM ' Если это Девятка Бубен значит возаращаем TRUE
REM Public Function Player.AddCard(ByVal Value As Card) As Boolean
	REM ' Увеличиваем число карт у игрока
	REM intCardsCount += 1
	REM ' Именяем массив карт на 1 больше
	REM ' с сохранением
	REM ReDim Preserve m_Cards(intCardsCount - 1)
	REM ' Присваиваем новой карте значение
	REM m_Cards(intCardsCount - 1) = Value
	REM ' Проверяем
	REM If Value.Face = eFace.Nine AndAlso Value.Suit = eSuit.Diamond Then
		REM Return TRUE
	REM Else
		REM Return FALSE
	REM End If
REM End Function


	REM '' ??????????/????????????? ??????
	REM 'Public Property Money() As Integer
	REM '	Get
	REM '		Return Convert.ToInt32(m_Money.Value)
	REM '	End Get
	REM '	Set(ByVal Value As Integer)
	REM '		m_Money.Value = Value
	REM '	End Set
	REM 'End Property