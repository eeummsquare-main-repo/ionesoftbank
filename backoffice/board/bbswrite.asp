<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode
BBSCode=Request("BBscode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec, Idx, TitleTag, Sort
Dim Ref, Relevel, BBsSort
Dim BoardSort
Dim TopYN, Content, Title, Writer, Page, FileName, FileName1, imgNames
Dim startdate, enddate, vodUrl, note1, note2, note3, status, editorYN
Dim FileRec, i

Idx = uf_getRequest(Request("idx"),"int","","")

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serDate1, serdate2

page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("pageSize"),"int","","")
serstatus = uf_getRequest(Request("serstatus"),"int","","")
serisDisplay = uf_getRequest(Request("serisDisplay"),"int","","")
serismain = uf_getRequest(Request("serismain"),"int","","")
serboardsort = uf_getRequest(Request("serboardsort"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serCate1=uf_getRequest(Request("serCate1"),"char","","")
serCate2=uf_getRequest(Request("serCate2"),"char","","")
serCate3=uf_getRequest(Request("serCate3"),"char","","")
oSearchStr = Request("searchstr")

PageLink="bbslist.asp"
PageStr="BBscode="&BBscode&"&pagesize="&PageSize&"&serstatus="&serstatus&"&serisDisplay="&serisDisplay&"&serismain="&serismain&"&serboardsort="&serboardsort&"&serDate1="&serDate1&"&serdate2="&serdate2&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)

IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then
	IF serCate1<>"" Then PageStr = PageStr & "&serCate1="&serCate1
	IF serCate2<>"" Then PageStr = PageStr & "&serCate2="&serCate2
	IF serCate3<>"" Then PageStr = PageStr & "&serCate3="&serCate3
End IF
'=============================================

'===========BBS 언어 그룹 리스트=============
Sql="select idx, langIndex from boardAdmin WHERE subMenuCode='"&subMenuCode&"' Order By idx ASC"
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then bbsGroupRec=Rs.GetRows
Rs.Close
'===========================================

IF Idx<>"" Then
	Sql="SELECT cate1, cate2, cate3, title, content, writer, ReLevel, boardsort, imgNames, ref, topyn, isimp, startdate, enddate, VodUrl, status, editorYN, publicYN, artistidx, testFile1, testFile2, testFile3, viewdate, note1, note2, note3, note4, note5, note6, note7, note8, note9, note10, note11, note12, note13, thumbContent ,linkurl, readnum, isDisplay, setYear, isMain, CateCode, filteridx, bdiv1, bdiv2, bFilenames, aFilenames, edNonce, always, deadline, newwin1, newwin2 FROM BBsList WHERE idx="&idx

	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		cate1 = changeBlank(Rs("cate1"))
		cate2 = changeBlank(Rs("cate2"))
		cate3 = changeBlank(Rs("cate3")) 
		title = Rs("title")
		content = Rs("content")
		writer = Rs("writer")
		ReLevel = Rs("ReLevel")
		boardsort = Rs("boardsort")
		imgNames = Rs("imgNames")
		ref = Rs("ref")
		topyn = Rs("topyn")
		isimp = Rs("isimp")
		startdate = Rs("startdate")
		enddate = Rs("enddate")
		VodUrl = Rs("VodUrl")
		status = Rs("status")
		editorYN = Rs("editorYN")
		publicYN = Rs("publicYN")
		artistidx = Rs("artistidx")
		testFilename1 = Rs("testFile1")
		testFilename2 = Rs("testFile2")
		testFilename3 = Rs("testFile3")
		viewdate = Rs("viewdate")
		note1 = Rs("note1")
		note2 = Rs("note2")
		note3 = Rs("note3")
		note4 = Rs("note4")
		note5 = Rs("note5")
		note6 = Rs("note6")
		note7 = Rs("note7")
		note8 = Rs("note8")
		note9 = Rs("note9")
		note10 = Rs("note10")
		note11 = Rs("note11")
		note12 = Rs("note12")
		note13 = Rs("note13")
		thumbContent  = Rs("thumbContent")
		linkurl = Rs("linkurl")
		readnum = Rs("readnum")
		isDisplay = Rs("isDisplay")
		setYear = Rs("setYear")
		isMain = Rs("isMain")
		CateCode = Rs("CateCode")
		filteridx = Rs("filteridx")
		bdiv1 = Rs("bdiv1")
		bdiv2 = Rs("bdiv2")
		bFilenames = Rs("bFilenames")
		aFilenames = Rs("aFilenames")
		edNonce = changeBlank(Rs("edNonce"))
		always = changeBlank(Rs("always"))
		deadline = changeBlank(Rs("deadline"))
		newwin1 = changeBlank(Rs("newwin1"))
		newwin2 = changeBlank(Rs("newwin2"))

		IF editorYN=1 Then
			Content = ReplaceNoHtml(Content)
		Else
			Content = ReplaceBr(ReplaceNoHtml(ReplaceNoHtml(Content)))
		End IF
	End IF
	Set Rs = Nothing

	TitleTag = "수정"
	Sort = "edit"

	'=============파일정보Get======================================
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="Select idx,filenames From BBSData Where bidx="&Idx
	Rs.Open Sql,DBcon,1

	IF Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.Getrows()
	Rs.Close
	'==============================================================
Else
	setYear = Year(Date())
	isDisplay = 1
	ReLevel = "A"
	BoardSort = serboardsort
	artistidx = serartistidx
	TitleTag = "등록"
End IF

'###### 에디터 ID 생성 ##########
IF edNonce="" Then
	edNonce = GetEdNonce()
End IF
'###### 에디터 ID 생성 ##########

BBsSort = GetBoardSort(BBsCode,BoardSort,ReLevel)

IF ReLevel<>"A" Then	'답변글이라면
	Sql="SELECT title, content, editorYN FROM bbslist WHere idx="&ref
	Set Rs=DBcon.Execute(Sql)
	IF Rs.Bof Or Rs.Eof Then
		REsponse.Write ExecJavaAlert("원글정보를 찾을수 없습니다.\n다시시도해주세요.",0)
		Response.End
	Else
		oriTitle=Rs("title")
		oriContent=Rs("content")
		oriEditorYN=Rs("editorYN")

		IF oriEditorYN = 0 Then oriContent = ReplaceBr(ReplaceNoHtml(oriContent))
	End IF
End IF

DBcon.Close
Set DBcon=Nothing

IF Writer = "" Then Writer=Session("acountname")

arrBFile = Split(bFilenames, "^|^")
arrAFile = Split(aFilenames, "^|^")

IF Ubound(arrBFile)<5 Then
	ReDim Preserve arrBFile(5)
	ReDim Preserve arrAFile(5)
End IF

Function PT_LangMode()
	IF IsArray(bbsGroupRec) Then
		IF Ubound(bbsGroupRec,2)>0 Then
			Response.Write "<div class=""subTab mt20 mb20"">"&Vbcrlf
			For i=0 To Ubound(bbsGroupRec,2)
				Response.Write "	<a href=""bbslist.asp?bbscode="&bbsGroupRec(0,i)&""" class="""&iif_compare(bbsGroupRec(0,i), bbscode, "active")&"""><span>"&getBBSLangMode(bbsGroupRec(1,i))&"</span></a>"&Vbcrlf
			Next
			Response.Write "</div>"&Vbcrlf
		End IF
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<script type="text/javascript">
<!--
$(document).ready(function(){
	$(document).on("change",".fileFieldArr",function(){
		$(this).parent().find("input:checkbox").prop("checked",true);
		$(this).parent().find("input:checkbox[name=delchk]").change();
	});

	$(document).on("change","input:checkbox[name=delchk]",function(){
		dataVal = $(this).attr("dataVal");
		if ($(this).is(":checked")){
			$(this).parent().siblings("input[name=filedel_idx]").val(dataVal);
		}else{
			$(this).parent().siblings("input[name=filedel_idx]").val("");
		}
	});

	$(document).on("change","input:checkbox[name=always]",function(){
		if ($(this).is(":checked")){
			$("input[name=startdate]").attr("disabled", true)
			$("input[name=enddate]").attr("disabled", true)
		}else{
			$("input[name=startdate]").attr("disabled", false)
			$("input[name=enddate]").attr("disabled", false)
		}
	});
	$("input:checkbox[name=always]").change()

	$(document).on("change","select[name=cate1]",function(){
		var mCd = $(this).val();
		var params = "mCd="+mCd;
		$.ajax({type:"POST", url:"/_lib/_inquiryCateCh.asp",data:params,dataType:"html"
		}).done(function(msg){
			var rData = msg.split("|")
			if (rData[0]=="OK"){
				$("select[name=cate2] option:not(:first)").remove();
				if (rData[1]==""){
					$("select[name=cate2]").addClass("disNone");
					$("select[name=cate3]").addClass("disNone");
				}else{
					$("select[name=cate2]").removeClass("disNone");
					$("select[name=cate3]").addClass("disNone");
					$("select[name=cate2]").append(rData[1]);

					var caetSetVal = $("select[name=cate2]").attr("setVal")
					if (caetSetVal){
						$("select[name=cate2]").val(caetSetVal);
						$("select[name=cate2]").attr("setVal", "");
						$("select[name=cate2]").change();
					}
				}
			}else{
				var retMsg = rData[1].replace(/\\n/gi, "\n");
				alert(retMsg)
			}
		});
	});
	$(document).on("change","select[name=cate2]",function(){
		var mCd = $(this).val();
		var params = "mCd="+mCd;
		$.ajax({type:"POST", url:"/_lib/_inquiryCateCh.asp",data:params,dataType:"html"
		}).done(function(msg){
			var rData = msg.split("|")
			if (rData[0]=="OK"){
				$("select[name=cate3] option:not(:first)").remove();
				if (rData[1]==""){
					$("select[name=cate3]").addClass("disNone");
				}else{
					$("select[name=cate3]").removeClass("disNone");
					$("select[name=cate3]").append(rData[1]);

					var caetSetVal = $("select[name=cate3]").attr("setVal")
					if (caetSetVal){
						$("select[name=cate3]").val(caetSetVal);
						$("select[name=cate3]").attr("setVal", "");
					}
				}
			}else{
				var retMsg = rData[1].replace(/\\n/gi, "\n");
				alert(retMsg)
			}
		});
	});
	$("select[name=cate1]").change();
});
//-->
</script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
	var form=document.boardform;
	var date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

	if (form.cate1){
		if( $("select[name='cate1']").hasClass("disNone") === false && !$("select[name='cate1']").val() ){
			alert("분류를 선택하세요.")
			return;
		}
	}
	if (form.cate2){
		if( $("select[name='cate2']").hasClass("disNone") === false && !$("select[name='cate2']").val() ){
			alert("분류를 선택하세요.")
			return;
		}
	}
	if (form.cate3){
		if( $("select[name='cate3']").hasClass("disNone") === false && !$("select[name='cate3']").val() ){
			alert("분류를 선택하세요.")
			return;
		}
	}

	if( document.getElementById("selectBoardsort")){
		if(form.boardsort.value==""){
			alert("분류를 선택하세요.");
			form.boardsort.focus();
			return;
		}
	}
	if(form.writer.value==false){
		alert("작성자를 입력하세요.");
		form.writer.focus();
		return;
	}

	/*if(form.startdate){
		if(form.startdate.value!="" || form.enddate.value!=""){
			if(form.startdate.value==""){
				alert("시작일을 입력하세요.");
				return;
			}
			if(form.enddate.value==""){
				alert("종료일을 입력하세요.");
				return;
			}
			if (form.startdate.value!="" && !date_pattern.test(form.startdate.value)){
				alert("날짜 입력형식 오류! YYYY-MM-DD 형식으로 입력해주세요.")
				form.startdate.focus();
				return;
			}
			if (form.enddate.value!="" && !date_pattern.test(form.enddate.value)){
				alert("날짜 입력형식 오류! YYYY-MM-DD 형식으로 입력해주세요.")
				form.enddate.focus();
				return;
			}
			if(form.startdate.value!="" && form.enddate.value!=""){
				if(form.startdate.value>form.enddate.value){
					alert("시작일은 종료일보다 클수 없습니다.");
					return;
				}
			}
		}
	}*/

	if(form.startdate){
		if (form.startdate.value!="" && !date_pattern.test(form.startdate.value)){
			alert("날짜 입력형식 오류! YYYY-MM-DD 형식으로 입력해주세요.")
			form.startdate.focus();
			return;
		}
		if (form.enddate.value!="" && !date_pattern.test(form.enddate.value)){
			alert("날짜 입력형식 오류! YYYY-MM-DD 형식으로 입력해주세요.")
			form.enddate.focus();
			return;
		}
		if(form.startdate.value!="" && form.enddate.value!=""){
			if(form.startdate.value>form.enddate.value){
				alert("시작일은 종료일보다 클수 없습니다.");
				return;
			}
		}
	}
	if(form.title.value==false){
		alert("<%=TitleName%>을 입력하세요.");
		form.title.focus();
		return;
	}

	/*if (form.VodUrl){
		if(form.VodUrl.value==false){
			alert("동영상 URL을 입력하세요.");
			form.VodUrl.focus();
			return;
		}
	}*/
	if("<%=Sort%>"=="edit"){
		if(form.imgDel_Chk){
			if(form.imgDel_Chk.checked){
				if(form.imgfiles){
					if(uploadImg_check(form.imgfiles.value,"섬네일 이미지를 올바로 입력하세요.",1)==false){
						return;
					}
				}
			}
		}
	}
	else{
		if(form.imgfiles){
			if(uploadImg_check(form.imgfiles.value,"섬네일 이미지를 올바로 입력하세요.",1)==false){
				return;
			}
		}
	}
	form.editorYN.value=1
	form.submit();
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
//-->
</SCRIPT>
</head>

<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=HK_BBS_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=HK_BBS_TopMenuName%> &gt; <span><%=HK_BBS_SubMenuName%></span>
				</div>

				<%=PT_LangMode()%>

				<form name="boardform" action="bbswriteok.asp" method="post" ENCTYPE="multipart/form-data">
				<input type='hidden' name='editorYN' value=''>
				<input type='hidden' name='sort' value='<%=Sort%>'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='ref' value='<%=ref%>'>
				<input type='hidden' name='relevel' value='<%=ReLevel%>'>
				<input type='hidden' name='bbsCode' value='<%=bbsCode%>'>
				<input type='hidden' name='page' value='<%=Page%>'>
				<input type='hidden' name='serstatus' value='<%=serstatus%>'>
				<input type='hidden' name='serisDisplay' value='<%=serisDisplay%>'>
				<input type='hidden' name='serismain' value='<%=serismain%>'>
				<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
				<input type='hidden' name='serartistidx' value='<%=serartistidx%>'>
				<input type='hidden' name='seritem' value='<%=seritem%>'>
				<input type='hidden' name='SearchStr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<input type='hidden' name='serDate1' value='<%=serDate1%>'>
				<input type='hidden' name='serdate2' value='<%=serdate2%>'>
				<input type='hidden' name='sercate1' value='<%=sercate1%>'>
				<input type='hidden' name='sercate2' value='<%=sercate2%>'>
				<input type='hidden' name='sercate3' value='<%=sercate3%>'>
				<input type='hidden' name='catecode' value='<%=CateCode%>'>
				<input type='hidden' name='edNonce' value='<%=edNonce%>'>
				<table class="tbl_row box">
					<colgroup>
						<col width="12%" />
						<col width="38%" />
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tr <% IF ReLevel<>"A" Then %>class="disNone"<% End IF %>>
						<th>노출상태</th>
						<td colspan='3'>
							<select name="isDisplay">
								<option value="0" <%=selCheck(isDisplay,0)%>>비노출</option>
								<option value="1" <%=selCheck(isDisplay,1)%>>노출</option>
							</select>
						</td>
					</tr>

				<% IF HK_BBS_MainYN="True" Then %>
					<!-- <tr>
						<th>메인노출</th>
						<td colspan='3'>
							<label><input type='checkbox' name="isMain" value="1" <%=iif_compare(isMain, 1, "checked")%>> 체크시 메인에 노출됩니다.</label>
						</td>
					</tr> -->
				<% End IF%>

					<tr <% IF ReLevel<>"A" OR BBscode=2 Then %>class="disNone"<% End IF %>>
						<th>조회수</th>
						<td colspan='3'><input type='text' name='readnum' style='width:80px' maxlength='5' class='onlyNumber input' Value='<%=readnum%>'></td>
					</tr>
					<tr <% IF ReLevel<>"A" Then %>class="disNone"<% End IF %>>
						<th>노출일자</th>
						<td colspan='3'>
							<div class="date_wrap">
								<input type="text" name="viewdate" class="datepicker1" maxlength='10' value="<%=viewdate%>" style='width:90px;' placeholder="YYYY-MM-DD" />
								<span style='color: #5e82fd; padding-left:10px;'>미 입력시 현재일자 자동 입력</span>
							</div>
						</td>
					</tr>

				<% IF BBsSort<>"" Then %>
					<tr <% IF ReLevel<>"A" Then %>class="disNone"<% End IF %>>
						<th>분류</th>
						<td colspan='3'>
							<%=BBsSort%>
						</td>
					</tr>
				<% Else %>
					<input type='hidden' name='boardsort' value='<%=BoardSort%>'>
				<% End IF %>

					<tr <% IF HK_PubYN<>"True" Then %>class="disNone"<% End IF %>>
						<th>공개여부</th>
						<td colspan='3'>
							<input name="publicYN" id="publicY" type="radio" value="0" checked><label for="publicY">공개</label> &nbsp;
							<input name="publicYN" id="publicN" type="radio" value="1" <%=ChangeChecked(publicYN,True)%>><label for="publicN">비공개</label> &nbsp;
						</td>
					</tr>

					<tr>
						<th>작성자</th>
						<td colspan='3'><input type='text' name='writer' style='width:17%' maxlength='100' class='input' Value='<%=ReplaceTextField(Writer)%>'></td>
					</tr>

					<tr <% IF ReLevel<>"A" Then %>class="disNone"<% End IF %>>
						<th><%=TitleName%></th>
						<td colspan='3'>
							<div class="mb10">
								<label><input type='checkbox' name='topyn' Value='1' <%=ChangeCheckedYN(TopYN)%>> 공지글 체크</label>
								<% IF BBscode="30" Then %>
								<label><input type='checkbox' name='isimp' Value='1' <%=iif_compare(isimp, 1, "checked")%>> 중요</label>
								<% End IF %>
							</div>
							<input type='text' name='title' maxlength='200' class='input' Value='<%=ReplaceTextField(Title)%>'>
						</td>
					</tr>

					<% IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then %>
					<tr>
						<th>상담분류</th>
						<td colspan='3'>
							<select name="cate1" style="width:auto;">
								<option value="">선택하세요</option>
								<% IF BBscode="8" Then %>
								<option value="uc" <%=selCheck(cate1, "uc")%>>UC</option>
								<option value="erp" <%=selCheck(cate1, "erp")%>>ERP</option>
								<% ElseIF BBscode="18" Then %>
								<option value="icube" <%=selCheck(cate1, "icube")%>>iCUBE</option>
								<option value="icubeg20" <%=selCheck(cate1, "icubeg20")%>>iCUBE G20</option>
								<% ElseIF BBscode="40" Then %>
								<option value="cusetc" <%=selCheck(cate1, "cusetc")%>>기타</option>
								<% Else %>
								<option value="bizboxalpha" <%=selCheck(cate1, "bizboxalpha")%>>Bizbox Alpha</option>
								<% End IF %>
							</select>
							<select name="cate2" style="width:auto;" class="disNone" setVal="<%=cate2%>">
								<option value="">선택하세요</option>
							</select>
							<select name="cate3" style="width:auto;" class="disNone" setVal="<%=cate3%>">
								<option value="">선택하세요</option>
							</select>
						</td>
					</tr>
					<% ELSEIF BBscode="5" OR BBscode="15" OR BBscode="25" Then %>
					<tr>
						<th>분류</th>
						<td colspan='3'>
							<select name="cate1" style="width:auto;">
								<option value="">선택하세요</option>
								<% IF BBscode="5" Then %>
								<%=Create_CCodeOption("amaCate", cate1)%>
								<% ElseIF BBscode="15" Then %>
								<%=Create_CCodeOption("icubeCate", cate1)%>
								<% Else %>
								<%=Create_CCodeOption("bizboxCate", cate1)%>
								<% End IF %>
							</select>
							<select name="cate2" style="width:auto;" class="disNone" setVal="<%=cate2%>">
								<option value="">선택하세요</option>
							</select>
						</td>
					</tr>
					<% End IF %>

					<% IF ReLevel<>"A" Then %>
					<tr>
						<th>원글 제목</th>
						<td colspan="3">
							<%=ReplaceNoHtml(oriTitle)%>
						</td>
					</tr>
					<tr>
						<th>원글 내용</th>
						<td colspan="3"><%=oriContent%></td>
					</tr>
					<% End IF %>

					<% IF HK_VodUrlYN<>"False" Then %>
					<tr>
						<th>동영상URL</th>
						<td colspan='3'>
							<input type='text' name='VodUrl' style='width:100%' maxlength='100' class='input' value='<%=ReplaceTextField(VodUrl)%>'>
						</td>
					</tr>
					<% End IF %>

					<% IF HK_BBS_isCon Then %>
					<tr>
						<td colspan='4'>
							<textarea name='content' id="content" rows='20' class="ckeditor5" style='width:99%'><%=Content%></textarea>
						</td>
					</tr>
					<% End IF %>

					<% IF bbscode="51" Then %>
					<tr>
						<th>회사명</th>
						<td>
							<input type='text' name='note1' maxlength='100' class='input' Value='<%=ReplaceTextField(note1)%>'>
						</td>
						<th>모집부문</th>
						<td>
							<input type='text' name='note2' maxlength='100' class='input' Value='<%=ReplaceTextField(note2)%>'>
						</td>
					</tr>
					<tr>
						<th>채용인원</th>
						<td>
							<input type='text' name='note3' maxlength='100' class='input' Value='<%=ReplaceTextField(note3)%>'>
						</td>
						<th>고용형태</th>
						<td>
							<input type='text' name='note4' maxlength='100' class='input' Value='<%=ReplaceTextField(note4)%>'>
						</td>
					</tr>
					<tr>
						<th>근무지역</th>
						<td colspan="3">
							<input type='text' name='note5' maxlength='100' class='input' Value='<%=ReplaceTextField(note5)%>'>
						</td>
					</tr>
					<tr>
						<th>채용기간</th>
						<td colspan='3'>
							<div class="date_wrap">
								<input type='text' name='startdate' value="<%=ReplaceTextField(startdate)%>" class="datepicker1" placeholder="YYYY-MM-DD"> ~
								<input type='text' name='enddate' value="<%=ReplaceTextField(enddate)%>" class="datepicker2" placeholder="YYYY-MM-DD">

								<span style="margin-left:10px;"><input type="checkbox" name="always" value="1" id="always" <%=iif_compare(always, "1", "checked")%>><label for="always">상시채용</label></span>
								<span style="margin-left:10px;"><input type="checkbox" name="deadline" value="1" id="deadline" <%=iif_compare(deadline, "1", "checked")%>><label for="deadline">마감</label></span>
							</div>

							<div class="imp mt5">시작, 종료일을 입력하지 않을경우 채용시까지로 노출됩니다. (시작일 입력, 종료일 미입력 시 시작일 ~ 채용시까지로 노출.)</div>
							<div class="imp">종료일이 지나면 자동 마감처리 됩니다. 종료일 이전 마감처리가 필요할 경우 마감에 체크해주세요. (마감은 상시채용보다 우선됩니다.)</div>
						</td>
					</tr>
					<% End IF %>

					<% IF HK_imgYN<>"False" Then %>
					<tr>
						<th><% IF BBSCODE="51" Then %>업체로고<% Else %>대표이미지<% End IF %></th>
						<td colspan='3'>
							<div class="filesArea">
								<div class="file fileArea">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="imgfiles" title="파일첨부" class='fileField'/></span>
									</span>
									<a class="thumb"></a>

									<% IF Sort="edit" Then %>
										<input type='hidden' name='imgname' value="<%=imgNames%>">
										<% IF ImgNames<>"" Then %>
										<p class="checkIn">
											<input type='checkbox' name='delchk' id="imgDelChk_1" dataVal="1" class="fileFieldChk">
											<label class="labelTxt ml10" for="imgDelChk_1">삭제</label>
											<input type='hidden' name='imgDel_Chk' value='0' class="fileDelidx">
										</p>
										<%=PT_FileThumbImgTag(ImgNames, "board")%>
										<span class="fDBArea">첨부파일 (<a href="/_lib/download.asp?path=board&downfile=<%=ImgNames%>" class="ellipsis"><%=ReplaceNoHtml(ImgNames)%></a>)</span>
										<% Else %>
										<input type="hidden" name="imgDel_Chk" value="1">
										<% End IF %>
									<% End IF %>
								</div>
							</div>

							<% IF bbscode="1000" Then %>
							<div class="mt5" style='color: #8c0000'>이미지 최적사이즈 640px * 640px (1:1 비율)</div>
							<% End IF %>
						</td>
					</tr>
					<% End IF %>

					<% IF HK_PdsYN<>"False" AND ReLevel="A" Then %>
					<tr>
						<th>첨부파일</th>
						<td colspan='3'>

							<div class="filesArea">
								<a class="bbsFilePlus"><span>파일추가</span></a>

							<% IF IsArray(FileRec) Then %>
								<% For i=0 To UBound(FileRec,2) %>
								<div class="file fileArea">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부" class='fileField'/></span>
									</span>
									<a class="thumb"></a>
									<p class="checkIn">
										<input type='checkbox' name='delchk' id="delcheck<%=i+1%>" dataVal="<%=FileRec(0,i)%>" class="fileFieldChk">
										<label class="labelTxt ml10" for="delcheck<%=i+1%>">삭제</label>
										<input type='hidden' name='filedel_idx' value='0' class="fileDelidx">
									</p>
									<%=PT_FileThumbImgTag(FileRec(1,i), "board")%>
									<span class="fDBArea">첨부파일 (<a href="/_lib/download.asp?path=board&downfile=<%=FileRec(1,i)%>" class="ellipsis"><%=ReplaceNoHtml(FileRec(1,i))%></a>)</span>
								</div>
								<% Next%>
							<% Else %>
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부"/></span>
									</span>
									<a class="thumb"></a>
									<input type='hidden' name='filedel_idx' value='0'>
								</div>
							<% End IF %>
							</div>

						</td>
					</tr>
					<% End IF %>

					<% IF BBscode="7" OR BBscode="17" OR BBscode="26" OR BBscode="27" OR BBscode="30" Then %>
					<tr>
						<th>링크URL</th>
						<td colspan='3'>
							<input type='text' name='linkurl' style='width:90%' maxlength='2000' class='input' value='<%=ReplaceTextField(linkurl)%>'>
							<p class="checkIn">
								<input type='checkbox' name='newWin1' id="newWin1" <%=iif_compare(newWin1, "1", "checked")%> value="1">
								<label class="labelTxt ml10 imp" for="newWin1">새창</label>
							</p>
						</td>
					</tr>
					<% End IF %>
					
					<% IF bbscode="1000" Then %>
					<tr>
						<th>링크URL</th>
						<td colspan='3'>
							<input type='text' name='linkurl' style='width:90%' maxlength='2000' class='input' value='<%=ReplaceTextField(linkurl)%>'>
							<p class="checkIn">
								<input type='checkbox' name='newWin1' id="newWin1" <%=iif_compare(newWin1, "1", "checked")%> value="1">
								<label class="labelTxt ml10 imp" for="newWin1">새창</label>
							</p>
						</td>
					</tr>
					<tr>
						<th>상태</th>
						<td colspan='3'>
							<select name="status">
								<option value="1" <%=selCheck(status,1)%>>진행중</option>
								<option value="0" <%=selCheck(status,0)%>>종료</option>
							</select>
						</td>
					</tr>

					<tr>
						<th>매체명</th>
						<td colspan='3'>
							<input type='text' name='note1' maxlength='100' class='input' Value='<%=ReplaceTextField(note1)%>'>
						</td>
					</tr>
					<tr>
						<th>일정표파일</th>
						<td colspan='3'>
							<input type='file' name='testfiles' style='width:60%' class='input'>
							<% IF Sort="edit" Then %>
							<input type='hidden' name='testFilename1' value="<%=testFilename1%>">
							<label><input type='checkbox' name='testDel_Chk1'> 파일변경여부</label>
							<% End IF %>
							<% IF testFilename1<>"" Then %>
							<a href='/_lib/download.asp?path=board&downfile=<%=testFilename1%>'><img src='/backoffice/images/bt_download.gif' border='0' align='absmiddle'></a>
							<% End IF %>
						</td>
					</tr>
					<tr>
						<th>기간</th>
						<td colspan='3'>
							<div class="date_wrap">
								<input type='text' name='startdate' value="<%=ReplaceTextField(startdate)%>" readonly class="datepicker1"> ~
								<input type='text' name='enddate' value="<%=ReplaceTextField(enddate)%>" readonly class="datepicker2">
							</div>
						</td>
					</tr>
					<tr>
						<th>간략설명</th>
						<td colspan='3'>
							<input type='text' name='thumbContent' maxlength='500' class='input' Value='<%=ReplaceTextField(thumbContent)%>'>
							<!-- <textarea name='thumbContent' style='width:100%; word-break:break-all; height:70px;' ><%=thumbContent%></textarea> -->
						</td>
					</tr>
					<tr>
						<th>링크URL</th>
						<td colspan='3'>
							<input type='text' name='linkurl' style='width:100%' maxlength='100' class='input' value='<%=ReplaceTextField(linkurl)%>'>
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td colspan='3'>
							<input type='file' name='testfiles' style='width:60%' class='input'>
							<% IF Sort="edit" Then %>
							<input type='hidden' name='testFilename1' value="<%=testFilename1%>">
							<label><input type='checkbox' name='testDel_Chk1'> 파일변경여부</label>
							<% End IF %>
							<% IF testFilename1<>"" Then %>
							<a href='/_lib/download.asp?path=board&downfile=<%=testFilename1%>'><img src='/backoffice/images/bt_download.gif' border='0' align='absmiddle'></a>
							<% End IF %>
						</td>
					</tr>

					<tr>
						<th>상세URL</th>
						<td colspan='3'>
							<input type='text' name='linkurl' style='width:90%' maxlength='2000' class='input' value='<%=ReplaceTextField(linkurl)%>'>
							<p class="checkIn">
								<input type='checkbox' name='newWin1' id="newWin1" <%=iif_compare(newWin1, "1", "checked")%> value="1">
								<label class="labelTxt ml10 imp" for="newWin1">새창</label>
							</p>

							<div class="imp mt5">상세URL을 입력하시면 상세페이지가 노출되지 않고 해당 URL로 이동합니다.</div>
						</td>
					</tr>
					<tr>
						<th>PDF파일</th>
						<td colspan='3'>
							<input type='file' name='testfiles' style='width:60%' class='input'>
							<% IF Sort="edit" Then %>
							<input type='hidden' name='testFilename1' value="<%=testFilename1%>">
							<label><input type='checkbox' name='testDel_Chk1'> 파일변경여부</label>
							<% End IF %>
							<% IF testFilename1<>"" Then %>
							<a href='/_lib/download.asp?path=board&downfile=<%=testFilename1%>'><img src='/backoffice/images/bt_download.gif' border='0' align='absmiddle'></a>
							<% End IF %>

							<div class="imp mt5">PDF파일을 업로드하시면 상세페이지로 이동하지 않고 PDF파일 보여줍니다. (내용보다 우선)</div>
						</td>
					</tr>
					<% End IF %>
				</table>

				<% IF bbscode="1000" Then %>
				<div class="subTitle">BEFORE & AFTER 이미지</div>
				<table class="tbl_row box">
					<colgroup>
						<col width="12%" />
						<col width="38%" />
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<% For i=0 To Ubound(arrBFile)-1 %>
					<tr>
						<th>BEFORE <%=i+1%></th>
						<td colspan="3">
							<div class="fileArea">
								<input type='file' name='bfiles' style='width:50%;' class='fileField'>
								<input type='hidden' name='bFileName' value='<%=arrBFile(i)%>'>

								<% IF arrBFile(i) <> "" Then %>
								<span class="ml10">
									<input type='checkbox' name='delchk' id="delchk_b_<%=i%>" class="fileFieldChk">
									<label for="delchk_b_<%=i%>">삭제</label>
									<input type='hidden' name='bfiledelchk' value='0' class="fileDelidx">
								</span>
								<a href="/_lib/download.asp?path=board&downfile=<%=Server.Urlencode(arrBFile(i))%>" class="ml10"><%=ReplaceNoHtml(arrBFile(i))%></a>
								<% Else %>
								<input type='hidden' name='bfiledelchk' value='1'>
								<% End IF %>
							</div>
						</td>
					</tr>
					<tr>
						<th>AFTER <%=i+1%></th>
						<td colspan="3">
							<div class="fileArea">
								<input type='file' name='afiles' style='width:50%;' class='fileField'>
								<input type='hidden' name='aFileName' value='<%=arrAFile(i)%>'>

								<% IF arrAFile(i) <> "" Then %>
								<span class="ml10">
									<input type='checkbox' name='delchk' id="delchk_a_<%=i%>" class="fileFieldChk">
									<label for="delchk_a_<%=i%>">삭제</label>
									<input type='hidden' name='afiledelchk' value='0' class="fileDelidx">
								</span>
								<a href="/_lib/download.asp?path=board&downfile=<%=Server.Urlencode(arrAFile(i))%>" class="ml10"><%=ReplaceNoHtml(arrAFile(i))%></a>
								<% Else %>
								<input type='hidden' name='afiledelchk' value='1'>
								<% End IF %>
							</div>
						</td>
					</tr>
					<% Next %>
				</table>
				<% End IF %>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit()" class="btn_largeG">확인</a>
					<a href="javascript:history.back()" class="btn_largeW">취소</a>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->