<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "" : subMenuCode = "" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ObjRs
Dim totalorder,todayorderlist,OrderRows,todayordercnt
Dim Allrec, memberRec
Dim i

postSubTB = "SELECT idx, regdate FROM BBSLIST UNION SELECT idx, regdate FROM PRODUCT"

Set ObjRs=Nothing
'*------------------------------------게시판 현황 Function -----------------------------------------------*
Function crmBoard(sort,types)
	Dim Sql,Rs,strWhere

	IF types="b" Then
		Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
		Sql = Sql & "from bbslist Where boardidx="&Sort&") as t "
	ElseIF types="c" Then
		Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
		Sql = Sql & "from consult) as t "
	ElseIF types="p" Then
		Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
		Sql = Sql & "from partner) as t "
	ElseIF types="f" Then
		Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
		Sql = Sql & "from faq) as t "
	ElseIF types="emp" Then
		Sql = "select count(*), isnull(sum(scnt),0) from (select case when regdate>='"&Date()&"' then 1 else 0 end as scnt "
		Sql = Sql & "from empApply WHERE isComplete=1) as t "
	End IF
	Rs=DBcon.Execute(Sql)
	Response.Write "<div >전체 등록수 : <font color='#525252'><b>"&Rs(0)&"</b></font> 건</div>"&Vbcrlf
	Response.Write "<div style='padding-top:5px;'>오늘 등록수 : <font color='#00b0bf'><b>"&Rs(1)&"</b></font> 건</div>"&Vbcrlf
	Set Rs=Nothing
End Function
'*---------------------------------------------------------------------------------------------------------*

'############ 30일간 방문수 Count #########################
Dim arrvisitCnt(29)
statVisit7Cnt = 0 : statVisit30Cnt = 0
statStartDate = DateAdd("w",-29,Date())

Sql = "SELECT "&_
		"	Convert(Varchar(10),register,21)"&_
		"	,Count(1) "&_
		"FROM COUNTER WHERE register>='"&statStartDate&"' GROUP BY Convert(Varchar(10),register,21)"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	Do Until Rs.Eof
		arrindex = DateDiff("d", statStartDate, Rs(0))
		arrvisitCnt(arrindex) = Rs(1)

		IF arrindex>=23 Then statVisit7Cnt = CLng(statVisit7Cnt) + CLng(Rs(1))

		statVisit30Cnt = CLng(statVisit30Cnt) + CLng(Rs(1))
		Rs.MoveNext()
	Loop
End IF
'############ 30일간 방문수 Count #########################

'############ 30일간 게시물 Count #########################
Dim arrPostRegCnt(29)
statPostReg7Cnt = 0 : statPostReg30Cnt = 0
statStartDate = DateAdd("w",-29,Date())

Sql = "SELECT "&_
		"	Convert(Varchar(10),regdate,21)"&_
		"	,Count(1) "&_
		"FROM ("&postSubTB&") TB WHERE regdate>='"&statStartDate&"' GROUP BY Convert(Varchar(10),regdate,21)"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	Do Until Rs.Eof
		arrindex = DateDiff("d", statStartDate, Rs(0))
		arrPostRegCnt(arrindex) = Rs(1)

		IF arrindex>=23 Then statPostReg7Cnt = CLng(statPostReg7Cnt) + CLng(Rs(1))

		statPostReg30Cnt = CLng(statPostReg30Cnt) + CLng(Rs(1))
		Rs.MoveNext()
	Loop
End IF
'############ 30일간 게시물 Count #########################

'############ 30일간 회원 Count #########################
Dim arrMemRegCnt(29)
statMemReg7Cnt = 0 : statMemReg30Cnt = 0
statStartDate = DateAdd("w",-29,Date())

Sql = "SELECT "&_
		"	Convert(Varchar(10),regdate,21)"&_
		"	,Count(1) "&_
		"FROM members WHERE regdate>='"&statStartDate&"' GROUP BY Convert(Varchar(10),regdate,21)"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	Do Until Rs.Eof
		arrindex = DateDiff("d", statStartDate, Rs(0))
		arrMemRegCnt(arrindex) = Rs(1)

		IF arrindex>=23 Then statMemReg7Cnt = CLng(statMemReg7Cnt) + CLng(Rs(1))

		statMemReg30Cnt = CLng(statMemReg30Cnt) + CLng(Rs(1))
		Rs.MoveNext()
	Loop
End IF
'############ 30일간 회원 Count #########################

'############ 각 통계 전체 건수 ############################
Sql = "Select count(*) From counter"
Set Rs = DBcon.Execute(Sql)
totalVisitCount = Rs(0)

Sql = "Select count(*) From Members"
Set Rs = DBcon.Execute(Sql)
totalMemRegCount = Rs(0)

Sql = "Select count(*) From ("&postSubTB&") TB"
Set Rs = DBcon.Execute(Sql)
totalPostRegCount = Rs(0)
'############ 각 통계 전체 건수 ############################

Set Rs=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript" src="/_lib/js/jquery-dynamicNumber.js"></script>
<script type="text/javascript" src="/_lib/js/numberAnimate.js"></script>
<script type="text/javascript" src="/_lib/js/charts_loader.js"></script>
<script language="JavaScript">
<!--
$(document).ready(function(){
	google.charts.load('current', {'packages':['corechart']});
	google.charts.setOnLoadCallback(drawVisualization);

	$(".tCnt").each(function(index){
		var nums = $(this).attr("data-num")
		$(this).dynamicNumber()
		$(this).dynamicNumber('go', nums);
	});

});

function drawVisualization() {
	var arrData = [];
	arrData.push(['Date', '방문수', { role: 'style' }]);

	$("#visitCnt td").each(function(){
		var index = $("#visitCnt td").index(this);
		var visitCnt = $(this).html().replace(/,/gi,'');
		var sDate = $("#perHead td").eq(index).html().replace(/,/gi,'');
		arrData.push([sDate, parseInt(visitCnt), 'color: #00b0bf']);
	});

	var data = google.visualization.arrayToDataTable(arrData);
	var options = {
		chartArea:{left:40,top:30, width:'90%'},
		seriesType: 'bars',
		vAxes: {
			0: { title: '', titleTextStyle: {italic: false}, gridlines: { count: 5 } }
		},
		series: {
			0: { targetAxisIndex: 0, type: 'bar', color: '#00b0bf' }
		}
		,animation : {startup:true, duration:300, easing:'in' }
		,legend : {
			position : 'bottom' // 항목 표시 여부 및 위치
		}
		,focusTarget: 'category'
		,tooltip: {isHtml: true}
	};

	var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
	chart.draw(data, options);
}
//-->
</script>
</head>
<body class="adMain">
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<div class="contents">
				<div class="section">


					<div style='clear:both; padding-top:40px;'>
						<div style='float:left; width:49%'>
							<h2>최근 일주일 방문 건수 ( <%=statStartDate%> ~ <%=Date()%>)</h2>

							<div class="disNone">
								<table>
									<tr id="perHead">
										<th>구분</th>
										<td><%=uf_ConvertDateFormat(DateAdd("w",29,statStartDate),14)%></td>
										<td><%=uf_ConvertDateFormat(DateAdd("w",28,statStartDate),14)%></td>
										<td><%=uf_ConvertDateFormat(DateAdd("w",27,statStartDate),14)%></td>
										<td><%=uf_ConvertDateFormat(DateAdd("w",26,statStartDate),14)%></td>
										<td><%=uf_ConvertDateFormat(DateAdd("w",25,statStartDate),14)%></td>
										<td><%=uf_ConvertDateFormat(DateAdd("w",24,statStartDate),14)%></td>
										<td><%=uf_ConvertDateFormat(DateAdd("w",23,statStartDate),14)%></td>
									</tr>
									<tr id="visitCnt">
										<th>주문건</th>
										<td class="right"><%=spaceToZero(arrvisitCnt(29))%></td>
										<td class="right"><%=spaceToZero(arrvisitCnt(28))%></td>
										<td class="right"><%=spaceToZero(arrvisitCnt(27))%></td>
										<td class="right"><%=spaceToZero(arrvisitCnt(26))%></td>
										<td class="right"><%=spaceToZero(arrvisitCnt(25))%></td>
										<td class="right"><%=spaceToZero(arrvisitCnt(24))%></td>
										<td class="right"><%=spaceToZero(arrvisitCnt(23))%></td>
									</tr>
								</table>
							</div>

							<div id="chart_div" style="width: 100%; height: 280px; border:1px solid #e2e2e2"></div>
						</div>

						<div style='float:right; width:49%'>
							<h2>기간별 현황</h2>

							<table class="tbl_col termStats">
								<colgroup>
									<col style="width: 25%" />
									<col style="width: 25%" />
									<col style="width: 25%" />
									<col style="width: 25%" />
								</colgroup>
								<thead>
								<tr>
									<th scope="row">날짜</th>
									<th scope="row">방문수</th>
									<th scope="row">게시물 등록수</th>
									<th scope="row">회원 가입수</th>
								</tr>
								</thead>
								<tbody>
								<tr>
									<td><%=uf_ConvertDateFormat(Date(),14)%> (오늘)</td>
									<td class="right"><span class="cnt"><%=spaceToZero(arrvisitCnt(29))%></span> 건</td>
									<td class="right"><span class="cnt"><%=spaceToZero(arrPostRegCnt(29))%></span> 건</td>
									<td class="right"><span class="cnt"><%=spaceToZero(arrMemRegCnt(29))%></span> 건</td>
								</tr>
								<tr>
									<td>최근 7일 합계</td>
									<td class="right"><span class="sum"><%=statVisit7Cnt%></span> 건</td>
									<td class="right"><span class="sum"><%=statPostReg7Cnt%></span> 건</td>
									<td class="right"><span class="sum"><%=statMemReg7Cnt%></span> 건</td>
								</tr>
								<tr>
									<td>최근 7일 평균</td>
									<td class="right"><span class="avg"><%=FormatNumber(statVisit7Cnt / 7, 2)%></span> 건</td>
									<td class="right"><span class="avg"><%=FormatNumber(statPostReg7Cnt / 7, 2)%></span> 건</td>
									<td class="right"><span class="avg"><%=FormatNumber(statMemReg7Cnt / 7, 2)%></span> 건</td>
								</tr>
								<tr>
									<td>최근 30일 합계</td>
									<td class="right"><span class="sum"><%=statVisit30Cnt%></span> 건</td>
									<td class="right"><span class="sum"><%=statPostReg30Cnt%></span> 건</td>
									<td class="right"><span class="sum"><%=statMemReg30Cnt%></span> 건</td>
								</tr>
								<tr>
									<td>최근30일 평균</td>
									<td class="right"><span class="avg"><%=FormatNumber(statVisit30Cnt / 30, 2)%></span> 건</td>
									<td class="right"><span class="avg"><%=FormatNumber(statPostReg30Cnt / 30, 2)%></span> 건</td>
									<td class="right"><span class="avg"><%=FormatNumber(statMemReg30Cnt / 30, 2)%></span> 건</td>
								</tr>
								<tr>
									<td>전체</td>
									<td class="right"><span class="tCnt" data-num="<%=totalVisitCount%>" data-from="0" data-format="group"></span> 건</td>
									<td class="right"><span class="tCnt" data-num="<%=totalPostRegCount%>" data-from="0" data-format="group"></span> 건</td>
									<td class="right"><span class="tCnt" data-num="<%=totalMemRegCount%>" data-from="0" data-format="group"></span> 건</td>
								</tr>
								</tbody>
							</table>
						</div>
					</div>

					<div style='clear:both; padding-top:20px;'>
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td><h2>정부지원사업 & 구입문의 등록현황</h2></td>
						</tr>
						<tr>
							<td>
								<table class="tbl_colMain">
									<caption></caption>
									<colgroup>
										<col style="width: 20%" />
										<col style="width: 20%" />
										<col style="width: 20%" />
										<col style="width: 20%" />
										<col style="width: 20%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=1'>공지사항</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=2'>제품/서비스 구매상담</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=3'>세미나 안내/소개 영상</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=4'>제품/서비스 제안서</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=31'>Amaranth 10 소개영상</a></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><% crmBoard 1,"b" %></td>
											<td><% crmBoard 2,"b" %></td>
											<td><% crmBoard 3,"b" %></td>
											<td><% crmBoard 4,"b" %></td>
											<td><% crmBoard 31,"b" %></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</table>
					</div>

					<div style='clear:both; padding-top:20px;'>
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td><h2>Amaranth10 고객센터 등록현황</h2></td>
						</tr>
						<tr>
							<td>
								<table class="tbl_colMain">
									<caption></caption>
									<colgroup>
										<col style="width: 33%" />
										<col style="width: 33%" />
										<col style="width: 33%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=8'>1:1사용문의</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=5'>동영상강의</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=7'>자료실</a></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><% crmBoard 8,"b" %></td>
											<td><% crmBoard 5,"b" %></td>
											<td><% crmBoard 7,"b" %></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</table>
					</div>

					<div style='clear:both; padding-top:20px;'>
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td><h2>iCUBE / iCUBE G20 고객센터 등록현황</h2></td>
						</tr>
						<tr>
							<td>
								<table class="tbl_colMain">
									<caption></caption>
									<colgroup>
										<col style="width: 33%" />
										<col style="width: 33%" />
										<col style="width: 33%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=18'>1:1사용문의</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=15'>동영상강의</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=17'>자료실</a></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><% crmBoard 18,"b" %></td>
											<td><% crmBoard 15,"b" %></td>
											<td><% crmBoard 17,"b" %></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</table>
					</div>

					<div style='clear:both; padding-top:20px;'>
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td><h2>Bizbox Alpha 고객센터 등록현황</h2></td>
						</tr>
						<tr>
							<td>
								<table class="tbl_colMain">
									<caption></caption>
									<colgroup>
										<col style="width: 25%" />
										<col style="width: 25%" />
										<col style="width: 25%" />
										<col style="width: 25%" />
									</colgroup>
									<thead>
										<tr>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=28'>1:1사용문의</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=26'>업데이트내역</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=25'>동영상강의</a></th>
											<th scope="row"><a href='/backoffice/board/bbslist.asp?bbscode=27'>자료실</a></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><% crmBoard 28,"b" %></td>
											<td><% crmBoard 26,"b" %></td>
											<td><% crmBoard 25,"b" %></td>
											<td><% crmBoard 27,"b" %></td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</table>
					</div>

					<div class="cs_center">
						<div class="main_tlt">
							<h3>PRIX 고객센터 안내</h3>
							<p>COSTOMER CENTER</p>
						</div>
						<ul class="list_st_dot">
							<li>
								<span>문의전화</span>
								<a href="tel:02-3478-0711"><strong>02-3478-0711</strong></a>
							</li>
							<li>
								<span>상담가능시간</span>
								<p class="mt5">평일 10:00 ~ 18:00 (점심 12:00 ~ 13:00)<br>주말 및 공휴일 휴무</p>
							</li>
						</ul>
						<a class="maintenanceBtn" href="mailto:info@prix.co.kr"><p><img src="./images/h1_logo_20200407.png" alt=""></p>유지보수 신청</a>
					</div>

				</div>
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->