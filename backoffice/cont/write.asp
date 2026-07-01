<!--#include file = ../_lib/common.asp-->
<!--#include file = ../../_lib/dbcon.asp-->
<%
serDiv = uf_getRequest(Request("serDiv"),"int","7","0")
topMenuCode = "company" : subMenuCode = "sub01"
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
	Sql = "SELECT idx, regdate, isDisplay, proDiv, title, content, revinfoTits, revinfoCons, arrImgNm, arrFileNm, edNonce, zipcode, addr1, addr2 FROM project WHERE proDiv="&serDiv&" AND IDX="&Idx
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		idx = ChangeBlank(RS("idx"))

		regdate = ChangeBlank(RS("regdate"))
		isDisplay = ChangeBlank(RS("isDisplay"))
		proDiv = ChangeBlank(RS("proDiv"))
		title = ChangeBlank(RS("title"))
		content = ChangeBlank(RS("content"))
		revinfoTits = Split(ChangeBlank(RS("revinfoTits")),"|")
		revinfoCons = Split(ChangeBlank(RS("revinfoCons")),"|")
		edNonce = changeBlank(Rs("edNonce"))
		zipcode = changeBlank(Rs("zipcode"))
		addr1 = changeBlank(Rs("addr1"))
		addr2 = changeBlank(Rs("addr2"))

		arrImgNm = ChangeBlank(RS("arrImgNm"))
		arrFileNm = ChangeBlank(RS("arrFileNm"))

		IF arrImgNm<>"" Then ARRIMGNM = Split(ChangeBlank(RS("arrImgNm")),"|")
		IF arrFileNm<>"" Then ARRFILENM = Split(ChangeBlank(RS("arrFileNm")),"|")
	Else
		idx = ""
	End IF
End IF

IF idx="" Then
'	Dim revinfoTits(8), revinfoCons(8)
'	IF revinfoTits(0)="" Then revinfoTits(0)="위치"
'	IF revinfoTits(1)="" Then revinfoTits(1)="대지면적"
'	IF revinfoTits(2)="" Then revinfoTits(2)="연면적"
'	IF revinfoTits(3)="" Then revinfoTits(3)="건폐율"
'	IF revinfoTits(4)="" Then revinfoTits(4)="용적율"
'	IF revinfoTits(5)="" Then revinfoTits(5)="건축규모"
'	IF revinfoTits(6)="" Then revinfoTits(6)="세대수"
'	IF revinfoTits(7)="" Then revinfoTits(7)="공사기간"
'	IF revinfoTits(8)="" Then revinfoTits(8)="시공사"
End IF

'###### 에디터 ID 생성 ##########
IF edNonce="" Then
	edNonce = GetEdNonce()
End IF
'###### 에디터 ID 생성 ##########

SEt Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function detailList()
	IF isArray(revinfoTits) Then
		For i=0 To Ubound(revinfoTits)
			Response.Write "<div class=""diaryData"">"&Vbcrlf
			Response.Write "	<input type=""text"" name=""revinfoTit"" maxlength=""2"" class=""onlyNumber"" value="""&ReplaceTextField(revinfoTits(i))&""" placeholder=""=월 입력="">"&Vbcrlf
			Response.Write "	<input type=""text"" name=""revinfoCon"" maxlength=""100"" class="""" style=""max-width:692px !important; width:100%;"" placeholder=""=내용 입력="" value="""&ReplaceTextField(revinfoCons(i))&""">"&Vbcrlf
			Response.Write "	<button type=""button"" class=""btnRemove"">삭제</button>"&Vbcrlf
			Response.Write "</div>"&Vbcrlf
		Next
	Else
		Response.Write "<div class=""diaryData"">"&Vbcrlf
		Response.Write "	<input type=""text"" name=""revinfoTit"" maxlength=""2"" class=""onlyNumber"" placeholder=""=월 입력="">"&Vbcrlf
		Response.Write "	<input type=""text"" name=""revinfoCon"" maxlength=""100"" class="""" style=""max-width:692px !important; width:100%;"" placeholder=""=내용 입력="" value="""">"&Vbcrlf
		Response.Write "	<button type=""button"" class=""btnRemove"">삭제</button>"&Vbcrlf
		Response.Write "</div>"&Vbcrlf
	End IF
End Function
%>

<!--#include file = ../common/head.asp-->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<script LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	/* 부가정보 추가 및 삭제 */
	$(document).on("click",".btnRemove",function(){

		if ($(this).closest(".workdiary").find("div").size()=="1"){
			$(this).closest(".workdiary").find("textarea,input").val("");
		}else{
			$(this).closest("div").remove();
		}
	});

	$(document).on("click",".btnDiaryAdd",function(){
		var html = $("#copyDiv").html()
		$(this).closest(".workdiary").append(html);
	});
	/* 부가정보 추가 및 삭제 */
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

.tbl_row input, .tbl_row select{height:30px; color:#000 !important;}
.tbl_row textarea{color:#000;}
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
		<th class="reqTitle">년도</th>
		<td class="left">
			<input name="title" type="text" maxlength='4' value='<%=ReplaceTextField(title)%>' class="onlyNumber reqField" reqTitle="년도">
		</td>
	</tr>
	<tr>
		<th class="reqTitle">내용</th>
		<td class="left">
			<div class="workdiary">
				<a class="btnDiaryAdd"><span>추가</span></a>
				<%=detailList()%>
			</div>
			<div class="imp mt5">목록페이지에 노출되는 정보입니다.</div>
		</td>
	</tr>
	<tr>
		<th class="reqTitle">대표이미지<div class="imp">(540px * 320px)</div></th>
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
					<%=PT_FileThumbImgTag(ARRIMGNM(i), "project")%>
					<span class="fDBArea">첨부파일 (<a href="../../_lib/download.asp?path=project&downfile=<%=ARRIMGNM(i)%>" class="ellipsis"><%=ReplaceNoHtml(ARRIMGNM(i))%></a>)</span>
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
</table>
</form>

<div id="copyDiv" class="disNone">
	<div class="diaryData">
		<input type="text" name="revinfoTit" maxlength="2" class="onlyNumber" placeholder="=월 입력=">
		<input type="text" name="revinfoCon" maxlength="100" class="" style="max-width:692px !important; width:100%;" placeholder="=내용 입력=" value="">
		<button type="button" class="btnRemove">삭제</button>
	</div>
</div>

				<div class="btn_center pt30">
					<a href="javascript:sendit();" class="btn_largeG">저장하기</a>
					<a href="<%=PageLink%>?<%=PageStr%>" class="btn_largeW">목록보기</a>
				</div>
			</div>
		</div>
	</div>
<!--#include file = ../common/bottom.asp-->