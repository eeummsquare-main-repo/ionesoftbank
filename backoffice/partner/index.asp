<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
regDiv = uf_getRequest(Request("regDiv"),"int","3","0")
topMenuCode = "admin" : subMenuCode = "partner"
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Sql = "SELECT idx, title, isDisplay, listnum, regdate, regDiv FROM partner WHERE regDiv="&regDiv&" ORDER BY listNum ASC, Idx ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_ItemList
	Dim i,Num
	Num=1

	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			LOOP_idx = ChangeBlank(Allrec(0,i))
			LOOP_title = ChangeBlank(Allrec(1,i))
			LOOP_isDisplay = ChangeBlank(Allrec(2,i))
			LOOP_listnum = ChangeBlank(Allrec(3,i))
			LOOP_regdate = ChangeBlank(Allrec(4,i))
			LOOP_regDiv = ChangeBlank(Allrec(5,i))

			viewLinkUrl = "write.asp?idx="&LOOP_IDX&"&regDiv="&LOOP_regDiv
			Response.Write "<tr align='center' id=""tr_"&i&""">"&Vbcrlf
			Response.Write "<td><p class=""checkIn noTxt""><input type=""checkbox"" id=""chkidx_"&LOOP_IDX&""" name=""chkidx"" value="""&LOOP_IDX&"""><label for=""chkidx_"&LOOP_IDX&""">선택</label></p><input type='hidden' name='dbidx' value='"&LOOP_IDX&"'></td>"&Vbcrlf
			Response.Write "<td>"&Num&"</td>"&Vbcrlf
			Response.Write "<td><a href="""&viewLinkUrl&""">"&ReplaceNoHtml(LOOP_title)&"</a></td>"&Vbcrlf
			Response.Write "<td><a href="""&viewLinkUrl&""">"&ChageisDisplay(LOOP_isDisplay)&"</a></td>"&Vbcrlf
			Response.Write "<td><a href="""&viewLinkUrl&""">"&Left(LOOP_REGDATE,10)&"</a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num = Num+1
		Next
	Else
		Response.Write "<tr><td colspan='5' align='center' height='150'>검색된 내역이 없습니다.</td></tr>"&Vbcrlf
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
		},onDragStart: function(table, row) {

		}
	});

	$('#ch_cIdall').change(function() {
		if ($("#ch_cIdall").is(":checked")){
			$("input[name='chkidx']").prop('checked', true);
		}else{
			$("input[name='chkidx']").prop('checked', false);
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
					<a href="?regDiv=0" class="<%=iif_compare(regDiv, 0, "active")%>"><span>CVS</span></a>
					<a href="?regDiv=1" class="<%=iif_compare(regDiv, 1, "active")%>"><span>Hyper/Sumermarket</span></a>
					<a href="?regDiv=2" class="<%=iif_compare(regDiv, 2, "active")%>"><span>Online</span></a>
					<a href="?regDiv=3" class="<%=iif_compare(regDiv, 3, "active")%>"><span>Others</span></a>
				</div> -->

				<div class="tbl_top">
					<div class="top_right">
						<input type='button' value='선택게시물삭제' class='btn_gray bc_red' style='cursor:pointer; width:100px' onclick='remove()'>
						<a href="write.asp" class="btn_gray btn_gray100">등록하기</a>
					</div>
				</div>

				<form name="itemFrm" id="itemFrm" method="post" style='margin:0'>
				<input type='hidden' name="procMode" value="">
				<input type='hidden' name='seritem' value='<%=seritem%>'>
				<input type='hidden' name='regDiv' value='<%=regDiv%>'>
				<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<table class="tbl_col" id="listArea">
					<colgroup>
						<col style="width: 40px" />
						<col style="width: 80px" />
						<!-- <col style="width: 120px" /> -->
						<col style="*" />
						<col style="width: 100px" />
						<col style="width: 120px" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row">
							<p class="checkIn noTxt"><input type="checkbox" id="ch_cIdall" name="ch_cIdall" value="1"><label for="ch_cIdall">선택</label></p>
						</th>
						<th scope="row">순번</th>
						<!-- <th scope="row">분류</th> -->
						<th scope="row">제목</th>
						<th scope="row">노출여부</th>
						<th scope="row">등록일</th>
					</tr>
					</thead>
					<tbody>
					<%=PT_ItemList%>
					</tbody>
				</table>
				</form>

				<div class="tbl_bottom">
					<div class="top_left">
						<div class="imp">선택 드래그 하여 순서 변경이 가능합니다.</div>
					</div>
					<div class="top_right">
						<input type='button' value='노출순서저장' class='btn_gray bc_green' style='cursor:pointer; width:100px' onclick='setOrderBy()'>
						<input type='button' value='선택게시물삭제' class='btn_gray bc_red' style='cursor:pointer; width:100px' onclick='remove()'>
						<a href="write.asp?regDiv=<%=regDiv%>" class="btn_gray btn_gray100">등록하기</a>
					</div>
				</div>

				<form name="actFrm" id="actFrm" class="" method="get">
					<input type='hidden' name="idx" value="">
					<input type='hidden' name="procMode" value="">
					<input type='hidden' name="regDiv" value="<%=regDiv%>">
				</form>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->