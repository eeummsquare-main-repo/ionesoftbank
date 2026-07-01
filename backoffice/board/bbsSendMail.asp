<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode
BBSCode = uf_getRequest(Request("BBSCode"),"int","","1")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

idx = uf_getRequestProc(Request("idx"),"int","","")

Sql = "SELECT boardidx, title, writer, regdate, content, Wip, email, status, comDate, statusChDate, adMemo, adMemo1, cate1 AS cateNm1, DBO.FN_CODENAME(cate1, cate2) AS cateNm2, DBO.FN_CODENAME(cate2, cate3) AS cateNm3, memoFileNm FROM bbslist WHERE idx="&idx
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

	'######### 답변 첨부파일 ##########
	memoFileNm = changeBlank(Rs("memoFileNm"))
	'######### 답변 첨부파일 ##########

	cateNm1 = Rs("cateNm1")
	cateNm2 = Rs("cateNm2")
	cateNm3 = Rs("cateNm3")

	cateNames = getBBSCateNm1(cateNm1)
	IF cateNames <> "" Then
		IF cateNm2<>"" Then
			cateNames = cateNames & " > "& cateNm2

			IF cateNm3<>"" Then
				cateNames = cateNames & " > "& cateNm3
			End IF
		End IF
	End IF

	adMemo = Rs("adMemo")
	adMemo1 = Rs("adMemo1")

	Sql="UPDATE bbslist SET sendMailModDate=getDate(), sendMailWid=?, sendMailWname=? Where idx="&idx
	Set objCmd = Server.CreateObject("ADODB.Command")
	With objCmd
		.ActiveConnection = DBcon
		.CommandType = adCmdText
		.CommandText = Sql

		.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Session("acountcode"))
		.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Session("acountname"))
		.Execute,,adExecuteNoRecords
	End With
	Set objCmd = Nothing
End IF

DBcon.Close
Set DBcon = Nothing

IF DB_email<>"" Then
	STATUSNM = getApplyStatus(DB_status)

	IF DB_status="9" Then
		Title="[완료] 아이원소프트뱅크 문의내용에 대한 답변 입니다."
		REPLYCON = adMemo1
	Else
		Title="[처리중] 아이원소프트뱅크 문의내용에 대한 답변 입니다."
		REPLYCON = adMemo
	End IF


	IF DB_boardidx=8 Then
		customerNm = "log_amara.png"
		recvMail = GB_amaCsEmail
	ElseIF DB_boardidx=18 Then
		customerNm = "log_icube.png"
		recvMail = GB_icubeCsEmail
	Else
		customerNm = "log_bizbox.png"
		recvMail = GB_bizboxCsEmail
	End IF

	toEmail = "아이원소프트뱅크<ione@duzon119.co.kr>" '보내는사람
	ReEmail = DB_email '받는사람

	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/replyForm.html",1,false,-1)
	MailBody = f.ReadAll

	MailBody=Replace(MailBody,"__%Domain%__",Request.Servervariables("Server_name"))
	MailBody=Replace(MailBody,"__%CUSTOMERNM%__", customerNm)
	MailBody=Replace(MailBody,"__%CATENMS%__",ReplaceNoHtml(cateNames))
	MailBody=Replace(MailBody,"__%STATUSNM%__",ReplaceNoHtml(STATUSNM))
	MailBody=Replace(MailBody,"__%WRITER%__",ReplaceNoHtml(DB_writer))
	MailBody=Replace(MailBody,"__%REGDATE%__",ReplaceNoHtml(DB_regdate))
	MailBody=Replace(MailBody,"__%TITLE%__",ReplaceNoHtml(DB_title))
	MailBody=Replace(MailBody,"__%CONTENT%__",ReplaceBR(ReplaceNoHtml(DB_content)))
	MailBody=Replace(MailBody,"__%REPLYCON%__",ReplaceBR(ReplaceNoHtml(REPLYCON)))

	Call subSendMailSMTP(toEmail, ReEmail, Title, MailBody, 0, memoFileNm)
End IF

Response.Write "success"
%>