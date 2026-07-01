<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim Content,Idx
Dim StrLocation

Content=ReplaceNoHtml(Replaceensine(Request("content")))
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

Sql="SELECT boardidx,co_ref,co_ReLevel,co_pubYN,isNull(oriuseridx,-1) from CommentAdmin WHERE idx="&Idx
Rs=DBcon.Execute(Sql)
boardidx=Rs(0) : co_ref=Rs(1) : co_ReLevel=Rs(2) : co_pubYN=Rs(3) : oriuseridx=Rs(4)
IF CStr(oriuseridx)="-1" Then oriuseridx="null"

Dim MaxReLevelRec,MaxReLevel
Sql="Select Top 1 co_ReLevel From CommentAdmin Where co_ref="&co_ref&" And co_ReLevel Like '"&co_ReLevel&"_' Order By co_ReLevel DESC"
Set MaxReLevelRec=DBcon.Execute(Sql)

IF MaxReLevelRec.Eof Then
	MaxReLevel = co_ReLevel&"A"
Else
	MaxReLevel = co_ReLevel&Chr(ASC(Right(MaxReLevelRec(0),1))+1)
End IF

Set MaxReLevelRec=Nothing

Sql="Insert INTO CommentAdmin(boardcode,boardidx,useridx,pwd,name,content,cadwrite,co_ref,co_ReLevel,co_pubYN,oriuseridx) VALUES("&BBscode&","&boardidx&","&Session("acountidx")&",'',N'관리자',N'"&Content&"',1,"&co_ref&",'"&MaxReLevel&"',"&co_pubYN&","&oriuseridx&")"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

Response.Write "alert('답변이 등록되었습니다.');"&Vbclrf
Response.Write "viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"&Vbclrf
%>