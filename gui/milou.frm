VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmMilou 
   Caption         =   "Milou Model Extraction"
   ClientHeight    =   11100
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   11340
   LinkTopic       =   "Form1"
   ScaleHeight     =   11100
   ScaleWidth      =   11340
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdExcel 
      Caption         =   "Export to Excel"
      Height          =   375
      Left            =   4920
      TabIndex        =   36
      Top             =   0
      Width           =   1215
   End
   Begin VB.CommandButton cmdIntrinsics 
      Caption         =   "Copy Intrinsics"
      Height          =   375
      Left            =   2160
      TabIndex        =   33
      Top             =   0
      Width           =   1215
   End
   Begin VB.CommandButton cmdParasitics 
      Caption         =   "Copy Parasitics"
      Height          =   375
      Left            =   3480
      TabIndex        =   32
      Top             =   0
      Width           =   1335
   End
   Begin VB.CommandButton cmdMatlab 
      Caption         =   "Show Matlab"
      Height          =   375
      Left            =   7440
      TabIndex        =   31
      Top             =   0
      Width           =   1335
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "Add measurement(s) ..."
      Height          =   375
      Index           =   0
      Left            =   120
      TabIndex        =   30
      Top             =   0
      Width           =   1935
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear All"
      Height          =   375
      Left            =   9840
      TabIndex        =   29
      Top             =   0
      Width           =   1335
   End
   Begin VB.Frame frameMethod 
      BorderStyle     =   0  'None
      Height          =   2895
      Index           =   2
      Left            =   240
      TabIndex        =   15
      Top             =   9480
      Width           =   5295
      Begin VB.Label Label4 
         Caption         =   "Chalmers not implemented!"
         Height          =   375
         Left            =   600
         TabIndex        =   16
         Top             =   1320
         Width           =   3495
      End
   End
   Begin VB.Frame frameMethod 
      BorderStyle     =   0  'None
      Height          =   2895
      Index           =   1
      Left            =   5760
      TabIndex        =   13
      Top             =   9480
      Width           =   5295
      Begin VB.Label Label3 
         Caption         =   "Niekerk not implemented!"
         Height          =   375
         Left            =   600
         TabIndex        =   14
         Top             =   1320
         Width           =   3495
      End
   End
   Begin VB.Frame frameMethod 
      BorderStyle     =   0  'None
      Height          =   2895
      Index           =   0
      Left            =   240
      TabIndex        =   1
      Top             =   840
      Width           =   10815
      Begin VB.TextBox txtComment 
         Height          =   285
         Left            =   0
         TabIndex        =   37
         Top             =   1920
         Width           =   2175
      End
      Begin VB.CommandButton cmdViewModel 
         Caption         =   "View Model ..."
         Height          =   375
         Left            =   3000
         TabIndex        =   28
         Top             =   2520
         Width           =   1215
      End
      Begin VB.Frame Frame2 
         Caption         =   "Settings"
         Height          =   2295
         Left            =   7800
         TabIndex        =   19
         Top             =   240
         Width           =   2895
         Begin VB.TextBox txtOptions 
            Alignment       =   1  'Right Justify
            Height          =   285
            Index           =   3
            Left            =   1920
            TabIndex        =   26
            Text            =   "0.0001"
            ToolTipText     =   "Error tolerance for iteration procedure"
            Top             =   600
            Width           =   735
         End
         Begin VB.TextBox txtOptions 
            Alignment       =   1  'Right Justify
            Height          =   285
            Index           =   2
            Left            =   240
            TabIndex        =   22
            Text            =   "30"
            ToolTipText     =   "High frequency limit for intrinsic extraction"
            Top             =   1800
            Width           =   735
         End
         Begin VB.TextBox txtOptions 
            Alignment       =   1  'Right Justify
            Height          =   285
            Index           =   1
            Left            =   240
            TabIndex        =   21
            Text            =   "10"
            ToolTipText     =   "Low frequency limit for intrinsic extraction"
            Top             =   1200
            Width           =   735
         End
         Begin VB.TextBox txtOptions 
            Alignment       =   1  'Right Justify
            Height          =   285
            Index           =   0
            Left            =   240
            TabIndex        =   20
            Text            =   "6"
            ToolTipText     =   "High frequency limit for parasitic capacitance extraction"
            Top             =   600
            Width           =   735
         End
         Begin VB.Label lblOptions 
            Caption         =   "Tolerance"
            Height          =   255
            Index           =   3
            Left            =   1920
            TabIndex        =   27
            Top             =   360
            Width           =   735
         End
         Begin VB.Label lblOptions 
            Caption         =   "High frequency [GHz]"
            Height          =   255
            Index           =   2
            Left            =   240
            TabIndex        =   25
            Top             =   1560
            Width           =   1575
         End
         Begin VB.Label lblOptions 
            Caption         =   "Low frequency [GHz]"
            Height          =   255
            Index           =   1
            Left            =   240
            TabIndex        =   24
            Top             =   960
            Width           =   1575
         End
         Begin VB.Label lblOptions 
            Caption         =   "Cap frequency [GHz]"
            Height          =   255
            Index           =   0
            Left            =   240
            TabIndex        =   23
            Top             =   360
            Width           =   1575
         End
      End
      Begin VB.CommandButton cmdExtractParasitics 
         Caption         =   "Extract Parasitics"
         Height          =   375
         Left            =   1320
         TabIndex        =   18
         Top             =   2520
         Width           =   1575
      End
      Begin VB.CommandButton cmdExtraction 
         Caption         =   "Extract"
         Height          =   375
         Left            =   0
         TabIndex        =   17
         Top             =   2520
         Width           =   1215
      End
      Begin VB.ComboBox cmbBias 
         Height          =   315
         Index           =   0
         Left            =   120
         TabIndex        =   10
         Text            =   "Pinched"
         ToolTipText     =   "Select gate voltage for pinched condition"
         Top             =   480
         Width           =   1215
      End
      Begin VB.ComboBox cmbBias 
         Height          =   315
         Index           =   1
         Left            =   1440
         TabIndex        =   9
         Text            =   "Forward"
         ToolTipText     =   "Select gate voltage for forward condition"
         Top             =   480
         Width           =   1215
      End
      Begin VB.CheckBox chkOptions 
         Caption         =   "Cpd same as Cpg"
         Height          =   255
         Left            =   3360
         TabIndex        =   5
         Top             =   480
         Value           =   1  'Checked
         Width           =   1575
      End
      Begin VB.TextBox txtOptions 
         Alignment       =   1  'Right Justify
         Height          =   285
         Index           =   4
         Left            =   5040
         TabIndex        =   4
         Text            =   "0.5"
         ToolTipText     =   "Parasitic gate resistance, estimated from DC end-to-end measurement"
         Top             =   1080
         Width           =   735
      End
      Begin VB.TextBox txtOptions 
         Alignment       =   1  'Right Justify
         Height          =   285
         Index           =   5
         Left            =   4200
         TabIndex        =   3
         Text            =   "0.1"
         ToolTipText     =   "Channel resistance, estimated from material sheet-resistance"
         Top             =   1080
         Width           =   735
      End
      Begin VB.TextBox txtOptions 
         Alignment       =   1  'Right Justify
         Enabled         =   0   'False
         Height          =   285
         Index           =   6
         Left            =   5040
         TabIndex        =   2
         Text            =   "0"
         ToolTipText     =   "Parasitic drain-pad capacitance"
         Top             =   480
         Width           =   735
      End
      Begin VB.Label Label1 
         Caption         =   "Comment"
         Height          =   255
         Left            =   0
         TabIndex        =   38
         Top             =   1680
         Width           =   2175
      End
      Begin VB.Label lblPinched 
         Caption         =   "Pinched, Vgs [V]"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   12
         Top             =   240
         Width           =   1215
      End
      Begin VB.Label lblPinched 
         Caption         =   "Forward, Vgs [V]"
         Height          =   255
         Index           =   1
         Left            =   1440
         TabIndex        =   11
         Top             =   240
         Width           =   1215
      End
      Begin VB.Label lblOptions 
         Caption         =   "Rg [Ohm]"
         Height          =   255
         Index           =   4
         Left            =   5040
         TabIndex        =   8
         Top             =   840
         Width           =   735
      End
      Begin VB.Label lblOptions 
         Caption         =   "Rc [Ohm]"
         Height          =   255
         Index           =   5
         Left            =   4200
         TabIndex        =   7
         Top             =   840
         Width           =   735
      End
      Begin VB.Label lblOptions 
         Caption         =   "Cpd [fF]"
         Height          =   255
         Index           =   6
         Left            =   5040
         TabIndex        =   6
         Top             =   240
         Width           =   735
      End
   End
   Begin MSComctlLib.TabStrip tabMethod 
      Height          =   3375
      Left            =   120
      TabIndex        =   0
      Top             =   480
      Width           =   11055
      _ExtentX        =   19500
      _ExtentY        =   5953
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   3
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Dambrine/Milou"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Niekerk"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "Chalmers"
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   7920
      Top             =   840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      MaxFileSize     =   32000
   End
   Begin MSFlexGridLib.MSFlexGrid gridIntrinsics 
      Height          =   3855
      Left            =   120
      TabIndex        =   34
      Top             =   5400
      Width           =   11055
      _ExtentX        =   19500
      _ExtentY        =   6800
      _Version        =   393216
      SelectionMode   =   1
   End
   Begin MSFlexGridLib.MSFlexGrid gridParasitics 
      Height          =   1335
      Left            =   120
      TabIndex        =   35
      Top             =   3960
      Width           =   11055
      _ExtentX        =   19500
      _ExtentY        =   2355
      _Version        =   393216
   End
   Begin VB.Menu mnuFile 
      Caption         =   "File"
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "Help"
      Begin VB.Menu mnuAbout 
         Caption         =   "About Milou Model Extraction Tool"
      End
   End
End
Attribute VB_Name = "frmMilou"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub chkOptions_Click()
    
    ' enable/disable CPD entrybox
    If Me.chkOptions.Value = 1 Then
        Me.txtOptions(6).Enabled = False
    Else
        Me.txtOptions(6).Enabled = True
    End If
    
End Sub

Private Sub cmdBrowse_Click(Index As Integer)

Dim Files As Variant

Me.CommonDialog1.Flags = cdlOFNAllowMultiselect
Me.CommonDialog1.FileName = "*"
Me.CommonDialog1.ShowOpen
' load selected files
frmMilou.MousePointer = vbHourglass
Files = Split(Me.CommonDialog1.FileName)
LoadActiveSweep Files, Me.gridIntrinsics, Me.cmbBias
frmMilou.MousePointer = vbDefault

End Sub

Private Sub cmdClear_Click()

    MilouForm ClearForm

End Sub

Private Sub cmdExcel_Click()

    Dim namestr As String
    
    namestr = frmMilou.txtComment.Text
    ExportToExcel frmMilou.gridIntrinsics, frmMilou.gridParasitics, namestr

End Sub

Private Sub cmdExtraction_Click()

    frmMilou.MousePointer = vbHourglass
    LoadOptions Me.txtOptions, Me.chkOptions
    RunExtraction Me.cmbBias
    GetIntrinsics Me.gridIntrinsics
    GetParasitics Me.gridParasitics
    frmMilou.MousePointer = vbDefault

End Sub





Private Sub cmdExtractParasitics_Click()

    frmMilou.MousePointer = vbHourglass
    LoadOptions Me.txtOptions, Me.chkOptions
    RunParasiticsExtraction Me.cmbBias
    GetParasitics Me.gridParasitics
    frmMilou.MousePointer = vbDefault
    
End Sub

Private Sub cmdIntrinsics_Click()

    'Selects the whole Grid
    With Me.gridIntrinsics
        .Visible = False
        .Row = 0
        .Col = 0
        .RowSel = .Rows - 1
        .ColSel = .Cols - 1
        .TopRow = 1
        .Visible = True
    End With
    
    Clipboard.Clear
    Clipboard.SetText Me.gridIntrinsics.Clip
    
    'Deselects the whole Grid
    With Me.gridIntrinsics
        .Visible = False
        .Row = 0
        .Col = 0
        .RowSel = 0
        .ColSel = 0
        .TopRow = 1
        .Visible = True
    End With

End Sub

Private Sub cmdMatlab_Click()
    
    ' hide/show MATLAB
    If MatLabApp.Visible = 1 Then
        MatLabApp.Visible = 0
        cmdMatlab.Caption = "Show MATLAB"
    Else
        MatLabApp.Visible = 1
        cmdMatlab.Caption = "Hide MATLAB"
    End If

End Sub

Private Sub cmdParasitics_Click()

    'Selects the whole Grid
    With Me.gridParasitics
        .Visible = False
        .Row = 0
        .Col = 0
        .RowSel = .Rows - 1
        .ColSel = .Cols - 1
        .TopRow = 0
        .Visible = True
    End With
    
    Clipboard.Clear
    Clipboard.SetText Me.gridParasitics.Clip

    'Deselects the whole Grid
    With Me.gridParasitics
        .Visible = False
        .Row = 0
        .Col = 0
        .RowSel = 0
        .ColSel = 0
        .TopRow = 0
        .Visible = True
    End With
    

End Sub



Private Sub Command1_Click()

End Sub

Private Sub Form_Load()

MilouForm InitForm

If MatLabApp.Visible = 1 Then
    frmMilou.cmdMatlab.Caption = "Hide MATLAB"
Else
    frmMilou.cmdMatlab.Caption = "Show MATLAB"
End If

Dim i As Integer
'show and enable the selected tab's controls
'and hide and disable all others
For i = 0 To tabMethod.Tabs.Count - 1
    If i = tabMethod.SelectedItem.Index - 1 Then
        frameMethod(i).Left = 240
        frameMethod(i).Top = 840
        frameMethod(i).Enabled = True
    Else
        frameMethod(i).Left = -20000
        frameMethod(i).Top = -20000
        frameMethod(i).Enabled = False
    End If
Next

MilouForm InitGrid

End Sub

Private Sub gridIntrinsics_SelChange()
    
    PlotBiasPoint Me.gridIntrinsics

End Sub




Private Sub tabMethod_Click()
    Dim i As Integer
    'show and enable the selected tab's controls
    'and hide and disable all others
    For i = 0 To tabMethod.Tabs.Count - 1
        If i = tabMethod.SelectedItem.Index - 1 Then
            frameMethod(i).Left = 240
            frameMethod(i).Top = 840
            frameMethod(i).Enabled = True
        Else
            frameMethod(i).Left = -20000
            frameMethod(i).Top = -20000
            frameMethod(i).Enabled = False
        End If
    Next
    MilouForm InitGrid
    GetBiasPoints frmMilou.gridIntrinsics
End Sub







Private Sub gridParasitics_KeyPress(KeyAscii As Integer)


    ' cells under a nominator are editable
    If gridParasitics.Row Mod 2 = 1 Then
                
        With gridParasitics
            Select Case KeyAscii
                    
            Case 8: 'IF KEY IS BACKSPACE THEN
                    If .Text <> "" Then .Text = _
                    Left$(.Text, (Len(.Text) - 1))
            Case 13: 'IF KEY IS ENTER THEN
                Select Case .Col
                Case Is < (.Cols - 1):
                    SendKeys "{right}"
                Case (.Cols - 1):
                    SendKeys "{home}" + "{down}"
                End Select
            Case Else
                .Text = .Text + Chr$(KeyAscii)
            End Select
           
        End With
    
    End If
End Sub
