<!--#include virtual = _lib/common.asp-->
<%
GB_seoTitle = "구매상담·견적 — 더존 ERP 도입 비용 안내 | 아이원소프트뱅크"
GB_seoDescription = "더존 ERP 구매·견적 상담 무료. Amaranth10·WEHAGO·iCUBE G20·OmniEsol·ONE AI 도입 비용 평일 09:00~18:00 무료 안내. 1877-0256."
GB_seoKeywords = "더존ERP구매,ERP견적,ERP도입비용,ERP상담,Amaranth10가격,WEHAGO가격"
%>
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->

	<script type="text/javascript">
	$(document).ready(function(){
		$(document).on("click",".inqSubmitBtn",function(){
			var requiredFlag = true;
			var frm = $(this).closest("form")

			$(this).closest("form").find('.reqField').each(function(){
				itemTitle = $(this).attr("reqTitle")

				if ( $(this).is(':text, textarea, select') && $(this).val().length < 1 ) {
					alert('['+itemTitle+']는 필수 입력항목 입니다.');
					$(this).focus();
					requiredFlag = false;
					return false;
				}else if ( $(this).is(':file') && $(this).val().length < 1 ) {
					alert('['+itemTitle+']는 필수 업로드항목 입니다.');
					requiredFlag = false;
					return false;
				}else if ( $(this).is(':checkbox') ) {
					attrName = $(this).attr("name")
					if($("input:checkbox[name="+attrName+"]:checked").length==0) {
						alert('['+itemTitle+']는 필수 선택항목 입니다.');
						$(this).focus();
						requiredFlag = false;
						return false;
					}
				}else if ( $(this).is(':radio') ) {
					attrName = $(this).attr("name")

					if(!$("input:radio[name="+attrName+"]").is(":checked") == true) {
						alert('['+itemTitle+']는 필수 선택항목 입니다.');
						$(this).focus();
						requiredFlag = false;
						return false;
					}
				};
			});

			if( requiredFlag == true ) {
				var confirmVal = confirm("해당 내용으로 신청하시겠습니까?");
				if (confirmVal){
					frm.submit();
				}
			}

		});
	});

	$(function(){
		var today = new Date();
		var yyyy = today.getFullYear();
		var mm = String(today.getMonth()+1).padStart(2,'0');
		var dd = String(today.getDate()).padStart(2,'0');
		$('#meet_date').attr('min', yyyy+'-'+mm+'-'+dd);
		$('#meet_date').on('change', function(){
			var v = $(this).val();
			if(!v) return;
			var d = new Date(v);
			var day = d.getDay();
			if(day === 0 || day === 6){
				alert('미팅날짜는 영업일(월~금)만 선택 가능합니다.');
				$(this).val('');
				$(this).focus();
			}
		});

		// 미팅방법 선택 시 미팅날짜/시간 노출 + 필수화
		function toggleMeetFields(){
			if($('input[name="note5"]:checked').length > 0){
				$('#meet_date_row, #meet_time_row').show();
				$('#meet_date').addClass('reqField').attr('reqTitle','미팅날짜');
				$('#meet_time').addClass('reqField').attr('reqTitle','미팅시간');
			}else{
				$('#meet_date_row, #meet_time_row').hide();
				$('#meet_date, #meet_time').removeClass('reqField').val('');
			}
		}
		// 라디오 재클릭 시 선택 해제 (토글)
		$('input[name="note5"]').on('click', function(e){
			if($(this).data('wasChecked')){
				$(this).prop('checked', false).data('wasChecked', false);
				toggleMeetFields();
			}else{
				$('input[name="note5"]').data('wasChecked', false);
				$(this).data('wasChecked', true);
				toggleMeetFields();
			}
		});
	});
	</script>

	<style>
		/* 미팅방법 라디오: 선택된 것만 파란 원형 표시 */
		#inqFrm1 .check-new input[type=radio]+label>.graphic:before{opacity:0;}
		#inqFrm1 .check-new input[type=radio]:checked+label>.graphic:before{opacity:1;}
		/* 미팅날짜 input[type=date] 크기·정렬을 주변 텍스트 입력과 통일 */
		#inqFrm1 input[type=date].small{
			height:4.4rem;
			padding:0 1.4rem;
			font-size:1.6rem;
			line-height:1;
			border:1px solid var(--bor_c);
			border-radius:.4rem;
			background-color:#fff;
			min-width:20rem;
			vertical-align:middle;
			box-sizing:border-box;
		}
		#inqFrm1 input[type=date].small::-webkit-calendar-picker-indicator{
			cursor:pointer;
			width:2rem;
			height:2rem;
			margin-left:.6rem;
		}
		#inqFrm1 #meet_date + span{
			font-size:1.4rem;
			margin-left:1rem;
			vertical-align:middle;
		}
		#inqFrm1 select#meet_time.small{
			height:4.4rem;
			font-size:1.6rem;
		}
	</style>
</head>

<body data-pgCode="0301">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">

<form name='inqFrm1' id='inqFrm1' action='/board/ok_bbswrite.asp' method='post' ENCTYPE="multipart/form-data" style='margin:0;' target="bbsActFrame">
<input type='hidden' name='editorYN' value='0'>
<input type="hidden" name='bbscode' id='bbscode' value='2'>
<input type="hidden" name='boardsort' value=''>
<div class="board_write">
	<table>
		<tbody>
			<tr>
				<th scope="row"><span class="">상호(법인명)</span></th>
				<td><input type="text" name="company" maxlength="50" class="small reqField" reqTitle="상호(법인명)" placeholder="" required></td>
			</tr>
			<tr>
				<th scope="row"><span class="">사업자등록번호</span></th>
				<td>
					<input type="text" name="note1" class="small" maxlength="12" reqTitle="" value="" oninput="hypenBizcode(this)" placeholder=""/>
					<span style="color: #0799f0; line-height: 1.3; padding-top: 1rem;">(사업자등록번호를 작성해주시면 더 원활한 상담이 가능합니다.)</span>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">전화번호</span></th>
				<td><input type="text" name="tel" maxlength="50" class="small" reqTitle="" placeholder=""></td>
			</tr>
			<tr>
				<th scope="row"><span class="">팩스번호</span></th>
				<td><input type="text" name="note2" maxlength="50" class="small" reqTitle="" placeholder=""></td>
			</tr>
			<tr>
				<th scope="row"><span class="">담당자명</span></th>
				<td><input type="text" name="writer" maxlength="50" class="small reqField" reqTitle="담당자명" placeholder="" required></td>
			</tr>
			<tr>
				<th scope="row"><span class="">직위</span></th>
				<td><input type="text" name="note3" maxlength="50" class="small" reqTitle="" placeholder=""></td>
			</tr>
			<tr>
				<th scope="row"><span class="">핸드폰번호</span></th>
				<td>
					<div class="flex three">
						<input type="text" name="phone" class="onlyNumber reqField" maxlength="4" reqTitle="핸드폰번호" value="<%=GB_Member_ArrPhone(0)%>" placeholder="" required />
						<span class="type c">-</span>
						<input type="text" name="phone" class="onlyNumber reqField" maxlength="4" reqTitle="핸드폰번호" value="<%=GB_Member_ArrPhone(1)%>" placeholder="" required />
						<span class="type c">-</span>
						<input type="text" name="phone" class="onlyNumber reqField" maxlength="4" reqTitle="핸드폰번호" value="<%=GB_Member_ArrPhone(2)%>" placeholder="" required />
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">이메일</span></th>
				<td>
					<div class="flex three emall">
						<input type="text" name="email" maxlength="25" value="<%=GB_Member_ArrEmail(0)%>" placeholder="" required class="reqField" reqTitle="이메일" />
						<span class="type c">@</span>
						<input type="text" name="email" maxlength="25" value="<%=GB_Member_ArrEmail(1)%>" placeholder="" class="eDomain reqField" required reqTitle="이메일" />
						<!-- <select title="" name="email_domain" class="eDomailSelector">
							<option value="" selected><%=LangPack_SelboxEdomain%></option>
							<%=PT_ComCodeSelect("email","")%>
						</select> -->
					</div>
				</td>
			</tr>

			<tr>
				<th scope="row"><span class="">제품선택</span></th>
				<td>
					<div class="flex check wrap">
						<p class="check-new"><input type="checkbox" id="hirer_04" name="note4" value="Amaranth 10"><label for="hirer_04"><span class="graphic"></span>Amaranth 10</label></p>
						<p class="check-new"><input type="checkbox" id="hirer_01" name="note4" value="WEHAGO(SmartA10)"><label for="hirer_01"><span class="graphic"></span>WEHAGO(SmartA10)</label></p>
						<p class="check-new"><input type="checkbox" id="hirer_05" name="note4" value="그룹웨어"><label for="hirer_05"><span class="graphic"></span>그룹웨어</label></p>
						<p class="check-new"><input type="checkbox" id="hirer_06" name="note4" value="PMS/SI"><label for="hirer_06"><span class="graphic"></span>PMS/SI</label></p>
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">미팅방법</span></th>
				<td>
					<div class="flex check wrap">
						<p class="check-new"><input type="radio" id="meet_way_01" name="note5" value="원격미팅"><label for="meet_way_01"><span class="graphic"></span>원격미팅</label></p>
						<p class="check-new"><input type="radio" id="meet_way_02" name="note5" value="대면미팅"><label for="meet_way_02"><span class="graphic"></span>대면미팅</label></p>
					</div>
				</td>
			</tr>
			<tr id="meet_date_row" style="display:none;">
				<th scope="row"><span class="">미팅날짜</span></th>
				<td>
					<input type="date" name="note6" id="meet_date" class="small" reqTitle="미팅날짜">
					<span style="color:#0799f0; line-height:1.3; padding-top:1rem;">(영업일 기준 월~금만 선택 가능)</span>
				</td>
			</tr>
			<tr id="meet_time_row" style="display:none;">
				<th scope="row"><span class="">미팅시간</span></th>
				<td>
					<select name="note7" id="meet_time" class="small" reqTitle="미팅시간">
						<option value="">시간 선택</option>
						<option value="09:00">09:00</option>
						<option value="10:00">10:00</option>
						<option value="11:00">11:00</option>
						<option value="12:00">12:00</option>
						<option value="13:00">13:00</option>
						<option value="14:00">14:00</option>
						<option value="15:00">15:00</option>
						<option value="16:00">16:00</option>
						<option value="17:00">17:00</option>
						<option value="18:00">18:00</option>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">문의내용</span></th>
				<td><textarea name="content" class="reqField" reqTitle="문의내용"></textarea></td>
			</tr>

			<tr>
				<th scope="row">첨부파일</th>
				<td>
					<div class="fileArea">
						<!-- <a href="javascript:void(0);" class="filePlus"><span>파일추가</span></a> -->
						<div class="file">
							<span class="file_wrap">
								<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부"/></span>
							</span>
							<a class="thumb"></a>
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

<div class="clauseArea">
	<p class="tit">개인정보처리방침</p>
	<div class="scroll">
		<!--#include virtual = /common/include/privacy.asp-->
	</div>
	<p class="check-new"><input type="checkbox" id="privacy_check" name="privacy_check" value="" class="reqField" reqTitle="개인정보처리방침 동의" ><label for="privacy_check"><span class="graphic"></span>개인정보처리방침에 동의합니다.</label></p>
</div>

<div class="board_btn long">
	<a href="javascript:void(0);" class="click inqSubmitBtn">문의하기</a>
</div>
</form>
<iframe name='bbsActFrame' frameborder='0' width='100%' height='100' class="disNone"></iframe>

	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<script type="text/javascript">
	$(function () {
	});
</script>
</body>
</html>