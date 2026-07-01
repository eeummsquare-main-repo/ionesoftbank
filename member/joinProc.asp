<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = _lib/SmsLibrary.asp-->
<!--#include virtual = _lib/smsSetting.asp-->
<!--#include virtual = _lib/json/JSON_2.0.4.asp-->
<!--#include virtual = _lib/json/json2.asp-->
<!--#include virtual = _lib/enc/base64.asp-->
<%
Dim FileDel_Chk(2),FileName(2)

Sort=Request("sort")
IF Sort="" Then Sort=1

IF Sort="2" Then
	HK_returnURL="../mypage/info.asp"
	%><!-- #include virtual = _lib/sessionchk.asp --><%
End IF

UserIdx = Session("useridx")
IF UserIdx="" Then UserIdx=0

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
UploadForm.DefaultPath=Server.MapPath("/upload/member/")

memsort = uf_getRequestProc(UploadForm("memsort"),"int","1","0")
userid = uf_getRequestProc(UploadForm("userid"),"char","50","")
passwd = uf_getRequestProc(UploadForm("passwd"),"char","50","")
name = uf_getRequestProc(UploadForm("name"),"char","50","")
zip = uf_getRequestProc(UploadForm("zip"),"char","7","")
addr1 = uf_getRequestProc(UploadForm("addr1"),"char","100","")
addr2 = uf_getRequestProc(UploadForm("addr2"),"char","100","")
tel = uf_getRequestProc(Replace(UploadForm("tel"),", ","-"),"char","15","")
phone = uf_getRequestProc(Replace(UploadForm("phone"),", ","-"),"char","15","")
email = uf_getRequestProc(Replace(UploadForm("email"),", ","@"),"char","100","")
EmailYN = uf_getRequestProc(UploadForm("EmailYN"),"int","1","0")
smsYN = uf_getRequestProc(UploadForm("smsYN"),"int","1","0")
birthday = uf_getRequestProc(UploadForm("birthday"),"char","15","")
Sex = uf_getRequestProc(UploadForm("Sex"),"char","10","")
note1 = uf_getRequestProc(UploadForm("note1"),"char","","")
note2 = uf_getRequestProc(UploadForm("note2"),"char","","")
company = uf_getRequestProc(UploadForm("company"),"char","","")
Bizcode = uf_getRequestProc(UploadForm("Bizcode"),"char","","")
nickname = uf_getRequestProc(UploadForm("nickname"),"char","","")

FileDel_Chk(0)=UploadForm("FileDel_Chk")
FileName(0)=UploadForm("filename")

For i=1 To UploadForm("files").count
	IF FileDel_Chk(i-1)<>"" And FileName(i-1)<>"" Then ImgDelete FileName(i-1),UploadForm.DefaultPath

	IF FileDel_Chk(i-1)<>"" Or Sort=1 Then 
		IF UploadForm("files")(i)<>"" Then 
			FileName(i-1)=ImgSaves(UploadForm("files")(i),UploadForm.defaultpath,30720000)
			IF FileName(i-1)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(30M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			End IF
		Else
			FileName(i-1)=""
		End IF
	End IF
Next

IF Sort="2" Then
	isAuth = 99
Else
	isAuth = 0
	'isAuth = 99
End IF

'===========SNS KEY Setting=================
IF Session("sEncINFO")<>"" Then
	tmpVal = Split(Session("sEncINFO"),"|")

	snsSort = strAnsi2Unicode(Base64decode(strUnicode2Ansi(tmpVal(0))))
	snsID = strAnsi2Unicode(Base64decode(strUnicode2Ansi(tmpVal(1))))

	IF snsSort="naver" Then
		naverAuthKey = snsID
	ElseIF snsSort="kakao" Then
		kakaoAuthKey = snsID
	ElseIF snsSort="facebook" Then
		fbAuthKey = snsID
	End IF
End IF
'===========SNS KEY Setting=================

DBcon.BeginTrans

SET cmd=CreateCommand(dbcon,"UP_MembersSet",adCmdStoredProc)
With cmd
	.Parameters.Append CreateInputParameter("@Sort",adVarchar,10,Sort)
	.Parameters.Append CreateInputParameter("@Idx",adBigint,8,SpaceToZero(UserIdx))
	.Parameters.Append CreateInputParameter("@userid",adVarWChar,20,userid)
	.Parameters.Append CreateInputParameter("@passwd",adVarWChar,20,passwd)
	.Parameters.Append CreateInputParameter("@memsort",adTinyint,1,memsort)
	.Parameters.Append CreateInputParameter("@name",adVarWChar,50,name)
	.Parameters.Append CreateInputParameter("@nickname",adVarWChar,50,nickname)
	.Parameters.Append CreateInputParameter("@Company",adVarWChar,50,Company)
	.Parameters.Append CreateInputParameter("@Bizcode",adVarWChar,50,Bizcode)
	.Parameters.Append CreateInputParameter("@zip",adVarChar,7,zip)
	.Parameters.Append CreateInputParameter("@addr1",adVarWChar,100,addr1)
	.Parameters.Append CreateInputParameter("@addr2",adVarWChar,100,addr2)
	.Parameters.Append CreateInputParameter("@tel",adVarWChar,15,tel)
	.Parameters.Append CreateInputParameter("@phone",adVarWChar,15,phone)
	.Parameters.Append CreateInputParameter("@email",adVarWChar,100,email)
	.Parameters.Append CreateInputParameter("@EmailYN",adTinyint,1,EmailYN)
	.Parameters.Append CreateInputParameter("@smsYN",adTinyint,1,smsYN)
	.Parameters.Append CreateInputParameter("@FileName",adVarWChar,50,FileName(0))
	.Parameters.Append CreateInputParameter("@birthday",adVarWChar,100,birthday)
	.Parameters.Append CreateInputParameter("@Sex",adVarWChar,10,Sex)
	.Parameters.Append CreateInputParameter("@note1",adVarWChar,100,note1)
	.Parameters.Append CreateInputParameter("@note2",adVarWChar,100,note2)
	.Parameters.Append CreateInputParameter("@isAuth",adTinyint,1,isAuth)
	.Parameters.Append CreateInputParameter("@naverAuthKey",adVarChar,255,naverAuthKey)
	.Parameters.Append CreateInputParameter("@kakaoAuthKey",adVarChar,255,kakaoAuthKey)
	.Parameters.Append CreateInputParameter("@fbAuthKey",adVarChar,255,fbAuthKey)
	.Parameters.Append CreateInputParameter("@DI",adVarChar,255, Session("cp_Di"))
	.Parameters.Append CreateOutputParameter("@result",adInteger,4)
	.execute
End With
Result=Cmd.Parameters("@result").Value

Set Cmd=Nothing

IF Result=0 Then
	On Error Resume Next

	autoSType = 1				'자동발송 타입 셋팅
	RecNumber = phone		'고객휴대폰번호

	'### 치환코드 내용 셋팅 ######
	Sms_ReplaceStr(0) = name				'회원이름/주문자명
	Sms_ReplaceStr(1) = userid				'회원아이디
	'### 치환코드 내용 셋팅 ######

	%><!--#include virtual = _lib/autoSmsSend.asp--><%

	'######### 메일 발송 ###############################
	mailHtmlFileName = "memberAdd.html"
	recvMail = GB_joinCsEmail

	mailTitle = "[아이원소프트뱅크] 새로운 회원가입 신청서가 접수되었습니다."
	IF recvMail<>"" AND mailTitle<>"" AND mailHtmlFileName<>"" Then
		toEmail = "아이원소프트뱅크<mail@prixcokr.iceserver.co.kr>" '보내는사람
		ReEmail = recvMail '받는사람

		Set fso = Server.CreateObject("Scripting.FileSystemObject")
		Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/"&mailHtmlFileName,1,false,-1)
		MailBody = f.ReadAll

		MailBody=Replace(MailBody, "__%Domain%__", Request.Servervariables("Server_name"))
		MailBody=Replace(MailBody, "__%BIZCODE%__", ReplaceNoHtml(BIZCODE))
		MailBody=Replace(MailBody, "__%COMPANY%__", ReplaceNoHtml(Company))
		MailBody=Replace(MailBody, "__%ID%__", ReplaceNoHtml(userid))
		MailBody=Replace(MailBody, "__%NAME%__", ReplaceNoHtml(name))
		Title = mailTitle

		Call subSendMailSMTP(toEmail, ReEmail, Title, MailBody, 0, EmailAttachFileName)
	End IF
	'######### 메일 발송 ###############################

	strLocation="top.location.href='../member/end.asp';"
	Response.Write ExecJavaAlert("","3")
ElseIF Result=1 then
	IF FileName(0)<>"" Then ImgDelete FileName(0),UploadForm.DefaultPath
	strLocation="top.layerModalClose();"
	Response.Write ExecJavaAlert("중복된 아이디입니다.\n확인후 다시 시도해주세요","3")
ElseIF Result=5 then
	IF FileName(0)<>"" Then ImgDelete FileName(0),UploadForm.DefaultPath
	strLocation="top.layerModalClose();"
	Response.Write ExecJavaAlert("중복된 이메일주소입니다.\n확인후 다시 시도해주세요","3")
ElseIF Result=3 then
	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert("회원정보가 정상적으로 수정되었습니다.","3")
ElseIF Result=4 then
	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert("중복된 이메일주소입니다\n이메일정보를 제외한 회원정보가 정상적으로 수정되었습니다.","3")
End IF

DBcon.Committrans

DBcon.Close
Set DBcon=Nothing
%>