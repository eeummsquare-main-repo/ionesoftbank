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
		<div class="board_write">
			<table>
				<tbody>
					<tr>
						<th scope="row"><span class="">분류</span></th>
						<td>
							<select name="" id="" required class="small">
								<option value="">분류를 선택하세요</option>
								<option value="분류1">분류1</option>
								<option value="분류2">분류2</option>
								<option value="분류3">분류3</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="">중복검사</span></th>
						<td>
							<div class="flex">
								<input type="text" name="" value="" id="" class="small" required placeholder="아이디">
								<a href="javascript:void(0);" class="btns">중복검사</a>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="">체크박스</span></th>
						<td>
							<div class="flex check wrap">
								<p class="check-new"><input type="checkbox" id="kinds_01" name="1" value="오피스"><label for="kinds_01"><span class="graphic"></span>오피스</label></p>
								<p class="check-new"><input type="checkbox" id="kinds_02" name="1" value="판매시설"><label for="kinds_02"><span class="graphic"></span>판매시설</label></p>
								<p class="check-new"><input type="checkbox" id="kinds_03" name="1" value="물류시설"><label for="kinds_03"><span class="graphic"></span>물류시설</label></p>
								<p class="check-new"><input type="checkbox" id="kinds_04" name="1" value="기타"><label for="kinds_04"><span class="graphic"></span>기타</label></p>
								<p class="type">※ 중복 선택 가능</p>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="">라디오박스</span></th>
						<td>
							<div class="flex check wrap">
								<p class="check-new"><input type="radio" id="hirer_01" name="2" value="대기업"><label for="hirer_01"><span class="graphic"></span>대기업</label></p>
								<p class="check-new"><input type="radio" id="hirer_02" name="2" value="중소기업"><label for="hirer_02"><span class="graphic"></span>중소기업</label></p>
								<p class="check-new"><input type="radio" id="hirer_03" name="2" value="프렌차이즈"><label for="hirer_03"><span class="graphic"></span>프렌차이즈</label></p>
								<p class="check-new flex"><input type="radio" id="hirer_04" name="2" value="기타"><label for="hirer_04"><span class="graphic"></span>기타</label><input type="text" id="" name="" value="" placeholder=""></p>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="">성함</span></th>
						<td><input type="text" name="" value="" id="" required class="small" placeholder="이름"></td>
					</tr>
					<tr>
						<th scope="row"><span class="">일자</span></th>
						<td><input type="text" name="" value="" id="" required class="datetimepicker small" placeholder="" readonly="readonly"></td>
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
						<th scope="row"><span class="">생년월일</span></th>
						<td>
							<div class="flex three day">
								<select name="wr_" id="wr_">
									<option value="">년 선택</option>
								</select>
								<span class="type l">년</span>
								<select name="wr_" id="wr_">
									<option value="">월 선택</option>
								</select>
								<span class="type l">월</span>
								<select name="wr_" id="wr_">
									<option value="">일 선택</option>
								</select>
								<span class="type l">일</span>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><span class="">주소</span></th>
						<td>
							<div class="flex" onclick="openDaumPostcode();">
								<input type="text" name="zip1" value="" id="postcode" title="우편번호" required class="small">
								<a href="javascript:void(0);" class="btns">주소검색</a>
							</div>
							<div class="flex juso">
								<input type="text" name="addr1" value="" id="addr" placeholder="주소" class="">
								<input type="text" name="addr2" value="" id="addr2" placeholder="상세주소">
							</div>
							<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
							<script charset="UTF-8" type="text/javascript" src="//t1.daumcdn.net/postcode/api/core/221018/1666013742754/221018.js"></script>
							<script>
								function openDaumPostcode() {
									new daum.Postcode({
										oncomplete: function(data) {
											// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

											// 각 주소의 노출 규칙에 따라 주소를 조합한다.
											// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
											var fullAddr = ''; // 최종 주소 변수
											var extraAddr = ''; // 조합형 주소 변수

											// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
											if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
												fullAddr = data.roadAddress;

											} else { // 사용자가 지번 주소를 선택했을 경우(J)
												fullAddr = data.jibunAddress;
											}

											// 사용자가 선택한 주소가 도로명 타입일때 조합한다.
											if(data.userSelectedType === 'R'){
												//법정동명이 있을 경우 추가한다.
												if(data.bname !== ''){
													extraAddr += data.bname;
												}
												// 건물명이 있을 경우 추가한다.
												if(data.buildingName !== ''){
													extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
												}
												// 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
												fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
											}

											// 우편번호와 주소 정보를 해당 필드에 넣는다.
											document.getElementById('postcode').value = data.zonecode; //5자리 새우편번호 사용
											document.getElementById('addr').value = fullAddr;

											// 커서를 상세주소 필드로 이동한다.
											document.getElementById('addr2').focus();
										}
									}).open();
								}
							</script>
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