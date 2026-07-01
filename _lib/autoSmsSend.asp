<%
IF GB_isSmsUse=1 AND GB_smsid<>"" AND GB_smscode<>"" AND GB_smsBalSinNum<>"" Then
	Sql = "SELECT isUse, smsCon, susinPhones, sTarget from smsAuto WHERE sType="&autoSType&" AND isUse=1"
	Set Rs = DBcon.Execute(Sql)
	Do Until Rs.Eof
		smsCon = Trim(get_ReplaceSmsCon(Rs("smsCon")))
		susinPhones = Rs("susinPhones")
		sTarget = Rs("sTarget")

		'###고객발송 #####
		IF sTarget=0 AND Len(Replace(RecNumber,"-",""))>10 AND Len(smsCon)>0 Then
'			IF returnToByte(smsCon)>90 Then
'				smsType = "LMS"
'				smsResultCode = Cafe24LmsSend(GB_smsid, GB_smscode, RecNumber, GB_smsBalSinNum, "", smsCon)
'			Else
'				smsType = "SMS"
'				smsResultCode = Cafe24SmsSend(GB_smsid, GB_smscode, RecNumber, GB_smsBalSinNum, smsCon)
'			End IF

			smsResultCode = alrigoSmsSend(GB_smsid, GB_smscode, RecNumber, GB_smsBalSinNum, smsCon)
			arrRCode = Split(smsResultCode,"|")
			smsType = arrRCode(2)

			'### 로그 INSERT #####
			Sql = "INSERT INTO smsResult(smstype, susinNum, recNum, smsCon, retCode, retMsg) Values(?, ?, ?, ?, ?, ?)"
			Set objCmd = Server.CreateObject("ADODB.Command")
			With objCmd
				.ActiveConnection = DBcon
				.CommandType = adCmdText
				.CommandText = Sql

				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, smsType)
				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, RecNumber)
				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, GB_smsBalSinNum)
				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2000, smsCon)
				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, arrRCode(0))
				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, arrRCode(1))
				.Execute,,adExecuteNoRecords
			End With
			Set objCmd = Nothing
			'### 로그 INSERT #####
		End IF
		'###고객발송 #####

		'###관리자발송 #####
		IF sTarget=1 AND susinPhones<>"" AND Len(smsCon)>0 Then

			arr_susinPhones = Split(susinPhones, ",")
			For i=0 To Ubound(arr_susinPhones)
				IF arr_susinPhones(i)<>"" Then
'					IF returnToByte(smsCon)>90 Then
'						smsType = "LMS"
'						smsResultCode = Cafe24LmsSend(GB_smsid, GB_smscode, arr_susinPhones(i), GB_smsBalSinNum, "", smsCon)
'					Else
'						smsType = "SMS"
'						smsResultCode = Cafe24SmsSend(GB_smsid, GB_smscode, arr_susinPhones(i), GB_smsBalSinNum, smsCon)
'					End IF
					smsResultCode = alrigoSmsSend(GB_smsid, GB_smscode, arr_susinPhones(i), GB_smsBalSinNum, smsCon)
					arrRCode = Split(smsResultCode,"|")
					smsType = arrRCode(2)

					'### 로그 INSERT #####
					Sql = "INSERT INTO smsResult(smstype, susinNum, recNum, smsCon, retCode, retMsg) Values(?, ?, ?, ?, ?, ?)"
					Set objCmd = Server.CreateObject("ADODB.Command")
					With objCmd
						.ActiveConnection = DBcon
						.CommandType = adCmdText
						.CommandText = Sql

						.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, smsType)
						.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, arr_susinPhones(i))
						.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, GB_smsBalSinNum)
						.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2000, smsCon)
						.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, arrRCode(0))
						.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, arrRCode(1))
						.Execute,,adExecuteNoRecords
					End With
					Set objCmd = Nothing
					'### 로그 INSERT #####
				End IF
			Next
		End IF
		'###관리자발송 #####

		Rs.MoveNext()
	Loop
End IF
%>