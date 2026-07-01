<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<!--#include virtual = _lib/smsLibrary.asp-->
<!--#include virtual = _lib/smsSetting.asp-->
<!--#include virtual = _lib/json/JSON_2.0.4.asp-->
<!--#include virtual = _lib/json/json2.asp-->
<%
mode = uf_getRequest(Request("mode"),"char","","")
smsCon = uf_getRequest(Request("smsCon"),"char","","")

IF GB_isSmsUse<>1 OR GB_smsid="" Or GB_smscode="" Or GB_smsBalSinNum="" Then
	ErrorMsg = "SMS 사용설정을 하지 않았습니다. 기본관리에서 SMS 사용 설정후 이용가능합니다."
ElseIF smsCon="" Then
	ErrorMsg = "SMS 내용을 입력해주세요."
End IF

succCnt = 0 : failCnt = 0

IF ErrorMsg="" Then
	IF mode="search" Then
		'==========검색 관련=========================================
		page = uf_getRequest(Request("page"),"int","","1")
		pageSize = uf_getRequest(Request("PageSize"),"int","","20")
		IF PageSize = "" Then PageSize=20

		seroutmember = uf_getRequest(Request("seroutmember"),"int","1","")
		serMemsort = uf_getRequest(Request("serMemsort"),"int","9","")
		serAuth = uf_getRequest(Request("serAuth"),"int","","")
		serOrderbyStr = uf_getRequest(Request("serOrderbyStr"),"char","","")
		serOrderbyDec = uf_getRequest(Request("serOrderbyDec"),"char","","")
		searchitem = uf_getRequest(Request("searchitem"),"char","","")
		searchstr = uf_getRequest(Request("searchstr"),"char","","")
		sermStatus = uf_getRequest(Request("sermStatus"),"int","","")
		seradidx = uf_getRequest(Request("seradidx"),"int","","")

		oSearchStr = Request("searchstr")

		IF Page="" Then	Page=1
		IF serOrderbyStr="" Then serOrderbyStr="idx"
		IF serOrderbyDec="" Then serOrderbyDec="DESC"
		IF searchstr<>"" Then strWhere = strWhere & " AND "&SearchItem&" LIKE N'%"&searchstr&"%' "
		IF seroutmember<>"" Then strWhere = strWhere & " AND outmember = "&seroutmember&" "
		IF sermStatus<>"" Then strWhere = strWhere & " AND mStatus = "&sermStatus&" "
		IF seradidx<>"" Then strWhere = strWhere & " AND adidx = "&seradidx&" "
		IF serAuth<>"" Then strWhere = strWhere & " AND isAuth = "&serAuth&" "

		IF serMemsort<>"" Then
			IF serMemsort="8" Then
				strWhere = strWhere & " AND memsort = 9 AND sDate<>'' AND (sDate>'"&Date()&"' OR eDate<'"&Date()&"')"
			ElseIF serMemsort="9" Then
				strWhere = strWhere & " AND memsort = 9 AND ((sDate<='"&Date()&"' AND eDate>='"&Date()&"') OR sDate='')"
			Else
				strWhere = strWhere & " AND memsort = "&serMemsort&" "
			End IF
		End IF

		PageLink="memberlist.asp"
		PageStr="pagesize="&PageSize&"&sermStatus="&sermStatus&"&seradidx="&seradidx&"&seroutmember="&seroutmember&"&serMemsort="&serMemsort&"&serAuth="&serAuth&"&serOrderbyStr="&serOrderbyStr&"&serOrderbyDec="&serOrderbyDec&"&searchitem="&searchitem&"&searchstr="&Server.UrlEncode(oSearchStr)
		'==========검색 관련=========================================

		Sql="SELECT phone FROM Members where 1=1 "&strWhere&" Order By "&serOrderbyStr&" "&serOrderbyDec
		Set Rs = DBcon.Execute(Sql)
		IF Rs.Bof OR Rs.Eof Then
			ErrorMsg = "검색된 회원이 없습니다."
		Else
			Do Until Rs.Eof
				phone = uf_getRequest(Rs("phone"),"char","","")

				IF Len(phone)>10 Then
'					IF returnToByte(smsCon)>90 Then
'						smsType = "LMS"
'						smsResultCode = Cafe24LmsSend(GB_smsid, GB_smscode, phone, GB_smsBalSinNum, "", smsCon)
'					Else
'						smsType = "SMS"
'						smsResultCode = Cafe24SmsSend(GB_smsid, GB_smscode, phone, GB_smsBalSinNum, smsCon)
'					End IF

'					smsResultCode = alrigoSmsSend(GB_smsid, GB_smscode, phone, GB_smsBalSinNum, smsCon)
'					arrRCode = Split(smsResultCode,"|")
'					smsResultCode = arrRCode(0)
'					smsResultMsg = arrRCode(1)
'					smsType = arrRCode(2)

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
				Rs.MoveNext()
			Loop
		End IF

	Else
		For i=1 To Request("phone").Count
			phone = uf_getRequest(Request("phone")(i),"char","","")

			IF Len(phone)>10 Then
'				IF returnToByte(smsCon)>90 Then
'					smsType = "LMS"
'					smsResultCode = Cafe24LmsSend(GB_smsid, GB_smscode, phone, GB_smsBalSinNum, "", smsCon)
'				Else
'					smsType = "SMS"
'					smsResultCode = Cafe24SmsSend(GB_smsid, GB_smscode, phone, GB_smsBalSinNum, smsCon)
'				End IF

'				smsResultCode = alrigoSmsSend(GB_smsid, GB_smscode, phone, GB_smsBalSinNum, smsCon)
'				arrRCode = Split(smsResultCode,"|")
'				smsResultCode = arrRCode(0)
'				smsResultMsg = arrRCode(1)
'				smsType = arrRCode(2)

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
		Next
	End IF
End IF

IF ErrorMsg="" Then
	Response.Write "COMPLETE|메세지가 발송되었습니다.[성공 : "&succCnt&"건, 실패 : "&failCnt&"건]"
Else
	Response.Write "ERROR|"&ErrorMsg
End IF
%>