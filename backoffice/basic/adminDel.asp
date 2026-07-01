<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "admin" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim idx, page, strLocation

page = uf_getRequest(Request("page"),"int","","1")
idx = uf_getRequest(Request("idx"),"int","","0")

IF CSTR(idx)="0" Then
	Response.write Execjavaalert("접근할수 없는 사용자코드입니다.\n다시시도해주세요.",0)
	Response.End
ElseIF CSTR(idx)="1" Then
	Response.write Execjavaalert("Super Admin 계정입니다.\n해당 계정은 삭제가 불가능합니다.",0)
	Response.End
End IF

Sql="Delete admin Where idx="&Idx
DBcon.Execute Sql

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="adminlist.asp?page="&Page
Response.Write ExecJavaAlert("선택하신 유저가 삭제되었습니다.",2)
%>