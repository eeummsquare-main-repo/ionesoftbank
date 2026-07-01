<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "count" : subMenuCode = "count" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec
Dim tp, fd, ed
Dim FDATE, EDATE

tp = Request("tp")
fd = Request("fd")
ed = Request("ed")

SetDefault tp, "8"

FDATE = fd
EDATE = ed
setDefault FDATE, formatdatetime(now, 2)
setDefault EDATE, formatdatetime(now, 2)

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


Dim tmpDB, totalCnt
tmpDB = "select YY, MM from ViewCounter where Register >= Convert(DateTime, '" & FDATE & " 00:00:00') and Register <= Convert(DateTime, '" & EDATE & " 23:59:59')"

sql = "select count(*) from (" & tmpDB & ") tmpDB"
Set Rs = DBcon.Execute(Sql)
TotalCnt = Rs(0)
IF TotalCnt <= 0 Then TotalCnt = 1 

sql = "select YY, MM, Count(*) AS TotalVisit from (" & tmpDB & ") tmpDB Group By YY, MM Order by YY, MM"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing


Function PT_List()
	Dim i
	Dim NDATE, TotalVisit, Percent, PercentSize

	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)

			NDATE = Allrec(0,i) & "년 " & AddZero(Allrec(1,i)) & "월"
			TotalVisit = Allrec(2,i)

			IF CLng(TotalCnt) = 0 then
				Percent = "0%"
				PercentSize = 0
			Else
				Percent = formatpercent(TotalVisit/TotalCnt,1)
				PercentSize = replace(Percent,"%","")*3
			End IF

			Response.Write "<tr bgcolor=""#ffffff"" onmouseover=""this.style.backgroundColor='#F2F9F7'"" onmouseout=""this.style.backgroundColor='#FFFFFF'"">"&Vbcrlf
			Response.Write "	<td><div style=""width:100%;overflow:hidden"">"&NDATE&"</div></td>"&Vbcrlf
			Response.Write "	<td>"&TotalVisit&"</td>"&Vbcrlf
			Response.Write "	<td class=""txt_left""><span class=""graphbar""><span class=""data"" style=""width: "&Percent&"""></span></span></td>"&Vbcrlf
			Response.Write "	<td>"&Percent&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr><td colspan=""4"" style=""padding:70px 0;"">검색된 내역이 없습니다</td><tr>"&Vbcrlf
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
	<p class="top_left inquiry">전체 <span><%=TotalCnt%></span>건의 게시물이 검색되었습니다</p>
</div>

<table class="tbl_col">
	<colgroup>
		<col style="width: 10%" />
		<col style="width: 8%" />
		<col style="width: *" />
		<col style="width: 8%" />
	</colgroup>
	<thead>
		<tr>
			<th scope="row">날짜</th>
			<th scope="row">방문자수</th>
			<th scope="row">그래프</th>
			<th scope="row">백분율</th>
		</tr>
	</thead>
	<tbody>
		<%=PT_List()%>
	</tbody>
</table>

				
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->