<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "intra" : subMenuCode = "intra" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'==========검색 관련=========================================
page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("PageSize"),"int","","10")

search = uf_getRequest(Request("search"),"char","","")
searchStr = uf_getRequest(Request("searchstr"),"char","","")	
searchMemsort = uf_getRequest(Request("searchMemsort"),"int","","")

oSearchStr = Request("searchstr")

PageLink="intraUser.asp"
PageStr="pagesize="&PageSize&"&search="&search&"&searchMemsort="&searchMemsort&"&searchstr="&Server.UrlEncode(oSearchStr)
'==========검색 관련=========================================

idx = uf_getRequest(Request("idx"),"int","","")

IF idx <> "" THen
	Sql="Delete intraUser Where idx="&Idx
	DBcon.Execute Sql
End IF

DBcon.Close
Set DBcon=Nothing

strLocation=PageLink&"?page="&Page&"&"&PageStr
Response.Write ExecJavaAlert("선택하신 유저가 삭제되었습니다.",2)
%>