#include "Drawing.bi"
#include "Cards.bi"
#include "IntegerToWString.bi"

Sub GetMoneyString( _
		ByVal buffer As WString Ptr, _
		ByVal MoneyValue As Integer, _
		ByVal CharacterName As WString Ptr _
	)
	' TODO Отображать валюту по текущим языковым стандартам
	Dim bufferMoney As WString * 256 = Any
	itow(MoneyValue, @bufferMoney, 10)
	
	lstrcpy(buffer, CharacterName)
	lstrcat(Buffer, ": ")
	
	lstrcat(buffer, bufferMoney)
	' lstrcat(buffer, " ")
	
	' lstrcat(buffer, CurrencyChar)
End Sub
