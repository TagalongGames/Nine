#include once "PlayerCard.bi"
#include once "Cards.bi"

Function PlayerCanDealCard(ByVal pc As PlayerCard Ptr, ByVal bp As PlayerCard Ptr)As Boolean
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
