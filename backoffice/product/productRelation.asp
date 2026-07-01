<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim langTitle, langmode

itemidx = uf_getRequest(Request("itemidx"),"int","","")

Sql = "SELECT idx, display, itemname, note1, regdate, catecode, price, listimg, dbo.fn_CateFullName(catecode) AS catenames, langmode FROM View_Product WHERE isMain=1 AND idx="&itemidx
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	proIfno=Rs.GetRows
Else
	Response.Write ExecJavaAlert("",0)
	Response.END
End IF

langmode = proIfno(9,i)
Call getLangModeTitle(langmode)

Sql="SELECT P.idx, display, itemname, note1, regdate, catecode, price, listimg, dbo.fn_CateFullName(catecode) AS catenames, rDate FROM View_product P INNER JOIN ProductRelation A ON P.idx = A.relationidx Where langmode="&langmode&" AND isMain=1 AND itemidx="&itemidx&" order by A.listnum ASC, A.idx ASC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
Rs.Close

DBcon.CLose
Set DBcon = Nothing

Function PT_ItemList
	For i=0 To Ubound(proIfno,2)
		loop_idx=proIfno(0,i)
		loop_display=proIfno(1,i)
		loop_itemname=proIfno(2,i)
		loop_note1=proIfno(3,i)
		loop_regdate=proIfno(4,i)
		loop_catecode1=proIfno(5,i)
		loop_price=proIfno(6,i)
		loop_listimg=proIfno(7,i)
		loop_Catenames=proIfno(8,i)

		IF loop_listimg="" Then
			ImgTag="NO IMAGE"
		Else
			ImgTag="<img src='/upload/product/"&loop_listimg&"' '"&ImgperSize("product",70,70,loop_listimg)&" valign='middle'>"
		End IF

		Response.Write "<tr align='center'>"&Vbcrlf
		Response.Write "<td>"&ImgTag&"</td>"&Vbcrlf
		Response.Write "<td>"&loop_Catenames&"</td>"&Vbcrlf
		Response.Write "<td align='left' style='line-height:1.3;' class=""left"">"&ReplaceNoHtml(loop_itemname)&"</td>"&Vbcrlf
		Response.Write "<td>"&loop_regdate&"</td>"&Vbcrlf
		Response.Write "<td>"&isDisplayYN(loop_display)&"</td>"&Vbcrlf
		Response.Write "</tr>"&Vbcrlf
		Num=Num-1
	Next
End Function

Function PT_BBsList()
	Dim i
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			loop_idx=Allrec(0,i)
			loop_display=Allrec(1,i)
			loop_itemname=Allrec(2,i)
			loop_note1=Allrec(3,i)
			loop_regdate=Allrec(4,i)
			loop_catecode1=Allrec(5,i)
			loop_price=Allrec(6,i)
			loop_listimg=Allrec(7,i)
			loop_Catenames=Allrec(8,i)
			loop_rDate=Allrec(9,i)

			Response.Write "<tr align='center'>"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&loop_idx&"'><input type='hidden' name='dbidx' value='"&loop_idx&"'></td>"&Vbcrlf
			Response.Write "<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a></td>"&Vbcrlf
			Response.Write "<td>"&i+1&"</td>"&Vbcrlf
			Response.Write "<td>"&loop_Catenames&"</td>"&Vbcrlf
			Response.Write "<td align='left' style='line-height:1.3;' class=""left"">"&ReplaceNoHtml(loop_itemname)&"</td>"&Vbcrlf
			Response.Write "<td>"&Left(loop_rDate,10)&"</td>"&Vbcrlf
			Response.Write "<td>"&isDisplayYN(loop_display)&"</td>"&Vbcrlf

			Response.Write "<td><a href=""javascript:relationDel("&Allrec(0,i)&");"" class=""btn_default bc_red"">삭제</a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	Else
		Response.Write "<tr><td colspan='8' align='center' height='100'>등록된 게시물이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
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

function layProductSearch(par, page){
	$("#actFrmPage").val(page);

	var params = $("#actFrm").serialize();
	$.ajax({
		type:"post",
		url: "layer_pSearch.asp",
		data:params,
		dataType:"html",
		async: true
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}
function relationDel(idx){
	var value=confirm("관련상품을 삭제하시겠습니까?");
	if(value){
		document.boardform.idx.value = idx;

		var params = $("#boardform").serialize();
		$.ajax({
			type:"post",
			url: "productRelationDel.asp",
			data:params,
			dataType:"html",
			async: true
		}).done(function(data){
			if (data=="OK")	{
				alert("관련상품이 삭제되었습니다.");
				location.reload();
			}else{
				alert(data)
			}
		})
	}
}
function groupRemove(){
	var count = $(':checkbox[name="chkidx"]:checked').length;
	var chkedIdx = [];

	if(count==0){
		alert("삭제하실 관련상품을 선택하세요.");
		return;
	}
	var val = confirm("선택하신 모든 관련상품을 삭제하시겠습니까?");

	if (val){
		$("input[name='chkidx']:checked").each(function(i) {
			chkedIdx.push($(this).val());
		});
		document.boardform.idx.value = chkedIdx;

		var params = $("#boardform").serialize();
		$.ajax({
			type:"post",
			url: "productRelationDel.asp",
			data:params,
			dataType:"html",
			async: true
		}).done(function(data){
			if (data=="OK")	{
				alert("선택하신 관련상품이 삭제되었습니다.");
				location.reload();
			}else{
				alert(data)
			}
		})
	}
}
function setOrderBy(){
	var val = confirm("노출순서를 저장합니다.\n저장하시겠습니까?");
	if (val){
		var params = $("#boardform").serialize();
		$.ajax({
			type:"post",
			url: "productRelationNumChangeOk.asp",
			data:params,
			dataType:"html",
			async: true
		}).done(function(data){
			if (data=="OK")	{
				alert("노출순서가 저장되었습니다.");
				location.reload();
			}else{
				alert(data)
			}
		})
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
					<h2 class="top_left">관련상품관리 (<%=langTitle%>)</h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span>관련상품관리</span>
				</div>

				<table class="tbl_col">
					<colgroup>
						<col style="width: 7%" />
						<col style="width: 12%" />
						<col style="*" />
						<col style="width: 8%" />
						<col style="width: 6%" />
					</colgroup>
					<tr bgcolor="#F5F5F5">
						<th scope="row">상품사진</th>
						<th scope="row">카테고리</th>
						<th scope="row">제품명</th>
						<th scope="row">등록일</th>
						<th scope="row">진열여부</th>
					</tr>
					<%=PT_ItemList%>
				</table>

				<div class="top_left apsubTitle mt30">관련상품목록</div>

				<form name="boardform" id="boardform" method="post">
				<input type='hidden' name='itemidx' value='<%=itemidx%>'>
				<input type='hidden' name='idx' value=''>
				<table class="tbl_col mt30" id="listArea">
					<colgroup>
						<col style="width: 4%" />
						<col style="width: 6%" />
						<col style="width: 6%" />
						<col style="width: 14%" />
						<col style="width: " />
						<col style="width: 8%" />
						<col style="width: 6%" />
						<col style="width: 8%" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
						<th scope="row">노출순서</th>
						<th scope="row">No</th>
						<th scope="row">카테고리명</th>
						<th scope="row">제품명</th>
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

				<form name="actFrm" id="actFrm" method="post" style='margin:0'>
				<input type='hidden' name='itemidx' value='<%=itemidx%>'>
				<input type='hidden' name='selidx' value=''>
				<input type='hidden' name='page' id="actFrmPage" value='<%=page%>'>
				<input type='hidden' name='seritemstat' value='<%=seritemstat%>'>
				<input type='hidden' name='serSellYn' value='<%=serSellYn%>'>
				<input type='hidden' name='searchStr' value='<%=SearchStr%>'>
				<input type='hidden' name='sercatecode1' value='<%=sercatecode1%>'>
				<input type='hidden' name='sercatecode2' value='<%=sercatecode2%>'>
				<input type='hidden' name='sercatecode3' value='<%=sercatecode3%>'>
				</form>

				<div class="tbl_bottom">
					<div class="top_left">
						<a href="javascript:setOrderBy()" class="btn_gray btn_gray100 bc_green">노출순서저장</a>
						<a href="javascript:groupRemove()" class="btn_gray btn_gray100 bc_red">선택삭제</a>
					</div>
				</div>

				<div class="btn_center pt30">
					<a href="javascript:actFrm.reset(); layProductSearch('')" class="btn_largeG">제품검색</a>
					<a href="javascript:history.back();" class="btn_largeW">목록</a>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->
