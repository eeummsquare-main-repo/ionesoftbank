<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim dbidx,Num,i,CateIdx,strLocation

itemidx = Request("itemidx")

langmode=Request("langmode")
dbidx=Request("dbidx")

dbidx=Split(dbidx,",")

Num=1
For i=0 To Ubound(dbidx)
	Sql="UPDATE productRelation SET listnum="&Num&" WHERE relationidx="&dbidx(i)&" AND itemidx='"&itemidx&"'"
	DBcon.Execute Sql
	Num=Num+1
Next

Dbcon.Close
Set Dbcon=Nothing

Response.Write "OK"
%>
