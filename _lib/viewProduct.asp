<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Sql="SELECT TOP 20 p.idx, itemname, listimg FROM Product AS P INNER JOIN ViewProduct AS C ON C.itemidx = p.idx WHERE display=1 AND sessionId='"&Session.SessionID&"' ORDER BY c.idx DESC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_List()
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			imgTag = ""
			IF Allrec(2,i)<>"" Then imgTag = "background-image: url('/upload/product/"&Allrec(2,i)&"');"
			Response.Write "<a href=""../product/product_view.asp?idx="&Allrec(0,i)&""" class=""slider"" style="""&imgTag&"""></a>"&Vbcrlf
		Next
	End IF
End Function
%>
<%=PT_List%>