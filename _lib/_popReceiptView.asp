<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","","")

IF Idx<>"" AND Session("useridx")<>"" Then
	Sql = "SELECT status, regdate, testYear, testRound, testGrade, testArea1, testArea2, price, name, birthday, phone, email, sosok, pic, filename, sex, examNo, testSt, testHarf, setArea, setRoom, setsTime, seteTime FROM jewelryApply WHERE useridx="&Session("useridx")&" AND IDX="&Idx

	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		status = ChangeBlank(Rs("status"))
		regdate = ChangeBlank(Rs("regdate"))
		testYear = ChangeBlank(Rs("testYear"))
		testRound = ChangeBlank(Rs("testRound"))
		testGrade = ChangeBlank(Rs("testGrade"))
		testArea1 = ChangeBlank(Rs("testArea1"))
		testArea2 = ChangeBlank(Rs("testArea2"))
		price = ChangeBlank(Rs("price"))
		name = ChangeBlank(Rs("name"))
		birthday = ChangeBlank(Rs("birthday"))
		phone = ChangeBlank(Rs("phone"))
		email = ChangeBlank(Rs("email"))
		sosok = ChangeBlank(Rs("sosok"))
		pic = ChangeBlank(Rs("pic"))
		filename = ChangeBlank(Rs("filename"))
		sex = ChangeBlank(Rs("sex"))
		examNo = ChangeBlank(Rs("examNo"))
		testSt = ChangeBlank(Rs("testSt"))
		testHarf = ChangeBlank(Rs("testHarf"))

		setArea = ChangeBlank(Rs("setArea"))
		setRoom = ChangeBlank(Rs("setRoom"))
		setsTime = ChangeBlank(Rs("setsTime"))
		seteTime = ChangeBlank(Rs("seteTime"))

		isRecord = True
	End IF
End IF

DBcon.CLose
Set DBcon = Nothing
IF Not(isRecord) Then
	Response.Write ExecJavaAlert("게시물 정보를 찾을수 없습니다.", 1)
	Response.End
ElseIF examNo="" Then
	Response.Write ExecJavaAlert("아직 응시번호 채번이 되지 않았습니다.\n접수상태를 확인해주세요.", 1)
	Response.End
End IF
%>
<!DOCTYPE html>
<html lang="ko" class="sub">

<head>
    <!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="1101">
    <div id="wrap">

		<div class="application_form">
			<div class="w1300">
				<div class="form1">
					<p class="application_form_title">주얼리마스터 자격검정시험</p>
					<p class="application_form_sub">응 시 원 서</p>
					<table>
						<colgroup>
							<col width="10%">
							<col width="27.5%">
							<col width="15%">
							<col width="27.5%">
							<col width="20%">
						</colgroup>
						<tr>
							<th>성명</th>
							<td><%=ReplaceNoHtml(name)%></td>
							<td>생년월일</td>
							<td><%=ReplaceNoHtml(birthday)%></td>
							<td rowspan="3"><img src="/upload/applyJewelry/<%=pic%>"></td>
						</tr>
						<tr>
							<th>소속</th>
							<td><%=ReplaceNoHtml(sosok)%></td>
							<td>연락처</td>
							<td><%=ReplaceNoHtml(phone)%></td>
						</tr>
						<tr>
							<th>이메일</th>
							<td colspan="3"><%=ReplaceNoHtml(email)%></td>
						</tr>
					</table>
					
					<div class="form1_text">
						<p>- 귀 협회에서 시행하는 주얼리마스터 자격검정시험에 응시하고자 아래 사항을 서약하고 이 원서를 제출합니다. </p>
						<p>- 이 원서에 기재한 내용이 사실과 다르거나 응시자격 기준에 해당하지 아니한 때에는 합격 또는 자격을 취소하여도 아무런 이의를 제기하지 않겠습니다. </p>
					</div>
					<div class="form1_signs">
						<p><%=Year(Date())%>년</p>
						<p><%=Month(Date())%>월</p>
						<p><%=Day(Date())%>일</p>
						<p>성 명 : <%=ReplaceNoHtml(name)%></p>
						<span>(서명)</span>
					</div>
					<img style="display: block; margin: 3rem auto 5rem" src="/images/main/location_logo.png" alt="">
				</div>

				<div class="w1300">
					<div class="form1">
					<p class="application_form_title">
						주얼리마스터 자격검정시험
					</p>
					<p class="application_form_sub">
						수 험 표
					</p>
					<table>
						<colgroup>
							<col width="10%">
							<col width="27.5%">
							<col width="15%">
							<col width="27.5%">
							<col width="20%">
						</colgroup>
						<tr>
							<th>수험번호</th>
							<td colspan="3"><%=ReplaceNoHtml(examNo)%></td>
							<td rowspan="3"><img src="/upload/applyJewelry/<%=pic%>"></td>
						</tr>
						<tr>
							<th>성명</th>
							<td><%=ReplaceNoHtml(name)%></td>
							<td>생년월일</td>
							<td><%=ReplaceNoHtml(birthday)%></td>
						</tr>
						<tr>
							<th>소속</th>
							<td><%=ReplaceNoHtml(sosok)%></td>
							<td>연락처</td>
							<td><%=ReplaceNoHtml(phone)%></td>
						</tr>
						<tr>
							<th>지역</th>
							<td><%=ReplaceNoHtml(setArea)%></td>
							<td>시험장</td>
							<td colspan="2"><%=ReplaceNoHtml(setRoom)%></td>
						</tr>
						<tr>
							<table>
								<colgroup>
									<col width="18.75%">
									<col width="18.75%">
									<col width="22.5%">
									<col width="*">
									<col width="17.5%">
								</colgroup>
								<tbody>
									<tr>
										<td>회차</td>
										<td>급수</td>
										<td>차수</td>
										<td rowspan="3" style="text-align: left;">
											시험시간: <%=ReplaceNoHtml(setsTime)%>~<%=ReplaceNoHtml(seteTime)%>
											<% ON ERROR RESUME NEXT %>
											(총 <%=DateDiff("n", setsTime, seteTime)%>분) <br><br>
											쉬는시간 없이 진행
											<!-- 11:50부터 퇴실 가능 -->
										</td>
										<td>감독관 확인</td>
									</tr>
									<tr>
										<td rowspan="2"><%=testYear%>년 <%=ReplaceNoHtml(testHarf)%> <br> <span><%=testRound%>회</span></td>
										<td rowspan="2"><span><%=ReplaceNoHtml(testGrade)%>급</span></td>
										<td rowspan="2"><span><%=ReplaceNoHtml(testSt)%></span></td>
										<td rowspan="2"><span></span></td>
									</tr>
								</tbody>
							</table>
						</tr>
					</table>
					
					<div class="form1_text2">
						<p>※ 수험자 유의사항</p>
						<p>1. 수험자는 시험시작 20분전 까지 시험실 입실을 완료해야 합니다. </p>
						<p>2. 수험자는 수험표, 주민등록증, 필기도구(컴퓨터사인펜, 흑색볼펜), 계산기를 지참하여야 합니다. </p>
						<p>3. 합격자 발표는 시험일로부터 2주 후, 협회 홈페이지(www.kgta.co.kr)에서 확인해야 합니다. (개별통보 하지 않음)</p>
					</div>
				 </div>
				</div>

			</div>
		</div>

    </div>
</body>
</html>