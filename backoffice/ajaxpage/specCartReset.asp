<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Set Rs=Server.CreateObject("ADODB.RecordSet")

Sql="SELECT idx,title From specCart Order by idx DESC"
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then specCartRec=Rs.GetRows
Rs.Close

Set Rs=Nothing
dbcon.close
set dbcon=Nothing

Response.write "var f=document.goods_form;"&Vbcrlf
Response.write "var cnt=f.scartidx.length;"&vbcrlf
Response.Write "for(var i=0;i<cnt;i++){ f.scartidx.remove(1); }"&Vbcrlf

IF IsArray(specCartRec) Then
	For i=0 To Ubound(specCartRec,2)
		Response.write "f.scartidx.options.add(new Option("""&ReplaceJScript(specCartRec(1,i))&""","""&ReplaceJScript(specCartRec(0,i))&"""));"
	Next
End IF
%>