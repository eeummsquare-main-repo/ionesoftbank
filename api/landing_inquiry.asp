<%@ Language="VBScript" CodePage="65001" %>
<%
' ============================================================
'  랜딩페이지 상담/구매요청 접수 API
'  - 외부 랜딩(Vite+React SPA)에서 POST(form-urlencoded)로 호출
'  - 저장 테이블: landing_inquiry
'  - 응답: HTTP 200 = 성공 / 그 외 = 실패
'  작성: 2026-07
' ============================================================
Response.CodePage = 65001
Response.CharSet = "utf-8"
Response.ContentType = "application/json"
Response.Expires = -1

' ---------- ADO 상수는 global.asa 의 TypeLib 참조로 전역 제공됨 (재선언 금지) ----------

' ---------- 유틸 ----------
Function Cut(s, n)
	If IsNull(s) Then s = ""
	s = Trim(s & "")
	If Len(s) > n Then s = Left(s, n)
	Cut = s
End Function

Sub SendResult(statusCode, statusText, resultCode, msg)
	Response.Status = statusCode & " " & statusText
	Response.Write "{""result"":""" & resultCode & """,""message"":""" & msg & """}"
	Response.End
End Sub

' ============================================================
'  1) CORS
' ============================================================
Dim allowOrigins, origin, i, isAllowed
' ★ 허용 도메인 — 정식 도메인 확정 시 이 배열에 한 줄만 추가하면 됩니다
allowOrigins = Array( _
	 "https://omniesol-119-53tt.vercel.app" _
	,"http://localhost:3000" _
	,"http://localhost:5173" _
)

origin = Request.ServerVariables("HTTP_ORIGIN") & ""
isAllowed = False
For i = 0 To UBound(allowOrigins)
	If LCase(origin) = LCase(allowOrigins(i)) Then isAllowed = True
Next

If isAllowed Then
	Response.AddHeader "Access-Control-Allow-Origin", origin
	Response.AddHeader "Vary", "Origin"
End If
Response.AddHeader "Access-Control-Allow-Methods", "POST, OPTIONS"
Response.AddHeader "Access-Control-Allow-Headers", "Content-Type"
Response.AddHeader "Access-Control-Max-Age", "86400"

' Preflight
If UCase(Request.ServerVariables("REQUEST_METHOD")) = "OPTIONS" Then
	Response.Status = "204 No Content"
	Response.End
End If

' POST 외 차단
If UCase(Request.ServerVariables("REQUEST_METHOD")) <> "POST" Then
	Call SendResult(405, "Method Not Allowed", "error", "POST only")
End If

' 등록되지 않은 출처 차단 (Origin 없는 서버간 호출은 허용)
If origin <> "" And isAllowed = False Then
	Call SendResult(403, "Forbidden", "error", "origin not allowed")
End If

' ============================================================
'  2) 입력값 수집
' ============================================================
Dim company, bizno, tel, fax, writer, position, phone, email
Dim products, meetingMethod, meetingDate, meetingTime, content
Dim privacyAgree, honeypot
Dim utmSource, utmMedium, utmCampaign
Dim siteCode, referer, clientIp, userAgent

company       = Cut(Request.Form("company"), 100)
bizno         = Cut(Request.Form("bizno"), 20)
tel           = Cut(Request.Form("tel"), 30)
fax           = Cut(Request.Form("fax"), 30)
writer        = Cut(Request.Form("writer"), 50)
position      = Cut(Request.Form("position"), 50)
phone         = Cut(Request.Form("phone"), 30)
email         = Cut(Request.Form("email"), 120)
products      = Cut(Request.Form("products"), 200)
meetingMethod = Cut(Request.Form("meetingMethod"), 20)
meetingDate   = Cut(Request.Form("meetingDate"), 20)
meetingTime   = Cut(Request.Form("meetingTime"), 20)
content       = Cut(Request.Form("content"), 1000)
honeypot      = Trim(Request.Form("website_alt") & "")
utmSource     = Cut(Request.Form("utm_source"), 100)
utmMedium     = Cut(Request.Form("utm_medium"), 100)
utmCampaign   = Cut(Request.Form("utm_campaign"), 100)

siteCode      = Cut(Request.Form("site_code"), 30)
If siteCode = "" Then siteCode = "omniesol"

If products = "" Then products = "OmniEsol"

' 개인정보 동의 : 폼에서 필수 체크를 강제하므로, 미전송 시 동의(1)로 기록
privacyAgree = 1
If Request.Form("privacyAgree") <> "" Then
	If Request.Form("privacyAgree") = "0" Or LCase(Request.Form("privacyAgree")) = "false" Then privacyAgree = 0
End If

referer   = Cut(Request.ServerVariables("HTTP_REFERER"), 500)
userAgent = Cut(Request.ServerVariables("HTTP_USER_AGENT"), 500)
clientIp  = Cut(Request.ServerVariables("HTTP_X_FORWARDED_FOR"), 45)
If clientIp = "" Then clientIp = Cut(Request.ServerVariables("REMOTE_ADDR"), 45)

' ============================================================
'  3) 스팸(honeypot) — 조용히 성공 응답 후 저장하지 않음
' ============================================================
If honeypot <> "" Then
	Call SendResult(200, "OK", "ok", "received")
End If

' ============================================================
'  4) 필수값 검증
' ============================================================
If company = "" Or writer = "" Or phone = "" Or email = "" Or content = "" Then
	Call SendResult(400, "Bad Request", "error", "required field missing")
End If

If InStr(email, "@") = 0 Then
	Call SendResult(400, "Bad Request", "error", "invalid email")
End If

' 미팅방법을 선택했으면 미팅날짜·미팅시간은 필수
' (기존 구매상담 페이지 purchase/inquiry.asp 와 동일 정책 — 반쪽 예약 방지)
If meetingMethod <> "" Then
	If meetingDate = "" Or meetingTime = "" Then
		Call SendResult(400, "Bad Request", "error", "meeting date and time are required when meeting method is selected")
	End If
End If

' ============================================================
'  5) DB 저장
' ============================================================
Dim DBcon, objCmd, sql
On Error Resume Next
%>
<!--#include virtual = "/_lib/dbcon.asp"-->
<%
If Err.Number <> 0 Then
	Err.Clear
	On Error Goto 0
	Call SendResult(500, "Internal Server Error", "error", "db connect failed")
End If

sql = "INSERT INTO landing_inquiry " & _
      "(site_code, company_name, biz_no, tel, fax, manager_name, [position], mobile, email, " & _
      " products, meeting_type, meeting_date, meeting_time, content, privacy_agree, " & _
      " referer, utm_source, utm_medium, utm_campaign, ip, user_agent) " & _
      "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = sql
	.Parameters.Append .CreateParameter("@site_code",   adVarChar,     adParamInput, 30,   siteCode)
	.Parameters.Append .CreateParameter("@company",     adVarWChar,    adParamInput, 100,  company)
	.Parameters.Append .CreateParameter("@bizno",       adVarChar,     adParamInput, 20,   bizno)
	.Parameters.Append .CreateParameter("@tel",         adVarChar,     adParamInput, 30,   tel)
	.Parameters.Append .CreateParameter("@fax",         adVarChar,     adParamInput, 30,   fax)
	.Parameters.Append .CreateParameter("@writer",      adVarWChar,    adParamInput, 50,   writer)
	.Parameters.Append .CreateParameter("@position",    adVarWChar,    adParamInput, 50,   position)
	.Parameters.Append .CreateParameter("@phone",       adVarChar,     adParamInput, 30,   phone)
	.Parameters.Append .CreateParameter("@email",       adVarChar,     adParamInput, 120,  email)
	.Parameters.Append .CreateParameter("@products",    adVarWChar,    adParamInput, 200,  products)
	.Parameters.Append .CreateParameter("@meetingType", adVarWChar,    adParamInput, 20,   meetingMethod)
	.Parameters.Append .CreateParameter("@meetingDate", adVarChar,     adParamInput, 20,   meetingDate)
	.Parameters.Append .CreateParameter("@meetingTime", adVarChar,     adParamInput, 20,   meetingTime)
	.Parameters.Append .CreateParameter("@content",     adVarWChar,    adParamInput, 1000, content)
	.Parameters.Append .CreateParameter("@privacy",     adBoolean,     adParamInput, 1,    CBool(privacyAgree))
	.Parameters.Append .CreateParameter("@referer",     adVarChar,     adParamInput, 500,  referer)
	.Parameters.Append .CreateParameter("@utmSource",   adVarChar,     adParamInput, 100,  utmSource)
	.Parameters.Append .CreateParameter("@utmMedium",   adVarChar,     adParamInput, 100,  utmMedium)
	.Parameters.Append .CreateParameter("@utmCampaign", adVarChar,     adParamInput, 100,  utmCampaign)
	.Parameters.Append .CreateParameter("@ip",          adVarChar,     adParamInput, 45,   clientIp)
	.Parameters.Append .CreateParameter("@ua",          adVarChar,     adParamInput, 500,  userAgent)
	.Execute , , adExecuteNoRecords
End With

If Err.Number <> 0 Then
	Err.Clear
	On Error Goto 0
	Set objCmd = Nothing
	Call SendResult(500, "Internal Server Error", "error", "db insert failed")
End If
On Error Goto 0

Set objCmd = Nothing
DBcon.Close
Set DBcon = Nothing

Call SendResult(200, "OK", "ok", "received")
%>
