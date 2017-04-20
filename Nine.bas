#include once "Nine.bi"
#include once "WndProc.bi"

#define IDR_ICON			500
#define IDR_MENU			10000
#define IDS_ABOUT			20001
#define IDS_NEWGAMEWARNING	20002
#define IDS_WINDOWTITLE		20003

Const MainWindowClassName = "Девятка"

Declare Function itow cdecl Alias "_itow" (ByVal Value As Integer, ByVal src As WString Ptr, ByVal radix As Integer)As WString Ptr
Declare Function ltow cdecl Alias "_ltow" (ByVal Value As Long, ByVal src As WString Ptr, ByVal radix As Integer)As WString Ptr
Declare Function wtoi cdecl Alias "_wtoi" (ByVal src As WString Ptr)As Integer
Declare Function wtol cdecl Alias "_wtol" (ByVal src As WString Ptr)As Long

Dim Shared hInst As HMODULE

#ifdef withoutrtl
Function EntryPoint Alias "EntryPoint"()As Integer
#endif
	hInst = GetModuleHandle(0)
	
	Dim NineWindowTitle As WString * 256 = Any
	LoadString(hInst, IDS_WINDOWTITLE, @NineWindowTitle, 255)
	
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
		.lpszMenuName  = Cast(WString Ptr, IDR_MENU)
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
	
	ShowWindow(hWndMain, SW_NORMAL)
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
			' If TranslateAccelerator(hWndMain, hAccel, @wMsg) = 0 Then
				TranslateMessage(@wMsg)
				DispatchMessage(@wMsg)
			' End If
		End If
		bRet = GetMessage(@wMsg, NULL, 0, 0)
	Loop
	
#ifdef withoutrtl
	Return 0
End Function
#endif
