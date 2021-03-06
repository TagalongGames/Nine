#ifndef STATISTICSDIALOGPROC_BI
#define STATISTICSDIALOGPROC_BI

#ifndef unicode
#define unicode
#endif

#include "windows.bi"

Type StatisticParams
	Dim WinsCount As DWORD
	Dim FailsCount As DWORD
End Type

Declare Function StatisticsDialogProc( _
	ByVal hwndDlg As HWND, _
	ByVal uMsg As UINT, _
	ByVal wParam As WPARAM, _
	ByVal lParam As LPARAM _
)As INT_PTR

#endif
