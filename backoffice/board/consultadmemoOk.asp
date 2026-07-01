<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub05" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/consult/")

'검색 필드 관련===============================
Page = uf_getRequest(uploadform("Page"),"int","","")
pagesize = uf_getRequest(uploadform("pagesize"),"int","","")

serDate1 = uf_getRequest(uploadform("serDate1"),"date","","")
serDate2 = uf_getRequest(uploadform("serDate2"),"date","","")
serStatus = uf_getRequest(uploadform("serStatus"),"int","","")
seritem = uf_getRequest(uploadform("seritem"),"int","","")
searchstr = uf_getRequest(uploadform("searchstr"),"char","","")
oSearchstr = uploadform("searchstr")

PageLink="consult.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = uf_getRequestProc(uploadform("idx"),"int","","0")
status = uf_getRequestProc(uploadform("status"),"int","","0")
adMemo = uf_getRequestProc(uploadform("adMemo"),"char","","")

Sql="UPDATE consult SET adMemo=?, memoModDate=getDate(), memoWid=?, memoWname=?, status=? Where idx="&idx
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@adMemo", adVarWChar, adParamInput, 2147483647, adMemo)
	.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Session("acountcode"))
	.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Session("acountname"))
	.Parameters.Append .CreateParameter("@par", adTinyint, adParamInput, 4, status)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

DBcon.Close
Set DBcon = Nothing

strLocation="top.location.reload();"
Response.Write ExecJavaAlert("저장되었습니다.","3")
%>