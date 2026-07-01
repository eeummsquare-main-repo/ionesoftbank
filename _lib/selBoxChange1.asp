<%
Function alrigoSmsSend(smsid, smsSecure, susinPhone, recPhone, smsMsg)
	Dim sms_url			: sms_url = "https://apis.aligo.in/send/" ' SMS 요청 URL
	Dim user_id			: user_id	= smsid						'SMS 아이디
	Dim secure			 : secure	= smsSecure				'인증키
	Dim testmode_yn	: testmode_yn = ""					'테스트모드 Y 인경우 실제문자 전송X , 자동취소(환불) 처리
	Dim msg				: msg	= smsMsg						'전송메시지
	Dim rphone			: rphone	= susinPhone				'수신자핸드폰번호(-포함)
	Dim sphone			: sphone	= recPhone					'발신자번호
	Dim PostData
	PostData = "user_id=" & user_id
	PostData = PostData & "&key=" & secure
	PostData = PostData & "&msg=" & msg
	PostData = PostData & "&receiver=" & rphone
	PostData = PostData & "&sender=" & sphone
	PostData = PostData & "&testmode_yn=" & testmode_yn
	PostData = PostData & "&rdate="
	PostData = PostData & "&rtime="
	PostData = PostData & "&title="
	PostData = PostData & "&destination="

	Dim ServerXmlHttp
	Dim tmpResult
	Set ServerXmlHttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
	ServerXmlHttp.open "POST", sms_url, false
	ServerXmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	ServerXmlHttp.setRequestHeader "Content-Length", Len(PostData)

	ServerXmlHttp.send PostData
	IF ServerXmlHttp.status = 200 Then
		tmpResult = ServerXmlHttp.responseText

		Set jsonData = JSON.parse(tmpResult)
		R_result_code = jsonData.result_code		'결과코드 1 성공
		R_message = jsonData.message				'메세지
		IF R_result_code="1" Then
			R_error_cnt = jsonData.error_cnt				'에러카운트
			R_success_cnt = jsonData.success_cnt	'성공카운트
			R_msg_type = jsonData.msg_type			'발송형태 SMS, LMS
		End IF
	Else
		R_result_code = -1
		R_message = "Connection Fail"
	End IF

	Set ServerXmlHttp = Nothing
	alrigoSmsSend = R_result_code & "|" & R_message & "|" & R_msg_type
End Function

Function Cafe24SmsSend(smsid, smsSecure, susinPhone, recPhone, smsMsg)
	arr_RecPhone = Split(recPhone,"-")

	Dim sms_url		: sms_url = "https://sslsms.cafe24.com/sms_sender.php" ' SMS 요청 URL
	Dim user_id		: user_id	= smsid						'SMS 아이디
	Dim secure	    : secure	= smsSecure				'인증키
	Dim encoderurl	: encoderurl = "Y"						'리턴 URL을 encode 해서 받을지를 결정합니다. (사용:Y, 사용안함:N, Y가 아닐 경우 변수를 여러개 넘겨받을 없습니다.)
	Dim msg	        : msg	= smsMsg						'전송메시지
	Dim rphone	    : rphone	= susinPhone				'수신자핸드폰번호(-포함)
	Dim sphone1	: sphone1	= arr_RecPhone(0)	'발신자번호
	Dim sphone2	: sphone2	= arr_RecPhone(1)	'발신자번호
	Dim sphone3	: sphone3	= arr_RecPhone(2)	'발신자번호
	Dim mode		: mode	= ""							'// base64 사용시 반드시 모드값을 1로 주셔야 합니다.
	Dim smsType	: smsType = ""							'LMS 사용시 L

	Dim PostData
	PostData = "lang="
	PostData = PostData & "&user_id=" & user_id
	PostData = PostData & "&secure=" & secure
	PostData = PostData & "&msg=" & msg
	PostData = PostData & "&rphone=" & rphone
	PostData = PostData & "&sphone1=" & sphone1
	PostData = PostData & "&sphone2=" & sphone2
	PostData = PostData & "&sphone3=" & sphone3
	PostData = PostData & "&mode=" & mode
	PostData = PostData & "&encoderurl=" & encoderurl
	PostData = PostData & "&smsType=" & smsType

	Dim ServerXmlHttp
	Dim tmpResult
	Set ServerXmlHttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
	ServerXmlHttp.open "POST", sms_url
	ServerXmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	ServerXmlHttp.setRequestHeader "Content-Length", Len(PostData)

	ServerXmlHttp.send PostData
	If ServerXmlHttp.status = 200 Then
		tmpResult = ServerXmlHttp.responseText
	Else
		tmpResult = "Connection Fail"
	End If
	Set ServerXmlHttp = Nothing

	Dim smsrMsg    : smsrMsg	=  split(tmpResult , ",")
	Dim smsResult    : smsResult	=  smsrMsg (0)
	Dim smsLimitCnt    : smsLimitCnt	=  smsrMsg (1)
	Dim smsResultMsg      : smsResultMsg  = ""
	
	SELECT CASE smsResult
		CASE "Test Success!"
			smsResultMsg = "테스트성공"
			smsResultMsg = smsResultMsg & " 잔여건수는 "+ smsLimitCnt+"건 입니다."
		CASE "success"
			smsResultMsg = "문자 정상적으로 전송되었습니다."
			smsResultMsg = smsResultMsg & " 잔여건수 : "+ smsLimitCnt+"건 "
		CASE "reserved"
			smsResultMsg = "예약되었습니다."
			smsResultMsg = smsResultMsg & " 잔여건수는 "+ smsLimitCnt+"건 입니다."
		CASE "3205"
			smsResultMsg = "잘못된 번호형식입니다."
		CASE "0044"
			smsResultMsg = "스팸문자는 보낼 수 없습니다."
		CASE Else
			smsResultMsg = "[Error]"+smsResult
	END Select

	Cafe24SmsSend = smsResult & "|" & smsResultMsg & "|SMS"
End Function

Function Cafe24LmsSend(smsid, smsSecure, susinPhone, recPhone, smsTitle, smsMsg)
	arr_RecPhone = Split(recPhone,"-")

	Dim sms_url		: sms_url = "https://sslsms.cafe24.com/sms_sender.php" ' SMS 요청 URL
	Dim user_id		: user_id	= smsid						'SMS 아이디
	Dim secure	    : secure	= smsSecure				'인증키
	Dim encoderurl	: encoderurl = "Y"						'리턴 URL을 encode 해서 받을지를 결정합니다. (사용:Y, 사용안함:N, Y가 아닐 경우 변수를 여러개 넘겨받을 없습니다.)
	Dim subject		: subject = smsTitle					'제목
	Dim msg	        : msg	= smsMsg						'전송메시지
	Dim rphone	    : rphone	= susinPhone				'수신자핸드폰번호(-포함)
	Dim sphone1	: sphone1	= arr_RecPhone(0)	'발신자번호
	Dim sphone2	: sphone2	= arr_RecPhone(1)	'발신자번호
	Dim sphone3	: sphone3	= arr_RecPhone(2)	'발신자번호
	Dim mode		: mode	= ""							'// base64 사용시 반드시 모드값을 1로 주셔야 합니다.
	Dim smsType	: smsType = "L"						'LMS 사용시 L

	Dim PostData
	PostData = "lang="
	PostData = PostData & "&subject=" & subject
	PostData = PostData & "&user_id=" & user_id
	PostData = PostData & "&secure=" & secure
	PostData = PostData & "&msg=" & msg
	PostData = PostData & "&rphone=" & rphone
	PostData = PostData & "&sphone1=" & sphone1
	PostData = PostData & "&sphone2=" & sphone2
	PostData = PostData & "&sphone3=" & sphone3
	PostData = PostData & "&mode=" & mode
	PostData = PostData & "&encoderurl=" & encoderurl
	PostData = PostData & "&smsType=" & smsType

	Dim ServerXmlHttp
	Dim tmpResult
	Set ServerXmlHttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
	ServerXmlHttp.open "POST", sms_url
	ServerXmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	ServerXmlHttp.setRequestHeader "Content-Length", Len(PostData)

	ServerXmlHttp.send PostData
	If ServerXmlHttp.status = 200 Then
		tmpResult = ServerXmlHttp.responseText
	Else
		tmpResult = "Connection Fail"
	End If
	Set ServerXmlHttp = Nothing

	Dim smsrMsg    : smsrMsg	=  split(tmpResult , ",")
	Dim smsResult    : smsResult	=  smsrMsg (0)
	Dim smsLimitCnt    : smsLimitCnt	=  smsrMsg (1)
	Dim smsResultMsg      : smsResultMsg  = ""
	
	SELECT CASE smsResult
		CASE "Test Success!"
			smsResultMsg = "테스트성공"
			smsResultMsg = smsResultMsg & " 잔여건수는 "+ smsLimitCnt+"건 입니다."
		CASE "success"
			smsResultMsg = "문자 정상적으로 전송되었습니다."
			smsResultMsg = smsResultMsg & " 잔여건수 : "+ smsLimitCnt+"건 "
		CASE "reserved"
			smsResultMsg = "예약되었습니다."
			smsResultMsg = smsResultMsg & " 잔여건수는 "+ smsLimitCnt+"건 입니다."
		CASE "3205"
			smsResultMsg = "잘못된 번호형식입니다."
		CASE "0044"
			smsResultMsg = "스팸문자는 보낼 수 없습니다."
		CASE Else
			smsResultMsg = "[Error]"+smsResult
	END Select

	Cafe24LmsSend = smsResult & "|" & smsResultMsg & "|LMS"
End Function

Function mKoreaSmsSend(smsType, smsid, smsSecure, susinPhone, recPhone, smsMsg)
	Dim PostData
	PostData = "remote_id="&Server.URLEncode(smsid) & "&remote_pass=" & Server.URLEncode(smsSecure) & "&remote_phone=" & Server.URLEncode(Replace(susinPhone,"-","")) & "&remote_callback=" & Server.URLEncode(Replace(recPhone,"-",""))
	PostData = PostData & "&remote_msg=" & Server.URLEncode(smsMsg) & "&remote_contents="

	IF smsType = "LMS" Then
		sms_url = "http://www.smsko.co.kr/Remote/RemoteMms.html"
	ElseIF smsType = "SMS" Then
		sms_url = "http://www.smsko.co.kr/Remote/RemoteSms.html"
	End IF

	Dim ServerXmlHttp
	Dim tmpResult
	Set ServerXmlHttp = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
	ServerXmlHttp.open "POST", sms_url
	ServerXmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	ServerXmlHttp.setRequestHeader "Content-Length", Len(PostData)

	ServerXmlHttp.send PostData
	If ServerXmlHttp.status = 200 Then
		tmpResult = (ServerXmlHttp.responseText)
	Else
		tmpResult = "Connection Fail"
	End If
	Set ServerXmlHttp = Nothing

	Dim smsrMsg    : smsrMsg	=  split(tmpResult , "|")
	Dim smsResult    : smsResult	=  smsrMsg (0)
	'Dim smsResultMsg      : smsResultMsg  = smsrMsg (1)
	Dim smsLimitCnt    : smsLimitCnt	=  smsrMsg (2)
	
	SELECT CASE smsResult
		CASE "0000"
			smsResultMsg = "문자발송완료"
			smsResultMsg = smsResultMsg & " 잔여건수는 "+ smsLimitCnt+"건 입니다."
		CASE "0001 "
			smsResultMsg = "접속오류."
		CASE "0002"
			smsResultMsg = "인증에러"
		CASE "0003"
			smsResultMsg = "잔여콜수없음."
		CASE "0004"
			smsResultMsg = "메시지 형식에러"
		CASE "0005"
			smsResultMsg = "콜백번호 에러"
		CASE "0006"
			smsResultMsg = "수신번호 개수에러"
		CASE "0009"
			smsResultMsg = "전송실패"
		CASE "0012"
			smsResultMsg = "메시지 길이오류"
		CASE "0030"
			smsResultMsg = "CALLBACK AUTH FAIL (발신번호 사전등록 미등록)"
		CASE "0033"
			smsResultMsg = "CALLBACK TYPE FAIL (발신번호 형식에러)"
		CASE "0080"
			smsResultMsg = "발송제한"
		CASE "6666"
			smsResultMsg = "일시차단"
		CASE "9999"
			smsResultMsg = "요금미납"
		CASE Else
			smsResultMsg = "오류"
	END Select

	mKoreaSmsSend = smsResult & "|" & smsResultMsg & "|" & smsType
End Function
%>