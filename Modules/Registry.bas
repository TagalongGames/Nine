#include "Registry.bi"

Function IncrementRegistryDWORD( _
		ByVal Key As WString Ptr _
	)As Boolean
	
	Dim regHKEY As HKEY = Any
	Dim dwDisposition As DWORD = Any
	
	Dim hr As Long = RegCreateKeyEx(HKEY_CURRENT_USER, @RegistrySection, 0, 0, 0, KEY_QUERY_VALUE + KEY_SET_VALUE, NULL, @regHKEY, @dwDisposition)
	
	If hr <> ERROR_SUCCESS Then
		Return False
	End If
	
	Dim dwValue As DWORD = Any
	Dim pdwType As DWORD = REG_DWORD
	Dim BufferLength As DWORD = SizeOf(DWORD)
	
	Select Case dwDisposition
		
		Case REG_CREATED_NEW_KEY
			dwValue = 0
			hr = ERROR_SUCCESS
		
		Case REG_OPENED_EXISTING_KEY
			hr = RegQueryValueEx(regHKEY, Key, 0, @pdwType, CPtr(Byte Ptr, @dwValue), @BufferLength)
			
	End Select
	
	If hr <> ERROR_SUCCESS Then
		
		If hr = ERROR_FILE_NOT_FOUND Then
			dwValue = 0
			BufferLength = SizeOf(DWORD)
		Else
			RegCloseKey(regHKEY)
			Return False
		End If
		
	End If
	
	dwValue += 1
	
	hr = RegSetValueEx(regHKEY, Key, 0, REG_DWORD, CPtr(Byte Ptr, @dwValue), SizeOf(DWORD))
	
	If hr <> ERROR_SUCCESS Then
		RegCloseKey(regHKEY)
		Return False
	End If
	
	RegCloseKey(regHKEY)
	
	Return True
	
End Function

Function GetRegistryDWORD( _
		ByVal Key As WString Ptr, _
		ByVal pValue As DWORD Ptr _
	)As Boolean
	
	Dim regHKEY As HKEY = Any
	Dim dwDisposition As DWORD = Any
	
	Dim hr As Long = RegCreateKeyEx(HKEY_CURRENT_USER, @RegistrySection, 0, 0, 0, KEY_QUERY_VALUE, NULL, @regHKEY, @dwDisposition)
	
	If hr <> ERROR_SUCCESS Then
		Return False
	End If
	
	Dim pdwType As DWORD = REG_DWORD
	Dim BufferLength As DWORD = SizeOf(DWORD)
	
	Select Case dwDisposition
		
		Case REG_CREATED_NEW_KEY
			*pValue = 0
			RegCloseKey(regHKEY)
			Return True
		
		Case REG_OPENED_EXISTING_KEY
			hr = RegQueryValueEx(regHKEY, Key, 0, @pdwType, CPtr(Byte Ptr, pValue), @BufferLength)
			
	End Select
	
	If hr <> ERROR_SUCCESS Then
		
		*pValue = 0
		RegCloseKey(regHKEY)
		
		If hr = ERROR_FILE_NOT_FOUND Then
			Return True
		Else
			Return False
		End If
		
	End If
	
	RegCloseKey(regHKEY)
	
	Return True
	
End Function

' Function GetRegistryString( _
		' ByVal Key As WString Ptr, _
		' ByVal DefaultValue As WString Ptr, _
		' ByVal ValueLength As Integer, _
		' ByVal pValue As WString Ptr _
	' )As Boolean
	
	' Dim regHKEY As HKEY = Any
	' Dim lpdwDisposition As DWORD = Any
	
	' Dim hr As Long = RegCreateKeyEx(HKEY_CURRENT_USER, @RegistrySection, 0, 0, 0, KEY_QUERY_VALUE, NULL, @regHKEY, @lpdwDisposition)
	
	' If hr <> ERROR_SUCCESS Then
		' Return False
	' End If
	
	' If lpdwDisposition = REG_CREATED_NEW_KEY Then
		
	' End If
	
	' Dim pdwType As DWORD = RRF_RT_REG_SZ
	' Dim BufferLength2 As DWORD = (BufferLength + 1) * SizeOf(WString)
	
	' hr = RegQueryValueEx(regHKEY, Key, 0, @pdwType, CPtr(Byte Ptr, Buffer), @BufferLength2)
	
	' If hr <> ERROR_SUCCESS Then
		' RegCloseKey(regHKEY)
		' Return False
	' End If
	
	' RegCloseKey(regHKEY)
	
	' Return True ' BufferLength \ SizeOf(WString) - 1
	
' End Function

' Function SetSettingsValue( _
		' ByVal Key As WString Ptr, _
		' ByVal Value As WString Ptr _
	' )As Boolean
	
	' Dim regHKEY As HKEY = Any
	' Dim lpdwDisposition As DWORD = Any
	
	' Dim hr As Long = RegCreateKeyEx(HKEY_CURRENT_USER, @RegistrySection, 0, 0, 0, KEY_SET_VALUE, NULL, @regHKEY, @lpdwDisposition)
	
	' If hr <> ERROR_SUCCESS Then
		' Return False
	' End If
	
	' hr = RegSetValueEx(regHKEY, Key, 0, REG_SZ, CPtr(Byte Ptr, Value), (lstrlen(Value) + 1) * SizeOf(WString))
	
	' If hr <> ERROR_SUCCESS Then
		' RegCloseKey(regHKEY)
		' Return False
	' End If
	
	' RegCloseKey(regHKEY)
	
	' Return True
	
' End Function
