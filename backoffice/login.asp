<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8;" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=device-dpi" />
	<title> 관리자</title>
	<script src="/_lib/js/jquery-1.11.1.min.js" type="text/javascript"></script>
	<script src="/backoffice/js/jquery-ui.min.js" type="text/javascript"></script>
	<script src="/_lib/enc/base64.js" type="text/javascript"></script>
	<script language='javascript' src='/_lib/functions.js'></script>

	<style>
	html { background-color:#eee; padding:0; margin:0; overflow:hidden; }
	html, body{height:100%; min-height:100%;}
	#login {width:640px; padding:50px 80px; box-sizing:border-box; margin: 8vw auto 10vw; text-align:center; }
	#login #login_box{font-size:0; line-height:0; }
	#login #login_box .login_tlt { font:500 12px 'Montserrat', sans-serif; letter-spacing:8px; }
	#login #login_box .login_tlt span { font:600 35px 'Noto Sans KR', sans-serif; letter-spacing:-0.05em; display:block; margin-top:20px;  }
	#login #login_box>ul {margin-top:40px; padding-left:0;}
	#login #login_box>ul>li {padding-bottom:15px;}
	#login #login_box>ul>li input {vertical-align:middle; font:400 14px 'Montserrat', sans-serif;}
	#login #login_box .login_btn {}
	#login #login_box .login_btn a{display:block; width:100%; height:45px; border:1px solid #0ca0ad; background-color:#00b0bf; text-align:center;  font-size:16px;  font-family:'Noto Sans KR', sans-serif; font-weight:normal; color:#fff; line-height:45px; text-decoration: none;}
	.login_input{width:100%; height:45px; line-height:45px; padding:8px; box-sizing:border-box; background-color:#fff; border:1px solid #e4e4e4; color:#464646;}
	.pass_check{margin-left:30px; }
	#login .copy { font-family:'Montserrat', 'Noto Sans KR', sans-serif; text-align:center; margin:35px auto 0;}
	#login .copy a{ font-family:'Montserrat', 'Noto Sans KR', sans-serif;}
	#login .copy a:after { content:"l"; color:#aeaeae; padding-left:10px; margin-right:5px;}
	#login .copy img {margin:0 10px;}
	#login .copy span { font:500 16px 'Montserrat', 'Noto Sans KR', sans-serif; color:#fb6767}
	.txt_b { font:500 12px 'Noto Sans KR', sans-serif; color:#222; }
	#login .right_con .btn { font:500 12px 'Noto Sans KR', sans-serif; color:#000; display:inline-block; padding:5px 8px; border:1px solid #e3e3e3; background:#e3e3e3; }

	footer{
		background: #333;
		border-top: 1px solid #efefef;
		text-align: center;
		padding: 20px 0;
		width: 100%;
		position: fixed;
		bottom: 0;
		left: 0;
		z-index: 98;
	}
	footer p { color: #fff; }
	@media all and (max-width:639px) {
		#login {width:80%; padding:20px;}
		#login .copy span{display:block; margin-top:8px;}
	}
	</style>

	<script language="javascript">
	<!--
	function sendit() {
		var form=document.login_form;
		if(form.admin_userid.value=="") {
			alert("관리자 아이디를 입력해 주십시오.");
			form.admin_userid.focus();
			return;
		}
		if(form.admin_passwd.value=="") {
			alert("관리자 비밀번호를 입력해 주십시오.");
			form.admin_passwd.focus();
			return;
		}
		if (hangul_chk(form.admin_userid.value) != true ){
			alert("ID에 한글이나 여백은 사용할 수 없습니다.");
			form.admin_userid.focus();
			return;
		}
		if (hangul_chk(form.admin_passwd.value) != true ){
			alert("비밀번호에 한글이나 여백은 사용할 수 없습니다.");
			form.admin_passwd.focus();
			return;
		}
		document.actFrm.encid.value=Base64.encode(form.admin_userid.value);
		document.actFrm.encpwd.value=Base64.encode(form.admin_passwd.value);
		document.actFrm.submit();
	}

	function inputSendit() {
		if(event.keyCode==13) {
			sendit();
		}
	}
	//-->
	</script>
</head>
<body>
	<div id="login">
		<form name="login_form" method="post" onsubmit="inputSendit();event.returnValue = false;">
		<input type="hidden" name="reqToken" value="<%=csrf_token%>">
		<div id="login_box">
			<p class="login_tlt">ADMINISTRATOR LOGIN<br/><span>관리자 로그인</span></p>
			<ul>
				<li><input type="text" id="id" name="admin_userid" class="login_input" maxlength="15" placeholder="아이디"/></li>
				<li><input type="password" id="pw" name="admin_passwd" onKeyDown="inputSendit();" class="login_input" maxlength="15" placeholder="비밀번호"/></li>
			</ul>
			<p class="login_btn"><a href="javascript:sendit();">로그인</a></p>
		</div>
		</form>

		<form name="actFrm" method="post" action="code_login_ok.asp">
		<input type="hidden" name="reqToken" value="<%=csrf_token%>">
		<input type="hidden" name="encid" value="">
		<input type="hidden" name="encpwd" value="">
		</form>
	</div>

	<footer>
		<p>COPYRIGHT (C) 2023 . ALL RIGHTS RESERVED.</p>
	</footer>

	<script language="javascript">
	document.login_form.admin_userid.focus();
	</script>
</body>
</html>
<% Call AD_Logout("", "") %>