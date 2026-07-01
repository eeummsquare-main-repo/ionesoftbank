<!-- #include virtual = _lib/common.asp -->
<%
'IF Session("cp_Di")="" OR Session("cp_uName")="" OR Session("cp_Mobile")="" Then
'	strLocation = "register.asp"
'	Response.Write ExecJavaalert("본인인증 오류!",2)
'	Response.END
'End IF

'cpMobile = addHyphen(Session("cp_Mobile"))
'arr_cpMobile = Split(cpMobile, "-")
'Response.Write Session("cp_Di")&"<br>"
'Response.Write Session("cp_birthDate")&"<br>"
'Response.Write Session("cp_gender")&"<br>"
'Response.Write Session("cp_Mobile")&"<br>"
'Response.Write Session("cp_uName")&"<br>"

Dim arr_cpMobile(2)

memsort = uf_getRequestProc(Request("memsort"),"int","1","0")
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

	function ID_chk() {
		$("#isIDDupChk").val(0)
		var ID = eval(Join.userid);
		strID=ID.value;
		if (strID!=""){
			var params = "id="+strID;
			$.ajax({type:"POST", url:"/_proc/idDubCheck.asp",data:params,dataType:"html"
			}).done(function(msg){
				if(msg=="useY"){
					$("#idMsg").html("사용가능한 ID입니다.");
					$("#isIDDupChk").val(1)
				}else if(msg=="useN"){
					$("#idMsg").html("이미 사용중인 ID입니다.");
				}else{
					$("#idMsg").html(msg);
				}
			});
		}
	}

      function checkBrn() {
        var brn = document.getElementById( "brn" ).value;
        if ( /^[0-9]{3}-[0-9]{2}-[0-9]{5}$/.test( brn ) ) {
          document.getElementById( "checkBrnMessage" ).innerText = "OK";
        } else {
          document.getElementById( "checkBrnMessage" ).innerText = "NOT OK";
        }
      }

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

		if (Join.userid.value==""){
			alert("ID 를 입력하여 주세요.");
			Join.userid.focus();
			return;
		}
		var idReg = /[^a-z0-9_]/gi;
		if( idReg.test( Join.userid.value ) ) {
			alert("아이디는 영문 혹은 영문, 숫자 혼합(6~15자이내), 특수문자(_)만 사용가능 합니다.");
			Join.userid.focus();
			return;
		}
		if (Join.userid.value.length < 6 || Join.userid.value.length > 15) {
			alert("아이디는 6~15자리입니다.");
			Join.userid.focus();
			return;
		}
		if ($("#isIDDupChk").val()=="0"){
			alert("이미 사용중인 아이디입니다.\n다른 아이디를 입력해주세요.");
			return;
		}
		if (Join.passwd.value==""){
			alert("비밀번호를 입력하여 주십시요.");
			Join.passwd.focus();
			return;
		}
		if (checkPassword(Join.passwd.value, Join.userid.value) == false){
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
		if(Join.name.value==""){
			alert("이름을 입력하세요.");
			Join.name.focus();
			return;
		}

//		if( (Join.phone[0].value + Join.phone[1].value + Join.phone[2].value).length !=0 ){
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
//		}

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

		if ($("#isEmailDupChk").val()=="0"){
			alert("이미 사용중인 이메일입니다.\n다른 이메일주소를 입력해주세요.");
			return;
		}

		//popupLoadingOpen();
		var val = confirm("입력하신 정보로 회원가입 신청하시겠습니까?")
		if (val){
			Join.target="iframes";
			Join.submit();
		}
	}
	</SCRIPT>
</head>

<body data-pgCode="1003" data-pgTitle="MEMBERSHIP">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container" class="f0">

<form action="joinProc.asp" method="post" name="Join" enctype="multipart/form-data" onsubmit="sendit();return false;" target="iframes">
<input type='hidden' name='isEmailDupChk' id="isEmailDupChk" value="0">
<input type='hidden' name='isIDDupChk' id="isIDDupChk" value="0">
<input type='hidden' name='memsort' id="memsort" value="<%=memsort%>">
<div class="board_write">
	<table>
		<tbody>
			<tr>
				<th scope="row"><span class="">사업자번호</span></th>
				<td>
					<input type="text" name="bizcode" class="small" maxlength="12" reqTitle="" value="" oninput="hypenBizcode(this)" placeholder="" required/>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">회사명</span></th>
				<td>
					<input type="text" name="company" class="small" maxlength="50" reqTitle="" value="" placeholder="" required/>
				</td>
			</tr>

			<tr>
				<th scope="row"><span class="">아이디</span></th>
				<td>
					<input type="text" title="아이디" name="userid" maxlength="15" onBlur="ID_chk()" class="middle" required/><br>
					<p class="type b" id="idMsg"></p>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">비밀번호</span></th>
				<td>
					<input type="password" title="비밀번호" name="passwd" value="" maxlength="15" class="middle" required /><br>
					<p class="type b">* 영문과 숫자를 조합하여 6~15자리로 만들어 주세요, 첫글자는 영문으로 입력해 주세요</p>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">비밀번호 확인</span></th>
				<td>
					<input type="password" title="비밀번호확인" name="passwd_check" value="" maxlength="15" class="middle" required />
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">이름</span></th>
				<td><input type="text" title="이름" name="name" maxlength="20" class="middle" required/></td>
			</tr>
			<tr>
				<th scope="row"><span class="">연락처</span></th>
				<td>
					<div class="flex three">
						<input type="text" class="onlyNumber" title="연락처 첫번째 자리 입력" name="phone" maxlength="4" required />
						<span class="type c">-</span>
						<input type="text" class="onlyNumber" title="연락처 가운데 자리 입력" name="phone" maxlength="4" required />
						<span class="type c">-</span>
						<input type="text" class="onlyNumber" title="연락처 가운데 자리 입력" name="phone" maxlength="4" required />
					</div>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">이메일</span></th>
				<td>
					<div class="flex three emall">
						<input type="text" title="이메일주소입력" name="email" maxlength="25" value="" class="emailChk" required />
						<span class="type c">@</span>
						<input type="text" class="eDomain emailChk" title="이메일 도메인 입력" name="email" maxlength="25" value="" required />
					</div>
					<p class="type b" id="emailMsg"></p>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="">주소</span></th>
				<td>
					<div class="flex" onclick="openDaumPostcode();">
						<input type="text" name="zip" id="zip" id="postcode" title="우편번호" class="middle" readonly>
						<a href="javascript:zipcodeck('zip','addr1','addr2');" class="btns">주소검색</a>
					</div>
					<div class="flex juso">
						<input type="text" name="addr1" id="addr1" maxlength="50" value="" placeholder="주소" class="">
						<input type="text" name="addr2" id="addr2" maxlength="50" value="" placeholder="상세주소">
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
								<p class="check-new"><input type="radio" name="EmailYN" id="form_email_n" value="0"><label for="form_email_n"><span class="graphic"></span>미수신</label></p>
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
	<a href="javascript:history.back();" class="click big delete">취소하기</a>
	<a href="javascript:sendit()" class="click big">가입하기</a>
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