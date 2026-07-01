<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0204">

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
				<li class="active"><a href="javascript:void(0);">2023년</a></li>
				<li><a href="javascript:void(0);">2022년</a></li>
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

		<div class="year-tab-conts f0 tac">
			<div class="month-tab">
				<p><strong>12월</strong>(11월분 입금현황)</p>
				<div class="month-tab-in">
					<a href="javascript:void(0);"><strong>12월</strong>(11월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>9월</strong>(8월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>8월</strong>(7월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>7월</strong>(6월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>6월</strong>(5월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>5월</strong>(4월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>4월</strong>(3월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>3월</strong>(2월분 입금현황)</a>
				</div>
			</div>
			<img src="/images/sub/payment_status_2022.jpg" alt="" />
		</div>
		<div class="year-tab-conts f0 tac">
			<div class="month-tab">
				<p><strong>9월</strong>(8월분 입금현황)</p>
				<div class="month-tab-in">
					<a href="javascript:void(0);"><strong>12월</strong>(11월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>9월</strong>(8월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>8월</strong>(7월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>7월</strong>(6월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>6월</strong>(5월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>5월</strong>(4월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>4월</strong>(3월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>3월</strong>(2월분 입금현황)</a>
				</div>
			</div>
			<img src="/images/sub/payment_status_2021.jpg" alt="" />
		</div>
		<div class="year-tab-conts f0 tac">
			<div class="month-tab">
				<p><strong>6월</strong>(5월분 입금현황)</p>
				<div class="month-tab-in">
					<a href="javascript:void(0);"><strong>12월</strong>(11월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>9월</strong>(8월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>8월</strong>(7월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>7월</strong>(6월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>6월</strong>(5월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>5월</strong>(4월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>4월</strong>(3월분 입금현황)</a>
					<a href="javascript:void(0);"><strong>3월</strong>(2월분 입금현황)</a>
				</div>
			</div>
			<img src="/images/sub/payment_status_2020.jpg" alt="" />
		</div>
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

		$("body").on("click", ".month-tab", function(e){//
			if($(this).hasClass("open")){
				$(this).removeClass("open")
				$(".month-tab .month-tab-in").stop().slideUp(300);
			}else{
				$(this).addClass("open")
				$(".month-tab .month-tab-in").stop().slideDown(300);
			}
		});
		$("body").on("mouseleave", ".month-tab", function(){//
			$(".month-tab").removeClass("open");
			$(".month-tab .month-tab-in").stop().slideUp(300);
		});
	});
</script>
</body>
</html>