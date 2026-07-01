<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
	<link rel="stylesheet" type="text/css" href="/common/css/member.css" />

	<SCRIPT LANGUAGE="JavaScript">
	<!--
	function yakSendit(sort){
		if (!document.getElementById("agree1").checked){
			alert("이용약관에 동의 하셔야 합니다.");
			return;
		}
		if (!document.getElementById("agree2").checked){
			alert("개인정보 수집 및 이용에 동의 하셔야 합니다.");
			return;
		}
		location.href="join.asp";
		//window.open('/_okName/phone_popup2.asp', 'popupChk', 'width=640, height=430, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=yes');
	}
	function okNameResult(){
		document.joinFrm.target = "";
		document.joinFrm.action = "join.asp";
		document.joinFrm.submit();
	}

	$(function(){
		$("#allagree").click(function(){
			if($(this).is(":checked")){
				$(".agree_check").prop("checked", true);
			}else{
				$(".agree_check").prop("checked", false);
			}
		});
	});
	//-->
	</SCRIPT>
</head>

<body data-pgCode="1003" data-pgTitle="MEMBERSHIP">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container" class="f0">
		<!-- [s] 이용약관 -->
		<div class="clauseArea m0">
			<p class="tit">이용약관</p>
			<div class="scroll bor">
				<!--#include virtual = /common/include/clause.asp-->
			</div>
			<div class="tar">
			<p class="check-new">
				<input type="checkbox" id="agree1" name="clauseCheckss" />
				<label for="agree1"><span class="graphic"></span>위의 이용약관에 동의합니다.</label>
			</p>
			</div>
		</div>
		<!-- [e] 이용약관 -->

		<!-- [s] 개인정보처리방침 -->
		<div class="clauseArea mt50">
			<p class="tit">개인정보처리방침</p>
			<div class="scroll bor">
				<!--#include virtual = /common/include/privacy.asp-->
			</div>
			<div class="tar">
			<p class="check-new">
				<input type="checkbox" id="agree2" name="clauseCheckss2" />
				<label for="agree2"><span class="graphic"></span>위의 개인정보처리방침에 동의합니다.</label>
			</p>
			</div>
		</div>
		<!-- [e] 개인정보처리방침 -->
		<form name="joinFrm" id="joinFrm" method="post">
		</form>

		<div class="board_btn center">
			<a href="javascript:yakSendit(1);" class="click big">회원정보입력</a>
		</div>

		<!-- <div class="board_btn long">
			<a href="javascript:yakSendit(1);" class="click point">본인인증</a>
		</div> -->
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>

<script type="text/javascript">
	$(function () {
	});
</script>
</body>
</html>