<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "banner" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Idx=Request("idx")

Sql="select title,filenames, filenames1,linkurl,linkurlNewWin,linkurl1,linkurlNewWin1,Bansort,langmode,sDate,eDate,isDisplay,note1,note2,note3,vodlinkurl,filevodlinkurl,thumbContent, titleColor, color1, color2, color3, color4, bgColor, linkurlBtnNm, linkurlBtnNm1 from mainbannerAdmin WHERE idx = "&Idx
Set Rs=Server.CreateObject("ADODB.RecordSet")
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=ReplaceTextField(Rs("title"))
	filenames=Rs("filenames")
	filenames1=Rs("filenames1")
	linkurl=ReplaceTextField(Rs("linkurl"))
	linkurlNewWin=Rs("linkurlNewWin")
	linkurl1=ReplaceTextField(Rs("linkurl1"))
	linkurlNewWin1=Rs("linkurlNewWin1")
	linkurlBtnNm=ReplaceTextField(Rs("linkurlBtnNm"))
	linkurlBtnNm1=ReplaceTextField(Rs("linkurlBtnNm1"))
	
	Bansort=Rs("Bansort")
	langmode=Rs("langmode")
	sDate=ReplaceTextField(Rs("sDate"))
	eDate=ReplaceTextField(Rs("eDate"))
	isDisplay = Rs("isDisplay")

	note1=ReplaceTextField(Rs("note1"))
	note2=ReplaceTextField(Rs("note2"))
	note3=ReplaceTextField(Rs("note3"))

	thumbContent=Rs("thumbContent")
	vodlinkurl=ReplaceTextField(Rs("vodlinkurl"))
	filevodlinkurl=ReplaceTextField(Rs("filevodlinkurl"))

	titleColor = Rs("titleColor")
	color1 = Rs("color1")
	color2 = Rs("color2")
	color3 = Rs("color3")
	color4 = Rs("color4")
	bgColor = Rs("bgColor")
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function infoModify(){
	var date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/; 
	var f=document.mainbannereditform;

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
	document.mainbannereditform.submit();
}
//-->
</SCRIPT>

<div class="popWrap">
	<div class="popCon">
		<h1>게시물수정<a class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<form name='mainbannereditform' method='post' ENCTYPE="multipart/form-data" action='mainbannerOk.asp'>
				<input type='hidden' name='sort' value='edit'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<input type='hidden' name='Bansort' value='<%=Bansort%>'>

				<table class="tbl_row box" style='width:800px'>
				<colgroup>
					<col width="17%" />
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
						<th scope="col">노출기간</th>
						<td class='left'>
							<div class="date_wrap">
								<input type="text" name="sDate" class="datepicker1" maxlength='10' value="<%=Replace(Left(sDate,4) & "-" & Mid(sDate,5,2) & "-" & Mid(sDate,7,2), "--", "")%>" placeholder="yyyy-mm-dd" />
								<select name="shour">
									<% getHour(Mid(sDate,9,2)) %>
								</select>
								<select name="sminute">
									<% getTime(Right(sDate,2)) %>
								</select>
								~
								<input type="text" name="eDate" class="datepicker2" maxlength='10' value="<%=Replace(Left(eDate,4) & "-" & Mid(eDate,5,2) & "-" & Mid(eDate,7,2), "--", "")%>" placeholder="yyyy-mm-dd" />
								<select name="ehour">
									<% getHour(Mid(eDate,9,2)) %>
								</select>
								<select name="eminute">
									<% getTime(Right(eDate,2)) %>
								</select>
							</div>
							<div style="padding-top:10px; color: #b50000;">시작일과 종료일을 입력하지 않으시면 상시노출됩니다.</div>
						</td>
					</tr>

					<tr>
						<th>타이틀</th>
						<td class='left'>
							<input type='text' name='title' class='input' maxlength='100' value='<%=Title%>'>
							<% IF Bansort="0" Then %>
							<div class="colorWrap disNone">
								<div><b>글자색상</b><input type="text" name="titleColor" maxlength="7" class="color-picker" value="<%=ReplaceTextField(titleColor)%>"></div>
							</div>
							<% End IF %>
						</td>
					</tr>
					<% IF Bansort="1000" Then %>
					<tr>
						<th>타이틀 하단 캡션</th>
						<td class='left'>
							<input type='text' name='note1' class='input' maxlength='100' placeholder="" value="<%=Note1%>">
							<div class="colorWrap disNone">
								<div><b>글자색상</b><input type="text" name="color1" maxlength="7" class="color-picker" value="<%=color1%>"></div>
							</div>
						</td>
					</tr>
					<tr class="disNone">
						<th>타이틀 상단 캡션</th>
						<td class='left'>
							<input type='text' name='note2' class='input' maxlength='100' placeholder="" value="<%=Note2%>">
							<div class="colorWrap">
								<div><b>글자색상</b><input type="text" name="color2" maxlength="7" class="color-picker" value="<%=color2%>"></div>
							</div>
						</td>
					</tr>
					<tr class="disNone">
						<th>타이틀 하단 캡션</th>
						<td class='left'>
							<input type='text' name='note3' class='input' maxlength='100' placeholder="" value="<%=Note3%>">
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
							<textarea name="thumbContent" style="height:100px; tab-size:20px;"><%=thumbContent%></textarea>

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
							<input type='text' name='linkurlBtnNm' class='input' maxlength='50' style="width:20%" placeholder="링크 버튼명" value="<%=linkurlBtnNm%>">
							<input type='text' name='linkurl' class='input' maxlength='2000' style="width:60%" placeholder="링크 URL" value="<%=linkurl%>">
							<p class="checkIn">
								<input type='checkbox' name='linkurlNewWin' id="linkurlNewWin" <%=iif_compare(linkurlNewWin, "1", "checked")%> value="1">
								<label class="labelTxt ml10 imp" for="linkurlNewWin">새창</label>
							</p>
						</td>
					</tr>
					<tr>
						<th>링크주소2</th>
						<td class='left'>
							<input type='text' name='linkurlBtnNm1' class='input' maxlength='50' style="width:20%" placeholder="링크 버튼명" value="<%=linkurlBtnNm1%>">
							<input type='text' name='linkurl1' class='input' maxlength='2000' style="width:60%" placeholder="링크 URL" value="<%=linkurl1%>">
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
							<input type='text' name='linkurl1' class='input' maxlength='2000' style="width:80%" value='<%=linkurl1%>'>
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
							<% IF filenames<>"" Then %>
								<div class="file fileArea">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부" class='fileField'/></span>
									</span>
									<a class="thumb"></a>
									<p class="checkIn">
										<input type='checkbox' name='delchk' value='1' id="filedelchk1" dataVal="1" class="fileFieldChk">
										<label class="labelTxt ml10" for="filedelchk1">삭제</label>
										<input type='hidden' name='filedelchk' value='0' class="fileDelidx">
										<input type='hidden' name='filename' value='<%=filenames%>'>
									</p>
									<%=PT_FileThumbImgTag(filenames, "mainbanner")%>
									<span class="fDBArea">첨부파일 (<a href="/_lib/download.asp?path=mainbanner&downfile=<%=filenames%>" class="ellipsis"><%=ReplaceNoHtml(filenames)%></a>)</span>
								</div>
							<% Else %>
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부"/></span>
									</span>
									<a class="thumb"></a>
									<input type='hidden' name='filedelchk' value='1'>
									<input type='hidden' name='filename' value=''>
								</div>
							<% End IF %>
							</div>
						</td>
					</tr>
					<% End IF %>

					<% IF Bansort="1000" Then %>
					<tr>
						<th>이미지업로드<br>(MOBILE)</th>
						<td class='left'>
							<div class="filesArea">
							<% IF filenames1<>"" Then %>
								<div class="file fileArea">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부" class='fileField'/></span>
									</span>
									<a class="thumb"></a>
									<p class="checkIn">
										<input type='checkbox' name='delchk' value='1' id="filedelchk2" dataVal="1" class="fileFieldChk">
										<label class="labelTxt ml10" for="filedelchk2">삭제</label>
										<input type='hidden' name='filedelchk' value='0' class="fileDelidx">
										<input type='hidden' name='filename' value='<%=filenames1%>'>
									</p>
									<%=PT_FileThumbImgTag(filenames1, "mainbanner")%>
									<span class="fDBArea">첨부파일 (<a href="/_lib/download.asp?path=mainbanner&downfile=<%=filenames1%>" class="ellipsis"><%=ReplaceNoHtml(filenames1)%></a>)</span>
								</div>
							<% Else %>
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부"/></span>
									</span>
									<a class="thumb"></a>
									<input type='hidden' name='filedelchk' value='1'>
									<input type='hidden' name='filename' value=''>
								</div>
							<% End IF %>
							</div>
						</td>
					</tr>
					<% End IF %>

					<% IF Bansort="1" Then %>
					<tr>
						<th>동영상 URL</th>
						<td class='left'>
							<input type='text' name='vodlinkurl' class='input' maxlength='200' value='<%=vodlinkurl%>'>
						</td>
					</tr>
					<tr class="disNone">
						<th>동영상 파일 URL</th>
						<td class='left'>
							<input type='text' name='filevodlinkurl' style='width:95%;' class='input' maxlength='200' value='<%=filevodlinkurl%>'>
						</td>
					</tr>
					<% End IF %>
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