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
Dim Allrec
Dim BBsSelectField, strWhere
Dim Record_Cnt, TotalPage, Page, Count

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("pageSize"),"int","","20")
serstatus = uf_getRequest(Request("serstatus"),"int","","")
serisDisplay = uf_getRequest(Request("serisDisplay"),"int","","")
serismain = uf_getRequest(Request("serismain"),"int","","")
serboardsort = uf_getRequest(Request("serboardsort"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","5","1")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serCate1=uf_getRequest(Request("serCate1"),"char","","")
serCate2=uf_getRequest(Request("serCate2"),"char","","")
serCate3=uf_getRequest(Request("serCate3"),"char","","")
oSearchStr = Request("searchstr")

PageLink="bbslist.asp"
PageStr="BBscode="&BBscode&"&pagesize="&PageSize&"&serstatus="&serstatus&"&serisDisplay="&serisDisplay&"&serismain="&serismain&"&serboardsort="&serboardsort&"&serdate1="&serdate1&"&serdate2="&serdate2&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)

IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then
	IF serCate1<>"" Then StrWhere = StrWhere & " AND cate1='"&serCate1&"'"
	IF serCate2<>"" Then StrWhere = StrWhere & " AND cate2='"&serCate2&"'"
	IF serCate3<>"" Then StrWhere = StrWhere & " AND cate3='"&serCate3&"'"

	IF serCate1<>"" Then PageStr = PageStr & "&serCate1="&serCate1
	IF serCate2<>"" Then PageStr = PageStr & "&serCate2="&serCate2
	IF serCate3<>"" Then PageStr = PageStr & "&serCate3="&serCate3

	IF serCate1<>"" THen
		Sql = "SELECT code, name From COMCODE WHERE groupCode='"&serCate1&"' Order By listNum ASC,idx ASC"
		Set Rs=DBcon.Execute(Sql)
		IF Not(Rs.Bof Or Rs.Eof) Then cate2Rec=Rs.GetRows()
		Set Rs=Nothing
	End IF

	IF serCate2<>"" THen
		Sql = "SELECT code, name From COMCODE WHERE groupCode='"&serCate2&"' Order By listNum ASC,idx ASC"
		Set Rs=DBcon.Execute(Sql)
		IF Not(Rs.Bof Or Rs.Eof) Then cate3Rec=Rs.GetRows()
		Set Rs=Nothing
	End IF
End IF
'=============================================

IF serDate1 <> "" Then strWhere = strWhere & " AND regdate>'"&serDate1&"'"
IF serDate2 <> "" Then strWhere = strWhere & " AND regdate<'"&DateAdd("d",1,serDate2)&"'"
IF serboardsort<>"" Then strWhere = strWhere & " AND boardsort="&serboardsort&" "
IF SearchStr <> "" Then
	IF seritem = "2" Then
		strWhere = strWhere & " AND content Like N'%"&SearchStr&"%'"
	ElseIF seritem = "3" Then
		strWhere = strWhere & " AND (title Like N'%"&SearchStr&"%' OR content Like N'%"&SearchStr&"%')"
	ElseIF seritem = "4" Then
		strWhere = strWhere & " AND writer Like N'%"&SearchStr&"%'"
	ElseIF seritem = "5" Then
		strWhere = strWhere & " AND note1 Like N'%"&SearchStr&"%'"
	Else
		seritem = "1"
		strWhere = strWhere & " AND title Like N'%"&SearchStr&"%'"
	End IF
End IF

IF BBscode="1000" Then
	IF serstatus<>"" Then strWhere = strWhere & " AND status = "&serstatus
Else
	IF serstatus="2" Then
		strWhere = strWhere & " AND replyCnt > 1"
	ElseIF serstatus="1" Then
		strWhere = strWhere & " AND submit = 1 AND replyCnt=1"
	ElseIF serstatus="0" Then
		strWhere = strWhere & " AND submit = 0"
	End IF
End IF
IF serisDisplay<>"" Then strWhere = strWhere & " AND isDisplay = "&serisDisplay
IF serismain<>"" Then strWhere = strWhere & " AND isMain = "&serismain

BBsSelectField = GetBoardSortSh_Admin(BBsCode,serboardsort)

Set Rs=Server.CreateObject("ADODB.RecordSet")
'===========BBS 언어 그룹 리스트=============
Sql="select idx, langIndex from boardAdmin WHERE subMenuCode='"&subMenuCode&"' Order By idx ASC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then bbsGroupRec=Rs.GetRows
Rs.Close
'===========================================

Sql="select top "&PageSize&" b.idx, title, regdate, writer, relevel, DelYN, topyn, publicYN, readnum, CommentCnt, submit, status, startdate, enddate, replyCnt, viewdate, note1, tel, sortname, note2, note3, isDisplay, setYear, isMain, always, deadline, cate1 AS cateNm1, DBO.FN_CODENAME(cate1, cate2) AS cateNm2, DBO.FN_CODENAME(cate2, cate3) AS cateNm3, isimp, DBO.FN_CODENAME( CASE WHEN b.boardidx=5 THen 'amaCate' WHEN b.boardidx=15 THEN 'icubeCate' Else 'bizboxCate' END  , cate1) AS vodCateNm FROM View_bbslist AS b Left Outer Join BoardSort ON boardsort=boardsort.idx WHERE b.boardidx="&BBsCode & strWhere&" AND b.idx NOT IN (select top "&(Page-1)*PageSize&" idx from View_bbslist Where boardidx="&BBsCode & strWhere&" order by Topyn DESC, sortDate DESC, Ref desc, ReLevel ASC, Idx DESC) order by Topyn DESC, sortDate DESC, Ref desc, ReLevel ASC, b.Idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) from View_bbslist Where boardidx="&BBsCode & strWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count = 0 : TotalPage = 1

	IF CInt(page)>1 Then
		Response.Redirect "?page="&CInt(page)-1&"&"&PageStr
	End IF
End If
Rs.Close

IF BBscode="9" Then
	Sql = "SELECT binqTopimgNm FROM shopinfo"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then binqTopimgNm = Rs("binqTopimgNm")
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

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

Dim basicListColumn : basicListColumn = 8
IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then basicListColumn = 10
IF BBsSelectField<>"" Then basicListColumn = basicListColumn + 1
IF BBscode=51 Then isViewTermStatus = True : basicColumnCnt = basicColumnCnt + 1
IF HK_BBS_MainYN="True" Then basicListColumn = basicListColumn + 1
IF BBscode="2" OR BBscode="9" Then basicListColumn = basicListColumn - 1

Function PT_BBsList
	Dim i,Num,LevelView,Depth,j,TitleView,TopTag,TrBg,PublicIcon,CommentCnt
	Dim NewIcon, StatusStr
	Num=1

	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)

		For i=0 To Ubound(Allrec,2)
			PublicIcon="" : CommentCnt="" : NewIcon="" : TopTag=Num : TrBg="" : StatusStr="" : termTag=""

			status = changeBlank(Allrec(11,i))
			startdate = changeBlank(Allrec(12,i))
			enddate = changeBlank(Allrec(13,i))
			always = changeBlank(Allrec(24,i))
			deadline = changeBlank(Allrec(25,i))
			isimp = changeBlank(Allrec(29,i))

			IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then
				cateNm1 = changeBlank(Allrec(26,i))
				cateNm2 = changeBlank(Allrec(27,i))
				cateNm3 = changeBlank(Allrec(28,i))
				vodCateNm = changeBlank(Allrec(30,i))

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
			End IF

			IF bbscode=1000 And Allrec(4,i)="A" Then
				StatusStr="<div>["&getCampaignSponStatusNm(Allrec(11,i))&"]</div>"
			End IF

			IF (BBscode=1000) And Allrec(4,i)="A" Then
				termTag="<div style='font-size:12px; line-height:1.6'>["&Allrec(12,i)&" ~ "&Allrec(13,i)&"]</div>"
			End IF

			IF BBscode=51 And Allrec(4,i)="A" Then
				IF always="1" Then
					termTag="<div style='font-size:12px; margin-bottom:5px; color: #9f0000'>[상시채용]</div>"
				ElseIF startdate="" AND enddate="" Then
					termTag="<div style='font-size:12px; margin-bottom:5px; color: #9f0000'>[채용시까지]</div>"
				ElseIF enddate="" Then
					termTag="<div style='font-size:12px; margin-bottom:5px; color: #9f0000'>"&startDate& " ~ 채용시까지</div>"
				Else
					termTag="<div style='font-size:12px; margin-bottom:5px; color: #9f0000'>["&Allrec(12,i)&" ~ "&Allrec(13,i)&"]</div>"
				End IF

				IF deadline="1" Then
					termStatus = "<span style='color: #a20000'>마감</span>"
				ElseIF always="1" Then
					termStatus = "<span style='color: #000'>진행중</span>"
				Else
					IF CStr(Date()) > CStr(enddate) AND enddate<>"" Then							'마감
						termStatus = "<span style='color: #a20000'>마감</span>"
					ElseIF CStr(Date()) < CStr(startdate) AND startdate<>"" Then						'예정
						termStatus = "<span style='color: #d3d3d3'>예정</span>"
					Else																								'진행
						termStatus = "<span style='color: #000'>진행중</span>"
					End IF
				End IF
			End IF

			IF Allrec(9,i)<>0 Then CommentCnt=" <img src='/_lib/memberimg/CommentCnt.gif'><span style='font-size:11px;'>["&Allrec(9,i)&"]</span>"
			IF Len(Allrec(4,i))<>1 Then
				LevelView="<span style='padding-left:"&(Len(Allrec(4,i))-1)*10&"px'><img src='/_lib/memberimg/icon_re.gif' border='0'> </span>"
			Else
				LevelView=""
			End IF

			IF Allrec(7,i)="True" AND Len(Allrec(4,i))=1 Then PublicIcon="<img src='/_lib/memberimg/public.gif' align='absmiddle' border='0'>"

			IF Allrec(6,i)="True" Then TopTag="<img src='/_lib/memberimg/icon_notice.gif'>" : TrBg="bgcolor='#F6F6F6'"
			IF Allrec(5,i)="True" Then
				TitleView="삭제된 게시물입니다."
			Else
				TitleView="<a href='bbsView.asp?page="&page&"&idx="&Allrec(0,i)&"&"&PageStr&"'>"& LevelView & PublicIcon & ReplaceNoHtml(Allrec(1,i)) &"</a>"
			End IF

			IF CDate(Allrec(2,i))>=Date() Then NewIcon="&nbsp;<img src='/_lib/memberimg/ico_new.gif' align='absmiddle' border='0'>"

			impTag = ""
			IF isimp="1" Then impTag = "<span class=""bbsimp"">중요</span>"

			Response.Write "<tr align='center' "&TrBg&">"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&Allrec(0,i)&"'></td>"&Vbcrlf
			Response.Write "<td>"&TopTag&"</td>"&Vbcrlf
			IF HK_BBS_MainYN="True" Then
			Response.Write "<td>"&isDisplayYN(Allrec(23,i))&"</td>"&Vbcrlf
			End IF
			IF BBscode<>"2" AND BBscode<>"9" Then
				Response.Write "<td>"&ChageisDisplay(Allrec(21,i))&"</td>"&Vbcrlf
			End IF
			IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then
				Response.Write "<td>"&cateNames&"</td>"&Vbcrlf
			End IF
			IF BBsSelectField<>"" Then
				Response.Write "<td>"&Allrec(18,i)&"</td>"&Vbcrlf
			End IF
			Response.Write "<td class='left'>"& impTag &StatusStr & termTag & TitleView &CommentCnt&NewIcon&"</td>"&Vbcrlf
			Response.Write "<td>"&Replace(ReplaceNoHtml(Allrec(3,i)),"|","<br>")&"</td>"&Vbcrlf

			IF isViewTermStatus Then
				Response.Write "<td>"&termStatus&"</td>"&Vbcrlf
			End IF
			Response.Write "<td>"&Allrec(8,i)&"</td>"&Vbcrlf
			IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then
				Response.Write "<td>"&getApplyStatus(status)&"</td>"&Vbcrlf
			End IF
			Response.Write "<td>"&Left(Allrec(15,i),10)&"</td>"&Vbcrlf
			Response.Write "<td>"&Vbcrlf
			Response.Write "	<a href=""javascript:boardDel("&Allrec(0,i)&");"" class=""btn_default bc_red"">삭제</a>"&Vbcrlf
			IF BBscode=1000 Then
			Response.Write "	<a href=""/backoffice/empApply?serEmpidx="&Allrec(0,i)&""" class=""btn_default bc_green"" style='width:90px;'>지원내역보기</a>"&Vbcrlf
			End IF
			Response.Write "</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='"&basicListColumn&"' align='center' height='100'>검색된 게시물이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function

IF BBscode="1000" Then
	writeTit = "지점명"
Else
	writeTit = "작성자"
End IF

Function PT_cate2SelBox()
	Dim code, name
	IF isArray(cate2Rec) Then
		Response.Write "<select name=""sercate2"">"&Vbcrlf
		Response.Write "	<option value=''>- 분류 전체 -</option>"
		For i=0 To Ubound(cate2Rec,2)
			code = ChangeBlank(cate2Rec(0,i))
			name = ChangeBlank(cate2Rec(1,i))

			Response.write "<option value="""&code&""" "&iif_compare(code, sercate2, "selected")&">"&name&"</option>"&vbcrlf
		Next
		Response.Write "</select>"&Vbcrlf
	End IF
End Function

Function PT_cate3SelBox()
	Dim code, name
	IF isArray(cate3Rec) Then
		Response.Write "<select name=""sercate3"">"&Vbcrlf
		Response.Write "	<option value=''>- 분류 전체 -</option>"
		For i=0 To Ubound(cate3Rec,2)
			code = ChangeBlank(cate3Rec(0,i))
			name = ChangeBlank(cate3Rec(1,i))

			Response.write "<option value="""&code&""" "&iif_compare(code, sercate3, "selected")&">"&name&"</option>"&vbcrlf
		Next
		Response.Write "</select>"&Vbcrlf
	End IF
End FUnction
%>

<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript">
<!--
$(document).ready(function(){
	$(document).on("change","form[name='searchFrm'] select[name=sercate1]",function(){
		$("form[name='searchFrm'] select[name='sercate2']").val("");
		$("form[name='searchFrm'] select[name='sercate3']").val("");
		$("form[name='searchFrm']").submit();
	});
	$(document).on("change","form[name='searchFrm'] select[name=sercate2]",function(){
		$("form[name='searchFrm'] select[name='sercate3']").val("");
		$("form[name='searchFrm']").submit();
	});
	$(document).on("change","form[name='searchFrm'] select[name=sercate3]",function(){
		$("form[name='searchFrm']").submit();
	});
});
//-->
</script>

<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	$('#ch_cIdall').change(function() {
		if ($("#ch_cIdall").is(":checked")){
			$("input[name='chkidx']").prop('checked', true);
		}else{
			$("input[name='chkidx']").prop('checked', false);
		}
	});
});

function pagesizeCnange(pSize){
	document.boardform.pagesize.value = pSize;
	document.boardform.action = "bbslist.asp";
	document.boardform.submit();
}

function boardDel(idx){
	var value=confirm("답변글이 있는경우 답변글도 모두 삭제됩니다.\n선택하신 글을 삭제하시겠습니까?");
	if(value){
		document.boardform.idx.value = idx;
		document.boardform.action="bbsdel.asp"
		document.boardform.submit();
	}
}
function groupRemove(){
	var count = $(':checkbox[name="chkidx"]:checked').length;
	var chkedIdx = [];

	if(count==0){
		alert("삭제하실 게시물을 선택하세요.");
		return;
	}
	var val = confirm("선택하신 모든 게시물을 삭제하시겠습니까?");

	if (val){
		$("input[name='chkidx']:checked").each(function(i) {
			chkedIdx.push($(this).val());
		});

		document.boardform.idx.value = chkedIdx;
		document.boardform.action = "BBsDel.asp";
		document.boardform.submit();
	}
}
function searchGo(){
	var f=document.searchFrm;
	f.submit();
}
function serExcelDown(){
	boardform.action='bbsExcelDown.asp';
	boardform.submit();
}
//-->
</SCRIPT>

<style>
.bbsimp{display:inline-block; padding:0 10px; border:1px solid #ff940b; margin-right:10px; border-radius:10px; line-height:19px; font-weight:600; color: #c97100}
</style>

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

<% IF BBscode="9" Then %>
<div class="mt20">
	<style>
	.fileDelBtn {
		background-color:#8e0000;
		color:#fff;
		border: 1px solid #8e0000;
		padding: 5px 10px;
		font-size: 12px;
		line-height: 1.6rem;
		border-radius: 4px;
		margin-left:5px;
	}
	.fileDelBtn:hover{color:#fff;}
	</style>
	<script type="text/javascript">
	$(window).load(function(){	// $(".testText").text("off2");
		$(document).on("click",".fileDelBtn",function(e){
			var confirmVal = confirm("삭제하시겠습니까?");

			if (confirmVal){
				var fieldNm = $(this).attr("dataFieldNm")
				var tbNm = $(this).attr("dataTbNm")
				var params = "tbNm="+tbNm+"&fieldNm="+fieldNm;
				var tObj = $(this)

				$.ajax({type:"POST", url:"../ajaxFileRemove.asp",data:params,dataType:"html"
				}).done(function(data){
					var rData = data.split("|")
					if (rData[0]=="OK"){
						alert("파일이 삭제 되었습니다.")
						tObj.closest(".fDBArea").remove();
					}else{
						var retMsg = rData[1].replace(/\\n/gi, "\n");
						alert(retMsg)
					}
				});
			}
		});

		$(document).on("change",".ajaxFileField",function(e){
			if ($(this).val()){
				var tObj = $(this)
				var confirmVal = confirm("파일을 변경하시겠습니까?");

				if (confirmVal){
					var fileObj = $(this)[0].files[0]
					var fieldNm = $(this).attr("dataFieldNm")
					var tbNm = $(this).attr("dataTbNm")

					var formData = new FormData();
					formData.append('files', fileObj);
					formData.append('fieldNm', fieldNm);
					formData.append('tbNm', tbNm);

					$.ajax("../ajaxFileUpload.asp", {
						method: 'post'
						,data: formData
						,processData: false
						,contentType: false
					}).done(function(data){
						var rData = data.split("|")
						if (rData[0]=="OK"){
							alert("파일이 업로드 되었습니다.")
							tObj.val("")
							tObj.closest(".file").find(".fDBArea").remove();
							tObj.closest(".file").append("<span class=\"fDBArea\">첨부파일 (<a href=\"/_lib/download.asp?path=&downfile="+rData[1]+"\" class=\"ellipsis\">"+rData[1]+"</a>) <a class='fileDelBtn' dataTbNm='"+tbNm+"' dataFieldNm='"+fieldNm+"'>삭제</a></span>")
						}else{
							var retMsg = rData[1].replace(/\\n/gi, "\n");
							alert(retMsg)
						}
					});
				}else{
					tObj.val("")
				}
			}
		});
	});
	</script>

	<form name="fileFrm" method="post" ENCTYPE="multipart/form-data" target="actFrame">
	<input type='hidden' name='bbscode' value='<%=bbscode%>'>
	<table class="tbl_row" style='margin-bottom:10px;'>
		<colgroup>
			<col style="width: 12%" />
			<col style="width: *" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="col" style='background-color: #00598e; color:#fff'>상단 이미지 관리</th>
				<td>

					<div class="filesArea">
						<div class="file ">
							<span class="file_wrap">
								<span class="btnFile">파일첨부<input type="file" name="imgfiles" title="파일첨부" class='ajaxFileField' dataTbNm="shopinfo" dataFieldNm="binqTopimgNm" /></span>
							</span>

							<% IF binqTopimgNm<>"" Then %>
							<span class="fDBArea">
								첨부파일 (<a href="/_lib/download.asp?path=&downfile=<%=binqTopimgNm%>" class="ellipsis"><%=ReplaceNoHtml(binqTopimgNm)%></a>)

								<a class='fileDelBtn' dataTbNm="shopinfo" dataFieldNm="binqTopimgNm">삭제</a>
							</span>
							<% End IF %>
						</div>
					</div>

				</td>
			</tr>
		</tbody>
	</table>
	</form>
</div>
<% End IF %>

				<% IF BBscode=1 OR BBscode=2 OR BBscode=3 OR BBscode=4 Then %>
				<!-- <div class="subTab mt20 mb20">
					<a href="bbslist.asp?bbscode=1" class="<%=iif_compare(bbscode, 1, "active")%>"><span>호텔외식조리</span></a>
					<a href="bbslist.asp?bbscode=2" class="<%=iif_compare(bbscode, 2, "active")%>"><span>호텔관광카지노</span></a>
					<a href="bbslist.asp?bbscode=3" class="<%=iif_compare(bbscode, 3, "active")%>"><span>호텔제과제빵</span></a>
					<a href="bbslist.asp?bbscode=4" class="<%=iif_compare(bbscode, 4, "active")%>"><span>호텔바리스타&소믈리에</span></a>
				</div> -->
				<% End IF %>

				<%=PT_LangMode()%>

				<form name='searchFrm' method='get' action='' onsubmit="searchGo();return false;">
				<input type='hidden' name='bbscode' value='<%=bbscode%>'>
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<table class="tbl_row">
					<colgroup>
						<col style="width: 12%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">등록일</th>
							<td>
								<div class="term_srch">
									<div class="date_wrap">
										<input type="text" name="serdate1" value="<%=serdate1%>" class="datepicker1" maxlength='10' readonly />
										~
										<input type="text" name="serdate2" value="<%=serdate2%>" class="datepicker2" maxlength='10' readonly />
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="searchbox">
					<%=BBsSelectField%>

					<% IF BBscode="5" OR BBscode="15" OR BBscode="25" OR BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then %>
					<select name="sercate1" style="width:auto;">
						<option value="">- 분류 전체 -</option>
						<% IF BBscode="8" Then %>
						<option value="uc" <%=selCheck(sercate1, "uc")%>>UC</option>
						<option value="erp" <%=selCheck(sercate1, "erp")%>>ERP</option>
						<% ElseIF BBscode="18" Then %>
						<option value="icube" <%=selCheck(sercate1, "icube")%>>iCUBE</option>
						<option value="icubeg20" <%=selCheck(sercate1, "icubeg20")%>>iCUBE G20</option>
						<% ElseIF BBscode="28" Then %>
						<option value="bizboxalpha" <%=selCheck(sercate1, "bizboxalpha")%>>Bizbox Alpha</option>
						<% ElseIF BBscode="40" Then %>
						<option value="cusetc" <%=selCheck(sercate1, "cusetc")%>>기타</option>
						<% ElseIF BBscode="5" Then %>
						<%=Create_CCodeOption("amaCate", sercate1)%>
						<% ElseIF BBscode="15" Then %>
						<%=Create_CCodeOption("icubeCate", sercate1)%>
						<% Else %>
						<%=Create_CCodeOption("bizboxCate", sercate1)%>
						<% End IF %>
					</select>
					<%=PT_cate2SelBox()%>
					<%=PT_cate3SelBox()%>
					<% End IF %>

					<% IF BBscode="1000" Then %>
					<select name="serstatus">
						<option value="">처리상태 전체</option>
						<option value='0' <%=selCheck(serstatus,"0")%>>문의접수</option>
						<option value='1' <%=selCheck(serstatus,"1")%>>접수처리</option>
						<option value='9' <%=selCheck(serstatus,"9")%>>상담완료</option>
					</select>
					<% End IF %>

					<% IF HK_BBS_MainYN="True" Then %>
					<select name="serismain">
						<option value="">상단노출 전체</option>
						<option value='0' <%=selCheck(serismain,"0")%>>비노출</option>
						<option value='1' <%=selCheck(serismain,"1")%>>노출</option>
					</select>
					<% End IF %>

					<% IF BBscode<>"2" AND BBscode<>"9" Then %>
					<select name="serisDisplay">
						<option value="">노출상태 전체</option>
						<option value="0" <%=selCheck(serisDisplay,0)%>>비노출</option>
						<option value="1" <%=selCheck(serisDisplay,1)%>>노출</option>
					</select>
					<% End IF %>

					<select name="seritem" >
						<option value="1" <%=selCheck(seritem,1)%>><%=TitleName%></option>
						<option value="4" <%=selCheck(seritem,4)%>><%=writeTit%></option>
						<option value="2" <%=selCheck(seritem,2)%>>내용</option>
						<option value="3" <%=selCheck(seritem,3)%>><%=TitleName%>+내용</option>
					</select>
					<input type="text" name="searchstr" value="<%=ReplaceTextField(oSearchStr)%>" />
					<a href="javascript:searchGo()" class="btn_default btn_default100">검색</a>
					<a href="?bbscode=<%=bbscode%>&pagesize=<%=pagesize%>" class="btn_default btn_default100">초기화</a>
				</div>
				</form>

				<div class="tbl_top">
					<p class="top_left inquiry">전체 <span><%=Count%></span>건의 게시물이 검색되었습니다</p>
					<div class="top_right">
						<select name="pagesize" onchange="pagesizeCnange(this.value)">
							<option value="10" <%=selCheck(pagesize,10)%>>10줄씩 보기</option>
							<option value="20" <%=selCheck(pagesize,20)%>>20줄씩 보기</option>
							<option value="30" <%=selCheck(pagesize,30)%>>30줄씩 보기</option>
							<option value="50" <%=selCheck(pagesize,50)%>>50줄씩 보기</option>
						</select>
					</div>
				</div>

				<form name="boardform" method="post">
				<input type='hidden' name='idx' value=''>
				<input type='hidden' name='BBscode' value='<%=BBscode%>'>
				<input type='hidden' name='page' value='<%=page%>'>
				<input type='hidden' name='serartistidx' value='<%=serartistidx%>'>
				<input type='hidden' name='serisDisplay' value='<%=serisDisplay%>'>
				<input type='hidden' name='serismain' value='<%=serismain%>'>
				<input type='hidden' name='serstatus' value='<%=serstatus%>'>
				<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
				<input type='hidden' name='seritem' value='<%=seritem%>'>
				<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<input type='hidden' name='serdate1' value='<%=serdate1%>'>
				<input type='hidden' name='serdate2' value='<%=serdate2%>'>
				<input type='hidden' name='sercate1' value='<%=sercate1%>'>
				<input type='hidden' name='sercate2' value='<%=sercate2%>'>
				<input type='hidden' name='sercate3' value='<%=sercate3%>'>
				<table class="tbl_col">
					<colgroup>
						<col style="width: 4%" />
						<col style="width: 6%" />
						<% IF HK_BBS_MainYN="True" Then %>
						<col style="width: 6%" />
						<% End IF %>
						<% IF BBscode<>"2" AND BBscode<>"9" Then %>
						<col style="width: 6%" />
						<% End IF %>
						<% IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then %>
						<col style="width: 16%" />
						<% End IF %>
						<% IF BBsSelectField<>"" Then %>
						<col style="width: 10%" />
						<% End IF %>
						<col style="*" />
						<col style="width: 9%" />
						<% IF isViewTermStatus Then %>
						<col style="width: 6%" />
						<% End IF %>
						<col style="width: 6%" />
						<% IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then %>
						<col style="width: 8%" />
						<% End IF %>
						<col style="width: 8%" />
						<% IF BBscode=1000 Then %>
						<col style="width: 15%" />
						<% Else %>
						<col style="width: 7%" />
						<% End IF %>
					</colgroup>
					<tr bgcolor="#F5F5F5">
						<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
						<th scope="row">순번</th>
						<% IF HK_BBS_MainYN="True" Then %>
						<th scope="row">상단노출</th>
						<% End IF %>
						<% IF BBscode<>"2" AND BBscode<>"9" Then %>
						<th scope="row">노출상태</th>
						<% End IF %>
						<% IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then %>
						<th scope="row">문의분류</th>
						<% ElseIF BBscode="5" OR BBscode="15" OR BBscode="25" Then %>
						<th scope="row">분류</th>
						<% End IF %>
						<% IF BBsSelectField<>"" Then %>
						<th scope="row">분류</th>
						<% End IF %>
						<th scope="row"><%=TitleName%></th>
						<th scope="row"><%=writeTit%></th>
						<% IF isViewTermStatus Then %>
						<th scope="row">진행상태</th>
						<% End IF %>
						<th scope="row">조회</th>
						<% IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then %>
						<th scope="row">상태</th>
						<th scope="row">등록일</th>
						<% Else %>
						<% IF BBscode="2" OR BBscode="9" Then %>
						<th scope="row">등록일</th>
						<% Else %>
						<th scope="row">노출일</th>
						<% End IF %>
						<% End IF %>
						<th scope="row">관리</th>
					</tr>
					<%PT_BBsList%>
				</table>
				</form>

				<div class="tbl_bottom">
					<div class="top_right">
						<a href="javascript:groupRemove()" class="btn_gray bc_red" style='width:100px'>선택게시물삭제</a>
						<% IF BBscode<>"2" AND BBscode<>"9" Then %>
						<a href="bbswrite.asp?BBsCode=<%=BBsCode%>" class="btn_gray btn_gray100">등록하기</a>
						<% End IF %>
					</div>
				</div>

				<%=PT_PageLink(PageLink,PageStr,"")%>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->