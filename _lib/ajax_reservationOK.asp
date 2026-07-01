<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = _lib/smsLibrary.asp-->
<!--#include virtual = _lib/smsSetting.asp-->
<!--#include virtual = _lib/json/JSON_2.0.4.asp-->
<!--#include virtual = _lib/json/json2.asp-->
<%
subjectidx = uf_getRequestProc(Request("subjectidx"),"int","","")
staffidx = uf_getRequestProc(Request("staffidx"),"int","","")
revDate = uf_getRequestProc(Request("revDate"),"date","10","")
revTime = uf_getRequestProc(Request("revTime"),"char","10","")
name = uf_getRequestProc(Request("name"),"char","50","")
icode = uf_getRequestProc(Request("icode"),"char","10","")
sex = uf_getRequestProc(Request("sex"),"char","10","")
phone = uf_getRequestProc(Request("phone"),"char","15","")
pass = uf_getRequestProc(Request("pass"),"char","10","")
note1 = uf_getRequestProc(Request("note1"),"char","100","")
note2 = uf_getRequestProc(Request("note2"),"char","100","")
note3 = uf_getRequestProc(Request("note3"),"char","100","")
note4 = uf_getRequestProc(Request("note4"),"char","100","")
regsort = uf_getRequestProc(Request("regsort"),"char","50","")

IF subjectidx="" OR staffidx="" OR revDate="" OR revTime="" OR name="" OR icode="" OR sex="" OR phone="" OR pass="" Then
	ErrorMsg = "필수입력값오류."
End IF

IF ErrorMsg="" Then
	Sql = "SELECT * FROM consult WHERE revDate='"&revDate&"' AND revTime='"&revTime&"' AND staffidx="&staffidx
	Set Rs = DBcon.Execute(Sql)
	IF Rs.Bof Or Rs.Eof Then
		Sql = "INSERT INTO consult(subjectidx, staffidx, revDate, revTime, name, icode, sex, phone, pass, note1, note2, note3, note4, regsort) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, subjectidx)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, staffidx)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 10, revDate)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 10, revTime)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, name)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, icode)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, sex)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, phone)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, pass)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 100, note1)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 100, note2)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 100, note3)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 100, note4)
			.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, regsort)
			.Execute,,adExecuteNoRecords
		End With
		Set objCmd = Nothing
	Else
		ErrorMsg = "해당 일시에 이미 예약이 되어 있습니다. 다른 시간을 선택해주세요."
	End IF
End IF

IF ErrorMsg="" Then
	Response.Write "OK"

	'### 신청자에게 SMS 발송 ###
	smsCon = "[미래탑의원] "&name&"님 온라인 예약이 접수되었습니다."&Vbcrlf&"확인 후 예약 완료 문자 드리겠습니다."
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

		Call smsLogInsert (smsType, phone, GB_smsBalSinNum, smsCon, smsResultCode, smsResultMsg)
	End IF
	'### 신청자에게 SMS 발송 ###
Else
	Response.Write ErrorMsg
End IF

Sub smsLogInsert( smsType, phone, GB_smsBalSinNum, smsCon, smsResultCode, smsResultMsg )
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
End Sub
%>