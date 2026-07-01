<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","","0")
Useridx = uf_getRequest(Session("useridx"),"int","","0")

Sql="SELECT status From Estimate Where idx="&idx&" AND useridx="&Useridx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.Write "1"
	Response.End
Else
	status=Rs("status")

	IF status=0 Then
		Sql="UPDATE Estimate Set status=8 Where idx="&idx
		DBcon.Execute Sql
	Else
		Response.Write "2"
		Response.End
	End IF
End IF

DBcon.Close
Set DBcon=Nothing

Response.Write "complete"
Response.End
%>