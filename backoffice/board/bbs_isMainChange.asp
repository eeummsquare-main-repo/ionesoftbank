<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","","")
isMain = uf_getRequest(Request("isMain"),"int","","0")
isMainNum = uf_getRequest(Request("isMainNum"),"int","","0")

IF isMain = 0 Then isMainNum=0

IF idx<>"" Then
	Sql="UPDATE BBSLIST SET isMain="&isMain&", isMainNum="&isMainNum&" WHERE idx IN ("&idx&")"
	DBcon.Execute Sql
End IF

DBcon.Close
Set DBcon=Nothing

Response.Write "OK"
%>