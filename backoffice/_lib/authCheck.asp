<%
Dim GB_TopMenu, GB_SubMenu, GB_pagePubYN
Dim GB_TopMenuName, GB_SubMenuName
ADLoginCk()

'===========관리메뉴GET================
Sql = "SELECT TOP 1 pubMenu, memsort FROM admin WHERE idx="&Session("acountidx")
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Call AD_Logout("", "/backoffice/login.asp")
End IF
GB_pubMenuCodes = Rs("pubMenu")
GB_ADMEMSORT = Rs("memsort")

Sql="SELECT idx, topcode, subcode, topName, subName, linkurl FROM menu WHERE idx IN ("&GB_pubMenuCodes&") And isUse=1 Order by listnum ASC, idx ASC"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then myMenuRec=Rs.GetRows()
'======================================

Sub GB_menuList()
	Dim tmpTopCode, seenTopCodes, seenTopNames
	seenTopCodes = "|"
	seenTopNames = "|"

	IF IsArray(myMenuRec) Then
		For i=0 To Ubound(myMenuRec,2)

			IF topMenuCode = myMenuRec(1,i) AND subMenuCode=myMenuRec(2,i) Then
				GB_pagePubYN = True
				GB_TopMenuName = myMenuRec(3,i)
				GB_SubMenuName = myMenuRec(4,i)
			End IF

			IF InStr(seenTopCodes, "|"&myMenuRec(1,i)&"|") = 0 _
				AND InStr(seenTopNames, "|"&myMenuRec(3,i)&"|") = 0 Then
				GB_TopMenu = GB_TopMenu & "<li dataTCode="""&myMenuRec(1,i)&""" ><a href="""&myMenuRec(5,i)&""">"&myMenuRec(3,i)&"</a></li>"&Vbcrlf
				seenTopCodes = seenTopCodes & myMenuRec(1,i) & "|"
				seenTopNames = seenTopNames & myMenuRec(3,i) & "|"
			End IF

			GB_SubMenu = GB_SubMenu & "<li dataTCode="""&myMenuRec(1,i)&""" dataSCode="""&myMenuRec(2,i)&"""><a href="""&myMenuRec(5,i)&""">"&myMenuRec(4,i)&"</a></li>"&Vbcrlf
			tmpTopCode = myMenuRec(1,i)
		Next
	End IF
End Sub

Call GB_menuList()

IF topMenuCode<>"" AND GB_pagePubYN<>True Then
	Response.Write ExecJavaAlert("관리권한이 없는 컨텐츠입니다.",0)
	Response.END
End IF
%>