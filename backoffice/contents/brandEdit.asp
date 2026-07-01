<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "brand" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Idx=Request("idx")

Sql="select title,filenames,Bansort,langmode,isdisplay,topicon,note1 from brandAdmin WHERE idx = "&Idx
Set Rs=Server.CreateObject("ADODB.RecordSet")
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=ReplaceTextField(Rs("title"))
	filenames=Rs("filenames")
	Bansort=CINT(Rs("Bansort"))
	langmode=Rs("langmode")
	isdisplay=ReplaceTextField(Rs("isdisplay"))
	topicon=Rs("topicon")
	note1=ReplaceTextField(Rs("note1"))
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function infoModify(){
	f=document.brandeditform;
	if(f.title.value==""){
		alert("브랜드명을 입력하세요");
		f.title.focus();
		return;
	}
	if(f.files){
		if(f.filedelchk.checked){
			if(uploadImg_check(f.files.value,"이미지를 업로드 해주세요.",1)==false){
				return;
			}
		}
	}
	if(f.files1){
		if(f.dfiledelchk.checked){
			if(uploadImg_check(f.files1.value,"이미지를 업로드 해주세요.",1)==false){
				return;
			}
		}
	}
	document.brandeditform.submit();
}
//-->
</SCRIPT>

<div class="popWrap">
	<div class="popCon">
		<h1>게시물수정<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<form name='brandeditform' method='post' ENCTYPE="multipart/form-data" action='brandOk.asp'>
				<input type='hidden' name='sort' value='edit'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='Bansort' value='<%=Bansort%>'>

				<table class="tbl_col box" style='width:800px'>
				<colgroup>
					<col width="25%" />
					<col width="" />
				</colgroup>
					<tr>
						<th scope="col">노출상태</th>
						<td class='left'>
							<label><input type="radio" name="isDisplay" value="1" checked> 노출</label>
							<label><input type="radio" name="isDisplay" value="0" <%=iif_compare(isdisplay,0,"checked")%>> 비노출</label>
						</td>
					</tr>
					<tr>
						<th>브랜드명</th>
						<td class='left'><input type='text' name='title' class='input' maxlength='100' value='<%=Title%>'></td>
					</tr>
					<!-- <tr>
						<th>간략설명</th>
						<td class='left'><input type='text' name='note1' class='input' maxlength='100' value='<%=note1%>'></td>
					</tr> -->
					<tr>
						<th>로고</th>
						<td class='left'>
							<div class="file fileArea">
								<% IF filenames<>"" Then %>
								<div style='float:left; padding-right:10px;'>
									<img src='/upload/brand/<%=filenames%>' width="<%=imgsize("brand",120,filenames)%>" style='cursor:pointer;' onclick='openWindow(100,100,"/_lib/imgview.asp?path=brand&imgname=<%=filenames%>","imgView","yes")'>
								</div>
								<div style='padding-bottom:5px;'>
									<label><input type='checkbox' name='filedelchk' class="fileFieldChk" value='1'> 파일삭제</label>
									<input type='hidden' name='filename' value='<%=filenames%>'>
								</div>
								<% Else %>
								<input type='hidden' name='filedelchk' value='1'>
								<% End IF %>
								<input type='file' name='files' class='fileField'>
								<div style="padding-top:20px; color: #b50000;">*이미지 최대 크기는 3MB입니다. jpg,gif,png 파일로 업로드 바랍니다.</div>
							</div>
						</td>
					</tr>

					<tr>
						<th>상단 카테고리 로고</th>
						<td class='left'>
							<div class="file fileArea">
								<% IF topicon<>"" Then %>
								<div style='float:left; padding-right:10px;'>
									<img src='/upload/brand/<%=topicon%>' width="<%=imgsize("brand",120,topicon)%>" style='cursor:pointer;' onclick='openWindow(100,100,"/_lib/imgview.asp?path=brand&imgname=<%=topicon%>","imgView","yes")'>
								</div>
								<div style='padding-bottom:5px;'>
									<label><input type='checkbox' name='dfiledelchk' class="fileFieldChk" value='1'> 파일삭제</label>
									<input type='hidden' name='dfilename' value='<%=topicon%>'>
								</div>
								<% Else %>
								<input type='hidden' name='dfiledelchk' value='1'>
								<% End IF %>
								<input type='file' name='files1' class='fileField'>
								<div style="padding-top:20px; color: #b50000;">*이미지 최대 크기는 3MB입니다. jpg,gif,png 파일로 업로드 바랍니다.</div>
							</div>
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