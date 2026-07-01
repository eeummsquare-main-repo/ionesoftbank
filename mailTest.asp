<!--#include virtual = _lib/common.asp-->
<%
'받는 메일 서버 : pop3s.hiworks.com
'보내는 메일 서버(SMTP) : smtps.hiworks.com
'ID : ione@duzon119.co.kr / PW : ionesoftbank21!!
'받는 메일 서버(POP3) : 995
''암호화된 연결(SSL) 필요' 선택
'보내는 메일 서버(SMTP) : 465, 연결 방식 'SSL' 선택

'---------------------------------------------------------------------------------------------------
'** SMTP 메일 보내기
'---------------------------------------------------------------------------------------------------
Sub subSendMailSMTPTest(toMail, reMail, Subject, Body, iFormat , File)
	Dim iMsg
	Dim iConf

	Set iMsg = CreateObject("CDO.Message")
	'SendUsing 속성을 지정하기 위한 개체 생성
	Set iConf = iMsg.Configuration

	iConf.Load 1
	With iConf.Fields
		.item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2   '1일 경우 로컬(SMTP), 2일 경우 외부(SMTP)로 메일전송
		.item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtps.hiworks.com"
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 ' 메일 서버의 포트 번호
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = true
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "ione@duzon119.co.kr"
		.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "iwzEhaWyGMoGE9QPzXn9"
		.item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
		.Update
	End With

	iMsg.To = reMail  '받는 사람 이메일 주소
	iMsg.From = toMail  '보내는 사람 이메일 주소
	iMsg.Subject  = Subject '제목
	iMsg.HTMLBody = Body    '본문

	IF File <> "" Then
		iMsg.AddAttachment Server.MapPath("/upload/board/") &"/"& File
	End If

	iMsg.BodyPart.Charset = "utf-8"
	iMsg.HTMLBodyPart.Charset = "utf-8"
	iMsg.Send

	Set iConf = Nothing
	Set iMsg = Nothing
End Sub
'---------------------------------------------------------------------------------------------------

toEmail = "아이원소프트뱅크<ione@duzon119.co.kr>" '보내는사람
ReEmail = "tucklee@nate.com" '받는사람
Title = "안녕하세요 아이원 소프트 뱅크입니다."
MailBody = "안녕하세요 아이원 소프트 뱅크입니다.안녕하세요 아이원 소프트 뱅크입니다. 안녕하세요 아이원 소프트 뱅크입니다.<> 내용입니다."
EmailAttachFileName = ""

Call subSendMailSMTPTest(toEmail, ReEmail, Title, MailBody, 0, EmailAttachFileName)
%>