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

Dim Fso, F, strconnect, DBCon, Rs, Sql
Dim current_domain			:	current_domain = Request.ServerVariables("current_domain")		' 현재 도메인 명
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
Dim topMenuCode, subMenuCode

Dim kakaoApiKey		: kakaoApiKey = "49b67feb3e05af521e08fbdae82f12e6"						'카카오 API Key

'게시판 환경변수
Dim HK_notYN,HK_pdsYN,HK_MemYN,HK_repYn,HK_comYn,HK_pubYn,HK_imgYN,HK_LangSort,HK_ImgViewYN,HK_ViewMode,HK_VodUrlYN,HK_comMode,HK_DownMode
Dim HK_BBS_TopMenuCode, HK_BBS_SubMenuCode, HK_BBS_TopMenuName, HK_BBS_SubMenuName,HK_BBS_isCon,HK_BBS_MainYN

%>
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = _lib/functions.asp-->
<!--#include virtual = _lib/BBsFunctions.asp-->
<!--#include virtual = _lib/GBSetting.asp-->
<%
IF csrf_token="" Then csrf_token = CSRP_TokenCreate(20)

IF Request("BBscode")="1000" Then
	TitleName = "명칭"
Else
	TitleName = "제목"
End IF

strCabinDiv = "객실 소개|부대 시설"
arrCabinDiv = Split(strCabinDiv, "|")

'=======공통코드 GET==============
Sql="SELECT Title, bansort, note1 From ComcodeAdmin Order By bansort, listnum ASC, idx ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then GB_ComcodeRec = Rs.GetRows()

Sql="SELECT groupCode, Code, Name FROM COMCODE WHERE isUse=1 AND isAd<>99 ORDER By groupCode, listnum ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then GB_CodeRec = Rs.GetRows()
'=======공통코드 GET==============

DBcon.CLose
Set DBcon = Nothing
%>