<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "community" : subMenuCode = "boardsort" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim strLocation,uploadform
Dim FileName,Idx,Page

Idx=Request("idx")
Page=Request("page")

Sql="SELECT boardidx From boardsort Where idx="&IDX
SET Rs=DBcon.Execute(Sql)
If Not(Rs.Bof Or Rs.Eof) Then
	boardidx=Rs(0)
End IF

Sql="DELETE boardsort WHERE idx="&Idx
DBcon.Execute Sql

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="boardsort.asp?boardidx="&boardidx
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>