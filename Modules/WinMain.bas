#include "WinMain.bi"
#include "win\commctrl.bi"
#include "MainFormWndProc.bi"
#include "Resources.RH"
#include "DisplayError.bi"
#include "CardControl.bi"

Const BackColor As Integer = &h006400
Const MainWindowClassName = "MainWindow"

Function wWinMain( _
		Byval hInst As HINSTANCE, _
		ByVal hPrevInstance As HINSTANCE, _
		ByVal lpCmdLine As LPWSTR, _
		ByVal iCmdShow As Long _
	)As Long
	
	Dim NineWindowTitle As WString * 256 = Any
	LoadString(hInst, IDS_WINDOWTITLE, @NineWindowTitle, 255)
	
	Dim icc As INITCOMMONCONTROLSEX = Any
	icc.dwSize = SizeOf(INITCOMMONCONTROLSEX)
	icc.dwICC = ICC_ANIMATE_CLASS Or _
		ICC_BAR_CLASSES Or _
		ICC_COOL_CLASSES Or _
		ICC_DATE_CLASSES Or _
		ICC_HOTKEY_CLASS Or _
		ICC_INTERNET_CLASSES Or _
		ICC_LINK_CLASS Or _
		ICC_LISTVIEW_CLASSES Or _
		ICC_NATIVEFNTCTL_CLASS Or _
		ICC_PAGESCROLLER_CLASS Or _
		ICC_PROGRESS_CLASS Or _
		ICC_STANDARD_CLASSES Or _
		ICC_TAB_CLASSES Or _
		ICC_TREEVIEW_CLASSES Or _
		ICC_UPDOWN_CLASS Or _
		ICC_USEREX_CLASSES Or _
	ICC_WIN95_CLASSES
	
	If InitCommonControlsEx(@icc) = False Then
		DisplayError(GetLastError(), "Failed to register Common Controls")
		Return 1
	End If
	
	' If InitCardControl() = False Then
		' DisplayError(GetLastError(), "Failed to register CardControl")
		' Return 1
	' End If
	
	Dim hAccel As HACCEL = LoadAccelerators(hInst, Cast(WString Ptr, ID_ACCEL))
	If hAccel = NULL Then
		DisplayError(GetLastError(), "Failed to load Accelerators")
		Return 1
	End If
	
	Dim BackColorBrush As HBRUSH = CreateSolidBrush(BackColor)
	If BackColorBrush = NULL Then
		DisplayError(GetLastError(), "Failed to create BackColorBrush")
		Return 1
	End If
	
	Dim wcls As WNDCLASSEX = Any
	With wcls
		.cbSize        = SizeOf(WNDCLASSEX)
		.style         = CS_HREDRAW Or CS_VREDRAW
		.lpfnWndProc   = @MainFormWndProc
		.cbClsExtra    = 0
		.cbWndExtra    = 0
		.hInstance     = hInst
		.hIcon         = LoadIcon(hInst, Cast(WString Ptr, IDR_ICON))
		.hCursor       = LoadCursor(NULL, IDC_ARROW)
		.hbrBackground = BackColorBrush
		.lpszMenuName  = Cast(WString Ptr, IDM_MENU)
		.lpszClassName = @MainWindowClassName
		.hIconSm       = NULL
	End With
	
	If RegisterClassEx(@wcls) = FALSE Then
		DisplayError(GetLastError(), "Failed to register WNDCLASSEX")
		Return 1
	End If
	
	Dim hWndMain As HWND = CreateWindowEx( _
		WS_EX_OVERLAPPEDWINDOW, _
		@MainWindowClassName, _
		@NineWindowTitle, _
		WS_OVERLAPPEDWINDOW Or WS_CLIPCHILDREN, _
		CW_USEDEFAULT, _
		CW_USEDEFAULT, _
		CW_USEDEFAULT, _
		CW_USEDEFAULT, _
		NULL, _
		NULL, _
		hInst, _
		NULL _
	)
	If hWndMain = NULL Then
		DisplayError(GetLastError(), "Failed to create Main Window")
		Return 1
	End If
	
	ShowWindow(hWndMain, iCmdShow)
	UpdateWindow(hWndMain)
	
	Dim wMsg As MSG = Any
	Dim GetMessageResult As Integer = GetMessage(@wMsg, NULL, 0, 0)
	
	Do While GetMessageResult <> 0
		
		If GetMessageResult = -1 Then
			
			DisplayError(GetLastError(), "Error in GetMessage")
			Return 1
			
		Else
			
			If TranslateAccelerator(hWndMain, hAccel, @wMsg) = 0 Then
				
				' If IsDialogMessage(hWndMain, @wMsg) = 0 Then
					
					TranslateMessage(@wMsg)
					DispatchMessage(@wMsg)
					
				' End If
				
			End If
			
		End If
		
		GetMessageResult = GetMessage(@wMsg, NULL, 0, 0)
		
	Loop
	
	Return wMsg.wParam
	
End Function
