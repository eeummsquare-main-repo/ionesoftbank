<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0502">

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
						<th scope="row"><span class="">이름</span></th>
						<td><input type="text" name="" value="" id="" class="small" required placeholder="이름"></td>
					</tr>
					<tr>
						<th scope="row"><span class="">연락처</span></th>
						<td>
							<div class="flex three">
								<select name="" id="" required>
									<option value="010" selected="selected">010</option>
									<option value="02">02</option>
									<option value="031">031</option>
									<option value="032">032</option>
									<option value="033">033</option>
									<option value="041">041</option>
									<option value="042">042</option>
									<option value="043">043</option>
									<option value="051">051</option>
									<option value="052">052</option>
									<option value="053">053</option>
									<option value="054">054</option>
									<option value="055">055</option>
									<option value="061">061</option>
									<option value="062">062</option>
									<option value="063">063</option>
									<option value="064">064</option>
									<option value="070">070</option>
									<option value="0505">0505</option>
								</select>
								<span class="type">-</span>
								<input type="text" name="" id="" value="" placeholder="" required />
								<span class="type">-</span>
								<input type="text" name="" id="" value="" placeholder="" required />
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="">이메일</span></th>
						<td>
							<div class="flex three emall">
								<input type="text" name="wr_email[]" id="wr_email_1" value="" placeholder="" required >
								<span class="type c">@</span>
								<input type="text" name="wr_email[]" id="wr_email_2" value="" placeholder="" required >
								<select name="email_addr">
									<option value="">직접입력</option>
									<option value="chollian.net">chollian.net</option>
									<option value="dreamwiz.com">dreamwiz.com</option>
									<option value="empal.com">empal.com</option>
									<option value="freechal.com">freechal.com</option>
									<option value="gmail.com">gmail.com</option>
									<option value="hanmail.net">hanmail.net</option>
									<option value="hotmail.com">hotmail.com</option>
									<option value="hanafos.com">hanafos.com</option>
									<option value="kebi.com">kebi.com</option>
									<option value="korea.com">korea.com</option>
									<option value="lycos.co.kr">lycos.co.kr</option>
									<option value="nate.com">nate.com</option>
									<option value="naver.com">naver.com</option>
									<option value="netian.com">netian.com</option>
									<option value="paran.com">paran.com</option>
									<option value="yahoo.co.kr">yahoo.co.kr</option>
								</select>
							</div>
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
								<!-- <a href="javascript:void(0);" class="filePlus"><span>파일추가</span></a> -->
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="upfile" title="파일첨부"/></span>
									</span>
									<a class="thumb"></a>
								</div>
								<!--
								<div class="file">
									<span class="file_wrap">
										<span class="btnFile">파일첨부<input type="file" name="upfile" title="파일첨부"/></span>
									</span>
									<a class="thumb text">파일명~파일명~파일명~파일명~파일명~파일명~파일명~파일명~파일명~파일명~</a>
									<p class="check-new"><input type="checkbox" id="delAuthchk_" name="delchk" value="1" class="bbsFileFieldChk"><label for="delAuthchk_"><span class="graphic"></span>삭제</label></p>
								</div>
								 -->
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

		<!-- [s] 개인정보처리방침 -->
		<div class="clauseArea">
			<p class="tit">개인정보처리방침</p>
			<div class="scroll">
				<!--#include virtual = /common/include/privacy.asp-->
			</div>
			<p class="check-new"><input type="checkbox" id="privacy_check" name="privacy_check" value=""><label for="privacy_check"><span class="graphic"></span>개인정보처리방침에 동의합니다.</label></p>
		</div>
		<!-- [e] 개인정보처리방침 -->

		<div class="board_btn long">
			<a href="javascript:void(0);" class="click">문의하기</a>
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