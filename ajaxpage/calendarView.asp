<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
strDate = uf_getRequest(Request("strDate"),"char","10","")
bbscode = uf_getRequest(Request("bbscode"),"int","",1)

Sql="SELECT title, content, startdate, enddate FROM bbslist WHERE startdate='"&strDate&"' AND boardidx='"&bbscode&"'"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec = Rs.GetRows()
Set Rs=Nothing

DBcon.Close
Set DBcon=Nothing

Function PT_List()
	IF isArray(Allrec) Then
		Response.Write "<ul class=""calendarList mt30"">"&Vbcrlf
		For i = 0 To Ubound(Allrec,2)
			Response.Write "	<li>"&Vbcrlf
			Response.Write "		<div class=""tit"">"&Allrec(0,i)&"</div>"&Vbcrlf
			Response.Write "		<div class=""day"">기간 : "&Allrec(2,i)&" ~ "&Allrec(3,i)&"</div>"&Vbcrlf
			Response.Write "		<div class=""txt"">"&Allrec(1,i)&"</div>"&Vbcrlf
			Response.Write "	</li>"&Vbcrlf
		Next
		Response.Write "</ul>"&Vbcrlf
	End IF
End Function

Response.Write PT_List()
%>