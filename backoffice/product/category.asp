<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
sIndex1=Request("sIndex1")
sIndex2=Request("sIndex2")
sIndex3=Request("sIndex3")
catecode=Request("catecode")

langmode=1

Sql="Select name,lowcode,middlecode,topcode,isdisplay FROM Category WHERE langmode="&langmode&" AND bannerSort is NULL ORDER BY align1Num, align2Num, align3Num"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Allrec=Rs.GetRows
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT language=JavaScript src="/_lib/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	setCategory();

	<% IF CStr(sIndex1)<>"" AND CStr(sIndex1)<>"-1" Then %>
	if ($("#cateSelect1 option").size()><%=sIndex1%>){
		$("#cateSelect1 option:eq(<%=sIndex1%>)").attr("selected",true);
		setCategory(1);
	}
	<% End IF %>

	<% IF CStr(sIndex2)<>"" AND CStr(sIndex2)<>"-1" Then %>
	if ($("#cateSelect2 option").size()><%=sIndex2%>){
		$("#cateSelect2 option:eq(<%=sIndex2%>)").attr("selected",true);
		setCategory(2);
	}
	<% End IF %>

	<% IF CStr(sIndex3)<>"" AND CStr(sIndex3)<>"-1" Then %>
	if ($("#cateSelect3 option").size()><%=sIndex3%>){
		$("#cateSelect3 option:eq(<%=sIndex3%>)").attr("selected",true);
		setCategory(3);
	}
	<% End IF %>

	//CKEDITOR.replace( 'detailcontent', { height : 300 } );
});

function setCategory(depth){
	var obj1 = $("#cateSelect1");
	var obj2 = $("#cateSelect2");
	var obj3 = $("#cateSelect3");

	var selIndex1 = $("#cateSelect1 option").index($("#cateSelect1 option:selected"));;
	var selIndex2 = $("#cateSelect2 option").index($("#cateSelect2 option:selected"));;
	var selIndex3 = $("#cateSelect3 option").index($("#cateSelect3 option:selected"));;

	var selBg1, selBg2, selBg3;

	if (!depth){
		for(i=0;i<depth1.length;i++){
			selBg1 = (depth1_display[i] == 0 ? " style='color:#929292;'" : "");

			$(obj1).append("<option value='"+depth1_value[i]+"' "+selBg1+">"+depth1[i]+"</option>");
		}
	}else if (depth==1){
		$(obj2).find("option").remove();
		$(obj3).find("option").remove();

		for(i=0;i<depth2[selIndex1].length;i++){
			selBg2 = (depth2_display[selIndex1][i] == 0 ? " style='color:#929292;'" : "");

			$(obj2).append("<option value='"+depth2_value[selIndex1][i]+"' "+selBg2+">"+depth2[selIndex1][i]+"</option>");
		}
	}else if (depth==2){
		$(obj3).find("option").remove();

		for(i=0;i<depth3[selIndex1][selIndex2].length;i++){
			selBg3 = (depth3_display[selIndex1][selIndex2][i] == 0 ? " style='color:#929292;'" : "");

			$(obj3).append("<option value='"+depth3_value[selIndex1][selIndex2][i]+"' "+selBg3+">"+depth3[selIndex1][selIndex2][i]+"</option>");
		}
	}

	$("#sIndex1").val(selIndex1);
	$("#sIndex2").val(selIndex2);
	$("#sIndex3").val(selIndex3);
}

//++++++++++++++++++++++++++++++++++++카테고리 추가++++++++++++++++++++++++++++++++++++
function addCate(){
	var code,name;
	var form=document.cateform;
	var obj_input=document.cateform.catename.value;
	var n = document.cateform.regsort.value;

	if(n==2){
		if(form.select1.selectedIndex<0){
			alert("1차카테고리를 선택하세요.");
			return;
		}
	}else if(n==3){
		if(form.select1.selectedIndex<0){
			alert("1차카테고리를 선택하세요.");
			return;
		}if(form.select2.selectedIndex<0){
			alert("2차카테고리를 선택하세요.");
			return;
		}
	}
	if(obj_input==""){
		alert("카테고리명을 입력해주세요.");
		document.cateform.catename.focus();
		return;
	}

	/*for (i=0;i<form.imgfiles.length ;i++ ){
		if(uploadImg_check(form.imgfiles[i].value,"이미지를 올바로 입력하세요.",1)==false){
			form.imgfiles[i].focus()
			return;
		}
	}*/
	document.cateform.catecode.value=creCode();
	cateform.action="category_add.asp?sort="+n;
	cateform.submit();
}

//+++++++++++++++++++++++++++++++++카테고리 삭제 함수+++++++++++++++++++++++++++++++++++++++
function cateDel(n,index){
	var obj_part,msg,delCode
	if(n==1){obj_part=document.cateform.select1; msg="하위카테고리까지 삭제됩니다.\n선택하신 카테고리를 삭제하시겠습니까?"}
	else if(n==2){ obj_part=document.cateform.select2; msg="하위카테고리까지 삭제됩니다.\n선택하신 카테고리를 삭제하시겠습니까?"}
	else{ obj_part=document.cateform.select3; msg="선택하신 카테고리를 삭제하시겠습니까?"}

	if(obj_part.selectedIndex==-1){	alert("삭제할 카테고리를 선택해주세요"); return; }

	var value=confirm(msg)
	if(value){
		delCode=obj_part.value;

		langmode=document.cateform.langmode.value;
		sIndex1=document.cateform.sIndex1.value;
		sIndex2=document.cateform.sIndex2.value;
		sIndex3=document.cateform.sIndex3.value;
		location.href="categoryDel.asp?langmode="+langmode+"&delCode="+delCode+"&sIndex1="+sIndex1+"&sIndex2="+sIndex2+"&sIndex3="+sIndex3+"&sort="+n;
	}
}

//+++++++++++++++++++++++++++++++++카테고리 순위변경 함수+++++++++++++++++++++++++++++++++++++++
function numchangeCate(n){
	var obj_select,codes="";
	var value = confirm(n+"차 카테고리 순서를 변경하시겠습니까?")
	if (value){
		if (n == 1){
			obj_select = document.cateform.select1;
		} else if (n == 2){
			obj_select = document.cateform.select2;
		} else{
			obj_select = document.cateform.select3;
		}
		if(obj_select.options.length==0){
			alert(n+"차 카테고리에 카테고리List가 없습니다.\n카테고리 선택 및 추가후 시도해주세요.");
			return;
		}
		for(var i=0;i<obj_select.options.length;i++){
			codes=codes+obj_select.options[i].value+",";
		}
		document.cateform.catecode.value=codes;
		document.cateform.action="category_align.asp?sort="+n;
		document.cateform.submit();
	}
}

//+++++++++++++++++++++++++++++++++카테고리 이동 함수+++++++++++++++++++++++++++++++++++++++
function cateMove(n,to) {
	var opt = $("#cateSelect"+n+" option:selected");

	if (to=="up"){
		opt.insertBefore(opt.prev());
	}else{
		opt.insertAfter(opt.next());
	}
}


//+++++++++++++++++++++++++++++++++고유 카테고리 코드 생성+++++++++++++++++++++++++++++++++++++++
function creCode(){
	a= new Date(); //현재 시각을 구함
	code="'"+a.getTime()+"'"
	code=code.substring(1,11)
	return code;
}
function showModifyCategory(idx,catesort){
	$.ajax({
		type:"post",
		url: "layer_categoryModify.asp",
		data:{"catesort":catesort,"idx":idx},
		dataType:"html",
		async: true,
		beforeSend : function(){
			popupLoadingOpen();
		}
	}).done(function(data){
		fnLayerPopupOpen(data);
		//CKEDITOR.replace( 'editcontent', { height : 250 } );
	})
}
function cateDetailSendit(){
	var of=document.cateform;
	var f=document.catedetailFrm;

	f.sIndex1.value=of.select1.selectedIndex;
	if(of.select2){ f.sIndex2.value=of.select2.selectedIndex; }
	if(of.select3){ f.sIndex3.value=of.select3.selectedIndex; }

	if(f.catecode.value==""){
		alert("세부정보를 수정할 카테고리를 선택해주세요.");
		return;
	}
	if(uploadImg_check(f.files1.value,"이미지를 올바로 입력하세요.",1)==false){
		return;
	}
	var val=confirm("해당 카테고리의 세부정보를 수정하시겠습니까?");
	if (val){
		f.submit();
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
					<h2 class="top_left"><%=GB_SubMenuName%> <!-- (<%=langTitle%>) --></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<!-- <div style='clear:both; padding-bottom:5px;'>
					<select name='langmode' class="select" style='width:100%; background-color:#000; color:#fff; font-size:14px; padding:5px; height:auto;' onchange="location.href='?langmode='+this.value;">
						<option value='1' <%=SelCheck(1,langmode)%>>국문 제품카테고리 관리</option>
						<option value='2' <%=SelCheck(2,langmode)%>>영문 제품카테고리 관리</option>
					</select>
				</div> -->

				<form name='cateform' method='post' action='category_ok.asp' onsubmit="addCate();return false;" ENCTYPE="multipart/form-data">
				<input type='hidden' name='catecode' value=''>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='sIndex1' id="sIndex1" value=''>
				<input type='hidden' name='sIndex2' id="sIndex2" value=''>
				<input type='hidden' name='sIndex3' id="sIndex3" value=''>
				<table border="0" cellpadding="0" cellspacing="0" width='100%'>
					<tr>
						<td align='center' width='49%'>
							<select name="select1" id="cateSelect1" size="8" style="background-color:#F6F6F6; width:100%; height:250px; font-size:14px; padding:5px;" onchange='setCategory(1)' ondblclick='showModifyCategory(this.value,1)'>
							</select>
						</td>
						<td align='center' width='49%'>
							<select name="select2" id="cateSelect2" size="8" style="background-color:#F6F6F6; width:100%; height:250px; font-size:14px; padding:5px;" onchange='setCategory(2)' ondblclick='showModifyCategory(this.value,2)'>
							</select>
						</td>
						<!-- <td align='center' width='33%'>
							<select name="select3" id="cateSelect3" size="8" style="background-color:#F6F6F6; width:100%; height:250px; font-size:14px; padding:5px;" ondblclick='showModifyCategory(this.value,3)'>
							</select>
						</td> -->
					</tr>
					<tr>
						<td align="center" style="padding:10px 0;">
							<img src="../images/cate1st.gif" alt="1차카테고리" style="vertical-align:middle;">
							<a href='javascript:cateDel(1,cateform.select1.selectedIndex)'><img src='../images/icon/bt_del1.gif' border='0' style="vertical-align:middle;"></a>
							<img src="../images/icon/bt_up.gif" onclick="cateMove(1,'up')" style='cursor:pointer; vertical-align:middle;'>
							<img src="../images/icon/bt_down.gif" onclick="cateMove(1,'down')" style='cursor:pointer; vertical-align:middle;'>
							<input type='button' value='순서변경' class='btn_gray' style='width:60px;' onclick='numchangeCate(1);'>
						</td>
						<td align="center" style="padding:10px 0;">
							<img src="../images/cate2st.gif" alt="2차카테고리" style="vertical-align:middle;">
							<a href='javascript:cateDel(2,cateform.select2.selectedIndex)'><img src='../images/icon/bt_del1.gif' border='0' style="vertical-align:middle;"></a>
							<img src="../images/icon/bt_up.gif" onclick="cateMove(2,'up')" style='cursor:pointer; vertical-align:middle;'>
							<img src="../images/icon/bt_down.gif" onclick="cateMove(2,'down')" style='cursor:pointer; vertical-align:middle;'>
							<input type='button' value='순서변경' class='btn_gray' style='width:60px;' onclick='numchangeCate(2);'>
						</td>
						<!-- <td align="center" style="padding:10px 0;">
							<img src="../images/cate3st.gif" alt="3차카테고리" style="vertical-align:middle;">
							<a href='javascript:cateDel(1,cateform.select3.selectedIndex)'><img src='../images/icon/bt_del1.gif' border='0' style="vertical-align:middle;"></a>
							<img src="../images/icon/bt_up.gif" onclick="cateMove(3,'up')" style='cursor:pointer; vertical-align:middle;'>
							<img src="../images/icon/bt_down.gif" onclick="cateMove(3,'down')" style='cursor:pointer; vertical-align:middle;'>
							<input type='button' value='순서변경' class='btn_gray' style='width:60px;' onclick='numchangeCate(3);'>
						</td> -->
					</tr>
				</table>

				<div style='clear:both; padding:0 0 20px 0; line-height:1.4;'>
					<b>☞카테고리 설정법☜</b><br>

					<b>카테고리 등록</b> : 하단 카테고리 등록 모드에서 등록합니다.<br>
					<b>카테고리 수정</b> : 상단 카테고리 리스트에서 수정할 카테고리 더블클릭 하면 수정이 가능합니다.<br>
					<b>카테고리 삭제 및 순서변경</b> : 상단 카테고리별 버튼을 이용하여 카테고리 삭제 및 순서변경을 하실수 있습니다.(카테고리 박스에 보이는 순서대로 홈페이지에 적용됩니다.)<br>
					<font style='color: red; font-weight:bold;'>기존 카테고리 삭제시 카테고리에 등록된 상품이 존재할 경우 카테고리 삭제가 불가능합니다.</font>
					</fieldset>
				</div>

				<table class="tbl_row">
					<colgroup>
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th colspan='2' style="text-align:center;">카테고리 등록</th>
					</tr>
					<tr>
						<th>카테고리 DEPTH</th>
						<td>
							<select name="regsort">
								<option value="1">1차 카테고리</option>
								<option value="2" selected>2차 카테고리</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>공개여부</th>
						<td>
							<input type="radio" name='isdisplay' id="isdisplay1" value="1" checked><label for="isdisplay1" style="margin-right:10px;">공개</label>
							<input type="radio" name='isdisplay' id="isdisplay2" value="0"><label for="isdisplay2">비공개</label>
						</td>
					</tr>
					<tr>
						<th>카테고리명</th>
						<td><input type='text' name='catename' size='80' maxlength='100' class='input'></td>
					</tr>
					<tr class="disNone">
						<th>서브 카테고리명</th>
						<td><input type='text' name='catenameSub' size='80' maxlength='100' class='input'></td>
					</tr>
					<tr>
					<tr class="disNone">
						<th>카테고리 이미지(PC)</th>
						<td>
							<input type='file' name='imgfiles' style='width:60%' class='input'>
						</td>
					</tr>
					<tr>
					<tr class="disNone">
						<th>카테고리 이미지(MOBILE)</th>
						<td>
							<input type='file' name='imgfiles' style='width:60%' class='input'>
						</td>
					</tr>
					<!-- <tr>
						<th>내용</th>
						<td>
							<textarea name='content' id='content' class='ckeditor'></textarea>
						</td>
					</tr>
					<tr>
						<th>상세설명</th>
						<td>
							<textarea name='detailcontent' id='detailcontent' class='ckeditor'><%=detailcontent%></textarea>
						</td>
					</tr>
					<tr>
						<th>기준이미지</th>
						<td>
							<input type='file' name='imgfiles' style='width:60%' class='input'>
						</td>
					</tr>
					<tr>
						<th>큰이미지</th>
						<td>
							<input type='file' name='imgfiles' style='width:60%' class='input'>
						</td>
					</tr>
					<tr>
						<th>PDF파일</th>
						<td>
							<input type='file' name='files' style='width:60%' class='input'>
						</td>
					</tr> -->
				</table>

				<div class="btn_center pt30">
					<a href="javascript:addCate()" class="btn_largeG">등록</a>
				</div>
				</form>


			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->

<SCRIPT LANGUAGE="JavaScript">
//CKEDITOR.replace( 'content', { height:250 } );
</SCRIPT>

<%PT_CateScript%>