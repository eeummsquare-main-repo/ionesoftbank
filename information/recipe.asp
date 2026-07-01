<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0403">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<div class="photo_list newsletter recipe">
			<ul class="list">
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe01.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe02.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe03.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe04.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe02.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe03.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe01.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe04.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe03.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe01.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe02.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>
				<li>
					<a href="recipe_view.asp" class="gall_cont">
						<div class="thumb">
							<img src="/images/sub/img_recipe04.jpg" alt="" title=""><p class="over move"><span>view</span></p>
						</div>
					</a>
				</li>


				<li class="noPost">게시물이 없습니다.</li>
			</ul>

			<button type="button" class="more">더보기</button>
		</div>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<script type="text/javascript">
	$(function () {
	});
</script>
<script type="text/javascript">
	$(function(){
		// 플러그인 이미지(bg 움직임) 오버
		$(".photo_list .list").iOverScript({
			btns : '.gall_cont', // 이벤트 class
			bg : '.over', // 활성화 class
			speed : 700 // 속도
		});
	});
</script>
</body>
</html>