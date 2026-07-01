<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub05" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serRevDate = uf_getRequest(Request("serRevDate"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
serstaffidx = uf_getRequest(Request("serstaffidx"),"int","","")

seritem = uf_getRequest(Request("seritem"),"int","1","0")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

IF serstaffidx <> "" Then strWhere = strWhere & " AND staffidx="&serstaffidx
IF serStatus <> "" Then strWhere = strWhere & " AND status="&serStatus
IF serRevDate <> "" Then strWhere = strWhere & " AND revDate='"&serRevDate&"'"
IF serDate1 <> "" Then strWhere = strWhere & " AND A.regdate>'"&serDate1&"'"
IF serDate2 <> "" Then strWhere = strWhere & " AND A.regdate<'"&DateAdd("d",1,serDate2)&"'"
IF SearchStr <> "" Then
	IF seritem = "1" Then
		strWhere = strWhere & " AND A.phone Like N'%"&SearchStr&"%'"
	Else
		strWhere = strWhere & " AND A.name Like N'%"&SearchStr&"%'"
	End IF
End IF

PageLink="consult.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serRevDate="&serRevDate&"&serStatus="&serStatus&"&serstaffidx="&serstaffidx&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

Set Rs=server.CreateObject("ADODB.RecordSet")
Sql = "select  A.idx, isNull(C.title,'삭제됨'), isNull(B.title,'삭제됨'), revdate, revTime, name, sex, phone, regdate, status, icode, note1, note2, note3, note4, regsort FROM consult A LEFT OUTER JOIN staffAdmin B ON A.staffidx = B.idx LEFT OUTER JOIN subjectAdmin C ON A.subjectidx = C.idx WHERE 1=1 "&strWhere&" order by A.Idx DESC"
Rs.Open Sql,dbcon,1

IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaAlert("검색된 내역이 없습니다.",0)
	Response.End
Else
	Allrec=Rs.GetRows()
End IF
Rs.Close

Response.Write "<style>"&Vbcrlf
Response.Write "br { mso-data-placement:same-cell; }"&Vbcrlf
Response.Write "</style>"&Vbcrlf
Response.Write "<table border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' style='border-collapse: collapse'>"
Response.Write "<tr align='center' height='30' bgcolor='#E1E1E1'>"
Response.Write "<td>순번</td>"
Response.Write "<td>진료과</td>"
Response.Write "<td>의료진</td>"
Response.Write "<td>예약일자</td>"
Response.Write "<td>예약시간</td>"
Response.Write "<td>초진/재진</td>"
Response.Write "<td>예약자</td>"
Response.Write "<td>성별</td>"
Response.Write "<td>연락처</td>"
Response.Write "<td>주민번호 앞자리</td>"
Response.Write "<td>신장</td>"
Response.Write "<td>체중</td>"
Response.Write "<td>질병력</td>"
Response.Write "<td>현재복용약물</td>"
Response.Write "<td>신청일</td>"
Response.Write "<td>상태</td>"

Response.Write "</tr>"
For i=0 To Ubound(Allrec,2)
	Response.Write "<tr>"
	Response.Write "	<td style=""mso-number-format:'\@'"">"&i+1&"</td>"
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(1,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(2,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(3,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(4,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(15,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(5,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(6,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(7,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(10,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(11,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(12,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(13,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(Allrec(14,i))&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&Left(Allrec(8,i),10)&"</td>"&Vbcrlf
	Response.Write "	<td style=""mso-number-format:'\@'"">"&ChangeConsultStatus(Allrec(9,i))&"</td>"&Vbcrlf
	Response.Write "</tr>"
Next
Response.Write "</table>"

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Response.ContentType  = "application/x-msexcel"
Response.CacheControl = "public"
Response.AddHeader "Content-Disposition","attachment;filename="&Server.URLPathEncode("예약리스트.xls")
%>