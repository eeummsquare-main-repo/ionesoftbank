<!--#include virtual="/_lib/common.asp"-->
<!--#include virtual="/_lib/dbcon.asp"-->
<!--#include virtual="/_lib/json/json2.asp"-->
<%
Response.ContentType = "application/json"

Const OMNIESOL_API_KEY = "O2s3CFHmSJFrEteZ0cxXKC1Y3pOBpFpp9ghDBsKjr6zZmB6v"
Const TARGET_BBSCODE = 2

Sub SendJson(sstat, sbody)
	Response.Status = sstat
	Response.Write sbody
	Response.End
End Sub

Function jsGet(oJs, sKey, vDef)
	Dim v
	On Error Resume Next
	v = oJs.get(sKey)
	If Err.Number <> 0 Then v = vDef
	If IsNull(v) Or IsEmpty(v) Then v = vDef
	On Error Goto 0
	jsGet = v
End Function

Dim reqMethod : reqMethod = UCase(Request.ServerVariables("REQUEST_METHOD"))

If reqMethod = "OPTIONS" Then
	Response.AddHeader "Access-Control-Allow-Origin", "*"
	Response.AddHeader "Access-Control-Allow-Methods", "POST, OPTIONS"
	Response.AddHeader "Access-Control-Allow-Headers", "Content-Type, X-API-Key"
	Response.Status = "204 No Content"
	Response.End
End If

If reqMethod <> "POST" Then
	SendJson "405 Method Not Allowed", "{""ok"":false,""error"":""method_not_allowed""}"
End If

Dim reqKey : reqKey = Request.ServerVariables("HTTP_X_API_KEY")
If reqKey <> OMNIESOL_API_KEY Then
	SendJson "401 Unauthorized", "{""ok"":false,""error"":""unauthorized""}"
End If

Dim bytes : bytes = Request.TotalBytes
If bytes <= 0 Or bytes >= 65536 Then
	SendJson "400 Bad Request", "{""ok"":false,""error"":""empty_or_too_large""}"
End If

Dim raw : raw = Request.BinaryRead(bytes)
Dim streamObj : Set streamObj = Server.CreateObject("ADODB.Stream")
streamObj.Type = 1
streamObj.Open
streamObj.Write raw
streamObj.Position = 0
streamObj.Type = 2
streamObj.Charset = "utf-8"
Dim bodyStr : bodyStr = streamObj.ReadText
streamObj.Close
Set streamObj = Nothing

Dim data
On Error Resume Next
Set data = JSON.parse(bodyStr)
If Err.Number <> 0 Then
	Err.Clear
	On Error Goto 0
	SendJson "400 Bad Request", "{""ok"":false,""error"":""invalid_json""}"
End If
On Error Goto 0

Dim iName, iCompany, iPhone, iEmail, iType, iContent, iAgree
Dim iPosition, iBiz, iFax, iMeetMethod, iMeetDate, iMeetTime

iName       = jsGet(data, "name", "")
iCompany    = jsGet(data, "company", "")
iPhone      = jsGet(data, "phone", "")
iEmail      = jsGet(data, "email", "")
iType       = jsGet(data, "inquiryType", "")
iContent    = jsGet(data, "content", "")
iAgree      = jsGet(data, "agree", False)
iPosition   = jsGet(data, "position", "")
iBiz        = jsGet(data, "bizNumber", "")
iFax        = jsGet(data, "fax", "")
iMeetMethod = jsGet(data, "meetMethod", "")
iMeetDate   = jsGet(data, "meetDate", "")
iMeetTime   = jsGet(data, "meetTime", "")

Dim missing : missing = ""
If Trim(CStr(iName))     = "" Then missing = missing & "name,"
If Trim(CStr(iCompany))  = "" Then missing = missing & "company,"
If Trim(CStr(iPhone))    = "" Then missing = missing & "phone,"
If Trim(CStr(iEmail))    = "" Then missing = missing & "email,"
If Trim(CStr(iType))     = "" Then missing = missing & "inquiryType,"
If Len(Trim(CStr(iContent))) < 10 Then missing = missing & "content,"
If Not (iAgree = True Or CStr(iAgree) = "True" Or CStr(iAgree) = "true") Then missing = missing & "agree,"

If missing <> "" Then
	SendJson "400 Bad Request", "{""ok"":false,""error"":""validation"",""fields"":""" & Left(missing, Len(missing)-1) & """}"
End If

Dim inqTitle
inqTitle = iName & "님의 구매상담 문의내역입니다. (옴니이솔 전용페이지)"
Dim reqIp
reqIp = Request.ServerVariables("REMOTE_ADDR")

Dim sqlIns
sqlIns = "INSERT INTO BBslist(boardidx, writer, company, tel, email, phone, title, content, "
sqlIns = sqlIns & "note1, note2, note3, note4, note5, note6, note7, "
sqlIns = sqlIns & "publicYN, submit, editorYN, wip, regdate) "
sqlIns = sqlIns & "OUTPUT INSERTED.idx AS newIdx "
sqlIns = sqlIns & "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, 0, ?, Getdate())"

Dim objCmd, oRs, oNewIdx
Set objCmd = Server.CreateObject("ADODB.Command")
objCmd.ActiveConnection = DBcon
objCmd.CommandType = 1
objCmd.CommandText = sqlIns

objCmd.Parameters.Append objCmd.CreateParameter("@boardidx", 3, 1, 4, TARGET_BBSCODE)
objCmd.Parameters.Append objCmd.CreateParameter("@writer", 202, 1, 100, Left(CStr(iName), 100))
objCmd.Parameters.Append objCmd.CreateParameter("@company", 202, 1, 100, Left(CStr(iCompany), 100))
objCmd.Parameters.Append objCmd.CreateParameter("@tel", 202, 1, 50, Left(CStr(iPhone), 50))
objCmd.Parameters.Append objCmd.CreateParameter("@email", 202, 1, 100, Left(CStr(iEmail), 100))
objCmd.Parameters.Append objCmd.CreateParameter("@phone", 202, 1, 100, Left(CStr(iPhone), 100))
objCmd.Parameters.Append objCmd.CreateParameter("@title", 202, 1, 200, Left(inqTitle, 200))
objCmd.Parameters.Append objCmd.CreateParameter("@content", 203, 1, 1000000, CStr(iContent))
objCmd.Parameters.Append objCmd.CreateParameter("@note1", 202, 1, 100, Left(CStr(iType), 100))
objCmd.Parameters.Append objCmd.CreateParameter("@note2", 202, 1, 100, Left(CStr(iPosition), 100))
objCmd.Parameters.Append objCmd.CreateParameter("@note3", 202, 1, 100, Left(CStr(iBiz), 100))
objCmd.Parameters.Append objCmd.CreateParameter("@note4", 202, 1, 50, Left(CStr(iFax), 50))
objCmd.Parameters.Append objCmd.CreateParameter("@note5", 202, 1, 50, Left(CStr(iMeetMethod), 50))
objCmd.Parameters.Append objCmd.CreateParameter("@note6", 202, 1, 50, Left(CStr(iMeetDate), 50))
objCmd.Parameters.Append objCmd.CreateParameter("@note7", 202, 1, 50, Left(CStr(iMeetTime), 50))
objCmd.Parameters.Append objCmd.CreateParameter("@wip", 200, 1, 50, Left(CStr(reqIp), 50))

On Error Resume Next
Set oRs = objCmd.Execute
Dim oErrNum
oErrNum = Err.Number
On Error Goto 0

If oErrNum <> 0 Then
	SendJson "500 Internal Server Error", "{""ok"":false,""error"":""db_insert_failed""}"
End If

oNewIdx = 0
If Not (oRs Is Nothing) Then
	If Not oRs.EOF Then oNewIdx = CLng(oRs("newIdx"))
	oRs.Close
End If
Set oRs = Nothing
Set objCmd = Nothing

DBcon.Close
Set DBcon = Nothing

SendJson "200 OK", "{""ok"":true,""idx"":" & oNewIdx & "}"
%>
