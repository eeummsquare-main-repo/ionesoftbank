<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "banner" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
langmode = uf_getRequest(Request("langmode"),"int","1","0")
bansort = uf_getRequest(Request("bansort"),"int","","0")

DBcon.Close
Set DBcon=Nothing
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function goAdd(){
	var date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/; 
	var f=document.mainbannerform;

	if(f.title.value==""){
		alert("배너명을 입력하세요");
		f.title.focus();
		return;
	}
	if (f.sDate){
		if (f.sDate.value!="" || f.eDate.value!=""){
			if(f.sDate.value==""){
				alert("노출기간을 입력하세요");
				f.sDate.focus();
				return;
			}
			if(f.eDate.value==""){
				alert("노출기간을 입력하세요");
				f.eDate.focus();
				return;
			}

			if (f.sDate.value!="" && !date_pattern.test(f.sDate.value)){
				alert("날짜 입력형식 오류! YYYY-MM-DD 형식으로 입력해주세요.")
				f.sDate.focus();
				return;
			}
			if (f.eDate.value!="" && !date_pattern.test(f.eDate.value)){
				alert("날짜 입력형식 오류! YYYY-MM-DD 형식으로 입력해주세요.")
				f.eDate.focus();
				return;
			}
		}
	}
	document.mainbannerform.submit();
}
//-->
</SCRIPT>

<div class="popWrap">
	<div class="popCon">
		<h1>게시물등록<a class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				
				<form name='mainbannerform' method='post' ENCTYPE="multipart/form-data" action='mainbannerOk.asp' onsubmit="goAdd(); return false;">
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='bansort' value='<%=bansort%>'>
				<table class="tbl_row box" style='width:800px'>
				<colgroup>
					<col width="17%" />
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
						<th scope="col">노출기간</th>
						<td class='left'>
							<div class="date_wrap">
								<input type="text" name="sDate" class="datepicker1" maxlength='10' placeholder="yyyy-mm-dd" />
								<select name="shour">
									<% getHour("") %>
								</select> : 
								<select name="sminute">
									<% getTime("") %>
								</select>
								~
								<input type="text" name="eDate" class="datepicker2" maxlength='10' placeholder="yyyy-mm-dd" />
								<select name="ehour">
									<% getHour("") %>
								</select> : 
								<select name="eminute">
									<% getTime("") %>
								</select>
							</div>
							<div class="imp mt10">시작일과 종료일을 입력하지 않으시면 상시노출됩니다.</div>
						</td>
					</tr>

					<tr>
						<th>타이틀</th>
						<td class='left'>
							<input type='text' name='title' class='input' maxlength='100' placeholder="">
							<% IF Bansort="0" Then %>
							<div class="colorWrap disNone">
								<div><b>글자색상</b><input type="text" name="titleColor" maxlength="7" class="color-picker" value="<%=titleColor%>"></div>
							</div>
							<% End IF %>
						</td>
					</tr>

					<% IF Bansort="1000" Then %>
					<tr>
						<th>타이틀 상단 캡션</th>
						<td class='left'>
							<input type='text' name='note1' class='input' maxlength='100' placeholder="">
							<div class="colorWrap disNone">
								<div><b>글자색상</b><input type="text" name="color1" maxlength="7" class="color-picker" value="<%=color1%>"></div>
							</div>
						</td>
					</tr>
					<tr class="">
						<th>타이틀 하단 캡션</th>
						<td class='left'>
							<input type='text' name='note2' class='input' maxlength='100' placeholder="">
							<div class="colorWrap disNone">
								<div><b>글자색상</b><input type="text" name="color2" maxlength="7" class="color-picker" value="<%=color2%>"></div>
							</div>
						</td>
					</tr>
					<tr class="disNone">
						<th>타이틀 하단 캡션</th>
						<td class='left'>
							<input type='text' name='note3' class='input' maxlength='100' placeholder="">
							<div class="colorWrap">
								<div><b>글자색상</b><input type="text" name="color3" maxlength="7" class="color-picker" value="<%=color3%>"></div>
							</div>
						</td>
					</tr>
					<% End IF %>
					
					<% IF Bansort="1" Then %>
					<tr>
						<th>내용</th>
						<td class='left'>
<textarea name="thumbContent" style="height:100px; tab-size:20px;"></textarea>
<div class="imp mt10">아래 내용을 복사하여 텍스트만 변경 하여 이용 해주세요. </div>
<fieldset>
<xmp style="tab-size:15px; font-size:12px; margin:0; border:1px solid #eee; padding:10px; line-height:14px;"><p class="ii cate">기업에 필요한 다양한 업무환경을 제공하는</p>
<p class="ii title">비즈니스 플랫폼 <br class="mb840" />‘Amaranth 10’</p>
<p class="ii text">
	고객의 지속가능한 성장을 돕는 혁신적인 기술력을 바탕으로 <br />
	ERP, 그룹웨어, 문서관리 솔루션을 통합한 올인원 비즈니스 플랫폼
</p>
</xmp>
</fieldset>
						</td>
					</tr>
					<tr>
						<th>링크주소1</th>
						<td class='left'>
							<input type='text' name='linkurlBtnNm' class='input' maxlength='50' style="width:20%" placeholder="링크 버튼명">
							<input type='text' name='linkurl' class='input' maxlength='2000' style="width:60%" placeholder="링크 URL">
							<p class="checkIn">
								<input type='checkbox' name='linkurlNewWin' id="linkurlNewWin" <%=iif_compare(linkurlNewWin, "1", "checked")%> value="1">
								<label class="labelTxt ml10 imp" for="linkurlNewWin">새창</label>
							</p>
						</td>
					</tr>
					<tr>
						<th>링크주소2</th>
						<td class='left'>
							<input type='text' name='linkurlBtnNm1' class='input' maxlength='50' style="width:20%" placeholder="링크 버튼명">
							<input type='text' name='linkurl1' class='input' maxlength='2000' style="width:60%" placeholder="링크 URL">
							<p class="checkIn">
								<input type='checkbox' name='linkurlNewWin1' id="linkurlNewWin1" <%=iif_compare(linkurlNewWin1, "1", "checked")%> value="1">
								<label class="labelTxt ml10 imp" for="linkurlNewWin1">새창</label>
							</p>
						</td>
					</tr>
					<% Else %>
					<tr>
						<th>링크주소</th>
						<td class='left'>
							<input type='text' name='linkurl' class='input' maxlength='2000' style="width:80%">
							<p class="checkIn">
								<input type='checkbox' name='linkurlNewWin' id="linkurlNewWin" <%=iif_compare(linkurlNewWin, "1", "checked")%> value="1">
								<label class="labelTxt ml10 imp" for="linkurlNewWin">새창</label>
							</p>
						</td>
					</tr>
					<% End IF %>

					<% IF Bansort="1000" Then %>
					<tr>
						<th>후원주소</th>
						<td class='left'>
							<input type='text' name='linkurl1' class='input' maxlength='2000' style="width:80%">
							<p class="checkIn">
								<input type='checkbox' name='linkurlNewWin1' id="linkurlNewWin1" <%=iif_compare(linkurlNewWin1, "1", "checked")%> value="1">
								<label class="labelTxt ml10 imp" for="linkurlNewWin1">새창</label>
							</p>
						</td>
					</tr>
					<% End IF %>

					<% IF Bansort<>"1" Then %>
					<tr>
						<th>이미지업로드<% IF Bansort="1000" Then %><br>(PC)<% End IF %></th>
						<td class='left'>
							<div class="filesArea">
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부"/></span>
									</span>
									<a class="thumb"></a>
									<input type='hidden' name='filedelchk' value='1'>
									<input type='hidden' name='filename' value=''>
								</div>
							</div>

							<% IF Bansort="0" Then %>
							<div class="imp mt10">이미지 최적사이즈 1920px * 120px</div>
							<% ElseIF Bansort="1" Then %>
							<div class="imp mt10">이미지 최적사이즈 1440px * 560px</div>
							<% ElseIF Bansort="2" Then %>
							<div class="imp mt10">이미지 최적사이즈 240px * 290px</div>
							<% ElseIF Bansort="3" OR Bansort="4" OR Bansort="5" Then %>
							<div class="imp mt10">이미지 최적사이즈 240px * 290px</div>
							<% End IF %>
						</td>
					</tr>
					<% End IF %>

					<% IF Bansort="1000" Then %>
					<tr>
						<th>이미지업로드<br>(MOBILE)</th>
						<td class='left'>
							<div class="filesArea">
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부"/></span>
									</span>
									<a class="thumb"></a>
									<input type='hidden' name='filedelchk' value='1'>
									<input type='hidden' name='filename' value=''>
								</div>
							</div>
							<% IF Bansort="0" Then %>
							<!-- <div class="imp mt10">이미지 최적사이즈 640px * 900px</div> -->
							<% ElseIF Bansort="1" Then %>
							<div class="imp mt10">이미지 최적사이즈 330px * 450px</div>
							<% ElseIF Bansort="2" Then %>
							<div class="imp mt10">이미지 최적사이즈 160px * 60px</div>
							<% ElseIF Bansort="3" Then %>
							<div class="imp mt10">이미지 최적사이즈 160px * 60px</div>
							<% End IF %>
						</td>
					</tr>
					<% End IF %>

					<% IF Bansort="1" Then %>
					<tr>
						<th>유튜브 URL</th>
						<td class='left'>
							<input type='text' name='vodlinkurl' class='input' maxlength='200' value='<%=vodlinkurl%>'>
						</td>
					</tr>
					<% End IF %>
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