<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Response.ContentType = "text/plain"
Response.Charset = "utf-8"

Dim company, writer, phone, email, interest, note1, agree1, agree2
company  = uf_getRequestProc(Request("company"),  "char", "100", "")
writer   = uf_getRequestProc(Request("writer"),   "char", "50",  "")
phone    = uf_getRequestProc(Replace(Request("phone"), ", ", "-"), "char", "30", "")
email    = uf_getRequestProc(Request("email"),    "char", "100", "")
interest = uf_getRequestProc(Request("interest"), "char", "200", "")
note1    = uf_getRequestProc(Request("note1"),    "char", "500", "")
agree1   = uf_getRequestProc(Request("agree1"),   "char", "1",   "0")
agree2   = uf_getRequestProc(Request("agree2"),   "char", "1",   "0")

Dim errMsg : errMsg = ""
IF company = "" Then errMsg = "회사명을 입력해주세요."
IF errMsg = "" AND writer  = "" Then errMsg = "담당자명을 입력해주세요."
IF errMsg = "" AND phone   = "" Then errMsg = "연락처를 입력해주세요."
IF errMsg = "" AND agree1 <> "1" Then errMsg = "개인정보 수집 및 이용에 동의해주세요."
IF errMsg = "" AND agree2 <> "1" Then errMsg = "정보 수신에 동의해주세요."

IF errMsg <> "" Then
    Response.Write "ERR:" & errMsg
Else
    Sql = "INSERT INTO cardnews_request(company, writer, phone, email, interest, note1, agree1, agree2, Wip, regdate) " & _
          "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())"
    Set objCmd = Server.CreateObject("ADODB.Command")
    With objCmd
        .ActiveConnection = DBcon
        .CommandType = adCmdText
        .CommandText = Sql
        .Parameters.Append .CreateParameter("@p1", adVarWChar, adParamInput, 100, company)
        .Parameters.Append .CreateParameter("@p2", adVarWChar, adParamInput,  50, writer)
        .Parameters.Append .CreateParameter("@p3", adVarWChar, adParamInput,  30, phone)
        .Parameters.Append .CreateParameter("@p4", adVarWChar, adParamInput, 100, email)
        .Parameters.Append .CreateParameter("@p5", adVarWChar, adParamInput, 200, interest)
        .Parameters.Append .CreateParameter("@p6", adVarWChar, adParamInput, 500, note1)
        .Parameters.Append .CreateParameter("@p7", adTinyInt,  adParamInput,   0, CInt(agree1))
        .Parameters.Append .CreateParameter("@p8", adTinyInt,  adParamInput,   0, CInt(agree2))
        .Parameters.Append .CreateParameter("@p9", adVarWChar, adParamInput,  50, Wip)
        .Execute ,, adExecuteNoRecords
    End With
    Set objCmd = Nothing
    Response.Write "OK"
End IF

DBcon.Close
Set DBcon = Nothing
%>
