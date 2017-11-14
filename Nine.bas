#include once "Nine.bi"
#include once "WndProc.bi"
#include once "Nine.rh"
#include once "IntegerToWString.bi"

Const MainWindowClassName = "Девятка"

#ifdef withoutrtl

Function EntryPoint Alias "EntryPoint"()As Integer
	Dim ArgsCount As DWORD = Any
	Dim Args As WString Ptr Ptr = CommandLineToArgvW(GetCommandLine(), @ArgsCount)
	Dim WinMainResult As Integer = WinMain(GetModuleHandle(0), NULL, Args, CInt(ArgsCount), SW_MAXIMIZE)
	LocalFree(Args)
	Return WinMainResult
End Function

#else
	
	Dim ArgsCount As DWORD = Any
	Dim Args As WString Ptr Ptr = CommandLineToArgvW(GetCommandLine(), @ArgsCount)
	Dim WinMainResult As Integer = WinMain(GetModuleHandle(0), NULL, Args, CInt(ArgsCount), SW_MAXIMIZE)
	LocalFree(Args)
	End(WinMainResult)
	
#endif

Function WinMain( _
		Byval hInst As HINSTANCE, _
		ByVal hPrevInstance As HINSTANCE, _
		ByVal Args As WString Ptr Ptr, _
		ByVal ArgsCount As Integer, _
		ByVal iCmdShow As Integer _
	) As Integer
	
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
		Dim ErrorCode As Integer = GetLastError()
		Dim Buffer As WString * 100 = Any
		itow(ErrorCode, @Buffer, 10)
		MessageBox(0, @Buffer, "Failed to register InitCommonControlsEx", MB_ICONERROR)
		Return 1
	End If
	
	Dim hAccel As HACCEL = LoadAccelerators(hInst, Cast(WString Ptr, ID_ACCEL))
	
	Dim wcls As WNDCLASSEX = Any
	With wcls
		.cbSize        = SizeOf(WNDCLASSEX)
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
		.hIconSm       = LoadImage(hInst, _
			MAKEINTRESOURCE(5), _
			IMAGE_ICON, _
			GetSystemMetrics(SM_CXSMICON), _
			GetSystemMetrics(SM_CYSMICON), _
			LR_DEFAULTCOLOR)
	End With
	
	If RegisterClassEx(@wcls) = FALSE Then
		Dim ErrorCode As Integer = GetLastError()
		Dim Buffer As WString * 100 = Any
		itow(ErrorCode, @Buffer, 10)
		MessageBox(0, @Buffer, "Failed to register WNDCLASSEX", MB_ICONERROR)
		Return 1
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
	
	ShowWindow(hWndMain, iCmdShow)
	UpdateWindow(hWndMain)
	
	Dim wMsg As MSG = Any
	Dim bRet As Integer = GetMessage(@wMsg, NULL, 0, 0)
	Do While bRet <> 0
		If bRet = -1 Then
			Dim ErrorCode As Integer = GetLastError()
			Dim Buffer As WString * 100 = Any
			itow(ErrorCode, @Buffer, 10)
			MessageBox(0, @Buffer, @"Ошибка в функции GetMessage", MB_ICONERROR)
			Exit Do
		Else
			If TranslateAccelerator(hWndMain, hAccel, @wMsg) = 0 Then
				TranslateMessage(@wMsg)
				DispatchMessage(@wMsg)
			End If
		End If
		bRet = GetMessage(@wMsg, NULL, 0, 0)
	Loop
	
	Return wMsg.WPARAM
End Function
