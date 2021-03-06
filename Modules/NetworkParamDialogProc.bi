#ifndef NETWORKPARAMDIALOGPROC_BI
#define NETWORKPARAMDIALOGPROC_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"

Const MaxCharsLength As Integer = 255

Type NetworkParams
	Dim ResultCode As Integer
	
	Dim Nick As WString * (MaxCharsLength + 1)
	Dim Server As WString * (MaxCharsLength + 1)
	Dim Port As WString * (MaxCharsLength + 1)
	Dim Channel As WString * (MaxCharsLength + 1)
	Dim LocalAddress As WString * (MaxCharsLength + 1)
	Dim LocalPort As WString * (MaxCharsLength + 1)
End Type

Declare Function NetworkParamDialogProc( _
	ByVal hwndDlg As HWND, _
	ByVal uMsg As UINT, _
	ByVal wParam As WPARAM, _
	ByVal lParam As LPARAM _
)As INT_PTR

#endif
