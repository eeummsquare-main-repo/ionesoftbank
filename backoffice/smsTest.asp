<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "rev" : subMenuCode = "consult" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<!--#include virtual = _lib/smsLibrary.asp-->
<!--#include virtual = _lib/smsSetting.asp-->
<!--#include virtual = _lib/json/JSON_2.0.4.asp-->
<!--#include virtual = _lib/json/json2.asp-->
<%
mode = uf_getRequest(Request("mode"),"char","","")
smsCon = uf_getRequest(Request("smsCon"),"char","","")

Response.Write GB_isSmsUse&"<br>"
Response.Write GB_smsid&"<br>"
Response.Write GB_smscode&"<br>"
Response.Write GB_smsBalSinNum&"<br>"

smsCon = "테스트"

IF GB_isSmsUse<>1 OR GB_smsid="" Or GB_smscode="" Or GB_smsBalSinNum="" Then
	ErrorMsg = "SMS 사용설정을 하지 않았습니다. 기본관리에서 SMS 사용 설정후 이용가능합니다."
ElseIF smsCon="" Then
	ErrorMsg = "SMS 내용을 입력해주세요."
End IF

succCnt = 0 : failCnt = 0


phone = "010-8919-2913"

IF Len(phone)>10 Then
	IF returnToByte(smsCon)>90 Then
		smsType = "LMS"
	Else
		smsType = "SMS"
	End IF
	smsResultCode = mKoreaSmsSend(smsType, GB_smsid, GB_smscode, phone, GB_smsBalSinNum, smsCon)
	arrRCode = Split(smsResultCode,"|")
	smsResultCode = arrRCode(0)
	smsResultMsg = arrRCode(1)

	IF UCase(smsResultCode)="0000" Then
		succCnt = succCnt + 1
	Else
		failCnt = failCnt + 1
	End IF

	'### 로그 INSERT #####
	Sql = "INSERT INTO smsResult(smstype, susinNum, recNum, smsCon, retCode, retMsg) Values(?, ?, ?, ?, ?, ?)"
	Set objCmd = Server.CreateObject("ADODB.Command")
	With objCmd
		.ActiveConnection = DBcon
		.CommandType = adCmdText
		.CommandText = Sql

		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, smsType)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, phone)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, GB_smsBalSinNum)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2000, smsCon)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, smsResultCode)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, smsResultMsg)
		.Execute,,adExecuteNoRecords
	End With
	Set objCmd = Nothing
	'### 로그 INSERT #####
End IF


IF ErrorMsg="" Then
	Response.Write "COMPLETE|메세지가 발송되었습니다.[성공 : "&succCnt&"건, 실패 : "&failCnt&"건]"
Else
	Response.Write "ERROR|"&ErrorMsg
End IF
%>