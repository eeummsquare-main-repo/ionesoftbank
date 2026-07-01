<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "code" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim serCode
serCode = uf_getRequest(Request("serCode"),"char","","")

IF serCode<>"" Then
	Sql = "SELECT groupCode, groupName FROM COMCODE WHERE isAd=99 AND groupCode='"&serCode&"'"
	Set Rs = DBcon.Execute(Sql)
	IF Rs.Bof Or Rs.Eof Then serCode = ""
End IF

Sql = "SELECT groupCode, groupName FROM COMCODE WHERE isAd=99 ORDER BY groupName ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	groupRec = Rs.GetRows()
	IF serCode="" Then serCode = groupRec(0,0)
End IF

IF serCode="" Then
	Response.Write ExecJavaAlert("등록된 코드가 없습니다.", 0)
	Response.END
End IF

Sql="SELECT idx, groupCode, groupName, code, name, listnum, isUse FROM COMCODE WHERE isAD=1 AND groupCode='"&serCode&"' ORDER BY groupCode ASC, listnum ASC"
Set Rs = Dbcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_GroupSelBox()
	IF isArray(groupRec) Then
		For i=0 To Ubound(groupRec,2)
			Response.Write "<option value="""&groupRec(0,i)&""" "&selCheck(serCode, groupRec(0,i))&">"&groupRec(1,i)&"</option>"&Vbcrlf
		Next
	End IF
End Function

Function PT_BBsList()
	Dim i
	IF IsArray(Allrec) Then
		Dim idx, groupCode, groupName, code, name, listnum, isUse

		For i=0 To Ubound(Allrec,2)
			idx = Allrec(0,i)
			groupCode = Allrec(1,i)
			groupName = Allrec(2,i)
			code = Allrec(3,i)
			name = Allrec(4,i)
			listnum = Allrec(5,i)
			isUse = Allrec(6,i)

			Response.Write "<tr align='center' id=""tr_"&i&""">"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&idx&"'><input type='hidden' name='dbidx' value='"&idx&"'></td>"&Vbcrlf
			Response.Write "<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a></td>"&Vbcrlf
			Response.Write "<td>"&i+1&"</td>"&Vbcrlf
			Response.Write "<td>"&ReplaceNoHtml(name)&"</td>"&Vbcrlf
			Response.Write "<td>"&ReplaceNoHtml(code)&"</td>"&Vbcrlf
			Response.Write "<td>"&isDisplayYN(isUse)&"</td>"&Vbcrlf
			Response.Write "<td>"&Vbcrlf
			Response.Write "	<a href=""codeWrite.asp?idx="&idx&"&serCode="&serCode&""" class=""btn_default btn_gray"">수정</a>"&Vbcrlf
			Response.Write "	<a href=""javascript:boardDel("&idx&");"" class=""btn_default btn_red"">삭제</a>"&Vbcrlf
			Response.Write "</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr><td colspan='7' align='center' height='100'>등록된 게시물이 없습니다.</td></tr>"&Vbcrlf
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
function boardDel(idx){
	var value=confirm("삭제하시겠습니까?");
	if(value){
		document.boardform.mode.value = "remove";
		document.boardform.idx.value = idx;
		document.boardform.action="codeProc.asp"
		document.boardform.submit();
	}
}
function groupRemove(){
	var count = $(':checkbox[name="chkidx"]:checked').length;
	var chkedIdx = [];

	if(count==0){
		alert("삭제하실 코드를 선택하세요.");
		return;
	}
	var val = confirm("선택하신 모든 코드를 삭제하시겠습니까?");

	if (val){
		$("input[name='chkidx']:checked").each(function(i) {
			chkedIdx.push($(this).val());
		});
		document.boardform.mode.value = "remove";
		document.boardform.idx.value = chkedIdx;
		document.boardform.action = "codeProc.asp";
		document.boardform.submit();
	}
}
function setOrderBy(){
	var val = confirm("순서를 저장합니다.\n저장하시겠습니까?");
	if (val){
		document.boardform.mode.value = "numchange";
		document.boardform.action = "codeProc.asp";
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

				<div style='clear:both;'>
					<select name='serCode' style='width:100%; background-Color: #B0CEFF; font-size:14px;' onchange="location.href='?serCode='+this.value;">
						<%=PT_GroupSelBox()%>
					</select>
				</div>

				<form name="boardform" id="boardform" method="post">
				<input type='hidden' name='idx' value=''>
				<input type='hidden' name='mode' value=''>
				<input type='hidden' name='serCode' value="<%=serCode%>">
				<table class="tbl_col mt40" id="listArea">
					<colgroup>
						<col style="width: 4%" />
						<col style="width: 8%" />
						<col style="width: 6%" />
						<col style="width: " />
						<col style="width: " />
						<col style="width: 8%" />
						<col style="width: 13%" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
						<th scope="row">노출순서</th>
						<th scope="row">No</th>
						<th scope="row">코드명</th>
						<th scope="row">코드</th>
						<th scope="row">사용여부</th>
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
						<div class="info">선택 드래그 하여 순서 변경이 가능합니다.</div>
					</div>

					<div class="top_right">
						<a href="javascript:setOrderBy()" class="btn_gray btn_gray100 btn_green">노출순서저장</a>
						<a href="javascript:groupRemove()" class="btn_gray btn_gray100 btn_red">선택삭제</a>
						<a href="codeWrite.asp?serCode=<%=serCode%>" class="btn_gray btn_gray100">등록</a>
					</div>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->