#ifndef ABOUTDIALOGPROC_BI
#define ABOUTDIALOGPROC_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"

Declare Function AboutDialogProc( _
	ByVal hwndDlg As HWND, _
	ByVal uMsg As UINT, _
	ByVal wParam As WPARAM, _
	ByVal lParam As LPARAM _
)As INT_PTR

#endif
