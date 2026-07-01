<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub05" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<!--#include virtual = _lib/smsLibrary.asp-->
<!--#include virtual = _lib/smsSetting.asp-->
<!--#include virtual = _lib/json/JSON_2.0.4.asp-->
<!--#include virtual = _lib/json/json2.asp-->
<%
'검색 필드 관련===============================
Page = uf_getRequest(Request("Page"),"int","","")
pagesize = uf_getRequest(Request("pagesize"),"int","","")

serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

PageLink="consult.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = Request("idx")
status = Request("status")

Sql = "SELECT status, phone, name FROM Consult Where idx IN ("&idx&")"
Set Rs = DBcon.Execute(Sql)
Do Until Rs.Eof
	DB_Status = Rs("status")
	DB_phone = Rs("phone")
	DB_name = Rs("name")

'	IF DB_phone<>"" Then
'		smsCon = "[미래탑의원]"&DB_name&"님 예약신청 접수가 완료되었습니다."&Vbcrlf& DB_revdate&" "&DB_revTime&" 방문 바랍니다."
'
'		'### SMS 발송 ###
'		IF Len(DB_phone)>10 Then
'			IF returnToByte(smsCon)>90 Then
'				smsType = "LMS"
'			Else
'				smsType = "SMS"
'			End IF
'			smsResultCode = mKoreaSmsSend(smsType, GB_smsid, GB_smscode, DB_phone, GB_smsBalSinNum, smsCon)
'			arrRCode = Split(smsResultCode,"|")
'			smsResultCode = arrRCode(0)
'			smsResultMsg = arrRCode(1)
'
'			IF UCase(smsResultCode)="0000" Then
'				succCnt = succCnt + 1
'			Else
'				failCnt = failCnt + 1
'			End IF
'
'			'### 로그 INSERT #####
'			Sql = "INSERT INTO smsResult(smstype, susinNum, recNum, smsCon, retCode, retMsg) Values(?, ?, ?, ?, ?, ?)"
'			Set objCmd = Server.CreateObject("ADODB.Command")
'			With objCmd
'				.ActiveConnection = DBcon
'				.CommandType = adCmdText
'				.CommandText = Sql
'
'				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, smsType)
'				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, DB_phone)
'				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, GB_smsBalSinNum)
'				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2000, smsCon)
'				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, smsResultCode)
'				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, smsResultMsg)
'				.Execute,,adExecuteNoRecords
'			End With
'			Set objCmd = Nothing
'			'### 로그 INSERT #####
'		End IF
'		'### SMS 발송 ###
'	End IF

	Rs.MoveNext()
Loop

Sql = "UPDATE Consult SET status="&status&", statusChangeDate=getDate() Where idx IN ("&idx&")"
DBcon.Execute Sql

DBcon.Close
Set DBcon=Nothing

strLocation = PageLink&"?page="&Page&"&"&PageStr
Response.Write ExecJavaAlert("선택하신 게시물의 상태가 수정되었습니다.",2)
%>