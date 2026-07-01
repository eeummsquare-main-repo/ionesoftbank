<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim Content,Idx
Dim StrLocation

Page=Request("Page")

Content=ReplaceNoHtml(Replaceensine(Request("content")))
Idx=Request("idx")
BBscode=Request("BBscode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

Sql="Select Top 1 boardidx From commentAdmin Where idx="&Idx
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Response.Write "alert('잘못된접근입니다.');"&Vbclrf
	DBcon.Close
	Set DBcon=Nothing
	Response.End
Else
	boardidx=Rs("boardidx")
End IF

Sql="UPDATE commentAdmin Set content=N'"&content&"' Where idx="&Idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

Response.Write "alert('코멘트가 수정되었습니다.');"&Vbclrf
Response.Write "viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"&Vbclrf
%>