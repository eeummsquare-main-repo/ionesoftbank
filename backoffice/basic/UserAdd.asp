<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "intra" : subMenuCode = "intra" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Idx = uf_getRequest(Request("Idx"),"int","","")

IF Idx<>"" Then
	Sql="SELECT id,pwd,name,email,company,tel FROM intraUser WHERE idx="&idx

	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		id=ReplaceTextField(Rs("id"))
		pwd=ReplaceTextField(Rs("pwd")) : name=ReplaceTextField(Rs("name"))
		company=ReplaceTextField(Rs("company")) : tel=ReplaceTextField(Rs("tel"))
		email=ReplaceTextField(Rs("email"))
	End IF
	Set Rs=Nothing

	TitleTag="수정"
	Sort=2
Else
	TitleTag="등록"
	Sort=1
End IF

DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
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
	if(f.name.value==""){
		alert("이름을 입력하세요.");
		f.name.focus();
		return;
	}
	f.target="iframes";
	f.submit();
}
function hangul_chk(word) {
	var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";

	for (i=0; i< word.length; i++)
	{
		idcheck = word.charAt(i);

		for ( j = 0 ;  j < str.length ; j++){

			if (idcheck == str.charAt(j)) break;

     			if (j+1 == str.length){
   				return false;
     			}
     		}
     	}
     	return true;
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
					<h2 class="top_left">인트라넷 유저<%=TitleTag%></h2>
					<a href="/backoffice/">HOME</a> &gt; 기본관리 &gt; <span>인트라넷 유저관리</span>
				</div>

				<form name="boardform" action="useraddOk.asp" method="post">
				<input type='hidden' name='sort' value='<%=Sort%>'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<table class="tbl_row">
					<caption>관리자 <%=TitleTag%></caption>
					<colgroup>
						<col style="width: 15%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">아이디</th>
							<td><input name="id" type="text" class="input" size="15" maxlength='15' value='<%=id%>'></td>
						</tr>
						<tr>
							<th scope="col">비밀번호</th>
							<td><input name="pwd" type="password" class="input" size="15" maxlength='15' value='<%=pwd%>'></td>
						</tr>
						<!-- <tr>
							<th scope="col">상점명</th>
							<td><input type='text' name='company' size='15' maxlength='100' class='input' Value='<%=company%>'></td>
						</tr> -->
						<tr>
							<th scope="col">담당자명</th>
							<td><input type='text' name='name' size='15' maxlength='40' class='input' Value='<%=name%>'></td>
						</tr>
						<tr>
							<th scope="col">부서명</th>
							<td><input type='text' name='tel' size='25' maxlength='30' class='input' Value='<%=Tel%>'></td>
						</tr>
						<tr>
							<th scope="col">Email</th>
							<td><input name="email" type="text" class="input" size="50" maxlength='100' value='<%=email%>'></td>
						</tr>
					</tbody>
				</table>
				</form>
				<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>

				<div class="btn_center pt30">
					<a href="javascript:sendit()" class="btn_largeG">확인</a>
					<a href="javascript:history.back()" class="btn_largeW">취소</a>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->