<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0504">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<!--[s] Search -->
		<div class="board_search">
			<select name="" id="">
				<option value="">제목</option>
				<option value="">내용</option>
				<option value="">제목+내용</option>
			</select>
			<input type="text" name="" value="" id="" placeholder="검색어를 입력해주세요" >
			<input type="submit" name="" value="검색" />
		</div>
		<!--[e] Search -->

		<ul class="faqArea">
			<li>
				<a href="javascript:void(0);" class="q">질문이 노출됩니다.</a>
				<div class="a">답변이 노출됩니다.</div>
			</li>
			<li>
				<a href="javascript:void(0);" class="q">질문이 노출됩니다.</a>
				<div class="a">답변이 노출됩니다.</div>
			</li>
			<li>
				<a href="javascript:void(0);" class="q">질문이 노출됩니다.</a>
				<div class="a">답변이 노출됩니다.</div>
			</li>
		</ul>

		<nav class="paging_all">
			<a class="btns pg_page prev">처음</a>
			<span class="num">
				<strong class="pg_current">1</strong>
				<a href="javascript:void(0);" class="pg_page">2</a>
				<a href="javascript:void(0);" class="pg_page">3</a>
				<a href="javascript:void(0);" class="pg_page">4</a>
				<a href="javascript:void(0);" class="pg_page">5</a>
			</span>
			<a class="btns pg_page next">다음</a>
		</nav>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<script type="text/javascript">
	$(function () {
	});
</script>
</body>
</html>