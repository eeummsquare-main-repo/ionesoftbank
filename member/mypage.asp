<!-- #include virtual = _lib/common.asp -->
<!--#include virtual = _lib/dbcon.asp-->
<% HK_returnURL="/member/mypage.asp" %>
<!--#include virtual = _lib/sessionchk.asp-->
<%
Sql="Select id, pwd, name, zipcode, addr1, addr2, tel, phone, email, filename, EmailYN, Memsort, smsYN, birthday, sex, isAuth, note1, note2, naverAuthKey, kakaoAuthKey, fbAuthKey, company, nickname, bizcode From Members Where idx="&Session("useridx")
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	id=ReplaceTextField(Rs("id"))
	name=ReplaceTextField(Rs("name"))
	Zip=Rs("zipcode") : addr1=ReplaceTextField(Rs("addr1"))
	addr2=ReplaceTextField(Rs("addr2")) : tel=Split(Rs("tel"),"-")
	phone=Split(Rs("phone"),"-") : email=ReplaceTextField(Rs("email"))
	filename=Rs("filename")
	EmailYN=Rs("EmailYN")
	smsYN=Rs("smsYN")
	Memsort=Rs("memsort")
	birthday=ReplaceTextField(Rs("birthday"))
	sex=ReplaceTextField(Rs("sex"))
	isAuth=Rs("isAuth")
	note1=ReplaceTextField(Rs("note1"))
	note2=ReplaceTextField(Rs("note2"))
	naverAuthKey=Rs("naverAuthKey")
	kakaoAuthKey=Rs("kakaoAuthKey")
	fbAuthKey=Rs("fbAuthKey")
	company=ReplaceTextField(Rs("company"))
	nickname=ReplaceTextField(Rs("nickname"))
	bizcode=ReplaceTextField(Rs("bizcode"))

	DB_ID = Rs("id")
	DB_NAME = Rs("name")
	EmailStr = Split(email,"@")

	IF Ubound(tel)<2 Then ReDim tel(2)
	IF Ubound(phone)<2 Then ReDim phone(2)
	IF Ubound(EmailStr)<1 Then ReDim EmailStr(1)
Else
	Response.Write ExecJavaAlert("",0)
	Response.END
End IF

Set MemberRec=Nothing
DBcon.Close
Set DBcon=Nothing
%>
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
	<link rel="stylesheet" type="text/css" href="/common/css/member.css" />

	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">
	$(window).load(function(){
		$('.emailChk').change(function(){
			$("#isEmailDupChk").val(0)

			if ($(".emailChk").eq(0).val()!="" && $(".emailChk").eq(1).val()!=""){
				strID = $(".emailChk").eq(0).val() + "@" + $(".emailChk").eq(1).val();
				var params = "id="+strID;
				$.ajax({type:"POST", url:"/_proc/emailDubChk.asp",data:params,dataType:"html"
				}).done(function(msg){
					if(msg=="useY"){
						$("#emailMsg").html("");
						$("#isEmailDupChk").val(1)
					}else if(msg=="useN"){
						$("#emailMsg").html("<div class='mt10'>이미 사용중인 Email입니다.</div>");
					}else{
						$("#emailMsg").html("<div class='mt10'>"+msg+"</div>");
					}
				});
			}else{
				$("#emailMsg").html("");
			}
		});
	});

	function sendit(){
		var Join=document.Join;

		if (Join.bizcode.value==""){
			alert("사업자번호를 입력하여 주세요.");
			Join.bizcode.focus();
			return;
		}
		if ( !checkCorporateRegiNumber(Join.bizcode.value) ){
			alert("올바른 사업자 번호를 입력해주세요.");
			return;
		}
		if (Join.company.value==""){
			alert("회사명을 입력하여 주세요.");
			Join.company.focus();
			return;
		}
		if (Join.passwd.value==""){
			alert("비밀번호를 입력하여 주십시요.");
			Join.passwd.focus();
			return;
		}
		if (checkPassword(Join.passwd.value, "") == false){
			Join.passwd.focus();
			return;
		}
		if (Join.passwd_check.value==""){
			alert("비밀번호 확인을 입력하여 주십시요.");
			Join.passwd_check.focus();
			return;
		}
		if (Join.passwd.value!==Join.passwd_check.value){
			alert("비밀번호가 일치하지 않습니다. 다시 입력하여 주십시요.");
			Join.passwd.focus();
			return;
		}

		//if( (Join.phone[0].value + Join.phone[1].value + Join.phone[2].value).length !=0 ){
			if(Join.phone[0].value==""){
				alert("연락처를 입력하세요.");
				Join.phone[0].focus();
				return;
			}
			if(Join.phone[1].value==""){
				alert("연락처를 입력하세요.");
				Join.phone[1].focus();
				return;
			}
			if(Join.phone[2].value==""){
				alert("연락처를 입력하세요.");
				Join.phone[2].focus();
				return;
			}
		//}

		var emailChk
		if(Join.email[0].value==""){
			alert("이메일을 입력하세요");
			Join.email[0].focus();
			return;
		}
		if(Join.email[1].value==""){
			alert("이메일을 입력하세요");
			Join.email[1].focus();
			return;
		}
		emailChk = isValidEmail( Join.email[0].value, Join.email[1].value )

		if (emailChk){
			alert(emailChk)
			return;
		}

		//popupLoadingOpen();
		Join.target="iframes";
		Join.submit();
	}

	function withdrawal(){
		var val = confirm("회원탈퇴를 하시면 재사용 및 복구가 불가능합니다.\n탈퇴를 하시겠습니까?");
		if (val){
			location.href="../member/outOK.asp"
		}
	}
	</SCRIPT>
</head>

<body data-pgCode="1101" data-pgTitle="">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container" class="f0">

<form name='Join' method='post' action='joinProc.asp?sort=2' enctype="multipart/form-data" onsubmit="sendit(); return false;" target="iframes">
<input type='hidden' name='isEmailDupChk' id="isEmailDupChk" value="0">
<input type='hidden' name='isIDDupChk' id="isIDDupChk" value="0">
<input type='hidden' name='memsort' id="memsort" value="<%=memsort%>">
<div class="board_write">
	<table>
		<tbody>
			<tr>
				<th scope="row"><span class="">아이디</span></th>
				<td>
					<%=DB_ID%>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">비밀번호</span></th>
				<td>
					<input type="password" title="비밀번호" name="passwd" maxlength="15" class="small" required /><br>
					<p class="type b">* 영문과 숫자를 조합하여 6~15자리로 만들어 주세요, 첫글자는 영문으로 입력해 주세요</p>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">비밀번호 확인</span></th>
				<td>
					<input type="password" title="비밀번호확인" name="passwd_check" maxlength="15" class="small" required />
				</td>
			</tr>

			<tr>
				<th scope="row"><span class="">사업자번호</span></th>
				<td>
					<input type="text" name="bizcode" class="small" maxlength="12" reqTitle="" value="<%=ReplaceTextFIeld(bizcode)%>" oninput="hypenBizcode(this)" placeholder="" required/>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">회사명</span></th>
				<td>
					<input type="text" name="company" class="small" maxlength="50" reqTitle="" value="<%=ReplaceTextFIeld(company)%>" placeholder="" required/>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">이름</span></th>
				<td><%=DB_NAME%></td>
			</tr>
			<tr>
				<th scope="row"><span class="">연락처</span></th>
				<td>
					<div class="flex three">
						<input type="text" class="onlyNumber" title="연락처 첫번째 자리 입력" name="phone" maxlength="4" value="<%=phone(0)%>" required />
						<span class="type c">-</span>
						<input type="text" class="onlyNumber" title="연락처 가운데 자리 입력" name="phone" maxlength="4" value="<%=phone(1)%>" required />
						<span class="type c">-</span>
						<input type="text" class="onlyNumber" title="연락처 가운데 자리 입력" name="phone" maxlength="4" value="<%=phone(2)%>" required />
					</div>

					<!-- <div class="flex wrap">
						<div class="three phone gap1">
							<input type="text" name="wr_10[]" id="wr_10_1" value="" placeholder="" class="next"
								oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
								maxlength="4">
							<span class="type c">-</span>
							<input type="text" name="wr_10[]" id="wr_10_2" value="" placeholder="" required=""
								class="next required"
								oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
								maxlength="4">
							<span class="type c">-</span>
							<input type="text" name="wr_10[]" id="wr_10_3" value="" placeholder="" required=""
								class="next required"
								oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
								maxlength="4">
						</div>
						<a class="btn mini" href="">인증 후 휴대폰 번호 수정</a>
						<div class="type">* 휴대폰 번호가 바뀐 경우에는 본인인증 후 새로운 번호로 저장 가능합니다.</div>
					</div> -->
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">이메일</span></th>
				<td>
					<div class="flex three emall">
						<input type="text" title="이메일주소입력" name="email" maxlength="25" class="emailChk" required value="<%=EmailStr(0)%>" />
						<span class="type c">@</span>
						<input type="text" class="eDomain emailChk" title="이메일 도메인 입력" name="email" maxlength="25" required value="<%=EmailStr(1)%>" />
						<select class="eDomailSelector">
							<option value="" selected>직접입력</option>
							<%=PT_ComCodeSelect("email","")%>
						</select>
					</div>
					<p class="type b" id="emailMsg"></p>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">주소</span></th>
				<td>
					<div class="flex" onclick="openDaumPostcode();">
						<input type="text" name="zip" id="zip" id="postcode" title="우편번호" class="middle" readonly value="<%=zip%>">
						<a href="javascript:zipcodeck('zip','addr1','addr2');" class="btns">주소검색</a>
					</div>
					<div class="flex juso">
						<input type="text" name="addr1" id="addr1" maxlength="50" placeholder="주소" class="" value="<%=addr1%>">
						<input type="text" name="addr2" id="addr2" maxlength="50" placeholder="상세주소" value="<%=addr2%>">
					</div>
				</td>
			</tr>

			<tr>
				<th scope="row"><span class="">공지알림 (선택)</span></th>
				<td>
					<div class="alert flex">
						<dl class="flex">
							<dt>이메일 수신</dt>
							<dd class="checkBox">
								<p class="check-new"><input type="radio" name="EmailYN" id="form_email_y" value="1" checked><label for="form_email_y"><span class="graphic"></span>수신</label></p>
								<p class="check-new"><input type="radio" name="EmailYN" id="form_email_n" value="0" <%=iif_compare(0, EmailYN, "checked")%>><label for="form_email_n"><span class="graphic"></span>미수신</label></p>
							</dd>
						</dl>
					</div>
					<p class="type star mt">주요공지를 위해 이메일 알람 설정은 '수신 허용'으로 설정됩니다.</p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</form>
<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>

<div class="board_btn center">
	<!-- <a href="javascript:history.back();" class="click big delete">취소하기</a> -->
	<a href="javascript:sendit()" class="click big">수정하기</a>
	<a class="click big delete btn_logout">로그아웃</a>
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