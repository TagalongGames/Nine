#ifndef CARDCONTROL_BI
#define CARDCONTROL_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"
#include "Cards.bi"

Const CardControlClassName = "CardControl"

' wParam — CardNumber
' lParam — CardViews
Const PM_SETCARDNUMBER As UINT = WM_USER + 0

' Return CardNumber
Const PM_GETCARDNUMBER As UINT = WM_USER + 1

Declare Function InitCardControl()As Integer

#endif
