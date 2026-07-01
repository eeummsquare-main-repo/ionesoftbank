<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim Content
Dim StrLocation

Name=Request("name")
Pwd=Request("pwd")
UserIdx="Null"

IF Pwd="" Then
	IF Session("UserIdx")="" Then
		Response.Write "alert('로그인이필요한페이지입니다.');"&Vbclrf
		DBcon.Close
		Set DBcon=Nothing
		Response.End
	Else
		UserIdx=Session("UserIdx")
		Name=Session("UserName")
	End IF
End IF

Content=ReplaceNoHtml(Replaceensine(Request("content")))
Idx=Request("idx")
bbscode=Request("bbscode")
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

Sql="Insert INTO CommentAdmin(boardcode,boardidx,useridx,oriuseridx,pwd,name,content,co_ref,co_ReLevel,co_pubYN) VALUES("&BBscode&","&boardidx&","&UserIdx&","&oriuseridx&",N'"&Pwd&"',N'"&Name&"',N'"&Content&"',"&co_ref&",'"&MaxReLevel&"',"&co_pubYN&")"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

Response.Write "alert('답변이 등록되었습니다.');"&Vbclrf
Response.Write "viewBoardCommentArea('"&boardidx&"','"&bbscode&"','"&Page&"');"&Vbclrf
%>