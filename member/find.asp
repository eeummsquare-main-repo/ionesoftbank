<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
	<link rel="stylesheet" type="text/css" href="/common/css/member.css" />

	<script type="text/javascript">
	<!--
	function idFind(frm){
		if (frm.username.value == ""){
			alert("성명을 입력하세요.");
			frm.username.focus();
			return;
		}
		if (frm.email.value == ""){
			alert("이메일을 입력하세요.");
			frm.email.focus();
			return;
		}
		frm.submit();
	}

	function pwdFind(frm){
		if (frm.userid.value == ""){
			alert("아이디를 입력하세요.");
			frm.userid.focus();
			return;
		}
		if (frm.username.value == ""){
			alert("성명을 입력하세요.");
			frm.username.focus();
			return;
		}
		if (frm.email.value == ""){
			alert("이메일을 입력하세요.");
			frm.email.focus();
			return;
		}
		frm.submit();
	}
	//-->
	</script>
</head>

<body data-pgCode="1002" data-pgTitle="FIND ID/PASSWORD">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container" class="f0">
		<div class="member-area find">
			<div class="inBox">
				<dl class="memTit">
					<dt>아이디 찾기</dt>
					<dd>가입시 입력하신 이름을 입력해주세요.</dd>
				</dl>

				<form Name="idForm" action="/_proc/findID_OK.asp" Method="Post" target="tpActFrame" onsubmit="idFind(this); return false;">
				<input type="hidden" name="mode" value="아이디 찾기">
				<div class="fildBox mt15">
					<input type="text" name="username" id="username" maxlength="50" value="" placeholder="이름 입력" />
					<input type="text" name="email" id="email" maxlength="50" value="" placeholder="이메일 입력" />
                    <!-- <input type="text" name="" id="" maxlength="50" value="" placeholder="휴대폰 번호를 - 빼고 입력해주세요" />
                    <input type="text" name="" id="" maxlength="50" value="" placeholder="인증번호" />
					<input type="text" name="" id="" maxlength="50" value="" placeholder="" disabled class="pVar" style="opacity: 0;" /> -->

					<div class="board_btn one">
						<input type="submit" value="확인" class="click big" />
					</div>
				</div>
				</form>
				<iframe name='tpActFrame' frameborder='0' width='100%' height='0' class="disNone"></iframe>
			</div>
			<div class="inBox">
				<dl class="memTit">
					<dt>비밀번호 찾기</dt>
					<dd>가입시 입력하신 아이디, 이름, 이메일을 입력해주세요.</dd>
				</dl>
				<form Name="pwdForm" action="/_proc/findPwd_OK.asp" Method="Post" target="tpActFrame" onsubmit="pwdFind(this); return false;">
				<div class="fildBox mt15">
					<input type="text" maxlength="15" name="userid" id="userid" value="" placeholder="아이디 입력" />
					<input type="text" maxlength="50" name="username" id="username" value="" placeholder="이름 입력" />
					<input type="text" maxlength="50" name="email" id="email" value="" placeholder="이메일 입력" />
                    <!-- <input type="text" name="" id="" maxlength="50" value="" placeholder="휴대폰 번호를 - 빼고 입력해주세요" />
                    <input type="text" name="" id="" maxlength="50" value="" placeholder="인증번호" /> -->
					<div class="board_btn one">
						<input type="submit" value="찾기" class="click big" />
					</div>
				</div>
				</form>
			</div>

			<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>
		</div>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>

<script type="text/javascript">
	$(function () {
	});
</script>
</body>
</html>