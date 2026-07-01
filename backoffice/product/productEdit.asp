<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim langTitle, langmode

'=====form 전송을 위한 변수 셋팅============================
Page = uf_getRequest(Request("Page"),"int","","")
serSelCate = uf_getRequest(Request("serSelCate"),"int","1","")
sercatecode = uf_getRequest(Request("sercatecode"),"char","50","")
searchOB = uf_getRequest(Request("searchOB"),"int","3","")
seritemstat = uf_getRequest(Request("seritemstat"),"int","1","")
serSellYn = uf_getRequest(Request("serSellYn"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
sercatecode1 = uf_getRequest(Request("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(Request("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(Request("sercatecode3"),"char","","")

PageStr="langmode="&langmode&"&serSelCate="&serSelCate&"&sercatecode1="&sercatecode1&"&sercatecode2="&sercatecode2&"&sercatecode3="&sercatecode3&"&sercatecode="&sercatecode&"&searchOB="&searchOB&"&seritemstat="&seritemstat&"&serSellYn="&serSellYn&"&searchStr="&searchStr
'=====form 전송을 위한 변수 셋팅============================

subitemidx = uf_getRequest(Request("subitemidx"),"int","","")
'=======================================상품정보 출력을 위한 코드
Sql = "SELECT langmode, txtNote1, txtNote2, display, itemname, content, regdate, listimg, imgname1, imgname2, imgname3, imgname4, imgname5, imgname6, imgname7, note1, note2, note3, note4, note5, note6, content1, thumbContent, brandidx, price, new_mark, cateidx, pricesort, isFreeAS, affDiscount, edNonce FROM product WHERE idx="&subitemIdx
ItemInfo=DBcon.Execute(Sql)

langmode=ItemInfo("langmode")

txtNote1=ItemInfo("txtNote1")
txtNote2=ItemInfo("txtNote2")

display=ItemInfo("display")
itemname=ReplaceTextField(ItemInfo("itemname"))
note1=ReplaceTextField(ItemInfo("note1"))
note2=ReplaceTextField(ItemInfo("note2"))
note3=ReplaceTextField(ItemInfo("note3"))
note4=ReplaceTextField(ItemInfo("note4"))
note5=ReplaceTextField(ItemInfo("note5"))
note6=ReplaceTextField(ItemInfo("note6"))
thumbContent=ReplaceTextField(ItemInfo("thumbContent"))
content=ReplaceNoHtml(ItemInfo("content"))
content1=ReplaceNoHtml(ItemInfo("content1"))
Regdate=ItemInfo("regdate")
Listimg=ItemInfo("Listimg")
imgname1=ItemInfo("imgname1") : imgname2=ItemInfo("imgname2") : imgname3=ItemInfo("imgname3") : imgname4=ItemInfo("imgname4") : imgname5=ItemInfo("imgname5")
imgname6=ItemInfo("imgname6") : imgname7=ItemInfo("imgname7")
brandidx = changeBlank(ItemInfo("brandidx"))
price=ItemInfo("price")
new_mark=ItemInfo("new_mark")
cateidx=iteminfo("cateidx")
pricesort=iteminfo("pricesort")
isFreeAS=iteminfo("isFreeAS")
affDiscount=ChangeBlank(iteminfo("affDiscount"))
edNonce = changeBlank(iteminfo("edNonce"))

Set ItemInfo=Nothing

IF ListImg<>"" Then ImgTag1="<input type='buttton' class=""btn_gray"" value='이미지보기' style='width:80px' onclick=""openWindow(10,10,'/_lib/imgview.asp?path=product&imgname="&Server.UrlEncode(ListImg)&"','img','no');"">"
IF imgname1<>"" Then ImgTag2="<input type='buttton' class=""btn_gray"" value='이미지보기' style='width:80px' onclick=""openWindow(10,10,'/_lib/imgview.asp?path=product&imgname="&Server.UrlEncode(imgname1)&"','img','no');"">"
IF imgname2<>"" Then ImgTag3="<input type='buttton' class=""btn_gray"" value='이미지보기' style='width:80px' onclick=""openWindow(10,10,'/_lib/imgview.asp?path=product&imgname="&Server.UrlEncode(imgname2)&"','img','no');"">"
IF imgname3<>"" Then ImgTag4="<input type='buttton' class=""btn_gray"" value='이미지보기' style='width:80px' onclick=""openWindow(10,10,'/_lib/imgview.asp?path=product&imgname="&Server.UrlEncode(imgname3)&"','img','no');"">"
IF imgname4<>"" Then ImgTag5="<input type='buttton' class=""btn_gray"" value='이미지보기' style='width:80px' onclick=""openWindow(10,10,'/_lib/imgview.asp?path=product&imgname="&Server.UrlEncode(imgname4)&"','img','no');"">"
IF imgname5<>"" Then ImgTag6="<input type='buttton' class=""btn_gray"" value='이미지보기' style='width:80px' onclick=""openWindow(10,10,'/_lib/imgview.asp?path=product&imgname="&Server.UrlEncode(imgname5)&"','img','no');"">"

Sql="Select name,lowcode,middlecode,topcode,isdisplay FROM Category ORDER BY align1Num, align2Num, align3Num"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
'================================================================

Call getLangModeTitle(langmode)

Sql="SELECT catecode, dbo.fn_CateFullName(catecode) AS catenames, isMain FROM productCategory WHERE pidx = "&subitemidx&" ORDER BY isMain DESC, idx ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	mainCatecode = Rs("catecode")
	setCateRec=Rs.GetRows

	Sql="SELECT tc.[lowcode] as tcCode, mc.[lowcode] as mcCode, lc.[lowcode] as lcCode FROM category lc inner join category mc on lc.middlecode = mc.lowcode inner join category tc on lc.topcode = tc.lowcode Where lc.lowcode='"&mainCatecode&"'"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		tcCode = Rs(0)
		mcCode = Rs(1)
		lcCode = Rs(2)
	End IF
End IF

Sql="Select idx, mTitle, mContent From productModel Where pidx="&subitemidx
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then modelRec=Rs.Getrows()
Rs.Close

'###### 에디터 ID 생성 ##########
IF edNonce="" Then
	edNonce = GetEdNonce()
End IF
'###### 에디터 ID 생성 ##########

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_Models()
	IF isArray(modelRec) Then
		For i=0 To Ubound(modelRec, 2)
			mTitle = changeBlank(modelRec(1,i))
			mContent = changeBlank(modelRec(2,i))

			Response.Write "<div class=""modelData"">"&Vbcrlf
			Response.Write "		<div>"&Vbcrlf
			Response.Write "			<input type=""text"" name=""mTitle"" maxlength=""200"" value="""&ReplaceTextField(mTitle)&""" placeholder=""MODEL TITLE"">"&Vbcrlf
			Response.Write "			<a type=""button"" class=""btnModelAdd"">추가</a>"&Vbcrlf
			Response.Write "		</div>"&Vbcrlf
			Response.Write "		<table class=""tbl_row box"">"&Vbcrlf
			Response.Write "			<tr>"&Vbcrlf
			Response.Write "				<td>"&Vbcrlf
			Response.Write "					<textarea name='mContent' id=""mContent"&i+1&""" class='ckeditor5'>"&mContent&"</textarea>"&Vbcrlf
			Response.Write "				</td>"&Vbcrlf
			Response.Write "			</tr>"&Vbcrlf
			Response.Write "		</table>"&Vbcrlf
			Response.Write "	</div>"&Vbcrlf
		Next
	Else
		Response.Write "<div class=""modelData"">"&Vbcrlf
		Response.Write "		<div>"&Vbcrlf
		Response.Write "			<input type=""text"" name=""mTitle"" maxlength=""200"" value="""" placeholder=""MODEL TITLE"">"&Vbcrlf
		Response.Write "			<a type=""button"" class=""btnModelAdd"">추가</a>"&Vbcrlf
		Response.Write "		</div>"&Vbcrlf
		Response.Write "		<table class=""tbl_row box"">"&Vbcrlf
		Response.Write "			<tr>"&Vbcrlf
		Response.Write "				<td>"&Vbcrlf
		Response.Write "					<textarea name='mContent' id=""mContent1"" class='ckeditor5'></textarea>"&Vbcrlf
		Response.Write "				</td>"&Vbcrlf
		Response.Write "			</tr>"&Vbcrlf
		Response.Write "		</table>"&Vbcrlf
		Response.Write "	</div>"&Vbcrlf
	End IF
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
	$(document).on("click",".selCateDel",function(){
		$(this).parent().remove();
	});
	$(document).on("change","#select1",function(){
		var index = $("#select1 option:selected").index()

		if(index != -1){
			var selVal = depth1_value[goods_form.select1.selectedIndex];

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

				var setVal = $("#select2").attr("setVal")
				if (setVal==""){
					$("#select2").val("<%=mcCode%>").change();
					$("#select2").attr("setVal","");
				}else{
					$("#select2").change();
				}
			}
		}
	});
	$(document).on("change","#select2",function(){
		var index = $("#select2 option:selected").index()

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
			setTubeOption($("#select2").val());
			$("input[name=mainCatecode]").val( $("#select2").val() )
			$("#select3").change()
		}
	});

	$(document).on("change","#select3",function(){
		var index = $("#select3 option:selected").index()
	});

	$("#select1").val("<%=tcCode%>").change();;
	$("input[name=addoptYN]").change();
});
//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 시작 ++++++++++++++++++++++++++++++++
function select2Del(){
	var cnt=goods_form.select2.length
	for(var i=0;i<cnt;i++){ goods_form.select2.remove(0); }
	if(goods_form.select3){ select3Del(); }
}
function select3Del(){
	var cnt=goods_form.select3.length
	for(var i=0;i<cnt;i++){ goods_form.select3.remove(0); }
}
//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 끝 ++++++++++++++++++++++++++++++++

function setTubeOption(catecode){
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

function sendit(){
	var form=document.goods_form;
	var date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/; 

	if (form.mainCatecode.value==""){
		alert("카테고리를 끝까지 선택해주세요.")
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
	if(uploadImg_check(form.files.value,"이미지를 올바로 입력하세요.",1)==false){
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
					<h2 class="top_left"><%=GB_SubMenuName%> <!-- (<%=langTitle%>) --></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

<form action="productOK.asp" method="post" name="goods_form" enctype="multipart/form-data" target='actFrame'>
<input type='hidden' name='mode' value='edit'>
<input type='hidden' name='langmode' value='<%=langmode%>'>
<input type='hidden' name='catecode' value='<%=CateCode%>'>
<input type='hidden' name='idx' value='<%=subitemIdx%>'>
<input type='hidden' name='page' value='<%=page%>'>
<input type='hidden' name='sercatecode' value='<%=sercatecode%>'>
<input type='hidden' name='searchStr' value='<%=searchStr%>'>
<input type='hidden' name='searchOB' value='<%=searchOB%>'>
<input type='hidden' name='seritemstat' value='<%=seritemstat%>'>
<input type='hidden' name='serSellYn' value='<%=serSellYn%>'>
<input type='hidden' name='sercatecode1' value='<%=sercatecode1%>'>
<input type='hidden' name='sercatecode2' value='<%=sercatecode2%>'>
<input type='hidden' name='sercatecode3' value='<%=sercatecode3%>'>
<input type='hidden' name='edNonce' value='<%=edNonce%>'>
<input type='hidden' name='mainCatecode' value=''>
<table class="tbl_row box">
<colgroup>
<col width="15%"></col>
<col width=""></col>
</colgroup>
	<tr>
		<th width="15%">카테고리 선택</th>
		<td>
			<select name="select1" id="select1" style="min-width:150px;" setVal="<%=tcCode%>">
			</select>
			<select name="select2" id="select2" style="min-width:150px;" class="disNone" setVal="<%=mcCode%>">
			</select>
			<select name="select3" id="select3" style="min-width:150px;" class="disNone" setVal="<%=lcCode%>">
			</select>
		</td>
	</tr>
	<tr class="TIDTR disNone">
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
			<input name="display" id="display2" type="radio" value="0" <%=ChangeChecked(0,display)%>><label for="display2" style='margin-right:15px;'>비공개</label>
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
				<input name="files" type="file" class="input fileField">&nbsp;&nbsp;<input type='hidden' name='filename' value="<%=Listimg%>">
				<% IF Listimg="" Then %>
				<input type='hidden' name='FileDel_Chk' value="1">
				<% Else %>
				<label><input type='checkbox' name='FileDel_Chk' class="fileFieldChk"> 파일삭제</label>
				<% End IF %>
				<%=ImgTag1%>
			</div>
			<div class="itemFileField">
				<span>상세이미지</span>
				<input name="files" type="file" class="input fileField">&nbsp;&nbsp;<input type='hidden' name='filename1' value="<%=ImgName1%>">
				<% IF ImgName1="" Then %>
				<input type='hidden' name='FileDel_Chk1' value="1">
				<% Else %>
				<label><input type='checkbox' name='FileDel_Chk1' class="fileFieldChk"> 파일삭제</label>
				<% End IF %>
				<%=ImgTag2%>
			</div>
			<div class="itemFileField">
				<span>상세이미지2</span>
				<input name="files" type="file" class="input fileField">&nbsp;&nbsp;<input type='hidden' name='filename2' value="<%=ImgName2%>">
				<% IF ImgName2="" Then %>
				<input type='hidden' name='FileDel_Chk2' value="1">
				<% Else %>
				<label><input type='checkbox' name='FileDel_Chk2' class="fileFieldChk"> 파일삭제</label>
				<% End IF %>
				<%=ImgTag3%>
			</div>
			<div class="itemFileField">
				<span>상세이미지3</span>
				<input name="files" type="file" class="input fileField">&nbsp;&nbsp;<input type='hidden' name='filename3' value="<%=ImgName3%>">
				<% IF ImgName3="" Then %>
				<input type='hidden' name='FileDel_Chk3' value="1">
				<% Else %>
				<label><input type='checkbox' name='FileDel_Chk3' class="fileFieldChk"> 파일삭제</label>
				<% End IF %>
				<%=ImgTag4%>
			</div>
			<div class="itemFileField">
				<span>상세이미지4</span>
				<input name="files" type="file" class="input fileField">&nbsp;&nbsp;<input type='hidden' name='filename4' value="<%=ImgName4%>">
				<% IF ImgName4="" Then %>
				<input type='hidden' name='FileDel_Chk4' value="1">
				<% Else %>
				<label><input type='checkbox' name='FileDel_Chk4' class="fileFieldChk"> 파일삭제</label>
				<% End IF %>
				<%=ImgTag5%>
			</div>
			<div class="itemFileField">
				<span>상세이미지5</span>
				<input name="files" type="file" class="input fileField">&nbsp;&nbsp;<input type='hidden' name='filename5' value="<%=ImgName5%>">
				<% IF ImgName5="" Then %>
				<input type='hidden' name='FileDel_Chk5' value="1">
				<% Else %>
				<label><input type='checkbox' name='FileDel_Chk5' class="fileFieldChk"> 파일삭제</label>
				<% End IF %>
				<%=ImgTag6%>
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
		<input type="radio" name="pricesort" id="pricesort2" value="1" <%=iif_compare(pricesort, "1", "checked")%>><label for="pricesort2">다중 MODEL 정보</label>
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
	<%=PT_Models()%>
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
form=document.goods_form ;
for(i=0;i<depth1.length;i++){
	form.select1.options.add(new Option(depth1[i],depth1_value[i]));
}
//-->
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