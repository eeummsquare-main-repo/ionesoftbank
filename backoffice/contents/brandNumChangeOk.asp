<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "brand" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim dbidx,Num,i,CateIdx,strLocation

langmode=Request("langmode")
Bansort=Request("Bansort")
dbidx=Request("dbidx")
dbidx=Split(dbidx,",")
	
Num=1
For i=0 To Ubound(dbidx)
	Sql="UPDATE brandAdmin SET ListNum="&Num&" WHERE idx="&dbidx(i)
	DBcon.Execute Sql
	Num=Num+1
Next

Dbcon.Close
Set Dbcon=Nothing

strLocation="brand.asp?langmode="&langmode&"&Bansort="&Bansort
Response.Write ExecJavaAlert("노출순서가 저장되었습니다.",2)
%>
