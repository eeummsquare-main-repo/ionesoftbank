<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Selcodes,Num,i,CateIdx,strLocation

langmode=Request("langmode")
Bansort=Request("Bansort")
SelCodes=Request("selcodes")
Selcodes=Split(Selcodes,",")
	
Num=1
For i=0 To Ubound(SelCodes)
	Sql="UPDATE categoryAdmin SET ListNum="&Num&" WHERE idx="&SelCodes(i)
	DBcon.Execute Sql
	Num=Num+1
Next

Dbcon.Close
Set Dbcon=Nothing

strLocation="category.asp?langmode="&langmode&"&Bansort="&Bansort
Response.Write ExecJavaAlert("게시물 순서가 수정되었습니다.",2)
%>
