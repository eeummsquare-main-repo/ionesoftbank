<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
langmode = uf_getRequest(Request("langmode"), "int", "1", "0")
topMenuCode = "company" : subMenuCode = "history"
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'=====form 전송을 위한 변수 셋팅============================
regdiv = uf_getRequest(Request("regdiv"), "int", "3", "0")
PageLink = "index.asp"
PageStr = "langmode="&langmode&"&regdiv="& regdiv
'=====form 전송을 위한 변수 셋팅============================

Sql = "SELECT IDX, SYEAR, SMONTH, TITLE FROM historyAdmin WHERE langmode="&langmode&" AND regdiv="&regdiv&" "&strWhere&" Order By listNum ASC, idx ASC"
Set Rs = DBCon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_ItemList
	Dim i,Num
	Num=1

	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			LOOP_IDX = ChangeBlank(Allrec(0,i))
			LOOP_SYEAR = ChangeBlank(Allrec(1,i))
			LOOP_SMONTH = ChangeBlank(Allrec(2,i))
			LOOP_TITLE = ChangeBlank(Allrec(3,i))

			Response.Write "<tr id=""tr_"&i&""">"&Vbcrlf
			Response.Write "	<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a></td>"&Vbcrlf
			Response.Write "	<td><input type='text' name=""sYear"" class=""required onlyNumber"" maxlength=""4"" reqTitle=""년도"" value="""&ReplaceTextField(LOOP_SYEAR)&""" style=""text-align:right""></td>"&Vbcrlf
			'Response.Write "	<td><input type='text' name=""sMonth"" class=""onlyNumber"" maxlength=""2"" reqTitle=""월"" value="""&AddZero(LOOP_SMONTH)&""" style=""text-align:right""></td>"&Vbcrlf
			Response.Write "	<td><input type='text' name=""Title"" class=""required"" maxlength=""200"" reqTitle=""내용"" value="""&ReplaceTextField(LOOP_TITLE)&"""></td>"&Vbcrlf
			Response.Write "	<td><input type='button' value=""삭제"" class=""btn_red btn_Del"" style='width:100%;'></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr id=""tr_0"">"&Vbcrlf
		Response.Write "	<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a></td>"&Vbcrlf
		Response.Write "	<td><input type='text' name=""sYear"" class=""required onlyNumber"" maxlength=""4"" reqTitle=""년도"" value="""&ReplaceTextField(LOOP_SYEAR)&""" style=""text-align:right""></td>"&Vbcrlf
		'Response.Write "	<td><input type='text' name=""sMonth"" class=""onlyNumber"" maxlength=""2"" reqTitle=""월"" value="""&ReplaceTextField(LOOP_SMONTH)&""" style=""text-align:right""></td>"&Vbcrlf
		Response.Write "	<td><input type='text' name=""Title"" class=""required"" maxlength=""200"" reqTitle=""내용"" value="""&ReplaceTextField(LOOP_TITLE)&"""></td>"&Vbcrlf
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
					<a href="?langmode=0" class="<%=iif_compare(langmode, 0, "active")%>"><span>KR</span></a>
					<a href="?langmode=1" class="<%=iif_compare(langmode, 1, "active")%>"><span>EN</span></a>
				</div>

				<!-- <div style='clear:both;'>
					<select name='regdiv' style='width:100%; background-Color: #000; color:#fff; font-size:14px; padding:5px; height:auto;' onchange="location.href='?langmode=<%=langmode%>&regdiv='+this.value;">
						<option value='0' <%=SelCheck(0, regdiv)%>>2020s 게시물 관리</option>
						<option value='1' <%=SelCheck(1, regdiv)%>>2010s 게시물 관리</option>
						<option value='2' <%=SelCheck(2, regdiv)%>>2000s 게시물 관리</option>
						<option value='3' <%=SelCheck(3, regdiv)%>>1989 to 1990s 게시물 관리</option>
					</select>
				</div> -->

				<div class="tbl_top">
					<div class="top_right">
						<a class="btn_gray btn_gray100 btn_Add">+ 항목추가</a>
					</div>
				</div>

				<form name="appFrm" id="appFrm" method="post" style='margin:0' action="proc.asp">
				<input type='hidden' name='regdiv' value='<%=regdiv%>'>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<table class="tbl_col box " id="stockTB">
					<colgroup>
						<col style="width: 6%" />
						<col style="width: 100px" />
						<!-- <col style="width: 100px" /> -->
						<col style="*" />
						<col style="width: 5%" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row">노출순서</th>
						<th scope="row">YEAR</th>
						<!-- <th scope="row">MONTH</th> -->
						<th scope="row">내용</th>
						<th scope="row">삭제</th>
					</tr>
					</thead>
					<tbody>
					<%=PT_ItemList%>
					</tbody>
				</table>
				</form>

				<div class="tbl_bottom">
					<div class="top_left">
						<div class="imp">선택 드래그 하여 순서 변경이 가능합니다.</div>
					</div>
					<div class="top_right">
						<a class="btn_gray btn_gray100 btn_Add">+ 항목추가</a>
					</div>
				</div>

				<table id="stockCopyArea" class="disNone">
					<tbody>
					<tr>
						<td class="orderBtnTD"><a class="orderDown"><img src="/backoffice/images/icon/bt_down.gif"></a> <a class="orderUp"><img src="/backoffice/images/icon/bt_up.gif"></a></td>
						<td><input type='text' name="sYear" class="required onlyNumber" maxlength="4" reqTitle="년도" style="text-align:right"></td>
						<!-- <td><input type='text' name="sMonth" class="onlyNumber" maxlength="2" reqTitle="월" style="text-align:right"></td> -->
						<td><input type='text' name="Title" class="required" maxlength="200" reqTitle="내용"></td>
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