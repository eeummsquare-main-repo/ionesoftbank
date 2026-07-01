<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub06" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Page = uf_getRequest(Request("Page"),"int","","")
pagesize = uf_getRequest(Request("pagesize"),"int","","")
serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

PageLink="cardnewsList.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)

idx = Request("idx")
status = uf_getRequest(Request("status"),"int","","")

' idx 안전화
Dim safeIdx, parts, p, k
parts = Split(idx, ",")
safeIdx = ""
For k = 0 To UBound(parts)
    p = Trim(parts(k))
    IF p<>"" AND IsNumeric(p) Then
        IF safeIdx="" Then
            safeIdx = CStr(CLng(p))
        Else
            safeIdx = safeIdx & "," & CStr(CLng(p))
        End IF
    End IF
Next

' status 안전화 — 0/1/9/99 만 허용
Dim safeStatus
Select Case CStr(status)
    Case "0", "1", "9", "99" : safeStatus = CStr(status)
    Case Else : safeStatus = ""
End Select

IF safeIdx<>"" AND safeStatus<>"" Then
    Sql = "UPDATE cardnews_request SET status="&safeStatus&", statusChangeDate=GETDATE() WHERE idx IN ("&safeIdx&")"
    DBcon.Execute Sql
End IF

DBcon.Close
Set DBcon=Nothing

strLocation = PageLink&"?page="&Page&"&"&PageStr
Response.Write ExecJavaAlert("선택하신 신청내역의 상태가 수정되었습니다.",2)
%>
