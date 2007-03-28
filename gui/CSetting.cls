VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CSetting"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'Premier Settings interface class
'Copyright © 2000 - Stan Schultes
'Written for VBPJ Getting Started September, 2000

'CSetting mode enum
Public Enum csModes
    csModeRegistry = 0
    csModeINI = 1
End Enum

'class member variables
Private m_eSaveMode As csModes

'module-level variables
Private msININame As String         'name of .INI file
Private msAppName As String         'app name for settings

'INI setting APIs
Private Declare Function GetPrivateProfileInt Lib "kernel32" Alias "GetPrivateProfileIntA" (ByVal SectionName As String, ByVal KeyName As String, ByVal Default As Long, ByVal FileName As String) As Long
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal SectionName As String, ByVal KeyName As String, ByVal Default As String, ByVal ReturnedString As String, ByVal StringSize As Long, ByVal FileName As String) As Long
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal SectionName As String, ByVal KeyName As String, ByVal KeyValue As String, ByVal FileName As String) As Long
'there is no WritePrivateProfileInt declaration...
Private Declare Function DeleteKeyValue Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal SectionName As String, ByVal KeyName As String, ByVal KeyValue As Long, ByVal FileName As String) As Long
Private Declare Function GetINIKeys Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal SetionName As String, ByVal KeyName As Long, ByVal Default As String, ByVal ReturnedString As String, ByVal Size As Long, ByVal FileName As String) As Long
Private Declare Function GetINISections Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal SetionName As Long, ByVal KeyName As Long, ByVal Default As String, ByVal ReturnedString As String, ByVal Size As Long, ByVal FileName As String) As Long

'Error definitions
Private Const mklErrOffset As Long = vbObjectError + 512
Private Const mklErrNotNumeric As Long = mklErrOffset + 1
Private Const mksErrNotNumeric As String = "The setting value returned was not numeric"
Private Const mklErrWriting As Long = mklErrOffset + 2
Private Const mksErrWriting As String = "Error writing Setting "
Private Const mklErrReading As Long = mklErrOffset + 3
Private Const mksErrReading As String = "Error reading Setting "
Private Const mklErrSection As Long = mklErrOffset + 4
Private Const mksErrSection As String = "Error reading Section "
Private Const mklErrDeleteKey As Long = mklErrOffset + 5
Private Const mksErrDeleteKey As String = "Error Deleting Key "
Private Const mklErrDeleteSection As Long = mklErrOffset + 6
Private Const mksErrDeleteSection As String = "Error Deleting Section "

Public Function Init(Optional ByVal FileName As Variant, Optional ByVal Mode As csModes = csModeRegistry)
'Set up class variables, default to Registry mode
    If IsMissing(FileName) Then
        msAppName = App.EXEName
        msININame = App.Path & "\" & msAppName & ".ini"
    Else
        msAppName = Trim$(FileName)
        msININame = FileName
    End If
    'default to the app's .exe path
    SaveMode = Mode
End Function

Public Function GetSettingStr(ByVal Section As String, ByVal KeyName As String, ByVal DefaultValue As String) As String
'returns a string setting
    Dim lRet As Long
    Dim sBuf As String * 128
    
    On Error GoTo GetSettingStr_Error
    
    If Len(msAppName) = 0 Then Init
    Select Case m_eSaveMode
    Case csModeRegistry
        GetSettingStr = GetSetting(msAppName, Section, KeyName, DefaultValue)
    Case Else
        lRet = GetPrivateProfileString(Section, KeyName, DefaultValue, sBuf, Len(sBuf), msININame)
        GetSettingStr = TrimNull(sBuf)
    End Select
GetSettingStr_Exit:
    Exit Function
    
GetSettingStr_Error:
    Err.Raise mklErrReading, "CSetting.GetSettingStr", mksErrReading & "(" & Err & ", " & Error & ")"
End Function

Public Function GetSettingInt(ByVal Section As String, ByVal KeyName As String, ByVal DefaultValue As Integer) As Integer
'returns a numeric setting
    Dim sSetting As String
    
    On Error GoTo GetSettingInt_Error
    
    If Len(msAppName) = 0 Then Init
    Select Case m_eSaveMode
    Case csModeRegistry
        sSetting = GetSetting(msAppName, Section, KeyName, CStr(DefaultValue))
        'check if value is numeric
        If IsNumeric(sSetting) Then
            GetSettingInt = CInt(sSetting)
        Else
            'match behavior of .INI return
            GetSettingInt = 0
            'or - return error if desired
            'On Error GoTo 0         'disable handler to return error
            'Err.Raise mklErrNotNumeric, "CSetting.GetSettingInt", mksErrNotNumeric
        End If
    Case Else
        'returns 0 if not numeric
        GetSettingInt = GetPrivateProfileInt(Section, KeyName, DefaultValue, msININame)
    End Select
GetSettingInt_Exit:
    Exit Function
    
GetSettingInt_Error:
    Err.Raise mklErrReading, "CSetting.GetSettingInt", mksErrReading & "(" & Err & ", " & Error & ")"
End Function

Public Function GetSettingAll(ByVal Section As String) As Variant
'Returns all settings in a given Section
    Dim vArray() As Variant
    Dim sKeys() As String
    Dim lRet As Long, lCnt As Long
    Dim lKeys As Long, lKey As Long
    Dim sBuf As String * 2048

    On Error GoTo GetSettingAll_Error
    
    If Len(msAppName) = 0 Then Init
    Select Case m_eSaveMode
    Case csModeRegistry
        'this is the easy way!
        GetSettingAll = GetAllSettings(msAppName, Section)
    
    Case Else
        'list keys in this section
        lRet = GetINIKeys(Section, 0&, 0&, sBuf, Len(sBuf), msININame)
        If (lRet > 1) Then              'if any returned
            lCnt = InStr(sBuf, vbNullChar & vbNullChar)     'find end of list
            sKeys = Split(Left$(sBuf, lCnt - 1), vbNullChar) 'separate keys
            lKeys = UBound(sKeys)       'get count
            ReDim vArray(lKeys, 1)      'make variant array
            For lKey = 0 To lKeys       'fill array
                vArray(lKey, 0) = sKeys(lKey)
                vArray(lKey, 1) = GetSettingStr(Section, sKeys(lKey), "")
            Next
            GetSettingAll = vArray      'return array
        End If
    End Select
GetSettingAll_Exit:
    Exit Function
    
GetSettingAll_Error:
    Err.Raise mklErrSection, "CSetting.GetSettingAll", mksErrSection & "(" & Err & ", " & Error & ")"
End Function

Public Function GetSectionNames() As Variant
'Returns all Section names - works for INI settings only.
    Dim vArray() As Variant
    Dim sKeys() As String
    Dim lRet As Long, lCnt As Long
    Dim lKeys As Long, lKey As Long
    Dim sBuf As String * 2048

    On Error GoTo GetSectionNames_Error
    
    If Len(msAppName) = 0 Then Init
    Select Case m_eSaveMode
    Case csModeRegistry
        'this will always return an uninitialized variant
        GetSectionNames = GetAllSettings(msAppName, 0&)
    
    Case Else
        'list section names
        lRet = GetINISections(0&, 0&, 0&, sBuf, Len(sBuf), msININame)
        If (lRet > 1) Then              'if any returned
            lCnt = InStr(sBuf, vbNullChar & vbNullChar)     'find end of list
            sKeys = Split(Left$(sBuf, lCnt - 1), vbNullChar) 'separate keys
            lKeys = UBound(sKeys)       'get count
            ReDim vArray(lKeys)         'make variant array
            For lKey = 0 To lKeys       'fill array
                vArray(lKey) = sKeys(lKey)
            Next
            GetSectionNames = vArray      'return array
        End If
    End Select
GetSectionNames_Exit:
    Exit Function
    
GetSectionNames_Error:
    Err.Raise mklErrSection, "CSetting.GetSectionNames", mksErrSection & "(" & Err & ", " & Error & ")"
End Function

Public Sub SaveSettingStr(ByVal Section As String, ByVal KeyName As String, ByVal Setting As String)
'saves a string setting
    Dim lRet As Long
    
    On Error GoTo SaveSettingStr_Error
    
    If Len(msAppName) = 0 Then Init
    Select Case m_eSaveMode
    Case csModeRegistry
        SaveSetting msAppName, Section, KeyName, Setting
    Case Else
        lRet = WritePrivateProfileString(Section, KeyName, Setting, msININame)
    End Select
SaveSettingStr_Exit:
    Exit Sub
    
SaveSettingStr_Error:
    Err.Raise mklErrWriting, "CSetting.SaveSettingStr", mksErrWriting & "(" & Err & ", " & Error & ")"
End Sub

Public Sub SaveSettingInt(ByVal Section As String, ByVal KeyName As String, Setting As Integer)
'saves a numeric setting
    Dim lRet As Long
    
    On Error GoTo SaveSettingInt_Error
    
    If Len(msAppName) = 0 Then Init
    Select Case m_eSaveMode
    Case csModeRegistry
        SaveSetting msAppName, Section, KeyName, CStr(Setting)
    Case Else
        lRet = WritePrivateProfileString(Section, KeyName, CStr(Setting), msININame)
    End Select
SaveSettingInt_Exit:
    Exit Sub
    
SaveSettingInt_Error:
    Err.Raise mklErrWriting, "CSetting.SaveSettingInt", mksErrWriting & "(" & Err & ", " & Error & ")"
End Sub

Public Sub DeleteKey(ByVal Section As String, ByVal KeyName As String)
'deletes the specified key
    Dim lRet As Long
    
    On Error GoTo DeleteKey_Error
    
    If Len(msAppName) = 0 Then Init
    Select Case m_eSaveMode
    Case csModeRegistry
        If Len(KeyName) = 0 Then
            'deletes section
            DeleteSetting msAppName, Section
        Else
            'deletes key
            DeleteSetting msAppName, Section, KeyName
        End If
    Case Else
        lRet = DeleteKeyValue(Section, KeyName, 0&, msININame)
        If lRet = 0 Then Err.Raise mklErrDeleteKey, "CSetting.DeleteKey", mksErrDeleteKey & "(check if file is protected)"
    End Select
DeleteKey_Exit:
    Exit Sub
    
DeleteKey_Error:
    Err.Raise mklErrDeleteKey, "CSetting.DeleteKey", mksErrDeleteKey & "(" & Err & ", " & Error & ")"
End Sub

Public Property Let SaveMode(Mode As csModes)
'sets save mode, see csModes enum
    m_eSaveMode = Mode
End Property

Public Property Get SaveMode() As Long
'returns save mode
    SaveMode = CLng(m_eSaveMode)
End Property

Private Function TrimNull(ByVal InString As String) As String
'trims string at first Null character
    Dim lPos As Long
    TrimNull = Trim$(InString)
    lPos = InStr(TrimNull, vbNullChar)
    If lPos > 0 Then TrimNull = Left$(TrimNull, lPos - 1)
End Function
