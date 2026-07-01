<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = _lib/enc/base64.asp-->
<%
Dim Cmd
Dim adId, adpwd, rememberadINFOYN
Dim resultId, resultMemsort, resultIdx, resultName
Dim strLocation

IF Request("logout")=1 Then
	Call AD_Logout("정상적으로 로그아웃이 되었습니다.", "/backoffice/login.asp")
Else
	IF CSRP_TokenConfirm(request("reqToken")) = False Then
		strLocation = "/backoffice/login.asp"
		Response.Write ExecJavaAlert("잘못된 접근입니다.",2)
		Response.End
	End IF

	AdId=Request("encid")
	adpwd=Request("encpwd")
	rememberadINFOYN=Request("rememberadINFOYN")

	AdId=strAnsi2Unicode(Base64decode(strUnicode2Ansi(AdId)))
	adpwd=strAnsi2Unicode(Base64decode(strUnicode2Ansi(adpwd)))

	IF rememberadINFOYN="" OR IsNull(rememberadINFOYN) Then
		Response.Cookies("rememberADID").Expires=Dateadd("d",-7,Date)
		Response.Cookies("rememberADPWD").Expires=Dateadd("d",-7,Date)
	Else
		Response.Cookies("rememberADID").expires=Dateadd("d",+7,Date)
		Response.Cookies("rememberADPWD").expires=Dateadd("d",+7,Date)
		Response.Cookies("rememberADID")=AdId
		Response.Cookies("rememberADPWD")=adpwd
	End IF

	Set Cmd=CreateCommand(dbcon,"SAP_Login",adCmdStoredProc)
	With Cmd
		.Parameters.Append CreateInputParameter("@UId",AdVarWChar,15,AdId)
		.Parameters.Append CreateInputParameter("@UPwd",AdVarWChar,15,adpwd)
		.Parameters.Append CreateInputParameter("@Wip",AdVarWChar,50,Wip)
		.Parameters.Append CreateOutPutParameter("@ResultID",AdVarWChar,15)
		.Parameters.Append CreateOutPutParameter("@ResultMemsort",adInteger,4)
		.Parameters.Append CreateOutPutParameter("@ResultIDx",adBigint,8)
		.Parameters.Append CreateOutPutParameter("@ResultName",AdVarWChar,10)
		.execute
	End With
	ResultID=Cmd.Parameters(3).value
	ResultMemsort=Cmd.Parameters(4).value
	ResultIDx=Cmd.Parameters(5).value
	ResultName=Cmd.Parameters(6).value
	
	Set Cmd=Nothing
	DBcon.Close
	Set DBcon=Nothing

	IF ResultID = "0" Then
		strLocation="/backoffice/login.asp"
		Response.Write ExecJavaAlert("로그인정보 불일치 \n확인후 다시 시도해주십시오.",2)
		Response.End
	Else
		Session("acountcode") = ResultID
		Session("accuntmemsort") = ResultMemsort
		Session("acountidx") = ResultIDx
		Session("acountname") = ResultName
		Session("user_ip") = WIP

		strLocation="index.asp"
		Response.Redirect strLocation
		Response.End
	End IF
End IF
%>