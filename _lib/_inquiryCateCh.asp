<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
mCd = uf_getRequest(Request("mCd"),"char","","")

IF mCd<>"" AND mCd<>"etc" Then
	Sql = "SELECT code, name From COMCODE WHERE groupCode='"&mCd&"' Order By listNum ASC,idx ASC"
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Set Rs=Nothing
End IF
Response.Write "OK|"

IF IsArray(Allrec) Then
	For i=0 To Ubound(Allrec,2)
		code = ChangeBlank(Allrec(0,i))
		name = ChangeBlank(Allrec(1,i))
		Response.write "<option value="""&code&""">"&name&"</option>"&vbcrlf
	Next
End IF

DBcon.Close
Set DBcon=Nothing
%>