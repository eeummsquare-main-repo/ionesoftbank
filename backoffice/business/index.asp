<!--#include file = ../_lib/common.asp-->
<!--#include file = ../../_lib/dbcon.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","4","0")
langmode = uf_getRequest(Request("langmode"),"int","1","0")

IF idx=0 Then
	topMenuCode = "business" : subMenuCode = "cont1"
ElseIF idx=1 Then
	topMenuCode = "business" : subMenuCode = "cont2"
ElseIF idx=2 Then
	topMenuCode = "business" : subMenuCode = "cont3"
ElseIF idx=3 Then
	topMenuCode = "business" : subMenuCode = "cont4"
ElseIF idx=4 Then
	topMenuCode = "business" : subMenuCode = "cont5"
End IF
%>
<!--#include file = ../_lib/authCheck.asp-->
<%

Sql = "SELECT thumbCont, cont, fileNms, fileTits, detailFileNms, detailFileTits, detailFileLinks, detailFileLinkTargets FROM business WHERE idx="&idx&" AND langmode="&langmode
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	thumbCont = changeBlank(Rs("thumbCont"))
	cont = changeBlank(Rs("cont"))
	fileNms = changeBlank(Rs("fileNms"))
	fileTits = changeBlank(Rs("fileTits"))
	detailFileNms = changeBlank(Rs("detailFileNms"))
	detailFileTits = changeBlank(Rs("detailFileTits"))
	detailFileLinks = changeBlank(Rs("detailFileLinks"))
	detailFileLinkTargets = changeBlank(Rs("detailFileLinkTargets"))

	IF fileNms<>"" Then ARRFILENM = Split(ChangeBlank(RS("fileNms")),"|")
	IF fileTits<>"" Then arrFileTit = Split(ChangeBlank(RS("fileTits")),"|")

	IF detailFileNms<>"" Then d_ARRFILENM = Split(ChangeBlank(RS("detailFileNms")),"|")
	IF detailFileTits<>"" Then d_arrFileTit = Split(ChangeBlank(RS("detailFileTits")),"|")

	IF detailFileLinks<>"" Then d_arrFileLink = Split(ChangeBlank(RS("detailFileLinks")),"|")
	IF detailFileLinkTargets<>"" Then d_arrFileLinkTarget = Split(ChangeBlank(RS("detailFileLinkTargets")),"|")
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function detailList()
	IF arrTitle="" Then
		Response.Write "<div class=""diaryData"">"&Vbcrlf
		Response.Write "	<input type=""text"" name=""dTitle"" maxlength=""100"" class="""" value="""" placeholder="""">"&Vbcrlf
		Response.Write "	<textarea name=""dContent"" class=""textarea relativeTxtBox"" placeholder=""""></textarea>"&Vbcrlf
		Response.Write "	<button type=""button"" class=""btnRemove"">삭제</button>"&Vbcrlf
		Response.Write "</div>"&Vbcrlf
	Else
		arr_title = Split(arrTitle, "|")
		arr_Content = Split(arrContent, "|")

		For i=0 To Ubound(arr_title)
			dTitle = changeBlank(arr_title(i))
			dContent = changeBlank(arr_Content(i))

			IF dTitle<>"" OR dContent<>"" Then
				Response.Write "<div class=""diaryData"">"&Vbcrlf
				Response.Write "	<input type=""text"" name=""dTitle"" maxlength=""100"" class="""" value="""&ReplaceTextField(dTitle)&""" placeholder="""">"&Vbcrlf
				Response.Write "	<textarea name=""dContent"" class=""textarea relativeTxtBox"" placeholder="""">"&dContent&"</textarea>"&Vbcrlf
				Response.Write "	<button type=""button"" class=""btnRemove"">삭제</button>"&Vbcrlf
				Response.Write "</div>"&Vbcrlf
			End IF
		Next
	End IF
End Function

Function detailListEn()
	IF arrTitleEn="" Then
		Response.Write "<div class=""diaryData"">"&Vbcrlf
		Response.Write "	<input type=""text"" name=""dTitleEn"" maxlength=""100"" class="""" value="""" placeholder="""">"&Vbcrlf
		Response.Write "	<textarea name=""dContentEn"" class=""textarea relativeTxtBox"" placeholder=""""></textarea>"&Vbcrlf
		Response.Write "	<button type=""button"" class=""btnRemove"">삭제</button>"&Vbcrlf
		Response.Write "</div>"&Vbcrlf
	Else
		arr_title = Split(arrTitleEn, "|")
		arr_Content = Split(arrContentEn, "|")

		For i=0 To Ubound(arr_title)
			dTitle = changeBlank(arr_title(i))
			dContent = changeBlank(arr_Content(i))

			IF dTitle<>"" OR dContent<>"" Then
				Response.Write "<div class=""diaryData"">"&Vbcrlf
				Response.Write "	<input type=""text"" name=""dTitleEn"" maxlength=""100"" class="""" value="""&ReplaceTextField(dTitle)&""" placeholder="""">"&Vbcrlf
				Response.Write "	<textarea name=""dContentEn"" class=""textarea relativeTxtBox"" placeholder="""">"&dContent&"</textarea>"&Vbcrlf
				Response.Write "	<button type=""button"" class=""btnRemove"">삭제</button>"&Vbcrlf
				Response.Write "</div>"&Vbcrlf
			End IF
		Next
	End IF
End Function
%>

<!--#include file = ../common/head.asp-->
<style>
.tbl_row input, .tbl_row select{height:30px; color:#000 !important;}
.tbl_row textarea{color:#000;}

.tbl_row .filesArea .filePlusTit, .tbl_row .filesArea .dfilePlusTit{width:100px; height:30px; background-color: #2e6c00; font-size:12px; line-height:30px; color: #fff; text-align: center; position: absolute; right:0px; top:0; z-index:5; border-radius:2px; box-sizing: border-box; cursor: pointer;}
.tbl_row .filesArea .filePlusTit:before{content: "+ ";}
.tbl_row .filesArea .dfilePlusTit:before{content: "+ ";}

.filesArea .fileTit{width:300px !important; text-align:center; margin-right:5px; height:30px;}

.filesArea .dfileTit{width:350px !important; text-align:center; margin-right:5px; height:30px;}
.filesArea .dfileLink{width:350px !important; text-align:center; margin-right:5px; height:30px;}
.filesArea .info select{font-size:13px}
.filesArea .info{margin-bottom:5px;}
</style>

<script type="text/javascript">
$(window).load(function(){
	$(document).on("click",".dfilePlusTit",function(){
		var maxCnt = $(this).attr("maxCnt");
		var fFieldNm = $(this).attr("fNm");
		var fDFieldNm = $(this).attr("fDNm");

		var fileAddTag = "";
		fileAddTag = fileAddTag + "<div class=\"file\">"
		fileAddTag = fileAddTag + "	<div class=\"info\">"
		fileAddTag = fileAddTag + "		<input type=\"text\" name=\"dfileTit\" value=\"\" placeholder=\"=타이틀 입력=\" class=\"dfileTit\">"
		fileAddTag = fileAddTag + "		<input type=\"text\" name=\"dfileLink\" value=\"\" placeholder=\"=링크주소 입력=\" class=\"dfileLink\">"
		fileAddTag = fileAddTag + "		<select name=\"dfileLinkTarget\">"
		fileAddTag = fileAddTag + "			<option value=\"0\">현재창</option>"
		fileAddTag = fileAddTag + "			<option value=\"1\">새창</option>"
		fileAddTag = fileAddTag + "		</select>"
		fileAddTag = fileAddTag + "	</div>"
		fileAddTag = fileAddTag + "	<span class=\"file_wrap\">"
		fileAddTag = fileAddTag + "		<span class=\"btnFile\">파일첨부<input type=\"file\" name=\""+fFieldNm+"\" title=\"파일첨부\"/></span>"
		fileAddTag = fileAddTag + "	</span>"
		fileAddTag = fileAddTag + "	<a class=\"thumb\"></a>"
		fileAddTag = fileAddTag + "	<input type='hidden' name='"+fDFieldNm+"' value='1'>"
		fileAddTag = fileAddTag + "	<input type='hidden' name='db"+fFieldNm+"' value=''>"
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
});
</script>

<script LANGUAGE="JavaScript">
<!--
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

				<div class="subTab mt20 mb20">
					<a href="?idx=<%=idx%>&langmode=0" class="<%=iif_compare(langmode, 0, "active")%>"><span>KR</span></a>
					<a href="?idx=<%=idx%>&langmode=1" class="<%=iif_compare(langmode, 1, "active")%>"><span>EN</span></a>
				</div>

<form action="proc.asp" method="post" name="regFrm" id="regFrm" target="actFrame" enctype="multipart/form-data">
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='langmode' value='<%=langmode%>'>
<table class="tbl_row box">
<colgroup>
	<col width="15%" />
	<col width="" />
</colgroup>
	<tr>
		<th class="reqTitle">간략설명</th>
		<td class="left">
			<input name="thumbCont" type="text" maxlength='200' value='<%=ReplaceTextField(thumbCont)%>' class="" reqTitle="">
		</td>
	</tr>
	<tr>
		<th class="reqTitle">내용</th>
		<td class="left">
			<textarea name="cont" class="relativeTxtBox"><%=cont%></textarea>
		</td>
	</tr>

	<tr>
		<th class="reqTitle">이미지<div class="imp mt10">이미지 최적사이즈<br>1400px * 680px</div></th>
		<td class="left">
			<div class="filesArea">
				<a href="javascript:void(0)" class="filePlusTit" maxCnt="100" fNm="files" fDNm="filedel_idx"><span>파일추가</span></a>
			<% IF IsArray(ARRFILENM) Then %>
				<% For i=0 To UBound(ARRFILENM) %>
				<div class="file fileArea">
					<input type="text" name="fileTit" value="<%=arrFileTit(i)%>" placeholder="=타이틀 입력=" class="fileTit">
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부" class='fileField' reqTitle=""></span>
					</span>
					<a class="thumb"></a>
					<p class="checkIn">
						<input type='checkbox' name='delchk' value='1' id="filedel_idx<%=i%>" dataVal="1" class="fileFieldChk">
						<label class="labelTxt ml10" for="filedel_idx<%=i%>">삭제</label>
						<input type='hidden' name='filedel_idx' value='0' class="fileDelidx">
						<input type='hidden' name='dbfiles' value='<%=ARRFILENM(i)%>'>
					</p>
					<%=PT_FileThumbImgTag(ARRFILENM(i), "business")%>
					<span class="fDBArea">첨부파일 (<a href="../../_lib/download.asp?path=business&downfile=<%=ARRFILENM(i)%>" class="ellipsis"><%=ReplaceNoHtml(ARRFILENM(i))%></a>)</span>
				</div>
				<% Next%>
			<% Else %>
				<div class="file">
					<input type="text" name="fileTit" value="" placeholder="=타이틀 입력=" class="fileTit">
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부"/></span>
					</span>
					<a class="thumb"></a>
					<input type='hidden' name='filedel_idx' value='1'>
					<input type='hidden' name='dbfiles' value=''>
				</div>
			<% End IF %>
			</div>
		</td>
	</tr>


	<tr>
		<th class="reqTitle">설치사진<div class="imp mt10">이미지 최적사이즈<br>500px * 500px</div></th>
		<td class="left">
			<div class="filesArea">
				<a href="javascript:void(0)" class="dfilePlusTit" maxCnt="4" fNm="dfiles" fDNm="dfiledel_idx"><span>파일추가</span></a>
			<% IF IsArray(d_ARRFILENM) Then %>
				<% For i=0 To UBound(d_ARRFILENM) %>
				<div class="file fileArea">
					<div class="info">
						<input type="text" name="dfileTit" value="<%=ReplaceTextField(d_arrFileTit(i))%>" placeholder="=타이틀 입력=" class="dfileTit">
						<input type="text" name="dfileLink" value="<%=ReplaceTextField(d_arrFileLink(i))%>" placeholder="=링크주소 입력=" class="dfileLink">
						<select name="dfileLinkTarget">
							<option value="0">현재창</option>
							<option value="1" <%=selCheck(d_arrFileLinkTarget(i), "1")%>>새창</option>
						</select>
					</div>

					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="dfiles" title="파일첨부" class='fileField' reqTitle=""></span>
					</span>
					<a class="thumb"></a>
					<p class="checkIn">
						<input type='checkbox' name='delchk' value='1' id="dfiledel_idx<%=i%>" dataVal="1" class="fileFieldChk">
						<label class="labelTxt ml10" for="dfiledel_idx<%=i%>">삭제</label>
						<input type='hidden' name='dfiledel_idx' value='0' class="fileDelidx">
						<input type='hidden' name='dbdfiles' value='<%=d_ARRFILENM(i)%>'>
					</p>
					<%=PT_FileThumbImgTag(d_ARRFILENM(i), "business")%>
					<span class="fDBArea">첨부파일 (<a href="../../_lib/download.asp?path=business&downfile=<%=d_ARRFILENM(i)%>" class="ellipsis"><%=ReplaceNoHtml(d_ARRFILENM(i))%></a>)</span>
				</div>
				<% Next%>
			<% Else %>
				<div class="file">
					<div class="info">
						<input type="text" name="dfileTit" value="" placeholder="=타이틀 입력=" class="dfileTit">
						<input type="text" name="dfileLink" value="" placeholder="=링크주소 입력=" class="dfileLink">
						<select name="dfileLinkTarget">
							<option value="0">현재창</option>
							<option value="1">새창</option>
						</select>
					</div>
					<span class="file_wrap">
						<span class="btnFile">파일첨부<input type="file" name="dfiles" title="파일첨부"/></span>
					</span>
					<a class="thumb"></a>
					<input type='hidden' name='dfiledel_idx' value='1'>
					<input type='hidden' name='dbdfiles' value=''>
				</div>
			<% End IF %>
			</div>
		</td>
	</tr>
</table>
</form>

<form name="actFrm" id="actFrm" class="" method="get" target="actFrame">
<input type='hidden' name="procMode" value="">
</form>

<div class="btn_center pt30">
	<a href="javascript:sendit();" class="btn_largeG">저장하기</a>
</div>

			</div>
		</div>
	</div>
<!--#include file = ../common/bottom.asp-->