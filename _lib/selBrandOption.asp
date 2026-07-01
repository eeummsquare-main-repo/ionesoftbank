<!-- #include virtual = _lib/common.asp -->
<!-- #include virtual = _lib/dbcon.asp -->
<%
catecode=Replaceensine(Request("catecode"))

IF catecode<>"" Then
	Sql = "SELECT mbTitle FROM category Where lowcode='"&Catecode&"'"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		sCateStr = changeBlank(Rs(0))
	End IF

	IF sCateStr<>"" Then arrSubCate = Split(sCateStr, "|")
END IF

IF IsArray(arrSubCate) Then
	For i=0 To Ubound(arrSubCate)
		Response.Write "<option value="""&i&""">"&arrSubCate(i)&"</option>"&Vbcrlf
	Next
End IF

DBcon.Close
Set DBcon=Nothing
%>