#include "SimpleDebug.bi"

#ifndef unicode
#define unicode
#endif

#include "windows.bi"
#include "IntegerToWString.bi"

Function DebugMessageBoxValue( _
		ByVal Value As LongInt, _
		ByVal pCaption As WString Ptr _
	)As Integer
	
	Dim Buffer As WString * (255 + 1) = Any
	i64tow(Value, @Buffer, 10)
	
	Return MessageBox(NULL, Buffer, pCaption, MB_OK)
	
End Function

Function DebugMessageBoxArray( _
		ByVal pArray As Integer Ptr, _
		ByVal Length As Integer, _
		ByVal pCaption As WString Ptr _
	)As Integer
	
	Dim Buffer As WString * (65564 + 1) = Any
	Buffer[0] = 0
	
	For i As Integer = 0 To Length - 1
		Dim ValueBuffer As WString * (255 + 1) = Any
		i64tow(pArray[i], @ValueBuffer, 10)
		
		Dim IndexBuffer As WString * (255 + 1) = Any
		i64tow(i, @IndexBuffer, 10)
		
		lstrcat(Buffer, IndexBuffer)
		lstrcat(Buffer, " = ")
		lstrcat(Buffer, ValueBuffer)
		lstrcat(Buffer, !"\r\n")
	Next
	
	Return MessageBox(NULL, Buffer, pCaption, MB_OK)
	
End Function
