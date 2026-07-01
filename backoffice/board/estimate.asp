<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "board" : subMenuCode = "estimate" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Page = uf_getRequest(Request("Page"),"int","","1")
pagesize = uf_getRequest(Request("pagesize"),"int","","20")

serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","2","0")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

IF serStatus <> "" Then strWhere = strWhere & " AND E.status="&serStatus
IF serDate1 <> "" Then strWhere = strWhere & " AND E.regdate>'"&serDate1&"'"
IF serDate2 <> "" Then strWhere = strWhere & " AND E.regdate<'"&DateAdd("d",1,serDate2)&"'"
IF SearchStr <> "" Then
	IF seritem = "1" Then
		strWhere = strWhere & " AND M.id Like N'%"&SearchStr&"%'"
	ElseIF seritem = "2" Then
		strWhere = strWhere & " AND E.idx IN (SELECT oidx FROM estimateDetail WHERE itemname Like '%"&SearchStr&"%')"
	Else
		strWhere = strWhere & " AND M.name Like N'%"&SearchStr&"%'"
	End IF
End IF

PageLink="estimate.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="SELECT Top "&PageSize&" E.idx, M.name, itemnames, E.regdate, E.status FROM estimate E LEFT OUTER JOIN Members M ON E.useridx = M.idx WHERE 1=1 "&strWhere&" AND E.idx NOT IN (select top "&(Page-1)*PageSize&" E.idx FROM estimate E LEFT OUTER JOIN Members M ON E.useridx = M.idx WHERE 1=1 "&strWhere&" order by E.Idx DESC) order by E.Idx DESC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) FROM estimate E LEFT OUTER JOIN Members M ON E.useridx = M.idx WHERE 1=1 "&strWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count = 0 : TotalPage = 1

	IF CInt(page)>1 Then
		Response.Redirect "?page="&CInt(page)-1&"&"&PageStr
	End IF
End IF
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BBsList
	Dim i,Num
	Num=1

	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr align='center'>"&Vbcrlf
			Response.Write "	<td><input type=""checkbox"" name='chkidx' id='chkidx' value="""&Allrec(0,i)&""" dataPhone="""&Allrec(3,i)&"""></td>"&Vbcrlf
			Response.Write "	<td>"&Num&"</td>"&Vbcrlf
			Response.Write "	<td>"&ReplaceNoHtml(Allrec(1,i))&"</td>"&Vbcrlf
			Response.Write "	<td class=""left"">"&ReplaceNoHtml(Allrec(2,i))&"</td>"&Vbcrlf
			Response.Write "	<td>"&Vbcrlf
			Response.Write "		"&Left(Allrec(3,i),10)
			Response.Write "	</td>"&Vbcrlf
			Response.Write "	<td>"&Vbcrlf
			Response.Write "		<select name=""status"" style='width:100%;' onchange=""statusChange("&Allrec(0,i)&", this.value)"">"&Vbcrlf
			Response.Write "			<option value=""0"" "&selCheck(Allrec(4,i),0)&">견적대기</option>"&Vbcrlf
			Response.Write "			<option value=""9"" "&selCheck(Allrec(4,i),9)&">견적완료</option>"&Vbcrlf
			Response.Write "			<option value=""8"" "&selCheck(Allrec(4,i),8)&">견적취소</option>"&Vbcrlf
			Response.Write "		</select>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf

			Response.Write "	<td>"&Vbcrlf
			Response.Write "		<a href=""estimateView.asp?idx="&Allrec(0,i)&"&page="&page&"&"&PageStr&""" class=""btn_gray"">상세</a>"&Vbcrlf
			Response.Write "		<a href=""javascript:boardDel("&Allrec(0,i)&");"" class=""btn_red"">삭제</a>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf

			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='7' style=""height:200px;"">검색된 게시물이 없습니다.</td></tr>"&Vbcrlf
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

function boardDel(idx){
	var value=confirm("선택하신 신청내역을 삭제하시겠습니까?");
	if(value){
		document.paramtransFrm.idx.value = idx;
		document.paramtransFrm.action = "estimateDel.asp";
		document.paramtransFrm.submit();
	}
}
function groupRemove(){
	var count = $(':checkbox[name="chkidx"]:checked').length;
	var chkedIdx = [];

	if(count==0){
		alert("삭제하실 신청내역을 선택하세요.");
		return;
	}
	var val = confirm("선택하신 모든 신청내역을 삭제하시겠습니까?");

	if (val){
		$("input[name='chkidx']:checked").each(function(i) {
			chkedIdx.push($(this).val());
		});
		document.paramtransFrm.idx.value = chkedIdx;
		document.paramtransFrm.action = "estimateDel.asp";
		document.paramtransFrm.submit();
	}
}

function searchGo(){
	var f=document.searchFrm;
	f.submit();
}
function pagesizeCnange(pSize){
	document.paramtransFrm.pagesize.value = pSize;
	document.paramtransFrm.action = "estimate.asp";
	document.paramtransFrm.submit();
}

function statusChange(idx,status){
	if (idx==""){
		var count = $(':checkbox[name="chkidx"]:checked').length;
		var chkedIdx = [];

		if(count==0){
			alert("상태 변경하실 신청서를 선택하세요.");
			return;
		}
		var val = confirm("선택하신 모든 신청서의 상태를 수정 하시겠습니까?");

		if (val){
			$("input[name='chkidx']:checked").each(function(i) {
				chkedIdx.push($(this).val());
			});
			document.paramtransFrm.idx.value = chkedIdx;
			document.paramtransFrm.status.value = $("#groupstatus").val();
			document.paramtransFrm.action = "estimateStatusChange.asp";
			document.paramtransFrm.submit();
		}
	}else{
		var val=confirm("선택하신 게시물의 상태를 수정 하시겠습니까?");
		if(val){
			document.paramtransFrm.idx.value = idx;
			document.paramtransFrm.status.value = status;
			document.paramtransFrm.action = "estimateStatusChange.asp";
			document.paramtransFrm.submit();
		}	
	}
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
						<col style="width: 38%" />
						<col style="width: 12%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">신청일</th>
							<td>
								<div class="term_srch">
									<div class="date_wrap">
										<input type="text" name="serdate1" value="<%=serdate1%>" class="datepicker1" maxlength='10' readonly />
										~
										<input type="text" name="serdate2" value="<%=serdate2%>" class="datepicker2" maxlength='10' readonly />
									</div>
								</div>
							</td>
							<th scope="col">상태</th>
							<td>
								<select name='serstatus'>
									<option value="">상태 전체</option>
									<option value='0' <%=selCheck(serstatus, 0)%>>견적대기</option>
									<option value='9' <%=selCheck(serstatus, 9)%>>견적완료</option>
									<option value='8' <%=selCheck(serstatus, 8)%>>견적취소</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="searchbox">
					<select name="seritem">
						<option value="0" <%=selCheck(seritem,0)%>>신청자</option>
						<option value="1" <%=selCheck(seritem,1)%>>신청자ID</option>
						<option value="2" <%=selCheck(seritem,2)%>>신청제품</option>
					</select>
					<input type="text" name="searchstr" value="<%=searchstr%>" />
					<a href="javascript:searchGo()" class="btn_default btn_default100">검색</a>
					<a href="?pagesize=<%=pagesize%>" class="btn_default btn_default100">초기화</a>
					<input type='button' value="검색내역 엑셀다운" class="btn_green disNone" onclick="serExcelDown()" style="width:120px">
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
						<col style="width: 5%" />
						<col style="width: 12%" />
						<col style="" />
						<col style="width:10%" />
						<col style="width:8%" />
						<col style="width:12%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
							<th scope="row">NO</th>
							<th scope="row">신청자</th>
							<th scope="row">제품명</th>
							<th scope="row">신청일</th>
							<th scope="row">상태</th>
							<th scope="row">관리</th>
						</tr>
					</thead>
					<tbody>
						<%PT_BBsList%>
					</tbody>
				</table>

				<div class="tbl_bottom">
					<div class="top_left">
						선택하신 게시물을
						<select name='status' id="groupstatus">
							<option value='0'>견적대기</option>
							<option value='9'>견적완료</option>
							<option value='8'>견적취소</option>
						</select>
						으로
						<a href="javascript:statusChange('','')" class="btn_gray btn_gray50">변경</a>
					</div>
					<div class="top_right">
						<a href="javascript:groupRemove()" class="btn_red btn_gray100">선택삭제</a>
					</div>
				</div>

				<%=PT_PageLink("",PageStr,"")%>

				<form name="paramtransFrm" id="paramtransFrm" method="get">
					<input type="hidden" name="idx" value="">
					<input type="hidden" name="status" value="">
					<input type="hidden" name="page" value="<%=page%>">
					<input type="hidden" name="serStatus" value="<%=serStatus%>">
					<input type="hidden" name="seritem" value="<%=seritem%>">
					<input type="hidden" name="SearchStr" value="<%=ReplaceTextField(oSearchstr)%>">
					<input type="hidden" name="pagesize" value="<%=pagesize%>">
					<input type="hidden" name="serDate1" value="<%=serDate1%>">
					<input type="hidden" name="serDate2" value="<%=serDate2%>">
				</form>
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->