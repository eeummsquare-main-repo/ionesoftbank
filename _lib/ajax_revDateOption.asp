<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
staffidx = uf_getRequest(Request("staffidx"),"int","","")

startDate = DateAdd("d",2,Date())
endDate = DateAdd("m",1,startDate)

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