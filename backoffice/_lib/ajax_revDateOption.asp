<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "rev" : subMenuCode = "consult" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
staffidx = uf_getRequest(Request("staffidx"),"int","","")
revDate = uf_getRequest(Request("revDate"),"date","","")

startDate = DateAdd("d",-7,Date())
endDate = DateAdd("m",2,Date())

IF revDate<>"" AND CStr(revDate)<CStr(startDate) Then
	startDate = revDate
End IF

IF staffidx<>"" Then
	Sql = "SELECT revDate FROM (SELECT CONVERT(VARCHAR(10), DATEADD(DAY,number,'"&startDate&"'), 21) revDate FROM master..spt_values WHERE type = 'P' AND DATEADD(DAY,number,'"&startDate&"') < '"&endDate&"') TB WHERE revDate NOT IN ( SELECT dates FROM resBlockDate WHERE dates>='"&startDate&"' AND dates<='"&endDate&"' AND staffidx="&staffidx&")"
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Set Rs=Nothing
End IF

Response.write "var $target = $(""#revDate"");"&vbcrlf
Response.write "$target.attr(""dataVal"","""");"&vbcrlf
Response.write "$target.empty();"&vbcrlf
Response.write "$target.append(""<option value=''>선택하세요</option>"");"&vbcrlf

IF IsArray(Allrec) Then
	For i=0 To Ubound(Allrec,2)
		IF weekDay(Allrec(0,i)) <> "1" Then
			Response.write "$target.append(""<option value='"&Allrec(0,i)&"'>"&Allrec(0,i)&" ("&getWeekDay(Allrec(0,i))&")</option>"");"&vbcrlf
		End IF
	Next
End IF

DBcon.Close
Set DBcon=Nothing
%>