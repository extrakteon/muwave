VERSION 5.00
Begin VB.Form frmDirDialog 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Select Directory"
   ClientHeight    =   2685
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   6030
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2685
   ScaleWidth      =   6030
   ShowInTaskbar   =   0   'False
   Begin VB.DriveListBox drive 
      Height          =   315
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   4215
   End
   Begin VB.DirListBox dir 
      Height          =   2115
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   4215
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4680
      TabIndex        =   1
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   4680
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "frmDirDialog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub CancelButton_Click()
    Unload Me
End Sub

Private Sub drive_Change()
    dir.Path = drive.drive
End Sub

Private Sub Form_Load()
    Dim FSO As New FileSystemObject
    ' Center the form
    Me.Move (Screen.Width - Me.Width) / 2, (Screen.Height - Me.Height) / 2
    Me.drive = FSO.GetDriveName(Prefs.DataDir)
    Me.dir.Path = FSO.GetAbsolutePathName(Prefs.DataDir)
End Sub

Private Sub OKButton_Click()
    frmPreferences.txtDataDir.Text = dir.Path
    Unload Me
End Sub
