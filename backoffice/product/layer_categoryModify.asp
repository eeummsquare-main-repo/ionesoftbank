<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Idx=Request("idx")

Sql="SELECT langmode, name, lowcode, middlecode, topcode, images, rollimages, pdffilename, content, detailcontent, linkurl, barimages, isdisplay, nameSub, mbTitle, mbCaption FROM CATEGORY WHERE lowcode='"&idx&"'"

Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	langmode = Rs("langmode")
	name = Rs("name")
	nameSub = Rs("nameSub")
	lowcode = Rs("lowcode")
	middlecode = Rs("middlecode")
	topcode = Rs("topcode")
	images = Rs("images")
	rollimages = Rs("rollimages")
	barimages = Rs("barimages")
	content = Rs("content")
	detailcontent=ReplaceNoHtml(Rs("detailcontent"))
	linkurl = ReplaceTextfield(Rs("linkurl"))
	isdisplay = Rs("isdisplay")
	mbTitle = changeBlank(Rs("mbTitle"))
	mbCaption = changeBlank(Rs("mbCaption"))

	IF lowcode=topcode Then
		Sort=1
	ElseIf topcode=middlecode AND lowcode<>topcode Then
		Sort=2
	Else
		Sort=3
	End IF
End IF
Set Rs=Nothing

DBcon.Close
Set DBcon=Nothing
%>

<script type="text/javascript">
<!--
$(document).ready(function() {

});

function revModify(){
	var f = document.resFrm

	if(f.cateform==""){
		alert("카테고리명을 입력해주세요.");
		f.catename.focus();
		return;
	}
	/*if (f.imgDel_Chk.checked){
		if(uploadImg_check(f.imgfiles.value,"이미지를 올바로 입력하세요.",1)==false){
			f.imgfiles.focus()
			return;
		}
	}*/
	var val = confirm("카테고리 정보를 수정합니다.\n수정하시겠습니까?");
	if (val){
		f.submit();
	}
}
//-->
</script>

<div class="popWrap">
	<div class="popCon">
		<h1>제품카테고리 수정<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<form name="resFrm" id="resFrm" method="post" ENCTYPE="multipart/form-data" target="actFrame" action="category_add.asp" onsubmit="revModify();return false;">
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='catecode' value='<%=Idx%>'>
				<input type='hidden' name='middlecode' value='<%=middlecode%>'>
				<input type='hidden' name='topcode' value='<%=topcode%>'>
				<input type='hidden' name='regsort' value='<%=Sort%>'>
				<input type='hidden' name='mode' value='edit'>
				<table class="tbl_row box" style='width:1000px;'>
					<colgroup>
						<col width="20%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>공개여부</th>
						<td>
							<input type="radio" name='isdisplay' id="m_isdisplay1" value="1" checked><label for="m_isdisplay1" style="margin-right:10px;">공개</label>
							<input type="radio" name='isdisplay' id="m_isdisplay2" value="0" <%=ChangeChecked(isdisplay,0)%>><label for="m_isdisplay2">비공개</label>
						</td>
					</tr>
					<tr>
						<th>카테고리명</th>
						<td><input type='text' name='catename' size='80' maxlength='50' class='input' value="<%=name%>"></td>
					</tr>
					<tr class="disNone">
						<th>서브 카테고리명</th>
						<td><input type='text' name='catenameSub' size='80' maxlength='100' class='input' value="<%=nameSub%>"></td>
					</tr>
					
					<tr class="disNone">
						<th>카테고리 이미지</th>
						<td>
							<input type='file' name='imgfiles' style='width:40%' class='input fileField'>
							<input type='hidden' name='imgname' value="<%=barimages%>">

							<% IF barimages<>"" Then %>
							<a href='javascript:openWindow(100,100,"/_lib/imgview.asp?path=category&imgname=<%=barimages%>","imgView","yes")' class="btn_gray">VIEW</a>&nbsp;
							<label><input type='checkbox' name='imgDel_Chk' class="fileFieldChk"> 삭제</label>
							<% Else %>
							<input type="hidden" name="imgDel_Chk" value="1">
							<% End IF %>
						</td>
					</tr>

					<tr class="disNone">
						<th>메인 BEST상품 캡션</th>
						<td>
							<div><input type='text' name='mbTitle' maxlength='50' class='input' value="<%=mbTitle%>" placeholder="진열코너 타이틀을 입력해주세요."></div>
							<div class="mt5"><input type='text' name='mbCaption' maxlength='100' class='input' value="<%=mbCaption%>" placeholder="진열코너 설명을 입력해주세요."></div>
							<div class="imp mt5">
								메인에 노출되는 진열코너의 타이틀 및 설명글을 설정할수 있습니다.<br>
								타이틀 미입력시 카테고리명이 노출됩니다.
							</div>
						</td>
					</tr>

					<tr class="disNone">
						<th>카테고리 이미지(MOBILE)</th>
						<td>
							<input type='file' name='imgfiles' style='width:40%' class='input fileField'>
							<input type='hidden' name='imgname1' value="<%=rollimages%>">

							<% IF rollimages<>"" Then %>
							<a href='javascript:openWindow(100,100,"/_lib/imgview.asp?path=category&imgname=<%=rollimages%>","imgView","yes")' class="btn_gray">VIEW</a>&nbsp;
							<label><input type='checkbox' name='imgDel_Chk1' class="fileFieldChk"> 삭제</label>
							<% Else %>
							<input type="hidden" name="imgDel_Chk1" value="1">
							<% End IF %>
						</td>
					</tr>
					<!-- <tr>
						<td colspan='2'>
							<textarea name='content' id="editcontent" style='width:98%; word-break:break-all; height:300px;'><%=Content%></textarea>
						</td>
					</tr>
					<tr>
						<th>링크URL</th>
						<td>
							<input type='text' name='linkurl' maxlength="100" style='width:60%' class='input' value="<%=linkurl%>">
						</td>
					</tr> -->

					<!--
					<tr>
						<th>큰이미지</th>
						<td>
							<input type='file' name='imgfiles' style='width:40%' class='input'>
							<input type='hidden' name='imgname1' value="<%=rollimages%>">
							<input type='checkbox' name='imgDel_Chk1'> 파일변경여부
							<% IF rollimages<>"" Then %>
							<a href='javascript:openWindow(100,100,"/_lib/imgview.asp?path=category&imgname=<%=rollimages%>","imgView","yes")'><img src='/backoffice/images/bt_view.gif' border='0' align='absmiddle'></a>
							<% End IF %>
						</td>
					</tr>
					<tr>
						<th>PDF파일</th>
						<td>
							<input type='file' name='files' style='width:40%' class='input'>
							<input type='hidden' name='filename' value="<%=pdfFilename%>">
							<input type='checkbox' name='fileDel_Chk'> 파일변경여부
							<% IF pdfFilename<>"" Then %>
							<a href='/_lib/download.asp?downfile=<%=pdfFilename%>&path=category'><img src='/backoffice/images/bt_download.gif' border='0' align='absmiddle'></a>
							<% End IF %>
						</td>
					</tr> -->
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:revModify()" class="btn_largeG">확인</a>
					<a href="javascript:fnLayerPopupClose()" class="btn_largeW">취소</a>
				</div>
			</div>
		</div>

	</div>
</div>