#include once "Nine.bi"
#include once "WndProc.bi"
#include once "Nine.rh"
#include once "IntegerToWString.bi"

Const MainWindowClassName = "Девятка"

Dim Shared hInst As HMODULE

#ifdef withoutrtl
Function EntryPoint Alias "EntryPoint"()As Integer
#endif
	hInst = GetModuleHandle(0)
	
	Dim NineWindowTitle As WString * 256 = Any
	LoadString(hInst, IDS_WINDOWTITLE, @NineWindowTitle, 255)
	
	Dim hAccel As HACCEL = LoadAccelerators(hInst, Cast(WString Ptr, ID_ACCEL))
	
	Dim wcls As WNDCLASSEX = Any
	With wcls
		.cbSize = SizeOf(WNDCLASSEX)
		.style         = CS_HREDRAW Or CS_VREDRAW
		.lpfnWndProc   = @WndProc
		.cbClsExtra    = 0
		.cbWndExtra    = 0
		.hInstance     = hInst
		.hIcon         = LoadIcon(hInst, Cast(WString Ptr, IDR_ICON))
		.hCursor       = LoadCursor(NULL, IDC_ARROW)
		.hbrBackground = GetStockObject(WHITE_BRUSH)
		.lpszMenuName  = Cast(WString Ptr, IDM_MENU)
		.lpszClassName = @MainWindowClassName
		.hIconSm = LoadImage(hInst, _
			MAKEINTRESOURCE(5), _
			IMAGE_ICON, _
			GetSystemMetrics(SM_CXSMICON), _
			GetSystemMetrics(SM_CYSMICON), _
			LR_DEFAULTCOLOR)
	End With
	
	If RegisterClassEx(@wcls) = FALSE Then
		MessageBox(0, "Failed to register wcls", @NineWindowTitle, MB_ICONERROR)
#ifdef withoutrtl
		Return 1
#else
		End(1)
#endif
	End If
	
	Dim hWndMain As HWND = CreateWindowEx(0, @MainWindowClassName, _
		NineWindowTitle, _
		WS_OVERLAPPEDWINDOW, _
		CW_USEDEFAULT, _
		CW_USEDEFAULT, _
		CW_USEDEFAULT, _
		CW_USEDEFAULT, _
		NULL, _
		NULL, _
		hInst, _
		NULL)
	
	' ShowWindow(hWndMain, SW_NORMAL)
	ShowWindow(hWndMain, SW_MAXIMIZE)
	UpdateWindow(hWndMain)
	
	Dim wMsg As MSG = Any
	Dim bRet As Integer = GetMessage(@wMsg, NULL, 0, 0)
	Do While bRet <> 0
		If bRet = -1 Then
			' Ошибка
			Dim ErrorCode As Integer = GetLastError()
			Dim Buffer As WString * 100 = Any
			itow(ErrorCode, @Buffer, 10)
			MessageBox(0, @Buffer, @"Ошибка", MB_ICONERROR)
			Exit Do
		Else
			If TranslateAccelerator(hWndMain, hAccel, @wMsg) = 0 Then
				TranslateMessage(@wMsg)
				DispatchMessage(@wMsg)
			End If
		End If
		bRet = GetMessage(@wMsg, NULL, 0, 0)
	Loop
	
#ifdef withoutrtl
	Return wMsg.WPARAM
End Function
#else
	End(wMsg.WPARAM)
#endif
