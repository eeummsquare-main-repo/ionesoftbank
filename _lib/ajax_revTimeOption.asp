<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
staffidx = uf_getRequest(Request("staffidx"),"int","","")
revDate = uf_getRequest(Request("revDate"),"date","","")
modiidx = uf_getRequest(Request("modiidx"),"int","","")

Response.write "var $target = $(""#revTime"");"&vbcrlf
Response.write "$target.attr(""dataVal"","""");"&vbcrlf
Response.write "$target.empty();"&vbcrlf
Response.write "$target.append(""<option value=''>선택하세요</option>"");"&vbcrlf

IF staffidx<>"" AND revDate<>"" Then
	week = weekDay(revDate)
	revTimes = ","

	IF modiidx = "" Then
		Sql = "SELECT revTime FROM consult WHERE revDate='"&revDate&"' AND staffidx="&staffidx
	Else
		Sql = "SELECT revTime FROM consult WHERE idx<>"&modiidx&" AND revDate='"&revDate&"' AND staffidx="&staffidx
	End IF

	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		Do Until Rs.Eof
			revTimes = revTimes &Rs(0) & ","
			Rs.MoveNext
		Loop
	End IF

	IF week=7 Then
		endMinute = 760
	Else
		endMinute = 1050
	End IF

	For i=540 To endMinute Step 10
		strHour = int(i / 60)
		strMinute = i MOD 60
		
		IF i < 760 OR i>830 Then
			strTime = addZero(strHour)&":"&addZero(strMinute)

			IF InStr(revTimes, ","&strTime&",") = 0 Then
				Response.write "$target.append(""<option value='"&strTime&"'>"&strTime&"</option>"");"&vbcrlf
			End IF
		End IF
	Next
End IF

DBcon.Close
Set DBcon=Nothing
%>