<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->

	<link rel="stylesheet" type="text/css" href="/build/fullcalendar/main.css" />
	<style>
		#calendar{font-size:16px; border-bottom:1px solid var(--point);}
		.fc *{font-size:1.6rem; line-height:1;}
		.fc .fc-toolbar-chunk{}

		.fc-theme-standard .fc-scrollgrid{border-width:0px !important;}
		.fc-theme-standard td,
		.fc-theme-standard th{border-width:0 !important;}
		.fc-theme-standard th.fc-col-header-cell{background-color:var(--point); position: relative;}
		.fc-theme-standard th.fc-col-header-cell+th.fc-col-header-cell:before{content: ""; width: 1px; height: 2rem; background-color: #87b59f; display: inline-block; position:absolute; left: -1px; top:50%; transform: translateY(-50%);}
		.fc-theme-standard td{border-width:1px !important;}

		.fc .fc-toolbar{justify-content: center; gap:3rem;}
		.fc-header-toolbar{position: relative;}
		/*
		.fc-header-toolbar .fc-toolbar-chunk:nth-child(3){position: absolute; right:0; top:0.4rem;}
		*/
		/*
		.fc thead[role="rowgroup"],
		.fc-col-header-cell{display:none !important;}
		*/
		.fc-col-header{border-bottom:1px solid var(--point);}
		.fc-col-header-cell .fc-col-header-cell-cushion{padding:2.2rem 4px; font-weight: normal; font-size:1.8rem; line-height:1; color: #fff;}
		.fc-col-header-cell.fc-day-sun .fc-col-header-cell-cushion{color: #e6f400;}

		.fc .fc-button{width:3.4rem; height:3.4rem; padding:0; background-color: #fff; border:1px solid #cdcdcd; font-size: 1em; color: #666; border-radius:99px;}
		.fc .fc-button .fc-icon-chevron-left{letter-spacing: 1px;}
		.fc .fc-button.fc-today-button{padding: 0.35em 1.2em;}
		.fc .fc-button .fc-icon{width: 1.15em; height: 1.15em; font-size: 1.2em;}

		.fc .fc-day-sun .fc-daygrid-day-number{color: #ff5a71;}
		.fc .fc-day-sat .fc-daygrid-day-number{color: #071fb4;}

		.fc .fc-day-today{background-color:#f9f6f5;}
		.fc .fc-day-today .fc-daygrid-day-number{border:none; font-weight: 500; color: #222 !important;}

		.fc-daygrid-day-frame{display: flex; flex-wrap: wrap; flex-direction: row; align-content: flex-start; justify-content: center;}
		.fc-daygrid-day-frame:before,
		.fc-daygrid-day-frame:after{display:none;}
		.fc-daygrid-day-frame>*{width:100%;}
		.fc-daygrid-day-frame .fc-daygrid-day-top{margin-top:0; justify-content: flex-end;}
		.fc-daygrid-day-frame .fc-daygrid-day-top .fc-daygrid-day-number{width:3.9rem; height:3.9rem; color: #666; font-weight: 700; font-size:2rem; line-height:1; color: #1b1b1b; text-align: center; border-radius:999px; display: flex; align-items: center; justify-content: center;}

		.fc .fc-daygrid-day-events{height:8.5rem; position: relative;}
		.fc .fc-h-event .fc-event-main{color: #666; text-align: center;}

		.fc .fc-daygrid-day-bottom{text-align: center;}
		.fc .fc-daygrid-more-link.fc-more-link{font-weight: 400; font-size:1.2rem; color: var(--point) !important;}

		.fc-h-event .fc-event-main-frame{max-width: -webkit-fill-available; height:3rem; font-size:1.5rem; display: inline-flex; align-items: center; justify-content: center;}
		.fc .fc-h-event .fc-event-main .fc-event-title{ overflow: hidden; text-overflow: ellipsis; white-space: nowrap;}

		.fc-daygrid-day-frame.event-on .fc-daygrid-day-top .fc-daygrid-day-number{/*background-color: var(--point); color: #fff !important;*/}/* 이벤트있는 날짜*/

		.fc .fc-toolbar-title{font-weight: 400; font-size:3rem; color: #1b1b1b;}

		.fc .fc-button-primary:hover{background-color: var(--point); border-color:var(--point);}

		.fc-direction-ltr .fc-daygrid-event.fc-event-end,
		.fc-direction-rtl .fc-daygrid-event.fc-event-start{margin-left:0.9rem;}
		.fc-direction-ltr .fc-daygrid-event.fc-event-start,
		.fc-direction-rtl .fc-daygrid-event.fc-event-end{margin-right:0.9rem;}

		.fc-daygrid-event{border-radius:999px;}

		.fc-daygrid-event-harness,
		.fc-daygrid-event-harness>a{cursor: default !important;}


		/* 툴팁 */
			.fc .fc-popover{border-radius:1rem;}
			.fc-theme-standard .fc-popover-header{height:5.4rem; padding:0 2rem; background-color: #2a302d; font-weight: 700; font-size:1.6rem; line-height:1; color: #fff; display: flex; align-items: center; justify-content: space-between; border-radius:1rem 1rem 0 0;}
			.fc-theme-standard .fc-more-popover-misc{display:none !important;}
			.fc-theme-standard .fc-popover-body .fc-event-main{text-align: left; color: #666 !important; position: relative;}
			.fc-theme-standard .fc-popover-body .fc-event-main:before{content: "ㆍ"; position:absolute; left: -0.5rem; top:0.6rem;}
			.fc-theme-standard .fc-popover-body .fc-event-main .fc-event-title{}

		/*
			@media only screen and (max-width : 1280px){
				.fc-daygrid-day-frame .fc-daygrid-day-top{margin-top:-2rem;}
				.fc-daygrid-day-frame .fc-daygrid-day-top .fc-daygrid-day-number{width:4.6rem; height:2.6rem; font-size:1.4rem; line-height:2.6rem;}
			}
			@media only screen and (max-width : 1024px){
				.fc .fc-toolbar{justify-content: flex-start;}
			}
			@media only screen and (max-width : 840px){
				.fc *{font-size:1.6rem;}
				.fc .fc-button{}
				.fc .fc-button.fc-today-button{}
				.fc .fc-button .fc-icon{}
				.fc .fc-daygrid-day-number{width:3rem; height:3rem;}
				.fc .fc-h-event .fc-event-main .fc-event-title{font-size:1.6rem;}
			}

			.tooltipArea{}
			.tooltipTit{font-size:1.4rem;}
			.tooltipCon{padding-top:5px; font-size:1.2rem;}
		*/
	</style>

	<script type="text/javascript" src="/build/fullcalendar/main.js"></script>
	<script type="text/javascript" src="/build/fullcalendar/locales-all.js"></script>
	<script src="/build/fullcalendar/popper.js"></script>
	<script src="/build/fullcalendar/tippy.js"></script>

	<script type="text/javascript">
		var colorBg = ["#ffcea2", "transparent"];

		$(window).load(function () {	// $(".testText").text("off2");
			var initialLocaleCode = 'ko';
			var calendarEl = document.getElementById('calendar');

			var calendar = new FullCalendar.Calendar(calendarEl, {
				headerToolbar: {
					left: 'prev',//prev,next today prevYear,prev,next,nextYear
					center: 'title', //title
					end: 'next',
					//right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
				},
				titleFormat: function(date) {
					return `${date.date.year}년 ${date.date.month + 1}월`;
				},
				buttonText: {
					today: '오늘'
				},
				//initialDate: '2022-03-24',
				locale: initialLocaleCode,
				height: '97rem',
				expandRows: true,
				buttonIcons: true, // show the prev/next text
				weekNumbers: false,
				navLinks: false, // can click day/week names to navigate views
				editable: false, // Drag-n-Drop Events
				dayMaxEvents: 2, // allow "more" link when too many events
				//Boolean: false,
				events: [
					{
						id : "0",
						backgroundColor : "#00a8bf",
						textColor : "#fff",
						borderColor : "transparent",
						title: "2023 육우경진대회",
						start: "2023-12-17",
						end: "2023-12-20",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>안녕하세요 오오오오</div><div class='tooltipCon'>안녕하세요 오오오오안녕하세요안녕하세요안녕하세요안녕하세요</div></div>",
						//className: ["box-event"],
						//url: "안녕하세요 오오오오안녕하세요안녕하세요안녕하세요안녕하세요",
					},
					{
						id : "1",
						backgroundColor : "red",
						textColor : "#fff",
						borderColor : "transparent",
						title: "기타 행사일정 하나",
						start: "2023-12-05",
						end: "2023-12-05",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>fdsdsfdsfdsf</div><div class='tooltipCon'>dsfdsf</div></div>",
						//className: ["box-event"],
						//url: "dsfdsf",
					},
					{
						id : "2",
						backgroundColor : "transparent",
						borderColor : "transparent",
						title: "기타 행사일정 둘",
						start: "2023-12-03",
						end: "2023-12-03",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>asfdsfdsf</div><div class='tooltipCon'>sdfdsfsdfdsfdsf</div></div>",
						//className: ["box-event"],
						//url: "sdfdsfsdfdsfdsf",
					},
					{
						id : "3",
						backgroundColor : "transparent",
						borderColor : "transparent",
						title: "기타 행사일정 셋",
						start: "2023-12-28",
						end: "2023-12-28",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>검진 예약</div><div class='tooltipCon'>안녕하세요정기 검진 예약 안내 드립니다.정기 검진 예약정기 검진 예약정기 검진 예약정기 검진 예약정기 검진 예약정기 검진 예약감사합니다</div></div>",
						//className: ["box-event"],
						//url: "안녕하세요정기 검진 예약 안내 드립니다.정기 검진 예약정기 검진 예약정기 검진 예약정기 검진 예약정기 검진 예약정기 검진 예약감사합니다",
					},
					{
						id : "4",
						backgroundColor : "transparent",
						borderColor : "transparent",
						title: "기타 행사일정 넷",
						start: "2023-12-28",
						end: "2023-12-28",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>일정2</div><div class='tooltipCon'>일정2일정2일정2일정2일정2일정2일정2</div></div>",
						//className: ["box-event"],
						//url: "일정2일정2일정2일정2일정2일정2일정2",
					},
					{
						id : "5",
						backgroundColor : "transparent",
						textColor : "#ff0000",
						borderColor : "transparent",
						title: "크리스마스",
						start: "2023-12-25",
						end: "2023-12-25",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>크리스마스</div><div class='tooltipCon'>크리스마스</div></div>",
						//className: ["box-event"],
						//url: "크리스마스",
					},
					{
						id : "6",
						backgroundColor : "transparent",
						textColor : "#ff0000",
						borderColor : "transparent",
						title: "크리스마스",
						start: "2023-12-25",
						end: "2023-12-25",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>크리스마스</div><div class='tooltipCon'>크리스마스</div></div>",
						//className: ["box-event"],
						//url: "크리스마스",
					},
					{
						id : "7",
						backgroundColor : "transparent",
						textColor : "#ff0000",
						borderColor : "transparent",
						title: "크리스마스",
						start: "2023-12-25",
						end: "2023-12-25",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>크리스마스</div><div class='tooltipCon'>크리스마스</div></div>",
						//className: ["box-event"],
						//url: "크리스마스",
					},
					{
						id : "8",
						backgroundColor : "transparent",
						textColor : "#ff0000",
						borderColor : "transparent",
						title: "크리스마스",
						start: "2023-12-25",
						end: "2023-12-25",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>크리스마스</div><div class='tooltipCon'>크리스마스</div></div>",
						//className: ["box-event"],
						//url: "크리스마스",
					},
					{
						id : "9",
						backgroundColor : "transparent",
						borderColor : "transparent",
						title: "기타 행사일정 다섯 기타 행사일정 다섯 기타 행사일정 다섯 기타 행사일정 다섯",
						start: "2023-12-28",
						end: "2023-12-28",
						//description: "<div class='tooltipArea'><div class='tooltipTit'>일정2</div><div class='tooltipCon'>일정2일정2일정2일정2일정2일정2일정2</div></div>",
						//className: ["box-event"],
						//url: "일정2일정2일정2일정2일정2일정2일정2",
					},
				],

				eventClick: function(info) {
					info.jsEvent.preventDefault(); // don't let the browser navigate

					//$("#layer-schdule .title>span").html(info.event.startStr);
					//$("#layer-schdule .layer-schdule-text>dt").html(info.event.title);
					//$("#layer-schdule .layer-schdule-text>dd").html(info.event.url);
					//$("#layer-schdule .layer-schdule-text>dd").html($(".calender_list tbody>tr:eq("+info.event.id+") .subject").html());

					//popFancy('#layer-schdule');
				},
				dayCellContent: function (info) {
					var number = document.createElement("a");
					number.classList.add("fc-daygrid-day-number");
					number.innerHTML = info.dayNumberText.replace("일", '').replace("日","");
					if (info.view.type === "dayGridMonth") {
						return {
							html: number.outerHTML
						};
					}
					return {
					  domNodes: []
					};
				},
			});
			calendar.render();

			$("#calendar .box-event").each(function(index){
				$(this).closest(".fc-daygrid-day-frame").addClass("event-on");
			});
		});
	</script>
</head>

<body data-pgCode="0303">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<div class="cataracts-area">
			<div id="calendar"></div>
		</div>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>

<div id="layer-schdule" class="layer-base"><div class="layer-in">
	<div class="title"><span></span>일정</div>
	<dl class="layer-schdule-text">
		<dt></dt>
		<dd></dd>
	</dl>
</div></div>

<script type="text/javascript">
	$(function () {
	});
</script>
<script type="text/javascript">
	$(function(){
	});
</script>
</body>
</html>