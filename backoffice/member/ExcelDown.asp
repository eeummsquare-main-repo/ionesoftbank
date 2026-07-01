<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'==========검색 관련=========================================
page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("PageSize"),"int","","20")
IF PageSize = "" Then PageSize=20

seroutmember = uf_getRequest(Request("seroutmember"),"int","1","")
serMemsort = uf_getRequest(Request("serMemsort"),"int","","")
serAuth = uf_getRequest(Request("serAuth"),"int","","")
serOrderbyStr = uf_getRequest(Request("serOrderbyStr"),"char","","")
serOrderbyDec = uf_getRequest(Request("serOrderbyDec"),"char","","")
searchitem = uf_getRequest(Request("searchitem"),"char","","")
searchstr = uf_getRequest(Request("searchstr"),"char","","")

oSearchStr = Request("searchstr")

IF Page="" Then	Page=1
IF serOrderbyStr="" Then serOrderbyStr="idx"
IF serOrderbyDec="" Then serOrderbyDec="DESC"
IF searchstr<>"" Then
	IF SearchItem="birthday" OR SearchItem="phone" Then
		strWhere = strWhere & " AND Replace("&SearchItem&",'-','') LIKE N'%"&Replace(searchstr,"-","")&"%' "
	Else
		strWhere = strWhere & " AND "&SearchItem&" LIKE N'%"&searchstr&"%' "
	End IF
End IF
IF seroutmember<>"" Then strWhere = strWhere & " AND outmember = "&seroutmember&" "
IF serAuth<>"" Then strWhere = strWhere & " AND isAuth = "&serAuth&" "
IF serMemsort<>"" Then strWhere = strWhere & " AND memsort = "&serMemsort&" "

PageLink="memberlist.asp"
PageStr="pagesize="&PageSize&"&seroutmember="&seroutmember&"&serMemsort="&serMemsort&"&serAuth="&serAuth&"&serOrderbyStr="&serOrderbyStr&"&serOrderbyDec="&serOrderbyDec&"&searchitem="&searchitem&"&searchstr="&Server.UrlEncode(oSearchStr)
'==========검색 관련=========================================

chkidx = uf_getRequest(Request("chkidx"),"char","","")
IF chkidx<>"" Then
	strWhere = strWhere & " AND idx IN ("&chkidx&")"
End IF

Set Rs=server.CreateObject("ADODB.RecordSet")
Sql = "select " 
Sql = Sql & "Case When memsort=0 Then '일반회원' When memsort=1 Then '특별회원' End "
Sql = Sql & ",Case When isAuth=0 Then '가입대기중' When isAuth=1 Then '보류' When isAuth=99 Then '가입승인' End "
Sql = Sql & ",ID"
Sql = Sql & ",name"
Sql = Sql & ",phone"
Sql = Sql & ",email"
Sql = Sql & ",bizcode"
Sql = Sql & ",company"
Sql = Sql & ",zipcode"
Sql = Sql & ",addr1"
Sql = Sql & ",addr2"
Sql = Sql & ",Case When smsYN=0 Then 'N' Else 'Y' End "
Sql = Sql & ",Case When emailYN=0 Then 'N' Else 'Y' End "
Sql = Sql & ",regdate"
Sql = Sql & ",loginCnt"
Sql = Sql & ",lastLogin "
Sql = Sql & "FROM members where 1=1 "&strWhere&" order by "&serOrderbyStr&" "&serOrderbyDec
Rs.Open Sql,dbcon,1

IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaAlert("검색된 회원이 없습니다.",0)
	Response.End
Else
	Allrec=Rs.GetRows()
End IF
Rs.Close

Response.Write "<table border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' style='border-collapse: collapse'>"
Response.Write "<tr align='center' height='30' bgcolor='#E1E1E1'>"
Response.Write "<td>순번</td>"
Response.Write "<td>회원등급</td>"
Response.Write "<td>승인여부</td>"
Response.Write "<td>아이디</td>"
Response.Write "<td>이름</td>"
Response.Write "<td>연락처</td>"
Response.Write "<td>이메일</td>"
Response.Write "<td>사업자등록번호</td>"
Response.Write "<td>회사명</td>"
Response.Write "<td>우편번호</td>"
Response.Write "<td>주소</td>"
Response.Write "<td>상세주소</td>"
Response.Write "<td>SMS수신여부</td>"
Response.Write "<td>이메일수신여부</td>"
Response.Write "<td>등록일</td>"
Response.Write "<td>접속회수</td>"
Response.Write "<td>최종접속일</td>"
Response.Write "</tr>"
For i=0 To Ubound(Allrec,2)
	Response.Write "<tr>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&i+1&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(0,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(1,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(2,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(3,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(4,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(5,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(6,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(7,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(8,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(9,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(10,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(11,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(12,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(13,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(14,i)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&Allrec(15,i)&"</td>"
	Response.Write "</tr>"
Next
Response.Write "</table>"

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Response.ContentType  = "application/x-msexcel"
Response.CacheControl = "public"
Response.AddHeader "Content-Disposition","attachment;filename="&Server.URLPathEncode("회원리스트.xls")
%>