<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Page=Request("page")
seroutmember=Request("seroutmember")
sermempubYN=Request("sermempubYN")
serMemsort = Request("serMemsort")
serOrderbyStr=Request("serOrderbyStr")
serOrderbyDec=Request("serOrderbyDec")
searchitem=Request("searchitem")
searchstr=Request("searchstr")
IDX=Request("IDX")

IF Idx<>"" Then
	Sql="Select id, pwd, name, zipcode, addr1, addr2, tel, phone, email, filename, EmailYN, Memsort, smsYN, birthday, sex, isAuth, note1, note2, company, nickname, bizcode, dbo.fn_cLevelCd(idx) AS cMemLevel, loginCnt, lastLogin, isAutoLevel, autoLevel From members Where idx="&Idx
	Set Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then
		id=ReplaceTextField(Rs("id")) : pwd=Rs("pwd")
		name=ReplaceTextField(Rs("name"))
		Zip=Rs("zipcode") : addr1=ReplaceTextField(Rs("addr1"))
		addr2=ReplaceTextField(Rs("addr2")) : tel=Split(changeBlank(Rs("tel")),"-")
		phone=Split(Rs("phone"),"-") : email=ReplaceTextField(Rs("email"))
		filename=Rs("filename")
		EmailYN=Rs("EmailYN")
		smsYN=Rs("smsYN")
		Memsort=Rs("memsort")
		EmailStr = Split(email,"@")
		birthday=Rs("birthday")
		sex=ReplaceTextField(Rs("sex"))
		isAuth=Rs("isAuth")
		note1=ReplaceTextField(Rs("note1"))
		note2=ReplaceTextField(Rs("note2"))
		company=ReplaceTextField(Rs("company"))
		nickname=ReplaceTextField(Rs("nickname"))
		bizcode=ReplaceTextField(Rs("bizcode"))
		cMemLevel=Rs("cMemLevel")
		Member_lastLogin = Rs("lastLogin")
		Member_loginCnt = Rs("loginCnt")
		isAutoLevel = Rs("isAutoLevel")
		autoLevel = Rs("autoLevel")

		Sql = "SELECT COUNT(1) FROM BBSLIST WHERE boardidx=50 And useridx="&Idx
		Set Rs = DBcon.Execute(Sql)
		Member_BoardRegCnt = Rs(0)

		Sql = "SELECT COUNT(1) FROM CommentAdmin WHERE useridx="&Idx
		Set Rs = DBcon.Execute(Sql)
		Member_CommentRegCnt = Rs(0)
	End IF
	RealOnlyYN="readonly"
Else
	reDim Tel(2),Phone(2),EmailStr(1)
	RealOnlyYN=""
	Idx = ""
	isAutoLevel = "1"
End IF

IF Ubound(Tel)<2 Then ReDim Tel(2)
IF Ubound(Phone)<2 Then ReDim Phone(2)
IF Ubound(EmailStr)<1 Then ReDim EmailStr(1)

SEt Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<style>
.my_data_box{margin-bottom:2rem; display:flex; align-items:center; padding:1.7rem 2rem; border:0.2rem solid #ddd; border-radius:1rem; clear:both;}
.my_data_box .my_last_login{padding:0 3rem; display:flex; align-items:center; gap:3rem}
.my_data_box .my_last_login > p{font-size:1.6rem; line-height:2.4rem; color:#666; text-align:center;}
.my_data_box .my_last_login > p em{font-style:normal; font-weight:700; color:#111}
.my_data_box .my_last_login > p span{display:inline-block; margin-top:0.4rem; color:var(--point)}
.my_data_box .my_last_login::before{content:""; display:block; width:8.2rem; aspect-ratio:1/1; background-repeat:no-repeat; background-position:center; background-size:contain;}
.my_data_box .my_last_login.my_lv01::before{background-image:url("/images/icon/my_lv_icon01.png");}
.my_data_box .my_last_login.my_lv02::before{background-image:url("/images/icon/my_lv_icon02.png");}
.my_data_box .my_last_login.my_lv03::before{background-image:url("/images/icon/my_lv_icon03.png");}
.my_data_box .my_last_login.my_lv04::before{background-image:url("/images/icon/my_lv_icon04.png");}
.my_data_box .my_last_login.my_lv05::before{background-image:url("/images/icon/my_lv_icon05.png");}
.my_data_box .my_last_login.my_lv06::before{background-image:url("/images/icon/my_lv_icon06.png");}
.my_data_box .my_last_login.my_lv07::before{background-image:url("/images/icon/my_lv_icon07.png");}

.my_data_box .my_last_login + .my_info::before{content:""; display:block; width:1px; height:6.5rem; background-color:#ddd; position:absolute; left:0; top:50%; transform:translateY(-50%);}
.my_data_box .my_info{padding-left:4rem; display:flex; gap:1.5rem 4rem; position:relative;}
.my_data_box .my_info dl{display:flex; gap:1.3rem; align-items:center;}
.my_data_box .my_info dt{display:flex; align-items:center; gap:1rem; font-size:1.6rem; line-height:2.4rem; font-weight:500;}
.my_data_box .my_info dt::before{content:""; display:block; width:2.2rem; height:2.2rem; background-repeat:no-repeat; background-position:center; background-size:contain;}
.my_data_box .my_info dd{font-size:2rem; line-height:3rem; font-weight:700; color:var(--point)}
.my_data_box .my_info .my_mb_lv dd{color:#0738f0}

.my_data_box .my_info .my_mb_lv dt::before{background-image:url("/images/icon/my_info_icon01.png");}
.my_data_box .my_info .to_visit dt::before{background-image:url("/images/icon/my_info_icon02.png");}
.my_data_box .my_info .my_write dt::before{background-image:url("/images/icon/my_info_icon03.png");}
.my_data_box .my_info .my_comment dt::before{background-image:url("/images/icon/my_info_icon04.png");}
</style>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
	var Join=document.Join;

	if(Join.name.value==""){
		alert("이름을 입력하세요.");
		Join.name.focus();
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

	if( (Join.phone[0].value + Join.phone[1].value + Join.phone[2].value).length !=0 ){
		if(Join.phone[0].value==""){
			alert("휴대전화번호를 입력하세요.");
			Join.phone[0].focus();
			return;
		}
		if(Join.phone[1].value==""){
			alert("휴대전화번호를 입력하세요.");
			Join.phone[1].focus();
			return;
		}
		if(Join.phone[2].value==""){
			alert("휴대전화번호를 입력하세요.");
			Join.phone[2].focus();
			return;
		}
	}
	if(Join.email1.value==""){
		alert("이메일을 입력하세요");
		Join.email1.focus();
		return;
	}
	if(Join.email2.value==""){
		alert("이메일을 입력하세요");
		Join.email2.focus();
		return;
	}
	Join.email.value=Join.email1.value + "@" +Join.email2.value;

	Join.target="iframes";
	Join.submit();
}
function domain_chk()	{
	if (document.Join.email_domain.value!="") {
		document.Join.email2.value=document.Join.email_domain.value;
		document.Join.email2.readOnly=true;
	} else {
		document.Join.email2.value="";
		document.Join.email2.readOnly=false;
		document.Join.email2.focus();
	}
}

function viewPage(idx,tp,divID,page){
	//var params = $("#commentfrm").serialize();
	var params = "idx="+idx+'&page='+page;
	$.ajax({type:"POST", url:tp,data:params,dataType:"html"
	}).done(function(data){
		document.getElementById(divID).innerHTML=data;
	})
}
//-->
</SCRIPT>
</head>

<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%><!-- (<%=langTitle%>)--></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<% IF idx<>"" Then %>
				<div class="my_data_box">
					<div class="my_last_login my_lv0<%=cMemLevel%>">
						<p><em><%=ID%></em> 님의 <br>마지막 로그인 시간은 <br><span class="last_date"><%=uf_ConvertDateFormat(Member_lastLogin, 8)%></span></p>
					</div>
					<div class="my_info">
						<dl class="my_mb_lv">
							<dt>커뮤니티 회원등급</dt>
							<dd><%=getCommunityMemLevelNm(cMemLevel)%></dd>
						</dl>
						<dl class="to_visit">
							<dt>총 방문수</dt>
							<dd><%=FormatNumber(Member_loginCnt, 0)%></dd>
						</dl>
						<dl class="my_write">
							<dt>작성한 게시글</dt>
							<dd><%=FormatNumber(Member_BoardRegCnt, 0)%></dd>
						</dl>
						<dl class="my_comment">
							<dt>작성한 댓글</dt>
							<dd><%=FormatNumber(Member_CommentRegCnt, 0)%></dd>
						</dl>
					</div>
				</div>
				<% End IF %>

<script type="text/javascript">
<!--
$(document).ready(function(){
	$(document).on("change","#isAutoLevel",function(){
		if ( $(this).is(":checked") ){
			$("select[name=autoLevel]").hide();
		}else{
			$("select[name=autoLevel]").show();
		}
	});

	$("#isAutoLevel").change()
});
//-->
</script>

				<form action="join_ok.asp" method="post" name="Join" enctype="multipart/form-data">
				<input name="email" type="hidden" class="input">
				<input type='hidden' name='idx' value='<%=idx%>'>
				<table class="tbl_col">
				<colgroup>
					<col width="15%" />
					<col width="" />
				</colgroup>
					<tr>
						<th>커뮤니티등급</th>
						<td class="left">
							<p class="checkIn" style="vertical-align:middle">	
								<input type="checkbox" name="isAutoLevel" id="isAutoLevel" value="1" <%=iif_compare(isAutoLevel, "1", "checked")%>><label for="isAutoLevel" style="margin:10px 10px 10px 0;">자동레벨사용</label>
							</p>
							<select name='autoLevel'>
								<option value='1' <%=SelCheck("1",autoLevel)%>>신입사원</option>
								<option value='2' <%=SelCheck("2",autoLevel)%>>사원</option>
								<option value='3' <%=SelCheck("3",autoLevel)%>>과장</option>
								<option value='4' <%=SelCheck("4",autoLevel)%>>부장</option>
								<option value='5' <%=SelCheck("5",autoLevel)%>>이사</option>
								<option value='6' <%=SelCheck("6",autoLevel)%>>상무</option>
								<option value='7' <%=SelCheck("7",autoLevel)%>>대표</option>
							</select>
							<div class="imp">자동레벨 사용 체크 시 방문수, 작성한 게시글에 따라 설정된 레벨을 이용합니다.</div>
						</td>
					</tr>
					<tr>
						<th>회원등급</th>
						<td class="left">
							<select name='Memsort' id="memsort">
								<option value='0' <%=SelCheck("0",Memsort)%>>일반회원</option>
								<option value='1' <%=SelCheck("1",Memsort)%>>특별회원</option>
							</select>

							<select name='isAuth'>
								<option value='99' <%=SelCheck("99",isAuth)%>>가입승인</option>
								<option value='0' <%=SelCheck("0",isAuth)%>>가입대기중</option>
								<option value='1' <%=SelCheck("1",isAuth)%>>보류</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>아이디</th>
						<td class="left">
							<input name="userid" type="text" class="input" size="15" maxlength='15' value='<%=ID%>' <%=RealOnlyYN%>>
						</td>
					</tr>
					<tr>
						<th>패스워드</th>
						<td class="left">
							<input name="passwd" type="password" size="15" maxlength='15' class='input' value='<%=pwd%>'>
						</td>
					</tr>
					<tr>
						<th>패스워드확인</th>
						<td class="left">
							<input name="passwd_check" type="password"  size="15" maxlength='15' class='input' value='<%=pwd%>'>
						</td>
					</tr>
					<tr>
						<th>이름</th>
						<td class="left">
							<input name="name" type="text" size="15" maxlength='15' class='input' value='<%=name%>'>
						</td>
					</tr>
					<tr class="disNone">
						<th>닉네임</th>
						<td class="left">
							<input name="nickname" type="text" size="15" maxlength='20' class='input' value='<%=nickname%>'>
						</td>
					</tr>
					<tr class="disNone">
						<th scope="row"><span class="">생년월일</span></th>
						<td class="left">
							<input type="text" style="width:15%;" title="생년월일" name="birthday" maxlength="10" value="<%=birthday%>" />
						</td>
					</tr>

					<tr class="disNone">
						<th scope="row"><span class="">성별</span></th>
						<td class="left">
							<span class="checkIn">
								<input type="radio" id="sexType01" name="sex" value="남" <%=iif_Compare(sex,"남","checked")%> />
								<label for="sexType01">남</label>
							</span>
							<span class="checkIn">
								<input type="radio" id="sexType02" name="sex" value="여" <%=iif_Compare(sex,"여","checked")%> />
								<label for="sexType02">여</label>
							</span>
						</td>
					</tr>
					<tr class="disNone">
						<th>연락처</th>
						<td class="left">
							<input name="tel" type="text" size="4"  maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=tel(0)%>'>
							-
							<input name="tel" type="text" size="4"  maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=tel(1)%>'>
							-
							<input name="tel" type="text" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=tel(2)%>'>
						</td>
					</tr>
					<tr>
						<th>연락처</th>
						<td class="left">
							<input name="phone" type="text" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=phone(0)%>'>
							-
							<input name="phone" type="text" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=phone(1)%>'>
							-
							<input name="phone" type="text" size="4" maxlength='4' onKeyPress='if( (event.keyCode<48) || (event.keyCode>57) ) event.returnValue=false;' style='IME-MODE:disabled' class='input' value='<%=phone(2)%>'>
							<span><input type="checkbox" id="smsYN" name="smsYN" value="1" <%=iif_compare(1,smsYN,"checked")%> /><label for="smsYN">정보수신</label></span>
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td class="left">
							<input name="email1" size="25" maxlength="25" type="text" class="input" value="<%=EmailStr(0)%>">
							@
							<input name="email2" size="23" maxlength="25" type="text" class="input" tabindex="-1" value='<%=EmailStr(1)%>'>
							<!-- <select name="email_domain" onChange="domain_chk();">
								<option value="" selected >이메일선택</option>
								<option value="chol.com" <%=Selcheck("chol.com",EmailStr(1))%>>chol.com</option>
								<option value="dreamwiz.com" <%=Selcheck("dreamwiz.com",EmailStr(1))%>>dreamwiz.com</option>
								<option value="empas.com" <%=Selcheck("empas.com",EmailStr(1))%>>empas.com</option>
								<option value="freechal.com" <%=Selcheck("freechal.com",EmailStr(1))%>>freechal.com</option>
								<option value="hanafos.com" <%=Selcheck("hanafos.com",EmailStr(1))%>>hanafos.com</option>
								<option value="hanmail.net" <%=Selcheck("hanmail.net",EmailStr(1))%>>hanmail.net</option>
								<option value="hanmir.com" <%=Selcheck("hanmir.com",EmailStr(1))%>>hanmir.com</option>
								<option value="hitel.net" <%=Selcheck("hitel.net",EmailStr(1))%>>hitel.net</option>
								<option value="hotmail.com" <%=Selcheck("hotmail.com",EmailStr(1))%>>hotmail.com</option>
								<option value="korea.com" <%=Selcheck("korea.com",EmailStr(1))%>>korea.com</option>
								<option value="naver.com" <%=Selcheck("naver.com",EmailStr(1))%>>naver.com</option>
								<option value="nate.com" <%=Selcheck("nate.com",EmailStr(1))%>>nate.com</option>
								<option value="netian.com" <%=Selcheck("netian.com",EmailStr(1))%>>netian.com</option>
								<option value="yahoo.co.kr" <%=Selcheck("yahoo.co.kr",EmailStr(1))%>>yahoo.co.kr</option>
								<option value="">직접입력</option>
							</select> -->

							<span><input type="checkbox" id="emailYN" name="emailYN" value="1" <%=iif_compare(1,emailYN,"checked")%> /><label for="emailYN">정보수신</label></span>
						</td>
					</tr>

					<tr class="">
						<th>사업자등록번호</th>
						<td class="left">
							<input name="bizcode" type="text" size="50" maxlength='50' class='input' value='<%=bizcode%>'>
						</td>
					</tr>
					<tr class="">
						<th>회사명</th>
						<td class="left">
							<input name="company" type="text" size="50" maxlength='50' class='input' value='<%=company%>'>
						</td>
					</tr>
					<tr>
						<th>우편번호</th>
						<td class="left">
							<input name="zip" id="zip" type="text" class="input" size="7" readonly value='<%=zip%>'>
							<input type='button' value="우편번호찾기" class="btn_gray" style="width:100px" onclick="zipcodeck('zip','addr1','addr1')">
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td class="left">
							<input name="addr1" id="addr1" type="text" class="input" value='<%=addr1%>' style='width:40%'>
							<input name="addr2" id="addr2" type="text" class="input" value='<%=addr2%>' style='width:40%'>
						</td>
					</tr>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="#jLink" ONCLICK="sendit();" class="btn_largeG">저장하기</a>
					<a href="memberlist.asp?Page=<%= Page %>&sermempubYN=<%= sermempubYN %>&seroutmember=<%= seroutmember %>&serMemsort=<%= serMemsort %>&serOrderbyStr=<%= serOrderbyStr %>&serOrderbyDec=<%= serOrderbyDec %>&searchitem=<%= searchitem %>&searchstr=<%= searchstr %>" class="btn_largeW">목록보기</a>
				</div>

				<% IF Idx<>"" Then %>
				<div id='LoginLogDiv'></div>
				<SCRIPT LANGUAGE="JavaScript">viewPage(<%=idx%>,"ajax_LoginLog.asp","LoginLogDiv",'')</SCRIPT>
				<% End IF %>

			</div>
		</div>
	</div>
	<iframe name='iframes' frameborder='0' width='100%' height='0'></iframe>
<!--#include virtual = backoffice/common/bottom.asp-->