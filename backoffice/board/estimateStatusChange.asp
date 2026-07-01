<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "board" : subMenuCode = "estimate" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<!--#include virtual = _lib/smsLibrary.asp-->
<!--#include virtual = _lib/smsSetting.asp-->
<!--#include virtual = _lib/json/JSON_2.0.4.asp-->
<!--#include virtual = _lib/json/json2.asp-->
<%
'검색 필드 관련===============================
Page = uf_getRequest(Request("Page"),"int","","")
pagesize = uf_getRequest(Request("pagesize"),"int","","")

serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","2","0")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

PageLink="estimate.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = Request("idx")
status = Request("status")

Sql = "UPDATE estimate SET status="&status&" Where idx IN ("&idx&")"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

strLocation = PageLink&"?page="&Page&"&"&PageStr
Response.Write ExecJavaAlert("선택하신 신청서의 상태가 수정되었습니다.",2)
%>