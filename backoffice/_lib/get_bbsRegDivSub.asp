<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
catecode = uf_getRequest(Request("catecode"),"int","","")

IF catecode<>"" Then
	Sql = "SELECT idx, pagename FROM pageINFO WHERE isDisplay=1 AND catecode<>0 AND catecode="&catecode&" ORDER BY listnum ASC, idx ASC"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		Do Until Rs.Eof
			Response.Write "<option value="""&Rs("idx")&""">"&ReplaceNoHtml(Rs("pagename"))&"</option>"&Vbcrlf
			Rs.MoveNext()
		Loop
	End IF
End IF

DBcon.Close
Set DBcon=Nothing
%>