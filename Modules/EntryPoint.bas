#include "EntryPoint.bi"
#include "WinMain.bi"

#ifdef WITHOUT_RUNTIME
Function EntryPoint Alias "EntryPoint"()As Integer
#endif
	
	Dim RetCode As Long = wWinMain( _
		GetModuleHandle(0), _
		NULL, _
		GetCommandLine(), _
		SW_SHOW _
	)
	
	#ifdef WITHOUT_RUNTIME
		Return RetCode
	#else
		End(RetCode)
	#endif
	
#ifdef WITHOUT_RUNTIME
End Function
#endif
