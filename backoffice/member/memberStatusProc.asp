<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
chkidx = Request("chkidx")
cColumn = Request("cColumn")
cVal = Request("cVal")

IF chkidx<>"" AND cColumn<>"" AND cVal<>"" Then
	Sql = "UPDATE Members SET "&cColumn&"="&cVal&" WHERE idx IN("&chkidx&")"
	DBcon.Execute(Sql)
	Response.Write "OK"
Else
	Response.Write "ERROR"
End IF
%>