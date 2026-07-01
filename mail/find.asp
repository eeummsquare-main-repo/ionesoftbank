<%
toEmail="아이원소프트뱅크<mail@prixcokr.iceserver.co.kr>" '보내는사람
ReEmail=email '받는사람

Set fso = Server.CreateObject("Scripting.FileSystemObject")
Set f = fso.OpenTextFile(Server.MapPath("/mail/")&"/password.html",1,false,-1)
MailBody = f.ReadAll

MailBody=Replace(MailBody,"__%Domain%__",Request.Servervariables("Server_name"))
MailBody=Replace(MailBody,"__%PWD%__",tmpPwdStr)

Title="[아이원소프트뱅크] 요청하신 임시 비밀번호를 안내해드립니다."

Call subSendMailSMTP(toEmail, ReEmail, Title, MailBody, 0, "")
%>