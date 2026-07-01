<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "basic" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Sql = "SELECT dDepositAccount, dDepositBank, dDepositNm, isSmsUse, smsid, smscode, smsBalSinNum, allowTestIP, dFee1, dFee2, buyCsEmail, busCsEmail, amaCsEmail, icubeCsEmail, bizboxCsEmail, etcCsEmail, joinCsEmail FROM Shopinfo"
Set Rs=DBcon.Execute(Sql)



IF Not(rs.BOF Or rs.EOF) Then
	isSmsUse = Rs("isSmsUse")
	smsid = ReplaceTextField(Rs("smsid"))
	smscode = ReplaceTextField(Rs("smscode"))
	smsBalSinNum = ReplaceTextField(Rs("smsBalSinNum"))

	dDepositAccount = ReplaceTextField(Rs("dDepositAccount"))
	dDepositBank = ReplaceTextField(Rs("dDepositBank"))
	dDepositNm = ReplaceTextField(Rs("dDepositNm"))
	allowTestIP = ReplaceTextField(Rs("allowTestIP"))

	dFee1 = ReplaceTextField(Rs("dFee1"))
	dFee2 = ReplaceTextField(Rs("dFee2"))

	buyCsEmail = ReplaceTextField(Rs("buyCsEmail"))
	busCsEmail = ReplaceTextField(Rs("busCsEmail"))
	amaCsEmail = ReplaceTextField(Rs("amaCsEmail"))
	icubeCsEmail = ReplaceTextField(Rs("icubeCsEmail"))
	bizboxCsEmail = ReplaceTextField(Rs("bizboxCsEmail"))
	etcCsEmail = ReplaceTextField(Rs("etcCsEmail"))
	joinCsEmail = ReplaceTextField(Rs("joinCsEmail"))
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
	var form=document.express;

	/*if (form.dDepositBank.value=="") {
		alert("무통장계좌정보(은행명) 를 입력하세요.");
		form.dDepositBank.focus();
		return;
	}
	if (form.dDepositAccount.value=="") {
		alert("무통장계좌정보(입금계좌) 를 입력하세요.");
		form.dDepositAccount.focus();
		return;
	}
	if (form.dDepositNm.value=="") {
		alert("무통장계좌정보(예금주) 를 입력하세요.");
		form.dDepositNm.focus();
		return;
	}

	if ( $("input:checkbox[name=isSmsUse]").is(":checked") ){
		if (form.smsid.value=="") {
			alert("카페24 SMS ID를 입력하세요.");
			form.smsid.focus();
			return;
		}
		if (form.smscode.value=="") {
			alert("카페24 SMS 시큐어 코드를 입력하세요.");
			form.smscode.focus();
			return;
		}
		if (form.smsBalSinNum.value=="") {
			alert("카페24 SMS 발신번호를 입력하세요.");
			form.smsBalSinNum.focus();
			return;
		}
	}*/

	var val = confirm("저장하시겠습니까?")
	if (val){
		express.submit()
	}
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

				<form name='express' METHOD='POST' ACTION="basic_setup_ok.asp">
				<div class="subTitle disNone">무통장 입금계좌 정보</div>
				<table class="tbl_col box disNone">
				<colgroup>
					<col width="15%" />
					<col width="" />
				</colgroup>
					<tr>
						<th>은행명</th>
						<td class="left">
							<label><input type="text" maxlength="50" class="" name="dDepositBank" value="<%=dDepositBank%>"></label>
						</td>
					</tr>
					<tr>
						<th>입금계좌</th>
						<td class="left">
							<label><input type="text" maxlength="50" class="" name="dDepositAccount" value="<%=dDepositAccount%>"></label>
						</td>
					</tr>
					<tr>
						<th>예금주</th>
						<td class="left">
							<label><input type="text" maxlength="50" class="" name="dDepositNm" value="<%=dDepositNm%>"></label>
						</td>
					</tr>
				</table>

				<div class="subTitle disNone">배송비 설정</div>
				<table class="tbl_col box disNone">
				<colgroup>
					<col width="15%" />
					<col width="" />
				</colgroup>
					<tr>
						<th>택배비(일반)</th>
						<td class="left">
							<label><input type="text" maxlength="10" class="onlyNumber" name="dFee1" value="<%=dFee1%>"></label>
						</td>
					</tr>
					<tr>
						<th>택배비 (도서, 산간 및 제주도)</th>
						<td class="left">
							<label><input type="text" maxlength="10" class="onlyNumber" name="dFee2" value="<%=dFee2%>"></label>
						</td>
					</tr>
				</table>

				<div class="subTitle disNone">SMS 사용설정</div>
				<table class="tbl_col box disNone">
				<colgroup>
					<col width="15%" />
					<col width="" />
				</colgroup>
					<tr>
						<th>SMS사용여부</th>
						<td class="left">
							<label><input type="checkbox" name="isSmsUse" value="1" <%=iif_compare(isSmsUse, 1, "checked")%>><span class='info'>카페24 SMS 서비스에 가입하셔야합니다. 사용시 체크하세요.</span></label>
						</td>
					</tr>
					<tr>
						<th>카페24 ID</th>
						<td class="left">
							<input type="text" name="smsid" maxlength="50" value="<%=smsid%>" placeholder="발급받으신 SMS ID를 입력해주세요.">
						</td>
					</tr>
					<tr>
						<th>시큐리티 코드</th>
						<td class="left">
							<input type="text" name="smscode" maxlength="50" value="<%=smscode%>" placeholder="카페24에서 제공하는 시큐어 코드를 입력해주세요.">
						</td>
					</tr>
					<tr>
						<th>발신번호</th>
						<td class="left">
							<input type="text" name="smsBalSinNum" maxlength="15" value="<%=smsBalSinNum%>" class="" placeholder="- 포함한 발신번호를 입력해주세요.">
						</td>
					</tr>
				</table>

				<div class="subTitle">CS EMAIL 설정 <span style='font-weight:400'>( 게시물 관련 알림받을 메일주소를 입력하세요. <span>다중 입력시 " ; " 구분</span> )</span></div>
				<table class="tbl_col box">
				<colgroup>
					<col width="15%" />
					<col width="" />
				</colgroup>
					<tr>
						<th>제품/서비스 구매상담</th>
						<td class="left">
							<input type='text' name="buyCsEmail" maxlength="500" value="<%=ReplaceTextField(buyCsEmail)%>">
						</td>
					</tr>
					<tr>
						<th>비즈니스 제휴문의</th>
						<td class="left">
							<input type='text' name="busCsEmail" maxlength="500" value="<%=ReplaceTextField(busCsEmail)%>">
						</td>
					</tr>
					<tr>
						<th>Amaranth10 고객센터</th>
						<td class="left">
							<input type='text' name="amaCsEmail" maxlength="500" value="<%=ReplaceTextField(amaCsEmail)%>">
						</td>
					</tr>

					<tr>
						<th>iCUBE / iCUBE G20 고객센터</th>
						<td class="left">
							<input type='text' name="icubeCsEmail" maxlength="500" value="<%=ReplaceTextField(icubeCsEmail)%>">
						</td>
					</tr>
					<tr>
						<th>Bizbox Alpha 고객센터</th>
						<td class="left">
							<input type='text' name="bizboxCsEmail" maxlength="500" value="<%=ReplaceTextField(bizboxCsEmail)%>">
						</td>
					</tr>

					<tr>
						<th>기타문의</th>
						<td class="left">
							<input type='text' name="etcCsEmail" maxlength="500" value="<%=ReplaceTextField(etcCsEmail)%>">
						</td>
					</tr>

					<tr>
						<th>회원가입 알림메일</th>
						<td class="left">
							<input type='text' name="joinCsEmail" maxlength="500" value="<%=ReplaceTextField(joinCsEmail)%>">
						</td>
					</tr>
				</table>

				<div class="btn_center pt30">
					<a href="#jLink" ONCLICK="sendit();" class="btn_largeG">저장하기</a>
				</div>
				</FORM>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->