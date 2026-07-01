<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","","")
pass = uf_getRequest(Request("pass"),"char","","")

IF idx = "" OR pass = "" Then
	rMsg = "필수정보입력누락."
End IF

IF rMsg="" Then
	Sql="SELECT pass FROM consult Where Idx="&Idx
	Set Rs=DBcon.Execute(Sql)

	IF Rs.Bof Or Rs.Eof Then
		rMsg = "예약정보를 찾을수 없습니다."
	Else
		dbPwd=Rs("pass")

		IF Pass<>dbPwd Then
			rMsg = "비밀번호가 일치하지 않습니다. 다시 입력해주세요."
		Else
			rMsg = "OK"
			Session("conPass") = dbPwd
		End IF
	End IF
End IF

Response.Write rMsg
%>