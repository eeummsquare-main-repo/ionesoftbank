<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "pageSeo" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim SpItemCnt
idx = uf_getRequest(Request("idx"),"int","5","0")

Sql = "SELECT idx, regDiv, seoTitle, seoDescription, seoKeywords, seoFile, seoSubject, seoAuthor, seoCopyright, seoNaverKey FROM seoData Where idx="&idx
Set Rs = Dbcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	regDiv = changeBlank(Rs("regDiv"))
	seoTitle = changeBlank(Rs("seoTitle"))
	seoDescription = changeBlank(Rs("seoDescription"))
	seoKeywords = changeBlank(Rs("seoKeywords"))
	seoFile = changeBlank(Rs("seoFile"))

	seoSubject = changeBlank(Rs("seoSubject"))
	seoAuthor = changeBlank(Rs("seoAuthor"))
	seoCopyright = changeBlank(Rs("seoCopyright"))
	seoNaverKey = changeBlank(Rs("seoNaverKey"))
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
function sendit(){
	var form=document.regFrm;
	var date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/; 
	var requiredFlag = true;
	var itemTitle = "";

	$('.reqField').each(function(){
		itemTitle = $(this).attr("reqTitle")

		if ( $(this).is(':text, textarea, select') && $(this).val().length < 1 ) {
			alert('['+itemTitle+']는 필수 입력항목 입니다.');
			$(this).focus();
			requiredFlag = false;
			return false;
		}else if ( $(this).is(':checkbox') ) {
			attrName = $(this).attr("name")

			if(!$("input:checkbox[name="+attrName+"]").is(":checked") == true) {
				alert('['+itemTitle+']는 필수 선택항목 입니다.');
				$(this).focus();
				requiredFlag = false;
				return false;
			}
		}else if ( $(this).is(':radio') ) {
			attrName = $(this).attr("name")

			if(!$("input:radio[name="+attrName+"]").is(":checked") == true) {
				alert('['+itemTitle+']는 필수 선택항목 입니다.');
				$(this).focus();
				requiredFlag = false;
				return false;
			}
		};
	});
	if( requiredFlag == true ) {
		if (confirm('저장하시겠습니까?')){
			document.regFrm.submit();
		}
	}
}
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

				<div style='clear:both;'>
					<select name='idx' style='width:100%; background-Color: #B0CEFF; font-size:14px;' onchange="location.href='?idx='+this.value;">
						<option value='0' <%=SelCheck(0,idx)%>>기본 SEO</option>
						<option value='1' <%=SelCheck(1,idx)%>>메인</option>
						<option value='2' <%=SelCheck(2,idx)%>>후원</option>
						<option value='3' <%=SelCheck(3,idx)%>>사업</option>
						<option value='4' <%=SelCheck(4,idx)%>>소식</option>
						<option value='5' <%=SelCheck(5,idx)%>>법인</option>
					</select>
				</div>

				<div class="subTitle">
					Meta Tag
					<% IF CStr(idx)="0" Then %>
					<span style='font-weight:normal; font-size:12px; color: #d50000'>(SEO 기본정보입니다. 페이지별 SEO 정보가 없거나 비어있을 경우 해당 정보로 노출됩니다.)</span>
					<% End IF %>
				</div>
				<form action="proc.asp" method="post" name="regFrm" enctype="multipart/form-data" target="actFrame">
				<input type='hidden' name='idx' value='<%=idx%>'>
				<table class="tbl_row box">
					<colgroup>
						<col width="12%" />
						<col width="38%" />
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>Title</th>
						<td colspan='3'><input type='text' name='seoTitle' maxlength='200' class='input' Value='<%=ReplaceTextField(seoTitle)%>'></td>
					</tr>

<tr>
	<th>Subject</th>
	<td colspan='3'><input type='text' name='seoSubject' maxlength='200' class='input' Value='<%=ReplaceTextField(seoSubject)%>'></td>
</tr>

					<tr>
						<th>Keywords</th>
						<td colspan='3'><input type='text' name='seoKeywords' maxlength='200' class='input' Value='<%=ReplaceTextField(seoKeywords)%>'></td>
					</tr>
					<tr>
						<th>Description</th>
						<td colspan='3'><input type='text' name='seoDescription' maxlength='200' class='input' Value='<%=ReplaceTextField(seoDescription)%>'></td>
					</tr>
<tr>
	<th>Author</th>
	<td colspan='3'><input type='text' name='seoAuthor' maxlength='200' class='input' Value='<%=ReplaceTextField(seoAuthor)%>'></td>
</tr>
<tr>
	<th>Copyright</th>
	<td colspan='3'><input type='text' name='seoCopyright' maxlength='200' class='input' Value='<%=ReplaceTextField(seoCopyright)%>'></td>
</tr>
<tr>
	<th>네이버 사이트등록 Key</th>
	<td colspan='3'><input type='text' name='seoNaverKey' maxlength='2000' class='input' Value='<%=ReplaceTextField(seoNaverKey)%>'></td>
</tr>
					<tr>
						<th>Image</th>
						<td colspan='3'>
							<div class="file">
								<input type='file' name='seoFiles' class='input fileField'>

								<input type='hidden' name='seoFileNm' value="<%=seoFile%>">
								<% IF seoFile<>"" Then %>
								<a href='javascript:openWindow(100,100,"/_lib/imgview.asp?path=seo&imgname=<%=seoFile%>","imgView","yes")' class="btn_gray">VIEW</a>&nbsp;
								<p class="checkIn">
									<input type='checkbox' name='seoimgDel_Chk' value='1' id="seoimgDel_Chk" class="fileFieldChk">
									<label class="labelTxt ml10" for="seoimgDel_Chk">삭제</label>
								</p>
								<% Else %>
								<input type="hidden" name="seoimgDel_Chk" value="1">
								<% End IF %>
							</div>
						</td>
					</tr>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit();" class="btn_largeG">저장하기</a>
				</div>


			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->