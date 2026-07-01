<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "comcode" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim strLocation,uploadform
Dim FileName,Idx,Page

idx = uf_getRequest(Request("idx"),"int","","")
page = uf_getRequest(Request("page"),"int","","1")

Sql="SELECT Bansort From comcodeAdmin Where idx="&IDX
SET Rs=DBcon.Execute(Sql)
If Not(Rs.Bof Or Rs.Eof) Then Bansort=Rs(0)

Sql="DELETE comcodeAdmin WHERE idx="&Idx
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

strLocation="comcode.asp?Bansort="&Bansort
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>