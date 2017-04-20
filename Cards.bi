' Виндовые функции работы с картами
Declare Function cdtInit Alias "cdtInit"(ByVal Width As Integer Ptr, ByVal Height As Integer Ptr)As Integer
Declare Function cdtDrawExt Alias "cdtDrawExt"(ByVal hDC As HDC, ByVal X As Integer, ByVal Y As Integer, ByVal dX As Integer, ByVal dY As Integer, ByVal Card As Integer, ByVal Suit As Integer, ByVal Color As DWORD)As Integer
Declare Sub cdtTerm Alias "cdtTerm"()

' Картинки для рубашки
Public Enum Backs
	Crosshatch = 53	' Сетка
	Sky = 54		' Небо
	Mineral = 55		' Минерал
	Fish = 56		' Рыба
	Frog = 57		' Лягушка
	Flower = 58		' Цветок
	Island = 59		' Остров с пальмами
	Squares = 60		' Квадраты
	Magenta = 61		' Фиолетовый узор
	Sanddunes = 62	' Песчаные дюны
	Spaces = 63		' Астронавт
	Lines = 64		' Линии
	Cars = 65		' Машинки
	Unused = 66		' Неиспользуемая карта
	X = 67			' Символ X
	O = 68			' Символ 0
End Enum

'Номинал карты
Public Enum Faces
	Ace = 0		' туз
	Two = 1		' двойка
	Three = 2	' тройка
	Four = 3		' четверка
	Five = 4		' пятерка
	Six = 5		' шестерка
	Seven = 6	' семерка
	Eight = 7	' восьмерка
	Nine  = 8	' девятка
	Ten  = 9	' десятка
	Jack  = 10	' валет
	Queen = 11	' дама
	King = 12	' король
End Enum

' Масти карт
Public Enum Suits
	Clubs = 0		' трефы
	Diamond = 1		' бубны
	Hearts = 2		' черви
	Spades = 3		' пики
End Enum

' Тип отображения карты
Public Enum CardViews
	Normal = 0		' Карта в нормальном виде
	Back = 1			' Рубашка карты
	Invert = 2		' Инвертированная карта
End Enum
