<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim FileDel_Chk(2),FileName(2)

WIP=Request.ServerVariables("REMOTE_ADDR")

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
UploadForm.DefaultPath=Server.MapPath("/upload/member/")

Idx = uf_getRequestProc(UploadForm("Idx"),"int","","0")
memsort = uf_getRequestProc(UploadForm("memsort"),"int","","0")
userid = uf_getRequestProc(UploadForm("userid"),"char","15","")
passwd = uf_getRequestProc(UploadForm("passwd"),"char","15","")
name = uf_getRequestProc(UploadForm("name"),"char","50","")
company = uf_getRequestProc(UploadForm("company"),"char","50","")
bizcode = uf_getRequestProc(UploadForm("bizcode"),"char","50","")
zip = uf_getRequestProc(UploadForm("zip"),"char","7","")
addr1 = uf_getRequestProc(UploadForm("addr1"),"char","100","")
addr2 = uf_getRequestProc(UploadForm("addr2"),"char","100","")
tel = uf_getRequestProc(Replace(UploadForm("tel"),", ","-"),"char","15","")
phone = uf_getRequestProc(Replace(UploadForm("phone"),", ","-"),"char","15","")
email = uf_getRequestProc(UploadForm("email"),"char","100","")
EmailYN = uf_getRequestProc(UploadForm("EmailYN"),"int","1","0")
smsYN = uf_getRequestProc(UploadForm("smsYN"),"int","1","0")
birthday = uf_getRequestProc(UploadForm("birthday"),"char","15","")
Sex = uf_getRequestProc(UploadForm("Sex"),"char","10","")
isAuth = uf_getRequestProc(UploadForm("isAuth"),"int","","0")
note1 = uf_getRequestProc(UploadForm("note1"),"char","","")
note2 = uf_getRequestProc(UploadForm("note2"),"char","","")
nickname = uf_getRequestProc(UploadForm("nickname"),"char","","")

isAutoLevel = uf_getRequestProc(UploadForm("isAutoLevel"),"int","1","0")
autoLevel = uf_getRequestProc(UploadForm("autoLevel"),"int","7","1")

FileDel_Chk(0)=UploadForm("FileDel_Chk")
FileName(0)=UploadForm("filename")

IF CStr(Idx)="0" Then
	Sort=1
Else
	Sort=2
End IF

Sql="Select id, pwd, name, zipcode, addr1, addr2, tel, phone, email, filename, EmailYN, Memsort, smsYN, birthday, sex, isAuth, note1, note2, company, nickname, bizcode, isAuth From members Where idx="&Idx
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	DB_name=Rs("name")
	DB_email=Rs("email")
	DB_isAuth=Rs("isAuth")
End IF

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

set cmd=CreateCommand(dbcon,"AP_MembersSet",adCmdStoredProc)
With cmd
	.Parameters.Append CreateInputParameter("@Sort",adVarchar,10,Sort)
	.Parameters.Append CreateInputParameter("@Idx",adBigint,8,Idx)
	.Parameters.Append CreateInputParameter("@memsort",adTinyint,1,memsort)
	.Parameters.Append CreateInputParameter("@userid",adVarWChar,20,userid)
	.Parameters.Append CreateInputParameter("@passwd",adVarWChar,15,passwd)
	.Parameters.Append CreateInputParameter("@name",adVarWChar,50,name)
	.Parameters.Append CreateInputParameter("@nickname",adVarWChar,50,nickname)
	.Parameters.Append CreateInputParameter("@company",adVarWChar,50,company)
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
	.Parameters.Append CreateInputParameter("@bizcode",adVarWChar,100,bizcode)
	.Parameters.Append CreateInputParameter("@note1",adVarWChar,100,note1)
	.Parameters.Append CreateInputParameter("@note2",adVarWChar,100,note2)
	.Parameters.Append CreateInputParameter("@isAuth",adTinyint,1,isAuth)
	.Parameters.Append CreateInputParameter("@isAuth",adTinyint,1,isAutoLevel)
	.Parameters.Append CreateInputParameter("@isAuth",adTinyint,1,autoLevel)
	.Parameters.Append CreateOutputParameter("@result",adInteger,4)
	.Execute
End With

Result=Cmd.Parameters("@result").Value
Set Cmd=Nothing

IF Result=0 Then
	strLocation="top.location.href='memberlist.asp';"
	Response.Write ExecJavaAlert("회원가입이 완료되었습니다.","3")
ElseIF Result=1 then
	IF FileName(0)<>"" Then ImgDelete FileName(0),UploadForm.DefaultPath
	Response.Write ExecJavaAlert("중복된 아이디입니다.\n\n확인후 다시 시도해주세요","")
ElseIF Result=5 then
	IF FileName(0)<>"" Then ImgDelete FileName(0),UploadForm.DefaultPath
	Response.Write ExecJavaAlert("중복된 이메일주소입니다.\n\n확인후 다시 시도해주세요","")
ElseIF Result=3 Then
	IF CStr(DB_isAuth)<>CStr(isAuth) And CStr(isAuth)="99" Then
		'######### 메일 발송 ###############################
		mailHtmlFileName = "memberAuth.html"
		recvMail = DB_email

		mailTitle = "[아이원소프트뱅크] 공식 홈페이지 회원가입 완료."
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
	End IF

	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert("회원정보가 정상적으로 수정되었습니다.","3")
ElseIF Result=4 then
	strLocation="top.location.reload();"
	Response.Write ExecJavaAlert("중복된 이메일주소입니다\n이메일정보를 제외한 회원정보가 정상적으로 수정되었습니다.","3")
End IF
%>