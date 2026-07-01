<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
	<link rel="stylesheet" type="text/css" href="/common/css/member.css" />
</head>

<body data-pgCode="1002" data-pgTitle="FIND ID/PASSWORD">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container" class="f0">
		<div class="kookMin-find">
			<div id="find_info" class="mbskin kookMin newLogin">
				<dl class="topTit">
					<dt>아이디 찾기</dt>
					<dd>
						*회원가입 시 등록한 다음의 정보를 입력해 주세요
					</dd>
				</dl>
				<form name="idForm" action="/_proc/findID_OK.asp" method="Post" target="tpActFrame" onsubmit="idFind(this); return false;">
				<input type="hidden" name="mode" value="아이디 찾기">
					<fieldset id="login_fs">
						<label for="mb_email" class="sound_only">NAME<strong class="sound_only">필수</strong></label>
						<input type="text" name="username" class="required frm_input full_input email" size="30" placeholder="이름" style="margin-bottom: 1rem;" maxlength="50">
						<label for="mb_email" class="sound_only">EMAIL<strong class="sound_only">필수</strong></label>
						<input type="text" name="email" class="required frm_input full_input email" size="30" placeholder="이메일" maxlength="50">
						<div class="btn_box">
							<button type="button" class="btn_submit btn_cancel" onclick="javascript:history.go(-1);">취소</button>
							<button type="submit" class="btn_submit">확인</button>
						</div>
					</fieldset>
				</form>
				<iframe name="tpActFrame" frameborder="0" width="100%" height="0" class="disNone"></iframe>
			</div>

			<div id="find_info" class="mbskin kookMin newLogin">
				<dl class="topTit">
					<dt>비밀번호 찾기</dt>
					<dd>
						*회원가입 시 등록한 다음의 정보를 입력해 주세요 <br>
						(비밀번호는 암호화 되어있어 임시비밀번호로 재발급됩니다.)
					</dd>
				</dl>
				<form name="pwdForm" action="/_proc/findPwd_OK.asp" method="Post" target="tpActFrame" onsubmit="pwdFind(this); return false;">
					<fieldset id="login_fs">
						<label for="mb_email" class="sound_only">ID<strong class="sound_only">필수</strong></label>
						<input type="text" maxlength="15" name="userid" class="required frm_input full_input email" size="30" placeholder="아이디" style="margin-bottom: 1rem;">
						<label for="mb_email" class="sound_only">NAME<strong class="sound_only">필수</strong></label>
						<input type="text" maxlength="50" name="username" class="required frm_input full_input email" size="30" placeholder="이름" style="margin-bottom: 1rem;">
						<label for="mb_email" class="sound_only">EMAIL<strong class="sound_only">필수</strong></label>
						<input type="text" maxlength="50" name="email" class="required frm_input full_input email" size="30" placeholder="이메일">

						<div class="btn_box">
							<button type="button" class="btn_submit btn_cancel" onclick="javascript:history.go(-1);">취소</button>
							<button type="submit" class="btn_submit">확인</button>
						</div>
					</fieldset>
				</form>
			</div>
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