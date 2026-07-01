<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode
BBSCode = uf_getRequest(Request("BBSCode"),"int","","1")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec
Dim BBsSelectField, strWhere
Dim Record_Cnt, TotalPage, Page, Count

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serDate1, serdate2

page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("pageSize"),"int","","20")
serstatus = uf_getRequest(Request("serstatus"),"int","","")
serisDisplay = uf_getRequest(Request("serisDisplay"),"int","","")
serismain = uf_getRequest(Request("serismain"),"int","","")
serboardsort = uf_getRequest(Request("serboardsort"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","5","1")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serCate1=uf_getRequest(Request("serCate1"),"char","","")
serCate2=uf_getRequest(Request("serCate2"),"char","","")
serCate3=uf_getRequest(Request("serCate3"),"char","","")
oSearchStr = Request("searchstr")

PageLink="bbslist.asp"
PageStr="BBscode="&BBscode&"&pagesize="&PageSize&"&serstatus="&serstatus&"&serisDisplay="&serisDisplay&"&serismain="&serismain&"&serboardsort="&serboardsort&"&serDate1="&serDate1&"&serdate2="&serdate2&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)

IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then
	IF serCate1<>"" Then StrWhere = StrWhere & " AND cate1='"&serCate1&"'"
	IF serCate2<>"" Then StrWhere = StrWhere & " AND cate2='"&serCate2&"'"
	IF serCate3<>"" Then StrWhere = StrWhere & " AND cate3='"&serCate3&"'"

	IF serCate1<>"" Then PageStr = PageStr & "&serCate1="&serCate1
	IF serCate2<>"" Then PageStr = PageStr & "&serCate2="&serCate2
	IF serCate3<>"" Then PageStr = PageStr & "&serCate3="&serCate3
End IF
'=============================================

IF serDate1 <> "" Then strWhere = strWhere & " AND regdate>'"&serDate1&"'"
IF serDate2 <> "" Then strWhere = strWhere & " AND regdate<'"&DateAdd("d",1,serDate2)&"'"
IF serboardsort<>"" Then strWhere = strWhere & " AND boardsort="&serboardsort&" "
IF SearchStr <> "" Then
	IF seritem = "2" Then
		strWhere = strWhere & " AND content Like N'%"&SearchStr&"%'"
	ElseIF seritem = "3" Then
		strWhere = strWhere & " AND (title Like N'%"&SearchStr&"%' OR content Like N'%"&SearchStr&"%')"
	ElseIF seritem = "4" Then
		strWhere = strWhere & " AND writer Like N'%"&SearchStr&"%'"
	ElseIF seritem = "5" Then
		strWhere = strWhere & " AND note1 Like N'%"&SearchStr&"%'"
	Else
		seritem = "1"
		strWhere = strWhere & " AND title Like N'%"&SearchStr&"%'"
	End IF
End IF

IF BBscode="100" Then
	IF serstatus<>"" Then strWhere = strWhere & " AND status = "&serstatus
Else
	IF serstatus="2" Then
		strWhere = strWhere & " AND replyCnt > 1"
	ElseIF serstatus="1" Then
		strWhere = strWhere & " AND submit = 1 AND replyCnt=1"
	ElseIF serstatus="0" Then
		strWhere = strWhere & " AND submit = 0"
	End IF
End IF
IF serisDisplay<>"" Then strWhere = strWhere & " AND isDisplay = "&serisDisplay
IF serismain<>"" Then strWhere = strWhere & " AND isMain = "&serismain

Set Rs=server.CreateObject("ADODB.RecordSet")
Sql = "SELECT idx, writer, company, tel, email, title, regdate FROM BBslist WHERE relevel='A' AND boardidx="&BBsCode & strWhere&" ORDER BY Topyn DESC, sortDate DESC, Ref desc, ReLevel ASC, Idx DESC"
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
Response.Write "<td>No</td>"
Response.Write "<td>First Name</td>"
Response.Write "<td>Last Name</td>"
Response.Write "<td>Organization</td>"
Response.Write "<td>Contact Number</td>"
Response.Write "<td>Email</td>"
Response.Write "<td>Title</td>"
Response.Write "<td>Regdate</td>"
Response.Write "</tr>"
For i=0 To Ubound(Allrec,2)

	idx = Allrec(0,i)
	writer = Allrec(1,i)
	company = Allrec(2,i)
	tel = Allrec(3,i)
	email = Allrec(4,i)
	title = Allrec(5,i)
	regdate = Allrec(6,i)

	arrName = Split(writer,"|")
	IF Ubound(arrName)<1 Then ReDim arrName(1)

	Response.Write "<tr>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&i+1&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&arrName(0)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&arrName(1)&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&company&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&tel&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&email&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&title&"</td>"
	Response.Write "<td style=""mso-number-format:'\@'"">"&regdate&"</td>"
	Response.Write "</tr>"
Next
Response.Write "</table>"

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Response.ContentType  = "application/x-msexcel"
Response.CacheControl = "public"
Response.AddHeader "Content-Disposition","attachment;filename="&Server.URLPathEncode("contactUs.xls")
%>