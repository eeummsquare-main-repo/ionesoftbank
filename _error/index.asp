<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<style>
    #pageTop{display: none;}
    #container.full{padding: 0;}
</style>

<body data-pgCode="0000" data-pgTitle="">

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<div id="container" class="landscape">
		<div id="contents">
			<p style="padding:230px 0 50px; text-align:center;">
				<img src="/_lib/images/404_not_found.png" alt="">
			</p>
			<p style="font-size:36px; text-align:center;">요청하신 페이지를 찾을 수 없습니다.</p>
			<div style="padding:30px 0 50px; font-size:16px; text-align:center; line-height:20px;">
				<p>방문하시려는 페이지의 주소가 잘못 입력되었거나,<br>
					일시적인 문제로 접근 할 수 없습니다..<br>
				</p>
				<p style="padding:10px 0 50px">입력하신 페이지의 주소가 정확한지 다시 한 번 확인해 주시기 바랍니다.</p>
			</div>
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