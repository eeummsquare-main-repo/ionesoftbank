<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "comcode" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Selcodes,Num,i,CateIdx,strLocation

Bansort=Request("Bansort")
SelCodes=Request("selcodes")
Selcodes=Split(Selcodes,",")
	
Num=1
For i=0 To Ubound(SelCodes)
	Sql="UPDATE comcodeAdmin SET ListNum="&Num&" WHERE idx="&SelCodes(i)
	DBcon.Execute Sql
	Num=Num+1
Next

Dbcon.Close
Set Dbcon=Nothing

strLocation="comcode.asp?Bansort="&Bansort
Response.Write ExecJavaAlert("게시물 순서가 수정되었습니다.",2)
%>
