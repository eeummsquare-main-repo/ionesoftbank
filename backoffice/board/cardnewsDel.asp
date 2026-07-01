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

' idx는 숫자 또는 콤마구분 숫자열만 허용 (인젝션 방지)
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

IF safeIdx <> "" Then
    Sql = "DELETE FROM cardnews_request WHERE idx IN ("&safeIdx&")"
    DBcon.Execute Sql
End IF

DBcon.Close
Set DBcon=Nothing

strLocation = PageLink&"?page="&Page&"&"&PageStr
Response.Write ExecJavaAlert("선택하신 신청내역이 삭제되었습니다.",2)
%>
