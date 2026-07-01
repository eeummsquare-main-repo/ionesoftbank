<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub08" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("pageSize"),"int","","20")
seritem = uf_getRequest(Request("seritem"),"int","","0")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = ""
PageStr = "pagesize="&PageSize&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)

IF SearchStr <> "" Then
	IF seritem="0" Then
		strWhere = strWhere & " AND title Like N'%"&SearchStr&"%'"
	Else
		strWhere = strWhere & " AND addr1 Like N'%"&SearchStr&"%'"
	End IF
End IF
'=============================================

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="SELECT TOP "&PageSize&" idx, isDisplay, regdate, title, tel, owner, addr1, addr2 FROM storeAdmin WHERE 1=1 "& strWhere&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from storeAdmin Where 1=1 "& strWhere&" ORDER BY listNum ASC, Idx ASC) ORDER BY listNum ASC, Idx ASC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) from storeAdmin Where 1=1 "& strWhere)
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

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BBsList
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr align='center' "&TrBg&" id=""tr_"&i&""">"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&Allrec(0,i)&"'><input type='hidden' name='dbidx' value='"&Allrec(0,i)&"'></td>"&Vbcrlf
			Response.Write "<td>"&i+1&"</td>"&Vbcrlf
			Response.Write "<td>"&ChageisDisplay(Allrec(1,i))&"</td>"&Vbcrlf
			Response.Write "<td>"&ReplaceNoHtml(Allrec(3,i))&"</td>"&Vbcrlf
			'Response.Write "<td>"&ReplaceNoHtml(Allrec(4,i))&"</td>"&Vbcrlf
			Response.Write "<td>"&ReplaceNoHtml(Allrec(6,i))&"&nbsp;"&ReplaceNoHtml(Allrec(7,i))&"</td>"&Vbcrlf
			Response.Write "<td>"&Left(Allrec(2,i),10)&"</td>"&Vbcrlf
			Response.Write "<td>"&Vbcrlf
			Response.Write "	<a href=""write.asp?idx="&Allrec(0,i)&"&page="&page&"&"&PageStr&""" class=""btn_default btn_green"">수정</a>"&Vbcrlf
			Response.Write "	<a href=""javascript:boardDel("&Allrec(0,i)&");"" class=""btn_default btn_red"">삭제</a>"&Vbcrlf
			Response.Write "</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr><td colspan='7' align='center' height='100'>검색된 게시물이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript" src="/_lib/js/jquery.tablednd.js"></script>
<style>
.dragTR td{background-color:#d4d4d4}
</style>
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
	document.actFrm.method = "get";
	document.actFrm.pagesize.value = pSize;
	document.actFrm.action = "list.asp";
	document.actFrm.submit();
}

function boardDel(idx){
	var value=confirm("선택하신 게시물을 삭제하시겠습니까?");
	if(value){
		document.boardform.idx.value = idx;
		document.boardform.action="remove.asp"
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
		document.boardform.action = "remove.asp";
		document.boardform.submit();
	}
}
function searchGo(){
	var f=document.searchFrm;
	f.submit();
}

function allRemove(){
	var val = confirm("모든 게시물을 삭제합니다.\n해당 작업은 되돌릴수 없습니다.\n삭제하시겠습니까?");

	if (val){
		document.boardform.action = "removeAll.asp";
		document.boardform.submit();
	}
}

function excelUpload(){
	$.ajax({
		type:"post",
		url: "excelUploadForm.asp",
		data:"",
		dataType:"html",
		async: true,
		beforeSend : function(){
			popupLoadingOpen();
		}
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}
//-->
</SCRIPT>

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
				<div class="searchbox" style='clear:both'>
					<select name="seritem" >
						<option value="0" <%=selCheck(seritem,0)%>>We대한가게명</option>
						<option value="1" <%=selCheck(seritem,1)%>>주소</option>
					</select>
					<input type="text" name="searchstr" value="<%=ReplaceTextField(oSearchStr)%>" />
					<a href="javascript:searchGo()" class="btn_default btn_default100">검색</a>
					<a href="?" class="btn_default btn_default100">초기화</a>
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

				<form name="actFrm" method="post">
				<input type='hidden' name='page' value='<%=page%>'>
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<input type='hidden' name='seritem' value='<%=ReplaceTextField(seritem)%>'>
				<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				</form>

				<form name="boardform" method="post">
				<input type='hidden' name='idx' value=''>
				<input type='hidden' name='page' value='<%=page%>'>
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<input type='hidden' name='seritem' value='<%=ReplaceTextField(seritem)%>'>
				<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<table class="tbl_col" id="listArea">
					<colgroup>
						<col style="width: 4%" />
						<col style="width: 6%" />
						<col style="width: 7%" />
						<col style="" />
						<!-- <col style="width: 9%" /> -->
						<col style="" />
						<col style="width: 8%" />
						<col style="width: 12%" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
						<th scope="row">순번</th>
						<th scope="row">노출여부</th>
						<th scope="row">We대한가게명</th>
						<!-- <th scope="row">연락처</th> -->
						<th scope="row">주소</th>
						<th scope="row">등록일</th>
						<th scope="row">관리</th>
					</tr>
					</thead>
					<tbody>
					<%PT_BBsList%>
					</tbody>
				</table>
				</form>

				<div class="tbl_bottom">
					<div class="top_left">
						<a href="javascript:groupRemove()" class="btn_gray btn_gray100 ">선택삭제</a>
						<a href="javascript:allRemove()" class="btn_gray btn_gray100 bc_red">전체삭제</a>
					</div>

					<div class="top_right">
						<input type='button' value="EXCEL업로드" class="btn_green btn_gray100" onclick="excelUpload()">
						<a href="write.asp" class="btn_gray btn_gray100">등록</a>
					</div>
				</div>

				<%=PT_PageLink(PageLink,PageStr,"")%>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->