#include "PlayerCard.bi"
#include "Cards.bi"

#include "windows.bi"

Function GetPlayerDealCard(ByVal pc as PlayerCard Ptr, ByVal bp As PlayerCard Ptr)As Integer
	' TODO Правильная стратегия выбора карты
	If bp[3].IsUsed Then
		Scope
			' Выбрать младшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 2
			Do While bp[CardSortNumber].IsUsed
				CardSortNumber -= 1
				If CardSortNumber = 0 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			For i As Integer = 0 To 11
				If pc[i].IsUsed Then
					If pc[i].CardSortNumber = CardSortNumber Then
						Return i
					End If
				End If
			Next
		End Scope
		
		Scope
			' Выбрать старшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 4
			Do While bp[CardSortNumber].IsUsed
				CardSortNumber += 1
				If CardSortNumber = 8 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			For i As Integer = 0 To 11
				If pc[i].IsUsed Then
					If pc[i].CardSortNumber = CardSortNumber Then
						Return i
					End If
				End If
			Next
		End Scope
	End If
	
	If bp[12].IsUsed Then
		Scope
			' Выбрать младшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 11
			Do While bp[CardSortNumber].IsUsed
				CardSortNumber -= 1
				If CardSortNumber = 9 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			For i As Integer = 0 To 11
				If pc[i].IsUsed Then
					If pc[i].CardSortNumber = CardSortNumber Then
						Return i
					End If
				End If
			Next
		End Scope
		
		Scope
			' Выбрать старшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 13
			Do While bp[CardSortNumber].IsUsed
				CardSortNumber += 1
				If CardSortNumber = 17 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			For i As Integer = 0 To 11
				If pc[i].IsUsed Then
					If pc[i].CardSortNumber = CardSortNumber Then
						Return i
					End If
				End If
			Next
		End Scope
	End If
	
	If bp[21].IsUsed Then
		Scope
			' Выбрать младшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 20
			Do While bp[CardSortNumber].IsUsed
				CardSortNumber -= 1
				If CardSortNumber = 18 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			For i As Integer = 0 To 11
				If pc[i].IsUsed Then
					If pc[i].CardSortNumber = CardSortNumber Then
						Return i
					End If
				End If
			Next
		End Scope
		
		Scope
			' Выбрать старшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 22
			Do While bp[CardSortNumber].IsUsed
				CardSortNumber += 1
				If CardSortNumber = 26 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			For i As Integer = 0 To 11
				If pc[i].IsUsed Then
					If pc[i].CardSortNumber = CardSortNumber Then
						Return i
					End If
				End If
			Next
		End Scope
	End If
	
	If bp[30].IsUsed Then
		Scope
			' Выбрать младшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 29
			Do While bp[CardSortNumber].IsUsed
				CardSortNumber -= 1
				If CardSortNumber = 27 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			For i As Integer = 0 To 11
				If pc[i].IsUsed Then
					If pc[i].CardSortNumber = CardSortNumber Then
						Return i
					End If
				End If
			Next
		End Scope
		Scope
			' Выбрать старшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 31
			Do While bp[CardSortNumber].IsUsed
				CardSortNumber += 1
				If CardSortNumber = 35 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			For i As Integer = 0 To 11
				If pc[i].IsUsed Then
					If pc[i].CardSortNumber = CardSortNumber Then
						Return i
					End If
				End If
			Next
		End Scope
	End If
	
	' Девятки в последнюю очередь
	For i As Integer = 0 To 11
		If pc[i].IsUsed <> False Then
			Select Case pc[i].CardNumber
				Case Faces.Nine * 4 + Suits.Clubs
					Return i
				Case Faces.Nine * 4 + Suits.Diamond
					Return i
				Case Faces.Nine * 4 + Suits.Hearts
					Return i
				Case Faces.Nine * 4 + Suits.Spades
					Return i
			End Select
		End If
	Next
	
	Return -1
End Function

Function GetNinePlayerNumber(ByVal RightDeck As PlayerCard Ptr, ByVal PlayerDeck As PlayerCard Ptr, ByVal LeftDeck As PlayerCard Ptr)As CharacterWithNine
	For i As Integer = 0 To 11
		If RightDeck[i].CardNumber = Faces.Nine * 4 + Suits.Diamond Then
			Dim cn As CharacterWithNine = Any
			cn.Character = Characters.RightCharacter
			cn.NineIndex = i
			Return cn
		End If
	Next
	For i As Integer = 0 To 11
		If PlayerDeck[i].CardNumber = Faces.Nine * 4 + Suits.Diamond Then
			Dim cn As CharacterWithNine = Any
			cn.Character = Characters.Player
			cn.NineIndex = i
			Return cn
		End If
	Next
	For i As Integer = 0 To 11
		If LeftDeck[i].CardNumber = Faces.Nine * 4 + Suits.Diamond Then
			Dim cn As CharacterWithNine = Any
			cn.Character = Characters.LeftCharacter
			cn.NineIndex = i
			Return cn
		End If
	Next
End Function
/'
Function GetClickPlayerCardNumber(ByVal pc As PlayerCard Ptr, ByVal X As Integer, ByVal Y As Integer)As Integer
	Dim pt As POINT = Any
	With pt
		.x = X
		.y = Y
	End With
	For i As Integer = 0 To 11
		Dim CardRect As RECT = Any
		SetRect(@CardRect, pc[i].X, pc[i].Y, pc[i].X + DefautlCardWidth, pc[i].Y + DefautlCardHeight)
		If PtInRect(@CardRect, pt) <> 0 Then
			Return i
		End If
	Next
	Return -1
End Function
'/
Function IsPlayerWin(ByVal pc As PlayerCard Ptr)As Boolean
	For i As Integer = 0 To 11
		If pc[i].IsUsed <> False Then
			Return False
		End If
	Next
	Return True
End Function

Function ValidatePlayerCardNumber(ByVal PlayerCardSortNumber As Integer, ByVal BankPack As PlayerCard Ptr)As Boolean
	Select Case PlayerCardSortNumber
		Case 3
			If BankPack[3].IsUsed Then
				Return False
			Else
				Return True
			End If
		Case 12
			If BankPack[12].IsUsed Then
				Return False
			Else
				Return True
			End If
		Case 21
			If BankPack[21].IsUsed Then
				Return False
			Else
				Return True
			End If
		Case 30
			If BankPack[30].IsUsed Then
				Return False
			Else
				Return True
			End If
	End Select
	
	If BankPack[3].IsUsed Then
		Scope
			' Выбрать младшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 2
			Do While BankPack[CardSortNumber].IsUsed
				CardSortNumber -= 1
				If CardSortNumber = 0 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
		End Scope
		Scope
			' Выбрать старшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 4
			Do While BankPack[CardSortNumber].IsUsed
				CardSortNumber += 1
				If CardSortNumber = 8 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
		End Scope
	End If
	
	If BankPack[12].IsUsed Then
		Scope
			' Выбрать младшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 11
			Do While BankPack[CardSortNumber].IsUsed
				CardSortNumber -= 1
				If CardSortNumber = 9 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
		End Scope
		Scope
			' Выбрать старшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 13
			Do While BankPack[CardSortNumber].IsUsed
				CardSortNumber += 1
				If CardSortNumber = 17 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
		End Scope
	End If
	
	If BankPack[21].IsUsed Then
		Scope
			' Выбрать младшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 20
			Do While BankPack[CardSortNumber].IsUsed
				CardSortNumber -= 1
				If CardSortNumber = 18 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
		End Scope
		Scope
			' Выбрать старшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 22
			Do While BankPack[CardSortNumber].IsUsed
				CardSortNumber += 1
				If CardSortNumber = 26 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
		End Scope
	End If
	
	If BankPack[30].IsUsed Then
		Scope
			' Выбрать младшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 29
			Do While BankPack[CardSortNumber].IsUsed
				CardSortNumber -= 1
				If CardSortNumber = 27 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
		End Scope
		Scope
			' Выбрать старшее пустое место в ряду мастей на поле
			Dim CardSortNumber As Integer = 31
			Do While BankPack[CardSortNumber].IsUsed
				CardSortNumber += 1
				If CardSortNumber = 35 Then
					Exit Do
				End If
			Loop
			' Проверить, есть ли у игрока такая карта
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
		End Scope
	End If
	
	Return False
End Function

Sub ShuffleArray(ByVal a As Integer Ptr, ByVal length As Integer)
	For i As Integer = 0 To length - 1
		a[i] = i
	Next
	For i As Integer = length - 1 To 1 Step -1
		Dim j As Integer = rand() Mod (i + 1)
		' Обменять номер текущей ячейки с полученным
		Dim t As Integer = a[i]
		a[i] = a[j]
		a[j] = t
	Next
End Sub

Function GetCardNumber(ByVal CardSortNumber As Integer)As Integer
	Dim arr(35) As Integer = _
	{ _
		Faces.Six * 4 + Suits.Diamond, _
		Faces.Seven * 4 + Suits.Diamond, _
		Faces.Eight * 4 + Suits.Diamond, _
		Faces.Nine * 4 + Suits.Diamond, _
		Faces.Ten * 4 + Suits.Diamond, _
		Faces.Jack * 4 + Suits.Diamond, _
		Faces.Queen * 4 + Suits.Diamond, _
		Faces.King * 4 + Suits.Diamond, _
		Faces.Ace * 4 + Suits.Diamond, _
		Faces.Six * 4 + Suits.Clubs, _
		Faces.Seven * 4 + Suits.Clubs, _
		Faces.Eight * 4 + Suits.Clubs, _
		Faces.Nine * 4 + Suits.Clubs, _
		Faces.Ten * 4 + Suits.Clubs, _
		Faces.Jack * 4 + Suits.Clubs, _
		Faces.Queen * 4 + Suits.Clubs, _
		Faces.King * 4 + Suits.Clubs, _
		Faces.Ace * 4 + Suits.Clubs, _
		Faces.Six * 4 + Suits.Hearts, _
		Faces.Seven * 4 + Suits.Hearts, _
		Faces.Eight * 4 + Suits.Hearts, _
		Faces.Nine * 4 + Suits.Hearts, _
		Faces.Ten * 4 + Suits.Hearts, _
		Faces.Jack * 4 + Suits.Hearts, _
		Faces.Queen * 4 + Suits.Hearts, _
		Faces.King * 4 + Suits.Hearts, _
		Faces.Ace * 4 + Suits.Hearts, _
		Faces.Six * 4 + Suits.Spades, _
		Faces.Seven * 4 + Suits.Spades, _
		Faces.Eight * 4 + Suits.Spades, _
		Faces.Nine * 4 + Suits.Spades, _
		Faces.Ten * 4 + Suits.Spades, _
		Faces.Jack * 4 + Suits.Spades, _
		Faces.Queen * 4 + Suits.Spades, _
		Faces.King * 4 + Suits.Spades, _
		Faces.Ace * 4 + Suits.Spades _
	}
	Return arr(CardSortNumber)
End Function

Sub SortCharacterPack(ByVal pc As PlayerCard Ptr)
	For j As Integer = 0 To 11 - 1
		For i As Integer = 0 To 11 - 1 - j
			If pc[i].CardSortNumber > pc[i + 1].CardSortNumber Then
				' Обменять
				Scope
					Dim t As Integer = pc[i].CardSortNumber
					pc[i].CardSortNumber = pc[i + 1].CardSortNumber
					pc[i + 1].CardSortNumber = t
				End Scope
				Scope
					Dim t As Integer = pc[i].CardNumber
					pc[i].CardNumber = pc[i + 1].CardNumber
					pc[i + 1].CardNumber = t
				End Scope
			End If
		Next
	Next
End Sub

Function GetBankCardNumberAnimateDealCard(ByVal CardSortNumber As Integer)As Integer
	Dim arr(35) As Integer = _
	{ _
		35, 34, 33, 32, 31, 30, 29, 28, 27, _
		18, 19, 20, 21, 22, 23, 24, 25, 26, _
		17, 16, 15, 14, 13, 12, 11, 10, 09, _
		0, 1, 2, 3, 4, 5, 6, 7, 8 _
	}
	Return arr(CardSortNumber)
End Function
