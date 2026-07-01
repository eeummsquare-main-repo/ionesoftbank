<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="040602">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<div class="store-online f0">
			<div class="store-online-top">
				<dl>
					<dt>신선한 고품질 육우<br /><strong>우리육우 공식 온라인 쇼핑몰</strong></dt>
					<dd>지금 바로 확인하세요!</dd>
				</dl>
			</div>

			<div class="store-online-btm">
				<p class="text">우리육우는 공식 쇼핑몰 이외 다른 판매처에서도 소비자님들에게 <br /><strong>신선한 제품</strong>을 판매하고 있습니다.</p>
			</div>

			<div class="photo_list store">
				<ul class="list">
					<li>
						<a href="javascript:void(0);" class="gall_cont">
							<div class="thumb">
								<img src="/images/sub/logo_store01.jpg" alt="" title=""><!-- 288*118 -->
							</div>
						</a>
					</li>
					<li>
						<a href="javascript:void(0);" class="gall_cont">
							<div class="thumb">
								<img src="/images/sub/logo_store02.jpg" alt="" title="">
							</div>
						</a>
					</li>
					<li>
						<a href="javascript:void(0);" class="gall_cont">
							<div class="thumb">
								<img src="/images/sub/logo_store03.jpg" alt="" title="">
							</div>
						</a>
					</li>
					<li>
						<a href="javascript:void(0);" class="gall_cont">
							<div class="thumb">
								<img src="/images/sub/logo_store04.jpg" alt="" title="">
							</div>
						</a>
					</li>
					<li>
						<a href="javascript:void(0);" class="gall_cont">
							<div class="thumb">
								<img src="/images/sub/logo_store05.jpg" alt="" title="">
							</div>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<script type="text/javascript">
	$(function () {
	});

	function findingMap(aVal){
		//tVal = aVal;
		$(".finding-map-link").removeClass("active");


		$(".finding-map-link[data-val='"+aVal+"']").addClass("active");
		//$("#areaidx").val(aVal);
		//changeAreaidx(aVal)
	}
</script>
</body>
</html>