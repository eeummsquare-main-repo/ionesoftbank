<%@ Language="VBScript" CodePage="65001" %>
<!--METADATA TYPE="TypeLib" NAME="Microsoft ActiveX Data Objects 2.7 Library" UUID="{EF53050B-882E-4776-B643-EDA472E8E3F2}" VERSION="2.7"-->
<% 'Option Explicit %>
<%
REM	인코딩 설정 : Page  - Encoding  [0 : ANSI], [949 : EUC-KR], [65001 : 유니코드(UTF-8)], [65535 : 유니코드(UTF-16)]
Response.CharSet = "utf-8"
Response.Expires = "-1"
Response.CodePage = "65001"
Session.CodePage = "65001"
Response.AddHeader "Expires","-1"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Cache-Control","no-cache,must-revalidate"
'Response.AddHeader "Set-Cookie", ""&CStr(Request.ServerVariables("HTTP_COOKIE"))&";path=/;SameSite=None;"
'Response.AddHeader "Set-Cookie", ""&CStr(Request.ServerVariables("HTTP_COOKIE"))&";path=/;SameSite=None; Secure"
IF instr(Request.ServerVariables("HTTP_COOKIE"), "ASPSESSIONID") > 0 Then
    Dim Allcookies

    AllCookies = Split(Request.ServerVariables("HTTP_COOKIE"),";")
    For i = 1 to UBound(AllCookies)
        IF instr(AllCookies(i), "ASPSESSIONID") > 0 Then
			'Response.Write AllCookies(i)&"<br>"
			Response.AddHeader "Set-Cookie", AllCookies(i) & "; path=/;SameSite=None; Secure"
        End IF
    Next
End IF

Dim pgCode
Dim Fso, F, strconnect, DBCon, Rs, Sql
Dim current_domain			:	current_domain = Request.ServerVariables("current_domain")		' 현재 도메인 명
Dim server_port				:	server_port = Request.ServerVariables("SERVER_PORT")
Dim thisHost					:	thisHost = Request.ServerVariables("http_host")					' www.xxxxx.co.kr 의 형태
Dim thisUrl						:	thisUrl = Request.ServerVariables("url")						' /aaa/bbb/ccccc.asp 의 형태
Dim local_ip						:	local_ip = Request.ServerVariables("local_ip")					' 현재 서버 아이피
Dim current_url					:	current_url = Request.ServerVariables("url")					' 현재페이지주소저장
Dim current_querystring		:	current_querystring = Request.ServerVariables("query_string")	' 현재페이지에 전달된 쿼리스트링저장
Dim http_referer				:	http_referer = Request.ServerVariables("http_referer")			' 이전경로저장
Dim http_user_agent			:	http_user_agent = Request.ServerVariables("http_user_agent")	' 사이트 접속정보관련
Dim accLang					:	accLang = Request.ServerVariables("http_accept_language")		' 언어
Dim mainYn						:	mainYn = False													' 메인여부
Dim WIP							:	Wip = Request.ServerVariables("REMOTE_ADDR")
Dim csrf_token					:	csrf_token = session("CSRP_Token")								' csrf 방지 토큰정보
Dim thisFullUrl					:	thisFullUrl = "http://"&thisHost&thisUrl&"?"&current_querystring
Dim nowTimeStamp			:	nowTimeStamp = getTimestamp(now())
Dim isSnsLogin				:	isSnsLogin = False
Dim usePassChange			:	usePassChange = False		'비밀번호 변경주기 사용여부
Dim passChangePeriod		:	passChangePeriod = 3		'비밀번호 변경주기(Month)
Dim MOBILEYN				:	MOBILEYN = False

Dim myDBcon
Dim naverApiKey				:	naverApiKey = ""								'네이버 ClientID
Dim kakaoApiKey				:	kakaoApiKey = ""								'카카오 API Key
Dim iniPaySignKey			:	iniPaySignKey = ""		'이니시스 사인키
Dim iniPayStoreID				:	iniPayStoreID = ""		'이니시스 상점아이디
'Dim iniPaySignKey			:	iniPaySignKey = "Mm56TWpMSEhyTEpFZFdtREg2ZElCdz09"		'이니시스 사인키
'Dim iniPayStoreID				:	iniPayStoreID = "khcaorkr00"		'이니시스 상점아이디

'게시판 환경변수
Dim HK_notYN,HK_pdsYN,HK_MemYN,HK_repYn,HK_comYn,HK_pubYn,HK_imgYN,HK_LangSort,HK_ImgViewYN,HK_ViewMode,HK_VodUrlYN,HK_comMode,HK_DownMode, HK_BBS_isCon
Dim HK_BBS_TopMenuCode, HK_BBS_SubMenuCode, HK_BBS_TopMenuName, HK_BBS_SubMenuName

'언어 VALUE : 0-국문, 1-영문
Dim langmode : langmode = 0
Dim langCode : langCode = "kor"
Dim GB_RootFld : GB_RootFld="/"

'##### 언어 VALUE : 0-국문, 1-영문 ########
IF InStr(LCase(thisUrl)&"/", "/_lib/")>0 OR InStr(LCase(thisUrl)&"/", "/_proc/")>0 OR InStr(LCase(thisUrl)&"/", "/board/")>0 Then
	IF Session("langCode") = "eng" Then
		langmode = 1 : langCode = "eng" : Session("langCode") = "eng" : GB_RootFld="/en/"
	Else
		langmode = 0 : langCode = "kor" : Session("langCode") = "kor" : GB_RootFld="/"
	End IF
Else
	IF InStr(LCase(thisUrl)&"/", "/en/")>0 Then
		langmode = 1 : langCode = "eng" : Session("langCode") = "eng" : GB_RootFld="/en/"
	Else
		langmode = 0 : langCode = "kor" : Session("langCode") = "kor" : GB_RootFld="/"
	End IF
End IF
'##### 언어 VALUE : 0-국문, 1-영문 ########

Dim mainDomain				:	mainDomain = ""		'메인도메인 설정시 해당 도메인 아닐경우 REDIRECT
IF mainDomain="" Then mainDomain = thisHost

Dim THIS_DOMAIN			:	THIS_DOMAIN = thisHost

Dim GB_ActionDomain, GB_ReturnDomain
Dim GB_IS_SSLUse				:	GB_IS_SSLUse = True			'SSL 사용여부
Dim GB_IS_FullSSL				:	GB_IS_FullSSL = True			'전체 SSL 사용여부
Dim GB_Basic_Protocol			:	GB_Basic_Protocol = "https"	'기본 통신 프로토콜
Dim GB_Pri_Protocol				:	GB_Pri_Protocol = "https"		'현재 통신 프로토콜
Dim GB_SSL_Port				:	GB_SSL_Port = "443"			'SSL 포트

Dim mobileChk						:	mobileChk = isMobile()			'모바일 DEVICE 여부

IF Request.ServerVariables("HTTPS")="on" Then GB_Pri_Protocol = "https"
IF server_port<>"" AND server_port<>"80" AND server_port<>"443" Then THIS_DOMAIN = THIS_DOMAIN & ":" & server_port

IF GB_IS_SSLUse Then
	IF GB_IS_FullSSL Then GB_Basic_Protocol = "https"
	IF GB_SSL_Port<>"443" AND GB_Basic_Protocol="https" Then mainDomain = mainDomain & ":" & GB_SSL_Port
End IF

GB_ReturnDomain = "http://"&mainDomain
GB_ActionDomain = "http://"&mainDomain

IF GB_IS_SSLUse Then
	IF GB_IS_FullSSL Then GB_ReturnDomain = "https://"&mainDomain
	GB_ActionDomain = "https://"&mainDomain
End IF

IF LCase(THIS_DOMAIN) <> LCase(mainDomain) Then isRedirect = True
IF Request.ServerVariables("HTTPS")="off" AND GB_Basic_Protocol="https" Then isRedirect = True

IF current_querystring<>"" Then
	redirectUrl = GB_Basic_Protocol&"://"&mainDomain&current_url&"?"&current_querystring
Else
	redirectUrl = GB_Basic_Protocol&"://"&mainDomain&current_url
End IF

'##### 디버깅 ##############
IF WIP = "119.69.11.7" Then
End IF
'##### 디버깅 ##############

IF isRedirect Then Response.Redirect redirectUrl
%>
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = _lib/functions.asp-->
<!--#include virtual = _lib/BBsFunctions.asp-->
<!--#include virtual = _lib/memberINFO.asp-->
<!--#include virtual = _lib/bbs_LangGuide.asp-->
<!--#include virtual = _lib/GBSetting.asp-->
<%

'IF Session("useridx")<>"" THen
'	Sql = "SELECT TOP 1 * FROM LoginTable WHERE useridx="&Session("useridx")&" AND ssid='"&Session.SessionID&"' AND status=1"
'	Set sRs = DBcon.Execute(Sql)
'	IF sRs.Bof Or sRs.Eof Then
'		Session("UserIdx") = ""
'		Session("UserID") = ""
'		Session("UserName") = ""
'		Session("MemberShip") = ""
'
'		strLocation=""
'		Response.Write ExecJavaAlert("중복로그인이 감지되었습니다.\n로그아웃 처리됩니다.", 3)
'	End IF
'End IF

'=======공통코드 GET==============
Sql="SELECT Title, bansort, note1 From ComcodeAdmin Order By bansort, listnum ASC, idx ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then GB_ComcodeRec = Rs.GetRows()

Sql="SELECT groupCode, Code, Name FROM COMCODE WHERE isUse=1 AND isAd<>99 ORDER By groupCode, listnum ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then GB_CodeRec = Rs.GetRows()
'=======공통코드 GET==============

'=======기본설정 SMS/EMAIL 정보 GET==========
Dim GB_isSmsUse, GB_smsid, GB_smscode, GB_smsBalSinNum
Dim GB_pool_CS_Email, GB_cus_CS_Email, GB_fra_CS_email, GB_pool_CS_Phone, GB_cus_CS_Phone, GB_fra_CS_Phone, GB_dFee1, GB_dFee2
Dim GB_allowTestIP

Sql = "SELECT isSmsUse, smsid, smscode, smsBalSinNum, dDepositAccount, dDepositBank, dDepositNm, allowTestIP, dFee1, dFee2, dFee3, dFee4, dFee5, guideMsg1, guideMsg2, buyCsEmail, busCsEmail, amaCsEmail, icubeCsEmail, bizboxCsEmail, etcCsEmail, joinCsEmail, binqTopimgNm FROM shopinfo"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	GB_isSmsUse = Rs("isSmsUse")
	GB_smsid = Rs("smsid")
	GB_smscode = Rs("smscode")
	GB_smsBalSinNum = addHyphen(Replace(Rs("smsBalSinNum"),"-",""))

	GB_dDepositAccount = Rs("dDepositAccount")
	GB_dDepositBank = Rs("dDepositBank")
	GB_dDepositNm = Rs("dDepositNm")
	GB_allowTestIP = Rs("allowTestIP")
	GB_dFee1 = Rs("dFee1")
	GB_dFee2 = Rs("dFee2")
	GB_dFee3 = Rs("dFee3")
	GB_dFee4 = Rs("dFee4")
	GB_dFee5 = Rs("dFee5")

	GB_guideMsg1 = Rs("guideMsg1")
	GB_guideMsg2 = Rs("guideMsg2")

	GB_buyCsEmail = changeBlank(Rs("buyCsEmail"))
	GB_busCsEmail = changeBlank(Rs("busCsEmail"))
	GB_amaCsEmail = changeBlank(Rs("amaCsEmail"))
	GB_icubeCsEmail = changeBlank(Rs("icubeCsEmail"))
	GB_bizboxCsEmail = changeBlank(Rs("bizboxCsEmail"))
	GB_etcCsEmail = changeBlank(Rs("etcCsEmail"))
	GB_joinCsEmail = changeBlank(Rs("joinCsEmail"))

	GB_binqTopimgNm = changeBlank(Rs("binqTopimgNm"))
End IF
'=======기본설정 SMS/EMAIL 정보 GET==========

'=======페이지별 SEO SET==============
'Dim GB_seoTitle, GB_seoDescription, GB_seoKeywords, GB_seoFile, GB_seoSubject, GB_seoAuthor, GB_seoCopyright, GB_seoNaverKey, GB_shareUrl, GB_shareIMG, GB_SeoPgCode
'Dim GB_BASIC_seoTitle, GB_BASIC_seoDescription, GB_BASIC_seoKeywords, GB_BASIC_seoFile, GB_BASIC_seoSubject, GB_BASIC_seoAuthor, GB_BASIC_seoCopyright, GB_BASIC_seoNaverKey
'
'GB_shareUrl = GB_Basic_Protocol&"://"&mainDomain
'GB_shareIMG = ""
'
'Sql = "SELECT seoTitle, seoDescription, seoKeywords, seoFile, seoSubject, seoAuthor, seoCopyright, seoNaverKey FROM seoData Where idx=0"
'Set Rs=Server.CreateObject("ADODB.RecordSet")
'Rs.Open Sql,DBcon,1
'IF Not(Rs.Bof Or Rs.Eof) Then
'	GB_BASIC_seoTitle = changeBlank(Rs("seoTitle"))
'	GB_BASIC_seoDescription = changeBlank(Rs("seoDescription"))
'	GB_BASIC_seoKeywords = changeBlank(Rs("seoKeywords"))
'	GB_BASIC_seoFile = changeBlank(Rs("seoFile"))
'
'	GB_BASIC_seoSubject = changeBlank(Rs("seoSubject"))
'	GB_BASIC_seoAuthor = changeBlank(Rs("seoAuthor"))
'	GB_BASIC_seoCopyright = changeBlank(Rs("seoCopyright"))
'	GB_BASIC_seoNaverKey = changeBlank(Rs("seoNaverKey"))
'End IF
'
'IF InStr(redirectUrl, thisHost&"/index.asp")>0 Then
'	GB_SeoPgCode = 1
'ElseIF InStr(redirectUrl, thisHost&"/sponser/")>0 Then
'	GB_SeoPgCode = 2
'ElseIF InStr(redirectUrl, thisHost&"/business/")>0 Then
'	GB_SeoPgCode = 3
'ElseIF InStr(redirectUrl, thisHost&"/news/")>0 Then
'	GB_SeoPgCode = 4
'ElseIF InStr(redirectUrl, thisHost&"/company/")>0 Then
'	GB_SeoPgCode = 5
'End IF
'
'IF GB_SeoPgCode<>"" Then
'	Sql = "SELECT seoTitle, seoDescription, seoKeywords, seoFile, seoSubject, seoAuthor, seoCopyright, seoNaverKey FROM seoData Where idx="&GB_SeoPgCode
'	Set Rs = DBcon.Execute(Sql)
'	IF Not(Rs.Bof Or Rs.Eof) Then
'		GB_seoTitle = changeBlank(Rs("seoTitle"))
'		GB_seoDescription = changeBlank(Rs("seoDescription"))
'		GB_seoKeywords = changeBlank(Rs("seoKeywords"))
'		GB_seoFile = changeBlank(Rs("seoFile"))
'
'		GB_seoSubject = changeBlank(Rs("seoSubject"))
'		GB_seoAuthor = changeBlank(Rs("seoAuthor"))
'		GB_seoCopyright = changeBlank(Rs("seoCopyright"))
'		GB_seoNaverKey = changeBlank(Rs("seoNaverKey"))
'	End IF
'End IF
'
'IF GB_seoTitle="" Then GB_seoTitle = GB_BASIC_seoTitle
'IF GB_seoDescription="" Then GB_seoDescription = GB_BASIC_seoDescription
'IF GB_seoKeywords="" Then GB_seoKeywords = GB_BASIC_seoKeywords
'IF GB_seoFile="" Then GB_seoFile = GB_BASIC_seoFile
'IF GB_seoSubject="" Then GB_seoSubject = GB_BASIC_seoSubject
'IF GB_seoAuthor="" Then GB_seoAuthor = GB_BASIC_seoAuthor
'IF GB_seoCopyright="" Then GB_seoCopyright = GB_BASIC_seoCopyright
'IF GB_seoNaverKey="" Then GB_seoNaverKey = GB_BASIC_seoNaverKey
'IF GB_seoFile<>"" Then GB_shareIMG = GB_shareUrl&"/upload/seo/"&GB_seoFile
'=======페이지별 SEO SET==============

Set Rs = Nothing
Set GBShopRec = Nothing
DBcon.CLose
Set DBcon = Nothing

IF csrf_token="" Then csrf_token = CSRP_TokenCreate(20)
Dim NowDate	:	NowDate = uf_ConvertDateFormat(Now(), 96) '현재날짜 YYYYMMDDHHMM
%>