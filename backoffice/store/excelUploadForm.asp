<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub08" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
DBcon.Close
Set DBcon=Nothing
%>

<script type="text/javascript">
<!--
function uploadImg_check( value,msg,sort ){
	var src = getFileExtension(value);

	if(sort==1 && value==""){return true;}
	if ( src == ""){
		alert(msg);
		return false;
	} else if ( !((src.toLowerCase() == "xls")) ) {
		alert('xls 파일만 업로드 하실 수 있습니다.');
		return false;
	}else{return true;}
}

function uploadOK(){
	var f = document.excelUploadFrm;

	if(uploadImg_check(f.files.value,"엑셀파일을 업로드 해주세요.",0)==false){
		f.files.focus();
		return;
	}
	f.submit();
}
//-->
</script>

<div class="popWrap">
	<div class="popCon">
		<h1>엑셀 일괄 업로드<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<form name="excelUploadFrm" id="excelUploadFrm" method="post" action="excelUploadFormOK.asp" onsubmit="uploadOK(); return false;" enctype="multipart/form-data" target="actFrame">
				<div style='font-size:12px; margin-bottom:10px; line-height:18px;'>
					업로드한 엑셀파일 데이터를 일괄 등록합니다.<br/>
					<span style='color:red'>데이터가 정확하지 않으면 업로드가 되지않습니다.</span><br/>
					반드시 지정된 엑셀파일을 업로드 해주세요. (아래 엑셀다운 파일 참고)

					<div style='padding-top:10px; color: #000; text-decoration:underline;'>엑셀파일 업로드 시 준수사항</div>
					<div>엑셀 시트명 : Sheet1</div>
				</div>
				<table class="tbl_row" style='width:700px'>
					<colgroup>
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th colspan="2" style='font-weight:normal; text-align:right;'><a href="/upload/excel/exExcel.xls" style='color: #287eff'>예제엑셀파일 다운로드</a></th>
					</tr>
					<tr>
						<th>업로드파일</th>
						<td>
							<input name="files" type="file" class="input" style='width:100%;'>
						</td>
					</tr>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:uploadOK()" class="btn_largeG">확인</a>
					<a href="javascript:fnLayerPopupClose()" class="btn_largeW">취소</a>
				</div>
			</div>
		</div>

	</div>
</div>