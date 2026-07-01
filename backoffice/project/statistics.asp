<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "intra" : subMenuCode = "intra02" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
serdateDiv = uf_getRequest(Request("serdateDiv"),"int","1","0")
serdate1 = uf_getRequest(Request("serdate1"),"date","","")
serdate2 = uf_getRequest(Request("serdate2"),"date","","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

IF serDate1 <> "" Then strWhere = strWhere & " AND Convert(VARCHAR,year) + FORMAT(pMonth, '00') >= '"&Left(Replace(serdate1,"-",""),6)&"' "
IF serDate2 <> "" Then strWhere = strWhere & " AND Convert(VARCHAR,year) + FORMAT(pMonth, '00') <= '"&Left(Replace(serDate2,"-",""),6)&"' "
IF searchStr <> "" Then strWhere = strWhere & " AND (pOrder Like N'%"&SearchStr&"%')"
'=============================================

Dim Allrec,Page,PageSize,Record_Cnt,TotalPage,Count

Sql = "SELECT id, pMonth, pNo, pDiv, pNm, pOrder, pFloor, pArea, estAmount, setAmount, outAmount, outCompany, coldate1, coldate2, coldate3, coldate4, coldate5, colamount1, colamount2, colamount3, colamount4, colamount5, isReg , year FROM businessData WHERE pNm<>'' "&strWhere&" ORDER BY year DESC, id ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec = Rs.GetRows()

DBcon.Close
Set DBcon=Nothing

Dim NextID : NextID=1

Function Pt_List
	IF IsArray(Allrec) Then
		Dim id, pMonth, pNo, pDiv, pNm, pOrder, pFloor, pArea, estAmount, setAmount, outAmount, outCompany, coldate1, coldate2, coldate3, coldate4, coldate5, colamount1, colamount2, colamount3, colamount4, colamount5, isReg

		For i=0 To Ubound(Allrec,2)
			id = changeBlank(Allrec(0,i))
			pMonth = changeBlank(Allrec(1,i))
			pNo = changeBlank(Allrec(2,i))
			pDiv = changeBlank(Allrec(3,i))
			pNm = changeBlank(Allrec(4,i))
			pOrder = changeBlank(Allrec(5,i))
			pFloor = changeBlank(Allrec(6,i))
			pArea = changeBlank(Allrec(7,i))
			estAmount = changeBlank(Allrec(8,i))
			setAmount = changeBlank(Allrec(9,i))
			outAmount = changeBlank(Allrec(10,i))
			outCompany = changeBlank(Allrec(11,i))
			coldate1 = changeBlank(Allrec(12,i))
			coldate2 = changeBlank(Allrec(13,i))
			coldate3 = changeBlank(Allrec(14,i))
			coldate4 = changeBlank(Allrec(15,i))
			coldate5 = changeBlank(Allrec(16,i))
			colamount1 = changeBlank(Allrec(17,i))
			colamount2 = changeBlank(Allrec(18,i))
			colamount3 = changeBlank(Allrec(19,i))
			colamount4 = changeBlank(Allrec(20,i))
			colamount5 = changeBlank(Allrec(21,i))
			isReg = changeBlank(Allrec(22,i))
			pYear = changeBlank(Allrec(23,i))

			'wMinute = Round(wMinute / 60 / 8 , 2)
			'tSumRate = 0 : ioRate = 0 : impClass = ""
			'gIO = CDbl(gPlan) + CDbl(gDesign) + CDbl(gPub) + CDbl(gDev)
			'IF gIO>0 Then ioRate = Round(CDbl(wMinute) / CDbl(gIO) * 100, 0)
			'tProcSum = round(gPlan,2) + round(gDesign,2) + round(gPub,2) + round(gDev,2)
			'IF tProcSum<>0 Then
			'	tSumRate = tSumRate + ( round(gPlan,2) / tProcSum ) * round(planRate,2)
			'	tSumRate = tSumRate + ( round(gDesign,2) / tProcSum ) * round(designRate,2)
			'	tSumRate = tSumRate + ( round(gPub,2) / tProcSum ) * round(pubRate,2)
			'	tSumRate = tSumRate + ( round(gDev,2) / tProcSum ) * round(devRate,2)
			'End IF

			suPrice = 0 : suRate = 0
			suPrice = CLng(SpaceToZero(colamount1)) + CLng(SpaceToZero(colamount2)) + CLng(SpaceToZero(colamount3)) + CLng(SpaceToZero(colamount4)) + CLng(SpaceToZero(colamount5))

			IF CLng(SpaceToZero(setAmount))<>0 THen
				suRate = CLng(suPrice) / CLng(SpaceToZero(setAmount)) * 100
			End IF

'			IF suPrice=0 Then suPrice=""
'			IF suRate=0 Then
'				suRate = ""
'			Else
				suRate = Round(suRate,1)&"%"
'			End IF

			Response.Write "{"&Vbcrlf
			Response.Write "	id:"&id&""&Vbcrlf
			Response.Write "	, pMonth:"""&ReplaceJScript(pMonth)&""""&Vbcrlf
			Response.Write "	, pNo:"""&ReplaceJScript(pNo)&""""&Vbcrlf
			Response.Write "	, pDiv:"""&ReplaceJScript(pDiv)&""""&Vbcrlf
			Response.Write "	, pNm:"""&ReplaceJScript(pNm)&""""&Vbcrlf
			Response.Write "	, pOrder:"""&ReplaceJScript(pOrder)&""""&Vbcrlf
			Response.Write "	, pFloor:"""&ReplaceJScript(pFloor)&""""&Vbcrlf
			Response.Write "	, pArea:"""&ReplaceJScript(pArea)&""""&Vbcrlf
			Response.Write "	, estAmount:"""&ReplaceJScript(estAmount)&""""&Vbcrlf
			Response.Write "	, setAmount:"""&ReplaceJScript(setAmount)&""""&Vbcrlf
			Response.Write "	, outAmount:"""&ReplaceJScript(outAmount)&""""&Vbcrlf
			Response.Write "	, outCompany:"""&ReplaceJScript(outCompany)&""""&Vbcrlf
			Response.Write "	, coldate1:"""&ReplaceJScript(coldate1)&""""&Vbcrlf
			Response.Write "	, coldate2:"""&ReplaceJScript(coldate2)&""""&Vbcrlf
			Response.Write "	, coldate3:"""&ReplaceJScript(coldate3)&""""&Vbcrlf
			Response.Write "	, coldate4:"""&ReplaceJScript(coldate4)&""""&Vbcrlf
			Response.Write "	, coldate5:"""&ReplaceJScript(coldate5)&""""&Vbcrlf

			Response.Write "	, colamount1:"""&ReplaceJScript(colamount1)&""""&Vbcrlf
			Response.Write "	, colamount2:"""&ReplaceJScript(colamount2)&""""&Vbcrlf
			Response.Write "	, colamount3:"""&ReplaceJScript(colamount3)&""""&Vbcrlf
			Response.Write "	, colamount4:"""&ReplaceJScript(colamount4)&""""&Vbcrlf
			Response.Write "	, colamount5:"""&ReplaceJScript(colamount5)&""""&Vbcrlf

			Response.Write "	, colAmount:"""&suPrice&""""&Vbcrlf
			Response.Write "	, colRate:"""&suRate&""""&Vbcrlf

			Response.Write "	, isReg:"&isReg&""&Vbcrlf
			Response.Write "	, pYear:"&pYear&""&Vbcrlf
			Response.Write "},"&Vbcrlf

			NextID = CLng(id) + 1
		Next
	End IF
End Function
%>
<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="/_lib/js/jquery-dynamicNumber.js"></script>
<script type="text/javascript" src="/_lib/js/numberAnimate.js"></script>
<script type="text/javascript" src="/_lib/js/charts_loader.js"></script>
<link href="/_lib/tabulator-master/dist/css/tabulator.min.css" rel="stylesheet">
<script type="text/javascript" src="/_lib/tabulator-master/dist/js/tabulator.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/luxon@2.4.0/build/global/luxon.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var tabledata = [
		<%=Pt_List%>
	 ];

	var table = new Tabulator("#dataTable", {
		//height:"60%", // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
		history:true,
		data:tabledata, //assign data to table
		layout:"fitColumns", //fit columns to width of table (optional)
		columnHeaderVertAlign:"middle",
		persistence:true,
		columnDefaults:{
			headerSort:false,
			hozAlign:"center",
			headerHozAlign:"center",
			resizable:"header",
			width:100,
		},

		columns:[
			{title:"년", field:"pYear", width:60, cssClass:"pYear", frozen:true},
			{title:"월", field:"pMonth", width:60, cssClass:"pMonth", frozen:true},
			{title:"No", field:"pNo", width:60, frozen:true},
			{title:"구분", field:"pDiv", width:70, cssClass:"pDiv", frozen:true},
			{title:"프로젝트명", field:"pNm", width:150, cssClass:"pmNm", frozen:true},
			{title:"발주처", width:100, field:"pOrder", frozen:true},
			{
				title:"규모",
				headerHozAlign:"center",
				columns:[
					{title:"층수<br>(지상/지하)", field:"pFloor", hozAlign:"right", width:50},
					{title:"면적<br>(㎡)", field:"pArea", width:50},
				],
			},
			{title:"견적금액", field:"estAmount", width:90, cssClass:"estAmount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
			{title:"결정금액", field:"setAmount", width:90, cssClass:"setAmount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
			{title:"외주비용", field:"outAmount", width:90, cssClass:"outAmount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
			{title:"외주처", field:"outCompany", width:100},

			{
				title:"수금일 및 수금액",
				headerHozAlign:"center",
				columns:[
					{
						title:"1차",
						columns:[
							{title:"수금일", field:"coldate1", cssClass:"coldate", width:80},
							{title:"수금액", field:"colamount1", width:90, cssClass:"colamount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
					{
						title:"2차",
						columns:[
							{title:"수금일", field:"coldate2", cssClass:"coldate", width:80},
							{title:"수금액", field:"colamount2", width:90, cssClass:"colamount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
					{
						title:"3차",
						columns:[
							{title:"수금일", field:"coldate3", cssClass:"coldate", width:80},
							{title:"수금액", field:"colamount3", width:90, cssClass:"colamount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
					{
						title:"4차",
						columns:[
							{title:"수금일", field:"coldate4", cssClass:"coldate", width:80},
							{title:"수금액", field:"colamount4", width:90, cssClass:"colamount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
					{
						title:"5차",
						columns:[
							{title:"수금일", field:"coldate5", cssClass:"coldate", width:80},
							{title:"수금액", field:"colamount5", width:90, cssClass:"colamount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
				],
			},

			{title:"수금금액", field:"colAmount", width:90, cssClass:"tColAmount", formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
			{title:"수금율", field:"colRate", width:50, cssClass:"colRate",},
			{title:"실적<br>등록", field:"isReg", width:50, formatter:"tickCross", resizable:false, cssClass:"lineNone"},
		],
	});
	document.getElementById("download-xlsx").addEventListener("click", function(){
		table.download("xlsx", "data.xlsx", {sheetName:"My Data"});
	});
	table.on("tableBuilt", function(){
		cal()
	});

	function cal(){
		console.log("cal함수 실행")

		var tEstPrice = 0, tSuKumPrice = 0, projCnt = 0
		$(".tabulator .tabulator-row").each(function(){
			var setAmount = getNumber($(this).find(".setAmount").text())
			var tColAmount = 0;
			var colRate = 0;
			var projNm = $(this).find(".pmNm").html()

			$(this).find(".colamount").each(function(){
				tColAmount = tColAmount + getNumber($(this).text())
			});

			if (setAmount!=0 && tColAmount!=0) colRate = Math.round( (tColAmount / setAmount * 100) *10) / 10;

			$(this).find(".tColAmount").html( formatNumber(tColAmount,3) )
			$(this).find(".colRate").html( colRate + "%" )

			tEstPrice = tEstPrice + setAmount
			tSuKumPrice = tSuKumPrice + tColAmount

			if (parseInt(colRate)>=100){
				$(this).css({"background-color" : "#d1eaff"})
			}else{
				$(this).css({"background-color" : ""})
			}
			if (projNm!="&nbsp;") projCnt++
		});

		$("#tProjectCnt").html(formatNumber(projCnt,3))
		$("#tEstPrice").html(formatNumber(tEstPrice,3))
		$("#tSuKumPrice").html(formatNumber(tSuKumPrice,3))

		google.charts.load('current', {'packages':['corechart']});
		google.charts.setOnLoadCallback(drawChart);
	}

	function drawChart() {
		var arrData = [];
		arrData.push(['Task', 'Hours per Day']);
		var arrData1 = [];
		arrData1.push(['Task', 'Hours per Day']);

		var yearArry = [];
		var monthPrice = [];
		var price1=0, price2=0, price3=0, price4=0
		var sprice1=0, sprice2=0, sprice3=0, sprice4=0

		$(".tabulator .tabulator-row").each(function(){
			var pDiv = $(this).find(".pDiv").text();
			var pMonth = getNumber($(this).find(".pMonth").text());

			if (pDiv=="구조설계"){
				price1 = price1 + getNumber($(this).find(".setAmount").text())
				sprice1 = sprice1 + getNumber($(this).find(".tColAmount").text())
			}else if (pDiv=="안전진단 및 검토"){
				price2 = price2 + getNumber($(this).find(".setAmount").text())
				sprice2 = sprice2 + getNumber($(this).find(".tColAmount").text())
			}else if (pDiv=="안전진단"){
				price3 = price3 + getNumber($(this).find(".setAmount").text())
				sprice3 = sprice3 + getNumber($(this).find(".tColAmount").text())
			}else if (pDiv=="성능평가 및 검증"){
				price4 = price4 + getNumber($(this).find(".setAmount").text())
				sprice4 = sprice4 + getNumber($(this).find(".tColAmount").text())
			}

			$(this).find(".coldate").each(function(){
				var suDate = $(this).text()
				var suPrice = getNumber($(this).next(".colamount").text())
				var date = new Date(suDate);

				if (!isNaN(Date.parse(date))){
					strYear = date.getFullYear();
					strMonth = date.getMonth() +1;

					if (!monthPrice[strYear]){
						yearArry.push(strYear);
						monthPrice[strYear] = [0,0,0,0,0,0,0,0,0,0,0,0,0];
					}
					monthPrice[strYear][strMonth] = monthPrice[strYear][strMonth] + suPrice
				}
			});
		});
		arrData.push(["구조설계", parseInt(price1)]);
		arrData.push(["안전진단 및 검토", parseInt(price2)]);
		arrData.push(["안전진단", parseInt(price3)]);
		arrData.push(["성능평가 및 검증", parseInt(price4)]);

		arrData1.push(["구조설계", parseInt(sprice1)]);
		arrData1.push(["안전진단 및 검토", parseInt(price2)]);
		arrData1.push(["안전진단", parseInt(sprice3)]);
		arrData1.push(["성능평가 및 검증", parseInt(sprice4)]);

		var data = google.visualization.arrayToDataTable(arrData);
		var options = {
			//chartArea:{left:10,top:40, width:'100%'},
			chartArea:{left:15,top:0,width:'95%',height:'100%',backgroundColor:"#000000"},
			//title: '백분위 비교_견적금액',
			is3D: true,
			//colors: ['#e0440e', '#e6693e', '#ec8f6e', '#f3b49f', '#f6c7b6'],
			legend: { position: 'labeled',  alignment:"end",},
			height:270,
			//enableInteractivity:1,
			//reverseCategories:false,
		};
		var chart = new google.visualization.PieChart(document.getElementById('piechart'));
		chart.draw(data, options);

		var data = google.visualization.arrayToDataTable(arrData1);
		var options = {
			//chartArea:{left:10,top:40, width:'100%'},
			chartArea:{left:15,top:0,width:'95%',height:'100%',backgroundColor:"#000000"},
			//title: '백분위 비교_견적금액',
			is3D: true,
			//colors: ['#e0440e', '#e6693e', '#ec8f6e', '#f3b49f', '#f6c7b6'],
			legend: { position: 'labeled',  alignment:"end",},
			height:270,
			//enableInteractivity:1,
			//reverseCategories:false,
		};
		var chart = new google.visualization.PieChart(document.getElementById('chart2'));
		chart.draw(data, options);


		/* #### 년도별 월별 수금현황 ############*/
		var monthChartOption = {
			chartArea:{left:100,top:10, width:'90%'},
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
			,height:410
		};

		yearArry.sort((a, b) => a - b)

		$("#monthChartArea").html("");
		yearArry.forEach( function(value){
			var chartID = "monthChart_"+value;
			var arrData2 = [];
			arrData2.push(['Date', '수금액', { role: 'style' }]);

			var sum=0;
			for(let i = 1; i < monthPrice[value].length; i++){
				arrData2.push( [i+"월", parseInt(monthPrice[value][i]), 'color: #00b0bf'] );

				sum += parseInt(monthPrice[value][i]);
			}

			if (sum>0){
				$("#monthChartArea").append("<div class=\"chart3\"><div class=\"tit\">"+value+"년 월별 수금현황</div><div id=\""+chartID+"\" class=\"chart\"></div></div>")

				var data = google.visualization.arrayToDataTable(arrData2);
				var chart = new google.visualization.ComboChart(document.getElementById(chartID));
				chart.draw(data, monthChartOption);
			}
		});
		/* #### 년도별 월별 수금현황 ############*/
	}
});

function searchGo(){
	var f=document.searchFrm;
	f.submit();
}
</script>
</head>
<body>
<div id="wrap">
	<!--#include virtual = backoffice/common/header.asp-->

	<div id="container">
		<!--#include virtual = backoffice/common/subMenu.asp-->
		<div class="contents" style="padding-bottom:0; width:98%; min-width:1280px;">

			<div class="location">
				<h2 class="top_left"><%=GB_SubMenuName%></h2>
				<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
			</div>

			<form name='searchFrm' method='get' action='' onsubmit="searchGo();return false;">
			<table class="tbl_row">
				<colgroup>
					<col style="width: 8%" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="col">기간검색</th>
						<td>
							<div class="term_srch">
								<!-- <select name="serdateDiv">
									<option value="0">수금일</option>
									<option value="1" <%=selCheck(serdateDiv, 1)%>>년/월</option>
								</select> -->
								<div class="date_wrap">
									<input type="text" name="serdate1" value="<%=serdate1%>" class="datepicker1" maxlength='10' />
									~
									<input type="text" name="serdate2" value="<%=serdate2%>" class="datepicker2" maxlength='10' />
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="searchbox">
				<input type="text" name="searchstr" value="<%=ReplaceTextField(oSearchStr)%>" placeholder="발주처 검색" />
				<a href="javascript:searchGo()" class="btn_default btn_default100">검색</a>
				<a href="?" class="btn_default btn_default100">초기화</a>
				<a id="download-xlsx" class="btn_default btn_default100 bc_green">엑셀다운로드</a>
			</div>
			</form>

			<div style='clear:both; padding-bottom:100px'>
				<div id="dataTable"></div>
				<div class="btminfo">
					<p class="won">프로젝트수 : <span id="tProjectCnt">0</span> / 결정금액 : <span id="tEstPrice">0</span> / 수금금액 : <span id="tSuKumPrice">0</span></p>
				</div>
			</div>

<style>
.chartArea{padding-bottom:80px; display:inline-block; width:100%; display:flex; flex-direction: row; flex-wrap: wrap; justify-content: center;}
.chartArea>div{height: 300px; width:600px; }
#monthChartArea{width:1200px; margin-top:30px; height:auto;}
.chartArea .chart3{width:1200px; margin-top:30px; height:400px; overflow:hidden;}
.chartArea .tit{color:#bf0000; font-size:20px; text-align:center; margin-bottom:10px;}
</style>
<div class="chartArea" style="">
	<div>
		<div class="tit">백분위 비교_견적금액</div>
		<div id="piechart" class="chart"></div>
	</div>
	<div>
		<div class="tit">백분위 비교_수금금액</div>
		<div id="chart2" class="chart"></div>
	</div>

	<div id="monthChartArea" ></div>
</div>


		</div>
	</div>
</div>

<style>
.onlyPrice{width:100px !important; text-align:right;}
.datepickerAuto{width:100px !important; text-align:center;}
.tbl_colMain th{background-color: #666 !important; color: #fff; font-weight:400 !important}
.calArea{clear:both; width:100%; float:left; position:relative;}
.calArea .header{position: relative;height: 50px; line-height: 50px;}
.calArea .header .info-calendar{font-size:24px; font-weight:bold;  font-family:Tahoma, Verdana, Arial; color:#7ebb72; margin: 0 auto; text-align: center;}
.done {position:fixed; bottom: 20px; left: 20px; z-index: 10000; background:#000; color:#fff; font-size: 20px; padding:10px 20px;}
.lastSaveTd{background-color:#ffcccc3b}
.tbl_col select{width:100%;}

.serObj.active{background-color: #ffe3e3}
.btminfo{margin-top:10px; display:flex; justify-content: flex-end; }
.btminfo .won{font-size:16px;}
.btminfo span{font-size:20px; font-weight:600; color:#ff2323; letter-spacing:-2px;}
#tEstPrice{color:#257cff}
#tProjectCnt{color:#3dd100}

.tabulator{background-color:#fff; max-height:600px;} /* max-height:600px;*/
.tabulator .tabulator-header .tabulator-col.tabulator-sortable .tabulator-col-title{padding-right:0 !important;}
.tabulator{font-size:12px;}
/*
.tabulator .tabulator-header .tabulator-col .tabulator-col-content .tabulator-col-sorter{display:none;}
.tabulator .tabulator-header .tabulator-col.tabulator-sortable[aria-sort=descending].tabulator-col-sorter-element:hover{background-color:#f08a00; color:#fff}
.tabulator .tabulator-header .tabulator-col.tabulator-sortable[aria-sort=descending]{background-color:#f08a00; color:#fff}
.tabulator .tabulator-header .tabulator-col.tabulator-sortable[aria-sort=ascending].tabulator-col-sorter-element:hover{background-color:#3394ff; color:#fff}
.tabulator .tabulator-header .tabulator-col.tabulator-sortable[aria-sort=ascending]{background-color:#3394ff; color:#fff}
*/
.tabulator .lineBold{border-right:2px solid #636363 !important;}
.tabulator .lineNone{border-right:0px solid #636363 !important;}
.tabulator-col.dayOff{background-color:#d0d0d0 !important;}
.tabulator .dayOff{background-color:#d0d0d0; border-bottom:1px solid #bdbdbd}
.pmNm{}
</style>
<!--#include virtual = backoffice/common/bottom.asp-->