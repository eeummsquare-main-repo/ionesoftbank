<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec,TitleImg
Dim strWhere
Dim serDate1, serDate2, seritem, serStr
Dim Record_Cnt,TotalPage,PageSize,Page,Count
Dim langmode,langTitle

serboardsort = Request("serboardsort")
sersubsort = Request("sersubsort")
serDate1 = Request("serDate1")
serDate2 = Request("serDate2")
seritem = Request("seritem")
serStr = Request("serStr")
pageSize = Request("PageSize")
langmode = 1
IF serboardsort<>"1" Then sersubsort=""

Call getLangModeTitle(langmode)

Page=GetPage()
IF PageSize = "" Then PageSize=20

IF serboardsort <> "" Then strWhere = strWhere & " AND boardsort='"&serboardsort&"'"
IF sersubsort <> "" Then strWhere = strWhere & " AND subsort='"&sersubsort&"'"
IF serDate1 <> "" Then strWhere = strWhere & " AND regdate>'"&serDate1&"'"
IF serDate2 <> "" Then strWhere = strWhere & " AND regdate<'"&DateAdd("d",1,serDate2)&"'"
IF serStr <> "" Then
	IF seritem = "2" Then
		strWhere = strWhere & " AND content Like '%"&serStr&"%'"
	ElseIF seritem = "3" Then
		strWhere = strWhere & " AND (title Like '%"&serStr&"%' OR content Like '%"&serStr&"%')"
	Else
		seritem = "1"
		strWhere = strWhere & " AND title Like '%"&serStr&"%'"
	End IF
End IF

Sql="select top "&PageSize&" idx, title, regdate, boardsort, isDisplay from Faq WHERE langmode="&langmode&" "&strWhere&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from Faq WHERE langmode="&langmode&" "&strWhere&" order by Idx DESC) order by Idx DESC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) from Faq WHERE langmode="&langmode&" "&strWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count = 0 : TotalPage = 1

	IF CInt(page)>1 Then
		Response.Redirect "?page="&CInt(page)-1&"&langmode="&langmode&"&serboardsort="&serboardsort&"&sersubsort="&sersubsort&"&serdate1="&serdate1&"&serdate2="&serdate2&"&pagesize="&pagesize&"&seritem="&seritem&"&serstr="&serstr
	End IF
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BBsList
	Dim i,Num,LevelView,Depth,j,TitleView,TopTag,TrBg,PublicIcon
	Num=1

	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr>"&Vbcrlf
			Response.Write "	<td><input type='checkbox' name='chkidx' id='chkidx' value="""&Allrec(0,i)&"""></td>"&Vbcrlf
			Response.Write "	<td>"&Num&"</td>"&Vbcrlf
			'Response.Write "	<td>"&getFaqSortName(Allrec(3,i))&"</td>"&Vbcrlf
			Response.Write "	<td>"&ChangeIsDisplay(Allrec(4,i))&"</td>"&Vbcrlf
			Response.Write "	<td class='left'><a href=""javascript:boardModify("&Allrec(0,i)&");"">"&ReplaceNoHtml(Allrec(1,i))&"</a></td>"&Vbcrlf
			Response.Write "	<td>"&Left(Allrec(2,i),10)&"</td>"&Vbcrlf
			Response.Write "	<td>"&Vbcrlf
			Response.Write "		<a href=""javascript:boardModify("&Allrec(0,i)&");"" class=""btn_default"">수정</a>"&Vbcrlf
			Response.Write "		<a href=""javascript:boardDel("&Allrec(0,i)&");"" class=""btn_default"">삭제</a>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='6' style=""height:200px;"">검색된 게시물이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
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
	document.paramtransFrm.pagesize.value = pSize;
	document.paramtransFrm.action = "faqList.asp";
	document.paramtransFrm.submit();
}
function boardModify(idx){
	document.paramtransFrm.idx.value = idx;
	document.paramtransFrm.action = "faqWrite.asp";
	document.paramtransFrm.submit();
}
function boardDel(idx){
	var value=confirm("선택하신 게시물을 삭제하시겠습니까?");
	if(value){
		document.paramtransFrm.idx.value = idx;
		document.paramtransFrm.action = "faqDel.asp";
		document.paramtransFrm.submit();
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

		document.paramtransFrm.idx.value = chkedIdx;
		document.paramtransFrm.action = "faqDel.asp";
		document.paramtransFrm.submit();
	}
}
function searchGo(){
	var f=document.searchFrm;
	f.submit();
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
					<h2 class="top_left"><%=GB_SubMenuName%><!-- (<%=langTitle%>)--></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<form name='searchFrm' method='get' action='' onsubmit="searchGo();return false;">
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<table class="tbl_row">
					<colgroup>
						<col style="width: 12%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<!-- <tr>
							<th scope="col">언어</th>
							<td>
								<select name="langmode" onchange="location.href='?langmode='+this.value">
									<option value="1" <%=selCheck(langmode,1)%>>국문 MODE</option>
									<option value="2" <%=selCheck(langmode,2)%>>일문 MODE</option>
									<option value="3" <%=selCheck(langmode,3)%>>중문 MODE</option>
									<option value="4" <%=selCheck(langmode,4)%>>영문 MODE</option>
								</select>
							</td>
						</tr> -->
						<!-- <tr>
							<th scope="col">검색분류</th>
							<td>
								<select name="serboardsort" id="serboardsort" onchange="changeSubCate()">
									<option value="">등록분류 전체</option>
									<option value="0" <%=selCheck(serboardsort, 0)%>>치아교정</option>
									<option value="1" <%=selCheck(serboardsort, 1)%>>임플란트</option>
									<option value="2" <%=selCheck(serboardsort, 2)%>>심미보정</option>
								</select>
							</td>
						</tr> -->

						<tr>
							<th scope="col">등록일</th>
							<td>
								<div class="term_srch">
									<div class="date_wrap">
										<input type="text" name="serdate1" value="<%=serdate1%>" class="datepicker1 onlyNumber" maxlength='10' onKeyUp="dateFormat(this);" readonly />
										~
										<input type="text" name="serdate2" value="<%=serdate2%>" class="datepicker2 onlyNumber" maxlength='10' onKeyUp="dateFormat(this);" readonly />
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="searchbox">
					<select name="seritem">
						<option value="1" <%=selCheck(seritem,1)%>>제목</option>
						<option value="2" <%=selCheck(seritem,2)%>>내용</option>
						<option value="3" <%=selCheck(seritem,3)%>>제목+내용</option>
					</select>
					<input type="text" name="serstr" value="<%=serStr%>" />
					<a href="javascript:searchGo()" class="btn_default btn_default100">검색</a>
					<a href="?pagesize=<%=pagesize%>" class="btn_default btn_default100">초기화</a>
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

				<table class="tbl_col">
					<caption>FAQ 목록</caption>
					<colgroup>
						<col style="width: 3%" />
						<col style="width: 6%" />
						<!-- <col style="width: 10%" /> -->
						<col style="width: 6%" />
						<col style="width: *" />
						<col style="width: 8%" />
						<col style="width: 13%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
							<th scope="row">NO</th>
							<!-- <th scope="row">분류</th> -->
							<th scope="row">공개여부</th>
							<th scope="row">제목</th>
							<th scope="row">등록일</th>
							<th scope="row">관리</th>
						</tr>
					</thead>
					<tbody>
						<%PT_BBsList%>
					</tbody>
				</table>

				<div class="tbl_bottom">
					<div class="top_left">
						<a href="javascript:groupRemove()" class="btn_gray btn_gray100">선택삭제</a>
					</div>

					<div class="top_right">
						<a href="faqwrite.asp" class="btn_gray btn_gray100">신규등록</a>
					</div>
				</div>

				<%=PT_PageLink("","langmode="&langmode&"&serboardsort="&serboardsort&"&sersubsort="&sersubsort&"&serdate1="&serdate1&"&serdate2="&serdate2&"&pagesize="&pagesize&"&seritem="&seritem&"&serstr="&serstr,"")%>

				<form name="paramtransFrm" id="paramtransFrm" method="get">
					<input type="hidden" name="idx" value="">
					<input type="hidden" name="page" value="<%=page%>">
					<input type="hidden" name="langmode" value="<%=langmode%>">
					<input type="hidden" name="serboardsort" value="<%=serboardsort%>">
					<input type="hidden" name="sersubsort" value="<%=sersubsort%>">
					<input type="hidden" name="serdate1" value="<%=serDate1%>">
					<input type="hidden" name="serdate2" value="<%=serDate2%>">
					<input type="hidden" name="pagesize" value="<%=pageSize%>">
					<input type="hidden" name="seritem" value="<%=seritem%>">
					<input type="hidden" name="serstr" value="<%=serStr%>">
				</form>
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->