' Карта игрока
Type PlayerCard
	' Карта используется
	Dim IsUsed As Boolean
	
	' Координаты
	Dim X As Integer
	Dim Y As Integer
	Dim Width As Integer
	Dim Height As Integer
	
	' Номер карты для рисования
	Dim CardNumber As Integer
	
	' Порядковый номер карты для сортировки
	' Шестёрки самые младшие, тузы самые старшие
	Dim CardSortNumber As Integer
End Type

' Деньги
Type Money
	Dim Moneys As Integer
	
	Dim X As Integer
	Dim Y As Integer
End Type