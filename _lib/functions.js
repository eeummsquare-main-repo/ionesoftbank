$(document).ready(function(){
	$(document).on("click",".btn_logout",function(){
		var params = "";

		$.ajax({type:"POST", url:"/_proc/logout.asp",data:params,dataType:"html"
		}).done(function(data){
			var rData = data.split("|")
			if (rData[0]=="OK"){
				location.href="/";
			}else{
				var retMsg = rData[1].replace(/\\n/gi, "\n");
				alert(retMsg)
			}
		});
	});

	$('.amount .plus').click(function(){
		var n = $('.amount .plus').index(this);
		var qty = $(".amount .qty:eq("+n+")").val();
		qty = $(".amount .qty:eq("+n+")").val(qty*1+1);
		$(".amount .qty:eq("+n+")").change();
	});
	$('.amount .minus').click(function(){
		var n = $('.amount .minus').index(this);
		var qty = $(".amount .qty:eq("+n+")").val();
		if (qty == 1) {
			$(".amount .qty:eq("+n+")").val("1");
		} else {
			qty = $(".amount .qty:eq("+n+")").val(qty*1-1);
		}
		$(".amount .qty:eq("+n+")").change();
	});

	$(document).on("change",".fileField",function(){
		$(this).closest(".file").find(".fileFieldChk").prop("checked",true);
		$(this).closest(".file").find(".fileFieldChk").change();
		$(this).closest(".fileTD").find(".fileFieldChk").prop("checked",true);
		$(this).closest(".fileTD").find(".fileFieldChk").change();
	});

	$(document).on("change",".bbsFileField",function(){
		$(this).parent().parent().parent().find(".bbsFileFieldChk").prop("checked",true);
	});

	$(document).on("change",".fileFieldChk",function(){
		var fileidx = $(this).attr("dataVal")
		if (!fileidx) fileidx = 1;

		if ( $(this).is(":checked") ){
			$(this).parents(".file").find(".fileDelidx").val(fileidx);
		}else{
			$(this).parents(".file").find(".fileDelidx").val(0);
		}
	});

	$(document).on("change keyup input",".onlyNumber",function(){
		var x = $(this).val();
		x =x.replace(/[^0-9]/gi,"");
		var restr = x.toString();
		$(this).val(restr)
	});

	$(document).on("change keyup input",".onlyPer",function(){
		var str= "" + $(this).val().replace(/,/gi,''); // 콤마 제거 
		str = str.replace(/[^0-9-.]/gi,"");
		var regx = new RegExp(/(-?\d+)(\d{3})/); 
		var bExists = str.indexOf(".",0); 
		var strArr = str.split('.'); 

		if (bExists > -1){
			$(this).val(strArr[0] + "." + strArr[1]);
		}else{
			$(this).val(strArr[0]);
		} 
	});

	$(document).on("change keyup input",".onlyPrice",function(){
		var str= "" + $(this).val().replace(/,/gi,''); // 콤마 제거 
		str = str.replace(/[^0-9-.]/gi,"");
		var regx = new RegExp(/(-?\d+)(\d{3})/); 
		var bExists = str.indexOf(".",0); 
		var strArr = str.split('.'); 
		while(regx.test(strArr[0])){ 
			strArr[0] = strArr[0].replace(regx,"$1,$2"); 
		} 
		if (bExists > -1){
			$(this).val(strArr[0] + "." + strArr[1]);
		}else{
			$(this).val(strArr[0]);
		} 
	});

	$("body").on("change", ".file_wrap>input[type=file]", function(){
		var idx = $(".file_wrap>input[type=file]").index($(this));
		var val = this.value;
		$(".file_route").eq(idx).html(val);
	});

	$("body").on("click", ".file_route", function(){
		var idx = $(".file_route").index($(this));
		var val = "";
		$(".file_wrap>input[type=file]").eq(idx).val("");
		$(".file_route").eq(idx).html(val);
	});

	$("#HKeditorContent img").each(function(){
		$(this).css("max-width","100%")
	});

	$(document).on("change",".eDomailSelector",function(e){
		var val = $(this).val();
		var obj = $(this).parents().find(".eDomain");
		if (val==""){
			obj.val("");
			obj.focus();
		}else{
			obj.val(val);
		}
		$(".emailChk").change()
	});
});

function checkCorporateRegiNumber(number){
	var numberMap = number.replace(/-/gi, '').split('').map(function (d){
		return parseInt(d, 10);
	});

	if(numberMap.length == 10){
		var keyArr = [1, 3, 7, 1, 3, 7, 1, 3, 5];
		var chk = 0;

		keyArr.forEach(function(d, i){
			chk += d * numberMap[i];
		});

		chk += parseInt((keyArr[8] * numberMap[8])/ 10, 10);
		console.log(chk);
		return Math.floor(numberMap[9]) === ( (10 - (chk % 10) ) % 10);
	}
	return false;
}

const hypenBizcode = (target) => {
	target.value = target.value
	.replace(/[^0-9]/g, '')
	.replace(/^(\d{3})(\d{2})(\d{5})$/, '$1-$2-$3');
}

/*비동기 기본 셋팅*/
$.ajaxSetup({
	type: "POST",
	async: true,
	dataType:"html",
	beforeSend : function(){
		popupLoadingOpen();
	},
	success:function() {
		layerModalClose();
	},
	error:function(request,status,error) {
		//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		alert("데이터 처리중 오류가 발생했습니다.");
		layerModalClose();
		//location.reload();
	}
});

function inputYMDNumber(obj) {
	// @see DELETE 키버튼이 눌리지 않은 경우에만 실행
	if(event.keyCode != 8) {
		// @see 숫자와 하이픈(-)기호의 값만 존재하는 경우 실행
		if(obj.value.replace(/[0-9 \-]/g, "").length == 0) {
			// @see 하이픈(-)기호를 제거한다.
			let number = obj.value.replace(/[^0-9]/g,"");
			let ymd = "";

			// @see 문자열의 길이에 따라 Year, Month, Day 앞에 하이픈(-)기호를 삽입한다.
			if(number.length < 4) {
				return number;
			} else if(number.length < 6){
				ymd += number.substr(0, 4);
				ymd += "-";
				ymd += number.substr(4);
			} else {
				ymd += number.substr(0, 4);
				ymd += "-";
				ymd += number.substr(4, 2);
				ymd += "-";
				ymd += number.substr(6);
			}
			obj.value = ymd;
		} else {
			obj.value = obj.value.replace(/[^0-9 ^\-]/g,"");
			return false;
		}
	} else {
		return false;
	}
}

function setDatepicker(obj){
	if (obj){
		targetObj = obj.find(".datepicker")
	}else{
		targetObj = $( ".datepicker" )
	}

	// datepicker 
	targetObj.datepicker({
		inline: true, 
		dateFormat: "yy-mm-dd",    /* 날짜 포맷 */ 
		prevText: 'prev', 
		nextText: 'next', 
		showButtonPanel: false,    /* 버튼 패널 사용 */ 
		changeMonth: false,        /* 월 선택박스 사용 */ 
		changeYear: false,        /* 년 선택박스 사용 */ 
		showOtherMonths: true,    /* 이전/다음 달 일수 보이기 */ 
		selectOtherMonths: true,    /* 이전/다음 달 일 선택하기 */ 
		showOn: "both", 
		buttonImage: "/images/calendar.png",
		buttonImageOnly: false, 
		//minDate: "2020-05-20",
		closeText: '닫기', 
		currentText: '오늘', 
		yearSuffix: " 년", //달력의 년도 부분 뒤에 붙는 텍스트
		showMonthAfterYear: true,        /* 년과 달의 위치 바꾸기 */ 
		yearRange: '-15:+10', // Range of years to display in drop-down,
			// either relative to current year (-nn:+nn) or absolute (nnnn:nnnn)
		/* 한글화 */ 
		monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], 
		monthNamesShort : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], 
		dayNames : ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesShort : ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesMin : ['일', '월', '화', '수', '목', '금', '토'],
		showAnim: 'fade', 
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

function pagePrint(){
	var bodyCon = $("#printArea").html();
    var W = 600;
    var H = 500;

	var features = "menubar=no,toolbar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes,width=" + W + ",height=" + H + ",left=0,top=0";
	var PrintPage = window.open("/board/printContent.asp","print",features);
}

/* 심플모달 시작 */
function layerModalOpen(data){
	var obj = null;

	if (typeof(data) == "string") {
		if (!document.getElementById("simplemodal_div")) {
			$("<div>", {"id": "simplemodal_div"})
				.html("<span id='simplemodal_span'></span>")
				.appendTo(document.body)
				.hide();
		}

		obj = $("#simplemodal_div").find("#simplemodal_span").html(data);
	} else {
		obj = data;
	}
	$(obj).modal({
		zIndex: 20000,
		overlayId: "simplemodal-overlay",
		containerId: "simplemodal-container",
		overlayClose:false,
		autoResize:true,
		escClose: false,
		autoPosition:true,
		close : false
	});
}

/* 팝업로딩 */
function popupLoadingOpen(){
	layerModalOpen("<div class=\"loading\"><img src=\"/_lib/images/loading.gif\" alt=\"Loading\"></div>");
	$("#simplemodal-overlay").css("background","none");
}

/* 심플모달 닫기 */
function layerModalClose() {
	$("#simplemodal_div, #loading_div").remove();
	$.modal.close();
}

/* 레이어 팝업 띄우기 */
function fnLayerPopupOpen(data){
	if (!document.getElementById("layerPopupWrap")) {
		$("<div>", {"id": "layerPopupWrap"}).appendTo(document.body);
	}
	$("#layerPopupWrap").html(data).hide();

	var $layerWrap = $(".popWrap");
	var winW = $(document).width();
	var winH = $(document).height();

	$layerWrap.prepend('<div class="dimmed"></div>');
	$(".dimmed").css({"width": winW, "height": winH});

	$("#layerPopupWrap").show();
	if ( $layerWrap.is(":visible") ) {
		var popH= ($('.popCon').height()+42)/2;
		var popW= $('.popCon').width()/2;
		$(".popCon").css({
			"top": '50%',
			"left" : '50%',
			"margin-top":-popH,
			"margin-left":-popW
		});
	}
	$layerWrap.find(".btnClose, .btnClose2").on('click', function(e) {
		e.preventDefault();
		fnLayerPopupClose();
	});
	layerModalClose();
}

/* 레이어 팝업 닫기 */
function fnLayerPopupClose(){
	$(".popWrap").hide();
	$("#layerPopupWrap").remove();
}

function isValidEmail( string1, string2 ) {
	var message = "";

	if( string1 == "" || string2 == "" ) {
		message = "이메일을 입력해 주시기 바랍니다.";
		return message;
	}
	if( isSpace( string1 + string2 ) ) {
		messages = "이메일 주소를 빈공간없이 넣어주시기 바랍니다.";
		return message;
	}
	if( -1 == string2.indexOf('.') ) {
		message = "이메일 형식이 잘못 되었습니다.";
		return message;
	}
	var isEmail = /^[a-zA-Z0-9_+.-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,4}$/;
	if( !isEmail.test(string1 + '@' + string2) ) {
		message = "이메일 형식이 잘못 되었습니다.";
		return message;
	}
	return message;
}

function isValidEmailOnce(string) {
	var message = "";

	if( string == "" ) {
		message = "이메일을 입력해 주시기 바랍니다.";
		return message;
	}
	if( isSpace( string ) ) {
		messages = "이메일 주소를 빈공간없이 넣어주시기 바랍니다.";
		return message;
	}
	if( -1 == string.indexOf('.') ) {
		message = "이메일 형식이 잘못 되었습니다.";
		return message;
	}
	var isEmail = /^[a-zA-Z0-9_+.-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,4}$/;
	if( !isEmail.test(string) ) {
		message = "이메일 형식이 잘못 되었습니다.";
		return message;
	}
	return message;
}

function uemailListChange(emailDomain){
	if (emailDomain != "") {
		$('#email2').val(emailDomain);
		$('#email2').attr('readonly', true);
	} else {
		$('#email2').attr('readonly', false);
		$('#email2').val('');
	}
}

function isSpace( string ) {
	if(string.search(/\s/) != -1) {
		return true;
	} else {
		return false;
	}
}

/* 숫자키만 입력 받을수 있게 설정 */
function onlyNumber(){
	$(":input").filter(".onlyNumber")

	.bind("cut copy paste", function(e){
		 e.preventDefault();
	}).keypress(function(event){
		if (event.which && (event.which < 48 || event.which > 57)) {
			//alert("숫자만 입력 가능합니다.");
			event.preventDefault();
		}
	}).css("imeMode", "disabled")
}

function openVideo(vodurl){
	params="vodurl="+vodurl;
	jQuery.ajax({type:"POST", url:'/sub/ajax_VideoView.asp',data:params,dataType:"html",
		success:function(msg){
			document.getElementById("layerVideoDiv").style.display="inline";
			document.getElementById("listDiv").innerHTML=msg;
		}
	});
}
function closeVideo(){
	document.getElementById("layerVideoDiv").style.display="none";
}

function getSubCate(sort,val){
	var params = "sort="+sort+"&catecode="+val;
	$.ajax({type:"POST", url:"/_lib/subCateList.asp",data:params,dataType:"script"
	}).done(function(data){

	});
}
function goProductDetail(){
	var proidx = $("#sercate3").val()
	if (proidx==""){
		alert("3차 분류까지 선택해주세요.");
		return;
	}

	location.href="/product/product_view.asp?idx="+proidx;
}
function MainItemSearchGo(frm){
	if ( frm.searchStr.value.length==0 || frm.searchStr.value.length<1 ){
		if (langCode=="kor"){
			alert("검색어를 입력해주세요.");
		}else{
			alert("Please enter your search term.");
		}
		frm.searchStr.focus();
		return ;
	}
	frm.submit();
}

function viewTempPopup(actDiv,temCode,idx){
	var params = "idx="+idx;

	if(temCode==1){
		pageName="/library/popskin/pop1.asp"
	}else if(temCode==2){
		pageName="/library/popskin/pop2.asp"
	}else if(temCode==3){
		pageName="/library/popskin/pop3.asp"
	}else if(temCode==4){
		pageName="/library/popskin/pop4.asp"
	}else if(temCode==5){
		pageName="/library/popskin/pop5.asp"
	}else if(temCode==6){
		pageName="/library/popskin/pop6.asp"
	}else if(temCode==7){
		pageName="/library/popskin/pop7.asp"
	}else if(temCode==8){
		pageName="/library/popskin/pop8.asp"
	}else if(temCode==9){
		pageName="/library/popskin/pop9.asp"
	}else if(temCode==10){
		pageName="/library/popskin/pop10.asp"
	}

	$.ajax({type:"POST", url:pageName,data:params,dataType:"html",
		success:function(msg){
			document.getElementById(actDiv).innerHTML=msg;
		}
	});
}

function numOnMask(me){
	if (event.keyCode<48||event.keyCode>57){//숫자외금지
		event.returnValue=false;
	}
	var tmpH
	if(me.charAt(0)=="-"){//음수가 들어왔을때 '-'를 빼고적용되게..
		tmpH=me.substring(0,1);
		me=me.substring(1,me.length);
	} //me.indexOf('-')
	if(me.length > 3){
		var c=0;
		var myArray=new Array();
		for(var i=me.length;i>0;i=i-3){
			myArray[c++]=me.substring(i-3,i);
		}
		myArray.reverse();
		me=myArray.join(",");
	}
	if(tmpH){
		me=tmpH+me;
	}
	return me;
}
function numOffMask(me){
	var tmp=me.split(",");
	tmp=tmp.join("");

	return tmp;
}
function check_value(me){
	if(me.value!="-"){
		var myStr=numOffMask(me.value);

		if (isNaN(myStr)) {
			//alert("숫자만 입력할 수 있습니다.");
			me.value='';
		}else{
			me.value=numOnMask(myStr);
		}
	}
	//me.focus();
}

function autotab(field){
	 if (field.getAttribute&&field.value.length==field.getAttribute("maxlength")) {
		var i;
		for (i = 0; i < field.form.elements.length; i++)
			if (field == field.form.elements[i])
				break;
		i = (i + 1) % field.form.elements.length;
		field.form.elements[i].focus();
		return false;
	}
	else
	return true;
}

function jumin_check(userNo1,userNo2){
	a = Array(6);
	b = Array(7);
	var f=document.pageForm;
	var num1, num2, total, tot;

	if(userNo1.length==6 && userNo2.length==7){
		num1=userNo1;
		num2=userNo2;

		for(var i=0; i<6; i++){
			a[i]=parseInt(num1.charAt(i));
		}

		for(var j=0; j<7; j++){
			b[j]=parseInt(num2.charAt(j));
		}

		total = (a[0]*2) + (a[1]*3) + (a[2]*4) + (a[3]*5) + (a[4]*6) + (a[5]*7) + (b[0]*8) + (b[1]*9) + (b[2]*2) + (b[3]*3) + (b[4]*4) + (b[5]*5);
		tot = 11 - (total % 11);
		if(tot==11){
			tot = 1;
		}else if(tot==10){
			tot = 0;
		}

		if(b[6]!=tot){
			alert("주민번호가 올바르지않습니다.");
			return(false);
		}return(true);
	}else{
		alert("주민등록번호를 올바로 입력하세요.");
		return(false);
	}
}

function closeLayer(obj){
	obj.style.visibility='hidden';
}
function closetoLayer(obj){
	setCookie( obj, "done" , 1 );
	document.all[obj].style.visibility = "hidden";
}

function openLayer(obj){
	obj.style.visibility='visible';
}
function opentoLayer(obj){
	setCookie( obj, "done" , 1 );
	document.all[obj].style.visibility = "visible";
}

function setCookie( name, value, expiredays ) {
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}
function getCookie( name ){
	var nameOfCookie = name + "=";
	var x = 0;
	while ( x <= document.cookie.length ) {
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie ) {
			if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 ) endOfCookie = document.cookie.length;
			return unescape( document.cookie.substring( y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 ) break;
	}
	return "";
}

function getFileExtension( filePath ){
	var extension = "";
	var lastIndex = -1;
		lastIndex = filePath.lastIndexOf('.');

	if ( lastIndex != -1 ){
		extension = filePath.substring( lastIndex+1, filePath.len );
	} else{
		extension = "";
	}
		return extension;
}

function uploadImg_check( value,msg,sort ){
	var src = getFileExtension(value);

	if(sort==1 && value==""){return true;}
	if ( src == ""){
		alert(msg);
		return false;
	} else if ( !((src.toLowerCase() == "gif") || (src.toLowerCase() == "jpg") || (src.toLowerCase() == "jpeg") || (src.toLowerCase() == "png")) ) {
		alert('gif,jpg,png 파일만 업로드 하실 수 있습니다.');
		return false;
	}else{return true;}
}

function uploadImg_check_JPG( value,msg,sort ){
	var src = getFileExtension(value);

	if(sort==1 && value==""){return true;}
	if ( src == ""){
		alert(msg);
		return false;
	} else if ( !((src.toLowerCase() == "jpg") || (src.toLowerCase() == "jpeg")) ) {
		alert('jpg 파일만 업로드 하실 수 있습니다.');
		return false;
	}else{return true;}
}

function uploadFlvImg_check( value,msg,sort ){
	var src = getFileExtension(value);

	if(sort==1 && value==""){return true;}
	if ( src == ""){
		alert(msg);
		return false;
	} else if ( !((src.toLowerCase() == "flv")) ) {
		alert('플래쉬동영상 파일만 업로드 하실 수 있습니다.');
		return false;
	}else{return true;}
}

function popOpen(Width,Height,idx,sTop,sLeft,langsort) {
	if( getCookie( "pop"+idx ) != "done" ){
		var Option="left="+sLeft+",top="+sTop+",toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width="+Width+", height="+parseInt(Height+21);
		window.open("/popup.asp?idx="+idx,"pop"+idx,Option);
	}
}

function mainLoginSend(form) {
	if (langCode=="kor"){
		if(form.userid.value=="") {
			alert("아이디를 입력해 주십시오.");
			form.userid.focus();
			return;
		}
		if(form.passwd.value=="") {
			alert("패스워드를 입력해 주십시오.");
			form.passwd.focus();
			return;
		}
	}else{
		if(form.userid.value=="") {
			alert("Please enter your ID.");
			form.userid.focus();
			return;
		}
		if(form.passwd.value=="") {
			alert("Please enter your password.");
			form.passwd.focus();
			return;
		}

	}

	var params = $("#loginfrm").serialize();
	$.ajax({type:"POST", url:"/_proc/login.asp",data:params,dataType:"html"
	}).done(function(data){
		var rData = data.split("|")
		if (rData[0]=="OK"){
			location.reload();
		}else{
			var retMsg = rData[1].replace(/\\n/gi, "\n");
			alert(retMsg)
		}
	});
}

function mainLoginInputSendit(form) {
	if(event.keyCode==13) {
		mainLoginSend(form);
	}
}

function zipcodeck(zip,addr1,addr2) {
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
			document.getElementById(zip).value = data.zonecode; //5자리 새우편번호 사용
			document.getElementById(addr1).value = fullAddr;

			// 커서를 상세주소 필드로 이동한다.
			document.getElementById(addr2).focus();
		}
	}).open();
}

function getAddrs() {
	new daum.Postcode({
		oncomplete: function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var fullAddr = ''; // 최종 주소 변수
			var fullAddrJi = ''; // 최종 주소 변수
			var extraAddr = ''; // 조합형 주소 변수

			fullAddrJi = data.jibunAddress;
			fullAddr = data.roadAddress;

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

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById("zipcode").value = data.zonecode; //5자리 새우편번호 사용
			document.getElementById("addr1").value = fullAddr;
			$("#addr1_ji").val(fullAddrJi)
		}
	}).open();
}

function zipcodeck_getLat(zip,addr1,addr2,jibunaddr1) {
	new daum.Postcode({
		oncomplete: function(data) {
			var fullAddr = '';
			var fullAddrJiBun = '';
			var extraAddr = '';

			fullAddr = data.roadAddress;
			fullAddrJiBun = data.jibunAddress;

			if(data.userSelectedType === 'R'){
				if(data.bname !== ''){
					extraAddr += data.bname;
				}
				if(data.buildingName !== ''){
					extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				//fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
			}

			//좌표 GET////////////////
			var geocoder = new daum.maps.services.Geocoder();						// 주소-좌표 변환 객체를 생성합니다

			geocoder.addressSearch(fullAddr, function(result, status) {				// 주소로 좌표를 검색합니다
				if (status === daum.maps.services.Status.OK) {
					//var coords = new daum.maps.LatLng(result[0].y, result[0].x);
					$("#coord_y").val(result[0].y);
					$("#coord_x").val(result[0].x);
				}else{
					$("#ncoord_x").val("");
					$("#ncoord_y").val("");
					alert("위/경도 변환에 실패했습니다.\n위/경도가 입력되지 않으면 주문 및 매장 검색이 되지 않습니다.")
				}
			});
			//좌표 GET////////////////

			if (zip) $("#"+zip).val(data.zonecode);
			if (addr1) $("#"+addr1).val(fullAddr);
			if (addr2) $("#"+addr2).focus();
		}
	}).open();
}

function itemsearch(){
	if(document.itemshform.searchstr.value==""){
		alert("검색하실 제품 단어를 입력하세요.");
		document.itemshform.searchstr.focus();
		return;
	}document.itemshform.submit();
}

function openModal(width,height,fileUrl,scroll){
	var OpenFile=fileUrl;
	var ReturnValue=window.showModalDialog(OpenFile,'','scroll:'+scroll+'; help:no; center:yes; status:no; dialogWidth:'+width+'px; dialogHeight:'+height+'px');
	if(ReturnValue==1){
		return true;
	}
}

function openWindow(Width,Height,Url,winname,scroll) {
	var winPosLeft = (screen.width - Width) / 2; // 새창 Y 좌표
	var winPosTop = (screen.height - Height) / 2; // 새창 X 좌표

	var Option="top="+winPosTop+",left="+winPosLeft+", toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars="+scroll+", resizable=no,width="+Width+", height="+Height;
	obj = window.open(Url,winname,Option);
	obj.focus();
}

function login(rUrl){
	val = confirm("회원전용 컨텐츠입니다.\n로그인 페이지로 이동하시겠습니까?")
	if (val){
		location.href="../member/login.asp?returnURL="+rUrl
	}
}

function loginConfirm(msg, rUrl){
	val = confirm(msg)
	if (val){
		location.href="../member/login.asp?returnURL="+rUrl
	}
}

function downChk(){
	alert("다운로드 권한이 없습니다.\n확인후 다시시도해주세요.");
	return;
}

function inputSendit(thisform) {
	if(event.keyCode==13) {
		thisform.submit();
	}
}

function formatNumber(v1,v2){
	var str=new Array(); //콤마스트링을 조합할 배열
	v1=String(v1); //숫자를 스트링으로 변환
	for(var i=1;i<=v1.length;i++){ //숫자의 길이만큼 반복
		if(i%v2) str[v1.length-i]=v1.charAt(v1.length-i); //자리수가 아니면 숫자만삽입
		else  str[v1.length-i]=','+v1.charAt(v1.length-i); //자리수 이면 콤마까지 삽입
	}
	return str.join('').replace(/^,/,''); //스트링을 조합하여 반환
}

function regularExp(Str,Patten){
	var chk
	if(Patten=="hangle"){chk=/[^ ㄱ-힣]/;}		// 한글,공백 허용
	else if(Patten=="charcode"){chk=/[^ \wㄱ-힣]/}	// 한영문자,숫자,공백,_ 허용
	else if(Patten=="intcode"){chk=/[^\d-]/;}	// 숫자,- 허용
	else{chk=Patten}
	return chk.test(Str);
}

function OpenWin_Upload() {
	window.open("../TextEditor/fileupload.asp","FileUpload","scrollbars=yes,height=470,width=720,top=20,left=50");
}

function setCookie( name, value, expiredays ){
  var endDate = new Date();
  endDate.setDate( endDate.getDate()+ expiredays );
  document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + endDate.toGMTString() + ";"
}

function get_Cookie( name ){
    var nameOfCookie = name + "=";
    var x = 0;
    while ( x <= document.cookie.length ){
        var y = (x+nameOfCookie.length);
        if ( document.cookie.substring( x, y ) == nameOfCookie ){
            if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
                endOfCookie = document.cookie.length;
            return unescape( document.cookie.substring( y, endOfCookie ) );
        }
        x = document.cookie.indexOf( " ", x ) + 1;
        if ( x == 0 ) break;
    }
    return "";
}

function getCookie( name ){
	var nameOfCookie = name + "=";
	var x = 0;
	while ( x <= document.cookie.length ) {
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie ) {
			if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 ) endOfCookie = document.cookie.length;
			return unescape( document.cookie.substring( y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 ) break;
	}
	return "";
}

function changeMenu(index){
	if(index==0){
		document.all.MenuTable1.style.display='block';
		document.all.MenuTable2.style.display='none';
		setCookie( "menuSort", 0 , 1);
	}else{
		document.all.MenuTable1.style.display='none';
		document.all.MenuTable2.style.display='block';
		setCookie( "menuSort", 1 , 1);
	}
}

function vodView(title,url){
	var Option="top=0, left=0, toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars="+scroll+", resizable=no,width=400, height=300";
	window.open('/player/player.asp?title='+title+'&ViewFileUrl='+url,'player',Option);
}

function addRowFront() {
	var html="";

	var cnt = $("input[name=files]").length+1;

	html = html + "<div style='padding-top:3px;'>"
	html = html + "	<span class=\"file_wrap\">"
	html = html + "		<input type=\"file\" name='files' onchange=\"javascript:document.getElementById('file_route"+cnt+"').value=this.value\" />"
	html = html + "	</span>"
	html = html + "	<input type=\"text\" id=\"file_route"+cnt+"\" style=\"width:50%;\" readonly=\"readonly\" disabled=\"disabled\" title=\"첨부된 파일경로\" />"
	html = html + "	<input type='hidden' name='filedel_idx' value='0'>"
	html = html + "</div>"

	$("#attFiles").append(html);
}
function addRow_Front() {
	var fileAddTag = "";
	fileAddTag = fileAddTag + "<div class=\"file\">"
	fileAddTag = fileAddTag + "	<span class=\"file_wrap\">"
	fileAddTag = fileAddTag + "		<span class=\"btnFile\">파일첨부<input type=\"file\" name=\"files\" title=\"파일첨부\"/><input type='hidden' name='filedel_idx' value='0'></span>"
	fileAddTag = fileAddTag + "		<span class=\"delFile\"></span>"
	fileAddTag = fileAddTag + "	</span>"
	fileAddTag = fileAddTag + "	<a class=\"thumb\"></a>"
	fileAddTag = fileAddTag + "</div>"

	var fileAllowCnt = 5 ;
	if ($("#fileArea .file").length>=fileAllowCnt){
		alert("더이상 추가할수 없습니다.");
	}else{
		$("#fileArea").append(fileAddTag);	
	}
}

function addRow() {
	var tbl = document.getElementById("inRow").getElementsByTagName("TBODY")[0];
	var html1 = "<input name='files' type='file' class='input' style='width:350px'><input type='hidden' name='filedel_idx' value='0'><input type='hidden' name='filesort' value='0'>";
	var row = document.createElement("tr");
	var col1 = document.createElement("td");
	col1.className="HK_noBoarder";
	row.appendChild(col1);
	col1.innerHTML = html1;
	tbl.appendChild(row);
}
function changeFilech(cnt,val){
	var delchk = document.getElementsByName('delchk');
	var filedel_idx = document.getElementsByName('filedel_idx');

	if(delchk[cnt].checked){filedel_idx[cnt].value=val}
	else{filedel_idx[cnt].value=""}
}

function changeFileArea(){
	if(document.getElementById("fileArea").style.display=="none"){
		document.getElementById("fileArea").style.display="inline";
	}else{
		document.getElementById("fileArea").style.display="none";
	}
}

var Drag={
	"obj":null,

	"init":function(a, aRoot, ee){
			if (!ee) {
				a.onmousedown=Drag.start;
			}
			a.root = aRoot;
			if(isNaN(parseInt(a.root.style.left))) { a.root.style.left="0px"; }
			if(isNaN(parseInt(a.root.style.top))) { a.root.style.top="0px"; }
			a.root.onDragStart = new Function();
			a.root.onDragEnd = new Function();
			a.root.onDrag = new Function();

			if (!!ee) {
				var b = Drag.obj = a;
				ee = Drag.fixE(ee);
				var c = parseInt(b.root.style.top);
				var d = parseInt(b.root.style.left);
				b.root.onDragStart(d,c,ee.clientX,ee.clientY);
				b.lastMouseX = ee.clientX;
				b.lastMouseY = ee.clientY;
				document.onmousemove    = Drag.Drag;
				document.onmouseup      = Drag.end;
			}

		},

	"start":function(a){

			var b=Drag.obj=this;
			a=Drag.fixE(a);

			var c = parseInt(b.root.style.top);
			var d = parseInt(b.root.style.left);

			b.root.onDragStart(d,c,a.clientX,a.clientY);

			b.lastMouseX = a.clientX;
			b.lastMouseY = a.clientY;

			document.onmousemove    = Drag.Drag;
			document.onmouseup      = Drag.end;
			return false;
		},

	"Drag":function(a){
			a = Drag.fixE(a);
			var b = Drag.obj;
			var c = a.clientY;
			var d = a.clientX;
			var e = parseInt(b.root.style.top);
			var f = parseInt(b.root.style.left);
			var h,g;
			h = f + d - b.lastMouseX;
			g = e + c - b.lastMouseY;
			b.root.style.left   = h + "px";
			b.root.style.top    = g + "px";
			b.lastMouseX        = d;
			b.lastMouseY        = c;
			b.root.onDrag(h, g, a.clientX, a.clientY);
			return false;
		},

	"end":function(){
			document.onmousemove    = null;
			document.onmouseup      = null;
			Drag.obj.root.onDragEnd(parseInt(Drag.obj.root.style.left),parseInt(Drag.obj.root.style.top));
			Drag.obj = null;
		},


	"fixE":function(a){
			if(typeof a == "undefined") { a=window.event; }
			if(typeof a.layerX == "undefined") { a.layerX=a.offsetX; }
			if(typeof a.layerY == "undefined") { a.layerY=a.offsetY; }
			return a;
		}
};

function hangul_chk(word) {
	var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";

	for (i=0; i< word.length; i++){
		idcheck = word.charAt(i);

		for ( j = 0 ;  j < str.length ; j++){
			if (idcheck == str.charAt(j)) break;

			if (j+1 == str.length){
				return false;
			}
   		}
   	}
   	return true;
}

function emailDomainSet()	{
	if ($("#domainSelect").val()==""){
		$("#emailDomain").val('');
		$("#emailDomain").focus();
	}else{
		$("#emailDomain").val( $("#domainSelect").val() );
	}
}
function demailDomainSet()	{
	if ($("#ddomainSelect").val()==""){
		$("#demailDomain").val('');
		$("#demailDomain").focus();
	}else{
		$("#demailDomain").val( $("#ddomainSelect").val() );
	}
}

//입력한 글자수를 체크
function chkByte(obj_name, max_len, span_name, isFirst) {
	var ls_str     = obj_name.value;      // 이벤트가 일어난 컨트롤의 value 값
	var pattern = "/\r\n/gm";
	ls_str = ls_str.replace(pattern,'\n');
	var li_str_len = ls_str.length;       // 전체길이

	// 변수초기화
	var li_max      = max_len;  // 제한할 글자수 크기
	var i           = 0;        // for문에 사용
	var li_byte     = 0;        // 한글일경우는 2 그밗에는 1을 더함
	var isHan = true;
	var li_len      = 0;        // substring하기 위해서 사용
	var ls_one_char = "";       // 한글자씩 검사한다
	var ls_str2     = "";       // 글자수를 초과하면 제한할수 글자전까지만 보여준다.

	try {
		//var objSpan = document.getElementById(span_name);

		for( i = 0; i < li_str_len; i++ ) {
			// 한글자추출
			ls_one_char = ls_str.charAt(i);

			if ( escape(ls_one_char).length > 4 ) {    // 한글이면 2를 더한다.
				li_byte += 1;
				isHan = true;
			} else if (ls_one_char == '\n') { // 줄바꿈일경우
			/*        if (li_str_len.charAt(i-1) != '\r') { // 하지만 밀려서 줄이 바뀐경우가 아닐때
			          li_byte += 1;
			          isHan = false;
			        }*/
			} else if (ls_one_char == ' ') { // 공백일경우

			} else {                        // 그밗의 경우는 1을 더한다.
				li_byte++;
				isHan = false;
			}

			// 전체 크기가 li_max를 넘지않으면
			if( li_byte <= li_max ) {
				li_len = i + 1;
			} else {
				break;
			}
		}

		// 전체길이를 초과하면
		if ( li_byte > li_max ) {
			alert( li_max + "자를 초과 입력할 수 없습니다.\n초과된 내용은 자동으로 삭제 됩니다. ");
			ls_str2 = ls_str.substr(0, li_len);
			obj_name.value = ls_str2;

			if ( isHan ) li_byte -= 1;
			else         li_byte--;
		}
		if ( isFirst != 'N') {
			obj_name.focus();
		}
		//objSpan.innerHTML = li_byte+"/"+max_len+"자";
	} catch(e) {}
}

// SMS CHECK Function ==============================================================
function str_limit_check( obj,obj1, max_len ){
	content_length = obj.value.length;
	tmp_content = "";
	cbyte = 0;
	if( !max_len ){	max_len = 80; }
        for( i = 0; i < content_length; i++ ){
			tmp_char = obj.value.charAt( i );
			if( escape( tmp_char ).length > 4){
				cbyte += 2;
			}
			else{ cbyte++; }
		if( typeof( document.all[obj1] ) == "object" ){
			document.all[obj1].innerHTML = cbyte;
		}
			if( cbyte <= max_len ){
				tmp_content += tmp_char;
			}
			else{
				msg = '메시지는 ' + max_len + ' Byte 이하로 입력해주세요.';
				alert( msg );
				obj.value = tmp_content;

				if( typeof( document.all[obj1] ) == "object" ){
					document.all[obj1].innerHTML = cbyte - ( cbyte - max_len );
				}
		break;
		}
	}
}
//==================================================================================

function changeareaData(str1,str2){
	var params = "areaidx="+str1+"&lccode="+str2+"&objname1=selAreaidx&objname2=areadetailidx";

	$.ajax({type:"POST", url:'/_lib/selAreaDetail.asp',data:params,dataType:"script",
	}).done(function(msg){
	});
}

function moveArea(target_top){
	$('html, body').stop().animate({'scrollTop':target_top+'px'}, 400);
}

function checkPassword(password, id){
	if(!/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,16}$/.test(password)){
		alert('비밀번호는 숫자+영문자 조합으로 6자리 이상 사용해야 합니다.');
		return false;
	}
	var checkNumber = password.search(/[0-9]/g);
	var checkEnglish = password.search(/[a-z]/ig);
	if(checkNumber <0 || checkEnglish <0){
		alert("비밀번호는 숫자와 영문자를 혼용하여야 합니다.");
		return false;
	}
	if(/(\w)\1\1\1/.test(password)){
		alert('비밀번호는 같은 문자를 4번 이상 사용하실 수 없습니다.');
		return false;
	}
	if (id!=""){
		if(password.search(id) > -1){
			alert("비밀번호에 아이디가 포함되었습니다.");
			return false;
		}
	}
	return true;
}

function getAreaName(siDo){
	if (siDo=="서울" || siDo=="서울시" || siDo=="서울특별시"){
		return "서울";
	}else if (siDo=="강원" || siDo=="강원도"){
		return "강원";
	}else if (siDo=="충남" || siDo=="충청남도"){
		return "충남";
	}else if (siDo=="충북" || siDo=="충청북도"){
		return "충북";
	}else if (siDo=="경북" || siDo=="경상북도"){
		return "경북";
	}else if (siDo=="경남" || siDo=="경상남도"){
		return "경남";
	}else if (siDo=="전북" || siDo=="전라북도"){
		return "전북";
	}else if (siDo=="전남" || siDo=="전라남도"){
		return "전남";
	}else if (siDo=="경기" || siDo=="경기도"){
		return "경기";
	}else if (siDo=="대전" || siDo=="대전광역시"){
		return "대전";
	}else if (siDo=="대구" || siDo=="대구광역시"){
		return "대구";
	}else if (siDo=="광주" || siDo=="광주광역시"){
		return "광주";
	}else if (siDo=="울산" || siDo=="울산광역시"){
		return "울산";
	}else if (siDo=="부산" || siDo=="부산광역시"){
		return "부산";
	}else if (siDo=="인천" || siDo=="인천광역시"){
		return "인천";
	}else if (siDo=="세종" || siDo=="세종시" || siDo=="세종특별자치시"){
		return "세종";
	}else if (siDo=="제주" || siDo=="제주시" || siDo=="제주도" || siDo=="제주특별자치시"){
		return "제주";
	}
}

function getNumber(val){
	if (parseFloat(val)){
		return parseFloat(val.replace(/,/gi,''));
	}else{
		return 0
	}
}