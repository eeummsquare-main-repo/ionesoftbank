<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub06" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","2","0")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

strWhere = ""
IF serStatus <> "" Then strWhere = strWhere & " AND status="&serStatus
IF serDate1 <> "" Then strWhere = strWhere & " AND regdate>'"&serDate1&"'"
IF serDate2 <> "" Then strWhere = strWhere & " AND regdate<'"&DateAdd("d",1,serDate2)&"'"
IF SearchStr <> "" Then
    IF seritem = "0" Then
        strWhere = strWhere & " AND company Like N'%"&SearchStr&"%'"
    ElseIF seritem = "1" Then
        strWhere = strWhere & " AND writer Like N'%"&SearchStr&"%'"
    ElseIF seritem = "2" Then
        strWhere = strWhere & " AND email Like N'%"&SearchStr&"%'"
    Else
        strWhere = strWhere & " AND phone Like N'%"&SearchStr&"%'"
    End IF
End IF

Set Rs=server.CreateObject("ADODB.RecordSet")
Sql = "SELECT idx, company, writer, phone, email, interest, note1, regdate, status, agree1, agree2 FROM cardnews_request WHERE 1=1 "&strWhere&" ORDER BY idx DESC"
Rs.Open Sql, DBcon, 1

IF Rs.Bof Or Rs.Eof Then
    Response.Write ExecJavaAlert("검색된 내역이 없습니다.",0)
    Response.End
Else
    Allrec = Rs.GetRows()
End IF
Rs.Close

Function statusLabel(s)
    Select Case CStr(s)
        Case "0"  : statusLabel = "대기중"
        Case "1"  : statusLabel = "접수완료"
        Case "9"  : statusLabel = "보관"
        Case "99" : statusLabel = "취소"
        Case Else : statusLabel = "-"
    End Select
End Function

Response.Write "<style>br { mso-data-placement:same-cell; }</style>" & Vbcrlf
Response.Write "<table border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' style='border-collapse: collapse'>"
Response.Write "<tr align='center' height='30' bgcolor='#E1E1E1'>"
Response.Write "<td>순번</td><td>회사명</td><td>담당자</td><td>연락처</td><td>이메일</td>"
Response.Write "<td>관심주제</td><td>문의사항</td><td>신청일시</td><td>상태</td><td>개인정보동의</td><td>수신동의</td>"
Response.Write "</tr>"
For i = 0 To UBound(Allrec, 2)
    Response.Write "<tr>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&(i+1)&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(1,i))&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(2,i))&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(3,i))&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(4,i))&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(5,i))&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(6,i))&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&Allrec(7,i)&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&statusLabel(Allrec(8,i))&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&IIf(CStr(Allrec(9,i))="1","Y","N")&"</td>"
    Response.Write "    <td style=""mso-number-format:'\@'"">"&IIf(CStr(Allrec(10,i))="1","Y","N")&"</td>"
    Response.Write "</tr>"
Next
Response.Write "</table>"

Set Rs = Nothing
DBcon.Close
Set DBcon = Nothing

Function IIf(cond, a, b)
    IF cond Then IIf = a Else IIf = b
End Function

Response.ContentType  = "application/x-msexcel"
Response.CacheControl = "public"
Response.AddHeader "Content-Disposition","attachment;filename="&Server.URLPathEncode("카드뉴스신청내역.xls")
%>
