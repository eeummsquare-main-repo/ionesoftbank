<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
subjectidx = uf_getRequest(Request("subjectidx"),"int","","")

IF subjectidx<>"" Then
	Sql="Select idx, title From staffAdmin Where subjectidx="&subjectidx&" Order By listNum ASC,idx ASC"
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Set Rs=Nothing
End IF

Response.write "var $target = $(""#staffidx"");"&vbcrlf
Response.write "$target.attr(""dataVal"","""");"&vbcrlf
Response.write "$target.empty();"&vbcrlf
Response.write "$target.append(""<option value=''>선택하세요</option>"");"&vbcrlf

IF IsArray(Allrec) Then
	For i=0 To Ubound(Allrec,2)
		Response.write "$target.append(""<option value='"&Allrec(0,i)&"'>"&Allrec(1,i)&"</option>"");"&vbcrlf
	Next
End IF

DBcon.Close
Set DBcon=Nothing
%>