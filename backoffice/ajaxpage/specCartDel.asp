<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx=uf_getRequest(Request("idx"), "int", "", "0")

IF idx <> "" Then
	Sql="DELETE specCart Where idx="&idx
	DBcon.Execute(Sql)
End IF

dbcon.close
set dbcon=Nothing
%>