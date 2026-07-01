<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

Dim BBsCode
BBSCode = uf_getRequest(uploadform("BBSCode"),"int","","1")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

idx = uf_getRequestProc(uploadform("idx"),"int","","")
adMemo = uf_getRequestProc(uploadform("adMemo"),"char","","")
adMemo1 = uf_getRequestProc(uploadform("adMemo1"),"char","","")
status = uf_getRequestProc(uploadform("status"),"int","","0")

IF idx<>"" Then
	Sql = "SELECT boardidx, title, writer, regdate, content, Wip, email, status, comDate, statusChDate FROM bbslist WHERE idx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		DB_boardidx = changeBlank(Rs("boardidx"))
		DB_title = changeBlank(Rs("title"))
		DB_writer = changeBlank(Rs("writer"))
		DB_regdate = changeBlank(Rs("regdate"))
		DB_content = changeBlank(Rs("content"))
		DB_Wip = changeBlank(Rs("Wip"))
		DB_email = changeBlank(Rs("email"))
		DB_status = changeBlank(Rs("status"))
		DB_comDate = changeBlank(Rs("comDate"))
		statusChDate = Rs("statusChDate")
	End IF
End IF


'######### 답변 첨부파일 업로드 ##########
Dim arr_DfileNm : arr_DfileNm = ""
For i=1 To UploadForm("dfiles").count
	dbFileName = ""
	dbFileName = UploadForm("dbdfiles")(i)

	IF UploadForm("dfiledel_idx")(i)="1" Then
		IF dbFileName<>"" Then
			ImgDelete dbFileName,UploadForm.DefaultPath
		End IF

		IF UploadForm("dfiles")(i)<>"" Then
			dbFileName = ImgSaves(UploadForm("dfiles")(i),uploadform.DefaultPath,3072000000)
		Else
			dbFileName = ""
		End IF
	End IF

	IF dbFileName<>"" Then
		IF arr_DfileNm<>"" Then arr_DfileNm = arr_DfileNm & "|"
		arr_DfileNm = arr_DfileNm & dbFileName
	End IF
Next
'######### 답변 첨부파일 업로드 ##########

comDate = null

IF status="9" Then
	comDate = Now()

	IF CStr(status) = CStr(DB_status) Then
		comDate = DB_comDate
	Else
		comDate = Now()
	End IF
Else
	comDate = null
End IF

IF CStr(status) <> CStr(DB_status) Then statusChDate = Now()

Sql="UPDATE bbslist SET status=?, adMemo=?, adMemo1=?, memoModDate=getDate(), memoWid=?, memoWname=?, comdate=?, statusChDate=?, memoFileNm=? Where idx="&idx
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@status", adTinyint, adParamInput, 1, status)
	.Parameters.Append .CreateParameter("@adMemo", adVarWChar, adParamInput, 2147483647, adMemo)
	.Parameters.Append .CreateParameter("@adMemo", adVarWChar, adParamInput, 2147483647, adMemo1)
	.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Session("acountcode"))
	.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Session("acountname"))
	.Parameters.Append .CreateParameter("@par", adDate, adParamInput, 8, comDate)
	.Parameters.Append .CreateParameter("@par", adDate, adParamInput, 8, statusChDate)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_DfileNm)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

DBcon.Close
Set DBcon = Nothing

IF DB_email<>"" AND adMemo<>"" Then
'	toEmail = "SDC<ione@duzon119.co.kr>" '보내는사람
'	ReEmail = DB_email '받는사람
'
'	Set fso = Server.CreateObject("Scripting.FileSystemObject")
'	Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/replyForm.html",1,false,-1)
'	MailBody = f.ReadAll
'
'	IF DB_boardidx="3" Then
'		MailBody=Replace(MailBody,"__%Domain%__",Request.Servervariables("Server_name"))
'
'		MailBody=Replace(MailBody,"__%WRITER%__",ReplaceNoHtml(DB_writer))
'		MailBody=Replace(MailBody,"__%REGDATE%__",ReplaceNoHtml(DB_regdate))
'		MailBody=Replace(MailBody,"__%TITLE%__",ReplaceNoHtml(DB_title))
'		MailBody=Replace(MailBody,"__%CONTENT%__",ReplaceBR(ReplaceNoHtml(DB_content)))
'		MailBody=Replace(MailBody,"__%REPLYCONTENT%__",ReplaceBR(ReplaceNoHtml(adMemo)))
'
'		Title="[SDC] 문의내용에 대한 답변 입니다."
'	End IF
'
'	Call subSendMailSMTP(toEmail, ReEmail, Title, MailBody, 0, Filename)
End IF

strLocation="top.location.reload();"
Response.Write ExecJavaAlert("저장되었습니다.","3")
%>