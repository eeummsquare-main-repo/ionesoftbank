<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "count" : subMenuCode = "count" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim tp, fd, ed
Dim FDATE, EDATE

tp = Request("tp")
fd = Request("fd")
ed = Request("ed")

SetDefault tp, "1"

FDATE = fd
EDATE = ed
setDefault FDATE, formatdatetime(now, 2)
setDefault EDATE, formatdatetime(now, 2)

Dim Allrec
Dim Record_Cnt,TotalPage,PageSize,Page,Count

Page=GetPage()
PageSize=20

Sql="select top "&PageSize&" ip, referer, agent, register, strBrowser, strWindow from counter WHERE Register > convert(datetime, '" & FDATE & " 00:00:00') and Register < convert(datetime, '" & EDATE & " 23:59:59') AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from counter WHERE Register > convert(datetime, '" & FDATE & " 00:00:00') and Register < convert(datetime, '" & EDATE & " 23:59:59') order by register desc) order by register desc"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) from counter where Register > convert(datetime, '" & FDATE & " 00:00:00') and Register < convert(datetime, '" & EDATE & " 23:59:59')")
	TotalPage=Int((CLng(Record_Cnt(0))-1)/CLng(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count = 0 : TotalPage = 1
End IF


'=============공통=========================
Dim YesterDay1, YesterDay2
Dim toDay1, toDay2
Dim Total_Count, Yesterday_Count, Today_Count

YesterDay1 = date() - 1 & " 00:00:00"
YesterDay2 = date() - 1 & " 23:59:59"  	
ToDay1 = date()  & " 00:00:00"
ToDay2 = date()  & " 23:59:59"   	 

sql = "select count(*) from counter"
Set Rs = DBcon.Execute(Sql)
Total_Count = Rs(0)
Setdefault Total_Count , 0

sql = "select count(*) from counter where register between '"& YesterDay1 &"' and '"& YesterDay2 &"' "
Set Rs = DBcon.Execute(Sql)
Yesterday_Count = rs(0)
Setdefault Yesterday_Count , 0

sql = "select count(*) from counter where register between '"& ToDay1 &"' and '"& ToDay2 &"' "
Set Rs = DBcon.Execute(Sql)
Today_Count = rs(0)
Setdefault Today_Count , 0
'=========================================

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_List()
	Dim i
	Dim ip, Referer, Agent, Register, Browser, Window

	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			Ip = Allrec(0,i)
			Referer = Allrec(1,i)
			Agent = Allrec(2,i)
			Register = Allrec(3,i)
			Browser = Allrec(4,i)
			Window = Allrec(5,i)
			
			setDefault Referer, "BOOKMARK"

			IF Not Referer = "BOOKMARK" then
				Referer = "<a href='" & Referer & "' target=_blank>" & Referer & "</a>"
			End If
			
			Response.Write "<tr bgcolor=""#ffffff"" onmouseover=""this.style.backgroundColor='#F2F9F7'"" onmouseout=""this.style.backgroundColor='#FFFFFF'"">"&Vbcrlf
			Response.Write "	<td>"&IP&"</td>"&Vbcrlf
			Response.Write "	<td class=""left""><div style=""width:100%;overflow:hidden"">"&Referer&"</div></td>"&Vbcrlf
			Response.Write "	<td>"&Browser&"</td>"&Vbcrlf
			Response.Write "	<td>"&Window&"</td>"&Vbcrlf
			Response.Write "	<td>"&Register&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr><td colspan=""5"" style=""padding:70px 0;"">검색된 내역이 없습니다</td><tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script>
var SEARCH_TYPE_1 = 1;
var SEARCH_TYPE_2 = 2;
var SEARCH_TYPE_3 = 3;
var SEARCH_TYPE_4 = 4;
var SEARCH_TYPE_5 = 5;
var SEARCH_TYPE_6 = 6;
var SEARCH_TYPE_7 = 7;
var SEARCH_TYPE_8 = 8;
var SEARCH_TYPE_9 = 9;

function fnSearch(){
	var obj = document.fo_search;
	var tp = arguments[0];

	switch(tp) {
		case SEARCH_TYPE_1: obj.action = 'index.asp'; break;
		case SEARCH_TYPE_2: obj.action = 'count1.asp'; break;
		case SEARCH_TYPE_3: obj.action = 'count2.asp'; break;
		case SEARCH_TYPE_4: obj.action = 'count3.asp'; break;
		case SEARCH_TYPE_5: obj.action = 'count4.asp'; break;
		case SEARCH_TYPE_6: obj.action = 'count5.asp'; break;
		case SEARCH_TYPE_7: obj.action = 'count6.asp'; break;
		case SEARCH_TYPE_8: obj.action = 'count7.asp'; break;
		case SEARCH_TYPE_9: obj.action = 'count8.asp'; break;
	}
	
	obj.tp.value = tp;
	obj.submit();
}
</script>
</head>

<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<div class="contents">

				<div class="location">
					<h2 class="top_left">접속통계</h2>
					<a href="/backoffice/">HOME</a> &gt; <span>접속통계</span>
				</div>

<!--#include file = "counter_menu.asp" -->	

<div class="tbl_top">
	<p class="top_left inquiry">전체 <span><%=Count%></span>건의 게시물이 검색되었습니다</p>
</div>

<table class="tbl_col">
	<colgroup>
		<col style="width: 10%" />
		<col style="width: *" />
		<col style="width: 15%" />
		<col style="width: 15%" />
		<col style="width: 13%" />
	</colgroup>
	<thead>
		<tr>
			<th scope="row">방문IP</th>
			<th scope="row">방문경로</th>
			<th scope="row">브라우져</th>
			<th scope="row">운영체제</th>
			<th scope="row">일시</th>
		</tr>
	</thead>
	<tbody>
		<%=PT_List()%>
	</tbody>
</table>

<%=PT_PageLink("","tp="&tp&"&fd="&fd&"&ed="&ed,"")%>


				
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->