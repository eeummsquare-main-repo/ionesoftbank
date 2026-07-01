<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub08" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

seritem = uf_getRequest(Request("seritem"),"int","","0")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "list.asp"
PageStr = "seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

Idx = uf_getRequest(Request("idx"),"int","","")

IF Idx<>"" Then
	Sql="SELECT isDisplay, regdate, reguseridx, regUserName, listnum, title, tel, owner, addr1, addr2, addr1_ji, addr2_ji, note1, note2, note3, note4, zipcode, imgnames1, linkUrl FROM storeAdmin WHERE idx="&idx

	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		isDisplay = Rs("isDisplay")
		regdate = Rs("regdate")
		reguseridx = Rs("reguseridx")
		regUserName = Rs("regUserName")
		listnum = Rs("listnum")
		title = Rs("title")

		tel = Rs("tel")
		owner = Rs("owner")
		addr1 = Rs("addr1")
		addr2 = Rs("addr2")
		addr1_ji = Rs("addr1_ji")
		addr2_ji = Rs("addr2_ji")
		note1 = Rs("note1")
		note2 = Rs("note2")
		note3 = Rs("note3")
		note4 = Rs("note4")
		zipcode = Rs("zipcode")
		imgnames1 = Rs("imgnames1")
		linkUrl = Rs("linkUrl")
	End IF
	Set Rs = Nothing
End IF

DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
	var isBreak = false
	var f = document.boardform

	if(f.title.value==""){
		alert("We대한가게명을 입력하세요.");
		f.title.focus();
		return;
	}
	if(f.addr1.value==""){
		alert("도로명 주소를 입력하세요.");
		f.addr1.focus();
		return;
	}
	f.submit();
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
					<h2 class="top_left"><%=GB_SubMenuName%><!-- (<%=langTitle%>)--></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<form name="boardform" action="writeProc.asp" method="post" ENCTYPE="multipart/form-data">
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='seritem' value='<%=ReplaceTextField(seritem)%>'>
				<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<table class="tbl_row box">
					<colgroup>
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<% IF idx<>"" Then %>
					<tr>
						<th>등록정보</th>
						<td><%=regUserName%> / <%=Regdate%></td>
					</tr>
					<% End IF %>

					<tr>
						<th>노출상태</th>
						<td>
							<select name="isDisplay">
								<option value="1" selected>노출</option>
								<option value="0" <%=selCheck(isDisplay,0)%>>비노출</option>
							</select>

							노출순서 : <input type='text' name="listnum" class="onlyNumber" maxlength="4" style='width:100px;' Value='<%=listnum%>'>
						</td>
					</tr>
					<tr>
						<th>We대한가게명</th>
						<td>
							<input type='text' name='title' maxlength='100' class='input' Value='<%=ReplaceTextField(title)%>'>
						</td>
					</tr>
					<tr>
						<th>연락처</th>
						<td>
							<input type='text' name='tel' maxlength='100' class='input' Value='<%=ReplaceTextField(tel)%>'>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td class="left">
							<input id="zipcode" name="zipcode" maxlength="7" readonly type="text" maxlength='7' style="width:100px;" value="<%=zipcode%>" />
							<input type='button' value="우편번호찾기" class="btn_gray" style="width:100px" onclick="getAddrs()">
							<p style='margin-top:5px'>
								<span style='display:inline-block; width:105px; text-align:center;'>도로명주소</span>
								<input type="text" name="addr1" id="addr1" maxlength="100" size="50" value="<%=addr1%>" placeholder="도로명주소" style='width:500px'/>&nbsp;
								<input type="text" name="addr2" id="addr2" maxlength="100" size="50" value="<%=addr2%>" placeholder="상세주소" style='width:480px' />
							</p>
							<p style='margin-top:5px'>
								<span style='display:inline-block; width:105px; text-align:center;'>지번주소</span>
								<input type="text" name="addr1_ji" id="addr1_ji" maxlength="100" size="50" value="<%=addr1_ji%>" placeholder="지번주소" style='width:500px'/>&nbsp;
								<input type="text" name="addr2_ji" id="addr2_ji" maxlength="100" size="50" value="<%=addr2_ji%>" placeholder="상세주소" style='width:480px' />
							</p>
						</td>
					</tr>
					<tr>
						<th>업종</th>
						<td>
							<input type='text' name='note1' maxlength='100' class='input' Value='<%=ReplaceTextField(note1)%>'>
						</td>
					</tr>
					<tr>
						<th>지역</th>
						<td>
							<input type='text' name='note2' maxlength='100' class='input' Value='<%=ReplaceTextField(note2)%>'>
						</td>
					</tr>
					<tr class="disNone">
						<th>홈페이지URL</th>
						<td>
							<input type='text' name='linkurl' maxlength='1000' class='input' Value='<%=ReplaceTextField(linkurl)%>' placeholder="http:// 포함하여 입력">
						</td>
					</tr>
					<tr class="disNone">
						<th>매장사진</th>
						<td>
							<input type='file' name='imgfiles' style='width:40%' class='input fileField'>
							<% IF idx<>"" Then %>
								<input type='hidden' name='imgnames1' value="<%=imgnames1%>">
								<% IF imgnames1<>"" Then %>
								<a href='javascript:openWindow(100,100,"/_lib/imgview.asp?path=menu&imgname=<%=imgnames1%>","imgView","yes")' class="btn_gray">VIEW</a>
								<label><input type='checkbox' name='imgDel_Chk1' class="fileFieldChk"> 삭제</label>
								<% Else %>
								<input type="hidden" name="imgDel_Chk1" value="1">
								<% End IF %>
							<% End IF %>
						</td>
					</tr>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit()" class="btn_largeG">확인</a>
					<a href="<%=PageLink%>?page=<%=page%>&<%=PageStr%>" class="btn_largeW">목록</a>
				</div>
 
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->