<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
sort=Request("sort")
catecode=Request("catecode")

IF sort="1" Then
	Sql="Select lowcode, name FROM Category WHERE topcode='"&catecode&"' AND lowcode<> topcode AND isDisplay=1 ORDER BY align1Num, align2Num, align3Num"
	Set Rs=DBCon.Execute(Sql)
	IF Not(Rs.Bof OR Rs.Eof) Then Allrec=Rs.GetRows()

	Response.Write "$(""#sercate2 option[value!='']"").remove();"&Vbcrlf
	Response.Write "$(""#sercate3 option[value!='']"").remove();"&Vbcrlf

	IF IsArray(Allrec) Then
		For i = 0 To Ubound(Allrec,2)
			Response.Write "$(""#sercate2"").append(""<option value='"&Allrec(0,i)&"'>"&Allrec(1,i)&"</option>"");"&Vbcrlf
		Next
	End IF
Else
	Sql="Select idx, itemname FROM product WHERE catecode='"&catecode&"' AND display=1 ORDER BY listnum ASC, idx DESC"
	Set Rs=DBCon.Execute(Sql)
	IF Not(Rs.Bof OR Rs.Eof) Then Allrec=Rs.GetRows()

	Response.Write "$(""#sercate3 option[value!='']"").remove();"&Vbcrlf

	IF IsArray(Allrec) Then
		For i = 0 To Ubound(Allrec,2)
			Response.Write "$(""#sercate3"").append(""<option value='"&Allrec(0,i)&"'>"&Allrec(1,i)&"</option>"");"&Vbcrlf
		Next
	End IF
END IF

DBcon.Close
Set DBcon=Nothing
%>