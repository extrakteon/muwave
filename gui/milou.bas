Attribute VB_Name = "Milou"
Option Explicit

Enum FormActionType
    InitForm = 0
    InitGrid = 1
    ClearForm = 2
End Enum

Enum ExtractionMethodType
    Dambrine = 0
    Niekerk = 1
    Chalmers = 2
End Enum

Global MatLabApp As Object
Global ExcelApp As Excel.Application
Global ExcelRunning As Boolean
Global Prefs As Preferences
Global ExtractionDone As Boolean

Sub MilouForm(Action As FormActionType)
                
    Select Case Action
    Case InitForm
        ' start a noninteractive MATLAB-session
        Set MatLabApp = CreateObject("Matlab.Application")
        MatLabApp.Visible = 0
        MatLabApp.Execute ("cd d:\users\koffe\project_milou\matlab_milou\extraction")
        Set Prefs = New Preferences
        Prefs.Load "apa"
        ExtractionDone = False
        ExcelRunning = False
    Case InitGrid
        Dim cmdstr As String
        Dim ivec As Variant
        Dim pvec As Variant
        Dim iuvec As Variant
        Dim puvec As Variant
        Dim n As Integer
        Select Case frmMilou.tabMethod.SelectedItem.Index - 1
        Case 0
            ' Dambrine
            Debug.Print "METHOD.DAMBRINE"
            cmdstr = "[pstr,istr]=milou;"
        Case 1
            ' Niekerk
            Debug.Print "METHOD.NIEKERK"
            cmdstr = "[pstr,istr]=milou;"
        Case 2
            ' Chalmers
            Debug.Print "METHOD.CHALMERS"
            cmdstr = "[pstr,istr]=milou;"
        End Select
        
        MatLabApp.Execute cmdstr
        
        ' get the intrinsics and their units
        ivec = ReadParameterString("istr.names")
        iuvec = ReadParameterString("istr.units")
        
        ' get the parasitics and their units
        pvec = ReadParameterString("pstr.names")
        puvec = ReadParameterString("pstr.units")
            
        n = UBound(ivec) + 1
        With frmMilou.gridIntrinsics
            .Clear
            .Cols = 4 + 4 + 4 + n
            .Rows = 2
            .FixedRows = 1
            .FixedCols = 0
            .Row = 0
            .Col = 0
            .CellFontBold = True
            .Text = "Vgs [V]"
            .Col = 1
            .CellFontBold = True
            .Text = "Vds [V]"
            .Col = 2
            .CellFontBold = True
            .Text = "Ids [mA]"
            .Col = 3
            .CellFontBold = True
            .Text = "Igs [mA]"
        End With
        
        Dim i As Integer
        For i = 0 To n - 1
            With frmMilou.gridIntrinsics
                .Row = 0
                .Col = 4 + i
                .CellFontBold = True
                .Text = ivec(i) & " [" & iuvec(i) & "]"
            End With
        Next
        
        With frmMilou.gridIntrinsics
            .Col = 4 + n + 0
            .CellFontBold = True
            .Text = "er11 [%]"
            .Col = 4 + n + 1
            .CellFontBold = True
            .Text = "er12 [%]"
            .Col = 4 + n + 2
            .CellFontBold = True
            .Text = "er21 [%]"
            .Col = 4 + n + 3
            .CellFontBold = True
            .Text = "er22 [%]"
            .Col = 2 * 4 + n + 0
            .CellFontBold = True
            .Text = "ea11"
            .Col = 2 * 4 + n + 1
            .CellFontBold = True
            .Text = "ea12"
            .Col = 2 * 4 + n + 2
            .CellFontBold = True
            .Text = "ea21"
            .Col = 2 * 4 + n + 3
            .CellFontBold = True
            .Text = "ea22"
        End With
        
        n = 8 ' number of columns
        With frmMilou.gridParasitics
            .Clear
            .Cols = n
            .Rows = 4
            .FixedCols = 0
            .FixedRows = 0
            .Row = 0
        End With
        For i = 0 To UBound(pvec)
            With frmMilou.gridParasitics
                .Col = i Mod n
                .Row = 2 * (i \ n)
                .CellFontBold = True
                .Text = pvec(i) & " [" & puvec(i) & "]"
            End With
        Next
    Case ClearForm
    
        ExtractionDone = False
    
        cmdstr = "clear all"
        MatLabApp.Execute cmdstr
        
        frmMilou.cmbBias(0).Clear
        frmMilou.cmbBias(1).Clear
        
        MilouForm InitGrid
        
    End Select



End Sub

Function ReadParameterString(ByVal str As String) As Variant
        Dim cmdstr As String
        Dim tmpstr As String
        cmdstr = "disp(" & str & ");"
        tmpstr = MatLabApp.Execute(cmdstr)
        tmpstr = Mid(tmpstr, 1, Len(tmpstr) - 1)
        ReadParameterString = Split(tmpstr, "_")
End Function

Sub LoadActiveSweep(Files As Variant, lists As Object, combos As Object)
    ' parse and load a collection of files into a meassweep-object
    Dim result, cmdstr As String
    Dim i As Integer
                  
    cmdstr = "disp(exist('active'))"
    Debug.Print cmdstr
    result = MatLabApp.Execute(cmdstr)
    result = Mid(result, 1, Len(result) - 1)
    Debug.Print "RESULT:" & result
    If result = 0 Then
        cmdstr = "active = read_milousweep(meassweep,"
    Else
        cmdstr = "active = read_milousweep(active,"
    End If
    Debug.Print cmdstr
    MatLabApp.Execute cmdstr
    
    If UBound(Files) = 0 Then
        ' a single file selected
        cmdstr = cmdstr & "{'" & Files(0) & "'});"
    Else
        cmdstr = cmdstr & "'" & Files(0) & "',{'"
        For i = (LBound(Files) + 1) To (UBound(Files) - 1)
            cmdstr = cmdstr & Files(i) & "','"
        Next
        cmdstr = cmdstr & Files(UBound(Files)) & "'});"
    End If
    
    Debug.Print cmdstr
    MatLabApp.Execute (cmdstr)
    
    GetBiasPoints lists
    GetColdPoints combos
    
End Sub


Sub GetBiasPoints(grid As Object)
    ' get the cold bias points of active meassweep
    
    Dim cmdstr As String
    Dim MLreal(1) As Double
    Dim MLimag() As Double
    Dim vgs() As Double
    Dim vds() As Double
    Dim igs() As Double
    Dim ids() As Double
    Dim i, n As Integer
    Dim itemstr As String
    
    cmdstr = "vgs = active.vgs; vds = active.vds;igs = active.igs; ids = active.ids"
    MatLabApp.Execute cmdstr

    ' populate bias-list
    MatlabRead "vgs", vgs
    MatlabRead "vds", vds
    MatlabRead "igs", igs
    MatlabRead "ids", ids
    
    n = UBound(vgs) + 1
    grid.Rows = n + 1
    grid.Row = 0
    grid.Col = 0
    grid.CellFontBold = True
    grid.Text = "Vgs [V]"
    grid.Col = 1
    grid.CellFontBold = True
    grid.Text = "Vds [V]"
    grid.Col = 2
    grid.CellFontBold = True
    grid.Text = "Ids [mA]"
    grid.Col = 3
    grid.CellFontBold = True
    grid.Text = "Igs [mA]"

    For i = 0 To n - 1
        grid.Row = i + 1
        grid.Col = 0
        grid.Text = Round(vgs(i), 4)
        grid.Col = 1
        grid.Text = Round(vds(i), 4)
        grid.Col = 2
        grid.Text = Round(1000# * ids(i), 4)
        grid.Col = 3
        grid.Text = Round(1000# * igs(i), 4)
    Next
    
End Sub


Sub GetColdPoints(combos As Object)
    ' get the cold bias points of active meassweep
    Dim cmdstr As String
    Dim MLreal(1) As Double
    Dim MLimag() As Double
    Dim vgs_cold() As Double
    Dim cstatus As String
    Dim i, n As Integer
    Dim xmin, xmax As Double
    Dim imin, imax As Integer
    
    cmdstr = "[cstatus,vgs_cold,index] = milou_cold(active);"
    MatLabApp.Execute cmdstr

    ' populate cold-bias selection combos
    
    ' is there any cold-points?
    cmdstr = "disp(cstatus)"
    cstatus = MatLabApp.Execute(cmdstr)
    cstatus = Mid(cstatus, 1, Len(cstatus) - 1)
    
    Debug.Print "STATUS: " & cstatus
    Debug.Print "NOT STATUS: " & (Not cstatus)
    If cstatus = 0 Then
        Debug.Print "COLDPOINTS"
        ' populate cold-bias selection combos
        MatlabRead "vgs_cold", vgs_cold
        n = UBound(vgs_cold)
        combos(0).Clear
        combos(1).Clear
        imin = 0 ' reset min/max index
        imax = 0
        xmin = vgs_cold(0)
        xmax = vgs_cold(0)
        For i = 0 To n
            If vgs_cold(i) < xmin Then
                xmin = vgs_cold(i)
                imin = i
            End If
            If vgs_cold(i) > xmax Then
                xmax = vgs_cold(i)
                imax = i
            End If
            combos(0).AddItem vgs_cold(i)
            combos(1).AddItem vgs_cold(i)
        Next
        combos(0).ListIndex = imin
        combos(1).ListIndex = imax
    Else
        combos(0).Clear
        combos(1).Clear
        combos(0).AddItem "N/A"
        combos(1).AddItem "N/A"
    End If
    
End Sub
Sub GetIntrinsics(IntrGrid As Object)

    Dim cmdstr, rowstr, unitstr As String
    Dim MLreal(1) As Double
    Dim MLimag() As Double
    Dim ival() As Double
    Dim erel() As Double
    Dim eabs() As Double
    Dim vgs() As Double
    Dim vds() As Double
    Dim i, j, n As Integer
    Dim numstr As String
    Dim headerstr As String
    Dim x As Double
    Dim y As Double
    
    headerstr = "Vgs" & vbTab & "Vds" & vbTab
        
    ' how many are they
    cmdstr = "[num,istr,ival,unitstr]=milou_intrstr(intrinsics);disp(num)"
    numstr = MatLabApp.Execute(cmdstr)
    numstr = Mid(numstr, 1, Len(numstr) - 1)
    
    MatlabRead "ival", ival
    n = 1 + UBound(ival, 1)
    
    cmdstr = "erel=intrinsics.error_relative;eabs=intrinsics.error_absolute;"
    Debug.Print cmdstr
    MatLabApp.Execute cmdstr
    
    MatlabRead "erel", erel
    MatlabRead "eabs", eabs
    
    ' get bias points
    cmdstr = "vgs = active.vgs; vds = active.vds;"
    MatLabApp.Execute cmdstr

    ' populate bias-list
    MatlabRead "vgs", vgs
    MatlabRead "vds", vds
    
    For j = 0 To n - 1
        IntrGrid.Row = j + 1
        For i = 0 To numstr - 1
            IntrGrid.Col = 4 + i
            x = Round(ival(j, i), 3)
            If x < 0 Then
                IntrGrid.CellForeColor = vbRed
            Else
                IntrGrid.CellForeColor = vbBlack
            End If
            IntrGrid.Text = x
        Next
        For i = 0 To 3
            x = 100 * Round(erel(j, i), 3)
            y = Round(eabs(j, i), 3)
            IntrGrid.Col = numstr + 4 + i 'relative
            IntrGrid.Text = x
            IntrGrid.Col = numstr + 2 * 4 + i 'absolute
            IntrGrid.Text = y
        Next
    Next
    
End Sub
Sub GetParasitics(ParaGrid As Object)
    
    Debug.Print "GetParasitics()"
    
    Dim cmdstr, rowstr, unitstr As String
    Dim MLreal(1) As Double
    Dim MLimag() As Double
    Dim pval() As Double
    Dim userpval() As Double
    Dim i, n As Integer
    Dim numstr As String
    Dim headerstr As String
    
    headerstr = "Vgs" & vbTab & "Vds" & vbTab
    
    ' how many are they
    cmdstr = "[num,pstr,pval,unitstr]=milou_parastr(parasitics);disp(num)"
    numstr = MatLabApp.Execute(cmdstr)
    numstr = Mid(numstr, 1, Len(numstr) - 1)
    
    MatlabRead "pval", pval
    ReDim userpval(UBound(pval))
    Dim x As Double
    n = ParaGrid.Cols
    For i = 0 To numstr - 1
        x = Round(pval(i), 3)
        ParaGrid.Col = i Mod n
        ParaGrid.Row = 2 * (i \ n) + 1
        ParaGrid.CellFontBold = False
        If ParaGrid.Text = "" Then
            userpval(i) = x
        Else
            userpval(i) = 1 * ParaGrid.Text
        End If
        If userpval(i) <> x Then
            ParaGrid.CellForeColor = vbBlue
        Else
            ParaGrid.CellForeColor = vbBlack
        End If
        If x < 0 Then
            ParaGrid.CellForeColor = vbRed
        End If
        ParaGrid.Text = x
    Next
    
End Sub

Sub MatlabRead(ByVal variable As String, ByRef MReal() As Double)

Dim result As String
Dim Mrsize(1) As Double
Dim Misize() As Double
Dim MImag() As Double
Dim i, j As Integer
Dim cmdstr As String

cmdstr = "[r,c] = size(" & variable & "); " & variable & "_size = [r, c];"
Debug.Print cmdstr
Call MatLabApp.Execute(cmdstr)
Call MatLabApp.GetFullMatrix(variable & "_size", "base", Mrsize, Misize)
Debug.Print "x: " & Mrsize(0) & ", y: " & Mrsize(1)
If Mrsize(0) = 1 Or Mrsize(1) = 1 Then
    ' row or column vector output
    If Mrsize(0) > Mrsize(1) Then
        ReDim MReal(Mrsize(0) - 1)
        Debug.Print "X"
    ElseIf Mrsize(1) > Mrsize(0) Then
        ReDim MReal(Mrsize(1) - 1)
        Debug.Print "Y"
    Else
        ReDim MReal(0)
        Debug.Print "SCALAR"
    End If
Else
    ' matrix output
    ReDim MReal(Mrsize(0) - 1, Mrsize(1) - 1)
End If

Call MatLabApp.GetFullMatrix(variable, "base", MReal, MImag)

End Sub


Sub LoadOptions(txtOptions As Object, chkOptions As Object)
    ' load options into a matlab options structure
    Dim cmdstr As String
    
    Dim CPDeqCPG As String
    Dim tol As String
    Dim fcap, flow, fhigh As String
    Dim Rg, Rc As String
    Dim Cpd As String
    Dim out_file As String
    
    ' parse gui
    CPDeqCPG = chkOptions.Value
    fcap = txtOptions(0).Text
    flow = txtOptions(1).Text
    fhigh = txtOptions(2).Text
    tol = txtOptions(3).Text
    Rg = txtOptions(4).Text
    Rc = txtOptions(5).Text
    Cpd = txtOptions(6).Text
    out_file = "out_file.txt"
    
    ' assemble MATLAB command string
    cmdstr = "options.CPDeqCPG = " & CPDeqCPG & "; "
    cmdstr = cmdstr & "options.fcap = " & fcap & "*1e9; "
    cmdstr = cmdstr & "options.flow = " & flow & "*1e9; "
    cmdstr = cmdstr & "options.fhigh = " & fhigh & "*1e9; "
    cmdstr = cmdstr & "options.TOL = " & tol & "; "
    cmdstr = cmdstr & "options.Rg = " & Rg & "; "
    cmdstr = cmdstr & "options.Rc = " & Rc & ";"
    cmdstr = cmdstr & "options.Cpd = " & Cpd * 0.000000000000001 & ";"
    cmdstr = cmdstr & "options.out_file = '" & out_file & "';"
    
    Debug.Print cmdstr
    MatLabApp.Execute cmdstr
    
End Sub

Sub RunParasiticsExtraction(cmbBias As Object)

    Dim cmdstr As String
    
    Dim pinched, forward As String
    
    pinched = cmbBias(0).ListIndex + 1
    forward = cmbBias(1).ListIndex + 1
    
    ' just perform a intrinsic extraction
    Debug.Print "PARASITICS"
    cmdstr = "pinchedSP = active(index(" & pinched & ")); "
    cmdstr = cmdstr + "forwardSP = active(index(" & forward & ")); "
    cmdstr = cmdstr + "[parasitics]=milou_parasitics(pinchedSP,forwardSP,options);"
    
    Debug.Print cmdstr
    MatLabApp.Execute cmdstr
    
    ExtractionDone = True

End Sub

Sub RunExtraction(cmbBias As Object)
    ' run a milou extraction
    
    Dim cmdstr As String
    
    Dim pinched, forward As String
    
    pinched = cmbBias(0).ListIndex + 1
    forward = cmbBias(1).ListIndex + 1
    
    If ExtractionDone Then
        ' just perform a intrinsic extraction
        Debug.Print "INTRINSICS"
        LoadParasitics frmMilou.gridParasitics
        cmdstr = "[intrinsics]=milou_intrinsics(active,parasitics,options);"
    Else
        ' perform both parasitics and intrinsics
        Debug.Print "PARASITICS AND INTRINSICS"
        cmdstr = "pinchedSP = active(index(" & pinched & ")); "
        cmdstr = cmdstr + "forwardSP = active(index(" & forward & ")); "
        cmdstr = cmdstr + "[parasitics,intrinsics]=milou(pinchedSP,forwardSP,active,options);"
    End If
    
    Debug.Print cmdstr
    MatLabApp.Execute cmdstr
    
    ExtractionDone = True
    
End Sub

Sub PlotBiasPoint(gridBias As Object)
    'plot S-parameters of selected bias-point
    Dim cmdstr As String
    Dim Index As String
    
    Index = gridBias.RowSel
    If ExtractionDone Then
        cmdstr = "figure(1);smithplot(active(" & Index & "),intrinsics.model(" & Index & "));"
        Debug.Print cmdstr
    Else
        cmdstr = "figure(1);smithplot(active(" & Index & "));"
        Debug.Print cmdstr
    End If
    MatLabApp.Execute cmdstr

End Sub


Sub LoadParasitics(ParaGrid As Object)

    Dim cmdstr, rowstr, unitstr As String
    Dim MLreal(1) As Double
    Dim MLimag() As Double
    Dim pval() As Double
    Dim userpval() As Double
    Dim i, n As Integer
    Dim numstr As String
    
    ' how many are they
    cmdstr = "[num,pstr,pval,unitstr]=milou_parastr(parasitics);disp(num)"
    numstr = MatLabApp.Execute(cmdstr)
    numstr = Mid(numstr, 1, Len(numstr) - 1)
    
    MatlabRead "pval", pval
    ReDim userpval(UBound(pval))
    Dim x As Double
    n = ParaGrid.Cols
    cmdstr = "parasitics.values = ["
    For i = 0 To numstr - 1
        x = Round(pval(i), 3)
        ParaGrid.Col = i Mod n
        ParaGrid.Row = 2 * (i \ n) + 1
        If ParaGrid.Text = "" Then
            userpval(i) = x
        Else
            userpval(i) = 1 * ParaGrid.Text
        End If
        cmdstr = cmdstr & userpval(i) & ","
    Next
    cmdstr = Mid(cmdstr, 1, Len(cmdstr) - 1)
    cmdstr = cmdstr & "];"

    MatLabApp.Execute cmdstr

End Sub

Public Sub ExportToExcel(IntrGrid As Object, ParaGrid As Object, Optional WorkSheetName _
  As String)
    
Dim wbXL As New Excel.Workbook
Dim wsXL As New Excel.Worksheet
Dim intRow As Integer ' counter
Dim intCol As Integer ' counter
Dim wsName As String

On Error GoTo ErrHandler

' is Excel running?
If Not ExcelRunning Then
    Set ExcelApp = New Excel.Application
    ExcelRunning = True
End If

Debug.Print "WORKBOOKS: " & ExcelApp.Workbooks.Count
' open, if necessary, a workbook
If ExcelApp.Workbooks.Count = 0 Then
    Debug.Print "OPENS NEW WORKBOOK"
    Set wbXL = ExcelApp.Workbooks.Add()
Else
    Debug.Print "USES EXISTING WORKBOOK"
    Set wbXL = ExcelApp.ActiveWorkbook
End If

wsName = ExcelApp.ActiveSheet.Name
If WorkSheetName = "" Then
    WorkSheetName = wsName
End If

If StrComp(WorkSheetName, wsName) = 0 Then
    Set wsXL = ExcelApp.ActiveSheet
Else
    Set wsXL = wbXL.Worksheets.Add
    ' name the worksheet
    wsXL.Name = WorkSheetName
End If
    
' fill worksheet with intrinsics
'For intRow = 1 To TheRows
'    For intCol = 1 To TheCols
'        With TheFlexGrid
'            wsXL.Cells(intRow, intCol).Value = _
'               .TextMatrix(intRow - 1, intCol - 1) & " "
'        End With
'    Next
'Next

'Selects the whole IntrGrid
With IntrGrid
    .Visible = False
    .Row = 0
    .Col = 0
    .RowSel = .Rows - 1
    .ColSel = .Cols - 1
    .TopRow = 1
    .Visible = True
End With
    
Clipboard.Clear
Clipboard.SetText IntrGrid.Clip
    
'Deselects the whole IntrGrid
With IntrGrid
    .Visible = False
    .Row = 0
    .Col = 0
    .RowSel = 0
    .ColSel = 0
    .TopRow = 1
    .Visible = True
End With

' paste intrinsics
wsXL.Range("A10").Select
wsXL.Paste

Clipboard.Clear


'Selects the whole ParaGrid
With ParaGrid
    .Visible = False
    .Row = 0
    .Col = 0
    .RowSel = .Rows - 1
    .ColSel = .Cols - 1
    .TopRow = 1
    .Visible = True
End With
    
Clipboard.Clear
Clipboard.SetText ParaGrid.Clip
    
'Deselects the whole ParaGrid
With ParaGrid
    .Visible = False
    .Row = 0
    .Col = 0
    .RowSel = 0
    .ColSel = 0
    .TopRow = 1
    .Visible = True
End With

' paste parasitics
wsXL.Range("A1").Select
wsXL.Paste
Clipboard.Clear

' show Excel
ExcelApp.Visible = True

   
ErrHandler:
    If (Err.Number = 521) Then
        Dim result As Variant
        result = MsgBox("Clipboard error. Press Retry to try again.", vbRetryCancel + vbCritical)
        If result = vbRetry Then
            Resume Next
        Else
            Exit Sub
        End If
    End If


End Sub
