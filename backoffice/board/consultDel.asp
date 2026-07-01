<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub05" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Page = uf_getRequest(Request("Page"),"int","","")
pagesize = uf_getRequest(Request("pagesize"),"int","","")

serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

PageLink="consult.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = uf_getRequest(Request("idx"),"char","","")

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/consult/")

'Sql="SELECT pic From consult Where idx IN ("&idx&")"
'SET Rs=DBcon.Execute(Sql)
'Do Until Rs.Eof
'	FileNames=Rs("pic")
'	IF FileNames<>"" Then ImgDelete FileNames,UploadForm.DefaultPath

'	Rs.MoveNext()
'Loop

Sql="Delete Consult Where idx IN ("&idx&")"
DBcon.Execute Sql

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation = PageLink&"?page="&Page&"&"&PageStr
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>