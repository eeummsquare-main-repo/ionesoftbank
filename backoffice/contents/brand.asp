<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "brand" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
langmode = 1

Dim SpItemCnt

bansort=Request("bansort")
If bansort="" Then bansort=1

Sql="SELECT idx, title, filenames, isDisplay, viewdate from brandAdmin Where langmode="&langmode&" AND bansort="&bansort&" order by listnum ASC, idx ASC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BBsList()
	Dim i
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			imgTag=""
			IF Allrec(2,i)<>"" Then imgTag = "<a href=""javascript:openWindow(100,100,'/_lib/imgview.asp?path=brand&imgname="&Allrec(2,i)&"','imgView','yes')""><img src=""/upload/brand/"&(Allrec(2,i))&""" style='max-width:180px; max-height:40px;'></a>"
			IF imgTag="" Then imgTag = "이미지없음"

			Response.Write "<tr align='center' "&TrBg&" id=""tr_"&i&""">"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&Allrec(0,i)&"'><input type='hidden' name='dbidx' value='"&Allrec(0,i)&"'></td>"&Vbcrlf
			Response.Write "<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a></td>"&Vbcrlf
			Response.Write "<td>"&i+1&"</td>"&Vbcrlf
			Response.Write "<td>"&imgTag&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(1,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(4,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&isDisplayYN(Allrec(3,i))&"</td>"&Vbcrlf
			Response.Write "<td><a href=""javascript:boardView("&Allrec(0,i)&");"" class=""btn_default bc_gray"">수정</a><a href=""javascript:boardDel("&Allrec(0,i)&");"" class=""btn_default bc_red"">삭제</a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr><td colspan='8' align='center' height='100'>등록된 게시물이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript" src="/backoffice/js/jquery.tablednd.js"></script>
<style>
.dragTR td{background-color:#d4d4d4}
</style>
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	$("#listArea").tableDnD({ 
		onDragClass : 'dragTR', 
		onDrop: function(table, row) { 
			setOrderBtnSet();
		},onDragStart: function(table, row) {
			
		} 
	});

	$(document).on("change","#ch_cIdall",function(){
		if ($(this).is(":checked")){
			$(this).parents("form").find("input[name='chkidx']").prop('checked', true);
		}else{
			$(this).parents("form").find("input[name='chkidx']").prop('checked', false);
		}
	});

	$(document).on("click",".orderDown",function(){
		var $tr = $(this).parent().parent();
		$tr.next().after($tr);
		setOrderBtnSet();
	});
	$(document).on("click",".orderUp",function(){
		var $tr = $(this).parent().parent();
		$tr.prev().before($tr);
		setOrderBtnSet();
	});
	setOrderBtnSet();
});

function setOrderBtnSet(){
	var cnt = $("#listArea tbody tr").length - 1;
	$("#listArea tbody tr").each(function(i) {
		if (i==0){
			$(this).find(".orderUp").hide();
			$(this).find(".orderDown").show();
		}else if (i==cnt){
			$(this).find(".orderUp").show();
			$(this).find(".orderDown").hide();
		}else{
			$(this).find(".orderUp").show();
			$(this).find(".orderDown").show();
		}
	});
}

function boardView(idx){
	$.ajax({
		type:"post",
		url: "brandEdit.asp?Idx="+idx,
		data:"",
		dataType:"html",
		async: true
	}).done(function(data){
		fnLayerPopupOpen(data);
		setDatepicker()
	})
}
function boardWrite(){
	var params = $("#boardform").serialize();

	$.ajax({
		type:"post",
		url: "brandWrite.asp",
		data:params,
		dataType:"html",
		async: true
	}).done(function(data){
		fnLayerPopupOpen(data);
		setDatepicker()
	})
}
function boardDel(idx){
	var value=confirm("삭제하시겠습니까?");
	if(value){
		document.boardform.idx.value = idx;
		document.boardform.action="brandDel.asp"
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
		document.boardform.action = "brandDel.asp";
		document.boardform.submit();
	}
}
function setOrderBy(){
	var val = confirm("노출순서를 저장합니다.\n저장하시겠습니까?");
	if (val){
		document.boardform.action = "brandNumChangeOk.asp";
		document.boardform.submit();
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

				<!-- <div style='clear:both;'>
					<div class="mainMenuList">
						<a href="javascript:;" onClick="location.href='?langmode=<%=langmode%>&bansort=1';" <% If bansort = "1" Then %>class="check"<% End If %>>브랜드 리스트</a>
					</div>
				</div> -->

				<form name="boardform" id="boardform" method="post">
				<input type='hidden' name='idx' value=''>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='bansort' value='<%=bansort%>'>
				<table class="tbl_col mt20" id="listArea">
					<colgroup>
						<col style="width: 4%" />
						<col style="width: 8%" />
						<col style="width: 6%" />
						<col style="width: 200px" />
						<col style="width: " />
						<col style="width: 8%" />
						<col style="width: 6%" />
						<col style="width: 13%" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
						<th scope="row">노출순서</th>
						<th scope="row">No</th>
						<th scope="row">이미지</th>
						<th scope="row">브랜드명</th>
						<th scope="row">등록일</th>
						<th scope="row">노출여부</th>
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
						<a href="javascript:setOrderBy()" class="btn_gray btn_gray100 bc_green">노출순서저장</a>
						<a href="javascript:groupRemove()" class="btn_gray btn_gray100 bc_red">선택삭제</a>
					</div>

					<div class="top_right">
						<a href="javascript:boardWrite();" class="btn_gray btn_gray100">등록</a>
					</div>
				</div>
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->