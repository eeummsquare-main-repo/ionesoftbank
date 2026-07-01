<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","","")

IF idx<>"" Then
	Sql="SELECT content From prodinfoAdmin WHERE idx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		Response.Write Rs(0)
	End IF
End IF
%>
