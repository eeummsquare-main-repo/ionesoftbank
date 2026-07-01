<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0105">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<div class="board_view">
			<table>
				<thead>
				<tr>
					<th>
						<div class="view_title">현대해상</div>

						<div class="view_info">
							<div class="view_txt">
								<p class="txt"><strong>작성일</strong>&nbsp;2023.03.07</p>
								<p class="txt"><strong>조회수</strong> &nbsp;97</p>
							</div>
						</div>
					</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td class="view_cont">
						<!-- 본문 내용 시작 { -->
						<div id="bo_v_con">
							234234234234
						</div>
						<!-- } 본문 내용 끝 -->

						<div class="view_file">
							<a href="javascript:void(0);">첨부파일.gif</a>
						</div>
					</td>
				</tr>
				</tbody>
			</table>
		</div>

		<div class="board_btn end">
			<a href="javascript:void(0);" class="click cancel">삭제</a>
			<a href="conmment_write.asp" class="click point">수정</a>
			<a href="conmment.asp" class="click">목록</a>
		</div>

		<!-- 댓글 시작 { -->
		<div class="comment_Area">
			<p class="comment_title"><i class="fa fa-comments-o" aria-hidden="true"></i> <strong>댓글</strong> (1)</p>
			<div class="comment_write">
				<div class="top">
					<input type="text" name="wr_name" value="" id="wr_name" required class="frm_input required" size="25" placeholder="이름">
					<input type="password" name="wr_password" id="wr_password" required class="frm_input required" size="25" placeholder="비밀번호">
					<p class="check-new">
						<input type="checkbox" name="wr_secret" value="secret" id="wr_secret" />
						<label for="wr_secret"><span class="graphic"></span>비밀글</label>
					</p>
				</div>
				<div class="btm">
					<textarea id="wr_content" name="wr_content" required title="댓글을 입력해주세요." placeholder="댓글을 입력해주세요."></textarea>
					<button type="submit" id="btn_submit" class="btn_submit">댓글등록</button>
				</div>
			</div>

			<div class="comment_list">
				<dl>
					<dt>asdfasdf</dt>
					<dd>
						<p><span class="guest">테스트</span></p>
						<p>2023.08.08 15:53:00</p>

						<div class="comment_option">
							<a href="javascript:void(0);"><span>수정</span></a>
							<a href="javascript:void(0);"><span>삭제</span></a>
						</div>
					</dd>
				</dl>

				<dl class="no_comment">
					<dt>등록된 댓글이 없습니다.</dt>
				</dl>
			</div>
		</div>
		<!-- } 댓글 끝 -->
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<script type="text/javascript">
	$(function () {
	});
</script>
</body>
</html>