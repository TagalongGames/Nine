#ifndef unicode
#define unicode
#endif

#include once "windows.bi"

' Функция,  в которой будет происходить
' Цикл обработки сообщений
Declare Function WndProc(ByVal hWnd As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
