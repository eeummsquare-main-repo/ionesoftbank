<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Idx=Request("idx")

Sql="select title,filenames,mfilenames,Bansort,langmode from categoryAdmin WHERE idx = "&Idx
Set Rs=Server.CreateObject("ADODB.RecordSet")
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=ReplaceTextField(Rs("title"))
	filenames=Rs("filenames")
	mfilenames=Rs("mfilenames")
	Bansort=Rs("Bansort")
	langmode=Rs("langmode")
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function infoModify(){
	f=document.categoryeditform;
	if(f.title.value==""){
		alert("타이틀을 입력하세요");
		f.title.focus();
		return;
	}
	if(uploadImg_check(f.files.value,"이미지를 올바로 입력하세요.",1)==false){
		return;
	}
	if(uploadImg_check(f.mfiles.value,"이미지를 올바로 입력하세요.",1)==false){
		return;
	}
	document.categoryeditform.submit();
}
//-->
</SCRIPT>

<div class="popWrap">
	<div class="popCon">
		<h1>게시물수정<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<form name='categoryeditform' method='post' ENCTYPE="multipart/form-data" action='categoryOk.asp'>
				<input type='hidden' name='sort' value='edit'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='Bansort' value='<%=Bansort%>'>

				<table class="tbl_col" style='width:800px'>
				<colgroup>
					<col width="25%" />
					<col width="" />
				</colgroup>
					<tr>
						<th>타이틀</th>
						<td class='left'><input type='text' name='title' style='width:95%;' class='input' maxlength='100' value='<%=Title%>'></td>
					</tr>
					<tr>
						<th>PC 이미지업로드</th>
						<td class='left'>
							<input type='file' name='files' style='width:50%;' class='input'>
							<% IF filenames<>"" Then %>
								<input type='button' value="이미지보기" class="btn_gray" style="width:80px" onclick="openWindow(100,100,'/_lib/imgview.asp?path=category&imgname=<%=filenames%>','imgView','yes')">
							<% End IF %>
							<input type='checkbox' name='filedelchk' value='1'> 파일수정여부
							<input type='hidden' name='filename' value='<%=filenames%>'>
						</td>
					</tr>
					<tr>
						<th>MOBILE 이미지업로드</th>
						<td class='left'>
							<input type='file' name='mfiles' style='width:50%;' class='input'>
							<% IF mfilenames<>"" Then %>
								<input type='button' value="이미지보기" class="btn_gray" style="width:80px" onclick="openWindow(100,100,'/_lib/imgview.asp?path=category&imgname=<%=mfilenames%>','imgView','yes')">
							<% End IF %>
							<input type='checkbox' name='mfiledelchk' value='1'> 파일수정여부
							<input type='hidden' name='mfilename' value='<%=mfilenames%>'>
						</td>
					</tr>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:infoModify()" class="btn_largeG">확인</a>
					<a href="javascript:fnLayerPopupClose()" class="btn_largeW">취소</a>
				</div>
			</div>
		</div>

	</div>
</div>