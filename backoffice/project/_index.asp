<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "intra" : subMenuCode = "intra01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec,Page,PageSize,Record_Cnt,TotalPage,Count

serYear = uf_getRequest(Request("serYear"),"int","",Year(Date))

Sql = "SELECT id, pMonth, pNo, pDiv, pNm, pOrder, pFloor, pArea, estAmount, setAmount, outAmount, outCompany, coldate1, coldate2, coldate3, coldate4, coldate5, colamount1, colamount2, colamount3, colamount4, colamount5, isReg FROM businessData WHERE year="&serYear&" ORDER BY id ASC"
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
			Response.Write "},"&Vbcrlf

			NextID = CLng(id) + 1
		Next
	End IF
End Function
%>
<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="/_lib/js/jquery-dynamicNumber.js"></script>
<script type="text/javascript" src="/_lib/js/numberAnimate.js"></script>
<script type="text/javascript" src="/_lib/js/charts_loader.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var tabledata = [
		<%=Pt_List%>
	 ];
	let year = <%=serYear%>;
	let nextId = <%=NextID%>;

	var rowMenu = [
		{
			label:"<i class='fas fa-user'></i> 행 추가하기",
			action:function(e, row){
				table.addRow({ id: nextId++ });
			}
		},{
			label:"<i class='fas fa-user'></i> 행 삭제하기",
			action:function(e, row){
				row.delete();
			}
		}
	]

	var table = new Tabulator("#example-table", {
		//height:"60%", // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
		history:true,
		data:tabledata, //assign data to table
		layout:"fitColumns", //fit columns to width of table (optional)
		columnHeaderVertAlign:"middle",
		persistence:true,
		//persistenceMode:"cookie",
		//enable range selection
		selectableRange:1,
		//selectableRangeColumns:true,
		selectableRangeClearCells:true,
		editTriggerEvent:"dblclick",
		//selectableRows:true,
		rowContextMenu: rowMenu,
		columnDefaults:{
			headerSort:false,
			hozAlign:"center",
			headerHozAlign:"center",
			editor:"input",
			resizable:"header",
			width:100,
		},

		columns:[
			{title:"월", field:"pMonth", width:60, cssClass:"pMonth", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }},
			{title:"No", field:"pNo", width:60, editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }},
			{title:"구분", field:"pDiv", width:70, cssClass:"pDiv", editor:"list", editorParams:{values:{"구조설계 ":"구조설계 ", "안전진단 및 검토":"안전진단 및 검토", "안전진단":"안전진단", "성능평가 및 검증":"성능평가 및 검증"}}},
			{title:"프로젝트명", field:"pNm", width:150, cssClass:"pmNm"},
			{title:"발주처", width:100, field:"pOrder"},
			{
				title:"규모",
				headerHozAlign:"center",
				columns:[
					{title:"층수<br>(지상/지하)", field:"pFloor", hozAlign:"right", width:50},
					{title:"면적<br>(㎡)", field:"pArea", width:50},
				],
			},
			{title:"견적금액", field:"estAmount", width:90, cssClass:"estAmount", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
			{title:"결정금액", field:"setAmount", width:90, cssClass:"setAmount", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
			{title:"외주비용", field:"outAmount", width:90, cssClass:"outAmount", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
			{title:"외주처", field:"outCompany", width:100},

			{
				title:"수금일 및 수금액",
				headerHozAlign:"center",
				columns:[
					{
						title:"1차",
						columns:[
							{title:"수금일", field:"coldate1", cssClass:"coldate", width:80, editor:"date", formatter:"datetime", formatterParams:{
								inputFormat:"yyyy-MM-dd",
								outputFormat:"yyyy.MM.dd",
								invalidPlaceholder:"",
							}},
							{title:"수금액", field:"colamount1", width:90, cssClass:"colamount", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
					{
						title:"2차",
						columns:[
							{title:"수금일", field:"coldate2", cssClass:"coldate", width:80, editor:"date", formatter:"datetime", formatterParams:{
								inputFormat:"yyyy-MM-dd",
								outputFormat:"yyyy.MM.dd",
								invalidPlaceholder:"",
							}},
							{title:"수금액", field:"colamount2", width:90, cssClass:"colamount", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
					{
						title:"3차",
						columns:[
							{title:"수금일", field:"coldate3", cssClass:"coldate", width:80, editor:"date", formatter:"datetime", formatterParams:{
								inputFormat:"yyyy-MM-dd",
								outputFormat:"yyyy.MM.dd",
								invalidPlaceholder:"",
							}},
							{title:"수금액", field:"colamount3", width:90, cssClass:"colamount", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
					{
						title:"4차",
						columns:[
							{title:"수금일", field:"coldate4", cssClass:"coldate", width:80, editor:"date", formatter:"datetime", formatterParams:{
								inputFormat:"yyyy-MM-dd",
								outputFormat:"yyyy.MM.dd",
								invalidPlaceholder:"",
							}},
							{title:"수금액", field:"colamount4", width:90, cssClass:"colamount", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
					{
						title:"5차",
						columns:[
							{title:"수금일", field:"coldate5", cssClass:"coldate", width:80, editor:"date", formatter:"datetime", formatterParams:{
								inputFormat:"yyyy-MM-dd",
								outputFormat:"yyyy.MM.dd",
								invalidPlaceholder:"",
							}},
							{title:"수금액", field:"colamount5", width:90, cssClass:"colamount", editor:"number", editorParams:{ selectContents:true, verticalNavigation:"table" }, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
						],
					},
				],
			},

			{title:"수금금액", field:"colAmount", width:90, cssClass:"tColAmount", editor:false, formatter:"money", formatterParams:{decimal:".", thousand:",", negativeSign:false, precision:false}},
			{title:"수금율", field:"colRate", width:50, cssClass:"colRate", editor:false,},
			{title:"실적<br>등록", field:"isReg", width:50, editor:true, formatter:"tickCross", resizable:false, cssClass:"lineNone"},
		],
	});

	document.getElementById("add-row").addEventListener("click", function(){
		table.addRow({ id: nextId++ });
	});

	table.on("cellEdited", function(cell){
		console.log("cellEdited 실행")
		var data = cell.getRow().getData();
		var idx = data.id
		var field = cell.getField()
		oldVal = cell.getOldValue();
		newVal = cell.getValue();

		if (field=="colAmount" || field=="colRate"){
			cell.restoreInitialValue();
			return;
		}

		if (oldVal!==newVal){
			var formData = new FormData();
			formData.append('setColumn', field);
			formData.append('year', year);
			formData.append('idx', idx);
			formData.append('setVal', newVal);

			$.ajax({
				type:"post",
				url: "ajax_SetVal.asp",
				data:formData
				,processData: false
				,contentType: false
				,error:function(request,status,error) {
					alert("데이터 처리중 오류가 발생했습니다.");
					layerModalClose();
					cell.restoreOldValue();
				}
			}).done(function(data){
				var msg = data.split("|")
				var retCode = msg[0];
				if (retCode=="OK"){
					//location.reload();
				}else{
					var retMsg = msg[1].replace(/\\n/gi, "\n");
					alert(retMsg)
					cell.restoreOldValue();
				}
			})
		}
		cal();
	});

	table.on("rowAdded", function(row){
		console.log("rowAdded 실행")
		rowData = JSON.stringify(row.getData())
		var id = row.getIndex();

		var formData = new FormData();
		formData.append('procMode', "ADD");
		formData.append('year', year);
		formData.append('data', rowData);

		$.ajax({
			type:"post",
			url: "ajax_SetVal.asp",
			data:formData
			,processData: false
			,contentType: false
			,error:function(request,status,error) {
				alert("데이터 처리중 오류가 발생했습니다.");
				layerModalClose();
				table.deleteRow(id);
			}
		}).done(function(data){
			var msg = data.split("|")
			var retCode = msg[0];

			if (retCode=="OK"){

			}else{
				retMsg = "오류"
				if (msg[1]){
					var retMsg = msg[1].replace(/\\n/gi, "\n");
				}
				alert(retMsg)
				table.deleteRow(id);
			}
		})
	});

	table.on("rowDeleted", function(row){
		console.log("rowDeleted 실행")
		var id = row.getIndex()

		var formData = new FormData();
		formData.append('procMode', "DELETE");
		formData.append('year', year);
		formData.append('id', id);

		$.ajax({
			type:"post",
			url: "ajax_SetVal.asp",
			data:formData
			,processData: false
			,contentType: false
			,error:function(request,status,error) {
				alert("데이터 처리중 오류가 발생했습니다.");
				layerModalClose();
				location.reload();
			}
		}).done(function(data){
			var msg = data.split("|")
			var retCode = msg[0];
			if (retCode=="OK"){
				table.clearHistory();
			}else{
				var retMsg = msg[1].replace(/\\n/gi, "\n");
				alert(retMsg)
				location.reload();
			}
		})
		cal();
	});

	table.on("historyUndo", function(action, component, data){
		console.log("historyUndo 실행")
		console.log(action)
		console.log(component)
		console.log(data)

		if (action=="cellEdit"){
			var idx = component.getRow().getIndex()
			var field = component.getField()
			oldVal = component.getOldValue();
			newVal = component.getValue();

			if (oldVal!==newVal){
				var formData = new FormData();
				formData.append('setColumn', field);
				formData.append('year', year);
				formData.append('idx', idx);
				formData.append('setVal', newVal);

				$.ajax({
					type:"post",
					url: "ajax_SetVal.asp",
					data:formData
					,processData: false
					,contentType: false
					,error:function(request,status,error) {
						alert("데이터 처리중 오류가 발생했습니다.");
						layerModalClose();
						component.restoreOldValue();
					}
				}).done(function(data){
					var msg = data.split("|")
					var retCode = msg[0];
					if (retCode=="OK"){
						//location.reload();
					}else{
						var retMsg = msg[1].replace(/\\n/gi, "\n");
						alert(retMsg)
						component.restoreOldValue();
					}
				})
			}
		}else if (action=="rowAdd"){
		}else if (action=="rowDelete"){
		}
		cal()
	});

	table.on("historyRedo", function(action, component, data){
		console.log("historyRedo 실행")

		if (action=="cellEdit"){
			var idx = component.getRow().getIndex()
			var field = component.getField()
			oldVal = component.getOldValue();
			newVal = component.getValue();

			if (oldVal!==newVal){
				var formData = new FormData();
				formData.append('setColumn', field);
				formData.append('year', year);
				formData.append('idx', idx);
				formData.append('setVal', newVal);

				$.ajax({
					type:"post",
					url: "ajax_SetVal.asp",
					data:formData
					,processData: false
					,contentType: false
					,error:function(request,status,error) {
						alert("데이터 처리중 오류가 발생했습니다.");
						layerModalClose();
						component.restoreOldValue();
					}
				}).done(function(data){
					var msg = data.split("|")
					var retCode = msg[0];
					if (retCode=="OK"){
						//location.reload();
					}else{
						var retMsg = msg[1].replace(/\\n/gi, "\n");
						alert(retMsg)
						component.restoreOldValue();
					}
				})
			}
		}else if (action=="rowAdd"){
		}else if (action=="rowDelete"){
		}
		cal()
	});

	table.on("tableBuilt", function(){
		cal()
	});

	function calendarGo(value,Year){
		strYear = Year+value;

		location.href="?serYear="+strYear;
	}

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

//		var monthPrice = [0,0,0,0,0,0,0,0,0,0,0,0,0]
		var yearArry = [];
		var monthPrice = [];
		
		var price1=0, price2=0, price3=0, price4=0
		var sprice1=0, sprice2=0, sprice3=0, sprice4=0

		$(".tabulator .tabulator-row").each(function(){
			var pDiv = $(this).find(".pDiv").text();
			var pMonth = getNumber($(this).find(".pMonth").text());

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
		yearArry.forEach( function(value){
			var chartID = "monthChart_"+value;
			var arrData2 = [];
			arrData2.push(['Date', '수금액', { role: 'style' }]);

			for(let i = 1; i < monthPrice[value].length; i++){
				arrData2.push( [i+"월", parseInt(monthPrice[value][i]), 'color: #00b0bf'] );
			}

			$("#monthChartArea").append("<div class=\"chart3\"><div class=\"tit\">"+value+"년 월별 수금현황</div><div id=\""+chartID+"\" class=\"chart\"></div></div>")

			var data = google.visualization.arrayToDataTable(arrData2);
			var chart = new google.visualization.ComboChart(document.getElementById(chartID));
			chart.draw(data, monthChartOption);
		});
	}
});
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

			<link href="/_lib/tabulator-master/dist/css/tabulator.min.css" rel="stylesheet">
			<script type="text/javascript" src="/_lib/tabulator-master/dist/js/tabulator.min.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/luxon@2.4.0/build/global/luxon.min.js"></script>

			<div class="calArea">
				<div class="header">
					<div class="info-calendar">
						<a class="" href="javascript:calendarGo(-1,<%=serYear%>)"> < </a>
						&nbsp;&nbsp;<%=serYear%>년&nbsp;&nbsp;
						<a class="" href="javascript:calendarGo(1,<%=serYear%>)"> > </a>
					</div>
				</div>

				<div style="position:absolute; right:0; bottom:10px;">
					<input type="button" value="추가하기" class="btn_gray bc_green" style="font-size:14px; width:100px; line-height:20px;" id="add-row">
				</div>
			</div>

			<div style='clear:both; padding-bottom:100px'>
				<div id="example-table"></div>
				<div class="btminfo">
					<p>* 모든 프로젝트 용역비는 부가세 미포함 금액으로 작성</p>
					<p class="won">프로젝트수 : <span id="tProjectCnt">0</span> / 결정금액 : <span id="tEstPrice">0</span> / 수금금액 : <span id="tSuKumPrice">0</span></p>
				</div>
			</div>

<style>
.chartArea{padding-bottom:80px; display:inline-block; width:100%; display:flex; flex-direction: row; flex-wrap: wrap; justify-content: center;}
.chartArea>div{height: 300px; width:600px; }
#monthChartArea{width:1200px; margin-top:30px;}
.chartArea .chart3{width:1200px; margin-top:30px; height:400px; overflow:hidden;}
.chartArea .tit{color:#bf0000; font-size:20px; text-align:center; margin-bottom:10px;}
</style>
<div class="chartArea" style="">

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
.btminfo{margin-top:10px; display:flex; justify-content: space-between; }
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