<!--#include virtual = /_lib/common.asp -->
<!--#include virtual = /_lib/dbcon.asp-->
<%
DBcon.CLose
Set DBcon = Nothing

returnURL = request("returnURL")

IF Session("UserID")<>"" Then
	IF returnUrl="" THen
		Response.Redirect "../"
	Else
		Response.Redirect returnURL
	End IF
	Response.END
End IF
%>
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
	<link rel="stylesheet" type="text/css" href="/common/css/member.css" />

	<% IF isSnsLogin = True Then %>
	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script type="text/javascript" src="/_lib/js/snsLogin.js"></script>
	<script>
	$(window).load(function(){
		if ($("#naver_login").length!=0){
			naver_id_login = new naver_id_login(naverApiKey, naverLoginCallBackUrl);
			var state = naver_id_login.getUniqState();
			$('#forState').val(state);
			naver_id_login.setState(state);
			naver_id_login.setPopup();
			naver_id_login.setCustomButton(false, "naver_login");
			naver_id_login.init_naver_id_login();
		}

		$(".popUp_wrap").click(function(e) {
			if( !$('.popUp_wrap').has(e.target).length ){
				$("html").removeClass("hidden");
				$(".popUp_wrap").removeClass("on");
			}
		});
		$(".btn_close").click(function() {
			$(".sns_login").toggleClass("on");
			$("html").removeClass("hidden");
		})
	});

	Kakao.init( kakaoApiKey );
	function loginWithKakao() {
	  Kakao.Auth.login({
		success: function(authObj) {
			Kakao.API.request({
				url: '/v2/user/me',
				success: function(res) {
					snsLogin("kakao", res.id, "");
				},
				fail: function(error) {
					alert('정보를 불러 올 수 없습니다.');
				}
			});
		},
		fail: function(err) {
			alert('카카오톡 서버와 연결 할 수 없습니다.');
		}
	  });
	}
	</script>
	<% End IF %>
</head>

<body data-pgCode="1001" data-pgTitle="LOGIN">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container" class="f0">
		<div class="member-area">
			<dl class="memTit">
				<dt class="logo-big"><img src="/images/logo_2026_on.png" alt=""></dt>
				<dd style="font-weight: 600; color:var(--point);">『본 서비스는 회원가입 후에 이용 가능합니다』</dd>
			</dl>

			<form name="loginfrm" id="loginfrm" method="post" action="login_ok.asp" onSubmit="mainLoginSend(loginfrm);return false;" style='margin:0;'>
			<input type='hidden' name='returnURL' value='<%=returnURL%>'>
			<input type='hidden' name='guestCHK' value='<%=guestCHK%>'>
			<div class="fildBox">
				<input type="text" name="userid" value="" maxlength="15" placeholder="아이디 입력" autocomplete="off" onkeydown="mainLoginInputSendit(loginfrm);" />
				<input type="password" name="passwd" value="" maxlength="15" placeholder="비밀번호 입력" autocomplete="off" onkeydown="mainLoginInputSendit(loginfrm);" />

				<div class="board_btn center">
					<input type="submit" value="로그인" class="click big point" />
				</div>

				<!-- <p class="check-new save_id">
					<input type="checkbox" id="login_auto_login" name="auto_login" />
					<label for="login_auto_login"><span class="graphic"></span>아이디 저장</label>
				</p> -->
			</div>
			</form>

			<ul class="txtBtn">
				<li>
					<span>- 아이디와 비밀번호를 알려드립니다.</span>
					<a href="javascript:link1002();">아이디/비밀번호 찾기</a>
				</li>
				<li>
					<span>- 아직 회원이 아니신가요?</span>
					<a href="javascript:link1003();">회원가입</a>
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