<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub05" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Page = uf_getRequest(Request("Page"),"int","","1")
pagesize = uf_getRequest(Request("pagesize"),"int","","20")

serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","1","0")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

IF serStatus <> "" Then strWhere = strWhere & " AND status="&serStatus
IF serDate1 <> "" Then strWhere = strWhere & " AND regdate>'"&serDate1&"'"
IF serDate2 <> "" Then strWhere = strWhere & " AND regdate<'"&DateAdd("d",1,serDate2)&"'"
IF SearchStr <> "" Then
	IF seritem = "1" Then
		strWhere = strWhere & " AND name Like N'%"&SearchStr&"%'"
	Else
		strWhere = strWhere & " AND email Like N'%"&SearchStr&"%'"
	End IF
End IF

PageLink="consult.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="SELECT Top "&PageSize&" idx, name, birthday, sex, phone, email, note1, regdate, status, hopeClass1 FROM consult WHERE 1=1 "&strWhere&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx FROM consult WHERE 1=1 "&strWhere&" order by Idx DESC) order by Idx DESC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) FROM consult WHERE 1=1 "&strWhere)
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

		Dim idx, name, birthday, sex, phone, email, note1, regdate, status
		For i=0 To Ubound(Allrec,2)
			idx = Allrec(0,i)
			name = Allrec(1,i)
			birthday = Allrec(2,i)
			sex = Allrec(3,i)
			phone = Allrec(4,i)
			email = Allrec(5,i)
			note1 = Allrec(6,i)
			regdate = Allrec(7,i)
			status = Allrec(8,i)
			hopeClass1 = Allrec(9,i)

			Response.Write "<tr align='center'>"&Vbcrlf
			Response.Write "	<td><input type=""checkbox"" name='chkidx' id='chkidx' value="""&idx&""" dataPhone="""&phone&"""></td>"&Vbcrlf
			Response.Write "	<td>"&Num&"</td>"&Vbcrlf
			Response.Write "	<td>"&ReplaceNoHtml(name)&"</td>"&Vbcrlf
			Response.Write "	<td>"&ReplaceNoHtml(email)&"</td>"&Vbcrlf
			Response.Write "	<td>"&Vbcrlf
			Response.Write "		"&Left(regdate,10)
			Response.Write "	</td>"&Vbcrlf
			Response.Write "	<td>"&Vbcrlf
			Response.Write "		<select name=""status"" style='width:100%;' onchange=""boardStatusChange("&idx&", this.value)"">"&Vbcrlf
			Response.Write "			<option value=""0"" "&selCheck(status,0)&">대기중</option>"&Vbcrlf
			Response.Write "			<option value=""1"" "&selCheck(status,1)&">접수완료</option>"&Vbcrlf
			Response.Write "			<option value=""9"" "&selCheck(status,9)&">구독취소</option>"&Vbcrlf
			Response.Write "			<option value=""99"" "&selCheck(status,99)&">신청취소</option>"&Vbcrlf
			Response.Write "		</select>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf

			Response.Write "	<td>"&Vbcrlf
			'Response.Write "		<a href=""consultView.asp?idx="&idx&"&page="&page&"&"&PageStr&""" class=""btn_gray"">보기</a>"&Vbcrlf
			Response.Write "		<a href=""javascript:boardDel("&idx&");"" class=""btn_red"">삭제</a>"&Vbcrlf
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

function boardModify(idx){
	$.ajax({
		type:"post",
		url: "consultModify_pop.asp",
		data:{"idx":idx},
		dataType:"html",
		async: true,
		beforeSend : function(){
			popupLoadingOpen();
		}
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}

function boardView(idx){
	$.ajax({
		type:"post",
		url: "consultView_pop.asp",
		data:{"idx":idx},
		dataType:"html",
		async: true,
		beforeSend : function(){
			popupLoadingOpen();
		}
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}
function boardDel(idx){
	var value=confirm("선택하신 게시물을 삭제하시겠습니까?");
	if(value){
		document.paramtransFrm.idx.value = idx;
		document.paramtransFrm.action = "consultDel.asp";
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
		document.paramtransFrm.action = "consultDel.asp";
		document.paramtransFrm.submit();
	}
}

function searchGo(){
	var f=document.searchFrm;
	f.submit();
}
function pagesizeCnange(pSize){
	document.paramtransFrm.pagesize.value = pSize;
	document.paramtransFrm.action = "consult.asp";
	document.paramtransFrm.submit();
}

function boardStatusChange(idx,status){
	if (idx==""){
		var count = $(':checkbox[name="chkidx"]:checked').length;
		var chkedIdx = [];

		if(count==0){
			alert("상태 변경하실 게시물을 선택하세요.");
			return;
		}
		var val = confirm("선택하신 모든 게시물의 상태를 수정 하시겠습니까?");

		if (val){
			$("input[name='chkidx']:checked").each(function(i) {
				chkedIdx.push($(this).val());
			});

			document.paramtransFrm.idx.value = chkedIdx;
			document.paramtransFrm.status.value = $("#groupstatus").val();
			document.paramtransFrm.action = "consultStatusChange.asp";
			document.paramtransFrm.submit();
		}
	}else{
		var val=confirm("선택하신 게시물의 상태를 수정 하시겠습니까?");
		if(val){
			document.paramtransFrm.idx.value = idx;
			document.paramtransFrm.status.value = status;
			document.paramtransFrm.action = "consultStatusChange.asp";
			document.paramtransFrm.submit();
		}	
	}
}

function serExcelDown(){
	var val = confirm("검색된 모든 내역을 엑셀 다운로드 합니다.\n데이터 양에 따라 소요시간이 길어질수 있습니다.\n다운로드 받으시겠습니까?");
	if (val){
		paramtransFrm.action='consultExcelDown.asp';
		paramtransFrm.submit();
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
									<option value='0' <%=selCheck(serstatus, 0)%>>대기중</option>
									<option value='1' <%=selCheck(serstatus, 1)%>>접수완료</option>
									<option value='9' <%=selCheck(serstatus, 9)%>>구독취소</option>
									<option value='99' <%=selCheck(serstatus, 99)%>>신청취소</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="searchbox">
					<select name="seritem">
						<option value="0" <%=selCheck(seritem,0)%>>이름</option>
						<option value="1" <%=selCheck(seritem,1)%>>이메일</option>
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
						<col style="" />
						<col style="" />
						<col style="width:8%" />
						<col style="width:8%" />
						<col style="width:6%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
							<th scope="row">NO</th>
							<th scope="row">이름</th>
							<th scope="row">이메일</th>
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
							<option value='0'>대기중</option>
							<option value='1'>접수완료</option>
							<option value='9'>구독취소</option>
							<option value='99'>신청취소</option>
						</select>
						으로
						<a href="javascript:boardStatusChange('','')" class="btn_gray btn_gray50">변경</a>
					</div>
					<div class="top_right">
						<a href="javascript:groupRemove()" class="btn_red btn_gray100">선택삭제</a>
						<!-- <a href="javascript:serExcelDown();" class="btn_green btn_gray100" style='width:120px;'>검색내역 엑셀다운</a> -->
						<!-- <a href="consultWrite.asp" class="btn_gray btn_gray100">등록하기</a> -->
					</div>
				</div>

				<%=PT_PageLink("",PageStr,"")%>

				<!-- <div style='margin-top:30px; line-height:1.6;'>
					신청서의 상태를 예약완료로 변경시 해당 예약자 연락처로 예약완료 메세지가 발송됩니다.<br>
					기존 상태가 예약완료이거나 예약일자가 지난 신청건에 대해서는 예약완료로 변경 하여도 메세지는 발송되지 않습니다.
				</div> -->

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