<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim strLocation
Dim Page,Idx
Dim serDate1, serDate2, seritem, serStr, pageSize

langmode = Request("langmode")
serboardsort = Request("serboardsort")
sersubsort = Request("sersubsort")
serDate1 = Request("serDate1")
serDate2 = Request("serDate2")
pageSize = Request("PageSize")
seritem = Request("seritem")
serStr = Request("serStr")

Page=Request("page")
idx=Request("idx")

Sql = "SELECT edNonce FROM Faq Where Idx IN ("&Idx&")"
Set Rs = DBcon.Execute(Sql)
Do Until Rs.Eof
	edNonce = Rs("edNonce")

	'###### 에디터 등록이미지 삭제처리 ##########
	Call edNonceRemove(edNonce)
	'###### 에디터 등록이미지 삭제처리 ##########

	Rs.MoveNext()
Loop

Sql="Delete Faq Where Idx IN ("&Idx&")"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

strLocation="faqList.asp?page="&Page&"&langmode="&langmode&"&serboardsort="&serboardsort&"&sersubsort="&sersubsort&"&serDate1="&serDate1&"&serDate2="&serDate2&"&seritem="&seritem&"&pageSize="&pageSize&"&serStr="&serStr
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>