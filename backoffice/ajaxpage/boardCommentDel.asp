<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim IDx,ManageYn,StrLocation,UIdx

Idx=Request("idx")
bbscode=Request("bbscode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

Page=Request("Page")

Sql="SELECT boardidx,co_ref,co_ReLevel from CommentAdmin WHERE idx="&Idx
Rs=DBcon.Execute(Sql)
boardidx=Rs(0) : co_ref=Rs(1) : co_ReLevel=Rs(2)

Sql="Select idx,co_ReLevel From CommentAdmin Where co_Ref="&co_ref&" AND co_ReLevel Like '"&co_ReLevel&"_'"
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Sql="DELETE CommentAdmin WHERE idx="&Idx
	DBcon.Execute Sql

	For i=Len(co_ReLevel)-1 To i=1 step i-1
		Sql="Select idx From CommentAdmin Where co_Ref="&co_Ref&" And co_ReLevel like '"&Left(co_ReLevel,i)&"%' AND co_DelYN<>1 AND idx<>"&IDx
		Set Rs=DBcon.Execute(Sql)

		IF Rs.Bof Or Rs.Eof Then
			Sql="Delete CommentAdmin Where co_Ref="&co_Ref&" And co_ReLevel Like '"&Left(co_ReLevel,i)&"%'"
			DBcon.Execute Sql
		Else
			Exit For
		End IF
	Next
Else
	Sql="Update CommentAdmin Set co_DelYN=1 Where idx="&Idx
	DBcon.Execute Sql
End IF

DBcon.Close
Set DBcon=Nothing

Response.Write "alert('코멘트가 삭제되었습니다.');"&Vbclrf
Response.Write "viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"&Vbclrf
%>