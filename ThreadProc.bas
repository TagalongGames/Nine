#include once "ThreadProc.bi"
#include once "Irc.bi"

Function ThreadProc(ByVal lpParam As LPVOID)As DWORD
	Dim objClient As IrcClient Ptr = CPtr(IrcClient Ptr, lpParam)
	
	Dim strReceiveBuffer As WString * (IrcClient.MaxBytesCount + 1) = Any
	'Dim intResult As ResultType = Any
	
	' Бесконечный цикл получения данных от сервера до тех пор, пока не будет ошибок
	'Do
	'	intResult = objClient->ReceiveData(@strReceiveBuffer)
	'	intResult = objClient->ParseData(@strReceiveBuffer)
	'Loop While intResult = ResultType.None
	' Закрыть
	objClient->CloseIrc()
	Return 0
End Function
