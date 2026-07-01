<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
catecode = uf_getRequest(Request("catecode"),"char","50","")
depth = uf_getRequest(Request("depth"),"int","","")

IF catecode<>"" AND (depth="1" Or depth="2") Then
	IF depth="1" Then
		inputName = "catecode2"
		Sql="SELECT name, lowcode, dbo.fn_CateBarIMG(lowcode) AS CateIMG From Category Where Topcode='"&catecode&"' AND lowcode=middlecode AND lowcode<>topcode Order By align1Num ASC,align2Num ASC,align3Num ASC"
	ElseIF depth="2" Then
		inputName = "catecode3"
		Sql="SELECT name, lowcode, dbo.fn_CateBarIMG(lowcode) AS CateIMG From Category Where middlecode='"&catecode&"' AND lowcode<>middlecode AND lowcode<>topcode Order By align1Num ASC,align2Num ASC,align3Num ASC"
	End IF
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Rs.Close
	Set Rs=Nothing
End IF

IF IsArray(Allrec) Then
	For i=0 To Ubound(Allrec,2)
		Response.Write "		<p class=""check"">"&Vbcrlf
		Response.Write "			<input type=""radio"" id=""cg_"&Allrec(1,i)&""" name="""&inputName&""" value="""&Allrec(1,i)&""" dataIMG="""&Allrec(2,i)&""" />"&Vbcrlf
		Response.Write "			<label for=""cg_"&Allrec(1,i)&""">"&ReplaceNoHtml(Allrec(0,i))&"</label>"&Vbcrlf
		Response.Write "		</p>"&Vbcrlf
	Next
End IF

DBcon.Close
Set DBcon=Nothing
%>