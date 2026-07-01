<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub08" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

seritem = uf_getRequest(Request("seritem"),"int","","0")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "list.asp"
PageStr = "seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

dbidx=Request("dbidx")
dbidx=Split(dbidx,",")
	
Num=1
For i=0 To Ubound(dbidx)
	Sql="UPDATE storeAdmin SET ListNum="&Num&" WHERE idx="&dbidx(i)
	DBcon.Execute Sql
	Num=Num+1
Next

Dbcon.Close
Set Dbcon=Nothing

strLocation = PageLink&"?page="&page&"&"&PageStr
Response.Write ExecJavaAlert("노출순서가 저장되었습니다.",2)
%>
