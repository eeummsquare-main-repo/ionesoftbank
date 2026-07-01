$(window).load(function(){
	$(".relativeTxtBox").each(function(){
		$(this).css('height', 'auto' );
		$(this).height( this.scrollHeight - 10 );
	});
	$(document).on( 'keyup', '.relativeTxtBox', function (e){
		$(this).css('height', 'auto' );
		$(this).height( this.scrollHeight - 10 );
	});

	$("body").on("change", ".file input[type='file']", function(e){
		var idx = $(".file input[type='file']").index($(this));

		var tit = $(this).val();
		$(".file .thumb").eq(idx).find(".over").detach();
		$(".file .thumb").eq(idx).attr("style","").removeClass("text");
		if ($(this).val()) {
			var input = $(".file input[type='file']").get(idx).files[0];
			var reader = new FileReader();
			$(reader).on('load', function(e) {
				$(".file .thumb").eq(idx).attr("title", tit).addClass("text").html(tit).append("<a class='btnFileEmpty'>X</a>");
			});
			reader.readAsDataURL(input);
		}else{
			var input = $(".file input[type='file']").get(idx).files[0];
			var reader = new FileReader();
			$(".file .thumb").eq(idx).attr("title", "").removeClass("text").html("");
		}
	});

	$(document).on("click",".btnFileEmpty",function(){
		$(this).closest(".file").find("input[type=file]").val("").change();
	});

	$(document).on("click",".filePlusTit",function(){
		var maxCnt = $(this).attr("maxCnt");
		var fFieldNm = $(this).attr("fNm");
		var fDFieldNm = $(this).attr("fDNm");

		var fileAddTag = "";
		fileAddTag = fileAddTag + "<div class=\"file\">"
		fileAddTag = fileAddTag + "	<input type=\"text\" name=\"fileTit\" value=\"\" placeholder=\"=타이틀 입력=\" class=\"fileTit\">"
		fileAddTag = fileAddTag + "	<span class=\"file_wrap\">"
		fileAddTag = fileAddTag + "		<span class=\"btnFile\">파일첨부<input type=\"file\" name=\""+fFieldNm+"\" title=\"파일첨부\"/><input type='hidden' name='"+fDFieldNm+"' value='1'><input type='hidden' name='db"+fFieldNm+"' value=''></span>"
		fileAddTag = fileAddTag + "	</span>"
		fileAddTag = fileAddTag + "	<a class=\"thumb\"></a>"
		fileAddTag = fileAddTag + "</div>"

		if (maxCnt){
			var fileAllowCnt = maxCnt ;
		}else{
			var fileAllowCnt = 5 ;
		}

		if ($(this).closest(".filesArea").find(".file").length>=fileAllowCnt){
			alert("더이상 추가할수 없습니다.");
		}else{
			$(this).closest(".filesArea").append(fileAddTag);
		}
	});

	$(document).on("click",".filePlus",function(){
		var maxCnt = $(this).attr("maxCnt");
		var fFieldNm = $(this).attr("fNm");
		var fDFieldNm = $(this).attr("fDNm");

		var fileAddTag = "";
		fileAddTag = fileAddTag + "<div class=\"file\">"
		fileAddTag = fileAddTag + "	<span class=\"file_wrap\">"
		fileAddTag = fileAddTag + "		<span class=\"btnFile\">파일첨부<input type=\"file\" name=\""+fFieldNm+"\" title=\"파일첨부\"/><input type='hidden' name='"+fDFieldNm+"' value='1'><input type='hidden' name='db"+fFieldNm+"' value=''></span>"
		fileAddTag = fileAddTag + "	</span>"
		fileAddTag = fileAddTag + "	<a class=\"thumb\"></a>"
		fileAddTag = fileAddTag + "</div>"

		if (maxCnt){
			var fileAllowCnt = maxCnt ;
		}else{
			var fileAllowCnt = 5 ;
		}

		if ($(this).closest(".filesArea").find(".file").length>=fileAllowCnt){
			alert("더이상 추가할수 없습니다.");
		}else{
			$(this).closest(".filesArea").append(fileAddTag);
		}
	});


	$(document).on("click",".bbsFilePlus",function(){
		var fileAddTag = "";
		fileAddTag = fileAddTag + "<div class=\"file\">"
		fileAddTag = fileAddTag + "	<span class=\"file_wrap\">"
		fileAddTag = fileAddTag + "		<span class=\"btnFile\">파일첨부<input type=\"file\" name=\"files\" title=\"파일첨부\"/></span>"
		fileAddTag = fileAddTag + "	</span>"
		fileAddTag = fileAddTag + "	<a class=\"thumb\"></a><input type='hidden' name='filedel_idx' value='0'><input type='hidden' name='filesort' value='0'>"
		fileAddTag = fileAddTag + "</div>"

		$(this).closest(".filesArea").append(fileAddTag);
	});
});

/* #### 기본검색 엔터키 활성 ########################### */
$(document).on("keydown",".bSearchInput",function(e){
	var val = $(this).val();
	if(e.keyCode == 13) searchGo();
});
/* #### 기본검색 엔터키 활성 ########################### */

function testResult(idx){
	var options = 'width=800, height=800, status=no, menubar=no, toolbar=no, resizable=no,location=no';
	window.open("pop_TestResult.asp?idx="+idx,"taking_test",options);
}

function popLicenseView(licidx){
	var options = 'width=800, height=800, status=no, menubar=no, toolbar=no, resizable=no,location=no';
	window.open("/_lib/_popLicenseView.asp?licidx="+licidx,"popLicPrint",options);
}

function setDatepickerAD(obj){
	if (obj){
		targetObj = obj.find(".datepicker1, .datepicker2, .datepicker")
	}else{
		targetObj = $( ".datepicker1, .datepicker2, .datepicker" )
	}

	// datepicker 
	targetObj.datepicker({
		inline: true, 
		dateFormat: "yy-mm-dd",    /* 날짜 포맷 */ 
		prevText: 'prev', 
		nextText: 'next', 
		showButtonPanel: true,    /* 버튼 패널 사용 */ 
		changeMonth: true,        /* 월 선택박스 사용 */ 
		changeYear: true,        /* 년 선택박스 사용 */ 
		showOtherMonths: true,    /* 이전/다음 달 일수 보이기 */ 
		selectOtherMonths: true,    /* 이전/다음 달 일 선택하기 */ 
		showOn: "button", 
		buttonImage: "/backoffice/images/common/bg_calender.gif",
		buttonImageOnly: true, 
		minDate: '-30y', 
		closeText: '닫기', 
		currentText: '오늘', 
		showMonthAfterYear: true,        /* 년과 달의 위치 바꾸기 */ 
		yearRange: '-15:+10', // Range of years to display in drop-down,
			// either relative to current year (-nn:+nn) or absolute (nnnn:nnnn)
		/* 한글화 */ 
		monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], 
		monthNamesShort : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], 
		dayNames : ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesShort : ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesMin : ['일', '월', '화', '수', '목', '금', '토'],
		showAnim: 'slideDown', 
		/* 날짜 유효성 체크 */ 
		onClose: function( selectedDate ) { 
		  $('#fromDate').datepicker("option","minDate", selectedDate); 
		} 
	 });
	/* datepicker 오늘버튼 클릭시 오늘 날짜 생성 스크립트 */
	$.datepicker._gotoToday = function(id) {
	    var target = $(id);
	    var inst = this._getInst(target[0]);
	    if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
	            inst.selectedDay = inst.currentDay;
	            inst.drawMonth = inst.selectedMonth = inst.currentMonth;
	            inst.drawYear = inst.selectedYear = inst.currentYear;
	    }
	    else {
	            var date = new Date();
	            inst.selectedDay = date.getDate();
	            inst.drawMonth = inst.selectedMonth = date.getMonth();
	            inst.drawYear = inst.selectedYear = date.getFullYear();
	            // the below two lines are new
	            this._setDateDatepicker(target, date);
	            this._selectDate(id, this._getDateDatepicker(target));
	    }
	    this._notifyChange(inst);
	    this._adjustDate(target);
	}
}

$(function() { 
	setDatepickerAD();

	// 제품관리 상세정보 셋팅///////////////////////////////////////
	$(document).on("click",".pdinfoCon .pdinfoGet",function(){
		var index = $(".pdinfoCon .pdinfoGet").index($(this));
		var selVal = $(".pdinfoCon select").eq(index).val();
		var txtObj = $(".pdinfoCon textarea").eq(index);

		if (selVal==""){
			alert("불러올 상세정보를 선택하세요.");
		}else{

			var params = "idx="+selVal;
			$.ajax({type:"POST", url:"productDetailINFoGet.asp",data:params,dataType:"html"
			}).done(function(data){
				CKEDITOR.instances[txtObj.attr("id")].setData(data);
			})
		}
	});

	$(document).on("change",".pdinfoChkbox",function(){
		var index = $(".pdinfoChkbox").index($(this));
		var selVal = $(".pdinfoCon select").eq(index).val();
		$(this).val("");

		if ($(this).prop("checked")){
			if (selVal==""){
				alert("사용할 상세정보를 선택하세요.");
				$(this).attr("checked",false)
			}else{
				$(this).val(selVal)
			}
		}
	});
	
	$(document).on("change",".pdinfoCon select",function(){
		var index = $(".pdinfoCon select").index($(this));
		var selVal = $(this).val();

		$(".pdinfoCon .pdinfoChkbox").eq(index).val(selVal)
	});
	// 제품관리 상세정보 셋팅///////////////////////////////////////

	$(document).on("click",".openZip",function(){
		var obj = $(this);

		new daum.Postcode({
			oncomplete: function(data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var fullAddr = ''; // 최종 주소 변수
				var extraAddr = ''; // 조합형 주소 변수

				// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					fullAddr = data.roadAddress;

				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					fullAddr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 조합한다.
				if(data.userSelectedType === 'R'){
					//법정동명이 있을 경우 추가한다.
					if(data.bname !== ''){
						extraAddr += data.bname;
					}
					// 건물명이 있을 경우 추가한다.
					if(data.buildingName !== ''){
						extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					// 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
					fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				obj.siblings(".addpost").val(data.zonecode)	//5자리 새우편번호 사용
				obj.siblings(".address").val(fullAddr)

				// 커서를 상세주소 필드로 이동한다.
				obj.siblings(".adddetail").focus();
			}
		}).open();
	});

	// tab
	 var tab = {
	 	init: function() {
	 		var $tabWrap = $('div.tab_wrap')
	 			$tabList = $('ul.tab_list'),
	 			$tabListLi = $('ul.tab_list li'),
	 			$tabAnchor = $tabListLi.find('a'),
	 			$tabConWrap =  $('div.tab_con_wrap'),
	 			$tabCon = $('div.tab_con'),
	 			currentClass = 'current';
	 		$tabCon.hide();
	 		$tabWrap.each(function() {
	 			var $tgWrap = $(this);
		 		$tgWrap.find($tabListLi).each(function() {
		 			var tgIndex = $(this).index(),
		 				$tgCon = $tabConWrap.find($tabCon);
		 			$(this).find($tabAnchor).on('click', function(e) {
		 				e.preventDefault();
		 				$(this).addClass(currentClass)
		 					.parent().siblings().children($tabAnchor).removeClass(currentClass);
		 				$tgWrap.find($tgCon).hide().eq(tgIndex).show();
		 				
		 			});
		 		}).first().children($tabAnchor).trigger('click');
	 		});
	 	}
	 }; tab.init();

	// on/off 
	var onoff = {
		init: function() {
			var $onoffWrap = $('span.onoff'),
				$onoffBtn = $onoffWrap.find('button');
			$onoffWrap.each(function() {
				var $tgThis = $(this);
				$tgThis.find($onoffBtn).on('click', function() {
					if ( $tgThis.hasClass('off') ) {
						$tgThis.removeClass('off');
					} else {
						$tgThis.addClass('off');
					};
				});	
			});
		}
	}; onoff.init();

	// faq
	var faqList = {
		init: function() {
			var $faqWrap = $('.tbl_faq'),
				$faqQ = $faqWrap.find('th'),
				$faqA = $faqWrap.find('tr.answer');
			$faqA.hide();
			$faqQ.each(function() {
				var $this = $(this);
				$this.on('click', function() {
					var $tgA = $(this).parent().next('tr.answer'),
						$tgAH = $tgA.outerHeight();
					$faqA.hide().filter($tgA).show();
				});
			}).first().children($tabAnchor).trigger('click');
		}
	}; faqList.init();

	// Auto Search
	$.widget( "custom.catcomplete", $.ui.autocomplete, {
	_create: function() {
	  this._super();
	  this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
	},
	_renderMenu: function( ul, items ) {
	  var that = this,
		currentCategory = "";
	  $.each( items, function( index, item ) {
		var li;
		if ( item.category != currentCategory ) {
		  ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
		  currentCategory = item.category;
		}
		li = that._renderItemData( ul, item );
		if ( item.category ) {
		  li.attr( "aria-label", item.category + " : " + item.label );
		}
	  });
	}
	});

	// table DnD
	if ( $(".tbl_DnD").size() !== 0 ) $(".tbl_DnD").tableDnD();

	// jsTree
	if ( $('#jstree').size() !== 0 ) $('#jstree').jstree();
	
    // 8 interact with the tree - either way is OK
    $('button').on('click', function () {
		$('#jstree').jstree(true).select_node('child_node_1');
		$('#jstree').jstree('select_node', 'child_node_1');
		$.jstree.reference('#jstree').select_node('child_node_1');
    });
});

function formatInt(str){
	str = str.replace(/[^0-9-.]/gi,"");
	return str;
}
function formatPrice(str){
	str = str.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	return str;
}

function viewKorean(num){
	var hanA = new Array("","일","이","삼","사","오","육","칠","팔","구","십"); 
	var danA = new Array("","십","백","천","","십","백","천","","십","백","천","","십","백","천"); 
	var result = ""; 
	for(i=0; i<num.length; i++){
		str = "";
		han = hanA[num.charAt(num.length-(i+1))];
		if(han != "") str += han+danA[i];
		if(i == 4) str += "만";
		if(i == 8) str += "억";
		if(i == 12) str += "조";
		result = str + result;
	}
	if(num != 0) result = result;
	return result ;
}
