<!-- #include virtual = _lib/common.asp -->
<!-- #include virtual = _lib/dbcon.asp -->
<%
areaidx=Replaceensine(Request("selVal"))

IF areaidx<>"" Then
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="Select idx,areaname From areadetail Where areaidx="&areaidx&" Order By areaname ASC, idx ASC"
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()

	Rs.Close
	Set Rs=Nothing
END IF

IF IsArray(Allrec) Then
	For i=0 To Ubound(Allrec,2)
		Response.Write "<option value="""&Allrec(0,i)&""">"&Allrec(1,i)&"</option>"&Vbcrlf
	Next
End IF

DBcon.Close
Set DBcon=Nothing
%>