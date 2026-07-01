<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "subject" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx = uf_getRequest(Request("idx"), "int", "1", "0")

Sql = "SELECT arrAreaNm, arrAreaPrice, txtCon1, txtCon2, txtCon3, arrReqSubject, arrSelSubject, txtinfo1, txtinfo2, txtinfo3, txtinfo4, txtinfo5, txtinfo6, txtinfo7, txtinfo8, txtinfo9, txtinfo10, txtinfo11, txtinfo12, txtinfo13, txtinfo14, txtinfo15, txtinfo16, txtinfo17, txtinfo18 FROM subjectData WHERE idx="&idx
Set Rs = DBCon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	AreaNm = changeBlank(Rs("arrAreaNm"))
	AreaPrice = changeBlank(Rs("arrAreaPrice"))
	txtCon1 = changeBlank(Rs("txtCon1"))
	txtCon2 = changeBlank(Rs("txtCon2"))
	txtCon3 = changeBlank(Rs("txtCon3"))
	arrReqSubject = changeBlank(Rs("arrReqSubject"))
	arrSelSubject = changeBlank(Rs("arrSelSubject"))

	txtinfo1 = changeBlank(Rs("txtinfo1"))
	txtinfo2 = changeBlank(Rs("txtinfo2"))
	txtinfo3 = changeBlank(Rs("txtinfo3"))
	txtinfo4 = changeBlank(Rs("txtinfo4"))
	txtinfo5 = changeBlank(Rs("txtinfo5"))
	txtinfo6 = changeBlank(Rs("txtinfo6"))
	txtinfo7 = changeBlank(Rs("txtinfo7"))
	txtinfo8 = changeBlank(Rs("txtinfo8"))
	txtinfo9 = changeBlank(Rs("txtinfo9"))
	txtinfo10 = changeBlank(Rs("txtinfo10"))
	txtinfo11 = changeBlank(Rs("txtinfo11"))
	txtinfo12 = changeBlank(Rs("txtinfo12"))
	txtinfo13 = changeBlank(Rs("txtinfo13"))
	txtinfo14 = changeBlank(Rs("txtinfo14"))
	txtinfo15 = changeBlank(Rs("txtinfo15"))
	txtinfo16 = changeBlank(Rs("txtinfo16"))
	txtinfo17 = changeBlank(Rs("txtinfo17"))
	txtinfo18 = changeBlank(Rs("txtinfo18"))

	arrAreaNm = Split(AreaNm, "|")
	arrAreaPrice = Split(AreaPrice, "|")
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_ItemList
	Dim i,Num
	Num=1

	IF IsArray(arrAreaNm) Then
		For i=0 To Ubound(arrAreaNm)
			areaNm = ChangeBlank(arrAreaNm(i))
			areaPrice = ChangeBlank(arrAreaPrice(i))

			Response.Write "<tr id=""tr_"&i&""">"&Vbcrlf
			Response.Write "	<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a></td>"&Vbcrlf
			Response.Write "	<td><input type='text' name=""areaNm"" class=""required"" maxlength=""20"" reqTitle=""지역명"" value="""&ReplaceTextField(areaNm)&"""></td>"&Vbcrlf
			Response.Write "	<td><input type='text' name=""areaPrice"" class=""onlyNumber"" maxlength=""3"" reqTitle=""수강료"" value="""&ReplaceTextField(areaPrice)&""" style=""text-align:right; width:150px""> 만원</td>"&Vbcrlf
			Response.Write "	<td><input type='button' value=""삭제"" class=""btn_red btn_Del"" style='width:100%;'></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr id=""tr_0"">"&Vbcrlf
		Response.Write "	<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a></td>"&Vbcrlf
		Response.Write "	<td><input type='text' name=""areaNm"" class=""required"" maxlength=""20"" reqTitle=""지역명"" value="""&ReplaceTextField(LOOP_TITLE)&"""></td>"&Vbcrlf
		Response.Write "	<td><input type='text' name=""areaPrice"" class=""onlyNumber"" maxlength=""3"" reqTitle=""수강료"" value="""&ReplaceTextField(LOOP_SYEAR)&""" style=""text-align:right; width:150px""> 만원</td>"&Vbcrlf
		Response.Write "	<td><input type='button' value=""삭제"" class=""btn_red btn_Del"" style='width:100%;'></td>"&Vbcrlf
		Response.Write "</tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript" src="/backoffice/js/jquery.tablednd.js"></script>
<style>
.dragTR td{background-color:#d4d4d4}
</style>
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	$("#stockTB").tableDnD({
		onDragClass : 'dragTR',
		onDrop: function(table, row) {
			setOrderBtnSet();
		},onDragStart: function(table, row) {

		}
	});

	$('#ch_cIdall').change(function() {
		if ($("#ch_cIdall").is(":checked")){
			$("input[name='chkidx']").prop('checked', true);
		}else{
			$("input[name='chkidx']").prop('checked', false);
		}
	});

	$(document).on("click",".orderDown",function(){
		var $tr = $(this).parent().parent();
		$tr.next().after($tr);
		setOrderBtnSet();
	});
	$(document).on("click",".orderUp",function(){
		var $tr = $(this).parent().parent();
		$tr.prev().before($tr);
		setOrderBtnSet();
	});

	$(document).on("click",".btn_Add",function(){
		var cnt = $("#stockTB tbody tr").size()
		var html = $("#stockCopyArea tbody").html()

		$("#stockTB tbody").append(html)
		setOrderBtnSet();
	});

	$(document).on("click",".btn_Del",function(){
		var cnt = $("#stockTB tbody tr").size()

		if (cnt==1){
			$(this).closest("tr").find("input[type='hidden']").val("");
			$(this).closest("tr").find("input[type='text']").val("");
		}else{
			$(this).closest("tr").remove();
		}
		setOrderBtnSet();
	});

	setOrderBtnSet();
});

function setOrderBtnSet(){
	var cnt = $("#stockTB tbody tr").length - 1;
	$("#stockTB tbody tr").each(function(i) {
		if (i==0){
			$(this).find(".orderUp").hide();
			$(this).find(".orderDown").show();
		}else if (i==cnt){
			$(this).find(".orderUp").show();
			$(this).find(".orderDown").hide();
		}else{
			$(this).find(".orderUp").show();
			$(this).find(".orderDown").show();
		}
		$(this).attr("id", "tr_"+i);
	});

	$("#stockTB").tableDnD({
		onDragClass : 'dragTR',
		onDrop: function(table, row) {
			setOrderBtnSet();
		},onDragStart: function(table, row) {

		}
	});
}

function sendit(){
	var requiredFlag = true;
	var itemTitle = "";

	$('#stockTB .required').each(function(){
		itemTitle = $(this).attr("reqTitle")

		if ( $(this).is(':text, textarea, select') && $(this).val().length < 1 ) {
			alert('['+itemTitle+']는 필수 입력항목 입니다.');
			$(this).focus();
			requiredFlag = false;
			return false;
		}else if ( $(this).is(':checkbox') ) {
			attrName = $(this).attr("name")

			if(!$("input:checkbox[name="+attrName+"]").is(":checked") == true) {
				alert('['+itemTitle+']는 필수 선택항목 입니다.');
				$(this).focus();
				requiredFlag = false;
				return false;
			}
		}else if ( $(this).is(':radio') ) {
			attrName = $(this).attr("name")

			if(!$("input:radio[name="+attrName+"]").is(":checked") == true) {
				alert('['+itemTitle+']는 필수 선택항목 입니다.');
				$(this).focus();
				requiredFlag = false;
				return false;
			}
		};
	});

	if( requiredFlag == true ) {
		document.appFrm.submit();
	}
}
//-->
</SCRIPT>
</head>

<body>

	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="HISTORY">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<div class="subTab mt20 mb20">
					<a href="?idx=0" class="<%=iif_compare(idx, 0, "active")%>"><span>사회복지 현장실습</span></a>
					<a href="?idx=1" class="<%=iif_compare(idx, 1, "active")%>"><span>보육실습</span></a>
				</div>

				<!-- <div style='clear:both;'>
					<select name='regdiv' style='width:100%; background-Color:  height:auto;' onchange="location.href='?langmode=<%=langmode%>&regdiv='+this.value;">
						<option value='0' <%=SelCheck(0, regdiv)%>>1980's ~ 2000's 게시물 관리</option>#000; color:#fff; font-size:14px; padding:5px;
						<option value='1' <%=SelCheck(1, regdiv)%>>2010's ~ 현재 게시물 관리</option>
					</select>
				</div> -->

				<div class="tbl_top">
					<div class="top_left">
						<span class="subTitle">실습지역</span>
					</div>
					<div class="top_right">
						<a class="btn_gray btn_gray100 btn_Add">+ 항목추가</a>
					</div>
				</div>

				<form name="appFrm" id="appFrm" method="post" style='margin:0' action="subjectSetupProc.asp">
				<input type='hidden' name='idx' value='<%=idx%>'>
				<table class="tbl_col box " id="stockTB">
					<colgroup>
						<col style="width: 6%" />
						<col style="" />
						<col style="width:200px" />
						<col style="width: 5%" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row">노출순서</th>
						<th scope="row">지역명</th>
						<th scope="row">수강료</th>
						<th scope="row">삭제</th>
					</tr>
					</thead>
					<tbody>
					<%=PT_ItemList%>
					</tbody>
				</table>
				<div class="tbl_bottom">
					<div class="top_left">
						<div class="imp">선택 드래그 하여 순서 변경이 가능합니다.</div>
					</div>
					<div class="top_right">
						<a class="btn_gray btn_gray100 btn_Add">+ 항목추가</a>
					</div>
				</div>

				<div class="subTitle">숙지사항</div>
				<div><textarea name="txtCon1" style="width:100%; height:150px; padding:10px;"><%=txtCon1%></textarea></div>

				<div class="subTitle">기타안내</div>
				<div><textarea name="txtCon2" style="width:100%; height:150px; padding:10px;"><%=txtCon2%></textarea></div>

				<% IF CStr(idx)="1" Then %>
				<div class="subTitle">수강신청안내</div>
				<div><textarea name="txtCon3" style="width:100%; height:150px; padding:10px;"><%=txtCon3%></textarea></div>
				<% End IF %>


				<% IF CStr(idx)="0" Then %>
				<div class="subTitle">수강신청 안내 (붉은 FONT로 표시되는 구문은 span 태그로 감싸주세요.)</div>
				<table class="tbl_col box " id="stockTB">
					<colgroup>
						<col style="width:200px" />
						<col style="" />
						<col style="width: 40%" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row">구분</th>
						<th scope="row">사회복지현장실습(3학점)</th>
						<th scope="row">세부 설명</th>
					</tr>
					</thead>
					<tbody>
					<tr>
						<th scope="row">개강일</th>
						<td scope="row"><textarea name="txtinfo1" style="width:100%; height:150px; padding:10px;"><%=txtinfo1%></textarea></td>
						<td scope="row"><textarea name="txtinfo2" style="width:100%; height:150px; padding:10px;"><%=txtinfo2%></textarea></td>
					</tr>
					<tr>
						<th scope="row">출석수업(세미나) 기간</th>
						<td scope="row"><textarea name="txtinfo3" style="width:100%; height:150px; padding:10px;"><%=txtinfo3%></textarea></td>
						<td scope="row"><textarea name="txtinfo4" style="width:100%; height:150px; padding:10px;"><%=txtinfo4%></textarea></td>
					</tr>
					<tr>
						<th scope="row">기관실습시간</th>
						<td scope="row"><textarea name="txtinfo5" style="width:100%; height:150px; padding:10px;"><%=txtinfo5%></textarea></td>
						<td scope="row"><textarea name="txtinfo6" style="width:100%; height:150px; padding:10px;"><%=txtinfo6%></textarea></td>
					</tr>
					<tr>
						<th scope="row">실습처 (기관실습 실시기관)</th>
						<td scope="row"><textarea name="txtinfo7" style="width:100%; height:150px; padding:10px;"><%=txtinfo7%></textarea></td>
						<td scope="row"><textarea name="txtinfo8" style="width:100%; height:150px; padding:10px;"><%=txtinfo8%></textarea></td>
					</tr>
					<tr>
						<th scope="row">실습기관 지도자</th>
						<td scope="row"><textarea name="txtinfo9" style="width:100%; height:150px; padding:10px;"><%=txtinfo9%></textarea></td>
						<td scope="row"><textarea name="txtinfo10" style="width:100%; height:150px; padding:10px;"><%=txtinfo10%></textarea></td>
					</tr>
					<tr>
						<th scope="row">납부방법</th>
						<td scope="row"><textarea name="txtinfo11" style="width:100%; height:150px; padding:10px;"><%=txtinfo11%></textarea></td>
						<td scope="row"><textarea name="txtinfo12" style="width:100%; height:150px; padding:10px;"><%=txtinfo12%></textarea></td>
					</tr>
					<tr>
						<th scope="row">신청자격</th>
						<td scope="row"><textarea name="txtinfo13" style="width:100%; height:150px; padding:10px;"><%=txtinfo13%></textarea></td>
						<td scope="row"><textarea name="txtinfo14" style="width:100%; height:150px; padding:10px;"><%=txtinfo14%></textarea></td>
					</tr>
					<tr>
						<th scope="row">성적배점</th>
						<td scope="row"><textarea name="txtinfo15" style="width:100%; height:150px; padding:10px;"><%=txtinfo15%></textarea></td>
						<td scope="row"><textarea name="txtinfo16" style="width:100%; height:150px; padding:10px;"><%=txtinfo16%></textarea></td>
					</tr>
					<tr>
						<th scope="row">신청방법</th>
						<td scope="row"><textarea name="txtinfo17" style="width:100%; height:150px; padding:10px;"><%=txtinfo17%></textarea></td>
						<td scope="row"><textarea name="txtinfo18" style="width:100%; height:150px; padding:10px;"><%=txtinfo18%></textarea></td>
					</tr>
					</tbody>
				</table>
				<% End IF %>
				</form>

				<table id="stockCopyArea" class="disNone">
					<tbody>
					<tr>
						<td class="orderBtnTD"><a class="orderDown"><img src="/backoffice/images/icon/bt_down.gif"></a> <a class="orderUp"><img src="/backoffice/images/icon/bt_up.gif"></a></td>
						<td><input type='text' name="areaNm" class="required" maxlength="20" reqTitle="지역명"></td>
						<td><input type='text' name="areaPrice" class="onlyNumber" maxlength="3" reqTitle="수강료" style="text-align:right; width:150px"> 만원</td>
						<td><input type='button' value="삭제" class="btn_red btn_Del" style='width:100%;'></td>
					</tr>
					</tbody>
				</table>

				<div class="btn_center pt30">
					<a href="javascript:sendit();" class="btn_largeG">저장하기</a>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->