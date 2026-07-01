<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0203">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<div class="year-tab">
			<button type="button" class="name"></button>
			<ul class="year-list">
				<li class="active"><a href="javascript:void(0);">2022년</a></li>
				<li><a href="javascript:void(0);">2021년</a></li>
				<li><a href="javascript:void(0);">2020년</a></li>

				<li><a href="javascript:void(0);">2019년</a></li>
				<li><a href="javascript:void(0);">2018년</a></li>
				<li><a href="javascript:void(0);">2017년</a></li>
				<li><a href="javascript:void(0);">2016년</a></li>
				<li><a href="javascript:void(0);">2015년</a></li>
				<li><a href="javascript:void(0);">2014년</a></li>
			</ul>
		</div>

		<div class="year-tab-conts f0 tac"><img src="/images/sub/report_2022.jpg" alt="" /></div>
		<div class="year-tab-conts f0 tac"><img src="/images/sub/report_2021.jpg" alt="" /></div>
		<div class="year-tab-conts f0 tac"><img src="/images/sub/report_2020.jpg" alt="" /></div>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<script type="text/javascript">
	$(function () {
		$(".year-tab").multiTab({name : "year"});

		$("body").on("click", ".year-list>li", function(){
			var idx = $(".year-list>li").index($(this));

			$(".year-tab-conts").hide();

			$(".year-tab-conts").eq(idx).show();
		});
		$(".year-tab-conts").eq(0).show();
	});
</script>
</body>
</html>