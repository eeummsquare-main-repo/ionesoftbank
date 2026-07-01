<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
regDiv = uf_getRequest(Request("regDiv"),"int","3","0")
topMenuCode = "cont" : subMenuCode = "info"
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
	Sql = "SELECT idx, isDisplay, listnum, regdate, ARRIMGNM, regDiv, arr_title, arr_country, arr_company, arr_addr, arr_tel, arr_fax, arr_website, arr_email FROM infomation WHERE regDiv="&regDiv&" AND IDX="&Idx
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		idx = ChangeBlank(RS("idx"))
		isDisplay = ChangeBlank(RS("isDisplay"))
		listnum = ChangeBlank(RS("listnum"))
		regdate = ChangeBlank(RS("regdate"))
		regDiv = ChangeBlank(RS("regDiv"))
		ARRIMGNM = Split(ChangeBlank(RS("ARRIMGNM")),"|")

		arr_title = Split(ChangeBlank(RS("arr_title")),"^|^")
		arr_country = Split(ChangeBlank(RS("arr_country")),"^|^")
		arr_company = Split(ChangeBlank(RS("arr_company")),"^|^")
		arr_addr = Split(ChangeBlank(RS("arr_addr")),"^|^")
		arr_tel = Split(ChangeBlank(RS("arr_tel")),"^|^")
		arr_fax = Split(ChangeBlank(RS("arr_fax")),"^|^")
		arr_website = Split(ChangeBlank(RS("arr_website")),"^|^")
		arr_email = Split(ChangeBlank(RS("arr_email")),"^|^")
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

Function PT_HoTelData()
	IF isArray(arr_title) Then
		For i=0 To Ubound(arr_title)
			ON ERROR RESUME NEXT
			title = arr_title(i)
			country = arr_country(i)
			company = arr_company(i)
			addr = arr_addr(i)
			tel = arr_tel(i)
			fax = arr_fax(i)
			website = arr_website(i)
			email = arr_email(i)

			Response.Write "<div class=""hotelData"">"&Vbcrlf
			Response.Write "	<div><input type=""text"" name=""title"" maxlength=""200"" value="""&ReplaceTextField(title)&""" placeholder=""= 타이틀 ="" class=""reqField"" reqTitle=""타이틀""></div>"&Vbcrlf
			Response.Write "	<div class=""tit"">"&Vbcrlf
			Response.Write "		<input type=""text"" name=""country"" maxlength=""200"" value="""&ReplaceTextField(country)&""" placeholder=""= 국가 ="" class=""reqField"" reqTitle=""국가"">"&Vbcrlf
			Response.Write "		<input type=""text"" name=""company"" maxlength=""200"" value="""&ReplaceTextField(company)&""" placeholder=""= 업체명 ="" class=""reqField"" reqTitle=""업체명"">"&Vbcrlf
			Response.Write "	</div>"&Vbcrlf
			Response.Write "	<div class=""conts"">"&Vbcrlf
			Response.Write "		<input type=""text"" name=""addr"" maxlength=""200"" value="""&ReplaceTextField(addr)&""" placeholder=""= Address ="" class="""" reqTitle="""">"&Vbcrlf
			Response.Write "		<input type=""text"" name=""tel"" maxlength=""200"" value="""&ReplaceTextField(tel)&""" placeholder=""= Tel ="" class="""" reqTitle="""">"&Vbcrlf
			Response.Write "		<input type=""text"" name=""fax"" maxlength=""200"" value="""&ReplaceTextField(fax)&""" placeholder=""= Fax ="" class="""" reqTitle="""">"&Vbcrlf
			Response.Write "		<input type=""text"" name=""website"" maxlength=""200"" value="""&ReplaceTextField(website)&""" placeholder=""= Website ="" class="""" reqTitle="""">"&Vbcrlf
			Response.Write "		<input type=""text"" name=""email"" maxlength=""200"" value="""&ReplaceTextField(email)&""" placeholder=""= Email ="" class="""" reqTitle="""">"&Vbcrlf
			Response.Write "	</div>"&Vbcrlf
			Response.Write "	<button type=""button"" class=""btnHotelRemove"">X</button>"&Vbcrlf
			Response.Write "</div>"&Vbcrlf
			On Error goto 0
		Next
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<script LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	/* 적용호텔 추가 및 삭제 */
	$(document).on("click",".btnHotelRemove",function(){

		if ($(".content .hotelData").size()==1){
			$(".content .hotelData input").val("")
		}else{
			$(this).closest(".hotelData").remove();
		}
	});
	$(document).on("click",".btnHotelAdd",function(){
		var langDiv = $(this).attr("dataDiv");
		$("#hDataDiv").find("input[name=langDiv]").attr("value",langDiv)
		var html = $("#hDataDiv").html()
		$(this).closest(".hotelWrap").find(".content").append(html);
	});
	/* 적용호텔 추가 및 삭제 */

	if ($(".content .hotelData").size()==0){
		$(".btnHotelAdd").click();
	}
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
		$(".hotelWrap .content .hotelData").each(function(i){
			var no = i+1
			$(this).find(".diaryData input").attr("name", "h_dTitle_"+no)
			$(this).find(".diaryData textarea").attr("name", "h_dContent_"+no)
		});

		if (confirm('저장하시겠습니까?')){
			document.regFrm.submit();
		}
	}
}
//-->
</script>
<style>
.btnHotelAdd{display:inline-block; width:180px; height:30px; background-color: #00546c; font-size:12px; line-height:30px; color: #fff; text-align: center; z-index:5; border-radius:2px; box-sizing: border-box; cursor: pointer;}
.btnHotelAdd:hover{color:#fff;}
.btnHotelAdd:before{content: "+ ";}

.hotelWrap input, .hotelWrap select{height:30px; color:#000 !important;}
.hotelWrap textarea{color:#000;}
.hotelWrap .hotelData{position:relative; border:1px solid #bebebe; padding:10px; margin-top:10px; display:block; width:100%; overflow:hidden; box-sizing: border-box; -webkit-box-sizing: border-box; -moz-box-sizing: border-box;}
.hotelWrap .hotelData .conts{position:relative;}
.hotelWrap .hotelData .tit{display:flex; margin-bottom:5px; margin-top:5px;}
.hotelWrap .hotelData .tit input{margin-right:5px; display:inline-block; }
.hotelWrap .hotelData .tit input:last-child{margin-right:0px;}
.hotelWrap .hotelData input{min-width:400px;}
.hotelWrap .hotelData .tit input:last-child{width:100%;}
.hotelWrap .hotelData .conts input{width:100% !important; box-sizing: border-box; -webkit-box-sizing: border-box; -moz-box-sizing: border-box; margin-bottom:5px;}
.hotelWrap .hotelData .conts input:last-child{margin-bottom:0px;}
.hotelWrap .hotelData input{height:30px;}
.hotelWrap .hotelData .btnHotelRemove { cursor: pointer; font-size: 20px; position: absolute; right: 10px; top: 5px; }
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

				<div class="subTab mt20 mb20">
					<a href="<%=PageLink%>?regDiv=0" class="<%=iif_compare(regDiv, 0, "active")%>"><span>PHYCHIPS Information</span></a>
					<a href="<%=PageLink%>?regDiv=1" class="<%=iif_compare(regDiv, 1, "active")%>"><span>ASIA</span></a>
					<a href="<%=PageLink%>?regDiv=2" class="<%=iif_compare(regDiv, 2, "active")%>"><span>AMERICA</span></a>
					<a href="<%=PageLink%>?regDiv=3" class="<%=iif_compare(regDiv, 3, "active")%>"><span>EUROPE</span></a>
				</div>

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
	<tr>
		<th class="reqTitle">이미지</th>
		<td class="left">
			<div class="filesArea">
				<a href="javascript:void(0)" class="filePlus disNone" maxCnt="4" fNm="files" fDNm="filedel_idx"><span>파일추가</span></a>
			<% IF IsArray(ARRIMGNM) Then %>
				<% For FileCnt=0 To UBound(ARRIMGNM) %>
				<div class="file fileArea">
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부" class='fileField' reqTitle="이미지"></span>
					</span>
					<a class="thumb"></a>
					<p class="checkIn">
						<input type='checkbox' name='delchk' value='1' id="filedel_idx<%=FileCnt%>" dataVal="1" class="fileFieldChk">
						<label class="labelTxt ml10" for="filedel_idx<%=FileCnt%>">삭제</label>
						<input type='hidden' name='filedel_idx' value='0' class="fileDelidx">
						<input type='hidden' name='dbfiles' value='<%=ARRIMGNM(FileCnt)%>'>
					</p>
					<%=PT_FileThumbImgTag(ARRIMGNM(FileCnt), "infomation")%>
					<span class="fDBArea">첨부파일 (<a href="/_lib/download.asp?path=infomation&downfile=<%=ARRIMGNM(FileCnt)%>" class="ellipsis"><%=ReplaceNoHtml(ARRIMGNM(FileCnt))%></a>)</span>
				</div>
				<% Next%>
			<% End IF %>
			<% IF FileCnt=0 Then %>
				<div class="file">
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부" class='fileField' reqTitle="이미지"/></span>
					</span>
					<a class="thumb"></a>
					<input type='hidden' name='filedel_idx' value='1' class="fileDelidx">
					<input type='hidden' name='dbfiles' value=''>
				</div>
			<% End IF %>
			</div>
		</td>
	</tr>
</table>

<div class="mt10 hotelWrap">
	<div style="text-align:right;">
		<a class="btnHotelAdd" dataDiv="1"><span>추가하기</span></a>
	</div>

	<div class="content">
		<%=PT_HoTelData()%>
	</div>
</div>
</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit();" class="btn_largeG">저장하기</a>
					<a href="<%=PageLink%>?page=<%=page%>&<%=PageStr%>" class="btn_largeW">목록보기</a>
				</div>

<div id="hDataDiv" class="disNone">
	<div class="hotelData">
		<div><input type="text" name="title" maxlength="200" value="" placeholder="= 타이틀 =" class="reqField" reqTitle="타이틀"></div>
		<div class="tit">
			<input type="text" name="country" maxlength="200" value="" placeholder="= 국가 =" class="reqField" reqTitle="국가">
			<input type="text" name="company" maxlength="200" value="" placeholder="= 업체명 =" class="reqField" reqTitle="업체명">
		</div>
		<div class="conts">
			<input type="text" name="addr" maxlength="200" value="" placeholder="= Address =" class="" reqTitle="">
			<input type="text" name="tel" maxlength="200" value="" placeholder="= Tel =" class="" reqTitle="">
			<input type="text" name="fax" maxlength="200" value="" placeholder="= Fax =" class="" reqTitle="">
			<input type="text" name="website" maxlength="200" value="" placeholder="= Website =" class="" reqTitle="">
			<input type="text" name="email" maxlength="200" value="" placeholder="= Email =" class="" reqTitle="">
		</div>
		<button type="button" class="btnHotelRemove">X</button>
	</div>
</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->