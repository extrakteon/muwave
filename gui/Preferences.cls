VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Preferences"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public PrefsFile As String
Public DataDir As String

Public CPDeqCPG As Integer
Public CapFreq As Variant
Public LowFreq As Variant
Public HighFreq As Variant
Public Rg As Variant
Public Rc As Variant
Public Tolerance As Variant



Public Sub Load(FileName As String)
    '
    Dim Name As String
    Dim cSet As New CSetting
    cSet.Init FileName, csModeINI 'load from ini-file

    Name = "Preferences"
    
    PrefsFile = cSet.GetSettingStr(Name, "PrefsFile", App.Path & "\" & App.EXEName & ".ini")
    DataDir = cSet.GetSettingStr(Name, "DataDir", App.Path)
    CPDeqCPG = cSet.GetSettingStr(Name, "CPDeqCPG", "1")
    CapFreq = cSet.GetSettingStr(Name, "CapFreq", "6")
    LowFreq = cSet.GetSettingStr(Name, "LowFreq", "10")
    HighFreq = cSet.GetSettingStr(Name, "HighFreq", "30")
    Rg = cSet.GetSettingStr(Name, "Rg", "0.5")
    Rc = cSet.GetSettingStr(Name, "Rc", "0.001")
    Tolerance = cSet.GetSettingStr(Name, "Tolerance", "0.0001")
    
End Sub

Public Sub Save(FileName As String)
    Dim Name As String
    Dim cSet As New CSetting
    cSet.Init FileName, csModeINI 'save as ini-file
    ' FIXME: Save all settings to one file
    Name = "Preferences"
    
    cSet.SaveSettingStr Name, "PrefsFile", PrefsFile
    cSet.SaveSettingStr Name, "DataDir", DataDir
    cSet.SaveSettingStr Name, "CPDeqCPG", CPDeqCPG
    cSet.SaveSettingStr Name, "CapFreq", CapFreq
    cSet.SaveSettingStr Name, "LowFreq", LowFreq
    cSet.SaveSettingStr Name, "HighFreq", HighFreq
    cSet.SaveSettingStr Name, "Rg", Rg
    cSet.SaveSettingStr Name, "Rc", Rc
    cSet.SaveSettingStr Name, "Tolerance", Tolerance
    
End Sub

Public Function PrefsPath() As String
    Dim FSO As New FileSystemObject
    PrefsPath = FSO.GetParentFolderName(PrefsFile)
End Function

