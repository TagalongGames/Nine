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
	Dim Value As Integer
	
	Dim X As Integer
	Dim Y As Integer
End Type

' Игрок может кидать карты на стол
Declare Function PlayerCanDealCard(ByVal pc As PlayerCard Ptr, ByVal bp As PlayerCard Ptr)As Boolean

' Создание и перемешивание массива
Declare Sub ShuffleArray(ByVal a As Integer Ptr, ByVal length As Integer)

' Возвращает номер карты для отображения
Declare Function GetCardNumber(ByVal CardSortNumber As Integer)As Integer
