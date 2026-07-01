<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
regDiv = uf_getRequest(Request("regDiv"),"int","3","0")

topMenuCode = "admin" : subMenuCode = "partner"
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

page = uf_getRequest(Request("page"),"int","","")
pageSize = uf_getRequest(Request("pageSize"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "index.asp"
PageStr = "regDiv="&regDiv&"&seritem="&seritem&"&pagesize="&PageSize&"&searchStr="&Server.UrlEncode(oSearchStr)
'=============================================

IDX = uf_getRequest(Request("idx"),"int","","")

IF Idx<>"" Then
	Sql = "SELECT idx, title, isDisplay, listnum, regdate, ARRIMGNM, linkurl, edNonce, content, regDiv FROM partner WHERE regDiv="&regDiv&" AND IDX="&Idx
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		idx = ChangeBlank(RS("idx"))
		title = ChangeBlank(RS("title"))
		isDisplay = ChangeBlank(RS("isDisplay"))
		listnum = ChangeBlank(RS("listnum"))
		regdate = ChangeBlank(RS("regdate"))
		regDiv = ChangeBlank(RS("regDiv"))

		linkurl = ChangeBlank(RS("linkurl"))
		edNonce = ChangeBlank(RS("edNonce"))
		content = ChangeBlank(RS("content"))
		ARRIMGNM = Split(ChangeBlank(RS("ARRIMGNM")),"|")
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
%>

<!--#include virtual = backoffice/common/head.asp-->
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
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
			itemTitle = $(this).closest("tr").find(".reqTitle").html()
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
</SCRIPT>
<style>
.tbl_col td{position:relative;}
.sResultPart{position:absolute; top:30px; left:-1px; background-color:#fff; border:1px solid #e0e0e0; width:100%; text-align:left; z-index:9; height:100px;}
.pNm{text-align:left !important; padding-left:10px !important;}
#stockTB input{text-align:center;}
</style>
</head>

<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<!-- <div class="subTab mt20 mb20">
					<a href="?regDiv=0" class="<%=iif_compare(regDiv, 0, "active")%>"><span>CVS</span></a>
					<a href="?regDiv=1" class="<%=iif_compare(regDiv, 1, "active")%>"><span>Hyper/Sumermarket</span></a>
					<a href="?regDiv=2" class="<%=iif_compare(regDiv, 2, "active")%>"><span>Online</span></a>
					<a href="?regDiv=3" class="<%=iif_compare(regDiv, 3, "active")%>"><span>Others</span></a>
				</div> -->

<form action="proc.asp?regDiv=<%=regDiv%>" method="post" name="regFrm" id="regFrm" enctype="multipart/form-data" target="actFrame">
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='page' value='<%=page%>'>
<input type='hidden' name='pagesize' value='<%=pagesize%>'>
<input type='hidden' name='seritem' value='<%=seritem%>'>
<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
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
	<!-- <tr>
		<th class="reqTitle">분류</th>
		<td class="left">
			<select name="regDiv">
				<option value="0" <%=selCheck(regDiv,0)%>>금융분야 - 증권</option>
				<option value="1" <%=selCheck(regDiv,1)%>>금융분야 - 은행</option>
				<option value="2" <%=selCheck(regDiv,2)%>>금융분야 - 보험</option>
				<option value="3" <%=selCheck(regDiv,3)%>>금융분야 - 신탁</option>
				<option value="4" <%=selCheck(regDiv,4)%>>건설분야</option>
				<option value="5" <%=selCheck(regDiv,5)%>>하가분야</option>
			</select>
		</td>
	</tr> -->
	
	<tr>
		<th class="reqTitle">제목</th>
		<td class="left">
			<input name="title" type="text" maxlength='100' value='<%=ReplaceTextField(title)%>' class="reqField" reqTitle="제목">
		</td>
	</tr>
	<tr>
		<th class="reqTitle">링크주소</th>
		<td class="left">
			<input name="linkurl" type="text" maxlength='100' value='<%=ReplaceTextField(linkurl)%>' placeholder="http:// 포함하여 입력해주세요.">
		</td>
	</tr>

	<tr>
		<th class="reqTitle">이미지</th>
		<td class="left">
			<div class="filesArea">
				<a href="javascript:void(0)" class="filePlus disNone" maxCnt="4" fNm="files" fDNm="filedel_idx"><span>파일추가</span></a>
			<% IF IsArray(ARRIMGNM) Then %>
				<% For i=0 To UBound(ARRIMGNM) %>
				<div class="file fileArea">
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부" class='fileField reqField' reqTitle="이미지"></span>
					</span>
					<a class="thumb"></a>
					<p class="checkIn">
						<input type='checkbox' name='delchk' value='1' id="filedel_idx<%=i%>" dataVal="1" class="fileFieldChk">
						<label class="labelTxt ml10" for="filedel_idx<%=i%>">삭제</label>
						<input type='hidden' name='filedel_idx' value='0' class="fileDelidx">
						<input type='hidden' name='dbfiles' value='<%=ARRIMGNM(i)%>'>
					</p>
					<%=PT_FileThumbImgTag(ARRIMGNM(i), "partner")%>
					<span class="fDBArea">첨부파일 (<a href="/_lib/download.asp?path=partner&downfile=<%=ARRIMGNM(i)%>" class="ellipsis"><%=ReplaceNoHtml(ARRIMGNM(i))%></a>)</span>
				</div>
				<% Next%>
			<% Else %>
				<div class="file">
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부" class='fileField reqField' reqTitle="이미지"/></span>
					</span>
					<a class="thumb"></a>
					<input type='hidden' name='filedel_idx' value='1' class="fileDelidx">
					<input type='hidden' name='dbfiles' value=''>
				</div>
			<% End IF %>
			<div class="imp mt10">이미지 최적사이즈 180px * 70px</div>
			</div>
		</td>
	</tr>

	<!-- <tr>
		<td colspan='2' class="disNone">
			<textarea name='content' id="content" rows='20' class="ckeditor5" style='width:99%'><%=Content%></textarea>
		</td>
	</tr> -->
</table>
</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit();" class="btn_largeG">저장하기</a>
					<a href="<%=PageLink%>?page=<%=page%>&<%=PageStr%>" class="btn_largeW">목록보기</a>
				</div>
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->