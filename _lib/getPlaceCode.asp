<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim retCode : retCode = ""
idx = uf_getRequest(Request("idx"),"int","","")

IF idx<>"" Then
	Sql = "SELECT areaCode, areaNm FROM testPlace WHERE idx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		retCode = Rs(0)
	End IF
End IF

DBcon.Close
Set DBcon=Nothing

Response.Write retCode
%>