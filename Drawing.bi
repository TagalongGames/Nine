#ifndef DRAWING_BI
#define DRAWING_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"
#include "PlayerCard.bi"

Declare Sub GetMoneyString( _
	ByVal buffer As WString Ptr, _
	ByVal MoneyValue As Integer, _
	ByVal CharacterName As WString Ptr _
)

#endif
