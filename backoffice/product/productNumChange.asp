<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "pnum" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim langTitle, langmode
langmode = uf_getRequest(Request("langmode"),"int","4","0")
'Call getLangModeTitle(langmode)

sercatecode1 = uf_getRequest(Request("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(Request("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(Request("sercatecode3"),"char","","")

IF serCatecode3<>"" Then
	serCatecode = sercatecode3
	strWhere = " AND catecode='"&serCatecode3&"'"
	OBColuml = "listnum"
ElseIF serCatecode2<>"" Then
	serCatecode = sercatecode2
	strWhere = " AND MiddleCode='"&serCatecode2&"'"
	OBColuml = "listnum2St"
ElseIF serCatecode1<>"" Then
	serCatecode = sercatecode1
	strWhere = " AND Topcode='"&serCatecode1&"'"
	OBColuml = "listnum1St"
End IF

IF serCatecode<>"" Then
	Sql="SELECT idx, display, itemname, regdate, catecode, price, listimg, dbo.fn_CateFullName(catecode) AS catenames FROM View_Product WHERE pcidx IN ( SELECT MIN(pcidx) FROM VIEW_Product WHERE langmode="&langmode&" "&strWhere&" GROUP BY idx) Order By "&OBColuml&" ASC, idx DESC"
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
End IF

'###### 1차 카테고리 ##########################
Sql="Select lowcode,name FROM Category Where Lowcode=Topcode Order by align1Num ASC"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then gbCateRec=Rs.GetRows()
Rs.Close

Function PT_CateGory1(Rec)
	IF IsArray(Rec) Then
		For i=0 To UBound(Rec,2)
			Response.Write "<option value='"&Rec(0,i)&"' "&selCheck(Rec(0,i),sercatecode1)&">"&Rec(1,i)&"</option>"
		Next
	End IF
End Function
'###### 1차 카테고리 ##########################

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_ItemList
	IF IsArray(Allrec) Then
		Num = 1
		For i=0 To Ubound(Allrec,2)
			loop_idx=Allrec(0,i)
			loop_display=Allrec(1,i)
			loop_itemname=Allrec(2,i)
			loop_regdate=Allrec(3,i)
			loop_catecode1=Allrec(4,i)
			loop_price=Allrec(5,i)
			loop_listimg=Allrec(6,i)
			loop_Catenames=Allrec(7,i)

			IF loop_listimg="" Then
				ImgTag="NO IMAGE"
			Else
				ImgTag="<img src='/upload/product/"&loop_listimg&"' valign='middle'>"
			End IF

			Response.Write "<tr align='center' id=""tr_"&i&""">"&Vbcrlf
			Response.Write "<td class=""orderBtnTD""><a class=""orderDown""><img src=""/backoffice/images/icon/bt_down.gif""></a> <a class=""orderUp""><img src=""/backoffice/images/icon/bt_up.gif""></a><input type='hidden' name='dbidx' value='"&loop_idx&"'></td>"&Vbcrlf
			Response.Write "<td>"&Num&"</td>"&Vbcrlf
			'Response.Write "<td>"&ReplaceNoHtml(loop_modelname)&"</td>"&Vbcrlf
			Response.Write "<td align='left' style='line-height:1.3;' class=""left"">"&ReplaceNoHtml(loop_itemname)&"</td>"&Vbcrlf
			Response.Write "<td>"&isDisplayYN(loop_display)&"</td>"&Vbcrlf
			Response.Write "<td>"&loop_regdate&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num+1
		Next
	Else
		Response.Write "<tr><td colspan='5' align='center' height='150'>검색된 제품이 없습니다.</td></tr>"&Vbcrlf
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
	$(".listArea").tableDnD({ 
		onDragClass : 'dragTR', 
		onDrop: function(table, row) { 
			setOrderBtnSet();
		},onDragStart: function(table, row) {
			
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
	changSelBox1("<%=serCatecode1%>","<%=serCatecode2%>")
});

function setOrderBtnSet(){
	$(".listArea").each(function() {
		var cnt = $(this).find("tbody tr").length - 1;
		$(this).find("tbody tr").each(function(i) {
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
	});
}

function search(){
	searchform.submit();
}
function changSelBox1(val1,val2){
	$.ajax({
		type:"post",
		url: "/_lib/selBoxChange1.asp",
		data:{"catecode":val1,"lccode":val2},
		dataType:"script",
		async: true
	})
}
function changSelBox2(val1,val2){
	/*$.ajax({
		type:"post",
		url: "/_lib/selBoxChange2.asp",
		data:{"catecode":val1,"lccode":val2},
		dataType:"script",
		async: true
	})*/
}

function setOrderBy(){
	var val = confirm("노출순서를 저장합니다.\n저장하시겠습니까?");
	if (val){
		document.boardform.action = "productNumChangeOk.asp";
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

				<!-- <div style='clear:both; padding-bottom:5px;'>
					<select name='langmode' class="select" style='width:100%; background-color:#000; color:#fff; font-size:14px; padding:5px; height:auto;' onchange="location.href='?langmode='+this.value;">
						<option value='1' <%=SelCheck(1,langmode)%>>국문 제품관리</option>
						<option value='2' <%=SelCheck(2,langmode)%>>영문 제품관리</option>
						<option value='3' <%=SelCheck(3,langmode)%>>중문 제품관리</option>
					</select>
				</div> -->

				<form name="searchform" method="get" action = "" style='margin:0px;'>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<div class="" style='clear:both; text-align:right'>
					<select name='sercatecode1' id='selBox1' onchange="changSelBox1(this.value,'')">
						<option value=''>:::카테고리 선택:::</option>
						<%=PT_CateGory1(gbCateRec)%>
					</select>
					<select name='sercatecode2' id='selBox2' onchange="changSelBox2(this.value,'')" class="">
						<option value=''>:::2차 카테고리 선택:::</option>
					</select>
					<a href="javascript:search()" class="btn_gray btn_gray100">검색</a>
				</div>
				</form>

				<% IF serCatecode="" Then %>
				<div style='text-align:center; font-size:16px; margin-top:100px; color: #9b0000'>먼저 순서관리할 카테고리를 선택하여 주세요.</div>
				<% Else %>
				<form name="boardform" id="boardform" method="post">
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='sercatecode1' value='<%=sercatecode1%>'>
				<input type='hidden' name='sercatecode2' value='<%=sercatecode2%>'>
				<input type='hidden' name='sercatecode3' value='<%=sercatecode3%>'>
				<table class="tbl_col listArea mt20" id="">
					<colgroup>
						<col style="width: 6%" />
						<col style="width: 6%" />
						<!-- <col style="width: 10%" /> -->
						<col style="width: " />
						<col style="width: 9%" />
						<col style="width: 9%" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row">노출순서</th>
						<th scope="row">No</th>
						<!-- <th scope="row">모델명</th> -->
						<th scope="row">제품명</th>
						<th scope="row">진열여부</th>
						<th scope="row">등록일</th>
					</tr>
					</thead>
					<tbody>
						<%=PT_ItemList%>
					</tbody>
				</table>
				</form>

				<div class="tbl_bottom">
					<div class="top_right">
						<a href="javascript:setOrderBy()" class="btn_gray btn_gray100 bc_green">노출순서저장</a>
					</div>
				</div>
				<% End IF %>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->