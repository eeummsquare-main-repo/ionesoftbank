<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "emp" : subMenuCode = "empApply" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("pageSize"),"int","","20")
seritem = uf_getRequest(Request("seritem"),"int","3","0")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
serEmpidx = uf_getRequest(Request("serEmpidx"),"int","","")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")

oSearchStr = Request("searchstr")

PageLink = "index.asp"
PageStr = "serEmpidx="& serEmpidx &"&serStatus="& serStatus &"&seritem="& seritem &"&pagesize="& PageSize &"&searchStr="& Server.UrlEncode(oSearchStr)
'=============================================

IF serEmpidx<>"" Then strWhere = strWhere & " AND empidx="&serEmpidx
IF serStatus<>"" Then strWhere = strWhere & " AND status="&serStatus
IF SearchStr <> "" Then strWhere = strWhere & " AND name LIKE N'%"&SearchStr&"%'"

Sql = "SELECT empidx, '[공고번호 : '+Convert(VARCHAR, empidx)+'] ' + MIN(empNm) FROM empApply WHERE isComplete=1 GROUP BY empidx"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then empNmRec = Rs.GetRows()

Sql = "SELECT TOP "&PageSize&" idx, regdate, empidx, empNm, appField, name, nameEn, phone, eTel, email, status FROM empApply WHERE isComplete=1"& strWhere&" AND idx NOT IN (SELECT TOP "&(Page-1)*PageSize&" idx FROM empApply Where isComplete=1"& strWhere&" ORDER BY regdate DESC, Idx DESC) ORDER BY regdate DESC, Idx DESC"
Set Rs = DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("SELECT COUNT(1) FROM empApply WHERE isComplete=1"& strWhere)
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

Function PT_ItemList
	Dim i,Num
	Num=1

	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)

		Dim idx, regdate, empidx, empNm, appField, name, nameEn, phone, eTel, email, status
		For i=0 To Ubound(Allrec,2)
			idx = ChangeBlank(Allrec(0,i))
			regdate = ChangeBlank(Allrec(1,i))
			empidx = ChangeBlank(Allrec(2,i))
			empNm = ChangeBlank(Allrec(3,i))
			appField = ChangeBlank(Allrec(4,i))
			name = ChangeBlank(Allrec(5,i))
			nameEn = ChangeBlank(Allrec(6,i))
			phone = ChangeBlank(Allrec(7,i))
			eTel = ChangeBlank(Allrec(8,i))
			email = ChangeBlank(Allrec(9,i))
			status = ChangeBlank(Allrec(10,i))

			viewLinkUrl = "view.asp?idx="&idx&"&page="&page&"&"&pageStr
			Response.Write "<tr align='center' id=""tr_"&i&""">"&Vbcrlf
			Response.Write "	<td><p class=""checkIn noTxt""><input type=""checkbox"" id=""chkidx_"&idx&""" name=""chkidx"" value="""&idx&"""><label for=""chkidx_"&idx&""">선택</label></p><input type='hidden' name='dbidx' value='"&idx&"'></td>"&Vbcrlf
			Response.Write "	<td>"&Num&"</td>"&Vbcrlf
			Response.Write "	<td><a href="""&viewLinkUrl&""">"&ReplaceNoHtml(empNm)&"</a></td>"&Vbcrlf
			Response.Write "	<td><a href="""&viewLinkUrl&""">"&ReplaceNoHtml(appField)&"</a></td>"&Vbcrlf
			Response.Write "	<td><a href="""&viewLinkUrl&""">"&ReplaceNoHtml(name)&"</a></td>"&Vbcrlf
			Response.Write "	<td><a href="""&viewLinkUrl&""">"&ReplaceNoHtml(nameEn)&"</a></td>"&Vbcrlf
			Response.Write "	<td><a href="""&viewLinkUrl&""">"&ReplaceNoHtml(phone)&"</a></td>"&Vbcrlf
			Response.Write "	<td><a href="""&viewLinkUrl&""">"&uf_ConvertDateFormat(regdate,4)&"</a></td>"&Vbcrlf
			Response.Write "	<td>"&Vbcrlf
			Response.Write "		<select name=""status"" dataidx="""&idx&""" class=""statusEv"">"&Vbcrlf
			Response.Write "			<option value=""0"" style='color:#9b0000;' "&iif_compare(status, 0, "selected")&">접수</option>"&Vbcrlf
			Response.Write "			<option value=""1"" style='color:#023cff;' "&iif_compare(status, 1, "selected")&">접수완료</option>"&Vbcrlf
			Response.Write "			<option value=""3"" style='color:#000;' "&iif_compare(status, 3, "selected")&">심사중</option>"&Vbcrlf
			Response.Write "			<option value=""4"" style='color:#000;' "&iif_compare(status, 4, "selected")&">서류전형</option>"&Vbcrlf
			Response.Write "			<option value=""5"" style='color:#000;' "&iif_compare(status, 5, "selected")&">서류전형 합격</option>"&Vbcrlf
			Response.Write "			<option value=""6"" style='color:#000;' "&iif_compare(status, 6, "selected")&">서류전형 불합격</option>"&Vbcrlf
			Response.Write "			<option value=""7"" style='color:#000;' "&iif_compare(status, 7, "selected")&">최종 합격</option>"&Vbcrlf
			Response.Write "			<option value=""8"" style='color:#000;' "&iif_compare(status, 8, "selected")&">최종 불합격</option>"&Vbcrlf
			Response.Write "		</select>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num = Num-1
		Next
	Else
		Response.Write "<tr><td colspan='9' align='center' height='150'>검색된 내역이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
var prev_val ;
$(document).ready(function(){
	$("select").each(function(i) {
		var color = $(this).children("option:selected").css("color")
		$(this).css("color", color)
	});
	$('#ch_cIdall').change(function() {
		if ($("#ch_cIdall").is(":checked")){
			$("input[name='chkidx']").prop('checked', true);
		}else{
			$("input[name='chkidx']").prop('checked', false);
		}
	});

    $(".statusEv").on('focus', function () {
        prev_val = $(this).val();
    }).change(function(){
		var idx = $(this).attr("dataidx");
		var procMode = $(this).attr("name");
		var selTxt = $(this).children("option:selected").text();
		var selVal = $(this).val();
		var objTxt = ""

		if (procMode=="status"){
			objTxt = "접수상태"
		}
		
		if (objTxt!=""){
			var confirmVal = confirm("["+objTxt+"] 상태를 ("+selTxt+")로 변경하시겠습니까?")
			if (confirmVal){
				var params = "procMode="+procMode+"&idx="+idx+"&selVal="+selVal;
				$.ajax({type:"POST", url:'proc.asp',data:params,dataType:"html",
				}).done(function(data){
					console.log(data)

					var rData = data.split("|")
					var retMsg = rData[1].replace(/\\n/gi, "\n");

					if (rData[0]=="OK"){
						alert("["+objTxt+"] 상태가 ("+selTxt+")로 변경 되었습니다.");
						location.reload();
					}else{
						alert(retMsg)
						location.reload();
					}
				});
			}else{
				$(this).val(prev_val)
			}
		}
    });

	$(document).on("click",".btnGroupCh",function(){
		var selTxt = $(this).siblings("select[name=status]").children("option:selected").text();
		var selVal = $(this).siblings("select[name=status]").val();
		var objTxt = ""
		var count = $(':checkbox[name="chkidx"]:checked').length;
		var chkedIdx = [];

		if(count==0){
			alert("상태 변경하실 게시물을 선택하세요.");
			return;
		}
		var val = confirm("선택하신 모든 게시물의 상태를 ("+selTxt+")로 변경 하시겠습니까?");
		if (val){
			$("input[name='chkidx']:checked").each(function(i) {
				chkedIdx.push($(this).val());
			});

			document.actFrm.selVal.value = selVal;
			document.actFrm.procMode.value = "groupStatus";
			document.actFrm.idx.value = chkedIdx;
			document.actFrm.action = "proc.asp";
			document.actFrm.submit();
		}
	});
});
function remove(){
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
		document.actFrm.procMode.value = "remove";
		document.actFrm.idx.value = chkedIdx;
		document.actFrm.action = "proc.asp";
		document.actFrm.submit();
	}
}

function setOrderBy(){
	var val = confirm("노출순서를 저장합니다.\n저장하시겠습니까?");
	if (val){
		document.itemFrm.procMode.value = "listnum";
		document.itemFrm.action = "proc.asp";
		document.itemFrm.submit();
	}
}

function searchGo(){
	var f=document.searchFrm;
	f.submit();
}

function serExcelDown(){
	if (confirm("검색된 내역을 엑셀로 다운로드 받습니다.\n데이터 양이 많을경우 오류가 발생할수 있습니다.\n검색 후 이용을 바랍니다.\n\n다운로드 받겠습니까?")){
		actFrm.action='_excelDown.asp';
		actFrm.submit();
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
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<form name='searchFrm' method='get' action='' onsubmit="searchGo();return false;">
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<table class="tbl_row box">
					<colgroup>
						<col style="width: 10%" />
						<col style="width: 40%" />
						<col style="width: 10%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">공고별</th>
							<td>
								<select name="serEmpidx">
									<option value="">공고 전체</option>
									<%=comSelOption(empNmRec, serEmpidx)%>
								</select>
							</td>
							<th scope="col">상태</th>
							<td>
								<select name="serStatus">
									<option value="">상태 전체</option>
									<option value="0" <%=selCheck(serStatus, 0)%>>접수</option>
									<option value="1" <%=selCheck(serStatus, 1)%>>접수완료</option>
									<option value="3" <%=selCheck(serStatus, 3)%>>심사중</option>
									<option value="4" <%=selCheck(serStatus, 4)%>>서류전형</option>
									<option value="5" <%=selCheck(serStatus, 5)%>>서류전형 합격</option>
									<option value="6" <%=selCheck(serStatus, 6)%>>서류전형 불합격</option>
									<option value="7" <%=selCheck(serStatus, 7)%>>최종 합격</option>
									<option value="8" <%=selCheck(serStatus, 8)%>>최종 불합격</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="searchbox" style="clear:both;">
					<select name="seritem" >
						<option value="0" <%=selCheck(seritem,0)%>>이름</option>
					</select>
					<input type="text" name="searchstr" value="<%=ReplaceTextField(oSearchStr)%>" />
					<a href="javascript:searchGo()" class="btn_default btn_default100">검색</a>
					<a href="?pagesize=<%=pagesize%>" class="btn_default btn_default100">초기화</a>

					<input type='button' value='검색내역 엑셀다운' class='btn_default btn_default100 bc_green' style='width:110px' onclick='serExcelDown()'>
				</div>
				</form>

				<div class="tbl_top">
					<div class="top_left">
						선택하신 게시물을
						<select name='status' id="groupstatus">
							<option value='0'>접수</option>
							<option value='1'>접수완료</option>
							<option value="3">심사중</option>
							<option value="4">서류전형</option>
							<option value="5">서류전형 합격</option>
							<option value="6">서류전형 불합격</option>
							<option value="7">최종 합격</option>
							<option value="8">최종 불합격</option>
						</select>
						으로
						<a class="btn_green btnGroupCh">변경</a>
					</div>
					<div class="top_right">
						<input type='button' value='선택게시물삭제' class='btn_gray bc_red' style='cursor:pointer; width:100px' onclick='remove()'>
					</div>
				</div>

				<form name="itemFrm" id="itemFrm" method="post" style='margin:0'>
				<input type='hidden' name="procMode" value="">
				<input type='hidden' name='page' value='<%=page%>'>
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<input type='hidden' name='serEmpidx' value='<%=serEmpidx%>'>
				<input type='hidden' name='seritem' value='<%=seritem%>'>
				<input type='hidden' name='serStatus' value='<%=serStatus%>'>
				<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<table class="tbl_col" id="listArea">
					<colgroup>
						<col style="width: 40px" />
						<col style="width: 80px" />
						<col style="*" />
						<col style="" />
						<col style="width: 100px" />
						<col style="width: 120px" />
						<col style="width: 120px" />
						<col style="width: 100px" />
						<col style="width: 130px" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row">
							<p class="checkIn noTxt"><input type="checkbox" id="ch_cIdall" name="ch_cIdall" value="1"><label for="ch_cIdall">선택</label></p>
						</th>
						<th scope="row">순번</th>
						<th scope="row">공고명</th>
						<th scope="row">지원부문</th>
						<th scope="row">이름</th>
						<th scope="row">이름(영문)</th>
						<th scope="row">연락처</th>
						<th scope="row">지원일</th>
						<th scope="row">접수상태</th>
					</tr>
					</thead>
					<tbody>
					<%=PT_ItemList%>
					</tbody>
				</table>
				</form>

				<div class="tbl_bottom">
					<div class="top_left">
						선택하신 게시물을
						<select name='status'>
							<option value='0'>접수</option>
							<option value='1'>접수완료</option>
							<option value="3">심사중</option>
							<option value="4">서류전형</option>
							<option value="5">서류전형 합격</option>
							<option value="6">서류전형 불합격</option>
							<option value="7">최종 합격</option>
							<option value="8">최종 불합격</option>
						</select>
						으로
						<a class="btn_green btnGroupCh">변경</a>
					</div>
					<div class="top_right">
						<input type='button' value='선택게시물삭제' class='btn_gray bc_red' style='cursor:pointer; width:100px' onclick='remove()'>
					</div>
				</div>

				<%=PT_PageLink(PageLink,PageStr,"")%>

				<form name="actFrm" id="actFrm" class="" method="get">
					<input type='hidden' name="idx" value="">
					<input type='hidden' name="procMode" value="">
					<input type='hidden' name="selVal" value="">
					<input type='hidden' name='page' value='<%=page%>'>
					<input type='hidden' name='pagesize' value='<%=pagesize%>'>
					<input type='hidden' name='serEmpidx' value='<%=serEmpidx%>'>
					<input type='hidden' name='seritem' value='<%=seritem%>'>
					<input type='hidden' name='serStatus' value='<%=serStatus%>'>
					<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				</form>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->