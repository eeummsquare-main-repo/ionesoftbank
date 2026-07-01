<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "align" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Selcode,Special,CateIdx,strLocation

SelCode=Request("selcode")
SelCode=Replace(SelCode,", ",",")
Special=Request("special")
CateIdx=Request("cateidx")

Sql="DELETE productAlignTB WHERE mainsort='"&Special&"' AND itemidx IN ("&SelCode&")"
DBcon.Execute Sql

DBCON.Close
Set DBCON=Nothing

strLocation="productAlign.asp?special="&Special&"&cateidx="&CateIdx
Response.Write ExecJavaAlert("선택하신 게시물이 코너에서 삭제되었습니다.",2)
%>
