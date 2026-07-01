<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Name=ReplaceEnsine(Request("name"))
birthday=ReplaceEnsine(Request("birthday"))
Pwd=Request("pwd")
UserIdx="Null"
co_pubYN=SpaceToZero(Request("co_pubYN"))

IF Pwd="" Then
	IF Session("UserIdx")="" Then
		Pwd = ""
'		Response.Write "alert('로그인이필요한페이지입니다.');"&Vbclrf
'		DBcon.Close
'		Set DBcon=Nothing
'		Response.End
	Else
		UserIdx=Session("UserIdx")
		Name=Session("UserName")
	End IF
End IF

Content = ReplaceNoHtml(Replaceensine(Request("content")))
Idx = Request("idx")
bbscode = Request("bbscode")

Sql="Insert INTO CommentAdmin(boardcode,boardidx,useridx,pwd,name,content,co_pubYN,oriuseridx) VALUES("&BBscode&","&Idx&","&UserIdx&",N'"&Pwd&"',N'"&Name&"',N'"&Content&"',"&co_pubYN&","&UserIdx&")"
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