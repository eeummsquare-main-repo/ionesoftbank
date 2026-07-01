<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim langTitle, langmode
langmode = uf_getRequest(Request("langmode"),"int","4","0")
'Call getlangmodeTitle(langmode)

'=====form 전송을 위한 변수 셋팅============================
Page = uf_getRequest(Request("Page"),"int","","1")
serSelCate = uf_getRequest(Request("serSelCate"),"int","1","")
sercatecode = uf_getRequest(Request("sercatecode"),"char","50","")
searchOB = uf_getRequest(Request("searchOB"),"int","3","")
seritemstat = uf_getRequest(Request("seritemstat"),"int","1","")
serSellYn = uf_getRequest(Request("serSellYn"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
sercatecode1 = uf_getRequest(Request("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(Request("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(Request("sercatecode3"),"char","","")

PageStr="langmode="&langmode&"&serSelCate="&serSelCate&"&sercatecode1="&sercatecode1&"&sercatecode2="&sercatecode2&"&sercatecode3="&sercatecode3&"&sercatecode="&sercatecode&"&searchOB="&searchOB&"&serSellYn="&serSellYn&"&seritemstat="&seritemstat&"&searchStr="&searchStr
'=====form 전송을 위한 변수 셋팅============================

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="Select name, lowcode, middlecode, topcode, idx FROM Category ORDER BY align1Num, align2Num, align3Num"
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
Rs.Close

'======================스펙바구니 리스트=============================
Sql="SELECT idx,title From specCart Order by idx DESC"
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then specCartRec=Rs.GetRows
Rs.Close

Function PT_specCart()
	IF IsArray(specCartRec) Then
		For i=0 To UBound(specCartRec,2)
			Response.Write "<option value='"&specCartRec(0,i)&"'>"&specCartRec(1,i)&"</option>"&Vbcrlf
		Next
	End IF
End Function
'=====================================================================

Sql="Select idx, title FROM brandAdmin ORDER BY listnum ASC, idx ASC"
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then brandRec=Rs.GetRows
Rs.Close

'###### 에디터 ID 생성 ##########
IF edNonce="" Then
	edNonce = GetEdNonce()
End IF
'###### 에디터 ID 생성 ##########

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BrandList()
	IF IsArray(brandRec) Then
		For i=0 To UBound(brandRec,2)
			Response.Write "<option value='"&brandRec(0,i)&"' "&selCheck(brandRec(0,i),brandidx)&">"&brandRec(1,i)&"</option>"&vbcrlf
		Next
	End IF
End Function

Function PT_Spec()
	IF isArray(specRec) Then
		rowCnt = Ubound(specRec,2)
	Else
		loopCnt = 4
	End IF

	loopCnt = rowCnt
	IF loopCnt < 4 Then loopCnt = 4

	For i=0 To loopCnt
		specName = "" : specVal = ""
		IF i < rowCnt Then
			specName = specRec(1,i)
			specVal = specRec(2,i)
		End IF

		Response.Write "<tr>"&Vbcrlf
		Response.Write "	<td class=""center""><input type=""checkbox"" name=""specCheckidx""></td>"&Vbcrlf
		Response.Write "	<td class=""center"">"&Vbcrlf
		Response.Write "		<input type=""text"" name=""iTitle"" maxlength=""50"" value="""&ReplaceTextField(specName)&""" style=""width:99%"">"&Vbcrlf
		Response.Write "	</td>"&Vbcrlf
		Response.Write "	<td class=""center""><input type=""text"" name=""iContent"" maxlength=""100"" value="""&ReplaceTextField(specVal)&""" style=""width:99%;"" placeholder=""줄바꿈시 '^' 를 입력해주세요""></td>"&Vbcrlf
		Response.Write "</tr>"&Vbcrlf
	Next
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<SCRIPT language=JavaScript src="../js/product.js" type='text/javascript'></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	change1(0);

	$(document).on("click",".selCateDel",function(){
		$(this).parent().remove();
	});
});
//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 시작 ++++++++++++++++++++++++++++++++
var cateName1='';
var cateName2='';
var cateName3='';

function select2Del(){
	var cnt=goods_form.select2.length
	for(var i=0;i<cnt;i++){ goods_form.select2.remove(0); }
	if(goods_form.select3){ select3Del(); }
}
function select3Del(){
	var cnt=goods_form.select3.length
	for(var i=0;i<cnt;i++){ goods_form.select3.remove(0); }
}
function change1(index){
	if(index != -1){
		var selVal = depth1_value[goods_form.select1.selectedIndex];
		cateName1=depth1[goods_form.select1.selectedIndex];

		if(goods_form.select2){
			select2Del();
			if(depth2[index].length!=0){
				$("#select2").removeClass("disNone")

				for(i=0;i<depth2[index].length;i++){
					goods_form.select2.options.add(new Option(depth2[index][i],depth2_value[index][i]));
				}
			}else{
				$("#select2").addClass("disNone")
			}
			change2(0);
		}
	}
}
function change2(index){
	if(index != -1){
		if(goods_form.select3){
			select3Del();

			if (depth3[goods_form.select1.selectedIndex][index]){

				if(depth3[goods_form.select1.selectedIndex][index].length!=0){
					for(i=0;i<depth3[goods_form.select1.selectedIndex][index].length;i++){
						goods_form.select3.options.add(new Option(depth3[goods_form.select1.selectedIndex][index][i],depth3_value[goods_form.select1.selectedIndex][index][i]));
					}
				}

			}
		}
		cateName2=depth2[goods_form.select1.selectedIndex][goods_form.select2.selectedIndex];

		setMainCate()
	}
}
function change3(index){
	if(index != -1){
		cateName3=depth3[goods_form.select1.selectedIndex][goods_form.select2.selectedIndex][goods_form.select3.selectedIndex];
	}
}
//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 끝 ++++++++++++++++++++++++++++++++

function setMainCate(){
	var form=document.goods_form;

	if(form.select1.value==""){
		alert("상품 카테고리를 끝까지 선택하세요.");
		return;
	}
	catecode = form.select1.value;
	if ($("#select2 option").size()>0){
		if(form.select2.value==""){
			alert("상품 카테고리를 끝까지 선택하세요.");
			return;
		}
		catecode = form.select2.value;
	}
	if ($("#select3 option").size()>0){
		if(form.select3.value==""){
			alert("상품 카테고리를 끝까지 선택하세요.");
			return;
		}
		catecode = form.select3.value;
	}
	cateVal = $("#select1 option:checked").text();
	if ($("#select2 option:checked").text()!=""){
		cateVal = cateVal + " > " + $("#select2 option:checked").text();
	}
	if ($("#select3 option:checked").text()!=""){
		cateVal = cateVal + " > " + $("#select3 option:checked").text();
	}
	$("#selCate"+catecode).remove()
	$("#cateRow").html("<li id='mainCate"+catecode+"'>"+cateVal+" <input type='hidden' name='mainCatecode' value='"+catecode+"'></li>")

	var params = "catecode="+catecode;
	$.ajax({type:"POST", url:'/_lib/selBrandOption.asp',data:params,dataType:"html",
	}).done(function(msg){
		$("#brandidx option").not("[value='']").remove();
		if (msg!=""){
			var setVal = $("#brandidx").attr("setVal");
			$("#brandidx").attr("setVal","")
			$("#brandidx").append(msg)
			$("#brandidx").val(setVal)

			$(".TIDTR").removeClass("disNone")
		}else{
			$(".TIDTR").addClass("disNone")
		}
	});
}

function setSelCate(){
	var form=document.goods_form;

	if(form.select1.value==""){
		alert("상품 카테고리를 끝까지 선택하세요.");
		return;
	}
	catecode = form.select1.value;
	if ($("#select2 option").size()>0){
		if(form.select2.value==""){
			alert("상품 카테고리를 끝까지 선택하세요.");
			return;
		}
		catecode = form.select2.value;
	}
	if ($("#select3 option").size()>0){
		if(form.select3.value==""){
			alert("상품 카테고리를 끝까지 선택하세요.");
			return;
		}
		catecode = form.select3.value;
	}

	if ($("#mainCate"+catecode).length!=0){
		alert("메인 카테고리에 지정된 카테고리입니다.")
		return;
	}
	if ($("#selCate"+catecode).length==0){
		cateVal = $("#select1 option:checked").text();
		if ($("#select2 option:checked").text()!=""){
			cateVal = cateVal + " > " + $("#select2 option:checked").text();
		}
		if ($("#select3 option:checked").text()!=""){
			cateVal = cateVal + " > " + $("#select3 option:checked").text();
		}
		$("#selCateRow").append("<li id='selCate"+catecode+"'><a class='btn_gray mr10 selCateDel'>삭제</a> "+cateVal+" <input type='hidden' name='selCatecode' value='"+catecode+"'></li>")	
	}else{
		alert("이미 추가된 카테고리입니다.")
		return;
	}
}

function sendit(){
	var form=document.goods_form;
	var date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/; 

	if($("#cateRow").html()==""){
		alert("대표카테고리를 지정해주세요.");
		return;
	}
	if(form.itemname.value==""){
		alert("제품명을 입력하세요.");
		form.itemname.focus();
		return;
	}
	/*if(form.price.value==""){
		alert("상품가격을 입력하세요.");
		form.price.focus();
		return;
	}
	if(uploadImg_check(form.files.value,"섬네일이미지를 올바로 입력하세요.",1)==false){
		form.files.focus();
		return;
	}*/
	form.submit();
}
//-->
</SCRIPT>

<script type="text/javascript">
$(document).ready(function(){
	$(document).on("change","input[name=pricesort]",function(){
		chkVal = $('input[name=pricesort]:checked').val() ;

		if (chkVal=="0"){
			$("#onceModelArea").show();
			$("#multiModelArea").hide();
		}else{
			$("#onceModelArea").hide();
			$("#multiModelArea").show();
		}
	});
	$("input[name=pricesort]").change();

	$(document).on("click",".btnModelAdd",function(){
		var cnt = $("#multiModelArea .modelData").size()
		var textareaID = "mContent"+(cnt+1)

		$("#multiModelCopyDiv").find("textarea").attr("id", textareaID)
		var html = $("#multiModelCopyDiv").html()
		$("#multiModelCopyDiv").find("textarea").attr("id", "")

		$("#multiModelArea").append(html);

		setCKEDITOR5(textareaID)
	});
	$(document).on("click",".btnModelRemove",function(){
		$(this).closest(".modelData").remove();
	});
});
</script>
<style>
.modelData{margin-bottom:10px;}
.modelData>div{display:flex; align-items: center; margin-bottom:7px;}
.modelData>div *{margin-right:5px; display:inline-block; }
.modelData input{width:100%; height:32px;}
.modelData:last-child{margin-bottom:0px}

.btnModelAdd{width:80px; height:30px; background-color: #2e6c00; font-size:12px; line-height:30px; color: #fff; text-align: center; z-index:5; border-radius:2px; box-sizing: border-box; cursor: pointer;}
.btnModelAdd:before{content: "+ ";}
.btnModelAdd:hover{color:#fff;}
.btnModelRemove{width:80px; height:30px; background-color: #770000; font-size:12px; line-height:30px; color: #fff; text-align: center; border-radius:2px; box-sizing: border-box; cursor: pointer;}
.btnModelRemove:before{content: "- ";}
.btnModelRemove:hover{color:#fff;}

#multiModelArea{position:relative;}

.ck-editor__editable{min-height:200px;}
</style>
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

<form action="productOK.asp" method="post" name="goods_form" enctype="multipart/form-data" target='actFrame'>
<input type='hidden' name='catecode' value=''>
<input type='hidden' name='langmode' value='<%=langmode%>'>
<input type='hidden' name='edNonce' value='<%=edNonce%>'>
<table class="tbl_row box">
<colgroup>
<col width="15%"></col>
<col width=""></col>
</colgroup>
	<tr>
		<th width="15%">카테고리 선택</th>
		<td>
			<select name="select1" id="select1" style="min-width:150px;" onClick='change1(this.selectedIndex);'>
			</select>
			<select name="select2" id="select2" style="min-width:150px;" onClick='change2(this.selectedIndex);'>
			</select>
		</td>
	</tr>
	<tr>
		<th>카테고리 명</th>
		<td height="25">
			<ul id='cateRow'></ul>
		</td>
	</tr>
	<tr class="TIDTR">
		<th width="15%">Tube ID</th>
		<td>
			<select name="brandidx" id="brandidx" setVal="<%=brandidx%>">
				<option value="">선택하세요.</option>
			</select>
		</td>
	</tr>
	<tr>
		<th>공개여부</th>
		<td>
			<input name="display" id="display1" type="radio" value="1" checked><label for="display1" style='margin-right:15px;'>공개</label>
			<input name="display" id="display2" type="radio" value="0"><label for="display2" style='margin-right:15px;'>비공개</label>
		</td>
	</tr>
</table>

<div style="height:20px;"></div>

<table class="tbl_row box">
<colgroup>
<col width="15%"></col>
<col width=""></col>
</colgroup>
	<tr>
		<th>제품명</th>
		<td>
			<input type='text' name='itemname' maxlength='100' value="<%=itemname%>">
		</td>
	</tr>
	<tr>
		<th>간략설명</th>
		<td>
			<textarea name="thumbContent" style="height:150px;"><%=thumbContent%></textarea>
		</td>
	</tr>
	<tr>
		<th>제품관련파일</th>
		<td>
			<div class="itemFileField">
				<span>대표이미지</span>
				<input name="files" type="file" class="input">&nbsp;&nbsp;[최적사이즈:300px * 300px]
			</div>
			<div class="itemFileField">
				<span>상세이미지</span>
				<input name="files" type="file" class="input">&nbsp;&nbsp;[최적사이즈:600px * 600px]
			</div>
			<div class="itemFileField">
				<span>상세이미지2</span>
				<input name="files" type="file" class="input">
			</div>
			<div class="itemFileField">
				<span>상세이미지3</span>
				<input name="files" type="file" class="input">
			</div>
			<div class="itemFileField">
				<span>상세이미지4</span>
				<input name="files" type="file" class="input">
			</div>
			<div class="itemFileField">
				<span>상세이미지5</span>
				<input name="files" type="file" class="input">
			</div>
		</td>
	</tr>
</table>

<div class="subTitle">Technical Data</div>
<table class="tbl_row box">
	<tr>
		<td>
			<textarea name='txtNote1' id='txtNote1' class='ckeditor5'><%=txtNote1%></textarea>
		</td>
	</tr>
</table>

<div class="subTitle">Document</div>
<table class="tbl_row box">
	<tr>
		<td>
			<textarea name='txtNote2' id='txtNote2' class='ckeditor5'><%=txtNote2%></textarea>
		</td>
	</tr>
</table>

<div class="subTitle">
	MODELS

	<p class="checkIn ml20">
		<input type="radio" name="pricesort" id="pricesort1" value="0" checked><label for="pricesort1">단일 MODEL 정보</label>
	</span>
	<p class="checkIn">
		<input type="radio" name="pricesort" id="pricesort2" value="1"><label for="pricesort2">다중 MODEL 정보</label>
	</span>
</div>
<div id="onceModelArea">
	<table class="tbl_row box">
		<tr>
			<td>
				<textarea name='content' id='content' class='ckeditor5'><%=content%></textarea>
			</td>
		</tr>
	</table>
</div>

<div id="multiModelArea">
	<div class="modelData">
		<div>
			<input type="text" name="mTitle" maxlength="200" value="" placeholder="MODEL TITLE">
			<a type="button" class="btnModelAdd">추가</a>
		</div>
		<table class="tbl_row box">
			<tr>
				<td>
					<textarea name='mContent' id="mContent1" class='ckeditor5'></textarea>
				</td>
			</tr>
		</table>
	</div>
</div>

<div class="btn_center pt30">
	<a href="javascript:sendit()" class="btn_largeG">확인</a>
	<a href="product.asp?page=<%=page%>&<%=pagestr%>" class="btn_largeW">목록</a>
</div>
</form>


			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->

<%PT_CateScript%>
<SCRIPT LANGUAGE="JavaScript">
<!--
for(i=0;i<depth1.length;i++){
	document.all.select1.options.add(new Option(depth1[i],depth1_value[i]));
}
-->
</SCRIPT>


<div id="multiModelCopyDiv" class="disNone">
	<div class="modelData">
		<div>
			<input type="text" name="mTitle" maxlength="200" value="" placeholder="MODEL TITLE">
			<a type="button" class="btnModelRemove">삭제</a>
		</div>
		<table class="tbl_row box">
			<tr>
				<td>
					<textarea name='mContent'></textarea>
				</td>
			</tr>
		</table>
	</div>
</div>