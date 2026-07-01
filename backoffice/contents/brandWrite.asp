<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "brand" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
langmode = uf_getRequest(Request("langmode"),"int","","1")
bansort = uf_getRequest(Request("bansort"),"int","","1")

DBcon.Close
Set DBcon=Nothing
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function goAdd(){
	f=document.brandform;
	if(f.title.value==""){
		alert("브랜드명을 입력하세요");
		f.title.focus();
		return;
	}
	if(f.files){
		if(uploadImg_check(f.files.value,"이미지를 업로드 해주세요.",1)==false){
			return;
		}
	}
	if(f.files1){
		if(uploadImg_check(f.files1.value,"이미지를 업로드 해주세요.",1)==false){
			return;
		}
	}

	document.brandform.submit();
}
//-->
</SCRIPT>

<div class="popWrap">
	<div class="popCon">
		<h1>게시물등록<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				
				<form name='brandform' method='post' ENCTYPE="multipart/form-data" action='brandOk.asp' onsubmit="goAdd(); return false;">
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='bansort' value='<%=bansort%>'>
				<table class="tbl_col box" style='width:800px'>
				<colgroup>
					<col width="25%" />
					<col width="" />
				</colgroup>
					<tr><th colspan='2'>게시물 추가</th></tr>
					<tr>
						<th scope="col">노출상태</th>
						<td class='left'>
							<label><input type="radio" name="isDisplay" value="1" checked> 노출</label>
							<label><input type="radio" name="isDisplay" value="0" > 비노출</label>
						</td>
					</tr>
					<tr>
						<th>브랜드명</th>
						<td class='left'><input type='text' name='title' class='input' maxlength='100' placeholder=""></td>
					</tr>
					<!-- <tr>
						<th>간략설명</th>
						<td class='left'><input type='text' name='note1' class='input' maxlength='100' value='<%=note1%>'></td>
					</tr> -->
					<tr>
						<th>로고</th>
						<td class='left'>
							<input type='file' name='files' style='width:100%;' class='input'>
							<div style="padding-top:10px; color: #b50000;">*이미지 최대 크기는 3MB입니다. jpg,gif,png 파일로 업로드 바랍니다.</div>
						</td>
					</tr>
					<tr>
						<th>상단 카테고리 로고</th>
						<td class='left'>
							<input type='file' name='files1' style='width:100%;' class='input'>
							<div style="padding-top:10px; color: #b50000;">*이미지 최대 크기는 3MB입니다. jpg,gif,png 파일로 업로드 바랍니다.</div>
						</td>
					</tr>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:goAdd()" class="btn_largeG">확인</a>
					<a href="javascript:fnLayerPopupClose()" class="btn_largeW">취소</a>
				</div>
			</div>
		</div>

	</div>
</div>