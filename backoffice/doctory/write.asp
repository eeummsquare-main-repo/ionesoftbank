<!--#include file = ../_lib/common.asp-->
<!--#include file = ../../_lib/dbcon.asp-->
<%
serDiv = uf_getRequest(Request("serDiv"),"int","7","0")
topMenuCode = "company" : subMenuCode = "doctor"
%>
<!--#include file = ../_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
serisDisplay = uf_getRequest(Request("serisDisplay"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "index.asp"
PageStr = "serDiv="&serDiv&"&serisDisplay="&serisDisplay&"&searchStr="&Server.UrlEncode(oSearchStr)
'=============================================

IDX = uf_getRequest(Request("idx"),"int","","")

IF Idx<>"" Then
	Sql = "SELECT idx, regdate, isDisplay, proDiv, title, titleEng, thumbCont, content, content1, content2, arrImgNm, edNonce, mSchdule, aSchdule FROM doctory WHERE proDiv="&serDiv&" AND IDX="&Idx
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		idx = ChangeBlank(RS("idx"))
		regdate = ChangeBlank(RS("regdate"))
		isDisplay = ChangeBlank(RS("isDisplay"))
		proDiv = ChangeBlank(RS("proDiv"))
		title = ChangeBlank(RS("title"))
		titleEng = ChangeBlank(RS("titleEng"))
		thumbCont = ChangeBlank(RS("thumbCont"))
		content = ChangeBlank(RS("content"))
		content1 = ChangeBlank(RS("content1"))
		content2 = ChangeBlank(RS("content2"))
		edNonce = ChangeBlank(RS("edNonce"))
		mSchdule = ChangeBlank(RS("mSchdule"))
		aSchdule = ChangeBlank(RS("aSchdule"))

		arrImgNm = ChangeBlank(RS("arrImgNm"))
		IF arrImgNm<>"" Then ARRIMGNM = Split(ChangeBlank(RS("arrImgNm")),"|")

		IF mSchdule<>"" Then arr_mSchdule = Split(mSchdule,",")
		IF aSchdule<>"" Then arr_aSchdule = Split(aSchdule,",")
	Else
		idx = ""
	End IF
End IF

'###### 에디터 ID 생성 ##########
IF edNonce="" Then
	edNonce = GetEdNonce()
End IF
'###### 에디터 ID 생성 ##########

SEt Rs=Nothing
DBcon.Close
Set DBcon=Nothing

IF Not(isArray(arr_mSchdule)) Then Dim arr_mSchdule(4)
IF Not(isArray(arr_aSchdule)) Then Dim arr_aSchdule(4)
IF Ubound(arr_mSchdule)<4 Then ReDim arr_mSchdule(4)
IF Ubound(arr_aSchdule)<4 Then ReDim arr_aSchdule(4)
%>

<!--#include file = ../common/head.asp-->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<script LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	$("select").each(function(i) {
		var color = $(this).children("option:selected").css("color")
		$(this).css("color", color)
	});

	$('select').change(function() {
		var color = $(this).children("option:selected").css("color")
		$(this).css("color", color)
	});
});

function sendit(){
	var date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
	var requiredFlag = true;
	var f = document.regFrm;

	$('#regFrm .reqField').each(function(){
		itemTitle = $(this).attr("reqTitle")

		if ( $(this).is(':text, password, textarea, select') && $(this).val().length < 1 ) {
			alert('['+itemTitle+']는 필수 입력항목 입니다.');
			$(this).focus();
			requiredFlag = false;
			return false;
		}else if ( $(this).is(':file') && $(this).val().length < 1 && $(this).closest(".file").find(".fileDelidx").val()=="1"  ) {
			alert('['+itemTitle+']는 필수 업로드항목 입니다.');
			$(this).focus();
			requiredFlag = false;
			return false;
		}else if ( $(this).is(':checkbox') ) {
			attrName = $(this).attr("name")
			if($("input:checkbox[name="+attrName+"]:checked").length==0) {
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
		$('.datepicker').each(function(){
			itemTitle = $(this).attr("reqTitle")
			itemVal = $(this).val()

			if (itemVal!="" && !date_pattern.test(itemVal)){
				alert("날짜 입력형식 오류! YYYY-MM-DD 형식으로 입력해주세요.")
				$(this).focus();
				requiredFlag = false;
				return false;
			}
		});
	}

	if( requiredFlag == true ) {
		if (confirm('저장하시겠습니까?')){
			document.regFrm.submit();
		}
	}
}
//-->
</script>
<style>
.workdiary{clear:both; position:relative; width:100%;}
.workdiary .diaryData{display:flex; width:calc(100% - 80px); margin-bottom:5px}
.workdiary .diaryData *{margin-right:5px; display:inline-block; }
.workdiary .diaryData:last-child{margin-bottom:0px}
.workdiary .btnRemove{min-width:80px; height:30px; background-color: #770000; font-size:12px; line-height:30px; color: #fff; text-align: center; border-radius:2px; box-sizing: border-box; cursor: pointer;}
.workdiary .btnRemove:before{content: "- ";}
.workdiary input{max-width:200px; height:30px;}
.workdiary textarea{height:80px;}
.workdiary .btnDiaryAdd{width:80px; height:30px; background-color: #2e6c00; font-size:12px; line-height:30px; color: #fff; text-align: center; position: absolute; right:0px; top:0; z-index:5; border-radius:2px; box-sizing: border-box; cursor: pointer;}
.workdiary .btnDiaryAdd:before{content: "+ ";}

.tbl_row input, .tbl_row select{height:30px; color:#000;}
.tbl_row textarea{color:#000;}

.md__table{border-bottom:1px solid #e5e5e5; border-right:1px solid #e5e5e5; width:100%}
.md__table table{width:100%;}
.md__table select{width:100%}
</style>
</head>

<body>
	<div id="wrap">
		<!--#include file = ../common/header.asp-->

		<div id="container">
			<!--#include file = ../common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

<form action="proc.asp" method="post" name="regFrm" id="regFrm" enctype="multipart/form-data" target="actFrame">
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='page' value='<%=page%>'>
<input type='hidden' name='pagesize' value='<%=pagesize%>'>
<input type='hidden' name='serisDisplay' value='<%=serisDisplay%>'>
<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
<input type='hidden' name='serDiv' value='<%=serDiv%>'>
<input type='hidden' name='edNonce' value='<%=edNonce%>'>
<table class="tbl_row box mt20">
<colgroup>
	<col width="15%" />
	<col width="" />
</colgroup>
	<tr>
		<th class="reqTitle">노출여부</th>
		<td class="left">
			<select name="isDisplay">
				<option value="1" <%=selCheck(isDisplay,1)%>>노출</option>
				<option value="0" <%=selCheck(isDisplay,0)%>>비노출</option>
			</select>
		</td>
	</tr>
	<tr>
		<th>등록일</th>
		<td>
			<div class="date_wrap">
				<input type="text" name="regdate" class="datepicker" maxlength='10' value="<%=regdate%>" placeholder="YYYY-MM-DD" />
				<span class="imp ml10">미 입력시 현재일자 자동 입력</span>
			</div>
		</td>
	</tr>
	<tr>
		<th class="reqTitle">이름</th>
		<td class="left">
			<input name="title" type="text" maxlength='50' value='<%=ReplaceTextField(title)%>' class="reqField" reqTitle="이름">
		</td>
	</tr>
	<tr>
		<th class="reqTitle">이름(영문)</th>
		<td class="left">
			<input name="titleEng" type="text" maxlength='50' value='<%=ReplaceTextField(titleEng)%>' class="reqField" reqTitle="이름(영문)">
		</td>
	</tr>
	<tr>
		<th class="reqTitle">전문분야</th>
		<td class="left">
			<input name="thumbCont" type="text" maxlength='100' value='<%=ReplaceTextField(thumbCont)%>' class="" reqTitle="">
		</td>
	</tr>
	<tr>
		<th class="reqTitle">대표이미지<div class="imp">(500px * 500px)</div></th>
		<td class="left">
			<div class="filesArea">
				<a href="javascript:void(0)" class="filePlus disNone" maxCnt="4" fNm="imgfiles" fDNm="imgfiledel_idx"><span>파일추가</span></a>
			<% IF IsArray(ARRIMGNM) Then %>
				<% For i=0 To UBound(ARRIMGNM) %>
				<div class="file fileArea">
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="imgfiles" title="파일첨부" class='fileField' reqTitle=""></span>
					</span>
					<a class="thumb"></a>
					<p class="checkIn">
						<input type='checkbox' name='delchk' value='1' id="imgfiledel_idx<%=i%>" dataVal="1" class="fileFieldChk">
						<label class="labelTxt ml10" for="imgfiledel_idx<%=i%>">삭제</label>
						<input type='hidden' name='imgfiledel_idx' value='0' class="fileDelidx">
						<input type='hidden' name='imgdbfiles' value='<%=ARRIMGNM(i)%>'>
					</p>
					<%=PT_FileThumbImgTag(ARRIMGNM(i), "doctory")%>
					<span class="fDBArea">첨부파일 (<a href="../../_lib/download.asp?path=doctory&downfile=<%=ARRIMGNM(i)%>" class="ellipsis"><%=ReplaceNoHtml(ARRIMGNM(i))%></a>)</span>
				</div>
				<% Next%>
			<% Else %>
				<div class="file">
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="imgfiles" title="파일첨부"/></span>
					</span>
					<a class="thumb"></a>
					<input type='hidden' name='imgfiledel_idx' value='1'>
					<input type='hidden' name='imgdbfiles' value=''>
				</div>
			<% End IF %>
			</div>
		</td>
	</tr>

	<tr>
		<th>진료일정</th>
		<td class='left'>

			<div class="md__table">
				<table>
					<thead>
						</thead><colgroup>
							<col width="14%">
							<col width="14%">
							<col width="14%">
							<col width="14%">
							<col width="14%">
							<col width="14%">
						</colgroup>
						<tbody><tr>
							<th>시간</th>
							<th>월</th>
							<th>화</th>
							<th>수</th>
							<th>목</th>
							<th>금</th>
						</tr>
					
					</tbody><tbody>
						<tr>
							<th>오전</th>
							<td>
								<select name="mSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_mSchdule(0), "1")%>>진료</option>
								</select>
							</td>
							<td>
								<select name="mSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_mSchdule(1), "1")%>>진료</option>
								</select>
							</td>
							<td>
								<select name="mSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_mSchdule(2), "1")%>>진료</option>
								</select>
							</td>
							<td>
								<select name="mSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_mSchdule(3), "1")%>>진료</option>
								</select>
							</td>
							<td>
								<select name="mSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_mSchdule(4), "1")%>>진료</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>오후</th>
							<td>
								<select name="aSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_aSchdule(0), "1")%>>진료</option>
								</select>
							</td>
							<td>
								<select name="aSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_aSchdule(1), "1")%>>진료</option>
								</select>
							</td>
							<td>
								<select name="aSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_aSchdule(2), "1")%>>진료</option>
								</select>
							</td>
							<td>
								<select name="aSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_aSchdule(3), "1")%>>진료</option>
								</select>
							</td>
							<td>
								<select name="aSchdule">
									<option value="0" style='color:#000;'>휴진</option>
									<option value="1" style='color:#ca0000;' <%=selCheck(arr_aSchdule(4), "1")%>>진료</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

		</td>
	</tr>
	<tr>
		<th class="reqTitle">학력</th>
		<td class="left">
			<textarea name="content" class="relativeTxtBox"><%=content%></textarea>
		</td>
	</tr>
	<tr>
		<th class="reqTitle">경력</th>
		<td class="left">
			<textarea name="content1" class="relativeTxtBox"><%=content1%></textarea>
		</td>
	</tr>
	<tr>
		<th class="reqTitle">학회</th>
		<td class="left">
			<textarea name="content2" class="relativeTxtBox"><%=content2%></textarea>
		</td>
	</tr>
</table>
</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit();" class="btn_largeG">저장하기</a>
					<a href="<%=PageLink%>?<%=PageStr%>" class="btn_largeW">목록보기</a>
				</div>
			</div>
		</div>
	</div>
<!--#include file = ../common/bottom.asp-->