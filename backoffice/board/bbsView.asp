<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode
BBSCode = uf_getRequest(Request("BBSCode"),"int","","1")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec,Idx,Page
Dim title,writer,regdate,content,Ref,ReLevel,TopYN,TopTag,Submit,SortName,filename1
Dim editorYN, imgNames, vodUrl, startdate, enddate, tel, phone, fax, email, note1, note2, note3, note4, note5, note6
Dim Company, status, Sort, BBsSort, boardsort
Dim FileRec

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

Sql="Select title, writer, regdate, content, Ref, ReLevel, Wip, TopYn, submit, SortName, imgnames, email, startdate, enddate, vodUrl, company, tel, phone, fax, note1, note2, note3, note4, note5, note6, note7, note8, note9, note10, note11, note12, note13, note14, status, editorYN, testFile1, testFile2, testFile3, viewdate, homepage, boardsort, thumbContent, linkurl, useridx, adMemo, adMemo1, memoModDate, memoWid, memoWname, setYear, isMain, catecode, filteridx, isMainNum, bFilenames, aFilenames, arrNote1, arrNote2, always, deadline, cate1 AS cateNm1, DBO.FN_CODENAME(cate1, cate2) AS cateNm2, DBO.FN_CODENAME(cate2, cate3) AS cateNm3, bizcode, memoFileNm, DBO.FN_CODENAME( CASE WHEN b.boardidx=5 THen 'amaCate' WHEN b.boardidx=15 THEN 'icubeCate' Else 'bizboxCate' END  , cate1) AS vodCateNm, sendMailModDate, sendMailWid, sendMailWname FROM BBSList AS B Left Outer Join BoardSort AS S ON BoardSort=S.idx Where b.idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	editorYN=Rs("editorYN")
	title = ReplaceNoHtml(Rs("title"))
	writer = ReplaceNoHtml(Rs("writer"))
	regdate = Rs("regdate")
	content = Rs("content")
	Ref = Rs("ref")
	ReLevel = Rs("relevel")
	WIP = Rs("wip")
	TopYN = Rs("topyn")
	Submit = Rs("submit")
	SortName = Rs("SortName")
	ImgNames = Rs("ImgNames")
	vodUrl = Rs("vodUrl")
	startdate = Rs("startdate") : enddate = Rs("enddate")
	viewdate = Rs("viewdate")
	homepage = Rs("homepage")
	boardsort = Rs("boardsort")
	useridx = Rs("useridx")

	tel = Rs("tel")
	phone = Rs("phone")
	fax = Rs("fax")
	email = Rs("email")
	note1 = ReplaceNoHtml(Rs("note1"))
	note2 = ReplaceNoHtml(Rs("note2"))
	note3 = ReplaceNoHtml(Rs("note3"))
	note4 = ReplaceNoHtml(Rs("note4"))
	note5 = ReplaceNoHtml(Rs("note5"))
	note6 = ReplaceNoHtml(Rs("note6"))
	note7 = ReplaceNoHtml(Rs("note7"))
	note8 = ReplaceNoHtml(Rs("note8"))
	note9 = ReplaceNoHtml(Rs("note9"))
	note10 = ReplaceNoHtml(Rs("note10"))
	note11 = ReplaceNoHtml(Rs("note11"))
	note12 = ReplaceNoHtml(Rs("note12"))
	note13 = ReplaceNoHtml(Rs("note13"))
	note14 = ReplaceNoHtml(Rs("note14"))
	linkurl = ReplaceNoHtml(Rs("linkurl"))
	company = ReplaceNoHtml(Rs("company"))
	thumbContent = Rs("thumbContent")

	testFileName1 = Rs("testFile1")
	testFileName2 = Rs("testFile2")
	testFileName3 = Rs("testFile3")

	status = Rs("status")

	adMemo = Rs("adMemo")
	adMemo1 = Rs("adMemo1")
	memoModDate = ReplaceNoHtml(Rs("memoModDate"))
	memoWid = ReplaceNoHtml(Rs("memoWid"))
	memoWname = ReplaceNoHtml(Rs("memoWname"))
	setYear = ReplaceNoHtml(Rs("setYear"))

	sendMailModDate = ReplaceNoHtml(Rs("sendMailModDate"))
	sendMailWid = ReplaceNoHtml(Rs("sendMailWid"))
	sendMailWname = ReplaceNoHtml(Rs("sendMailWname"))

	isMain = Rs("isMain")
	isMainNum = Rs("isMainNum")
	catecode = Rs("catecode")
	filteridx = Rs("filteridx")

	bFilenames = Rs("bFilenames")
	aFilenames = Rs("aFilenames")

	arrNote1 = ChangeBlank(Rs("arrNote1"))
	arrNote2 = ChangeBlank(Rs("arrNote2"))

	always = ChangeBlank(Rs("always"))
	deadline = ChangeBlank(Rs("deadline"))

	cateNm1 = ReplaceNoHtml(Rs("cateNm1"))
	cateNm2 = ReplaceNoHtml(Rs("cateNm2"))
	cateNm3 = ReplaceNoHtml(Rs("cateNm3"))
	bizcode = ReplaceNoHtml(Rs("bizcode"))
	vodCateNm = ReplaceNoHtml(Rs("vodCateNm"))

	'######### 답변 첨부파일 ##########
	memoFileNm = ReplaceNoHtml(Rs("memoFileNm"))
	IF memoFileNm<>"" Then
		ARRMEMOFILENM = Split(ChangeBlank(memoFileNm),"|")
	End IF
	'######### 답변 첨부파일 ##########

	IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then
		cateNames = getBBSCateNm1(cateNm1)
	Else
		cateNames = vodCateNm
	End IF

	IF cateNames <> "" Then
		IF cateNm2<>"" Then
			cateNames = cateNames & " > "& cateNm2

			IF cateNm3<>"" Then
				cateNames = cateNames & " > "& cateNm3
			End IF
		End IF
	End IF

	IF editorYN = 0 Then Content = ReplaceBr(ReplaceNoHtml(Content))

	IF Not(isNull(useridx)) Then
		Sql = "SELECT name FROM Members Where idx = "&Useridx
		Set Rs = DBcon.Execute(Sql)
		IF Not(Rs.Bof Or Rs.Eof) Then
			UserName = Rs("name")
		End IF
	End IF

	'=======관련글(답변글) ===================================
	'Sql="SELECT title, content, writer, regdate, editorYN, idx FROM BBSList WHERE isDisplay=1 AND idx<>"&idx&" AND ref = "&Ref&" order by Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC"
	'Set Rs=DBcon.Execute(Sql)
	'IF Not(Rs.Bof Or Rs.Eof) Then ReplyRec = Rs.GetRows()
	'=======================================================
End IF
Rs.Close

IF submit="0" Then
	Sql="UPDATE BBSList SET Submit=1 Where idx="&Idx
	DBcon.Execute Sql
End IF

IF TopYn="True" Then TopTag="[공지]"

IF HK_PdsYN = "True" Then
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="SELECT filenames FROM BBsData WHERE bidx="&idx
	Rs.Open Sql,DBcon,1
	If Not(Rs.Bof Or Rs.Eof) Then FileRec=Rs.GetRows()
	Rs.CLose()
End IF

IF BBscode=51 And relevel="A" Then
	IF always="1" Then
		recruitTerm = "상시채용"
	ElseIF startDate="" AND endDate="" Then
		recruitTerm = "상시"
	ElseIF endDate="" Then
		recruitTerm = startDate & " ~ 채용시까지"
	Else
		recruitTerm = startDate & " ~ "& endDate
	End IF

	IF deadline="1" Then
		termStatus = "<span style='color: #a20000' class=""ml10"">마감</span>"
	ElseIF always="1" Then
		termStatus = "<span style='color: #000' class=""ml10"">진행중</span>"
	Else
		IF CStr(Date()) > CStr(enddate) AND enddate<>"" Then
			termStatus = "<span style='color: #a20000' class=""ml10"">마감</span>"
		ElseIF CStr(Date()) < CStr(startdate) AND startdate<>"" Then	
			termStatus = "<span style='color: #d3d3d3' class=""ml10"">예정</span>"
		Else
			termStatus = "<span style='color: #000' class=""ml10"">진행중</span>"
		End IF
	End IF
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_FileArea()
	Dim i

	IF IsArray(FileRec) Then
	Response.Write "<div class=""attachedFile"">"&Vbcrlf
	Response.Write "	<dl>"&Vbcrlf
	Response.Write "		<dt><img src=""/_lib/memberimg/iconFiles.gif"" alt=""첨부"" /> <button type=""button"" class=""fileToggle"" onclick=""changeFileArea()"" style='color: #3383AE;'>첨부파일보기("&UBound(FileRec,2)+1&")</button></dt>"&Vbcrlf
	Response.Write "		<dd>"&Vbcrlf
	Response.Write "		<ul class=""files"" style='display:none;' id='fileArea' name='fileArea'>"&Vbcrlf
		For i=0 To UBound(FileRec,2)
			Response.Write "			<li>"&DownloadTag(FileRec(0,i),"board")&"</li>"&Vbcrlf
		Next
	Response.Write "		</ul>"&Vbcrlf
	Response.Write "		</dd>"&Vbcrlf
	Response.Write "	</dl>"&Vbcrlf
	Response.Write "</div>"&Vbcrlf
	End IF
End Function

Function PT_FileList()
	Dim i

	IF IsArray(FileRec) Then
	Response.Write "<tr>"&Vbcrlf
	Response.Write "	<th>상세이미지</th>"&Vbcrlf
	Response.Write "	<td colspan=""3"">"&Vbcrlf
	Response.Write "		<ul class=""files"" id='fileArea' name='fileArea'>"&Vbcrlf
		For i=0 To UBound(FileRec,2)
			'Response.Write "			<li>"&DownloadTag(FileRec(0,i),"board")&"</li>"&Vbcrlf
			Response.Write "			<li><a href=""javascript:openWindow(100,100,'/_lib/imgview.asp?path=board&imgname="&FileRec(0,i)&"','imgView','yes')"">"&FileRec(0,i)&"</a></li>"&Vbcrlf

		Next
	Response.Write "		</ul>"&Vbcrlf
	Response.Write "	</td>"&Vbcrlf
	Response.Write "</tr>"&Vbcrlf
	End IF
End Function

Function PT_ReplyList()
	IF IsArray(ReplyRec) Then
		For i=0 To Ubound(ReplyRec,2)
			IF ReplyRec(4,i)=0 Then
				Content = ReplaceBr(ReplyRec(1,i))
			Else
				Content = ReplyRec(1,i)
			End IF
			'title, content, writer, regdate, editorYN, idx
			Response.Write "<tr>"&Vbcrlf
			Response.Write "	<td class=""answer"" colspan=""4"">"&Vbcrlf
			Response.Write "		<p class=""tit"">답변 : "&Vbcrlf
			Response.Write "			<span>"&ReplyRec(2,i)&" ("&ReplyRec(3,i)&")</span>"&Vbcrlf
			Response.Write "			<span class=""btnArea"">"&Vbcrlf
			Response.Write "				<a href=""bbswrite.asp?page="&Page&"&idx="&ReplyRec(5,i)&"&"&PageStr&""" class=""btn_gray"">수정</a>"&Vbcrlf
			Response.Write "				<a href=""javascript:replyDel("&ReplyRec(5,i)&");"" class=""btn_red"">삭제</a>"&Vbcrlf
			Response.Write "			</span>"&Vbcrlf
			Response.Write "		</p>"&Vbcrlf
			Response.Write "		<div>"&Content&"</div>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	End IF
End Function

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

arrBFile = Split(bFilenames, "^|^")
arrAFile = Split(aFilenames, "^|^")

arrNote1 = Split(arrNote1, "|")
arrNote2 = Split(arrNote2, "|")

IF Ubound(arrBFile)<5 Then
	ReDim Preserve arrBFile(5)
	ReDim Preserve arrAFile(5)
End IF

IF BBscode="1000" Then
	writeTit = "지점명"
Else
	writeTit = "작성자"
End IF
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT language=JavaScript src="/_lib/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>
<script type="text/javascript" src="/_lib/adminboardControl.js"></script>
<% IF HK_comYn=True Then %>
<SCRIPT LANGUAGE="JavaScript">
<!--
$("document").ready(function(){
	viewBoardCommentArea('<%=idx%>','<%=BBscode%>','')
});
//-->
</SCRIPT>
<% End IF %>

<style>
.answer{padding:20px !important;}
.answer .tit{font-weight:700; color:#000}
.answer .btnArea{float:right;}
.answer .btnArea a{}
</style>


<SCRIPT LANGUAGE="JavaScript">
<!--
function boardDel(idx){
	var value=confirm("관리자권한으로 해당 게시물의 답변목록도 모두 삭제됩니다.\n선택하신 글을 삭제하시겠습니까?");
	if(value){
		location.href='bbsDel.asp?page=<%=Page%>&<%=PageStr%>&idx='+idx;
	}
}
function replyDel(idx){
	var value=confirm("해당 답변을 삭제하시겠습니까?");
	if(value){
		location.href='bbsDel.asp?page=<%=Page%>&<%=PageStr%>&idx='+idx;
	}
}
function isMainChBtn(){
	//isMain isMainNum
	isMain = $("input[name=isMain]:checked").val()
	isMainNum = $("input[name=isMainNum]").val()

	var params = "idx=<%=idx%>&isMain="+isMain+"&isMainNum="+isMainNum;
	$.ajax({
		type:"POST"
		, url:"bbs_isMainChange.asp"
		, data:params
		, dataType:"html"
	}).done(function(data){
		if (data=="OK"){
			alert("진열상태가 변경되었습니다.");
			location.reload();
		}else{
			alert("오류!\n새로고침 후 다시시도해주세요.")
		}
	});
}

function changeStatus(){
	var val=confirm("해당게시물의 처리상태를 변경하시겠습니까?");
	if (val){
		var params = $("#statusFrm").serialize();
		$.ajax({
			type:"POST"
			, url:"bbs_statusChange.asp"
			, data:params
			, dataType:"html"
		}).done(function(data){
			if (data=="OK"){
				alert("진행상태가 변경되었습니다.");
				location.reload();
			}else{
				alert("오류!\n새로고침 후 다시시도해주세요.")
			}
		});
	}
}
function adMemoOk(){
	var f = document.revFrm;
	var val = confirm("처리내역을 수정합니다.\n수정하시겠습니까?");
	if (val){
		document.revFrm.target="actFrame";
		document.revFrm.action="bbsAdmemoOk.asp"
		document.revFrm.submit()
	}
}
function sendMail(){
	var f = document.boardform;
	var params = $("#revFrm").serialize();
	$.ajax({
		type:"POST"
		, url:"bbsSendMail.asp"
		, data:params
		, dataType:"html"
	}).done(function(data){
		if (data=="success"){
			alert("메일발송 되었습니다.")
		}else{
			alert("오류!\n새로고침 후 다시시도해주세요.")
		}
	});
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

				<% IF bbscode=1000 AND ReLevel="A" Then %>
				<div class="tbl_top">
					<div class="top_right">
						<form name='statusFrm' id="statusFrm" action='bbs_statusChange.asp' method=''>
						<input type='hidden' name='idx' value='<%=idx%>'>
						<input type='hidden' name='bbscode' value='<%=bbscode%>'>
						해당게시물의 진행상태를
						<select name='status' style='background-color: #FFE8E8' onchange='changeStatus()'>
							<option value='0' <%=selCheck(status,"0")%>>신청대기</option>
							<option value='9' <%=selCheck(status,"9")%>>신청확정</option>
							<option value='1' <%=selCheck(status,"1")%>>신청취소</option>
						</select>
						으로 변경합니다.
						</form>
					</div>
				</div>
				<% End IF %>

				<form name="boardform" id="boardform" action="bbswriteok.asp" method="post" ENCTYPE="multipart/form-data">
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
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<input type='hidden' name='serDate1' value='<%=serDate1%>'>
				<input type='hidden' name='serdate2' value='<%=serdate2%>'>
				<input type='hidden' name='sercate1' value='<%=sercate1%>'>
				<input type='hidden' name='sercate2' value='<%=sercate2%>'>
				<input type='hidden' name='sercate3' value='<%=sercate3%>'>
				<input type='hidden' name='SearchStr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<table class="tbl_row box">
					<colgroup>
						<col width="12%" />
						<col width="38%" />
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th style='text-align:right;' colspan='4'>
							등록일 : <%=Regdate%>
							<span style='color: #b50000;'>(노출일자 : <%=VIewdate%>)</span>
						</th>
					</tr>
				<% IF HK_BBS_MainYN="True" Then %>
					<tr>
						<th>메인 노출설정</th>
						<td colspan='3'>
							<label><input type='checkbox' name="isMain" value="1" <%=iif_compare(isMain, 1, "checked")%>> 메인노출</label>
							진열순서 : <input type='text' name="isMainNum" value="<%=isMainNum%>" style="width:50px; text-align:center;" maxlength="3" class="onlyNumber">
							<input type='button' value="상태변경" class="btn_gray" style='width:100px;' onclick="isMainChBtn()">
							 <span class="ml20 imp">체크시 진열순서가 높은게시물 순으로 상단에 노출. (동일할경우 노출일 기준정렬)</span>
						</td>
					</tr>
				<% End IF%>

				<% IF BBscode<>"2" Then %>
					<tr>
						<th><%=writeTit%></th>
						<td colspan='3'>
							<%=Writer%> (<%=WIP%>)
							<% IF UserName<>"" Then %>
							<span class="ml10"><a href='/backoffice/member/addmember.asp?idx=<%=useridx%>' target="_blank" style='color: #008ee3;'>[<%=UserName%> - 회원정보 바로가기]</a></span>
							<% End IF %>
						</td>
					</tr>
				<% End IF %>

				<% IF SortName<>"" Then %>
					<tr>
						<th>분류</th>
						<td colspan='3'><%=SortName%></td>
					</tr>
				<% End IF %>

				<% IF BBscode="7" OR BBscode="17" OR BBscode="26" OR BBscode="27" OR BBscode="30" Then %>
					<tr>
						<th>링크URL</th>
						<td colspan='3'><%=linkurl%></td>
					</tr>
				<% End IF %>

				<% IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then %>
					<tr>
						<th>회사명</th>
						<td><%=company%></td>
						<th>사업자등록번호</th>
						<td><%=bizcode%></td>
					</tr>
					<tr>
						<th>연락처</th>
						<td><%=tel%></td>
						<th>이메일</th>
						<td><%=email%></td>
					</tr>
					<tr>
						<th>상담분류</th>
						<td colspan="3"><%=cateNames%></td>
					</tr>
				<% ElseIF BBscode="5" OR BBscode="15" OR BBscode="25" Then %>
					<tr>
						<th>분류</th>
						<td colspan="3"><%=cateNames%></td>
					</tr>
				<% End IF %>
				<% IF bbscode="51" Then %>
					<tr>
						<th>회사명</th>
						<td><%=PT_Msg(note1)%></td>
						<th>모집부문</th>
						<td><%=PT_Msg(note2)%></td>
					</tr>
					<tr>
						<th>채용인원</th>
						<td><%=PT_Msg(note3)%></td>
						<th>고용형태</th>
						<td><%=PT_Msg(note4)%></td>
					</tr>
					<tr>
						<th>근무지역</th>
						<td colspan="3"><%=PT_Msg(note5)%></td>
					</tr>

					<tr>
						<th>채용상태</th>
						<td colspan='3'><%=recruitTerm%> <%=termStatus%></td>
					</tr>
				<% End IF %>
				<% IF BBscode="2" Then %>
					<tr>
						<th>회사명</th>
						<td><%=company%></td>
						<th>사업자등록번호</th>
						<td><%=note1%></td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td><%=tel%></td>
						<th>팩스번호</th>
						<td><%=note2%></td>
					</tr>
					<tr>
						<th>담당자명</th>
						<td><%=writer%></td>
						<th>직위</th>
						<td><%=note3%></td>
					</tr>
					<tr>
						<th>휴대폰</th>
						<td><%=phone%></td>
						<th>이메일</th>
						<td><%=email%></td>
					</tr>
					<tr>
						<th>제품선택</th>
						<td colspan="3"><%=note4%></td>
					</tr>
					<tr>
						<th>미팅방법</th>
						<td><%=note5%></td>
						<th>미팅날짜</th>
						<td><%=note6%></td>
					</tr>
					<tr>
						<th>미팅시간</th>
						<td colspan="3"><%=note7%></td>
					</tr>

				<% ElseIF BBscode="9" Then %>
					<tr>
						<th>회사명</th>
						<td><%=company%></td>
						<th>사업자등록번호</th>
						<td><%=note1%></td>
					</tr>
					<tr>
						<th>담당자명</th>
						<td><%=writer%></td>
						<th>휴대폰</th>
						<td><%=phone%></td>
					</tr>
					<tr>
						<th>이메일</th>
						<td colspan="3"><%=email%></td>
					</tr>
					<tr>
						<th>주소</th>
						<td colspan="3">[<%=note2%>] <%=note3%>&nbsp;<%=note4%></td>
					</tr>
					<tr>
						<th>현 ERP 정보</th>
						<td colspan="3"><%=note5%></td>
					</tr>
					<tr>
						<th>체험모듈</th>
						<td colspan="3"><%=note6%></td>
					</tr>
				<% End IF %>

				<% IF HK_VodUrlYN<>"False" Then %>
					<tr>
						<th>동영상URL</th>
						<td colspan='3'>
							<%=VodUrl%>
						</td>
					</tr>
				<% End IF %>

				<% IF ImgNames<>"" Then %>
					<tr>
						<th>대표이미지</th>
						<td colspan='3'><a href='javascript:openWindow(100,100,"/_lib/imgview.asp?path=board&imgname=<%=ImgNames%>","imgView","yes")'><%=ImgNames%></a></td>
					</tr>
				<% End IF %>

				<% IF BBscode<>2 AND BBscode<>9 Then %>
					<tr>
						<th><%=TitleName%></th>
						<td colspan='3'><%=TopTag&Title%></td>
					</tr>
				<% End IF %>

				<% IF HK_BBS_isCon Then %>
					<tr>
						<td colspan='4'>
							<%=PT_FileArea()%>
							<% 'IF ImgNames<>"" Then Response.write "<center><img src='/upload/board/"&ImgNames&"' width='"&ImgSize("board",550,ImgNames)&"'><p></center>" %>
							<%
								'For i=0 To Ubound(Filename)
								'	IF FileName(i)<>"" Then
								'		Exitsts=UCase(mid(filename(i),instrrev(filename(i),".")+1))
								'		IF Exitsts="JPG" Or Exitsts="JPEG" Or Exitsts="GIF" Then
								'			Response.write "<center><img src='/upload/board/"&filename(i)&"' width='"&ImgSize("board",550,filename(i))&"' onclick=""openWindow(0,0,'/common/imgview.asp?path=board&imgname="&filename(i)&"','imgview','no');"" style='cursor:pointer;'></center><br>"
								'		End IF
								'	End IF
								'Next
							%>
							<div class="ck-content"><p><%=Content%></p></div>
						</td>
					</tr>
				<% Else %>
					<%=PT_FileList%>
				<% End IF %>

				<%=PT_ReplyList()%>
				</table>
				</form>

				<% IF bbscode="8" OR bbscode="18" OR bbscode="28" OR BBscode="40" Then %>
				<form name='revFrm' id='revFrm' method='post' style='margin:0;' ENCTYPE="multipart/form-data">
				<input type='hidden' name='idx' id="modiidx" value="<%=idx%>">
				<input type='hidden' name='bbscode' value="<%=bbscode%>">
				<div class="subTitle">답변</div>
				<table class="tbl_row box">
					<colgroup>
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>처리상태</th>
						<td>
							<select name="status">
								<option value="0" <%=selCheck(0, status)%>>접수문의</option>
								<option value="1" <%=selCheck(1, status)%>>처리중</option>
								<option value="9" <%=selCheck(9, status)%>>완료</option>
							</select>
							<% IF memoWid<>"" Then %>
							<span class="ml10" style='color:#000;'>최종 수정자 : <%=memoWname%> [<%=memoWid%>] | <%=memoModDate%></span>
							<% End IF %>

							<% IF sendMailWid<>"" Then %>
							<span class="ml30" style='color: #bf0000;'>최종 메일 발송자 : <%=sendMailWname%> [<%=sendMailWid%>] | <%=sendMailModDate%></span>
							<% End IF %>
						</td>
					</tr>

					<tr>
						<th class="reqTitle">첨부파일</th>
						<td>
							<div class="filesArea">
								<a href="javascript:void(0)" class="filePlus" maxCnt="10" fNm="dfiles" fDNm="dfiledel_idx"><span>파일추가</span></a>
							<% IF IsArray(ARRMEMOFILENM) Then %>
								<% For i=0 To UBound(ARRMEMOFILENM) %>
								<div class="file fileArea">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="dfiles" title="파일첨부" class='fileField reqField' reqTitle="이미지"></span>
									</span>
									<a class="thumb"></a>
									<p class="checkIn">
										<input type='checkbox' name='delchk' value='1' id="dfiledel_idx<%=i%>" dataVal="1" class="fileFieldChk">
										<label class="labelTxt ml10" for="dfiledel_idx<%=i%>">삭제</label>
										<input type='hidden' name='dfiledel_idx' value='0' class="fileDelidx">
										<input type='hidden' name='dbdfiles' value='<%=ARRMEMOFILENM(i)%>'>
									</p>
									<%=PT_FileThumbImgTag(ARRMEMOFILENM(i), "board")%>
									<span class="fDBArea">첨부파일 (<a href="/_lib/download.asp?path=board&downfile=<%=ARRMEMOFILENM(i)%>" class="ellipsis"><%=ReplaceNoHtml(ARRMEMOFILENM(i))%></a>)</span>
								</div>
								<% Next%>
							<% Else %>
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="dfiles" title="파일첨부" class='fileField reqField' reqTitle="이미지"/></span>
									</span>
									<a class="thumb"></a>
									<input type='hidden' name='dfiledel_idx' value='1' class="fileDelidx">
									<input type='hidden' name='dbdfiles' value=''>
								</div>
							<% End IF %>
							</div>
						</td>
					</tr>

					<tr>
						<th>처리중 답변</th>
						<td>
							<textarea name='adMemo' style='width:100%; word-break:break-all; padding:10px;' rows='7'><%=adMemo%></textarea>
						</td>
					</tr>
					<tr>
						<th>완료 답변</th>
						<td>
							<textarea name='adMemo1' style='width:100%; word-break:break-all; padding:10px;' rows='7'><%=adMemo1%></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div style='' class="mt5"><a href="javascript:adMemoOk()" class="btn_gray bc_green" style='width:100%; font-size:14px; line-height:20px;'>답변 저장</a></div>
						</td>
					</tr>
				</table>
				</form>
				<% End IF %>

				<% IF HK_comYn=True Then %>
				<div id="boardCommentDiv" name="boardCommentDiv" style='width:100%;'></div>
				<% End IF%>

				<div class="btn_center pt30">
					<% IF CStr(status)<>"0" Then%>
						<a class="btn_largeG bc_green" href="javascript:sendMail()">답변 메일발송</a>
					<% End IF %>

					<% IF HK_RepYN = "True" AND TopYN="False" AND HK_imgYN="False" Then %>
						<a href="bbsReply.asp?page=<%=Page%>&idx=<%=Idx%>&ref=<%=Ref%>&relevel=<%=ReLevel%>&<%=PageStr%>" class="btn_largeG">답변</a>
					<% End IF %>
					<% IF BBscode<>"2" AND BBscode<>"9" Then %>
					<a href="bbswrite.asp?page=<%=Page%>&idx=<%=Idx%>&<%=PageStr%>" class="btn_largeG">수정</a>
					<% End IF %>
					<a href="javascript:boardDel(<%=Idx%>);" class="btn_largeG">삭제</a>
					<a href="bbslist.asp?page=<%=Page%>&<%=PageStr%>" class="btn_largeW">목록</a>
				</div>
 
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->