<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "board" : subMenuCode = "estimate" %>
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
seritem = uf_getRequest(uploadform("seritem"),"int","2","0")
searchstr = uf_getRequest(uploadform("searchstr"),"char","","")
oSearchstr = uploadform("searchstr")

PageLink="estimate.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = uf_getRequestProc(uploadform("idx"),"int","","0")

Sql = "SELECT email, name, id FROM estimate E INNER JOIN MEMBERS M ON E.useridx=M.idx WHERE E.idx="&idx
Set Rs = DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	ErrorMsg = "발송대상 메일 정보를 찾을수 없습니다."
Else
	UserEmail = Rs("email")
	Username = Rs("name")
	Userid = Rs("id")
End IF

IF UserEmail="" Then
	ErrorMsg = "발송대상 메일 정보를 찾을수 없습니다."
End IF

DBcon.close
Set DBcon=Nothing

IF ErrorMsg="" Then
	toEmail = "삼익산업<webmail@samik.iceserver.co.kr>" '보내는사람
	ReEmail = UserEmail '받는사람

	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/quotation.html",1,false,-1)
	MailBody = f.ReadAll

	MailBody=Replace(MailBody,"__%Domain%__",Request.Servervariables("Server_name"))
	MailBody=Replace(MailBody,"__%USERNAME%__",Username)
	MailBody=Replace(MailBody,"__%ESTIDX%__",idx)

	Title="[삼익산업] 요청하신 견적서를 확인해주세요."

	Call subSendMailSMTP(toEmail, ReEmail, Title, MailBody, 0, "")

	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert("메일발송완료.","3")
Else
	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert(ErrorMsg,"3")
End IF
%>