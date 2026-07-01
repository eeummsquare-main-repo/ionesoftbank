<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim strLocation,uploadform
Dim FileName,Idx,Page

itemidx = Request("itemidx")
Idx = Request("idx")

Sql="DELETE productRelation WHERE relationidx IN ("&IDX&") AND itemidx='"&itemidx&"'"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

Response.Write "OK"
%>