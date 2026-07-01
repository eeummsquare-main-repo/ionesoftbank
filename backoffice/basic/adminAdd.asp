<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "admin" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim idx, page
Dim TitleTag, Sort
Dim id, pwd, name, username, tel, email, loginCnt

Idx = uf_getRequest(Request("idx"),"int","","")
Page = uf_getRequest(Request("page"),"int","","")

IF CSTR(idx)="0" Then
	Response.write Execjavaalert("접근할수 없는 사용자코드입니다.\n다시시도해주세요.",0)
	Response.end
End IF

IF Idx<>"" Then
	Sql="SELECT id, pwd, name, username, email, tel, loginCnt, pubMenu, memsort FROM admin WHERE idx="&idx
		
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		id=ReplaceTextField(Rs("id")) : pwd=ReplaceTextField(Rs("pwd"))
		name=ReplaceTextField(Rs("name"))
		username=ReplaceTextField(Rs("username"))
		email=ReplaceTextField(Rs("email"))
		tel=ReplaceTextField(Rs("tel"))
		loginCnt=Rs("loginCnt")
		pubMenu=Rs("pubMenu")
		memsort=Rs("memsort")
	End IF
	Set Rs=Nothing

	TitleTag="수정"
	Sort=2
Else
	TitleTag="등록"
	Sort=1
End IF

Sql="SELECT idx,topcode,subcode,topName,subName,linkurl FROM menu WHERE isUse=1 Order by listnum ASC, idx ASC"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then menuRec=Rs.GetRows()

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_PubMenu()
	IF IsArray(menuRec) Then
		For i=0 To Ubound(menuRec,2)
			IF menuRec(1,i) <> tmpTopCode Then
				Response.Write "<div>"&menuRec(3,i)&"</div>"&Vbcrlf
			End IF

			IF CSTR(idx)="1" Then disTag="disabled" : superCheck="checked"

			Response.Write "<span><input type='checkbox' name='pubMenu' class='pubMenus' id='pmenu"&i&"' value='"&menuRec(0,i)&"' "&arignSortChecked(","&pubMenu&",", ","&menuRec(0,i)&",")&" "&disTag&" "&superCheck&"><label for='pmenu"&i&"'>"&menuRec(4,i)&"</label></span>"&Vbcrlf
			tmpTopCode = menuRec(1,i)
		Next
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	<% IF CSTR(idx)<>"1" Then %>
	$('#ch_all').click(function() {
		$("input[name='pubMenu']").prop('checked', true);
	});
	$('#unch_all').click(function() {
		$("input[name='pubMenu']").prop('checked', false);
	});
	<% End IF %>
});

function sendit(){
	var f=document.boardform;
	if (f.id.value==""){
		alert("ID 를 입력하여 주십시요.");
		f.id.focus();
		return;
	}
	if (hangul_chk(f.id.value) != true ){
		alert("ID에 한글이나 여백은 사용할 수 없습니다.");
		f.userid.focus();
	 	return;
	}
	if (f.id.value.length < 3 || f.id.value.length > 15) {
		alert("ID는 3~15자리입니다.");
		f.id.focus();
		return;
	}
	if (f.pwd.value==""){
		alert("비밀번호를 입력하여 주십시요.");
		f.pwd.focus();
		return;
	}
	if (hangul_chk(f.pwd.value) != true ){
		alert("비밀번호에 한글이나 여백은 사용할 수 없습니다.");
		f.pwd.focus();
	 	return;
	}
	if (f.pwd.value.length < 3 || f.pwd.value.length > 15) {
		alert("비밀번호는 3~15자리입니다.");
		f.pwd.focus();
		return;
	}
	if(f.pwd.value != f.repwd.value){
		alert("패스워드와 패스워드확인이 일치하지 않습니다.\n다시입력해주세요.");
		f.pwd.value="";
		f.repwd.value="";
		f.pwd.focus();
		return;
	}
	if(f.name.value==""){
		alert("이름을 입력하세요.");
		f.name.focus();
		return;
	}
	if (!$(".pubMenus").is(":checked")){
		alert("하나 이상의 관리메뉴를 선택해야 합니다.");
		return;
	}
	$(".pubMenus").prop("disabled",false);

	f.target="iframes";
	f.submit();
}
function boardModify(idx){
	document.paramtransFrm.idx.value = idx;
	document.paramtransFrm.action = "adminAdd.asp";
	document.paramtransFrm.submit();
}
function boardDel(idx){
	var value=confirm("선택하신 운영자를 삭제하시겠습니까?");
	if(value){
		document.paramtransFrm.idx.value = idx;
		document.paramtransFrm.action = "adminDel.asp";
		document.paramtransFrm.submit();
	}
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
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<form name="boardform" action="adminAddok.asp" method="post">
				<input type='hidden' name='sort' value='<%=Sort%>'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='page' value='<%=Page%>'>
				<table class="tbl_row">
					<caption>관리자 <%=TitleTag%></caption>
					<colgroup>
						<col style="width: 15%" />
						<col style="width: *" />
						<col style="width: 15%" />
						<col style="width: 35%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">권한</th>
							<td colspan="3">
								<p class="checkIn">
									<input type='radio' name='memsort' value='0' id="memsort1" checked>
									<label class="labelTxt" for="memsort1">슈퍼관리자</label>
								</p>
								<p class="checkIn">
									<input type='radio' name='memsort' value='1' id="memsort2" <%=iif_compare(memsort, 1, "checked")%>>
									<label class="labelTxt ml10" for="memsort2">부관리자</label>
								</p>
								<p class="checkIn">
									<input type='radio' name='memsort' value='2' id="memsort3" <%=iif_compare(memsort, 2, "checked")%>>
									<label class="labelTxt ml10" for="memsort3">일반관리자</label>
								</p>
							</td>
						</tr>
						<tr>
							<th scope="col">아이디</th>
							<td colspan="3"><input name="id" type="text" class="txtall" maxlength='15' value='<%=id%>'></td>
						</tr>
						<tr>
							<th scope="col">비밀번호</th>
							<td><input name="pwd" type="password" class="txt80p" maxlength='15' value='<%=pwd%>'></td>
							<th scope="col">비밀번호확인</th>
							<td><input name="repwd" type="password" class="txt80p" maxlength='15' value='<%=pwd%>'></td>
						</tr>
						<tr>
							<th scope="col">관리자명</th>
							<td><input name='name' type='text' maxlength='10' class='txt80p' Value='<%=name%>'></td>
							<th scope="col">사용자명</th>
							<td><input name='username' type='text' maxlength='25' class='txt80p' Value='<%=username%>'></td>
						</tr>
						<tr>
							<th scope="col">연락처</th>
							<td><input name='tel' type='text' maxlength='15' class='txt80p' Value='<%=tel%>'></td>
							<th scope="col">이메일</th>
							<td><input name='email' type='text' maxlength='50' class='txt80p' Value='<%=email%>'></td>
						</tr>
						<tr>
							<th scope="col">관리메뉴</th>
							<td colspan='3' class='pubMenus'>
								<p>
									<a id="ch_all" class="btn_gray btn_gray100">전체선택</a>
									<a id="unch_all" class="btn_gray btn_gray100">전체해제</a>
								</p>
								<%=PT_PubMenu()%>
							</td>
						</tr>
					</tbody>
				</table>
				</form>
				<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>

				<div class="btn_center pt30">
					<a href="javascript:sendit()" class="btn_largeG">확인</a>
					<a href="javascript:history.back()" class="btn_largeW">취소</a>
				</div>

<script type="text/javascript">
<!--
function viewPage(idx,tp,divID,page){
	var params = "idx="+idx+'&page='+page;

	$.ajax({
		type:"post",
		url: tp,
		data:params,
		dataType:"html",
		async: true,
		beforeSend : function(){
			popupLoadingOpen();
		}
	}).done(function(data){
		$("#"+divID).html(data);
		layerModalClose();
	})
}
//-->
</script>

				<% IF Idx<>"" Then %>
				<div id='LoginLogDiv'></div>
				<SCRIPT LANGUAGE="JavaScript">viewPage(<%=idx%>,"ajax_AdminLoginLog.asp","LoginLogDiv",'')</SCRIPT>
				<% End IF %>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->