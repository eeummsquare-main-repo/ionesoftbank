<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Sql = "SELECT catecode, catename FROM pageINFO WHERE isDisplay=1 AND catecode<>0 Group By catecode, catename ORDER BY catecode ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	Do Until Rs.Eof
		Response.Write "<option value="""&Rs("catecode")&""">"&ReplaceNoHtml(Rs("catename"))&"</option>"&Vbcrlf
		Rs.MoveNext()
	Loop
End IF

DBcon.Close
Set DBcon=Nothing
%>