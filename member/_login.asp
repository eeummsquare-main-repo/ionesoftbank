<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
	<link rel="stylesheet" type="text/css" href="/common/css/member.css" />
</head>

<body data-pgCode="1001" data-pgTitle="LOGIN">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container" class="f0">
		<div id="mb_login" class="mbskin newLogin kookMin">
			<h1 class="logo-big"><img src="/images/logo_big.png" alt="REFUSS"></h1>
			<!-- <p class="txt">로그인을 하시면 더 많은 서비스를 이용하실 수 있습니다.</p> -->

			<fieldset id="login_fs">
				<label for="login_id" class="sound_only">회원아이디<strong class="sound_only"> 필수</strong></label>
				<input type="text" name="mb_id" id="login_id" required class="frm_input required" size="20" maxLength="20" placeholder="아이디">
				<label for="login_pw" class="sound_only">비밀번호<strong class="sound_only"> 필수</strong></label>
				<input type="password" name="mb_password" id="login_pw" required class="frm_input required" size="20" maxLength="20" placeholder="비밀번호">

				<p class="checkIn save_id">
					<input type="checkbox" id="login_auto_login" name="auto_login" />
					<label for="login_auto_login">아이디 저장</label>
				</p>

				<input type="submit" value="로그인" class="btn_submit">
			</fieldset>

			<ul class="txtBtn">
				<li>
					<span>- 아이디와 비밀번호를 알려드립니다.</span>
					<a href="find.asp"><span>아이디/비밀번호찾기</span></a>
				</li>
				<li>
					<span>- 아직 회원이 아니신가요?</span>
					<a href="register.asp">회원 가입</a>
				</li>
			</ul>
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