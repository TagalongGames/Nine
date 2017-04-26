#include once "PlayerCard.bi"
#include once "Cards.bi"

Function GetPlayerDealCard(ByVal pc as PlayerCard Ptr, ByVal bp As PlayerCard Ptr)As Integer
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
			cn.Char = Characters.RightCharacter
			cn.NineIndex = i
			Return cn
		End If
	Next
	For i As Integer = 0 To 11
		If PlayerDeck[i].CardNumber = Faces.Nine * 4 + Suits.Diamond Then
			Dim cn As CharacterWithNine = Any
			cn.Char = Characters.Player
			cn.NineIndex = i
			Return cn
		End If
	Next
	For i As Integer = 0 To 11
		If LeftDeck[i].CardNumber = Faces.Nine * 4 + Suits.Diamond Then
			Dim cn As CharacterWithNine = Any
			cn.Char = Characters.LeftCharacter
			cn.NineIndex = i
			Return cn
		End If
	Next
End Function

Function GetClickPlayerCardNumber(ByVal pc As PlayerCard Ptr, ByVal x As Integer, ByVal y As Integer)As Integer
	For i As Integer = 0 To 11
		If x > pc[i].X And x < pc[i].X + pc[i].Width Then
			If y > pc[i].Y And y < pc[i].Y + pc[i].Height Then
				If pc[i].IsUsed <> False Then
					Return i
				End If
			End If
		End If
	Next
	Return -1
End Function

Function IsPlayerWin(ByVal pc As PlayerCard Ptr)As Boolean
	For i As Integer = 0 To 11
		If pc[i].IsUsed <> False Then
			Return False
		End If
	Next
	Return True
End Function

Function ValidatePlayerCardNumber(ByVal PlayerCardSortNumber As Integer, ByVal bp As PlayerCard Ptr)As Boolean
	Select Case PlayerCardSortNumber
		Case 3
			Return True
		Case 12
			Return True
		Case 21
			Return True
		Case 30
			Return True
	End Select
	
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
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
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
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
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
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
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
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
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
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
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
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
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
			If PlayerCardSortNumber = CardSortNumber Then
				Return True
			End If
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
	For i As Integer = length - 1 To 0 Step - 1
		Dim n As Integer = rand() Mod (i + 1)
		' Обменять номер текущей ячейки с полученным
		Dim t As Integer = a[i]
		a[i] = a[n]
		a[n] = t
	Next
End Sub

Function GetCardNumber(ByVal CardSortNumber As Integer)As Integer
	Select Case CardSortNumber
		Case 0
			Return Faces.Six * 4 + Suits.Clubs
		Case 1
			Return Faces.Seven * 4 + Suits.Clubs
		Case 2
			Return Faces.Eight * 4 + Suits.Clubs
		Case 3
			Return Faces.Nine * 4 + Suits.Clubs
		Case 4
			Return Faces.Ten * 4 + Suits.Clubs
		Case 5
			Return Faces.Jack * 4 + Suits.Clubs
		Case 6
			Return Faces.Queen * 4 + Suits.Clubs
		Case 7
			Return Faces.King * 4 + Suits.Clubs
		Case 8
			Return Faces.Ace * 4 + Suits.Clubs
		Case 9
			Return Faces.Six * 4 + Suits.Diamond
		Case 10
			Return Faces.Seven * 4 + Suits.Diamond
		Case 11
			Return Faces.Eight * 4 + Suits.Diamond
		Case 12
			Return Faces.Nine * 4 + Suits.Diamond
		Case 13
			Return Faces.Ten * 4 + Suits.Diamond
		Case 14
			Return Faces.Jack * 4 + Suits.Diamond
		Case 15
			Return Faces.Queen * 4 + Suits.Diamond
		Case 16
			Return Faces.King * 4 + Suits.Diamond
		Case 17
			Return Faces.Ace * 4 + Suits.Diamond
		Case 18
			Return Faces.Six * 4 + Suits.Hearts
		Case 19
			Return Faces.Seven * 4 + Suits.Hearts
		Case 20
			Return Faces.Eight * 4 + Suits.Hearts
		Case 21
			Return Faces.Nine * 4 + Suits.Hearts
		Case 22
			Return Faces.Ten * 4 + Suits.Hearts
		Case 23
			Return Faces.Jack * 4 + Suits.Hearts
		Case 24
			Return Faces.Queen * 4 + Suits.Hearts
		Case 25
			Return Faces.King * 4 + Suits.Hearts
		Case 26
			Return Faces.Ace * 4 + Suits.Hearts
		Case 27
			Return Faces.Six * 4 + Suits.Spades
		Case 28
			Return Faces.Seven * 4 + Suits.Spades
		Case 29
			Return Faces.Eight * 4 + Suits.Spades
		Case 30
			Return Faces.Nine * 4 + Suits.Spades
		Case 31
			Return Faces.Ten * 4 + Suits.Spades
		Case 32
			Return Faces.Jack * 4 + Suits.Spades
		Case 33
			Return Faces.Queen * 4 + Suits.Spades
		Case 34
			Return Faces.King * 4 + Suits.Spades
		Case Else
			Return Faces.Ace * 4 + Suits.Spades
	End Select
End Function
