<%
seritemidx=Request("seritemidx")
serboardsort=Request("serboardsort")
itemidx=seritemidx

Call HK_BBSSetup(BBsCode)
BBsViewModeChk("write")
BbsAdminChk()

IF isSetBSort<>True Then
	BBsSort=GetBoardSort(BBsCode,serboardsort,ReLevel)
Else
	Dim boardSortName
	BoardSort = CheckBoardsortAndRedim(bbscode,serboardsort)
End IF
%>