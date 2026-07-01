<!--#include virtual = _lib/common.asp-->
<!DOCTYPE html>
<html lang="ko" class="sub">

<head>
    <!--#include virtual=common/include/head.asp-->
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">
	$(document).ready(function(){
		/*var chkdEa = 0;
		$(".max_chk_3 input:checkbox").on("change", function(){
			chkdEa = $(".max_chk_3 input:checkbox:checked").length

			if(chkdEa > 3){
				alert("최소 1개, 최대 3개 선택 가능 합니다.");
				$(this).attr("checked", false);
			}
		});*/

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

			/*if( requiredFlag == true ) {
				chkdEa = $(".max_chk_3 input:checkbox:checked").length
				if (chkdEa < 1 || chkdEa > 3) {
					alert("체험하시려는 모듈을 선택해주세요.\n최소 1개, 최대 3개 선택 가능 합니다.");
					requiredFlag = false;
					return false;
				}
			}*/
			if( requiredFlag == true ) {
				var confirmVal = confirm("해당 내용으로 신청하시겠습니까?");
				if (confirmVal){
					frm.submit();
				}
			}

		});
	});
	</script>
</head>

<body data-pgCode="0305">

    <!--[s] Skip To Content -->
    <a href="#contents" class="skip">&raquo; 본문 바로가기</a>
    <!--[e] Skip To Content -->

    <div id="wrap">
        <!--#include virtual=common/include/header.asp-->
        <!--#include virtual=common/include/subTop.asp-->

        <div id="container">

<% IF GB_binqTopimgNm<>"" Then %>
<div class="img_box" style="margin-bottom:3rem"><img src="/upload/<%=GB_binqTopimgNm%>" alt=""></div>
<% End IF %>

<form name='inqFrm1' id='inqFrm1' action='/board/ok_bbswrite.asp' method='post' ENCTYPE="multipart/form-data" style='margin:0;' target="bbsActFrame">
<input type='hidden' name='editorYN' value='0'>
<input type="hidden" name='bbscode' id='bbscode' value='9'>
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
					<input type="text" name="note1" class="small reqField" maxlength="12" reqTitle="사업자등록번호" value="" oninput="hypenBizcode(this)" placeholder="" required />
					<span style="color: #0799f0; line-height: 1.3; padding-top: 1rem;">(사업자등록번호를 작성해주시면 더 원활한 상담이 가능합니다.)</span>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">담당자명</span></th>
				<td><input type="text" name="writer" maxlength="50" class="small reqField" reqTitle="담당자명" placeholder="" required></td>
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
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">주소</span></th>
				<td>
					<div class="flex">
						<input type="text" name="note2" maxlength="5" value="" id="postcode" title="우편번호" class="small reqField" required reqTitle="우편번호">
						<a href="javascript:zipcodeck('postcode','addr','addr2');" class="btns">주소검색</a>
					</div>
					<div class="flex juso">
						<input type="text" name="note3" maxlength="50" value="" id="addr" placeholder="주소" class="reqField" required reqTitle="주소">
						<input type="text" name="note4" maxlength="50" value="" id="addr2" placeholder="상세주소">
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">현 ERP 정보</span></th>
				<td><input type="text" name="note5" maxlength="50" value="" id="" class="small" placeholder=""></td>
			</tr>
			<!-- <tr>
				<th scope="row"><span class="">모듈</span></th>
				<td>
					<strong style="color:#111; background:url('/images/require.png') no-repeat right top; padding-right:2rem">체험하시려는 모듈을 선택해주세요.</strong>
					<p class="mb-10">3개까지 복수선택 가능, (*UC 모듈은 공통 적용됩니다.)</p>
					<div class="flex check wrap max_chk_3" style="padding:1rem 0">
						<p class="check-new"><input type="checkbox" id="kinds_01" name="note6" value="회계" required><label for="kinds_01"><span class="graphic"></span>회계</label></p>
						<p class="check-new"><input type="checkbox" id="kinds_02" name="note6" value="인사" required><label for="kinds_02"><span class="graphic"></span>인사</label></p>
						<p class="check-new"><input type="checkbox" id="kinds_03" name="note6" value="생산" required><label for="kinds_03"><span class="graphic"></span>생산</label></p>
						<p class="check-new"><input type="checkbox" id="kinds_04" name="note6" value="물류" required><label for="kinds_04"><span class="graphic"></span>물류</label></p>
						<p class="check-new"><input type="checkbox" id="kinds_05" name="note6" value="기타" required><label for="kinds_05"><span class="graphic"></span>기타</label></p>
					</div>
					<span style="color: #0799f0; line-height: 1.3; padding-top: 1rem;">최소 1개, 최대 3개 선택 가능</span>
				</td>
			</tr> -->
		</tbody>
	</table>
</div>
<!-- 폼 자료 : https://form.naver.com/response/VxRYDLpFdqFzhnSPWEqB_A -->

<!-- [s] 개인정보처리방침 -->
<div class="clauseArea">
	<p class="tit">개인정보처리방침</p>
	<div class="scroll">
		<!--#include virtual = /common/include/privacy.asp-->
	</div>
	<p class="check-new"><input type="checkbox" id="privacy_check" name="privacy_check" value="" class="reqField" reqTitle="개인정보처리방침 동의" ><label for="privacy_check"><span class="graphic"></span>개인정보처리방침에 동의합니다.</label></p>
</div>
<!-- [e] 개인정보처리방침 -->

<div class="board_btn long">
	<a href="javascript:void(0);" class="click inqSubmitBtn">문의하기</a>
</div>
</form>
<iframe name='bbsActFrame' frameborder='0' width='100%' height='100' class="disNone"></iframe>

        </div>
        <!--#include virtual=common/include/footer.asp-->
    </div>
</body>
</html>