<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode
BBSCode=Request("BBscode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

idx = Request("idx")
status = Request("status")

Sql="UPDATE BBSLIST SET status="&status&" WHERE idx IN ("&idx&")"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

Response.Write "OK"
%>