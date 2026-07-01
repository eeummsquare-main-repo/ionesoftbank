<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "banner" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim langTitle, langmode
langmode = uf_getRequest(Request("langmode"),"int","1","0")
Call getLangModeTitle(langmode)

Dim SpItemCnt

bansort=Request("bansort")
If bansort="" Then bansort=0

Sql="select idx, title, filenames, isDisplay, sDate, eDate, regdate, listnum, vodlinkurl FROM mainbannerAdmin Where langmode="&langmode&" AND bansort="&bansort&" order by listnum ASC, idx ASC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

NowDate = uf_ConvertDateFormat(Now(), 96)

Function PT_BBsList()
	Dim i
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			sDate = Allrec(4,i)
			eDate = Allrec(5,i)

			imgTag=""
			IF Allrec(2,i)<>"" Then
				FileExt=mid(Allrec(2,i),instrrev(Allrec(2,i),"."))

				IF LCase(FileExt)=".mp4" Then
					imgTag = "동영상"
				Else
					imgTag = "<a href=""javascript:openWindow(100,100,'/_lib/imgview.asp?path=mainbanner&imgname="&Allrec(2,i)&"','imgView','yes')""><img src=""/upload/mainbanner/"&getImageThumbFilename(Allrec(2,i))&""" style='max-width:180px; max-height:80px;'></a>"
				End IF
			End IF

			IF imgTag="" AND Allrec(8,i)<>"" Then imgTag = "동영상"
			IF imgTag="" Then imgTag = "이미지없음"

			Response.Write "<tr align='center' "&TrBg&" id=""tr_"&i&""">"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&Allrec(0,i)&"'><input type='hidden' name='dbidx' value='"&Allrec(0,i)&"'></td>"&Vbcrlf
			Response.Write "<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a></td>"&Vbcrlf
			Response.Write "<td>"&i+1&"</td>"&Vbcrlf
			Response.Write "<td>"&imgTag&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(1,i)&"</td>"&Vbcrlf
			IF sDate="" Then
				Response.Write "<td style='color: #2466ff'>상시노출</td>"&Vbcrlf
			Else
				Response.Write "<td>"&uf_ConvertDateFormat1(sDate)&" ~ "&uf_ConvertDateFormat1(eDate)&"</td>"&Vbcrlf
			End IF
			Response.Write "<td>"&Left(Allrec(6,i),10)&"</td>"&Vbcrlf

			IF Allrec(3,i)="0" Then
				Response.Write "<td style='color: #aaaaaa'>N</td>"&Vbcrlf
			ElseIF sDate="" Then
				Response.Write "<td style='color: #000; font-weight:bold;'>Y</td>"&Vbcrlf
			ElseIF CStr(sDate)<=NowDate AND CStr(eDate)>=NowDate Then
				Response.Write "<td style='color: #000; font-weight:bold;'>Y</td>"&Vbcrlf
			Else
				Response.Write "<td style='color: #aaaaaa'>N</td>"&Vbcrlf
			End IF
			Response.Write "<td><a href=""javascript:boardView("&Allrec(0,i)&");"" class=""btn_default btn_gray"">수정</a><a href=""javascript:boardDel("&Allrec(0,i)&");"" class=""btn_default btn_red"">삭제</a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr><td colspan='9' align='center' height='100'>등록된 게시물이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->

<script src="/_lib/js/plug-in/colorPicker/spectrum.min.js"></script>
<link rel="stylesheet" type="text/css" href="/_lib/js/plug-in/colorPicker/spectrum.min.css">
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
		url: "mainbannerEdit.asp?Idx="+idx,
		data:"",
		dataType:"html",
		async: true
	}).done(function(data){
		fnLayerPopupOpen(data);
		setDatepickerAD()

		$('.color-picker').spectrum({
			type: "component"
		});
	})
}
function boardWrite(){
	var params = $("#boardform").serialize();

	$.ajax({
		type:"post",
		url: "mainbannerWrite.asp",
		data:params,
		dataType:"html",
		async: true
	}).done(function(data){
		fnLayerPopupOpen(data);
		setDatepickerAD()

		$('.color-picker').spectrum({
			type: "component"
		});

	})
}
function boardDel(idx){
	var value=confirm("삭제하시겠습니까?");
	if(value){
		document.boardform.idx.value = idx;
		document.boardform.action="mainbannerDel.asp"
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
		document.boardform.action = "mainbannerDel.asp";
		document.boardform.submit();
	}
}
function setOrderBy(){
	var val = confirm("노출순서를 저장합니다.\n저장하시겠습니까?");
	if (val){
		document.boardform.action = "mainbannerNumChangeOk.asp";
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

				<!-- <div class="subTab mt20 mb20">
					<a href="?langmode=0" class="<%=iif_compare(langmode, 0, "active")%>"><span>KR</span></a>
					<a href="?langmode=1" class="<%=iif_compare(langmode, 1, "active")%>"><span>EN</span></a>
				</div> -->

				<div style='clear:both;'>
					<select name='bansort' style='width:100%; background-Color: #B0CEFF; font-size:14px;' onchange="location.href='?langmode=<%=langmode%>&bansort='+this.value;">
						<option value='0' <%=SelCheck(0,bansort)%>>메인 리본배너 - 상위 10EA 노출</option>
						<option value='1' <%=SelCheck(1,bansort)%>>메인 동영상 배너 관리 - 상위 1EA 노출</option>
					</select>
				</div>

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
						<col style="width: 20%" />
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
						<th scope="row">배너명</th>
						<th scope="row">게시기간</th>
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
						<div class="info">배너를 선택 드래그 하여 순서 변경이 가능합니다.</div>
					</div>

					<div class="top_right">
						<a href="javascript:setOrderBy()" class="btn_gray btn_gray100 btn_green">노출순서저장</a>
						<a href="javascript:groupRemove()" class="btn_gray btn_gray100 btn_red">선택삭제</a>
						<a href="javascript:boardWrite();" class="btn_gray btn_gray100">등록</a>
					</div>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->