#include once "ThreadProc.bi"
#include once "Irc.bi"

Function ThreadProc(ByVal lpParam As LPVOID)As DWORD
	Dim objClient As IrcClient Ptr = CPtr(IrcClient Ptr, lpParam)
	
	Dim strReceiveBuffer As WString * (IrcClient.MaxBytesCount + 1) = Any
	Return 0
End Function
