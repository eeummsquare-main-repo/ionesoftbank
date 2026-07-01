<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0601">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<div class="board_write">
			<table>
				<tbody>
					<tr>
						<th scope="row"><span class="">분류</span></th>
						<td>
							<select name="" id="" required class="small">
								<option value="">분류를 선택하세요</option>
								<option value="분류1">직장백서</option>
								<option value="분류2">꿀팁 대방출</option>
								<option value="분류3">궁굼해요</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="">제목</span></th>
						<td><input type="text" name="wr_subject" value="" id="wr_subject" required maxlength="255" placeholder="제목"></td>
					</tr>
					<tr>
						<th scope="row"><span class="">내용</span></th>
						<td><textarea id="wr_content" name="wr_content" class="" ></textarea></td>
					</tr>

					<tr>
						<th scope="row">첨부파일</th><!-- 수정했음! -->
						<td>
							<div class="fileArea">
								<a href="javascript:void(0);" class="filePlus"><span>파일추가</span></a>
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="upfile" title="파일첨부"/></span>
									</span>
									<a class="thumb"></a>
								</div>
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="upfile" title="파일첨부"/></span>
									</span>
									<a class="thumb text">파일명~파일명~파일명~파일명~파일명~파일명~파일명~파일명~파일명~파일명~</a>
									<p class="check-new"><input type="checkbox" id="delAuthchk_" name="delchk" value="1" class="bbsFileFieldChk"><label for="delAuthchk_"><span class="graphic"></span>삭제</label></p>
								</div>
							</div>
						</td>
					</tr>

					<script type="text/javascript">
					$(window).load(function(){
						$("body").on("change", ".board_write input[type='file']", function(e){
							var idx = $(".board_write input[type='file']").index($(this));
							var tit = $(this).val();
							$(".board_write .thumb").eq(idx).find(".over").detach();
							$(".board_write .thumb").eq(idx).attr("style","").removeClass("text");
							if (window.File) {
								var input = $(".board_write input[type='file']").get(idx).files[0];
								var reader = new FileReader();
								$(reader).on('load', function(e) {
									if(this.result.indexOf('image') == 5){
										$(".board_write .thumb").eq(idx).attr("title", tit).css('background-image', "url('"+this.result+"')").append('<span class="over" style="background-image:url('+this.result+');"></span>');
									}else{
										$(".board_write .thumb").eq(idx).attr("title", tit).addClass("text").html(tit);
									}
								});
								reader.readAsDataURL(input);
							}
						});
					});
				</script>
				</tbody>
			</table>
		</div>

		<div class="board_btn long">
			<a href="javascript:void(0);" class="click">등록</a>
		</div>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<link rel="stylesheet" type="text/css" href="/build/jquery.datetimepicker.css"/>
<script src="/build/jquery.datetimepicker.full.min.js"></script>
<script>
	$.datetimepicker.setLocale('ko');
	$('.datetimepicker').datetimepicker({
		format: 'Y-m-d',
		timepicker:false
	});
</script>
<script type="text/javascript">
	$(function () {
	});
</script>
</body>
</html>