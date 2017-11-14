#ifndef unicode
#define unicode
#endif
#include once "windows.bi"
#include once "win\shellapi.bi"
#include once "win\commctrl.bi"

Declare Function WinMain( _
		Byval hInst As HINSTANCE, _
		ByVal hPrevInstance As HINSTANCE, _
		ByVal Args As WString Ptr Ptr, _
		ByVal ArgsCount As Integer, _
		ByVal iCmdShow As Integer _
	) As Integer
