<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "" : subMenuCode = "" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim id, pwd, name, username, tel, email, loginCnt

Sql="SELECT id,pwd,name,username,email,tel,loginCnt FROM admin WHERE idx="&Session("acountidx")
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	id=ReplaceTextField(Rs("id")) : pwd=ReplaceTextField(Rs("pwd"))
	name=ReplaceTextField(Rs("name"))
	username=ReplaceTextField(Rs("username"))
	email=ReplaceTextField(Rs("email"))
	tel=ReplaceTextField(Rs("tel"))
	loginCnt=Rs("loginCnt")
End IF
Set Rs=Nothing

DBcon.Close
Set DBcon=Nothing
%>

<script type="text/javascript">
<!--
function infoModify(){
	var f=document.userinfoFrm;
	if (f.id.value==""){
		alert("ID 를 입력하여 주십시요.");
		f.id.focus();
		return;
	}
	if (f.m_pwd.value==""){
		alert("정보수정을 위해 현재 비밀번호를 입력해주세요.");
		f.m_pwd.focus();
		return;
	}
	if (hangul_chk(f.id.value) != true ){
		alert("ID에 한글이나 여백은 사용할 수 없습니다.");
		f.userid.focus();
	 	return;
	}
	if (f.id.value.length < 4 || f.id.value.length > 15) {
		alert("ID는 4~15자리입니다.");
		f.id.focus();
		return;
	}
	if (f.pwd.value==""){
		alert("새 비밀번호를 입력하여 주십시요.");
		f.pwd.focus();
		return;
	}
	if (hangul_chk(f.pwd.value) != true ){
		alert("비밀번호에 한글이나 여백은 사용할 수 없습니다.");
		f.pwd.focus();
	 	return;
	}
	if (f.pwd.value.length < 6 || f.pwd.value.length > 15) {
		alert("비밀번호는 6~15자리입니다.");
		f.pwd.focus();
		return;
	}
	if(f.name.value==""){
		alert("이름을 입력하세요.");
		f.name.focus();
		return;
	}
	if(f.pwd.value != f.repwd.value){
		alert("새 패스워드와 새 패스워드확인이 일치하지 않습니다.\n다시입력해주세요.");
		f.pwd.value="";
		f.repwd.value="";
		f.pwd.focus();
		return;
	}

	var params = $("#userinfoFrm").serialize();
	$.ajax({
		type:"POST"
		, url:"/backoffice/basic/adminAddOk.asp"
		, data:params
		, dataType:"html"
		, async: true
		, beforeSend : function(){
			popupLoadingOpen();
		}
		, success:function(msg){
			if (msg=="success"){
				alert("정보가 수정되었습니다.");
				location.reload();
			}else if (msg=="dupID"){
				alert("이미등록된 아이디가 있습니다.\nID 변경후 다시시도해주세요.");
			}else if (msg=="passError"){
				alert("비밀번호가 일치하지 않습니다.\n현재 비밀번호를 정확히 입력해주세요.");
				f.m_pwd.value="";
				f.m_pwd.focus();
				layerModalClose();
			}else if (msg=="error"){
				alert("데이터처리중 오류가 발생했습니다.");
				location.reload();
			}
		}
	});
}
//-->
</script>

<div class="popWrap">
	<div class="popCon">
		<h1>내정보변경<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<form name="userinfoFrm" id="userinfoFrm" action="adminAddok.asp" method="post">
				<input type='hidden' name='sort' value='99'>
				<table class="tbl_row" style="width:800px;">
					<colgroup>
						<col style="width: 17%" />
						<col style="width: *" />
						<col style="width: 17%" />
						<col style="width: 33%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">아이디</th>
							<td><input name="id" type="text" class="txt80p" maxlength='15' value='<%=id%>'></td>
							<th scope="col">비밀번호</th>
							<td><input name="m_pwd" type="password" class="txt80p" maxlength='15' value=''></td>
						</tr>
						<tr>
							<th scope="col">새 비밀번호</th>
							<td><input name="pwd" type="password" class="txt80p" maxlength='15' value='<%=pwd%>'></td>
							<th scope="col">새 비밀번호확인</th>
							<td><input name="repwd" type="password" class="txt80p" maxlength='15' value='<%=pwd%>'></td>
						</tr>
						<tr>
							<th scope="col">관리자명</th>
							<td><input name='name' type='text' maxlength='10' class='txt80p' Value='<%=name%>'></td>
							<th scope="col">사용자명</th>
							<td><input name='username' type='text' maxlength='50' class='txt80p' Value='<%=username%>'></td>
						</tr>
						<tr>
							<th scope="col">연락처</th>
							<td><input name='tel' type='text' maxlength='15' class='txt80p' Value='<%=tel%>'></td>
							<th scope="col">이메일</th>
							<td><input name='email' type='text' maxlength='100' class='txt80p' Value='<%=email%>'></td>
						</tr>
					</tbody>
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