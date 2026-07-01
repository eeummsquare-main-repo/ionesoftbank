<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "popup" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Idx,Sort,StartDate,EndDate,WSize,HSize,Title,Content,HtmlYN,LinkUrl,OutputImg
Dim S_Year,S_Mon,S_Day,E_Year,E_Mon,E_Day
Dim pTop, pLeft, popSort, temCode
Idx = uf_getRequest(Request("idx"),"int","","")

Dim langTitle, langmode

Set Rs=DBcon.Execute("FM_AP_PopupView("&Idx&")")

Sort=Rs(0) : StartDate=Rs(1) : EndDate=Rs(2) : WSize=Rs(3) : HSize=Rs(4) : Title=ReplaceTextField(Rs(5))
HtmlYN=Rs(7) : LinkUrl=Rs(8) : OutputImg=Rs(9) : Content=ReplaceNoHtml(Rs(6))
pTop=Rs(10) : pLeft=Rs(11) : popSort=Rs(12) : temcode=Rs(13) : langmode=Rs(14)
mobileYN=Rs(15) : edNonce=ChangeBlank(Rs(16))

Call getLangModeTitle(langmode)

'###### 에디터 ID 생성 ##########
IF edNonce="" Then 
	edNonce = GetEdNonce()
End IF
'###### 에디터 ID 생성 ##########

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_JavaScript
	Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
	Response.Write "var form=document.popup_form ;"&Vbcrlf
	Response.Write "form.sort["&Sort&"].checked=true;"&Vbcrlf
	Response.Write "</SCRIPT>"&Vbcrlf
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	$(document).on("change",".mobileYN",function(){
		var radioVal = $('input[name="mobileYN"]:checked').val();

		if (radioVal==0){
			$(".PCMODE").show();
		}else{
			$(".PCMODE").hide();
		}
	});

	$(".mobileYN").change();
});

function popup_view(){
	form=document.popup_form ;
	if(form.sort[0].checked){
		document.all.view[0].style.display="none";
		document.all.view[1].style.display="none";
		document.all.view[2].style.display="none";
		document.all.view[3].style.display="";
	}
	else if(form.sort[1].checked){
		document.all.view[0].style.display="";
		document.all.view[1].style.display="";
		document.all.view[2].style.display="";
		document.all.view[3].style.display="none";
	}
}

function sendit(){
	var form=document.popup_form;
	if(form.searchDate1.value==false){
		alert("시작일을 입력해주세요.");
		return;
	}
	if(form.searchDate2.value==false){
		alert("종료일을 입력해주세요.");
		return;
	}
	if (form.mobileYN.value=="0"){
		if(form.pop_w.value==false){
			alert("가로사이즈를 입력하세요.");
			form.pop_w.focus();
			return;
		}
		if(form.pop_h.value==false){
			alert("세로사이즈를 입력하세요.");
			form.pop_h.focus();
			return;
		}
	}
	if(form.pop_title.value==""){
		alert("브라우져 타이틀을 입력하세요.");
		form.pop_title.focus();
		return;
	}
	if(form.sort[1].checked && form.files.value==""){
		if(form.imgDel_Chk.checked){
			alert("출력이미지를 선택하세요.");
			return;
		}
	}
	document.getElementById("pop_w").disabled=false;
	document.getElementById("pop_h").disabled=false;
	form.submit();
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
					<h2 class="top_left"><%=GB_SubMenuName%> <!-- [<%=langTitle%>] --></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<!-- <div class="subTab mt20 mb20">
					<a href="popup.asp?langmode=0" class="<%=iif_compare(langmode, 0, "active")%>"><span>KR</span></a>
					<a href="popup.asp?langmode=1" class="<%=iif_compare(langmode, 1, "active")%>"><span>EN</span></a>
				</div> -->

				<form action="popup_edit_ok.asp" method="post" name="popup_form" enctype="multipart/form-data" style='margin:0'>
				<input type='hidden' name='idx' value=<%=Idx%>>
				<input type='hidden' name='langmode' value=<%=langmode%>>
				<input type='hidden' name='edNonce' value='<%=edNonce%>'>
				<table class="tbl_row">
					<caption>팝업등록</caption>
					<colgroup>
						<col style="width: 15%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
					<tr class="disNone">
						<th scope="col">팝업분류</th>
						<td>
							<label><input type="radio" name="mobileYN" class="mobileYN" value="0" checked> PC팝업</label>
							<label><input type="radio" name="mobileYN" class="mobileYN" value="1" <%=iif_compare(mobileYN,1,"checked")%>> 모바일팝업</label>
						</td>
					</tr>
					<tr class="PCMODE">
						<th scope="col">팝업종류</th>
						<td>
							<label><input type="radio" name="popSort" value="0" checked <%=ChangeChecked(0,popSort)%>> 일반팝업</label>
							<label><input type="radio" name="popSort" value="1" <%=ChangeChecked(1,popSort)%>> 레이어팝업</label>
						</td>
					</tr>
					<tr>
						<th scope="col">형태선택</th>
						<td>
							<label><input type="radio" name="sort" id='sort1' value="0" checked onclick="popup_view();"> HTML</label>
							<label><input type="radio" name="sort" id='sort2' value="1" onclick="popup_view();"> 단일이미지</label>
						</td>
					</tr>
					<tr>
						<th scope="col">시작일/종료일</th>
						<td>
							<div class="date_wrap">
								<input type="text" name="searchDate1" class="datepicker1" maxlength='10' value='<%=StartDate%>' readonly />
								~
								<input type="text" name="searchDate2" class="datepicker2" maxlength='10' value='<%=EndDate%>' readonly />
							</div>
						</td>
					</tr>
					<tr class="PCMODE">
						<th scope="col">팝업창 사이즈</th>
						<td>
							<input type="text" name="pop_w" id='pop_w' size="4" maxlength="4" class="input onlyNumber" style='text-align: right; color: #FF0000;' value='<%=WSize%>'> 가로 x
							<input type="text" name="pop_h" id='pop_h' size="4" maxlength="4" class="input onlyNumber" style='text-align: right; color: #FF0000;' value='<%=HSize%>'> 세로 (새로운 창의 크기를 설정해주세요.)
						</td>
					</tr>
					<tr class="PCMODE">
						<th scope="col">팝업창 위치</th>
						<td>
							<input type="text" name="pLeft" size="4" maxlength="4" class="input onlyNumber" style='text-align: right; color: #FF0000;' value='<%=pLeft%>'> 좌측 x
							<input type="text" name="pTop" size="4" maxlength="4" class="input onlyNumber" style='text-align: right; color: #FF0000;' value='<%=pTop%>'> 상단
						</td>
					</tr>
					<tr>
						<th scope="col">브라우져 타이틀</th>
						<td><input type="text" name="pop_title" class="input" value='<%=Title%>' style="width:70%;" maxlength='100'> 간략한설명</td>
					</tr>

					<tr id="view" style="display:none;">
						<th scope="col">링크 URL</th>
						<td><input type="text" name="link_url" style='width:98%' class="input" value='<%=LinkUrl%>' maxlength='200'></td>
					</tr>
					<tr id="view" style="display:none;">
						<th scope="col">출력이미지</th>
						<td class="fileTD"> 
							<% IF OutputImg<>"" Then %>
							<div style='float:left; padding-right:30px;'>
								<img src='/upload/popup/<%=OutputImg%>' width="<%=imgsize("popup",180,OutputImg)%>" style='cursor:pointer;' onclick='openWindow(100,100,"/_lib/imgview.asp?path=popup&imgname=<%=OutputImg%>","imgView","yes")'>
							</div>
							<div style='padding-bottom:5px;'>
								<label><input type='checkbox' name='imgDel_Chk' value='1' class="fileFieldChk"> 삭제</label>
								<input type='hidden' name='imgname' value='<%=OutputImg%>'>
							</div>
							<% End IF %>
							<input type='file' name='files' class='filesrch_bar fileField'>
							<div style="padding-top:20px; color: #b50000;">
							*이미지 최대 크기는 3MB입니다. jpg,png 파일로 업로드 바랍니다.
							</div>
						</td>
					</tr>
					<tr id="view" style="display:none;">
						<td colspan="2" align="center">* 링크URL을 입력하시면 팝업창 이미지 클릭시 해당 페이지로 이동합니다.</td>
					</tr>
					<tr id="view" style="display:none;">
						<th scope="col">출력내용</th>
						<td align="center">
							<textarea name='content' id="content" rows='20' class="ckeditor5" style='width:100%'><%=Content%></textarea>
						</td>
					</tr>
					</tbody>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit()" class="btn_largeG">확인</a>
					<a href="javascript:history.back()" class="btn_largeW">취소</a>
				</div>

			</div>
		</div>


		<%PT_JavaScript%>
		<SCRIPT LANGUAGE="JavaScript">
		<!--
		form=document.popup_form ;
		if(form.sort[0].checked){
			document.all.view[0].style.display="none";
			document.all.view[1].style.display="none";
			document.all.view[2].style.display="none";
			document.all.view[3].style.display="";
		}
		else if(form.sort[1].checked){
			document.all.view[0].style.display="";
			document.all.view[1].style.display="";
			document.all.view[2].style.display="";
			document.all.view[3].style.display="none";
		}
		//-->
		</SCRIPT>

	</div>

<!--#include virtual = backoffice/common/bottom.asp-->