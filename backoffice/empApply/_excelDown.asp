<!--#include virtual = backoffice/_lib/common.asp-->
<% Response.Buffer = True %>
<% Response.Expires = -1 %>
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "emp" : subMenuCode = "empApply" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeout = 60 * 20

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("pageSize"),"int","","20")
seritem = uf_getRequest(Request("seritem"),"int","3","0")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
serEmpidx = uf_getRequest(Request("serEmpidx"),"int","","")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")

oSearchStr = Request("searchstr")
oSerEduCd = Request("serEduCd")
oSerLic = Request("serLic")

PageLink = "index.asp"
PageStr = "serEmpidx="& serEmpidx &"&serStatus="& serStatus &"&seritem="& seritem &"&pagesize="& PageSize &"&searchStr="& Server.UrlEncode(oSearchStr)
'=============================================

IF serEmpidx<>"" Then strWhere = strWhere & " AND empidx="&serEmpidx
IF serStatus<>"" Then strWhere = strWhere & " AND status="&serStatus
IF SearchStr <> "" Then strWhere = strWhere & " AND name LIKE N'%"&SearchStr&"%'"

Sql = "SELECT " 
Sql = Sql & "idx, status, name, nameEn, phone, eTel, email, veteransrate, veteransrateRel, veteransrateNo, milservice, milEx, miltype, milclass, milSDate, milEDate, milgrade, empNm, appField, arrFile, regdate "
Sql = Sql & "FROM empApply Where isComplete=1 "& strWhere&" ORDER BY regdate DESC, Idx DESC"
'Sql = Sql & ",Case When emailYN=0 Then '<font color=red>메일수신을 받지않습니다.</font>' Else '<font color=blue>메일수신을 받습니다.</font>' End "
Set Rs = DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaAlert("검색된 내역이 없습니다.",0)
	Response.End
Else
	Allrec=Rs.GetRows()

	LangMaxCnt = 1
	Dim arrLangData1()
	Dim arrLangData2()
	Dim arrLangData3()
	Dim arrLangData4()
	Sql = "SELECT isNull(MAX(CNT),1) FROM (SELECT Count(1) CNT, appidx FROM empApplyLang WHERE appidx IN (SELECT idx FROM empApply WHERE isComplete=1 "& strWhere&") GROUP By appidx) TB"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then LangMaxCnt = Rs(0)

	LicMaxCnt = 1
	Dim arrLicData1()
	Dim arrLicData2()
	Dim arrLicData3()
	Dim arrLicData4()
	Sql = "SELECT isNull(MAX(CNT),1) FROM (SELECT Count(1) CNT, appidx FROM empApplyCert WHERE appidx IN (SELECT idx FROM empApply WHERE isComplete=1 "& strWhere&") GROUP By appidx) TB"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then LicMaxCnt = Rs(0)

	CarMaxCnt = 1
	Dim arrCarData1()
	Dim arrCarData2()
	Dim arrCarData3()
	Dim arrCarData4()
	Dim arrCarData5()
	Dim arrCarData6()
	Sql = "SELECT isNull(MAX(CNT),1) FROM (SELECT Count(1) CNT, appidx FROM empApplyCareer WHERE appidx IN (SELECT idx FROM empApply WHERE isComplete=1 "& strWhere&") GROUP By appidx) TB"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then CarMaxCnt = Rs(0)

	EduMaxCnt = 1
	Dim arrEduData1()
	Dim arrEduData2()
	Dim arrEduData3()
	Dim arrEduData4()
	Sql = "SELECT isNull(MAX(CNT),1) FROM (SELECT Count(1) CNT, appidx FROM empApplyEdu WHERE appidx IN (SELECT idx FROM empApply WHERE isComplete=1 "& strWhere&") GROUP By appidx) TB"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then EduMaxCnt = Rs(0)
End IF

Response.Write "<style>br{mso-data-placement:same-cell;}</style>"
Response.Write "<table border='1' cellspacing='0' cellpadding='3' bordercolor='#BDBEBD' style='border-collapse: collapse'>"
Response.Write "<tr align='center' height='30' bgcolor='#E1E1E1'>"
Response.Write "<td>순번</td>"
Response.Write "<td>공고명</td>"
Response.Write "<td>지원부문</td>"
Response.Write "<td>지원일</td>"
Response.Write "<td>상태</td>"
Response.Write "<td>성명(한글)</td>"
Response.Write "<td>성명(영어)</td>"
Response.Write "<td>휴대폰</td>"
Response.Write "<td>비상연락처</td>"
Response.Write "<td>이메일</td>"
Response.Write "<td>보훈대상 여부	</td>"
Response.Write "<td>보훈관계</td>"
Response.Write "<td>보훈번호</td>"
Response.Write "<td>복무구분</td>"
Response.Write "<td>면제사유</td>"
Response.Write "<td>군별</td>"
Response.Write "<td>계급</td>"
Response.Write "<td>역종</td>"
Response.Write "<td>복무기간</td>"

For j=1 To LangMaxCnt
	Response.Write "<td>외국어 언어 "&j&"</td>"
	Response.Write "<td>외국어 시험명"&j&"</td>"
	Response.Write "<td>외국어 점수(급수) "&j&"</td>"
	Response.Write "<td>외국어 취득일 "&j&"</td>"
Next

For j=1 To LicMaxCnt
	Response.Write "<td>자격사항 자격증명 "&j&"</td>"
	Response.Write "<td>자격사항 발급기관 "&j&"</td>"
	Response.Write "<td>자격사항 등록번호 "&j&"</td>"
	Response.Write "<td>자격사항 취득일자 "&j&"</td>"
Next

For j=1 To CarMaxCnt
	Response.Write "<td>경력사항 회사명 "&j&"</td>"
	Response.Write "<td>경력사항 근무기간 "&j&"</td>"
	Response.Write "<td>경력사항 최종직위 "&j&"</td>"
	Response.Write "<td>경력사항 근무형태 "&j&"</td>"
	Response.Write "<td>경력사항 근무연한 "&j&"</td>"
	Response.Write "<td>경력사항 담당업무 세부사항 "&j&"</td>"
Next

For j=1 To EduMaxCnt
	Response.Write "<td>교육사항 교육부분 "&j&"</td>"
	Response.Write "<td>교육사항 교육과정명 "&j&"</td>"
	Response.Write "<td>교육사항 교육기관 "&j&"</td>"
	Response.Write "<td>교육사항 교육기간 "&j&"</td>"
Next
Response.Write "</tr>"

For i=0 To Ubound(Allrec,2)
	idx = ChangeBlank(Allrec(0,i))
	status = ChangeBlank(Allrec(1,i))
	name = ChangeBlank(Allrec(2,i))
	nameEn = ChangeBlank(Allrec(3,i))
	phone = ChangeBlank(Allrec(4,i))
	eTel = ChangeBlank(Allrec(5,i))
	email = ChangeBlank(Allrec(6,i))
	veteransrate = ChangeBlank(Allrec(7,i))
	veteransrateRel = ChangeBlank(Allrec(8,i))
	veteransrateNo = ChangeBlank(Allrec(9,i))
	milservice = ChangeBlank(Allrec(10,i))
	milEx = ChangeBlank(Allrec(11,i))
	miltype = ChangeBlank(Allrec(12,i))
	milclass = ChangeBlank(Allrec(13,i))
	milSDate = ChangeBlank(Allrec(14,i))
	milEDate = ChangeBlank(Allrec(15,i))
	milgrade = ChangeBlank(Allrec(16,i))
	empNm = ChangeBlank(Allrec(17,i))
	appField = ChangeBlank(Allrec(18,i))
	arrFile = ChangeBlank(Allrec(19,i))
	regdate = ChangeBlank(Allrec(20,i))

	Set langRec = Nothing
	Set licRec = Nothing
	Set carRec = Nothing
	Set eduRec = Nothing

	Sql = "SELECT language, lang_testNm, lang_testScore, lang_examDate FROM empApplyLang WHERE appidx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then langRec = Rs.GetRows()

	Sql = "SELECT cert_Note1, cert_Note2, cert_Note3, cert_Date FROM empApplyCert WHERE appidx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then licRec = Rs.GetRows()

	Sql = "SELECT car_Company, car_SDate, car_EDate, car_Note1, car_Note2, car_Note3, car_Content FROM empApplyCareer WHERE appidx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then carRec = Rs.GetRows()

	Sql = "SELECT eduNote1, eduNote2, eduNote3, eduSDate, eduEDate FROM empApplyEdu WHERE appidx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then eduRec = Rs.GetRows()

	ReDim arrLangData1(LangMaxCnt)
	ReDim arrLangData2(LangMaxCnt)
	ReDim arrLangData3(LangMaxCnt)
	ReDim arrLangData4(LangMaxCnt)
	IF isArray(langRec) Then
		For k=0 To Ubound(langRec,2)
			language = ChangeBlank(langRec(0,k))
			lang_testNm = ChangeBlank(langRec(1,k))
			lang_testScore = ChangeBlank(langRec(2,k))
			lang_examDate = ChangeBlank(langRec(3,k))

			arrLangData1(k) = ReplaceNoHtml(language)
			arrLangData2(k) = ReplaceNoHtml(convertSpace(lang_testNm, "-"))
			arrLangData3(k) = ReplaceNoHtml(convertSpace(lang_score, "-"))
			arrLangData4(k) = ReplaceNoHtml(convertSpace(lang_examDate, "-"))
		Next
	End IF

	ReDim arrLicData1(LicMaxCnt)
	ReDim arrLicData2(LicMaxCnt)
	ReDim arrLicData3(LicMaxCnt)
	ReDim arrLicData4(LicMaxCnt)
	IF isArray(licRec) Then
		For k=0 To Ubound(licRec,2)
			cert_Note1 = ChangeBlank(licRec(0,k))
			cert_Note2 = ChangeBlank(licRec(1,k))
			cert_Note3 = ChangeBlank(licRec(2,k))
			cert_Date = ChangeBlank(licRec(3,k))

			arrLicData1(k) = ReplaceNoHtml(convertSpace(cert_Note1, "-"))
			arrLicData2(k) = ReplaceNoHtml(convertSpace(cert_Note2, "-"))
			arrLicData3(k) = ReplaceNoHtml(convertSpace(cert_Note3, "-"))
			arrLicData4(k) = ReplaceNoHtml(convertSpace(cert_Date, "-"))
		Next
	End IF

	ReDim arrCarData1(CarMaxCnt)
	ReDim arrCarData2(CarMaxCnt)
	ReDim arrCarData3(CarMaxCnt)
	ReDim arrCarData4(CarMaxCnt)
	ReDim arrCarData5(CarMaxCnt)
	ReDim arrCarData6(CarMaxCnt)
	IF isArray(carRec) Then
		For k=0 To Ubound(carRec,2)
			car_Company = ChangeBlank(carRec(0,k))
			car_SDate = ChangeBlank(carRec(1,k))
			car_EDate = ChangeBlank(carRec(2,k))
			car_Note1 = ChangeBlank(carRec(3,k))
			car_Note2 = ChangeBlank(carRec(4,k))
			car_Note3 = ChangeBlank(carRec(5,k))
			car_Content = ChangeBlank(carRec(6,k))

			arrCarData1(k) = ReplaceNoHtml(convertSpace(car_Company, "-"))
			arrCarData2(k) = car_SDate & " ~ " & car_EDate
			arrCarData3(k) = ReplaceNoHtml(convertSpace(car_Note1, "-"))
			arrCarData4(k) = ReplaceNoHtml(convertSpace(car_Note2, "-"))
			arrCarData5(k) = ReplaceNoHtml(convertSpace(car_Note3, "-"))
			arrCarData6(k) = ReplaceBr(ReplaceNoHtml(car_Content))
		Next
	End IF

	ReDim arrEduData1(EduMaxCnt)
	ReDim arrEduData2(EduMaxCnt)
	ReDim arrEduData3(EduMaxCnt)
	ReDim arrEduData4(EduMaxCnt)
	IF isArray(EduRec) Then
		For k=0 To Ubound(EduRec,2)
			eduNote1 = ChangeBlank(EduRec(0,k))
			eduNote2 = ChangeBlank(EduRec(1,k))
			eduNote3 = ChangeBlank(EduRec(2,k))
			eduSDate = ChangeBlank(EduRec(3,k))
			eduEDate = ChangeBlank(EduRec(4,k))

			arrEduData1(k) = ReplaceNoHtml(convertSpace(eduNote1, "-"))
			arrEduData2(k) = ReplaceNoHtml(convertSpace(eduNote2, "-"))
			arrEduData3(k) = ReplaceNoHtml(convertSpace(eduNote3, "-"))
			arrEduData4(k) = eduSDate & " ~ " & eduEDate
		Next
	End IF

	Response.Write "<tr>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&i+1&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(empNm, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(appField, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&Regdate&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&getApplyStatus(status)&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(name, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(nameEn, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(Phone, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(eTel, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(Email, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(veteransrate, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(veteransrateRel, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(veteransrateNo, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(milservice, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(milEx, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(miltype, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(milclass, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(convertSpace(milgrade, "-"))&"</td>"&Vbcrlf
	Response.Write "<td style=""mso-number-format:'\@'"">"&ReplaceNoHtml(milSDate)&" ~ "&ReplaceNoHtml(milEDate)&"</td>"&Vbcrlf

	For j=0 To LangMaxCnt-1
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrLangData1(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrLangData2(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrLangData3(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrLangData4(j)&"</td>"&Vbcrlf
	Next

	For j=0 To LicMaxCnt-1
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrLicData1(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrLicData2(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrLicData3(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrLicData4(j)&"</td>"&Vbcrlf
	Next

	For j=0 To CarMaxCnt-1
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrCarData1(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrCarData2(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrCarData3(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrCarData4(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrCarData5(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrCarData6(j)&"</td>"&Vbcrlf
	Next

	For j=0 To EduMaxCnt-1
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrEduData1(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrEduData2(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrEduData3(j)&"</td>"&Vbcrlf
		Response.Write "<td style=""mso-number-format:'\@'"">"&arrEduData4(j)&"</td>"&Vbcrlf
	Next

	Response.Write "</tr>"&Vbcrlf
Next
Response.Write "</table>"
Response.Write "</html>"

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Response.ContentType  = "application/x-msexcel"
Response.CacheControl = "public"
Response.AddHeader "Content-Disposition","attachment;filename="&Server.URLPathEncode("지원서 리스트.xls")
%>