<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "testApp" : subMenuCode = "licApp" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim licenseSdate, licenseEdate

licidx = uf_getRequest(Request("licidx"),"int","","")

IF licidx<>"" Then
	Sql = "SELECT passDate, dbo.FN_LicTermDates(idx) historyDateTerm, testNm, testRound, licNo, name, birthday FROM licenseData WHERE IDX="&licidx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		passDate = ChangeBlank(Rs("passDate"))
		historyDateTerm = ChangeBlank(Rs("historyDateTerm"))

		testNm = ChangeBlank(Rs("testNm"))
		testRound = ChangeBlank(Rs("testRound"))
		licNo = ChangeBlank(Rs("licNo"))
		name = ChangeBlank(Rs("name"))
		birthday = ChangeBlank(Rs("birthday"))

		Call getLicenseDate( passDate, historyDateTerm, "" )

		isRecord = True
	End IF
End IF

DBcon.CLose
Set DBcon = Nothing

IF isRecord <> True Then
	Response.Write ExecJavaAlert("",1)
	Response.END
End IF
%>
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include file = ../common/include/head.asp-->
	<link rel="stylesheet" href="/test/license_print.css" />
</head>
<body>
	<article>
		<div class="license">
			<strong><%=ReplaceNoHtml(licNo)%></strong>
			<img src="/images/common/license_logo.png" alt="" />
			<h4>
				자격증<br/>
				Certificate
			</h4>
			<div class="info_part clear">
				<ul class="txt_wrap">
					<li class='clear'>
						<em>자격</em>
						<strong>
							<%=ReplaceNoHtml(testNm)%>
						</strong>
					</li>
					<li class='clear'>
						<em>성명</em>
						<strong><%=ReplaceNoHtml(name)%></strong>
					</li>
					<li class='clear'>
						<em>생년월일</em>
						<strong><%=uf_ConvertDateFormat(birthday, 7)%></strong>
					</li>
				</ul>
			</div>
			<p>
				위 사람은 본 대한병원코디네이터협회에서 실시한<br/>
				제 <%=ReplaceNoHtml(testRound)%> 회 <%=ReplaceNoHtml(testNm)%> 자격시험에 합격하여 <%=ReplaceNoHtml(testNm)%><br/>
				자격을 취득하였음을 증명합니다.
			</p>
			<span><%=uf_ConvertDateFormat(passDate, 7)%></span>
			<p>
				This is to certify that the person named above has passed the<br/>
				<%=testRound%>th hospital coordinator qualification examination<br/>
				conducted by the Korean Hospital Coordinator Association
			</p>
			<span><%=uf_ConvertDateFormat(passDate, 97)%></span>
			<div class="bottom_part">
				<p>유효기간 : <%=uf_ConvertDateFormat(licenseSdate, 7)%> ~ <%=uf_ConvertDateFormat(licenseEdate, 7)%></p>
				<p>증명서발급일 : <%=uf_ConvertDateFormat(Date(), 7)%></p>
			</div>
			<div class="sign_part">
				<strong>대한병원코디네이터협회 <span>회장</span></strong>
				<em>Korea Hospital Coordinator Association</em>
			</div>
		</div>
	</article>

</body>
</html>
