<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="1201">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container" class="recruitment-area idl">
		<div class="etc_select">
			<select name="" id="" class="base" onchange="javascript:sel_it(this.value);">
				<option value="javascript:void(0);" selected="selected">현행 시행 일자  : 2022년 10월 7일</option>
				<option value="javascript:void(0);">시행일자  : 2020년 11월 27일</option>
			</select>
		</div>
		<div class="etc_clause clauseArea no"><div class="etc_clause_in">
			<p class="logo"><img src="/images/logo_on.png" alt="incriss"></p>
			<div class="txt"><span>이용약관</span> 안내</div>

			<div class="scroll">
			    <!--#include virtual = /common/include/clause.asp-->
			</div>
		</div></div>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>

<script type="text/javascript">
	$(function () {
	});
</script>
</body>
</html>