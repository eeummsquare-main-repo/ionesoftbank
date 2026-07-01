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

Sql="Insert INTO CommentAdmin(boardcode,boardidx,useridx,pwd,name,content,cadwrite) VALUES("&BBscode&","&Idx&","&Session("acountidx")&",'',N'관리자',N'"&Content&"',1)"
DBcon.Execute Sql

'=================원글 코멘트 셋팅================
Dim MaxIdx

Sql="Select Max(Idx) From CommentAdmin"
MaxIdx=DBcon.Execute(Sql)

Sql="UPDATE CommentAdmin Set co_Ref="&MaxIdx(0)&",co_ReLevel='A' Where idx="&MaxIdx(0)
DBcon.Execute Sql
'=================================================

DBcon.Close
Set DBcon=Nothing

Response.Write "alert('코멘트가 등록되었습니다.');"&Vbclrf
Response.Write "viewBoardCommentArea('"&idx&"','"&bbscode&"','');"&Vbclrf
%>