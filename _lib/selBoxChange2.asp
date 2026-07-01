<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
response.expires = -1 

ItemBoxViewYN=""
catecode=Replaceensine(Request("catecode"))
lccode=Replaceensine(Request("lccode"))
lowcode=Replaceensine(Request("lowcode"))

IF catecode<>"" Then
	Sql="Select lowcode,name From Category Where middlecode='"&catecode&"' AND lowcode<>middlecode AND lowcode<>topcode Order By align1Num ASC,align2Num ASC,align3Num ASC"
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()
	Rs.Close
	Set Rs=Nothing
END IF

Response.write "var cnt=document.getElementById('selBox3').length;"&vbcrlf
Response.Write "for(var i=0;i<cnt;i++){ document.getElementById('selBox3').remove(1); }"&Vbcrlf

IF IsArray(Allrec) Then
	For i=0 To Ubound(Allrec,2)
		Response.write "document.getElementById('selBox3').options.add(new Option('"&Allrec(1,i)&"','"&Allrec(0,i)&"'));"&Vbcrlf
	Next

	IF lccode<>"" Then
		Response.write "for(i=0;i<document.getElementById('selBox3').options.length;i++){"&Vbcrlf
		Response.write "	if(document.getElementById('selBox3').options[i].value=="&lccode&"){"&Vbcrlf
		Response.write "		document.getElementById('selBox3').options[i].selected=true; break;"&Vbcrlf
		Response.write "	}"&Vbcrlf
		Response.write "}"&Vbcrlf
	End IF
End IF

DBcon.Close
Set DBcon=Nothing
%>