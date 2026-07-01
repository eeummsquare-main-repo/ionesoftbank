<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0102">

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

		<div class="board_list">
			<table>
				<colgroup>
					<col width="10%">
					<col width="*">
					<col width="12%">
					<col width="10%">
				</colgroup>
				<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">제목</th>
					<th scope="col">작성일</th>
					<th scope="col">파일</th>
				</tr>
				</thead>
				<tbody>
					<tr class="notis">
						<td class="td_num2">공지</td>
						<td class="td_subject"><a href="dataroom_view.asp">공지사항 제목이 들어갑니다. 공지사항 제목이 들어갑니다. 공지사항 제목이 들어갑니다. 공지사항 제목이 들어갑니다.</a></td>
						<td class="btm">2023.04.27</td>
						<td class="btm file"><a href="javascript:void(0);"><i class="fa fa-floppy-o" aria-hidden="true"></i></a></td>
					</tr>
					<tr>
						<td class="td_num2">9</td>
						<td class="td_subject"><a href="dataroom_view.asp">공지사항 제목이 들어갑니다.</a></td>
						<td class="btm">2023.04.27</td>
						<td class="btm file"><a href="javascript:void(0);"><i class="fa fa-floppy-o" aria-hidden="true"></i></a></td>
					</tr>


					<tr class="noPost"><td colspan="4">게시물이 없습니다.</td></tr>
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
</script>
</body>
</html>