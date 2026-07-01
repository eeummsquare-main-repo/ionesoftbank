<%
Class smsApi
	private send_ok

	private m_szServer
	private m_szUserID
	private m_szApiKey
	private m_szResultXML
	private m_szResultCode
	private m_szResultMessage
	private m_szResult
	private m_szMethod
	private m_nAfter
	private m_nBefore
	Private m_success_cnt
	Private m_fail_list
	Private m_szResult_all()

	private m_oEnc

	private Sub Class_Initialize
		m_szServer = "http://sms.gabia.com/api"
		send_ok = "0000"

		set m_oEnc = new smsEncrypt

		m_nAfter = 0
		m_nBefore = 0

	end sub

	private Sub Class_Terminate
		set m_oEnc = nothing
	end sub

	public property get RESULT_OK
		RESULT_OK = send_ok
	end property

	public property get RESULT_CODE
		RESULT_CODE = m_szResultCode
	end property

	public property get RESULT_MESG
		RESULT_MESG = m_szResultMessage
	end property

	public property get RESULT
		RESULT = m_szResult
	end property

	public property get AFTER
		AFTER = m_nAfter
	end property

	public property get BEFORE
		BEFORE = m_nBefore
	end Property
	
	public property get SUCCESS_CNT
		SUCCESS_CNT = m_success_cnt
	end property

	public property get FAIL_LIST
		FAIL_LIST = m_fail_list
	end property
	
	public property get RESULT_ARR
		RESULT_ARR = m_szResult_all
	end Property

	private Function GetNonce(Lenth)
		Dim RanNum,i
		Randomize
		GetNonce = Null

		For i=1 to Lenth
			Do
				RanNum = Round(Rnd * 1000, 0)

				if(RanNum>=48 and RanNum<=122 and (RanNum<=90 or RanNum>=97) and (RanNum<=57 or RanNum>=65)) then
					Exit Do
				end if
			Loop

			GetNonce = GetNonce & Chr(RanNum)
		Next

		GetNonce = GetNonce
	End Function

	public property let setUserID(ByVal pUserID)
		m_szUserID = pUserID
	end property

	public property let setApiKey(ByVal pKey)
		m_szApiKey = pKey
	end property

	private function sendRequest(pMethod, pParam)

		m_szMethod = pMethod

		if m_szUserID = "" then
			sendMessage = false
		end if

		Dim params(1)
		Dim requestXml
		Dim nonce
		Dim md5AccessToken

		nonce = GetNonce(8)
		md5AccessToken = nonce & m_oEnc.MD5(nonce & m_szApiKey)

		requestXml = "<request><sms-id>" & m_szUserID & "</sms-id>" & chr(13) _
			& "<access-token>" & md5AccessToken & "</access-token>" & chr(13)  _
			& "<response-format>xml</response-format>" & chr(13)  _
			& "<method>" & pMethod & "</method>" & chr(13)  _
			& "<params>" & chr(13)  _
			& pParam & chr(13)  _
			& "</params></request>"

		params(0) = requestXml

		m_szResultXML = xmlRPC (m_szServer, "gabiasms", params)

		if (isobject(m_szResultXML)) then

			Dim oXml
			Set oXml = new XMLDOMParse

			m_szResultCode = ucase(trim(oXml.TagText("code", 0)))
			m_szResultMessage = oXml.TagText("mesg", 0)

			set oXml = nothing
		else
			Dim oResult
			oResult = parseResult(m_szResultXML)

			m_szResultCode = ucase(trim(oResult(0)))
			m_szResultMessage = trim(oResult(1))
			m_szResult = trim(oResult(2))
		end if

		sendRequest = m_szResultCode

	end function

	private function sendMessage (pType, pCallback, pReceiver, pTitle, pMessage, pRefKey, pDate)

		if m_szUserID = "" OR m_szApiKey = "" then
			sendMessage = false
		end if

		Dim requestParam
		requestParam = "<send_type>" & pType & "</send_type>" & chr(13)  _
			& "<ref_key>" & pRefKey & "</ref_key>" & chr(13)  _
			& "<subject>" & pTitle & "</subject>" & chr(13)  _
			& "<message>" & pMessage & "</message>" & chr(13)  _
			& "<callback>" & pCallback & "</callback>" & chr(13)  _
			& "<phone>" & pReceiver & "</phone>" & chr(13) _
			& "<reserve>" & pDate & "</reserve>"

		sendMessage = sendRequest("SMS.send", requestParam)

	end Function
	
	private function mms_sendMessage(pType, pCallback, pReceiver, pTitle, pMessage, pFilePath, pRefKey, pDate)
		Dim requestParam, binary_file_xml, arr_length

		if m_szUserID = "" OR m_szApiKey = "" then
			mms_sendMessage = false
		end If

		arr_length = UBound(pFilePath)
		For i = 0 To UBound(pFilePath)
			If i = arr_length Then
				binary_file_xml = binary_file_xml & BinaryToXML(pFilePath(i), "file_bin_"&i)
			Else 
				binary_file_xml = binary_file_xml & BinaryToXML(pFilePath(i), "file_bin_"&i) & chr(13) _ 
			End If
		Next

		If i=0 Or i>2 Then
			mms_sendMessage = false
		end If
		
		requestParam = "<send_type>" & pType & "</send_type>" & chr(13)  _
			& "<ref_key>" & pRefKey & "</ref_key>" & chr(13)  _
			& "<subject>" & pTitle & "</subject>" & chr(13)  _
			& "<message>" & pMessage & "</message>" & chr(13)  _
			& "<callback>" & pCallback & "</callback>" & chr(13)  _
			& "<phone>" & pReceiver & "</phone>" & chr(13) _
			& "<reserve>" & pDate & "</reserve>" & chr(13) _ 
			& "<file_cnt>" & i & "</file_cnt>" & chr(13) _ 
			& binary_file_xml

		mms_sendMessage = sendRequest("SMS.send", requestParam)

	end function
	
	private function multi_sendMessage (pType, pCallback, pReceiver, pTitle, pMessage, pRefKey, pDate)

		if m_szUserID = "" OR m_szApiKey = "" then
			multi_sendMessage = false
		end if

		Dim requestParam
		requestParam = "<send_type>" & pType & "</send_type>" & chr(13)  _
			& "<ref_key>" & pRefKey & "</ref_key>" & chr(13)  _
			& "<subject>" & pTitle & "</subject>" & chr(13)  _
			& "<message>" & pMessage & "</message>" & chr(13)  _
			& "<callback>" & pCallback & "</callback>" & chr(13)  _
			& "<phone>" & pReceiver & "</phone>" & chr(13) _
			& "<reserve>" & pDate & "</reserve>" 

		multi_sendMessage = sendRequest("SMS.multi_send", requestParam)

	end Function

	private function multi_mms_sendMessage(pType, pCallback, pReceiver, pTitle, pMessage, pFilePath, pRefKey, pDate)
		Dim requestParam, binary_file_xml, arr_length
		if m_szUserID = "" OR m_szApiKey = "" then
			multi_mms_sendMessage = false
		end if
		
		arr_length = UBound(pFilePath)
		For i = 0 To UBound(pFilePath)
			If i = arr_length Then
				binary_file_xml = binary_file_xml & BinaryToXML(pFilePath(i), "file_bin_"&i)
			Else 
				binary_file_xml = binary_file_xml & BinaryToXML(pFilePath(i), "file_bin_"&i) & chr(13) _ 
			End If
		Next

		If i=0 Or i>2 Then
			multi_mms_sendMessage = false
		end If

		requestParam = "<send_type>" & pType & "</send_type>" & chr(13)  _
			& "<ref_key>" & pRefKey & "</ref_key>" & chr(13)  _
			& "<subject>" & pTitle & "</subject>" & chr(13)  _
			& "<message>" & pMessage & "</message>" & chr(13)  _
			& "<callback>" & pCallback & "</callback>" & chr(13)  _
			& "<phone>" & pReceiver & "</phone>" & chr(13) _
			& "<reserve>" & pDate & "</reserve>" & chr(13) _ 
			& "<file_cnt>" & i & "</file_cnt>" & chr(13) _ 
			& binary_file_xml
		
		multi_mms_sendMessage = sendRequest("SMS.multi_send", requestParam)

	end Function
	
	private function parseResult (pValue)
		Dim oBefore
		Dim oAfter
		Dim oResult(3)
		Dim oDom
		set oDom = server.CreateObject("MSXML2.DOMDOCUMENT.4.0")
		oDom.LoadXML pValue

		Dim oCode, oMesg, oRes
		set oCode = oDom.selectSingleNode("/response/code")
		set oMesg = oDom.selectSingleNode("/response/mesg")
		set oRes = oDom.selectSingleNode("/response/result")

		oResult(0) = oCode.text
		oResult(1) = oMesg.text
		oResult(2) = Base64.decode(CStr(oRes.text))

		if m_szMethod = "SMS.getStatusByRef" AND oResult(0) = send_ok then
			set oDom = nothing
			set oDom = server.CreateObject("MSXML2.DOMDOCUMENT.4.0")
			oDom.LoadXML oResult(2)

			Dim oStatus

			set oStatus = oDom.selectSingleNode("/root/smsResult/entries/entry")

			if (oStatus.text <> "NODATA") then
				set oStatus = nothing
				set oStatus = oDom.selectSingleNode("/root/smsResult/entries/entry/CODE")
				oResult(2) = oStatus.text

				set oStatus = nothing

				set oStatus = oDom.selectSingleNode("/root/smsResult/entries/entry/MESG")
				oResult(2) = oResult(2) & " : " & oStatus.text

				set oStatus = nothing
			end If
		elseif m_szMethod = "SMS.getStatusByRef_all" AND oResult(0) = send_ok Then
			set oDom = nothing
			set oDom = server.CreateObject("MSXML2.DOMDOCUMENT.4.0")
			oDom.LoadXML oResult(2)

			set oStatus = oDom.selectSingleNode("/root/smsResult/entries/entry")

			if (oStatus.text <> "NODATA") Then
				'결과값 다 가져오기위한 부분
				Dim strvalue()
				Set oStatus = nothing
				Set oStatus = oDom.selectNodes("/root/smsResult/entries/entry/PHONENUM")
				set oStatus_msg = oDom.selectNodes("/root/smsResult/entries/entry/MESG")
				
				ReDim m_szResult_all(oStatus.Length-1)
				For i=0 To oStatus.Length-1
					m_szResult_all(i) = oStatus.item(i).Text & " : " & oStatus_msg.item(i).Text
'					Response.Write(m_szResult_all(i)&"<br>")
				Next 
			end If

			set oStatus = Nothing
		elseif m_szMethod = "SMS.getUserInfo" and oResult(0) = send_ok then
			set oDom = nothing
			set oDom = server.CreateObject("MSXML2.DOMDOCUMENT.4.0")
			oDom.LoadXML oResult(2)

			Dim oCount

			set oCount = oDom.selectSingleNode("/root/sms_quantity")

			if (oCount.text <> "NODATA") then
				oResult(0) = CDbl(oCount.text)
				oResult(1) = ""
				oResult(2)= ""
			end if
		elseif m_szMethod = "SMS.send" and oResult(0) = send_ok then
			set oDom = nothing
			set oDom = server.CreateObject("MSXML2.DOMDOCUMENT.4.0")
			oDom.LoadXML oResult(2)

			set oBefore = oDom.selectSingleNode("/root/BEFORE_SMS_QTY")
			set oAfter = oDom.selectSingleNode("/root/AFTER_SMS_QTY")

			if (oBefore is nothing) then
				m_nBefore = 0
			else
				if (oBefore.text <> "NODATA") then
					m_nBefore = CDbl(oBefore.text)
				end if
			end if

			if (oAfter is nothing) then
				m_nAfter = 0
			else
				if (oAfter.text <> "NODATA") then
					m_nAfter = CDbl(oAfter.text)
				end if
			end if

			set oBefore = nothing
			set oAfter = Nothing
		elseIf m_szMethod = "SMS.multi_send" And oResult(0) = send_ok Then
			set oDom = nothing
			set oDom = server.CreateObject("MSXML2.DOMDOCUMENT.4.0")
			oDom.LoadXML oResult(2)
			
			Dim success_cnt
			Dim fail_list			'

			set oBefore = oDom.selectSingleNode("/root/BEFORE_SMS_QTY")
			set oAfter = oDom.selectSingleNode("/root/AFTER_SMS_QTY")
			set success_cnt = oDom.selectSingleNode("/root/SUCCESS_CNT")
			set fail_list = oDom.selectSingleNode("/root/FAIL_LIST")
			
			if (oBefore is nothing) then
				m_nBefore = 0
			else
				if (oBefore.text <> "NODATA") then
					m_nBefore = CDbl(oBefore.text)
				end if
			end if

			if (oAfter is nothing) then
				m_nAfter = 0
			else
				if (oAfter.text <> "NODATA") then
					m_nAfter = CDbl(oAfter.text)
				end if
			end if
			
			if (success_cnt is nothing) then
				m_success_cnt = 0
			else
				if (success_cnt.text <> "NODATA") then
					m_success_cnt = CDbl(success_cnt.text)
				end if
			end If
			
			if (fail_list is nothing) then
				m_fail_list = 0
			else
				if (fail_list.text <> "NODATA") then
					m_fail_list = Cstr(fail_list.text)
				end if
			end If
			
			set oBefore = nothing
			set oAfter = Nothing
			set success_cnt = nothing
			set fail_list = Nothing
		end if

		set oCode = nothing
		set oMesg = nothing
		set oRes = nothing
		set oDom = nothing

		parseResult = oResult
	end function

	public function sms_send (pCallback, pReceiver, pMessage, pRefKey, pDate)
		
		if m_szUserID = "" OR m_szApiKey = "" OR pCallback = "" OR pReceiver = "" OR pMessage = "" Then
			sms_send = false
			exit function
		end if

		sms_send = sendMessage("sms", pCallback, pReceiver, "", pMessage, pRefKey, pDate)
	end Function
	
	public function lms_send (pCallback, pReceiver, pTitle, pMessage, pRefKey, pDate)

		if m_szUserID = "" OR m_szApiKey = "" OR pCallback = "" OR pReceiver = "" OR pMessage = "" then
			lms_send = false
			exit function
		end if

		lms_send = sendMessage("lms", pCallback, pReceiver, pTitle, pMessage, pRefKey, pDate)
	end Function
	
	public function mms_send (pCallback, pReceiver, pTitle, pMessage, pFilePath, pRefKey, pDate)

		if m_szUserID = "" OR m_szApiKey = "" OR pCallback = "" OR pReceiver = "" OR pMessage = "" then
			lms_send = false
			exit function
		end if

		mms_send = mms_sendMessage("mms", pCallback, pReceiver, pTitle, pMessage, pFilePath,pRefKey, pDate)
	end function
	
	Public Function multi_sms_send(pCallback, pReceiver_arr, pMessage, pRefKey, pDate)
		m_phone_arr = make_string_receiver(pReceiver_arr)
		if m_szUserID = "" OR m_szApiKey = "" OR pCallback = "" OR m_phone_arr = "" OR pMessage = "" Then
			multi_sms_send = False
			Exit Function
		End If
'		Response.Write(m_phone_arr)
		multi_sms_send = multi_sendMessage("sms", pCallback, m_phone_arr, "", pMessage, pRefKey, pDate)
	End Function 

	Public Function multi_lms_send(pCallback, pReceiver_arr, pTitle,pMessage, pRefKey, pDate)
		m_phone_arr = make_string_receiver(pReceiver_arr)
		if m_szUserID = "" OR m_szApiKey = "" OR pCallback = "" OR m_phone_arr = "" OR pMessage = "" Then
			multi_sms_send = False
			Exit Function
		End If
'		Response.Write(m_phone_arr)
		multi_lms_send = multi_sendMessage("lms", pCallback, m_phone_arr, pTitle, pMessage, pRefKey, pDate)
	End Function

	Public Function multi_mms_send(pCallback, pReceiver_arr, pTitle,pMessage, pFilepath, pRefKey, pDate)
		m_phone_arr = make_string_receiver(pReceiver_arr)
		if m_szUserID = "" OR m_szApiKey = "" OR pCallback = "" OR m_phone_arr = "" OR pMessage = "" Then
			multi_sms_send = False
			Exit Function
		End If
'		Response.Write(m_phone_arr)
		multi_mms_send = multi_mms_sendMessage("mms", pCallback, m_phone_arr, pTitle, pMessage, pFilepath,pRefKey, pDate)
	End Function 

	private function make_string_receiver(phone_arr)
		dim phone
		If isarray(phone_arr) Then
			for i=0 To UBound(phone_arr)
				If i=0 Then
					phone = phone_arr(i)
				else
					phone = phone&","&phone_arr(i)
				End if
			next
		end If
		make_string_receiver = phone
	end Function
	
	public function getStatus (pRefKey)

		Dim keys, reqeustParam

		if isarray(pRefKey) then
			keys = join(pRefKey, ",")
		else
			keys = pRefKey
		end if

		requestParam = "<ref_key>" & keys & "</ref_key>"

		getStatus = sendRequest("SMS.getStatusByRef", requestParam)
	end function
	
	public function getStatus_all (pRefKey)

		Dim keys, reqeustParam

		if isarray(pRefKey) then
			keys = join(pRefKey, ",")
		else
			keys = pRefKey
		end if

		requestParam = "<ref_key>" & keys & "</ref_key>"

		getStatus_all = sendRequest("SMS.getStatusByRef_all", requestParam)

	end Function
	
	public function getSmsCount()
		Dim r
		getSmsCount = sendRequest("SMS.getUserInfo", "")
	end function

	Public Function reserveCancel(pRefKey,pType,phone_arr)

		Dim phone_str
		If isArray(phone_arr) Then
			phone_str = join(phone_arr, ",")
		Else 
			phone_str = ""
		End If 

		requestParam = "<send_type>" & pType & "</send_type>" & chr(13)  _
			& "<ref_key>" & pRefKey & "</ref_key>" & chr(13)  _
			& "<phonenum>" & phone_str & "</phonenum>" 

		reserveCancel = sendRequest("SMS.reservationCancel", requestParam)
	End Function

	Function BinaryToXML( filePath, file_name )
		Dim xmlDoc
		Dim xmlNode
		Dim xmlElement
		Dim strFileName
		Dim obj_stream

		strFileName = Server.MapPath(filePath)
		
		Set obj_stream   = Server.CreateObject("ADODB.Stream")
			obj_stream.Type = 1
			obj_stream.Open()
			obj_stream.LoadFromFile strFileName
		
		
		Set xmlDoc = Server.CreateObject( "MSXML.DOMDocument" )
		Set xmlElement = xmlDoc.createElement(file_name)
		Set xmlDoc.documentElement = xmlElement
			xmlElement.dataType = "bin.base64"
			xmlElement.nodeTypedValue = obj_stream.Read
			BinaryToXML = xmlDoc.xml
		Set xmlElement = Nothing
		Set xmlDoc = Nothing
		obj_stream.Close()
		Set obj_stream = Nothing
	End Function

end Class

%>