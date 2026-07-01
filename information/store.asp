<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="040601">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<div class="store-area f0">
			<div class="store-inj">
				<dl>
					<dt data-font="Prompt">STORE</dt>
					<dd padding-top:0.5rem; font-family:"pretendard"; font-weight: 500; font-size:1.4rem; line-height:1.2;>전국의 육우 인증점과 일반 판매점을 확인하실 수 있습니다.</dd>
				</dl>
				<div class="store-inj-box">
					<p><img src="/images/sub/logo_inj.png" alt="우리육우"></p>
					<dl>
						<dt>우리 육우 인증점이란?</dt>
						<dd>육우자조금 관리위원회의 엄격한 심사에서 인증받은 <br class="wVar" />국내산 육우만을 판매하는 전문 매장입니다.</dd>
					</dl>
				</div>
				<div class="store-inj-btn"><a href="javascript:void(0);">인증점 신청하기 <img src="/images/sub/arr_inj.png" alt=""></a></div>
			</div>

			<div class="store-map"><div class="thumb">
				<a href="javascript:findingMap(10);" class="finding-map-link" data-val="10" data-length="">서울 (10)</a>
				<!--
				<a href="javascript:findingMap(16);" class="finding-map-link" data-val="16" data-length="">부산 (10)</a>
				<a href="javascript:findingMap(13);" class="finding-map-link" data-val="13" data-length="">대구 (10)</a>
				-->
				<a href="javascript:findingMap(1);" class="finding-map-link" data-val="1" data-length="">인천 (7)</a>
				<!--
				<a href="javascript:findingMap(14);" class="finding-map-link" data-val="14" data-length="">광주 (10)</a>
				<a href="javascript:findingMap(12);" class="finding-map-link" data-val="12" data-length="">대전 (10)</a>
				<a href="javascript:findingMap(15);" class="finding-map-link" data-val="15" data-length="">울산 (10)</a>
				-->
				<a href="javascript:findingMap(2);" class="finding-map-link" data-val="2" data-length="">강원 (1)</a>
				<a href="javascript:findingMap(9);" class="finding-map-link" data-val="9" data-length="">경기 (4)</a>
				<a href="javascript:findingMap(7);" class="finding-map-link" data-val="7" data-length="">경남 (2)</a>
				<a href="javascript:findingMap(4);" class="finding-map-link" data-val="4" data-length="">경북 (6)</a>
				<a href="javascript:findingMap(6);" class="finding-map-link" data-val="6" data-length="">전남 (0)</a>
				<a href="javascript:findingMap(5);" class="finding-map-link" data-val="5" data-length="">전북 (1)</a>
				<a href="javascript:findingMap(8);" class="finding-map-link" data-val="8" data-length="">제주 (1)</a>
				<a href="javascript:findingMap(3);" class="finding-map-link" data-val="3" data-length="">충남 (6)</a>
				<a href="javascript:findingMap(11);" class="finding-map-link" data-val="11" data-length="">충북 (0)</a>
				<!-- <a href="javascript:findingMap(17);" class="finding-map-link" data-val="17" data-length="">세종 (10)</a> -->
				<img src="/images/sub/img_map.png" alt="">
			</div></div>
		</div>

		<!--[s] Search -->
		<div class="board_search small">
			<input type="text" name="" value="" id="" placeholder="검색어를 입력해주세요" >
			<input type="submit" name="" value="검색" />
		</div>
		<!--[e] Search -->

		<div class="board-total">Total <strong>91</strong>개점</div>
		<div class="store-table">
			<table>
				<colgroup>
					<col width="120">
					<col width="*">
					<col width="440">
					<col width="180">
					<col width="150">
				</colgroup>
				<thead>
					<tr>
						<th>지역</th>
						<th>업체명</th>
						<th>주소</th>
						<th>대표전화</th>
						<th>홈페이지</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td data-title="지역">서울</td>
						<td data-title="업체명"><strong class="tit">업체명 01</strong></td>
						<td data-title="주소">서울시 서초구 서초대로 127 혁성빌딩 4층</td>
						<td data-title="대표전화">02-6951-0722</td>
						<td data-title="홈페이지"><a href="javascript:void(0);" class="btn">바로가기</a></td>
					</tr>
					<tr>
						<td data-title="지역">서울</td>
						<td data-title="업체명"><strong class="tit">업체명 01</strong></td>
						<td data-title="주소">서울시 서초구 서초대로 127 혁성빌딩 4층 서울시 서초구 서초대로 127 혁성빌딩 4층</td>
						<td data-title="대표전화">02-6951-0722</td>
						<td data-title="홈페이지"><a href="javascript:void(0);" class="btn">바로가기</a></td>
					</tr>
					<tr>
						<td data-title="지역">서울</td>
						<td data-title="업체명"><strong class="tit">업체명 01</strong></td>
						<td data-title="주소">서울시 서초구 서초대로 127 혁성빌딩 4층 서울시 서초구 서초대로 127 혁성빌딩 4층 서울시 서초구 서초대로 127 혁성빌딩 4층 </td>
						<td data-title="대표전화">02-6951-0722</td>
						<td data-title="홈페이지"><a href="javascript:void(0);" class="btn">바로가기</a></td>
					</tr>
				</tbody>
			</table>
		</div>

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