<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "emp" : subMenuCode = "empApply" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
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

PageLink = "index.asp"
PageStr = "serEmpidx="& serEmpidx &"&serStatus="& serStatus &"&seritem="& seritem &"&pagesize="& PageSize &"&searchStr="& Server.UrlEncode(oSearchStr)
'=============================================

IDX = uf_getRequest(Request("idx"),"int","","")

IF idx<>"" Then
	Sql = "SELECT status, name, nameEn, phone, eTel, email, veteransrate, veteransrateRel, veteransrateNo, milservice, milEx, miltype, milclass, milSDate, milEDate, milgrade, empNm, appField, arrFile, regdate FROM empApply WHERE isComplete=1 AND idx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		status = ChangeBlank(Rs("status"))
		name = ChangeBlank(Rs("name"))
		nameEn = ChangeBlank(Rs("nameEn"))
		phone = ChangeBlank(Rs("phone"))
		etel = ChangeBlank(Rs("etel"))
		email = ChangeBlank(Rs("email"))
		veteransrate = ChangeBlank(Rs("veteransrate"))
		veteransrateRel = ChangeBlank(Rs("veteransrateRel"))
		veteransrateNo = ChangeBlank(Rs("veteransrateNo"))

		milservice = ChangeBlank(Rs("milservice"))
		milEx = ChangeBlank(Rs("milEx"))
		miltype = ChangeBlank(Rs("miltype"))
		milclass = ChangeBlank(Rs("milclass"))
		milSDate = ChangeBlank(Rs("milSDate"))
		milEDate = ChangeBlank(Rs("milEDate"))
		milgrade = ChangeBlank(Rs("milgrade"))
		empNm = ChangeBlank(Rs("empNm"))
		appField = ChangeBlank(Rs("appField"))

		arrFile = Split(ChangeBlank(Rs("arrFile")), "|")
		IF Ubound(arrFile)<4 Then ReDim Preserve arrFile(4)

		regdate = ChangeBlank(Rs("regdate"))
		isRecord = True
	End IF
End IF

IF Not(isRecord) Then
	Response.Write ExecJavaAlert("지원내역을 찾을수 없습니다.",0)
	Response.END
End IF

Sql = "SELECT language, lang_testNm, lang_testScore, lang_examDate FROM empApplyLang WHERE appidx="&idx
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then langRec = Rs.GetRows()

Sql = "SELECT cert_Note1, cert_Note2, cert_Note3, cert_Date FROM empApplyCert WHERE appidx="&idx
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then certRec = Rs.GetRows()

Sql = "SELECT car_Company, car_SDate, car_EDate, car_Note1, car_Note2, car_Note3, car_Content FROM empApplyCareer WHERE appidx="&idx
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then carRec = Rs.GetRows()

Sql = "SELECT eduNote1, eduNote2, eduNote3, eduSDate, eduEDate FROM empApplyEdu WHERE appidx="&idx
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then eduRec = Rs.GetRows()

SEt Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript">
	function fnExcelReport(id, title) {
		var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
		tab_text = tab_text + '<head><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
		tab_text = tab_text + '<xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
		tab_text = tab_text + '<x:Name>입사지원서</x:Name>';
		tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
		tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';

		tab_text = tab_text + '<style>';
		tab_text = tab_text + '.app__table{border:thin solid #000}';
		tab_text = tab_text + '.dummy{height:20px;}';
		tab_text = tab_text + '.tit{height:60px; font-size:20px; font-weight:bold; text-align:center;}';
		tab_text = tab_text + '.app__table th{width:100px; background-color:#fbfbfc; border:thin solid #000}';
		tab_text = tab_text + '.app__table td{background-color:#fff; border:thin solid #000}';
		tab_text = tab_text + 'br{mso-data-placement:same-cell;}';
		tab_text = tab_text + '</style>';

		tab_text = tab_text + '<table><tr><td></td></tr><tr><td class="tit" colspan="4">입사지원서</td></tr><tr><td></td></tr></table>';

		var exportTable = $('#' + id).clone();

		exportTable.find('input').each(function (index, elem) { $(elem).remove(); });
		
		/*
		exportTable.find('.editorInTB td').each(function (index, elem) {
			$(elem).html(  $(elem).html().replace(/(<([^>]+)>)/ig," ")  )
		});
		exportTable.find('.summary td').each(function (index, elem) {
			$(elem).html(  $(elem).html().replace(/<(\/ul|ul)([^>]*)>/gi,"")  )
			$(elem).html(  $(elem).html().replace(/<(\/li|li)([^>]*)>/gi,"")  )
		});
		exportTable.find('td,tr,table').each(function (index, elem) {
			$(elem).removeAttr("width").removeAttr("height")
		});
		*/

		exportTable.find('.app__table').each(function (index, elem) {
			$(elem).append("<table></table>")
		});
		exportTable.find('td.image').each(function (index, elem) {
			$(elem).attr("valign","middle").attr("align","center");
			$(elem).find("img").attr("width","100").attr('style', "")
		});
		exportTable.find('.carrer__name').each(function (index, elem) {
			$(elem).append(" : ")
		});
		exportTable.find('td').each(function (index, elem) {
			$(elem).attr('style', "mso-number-format:'\@';");
		});
		exportTable.find('.table_close').remove();
		
		tab_text = tab_text + exportTable.html();
		tab_text = tab_text + '</body></html>';

		var data_type = 'data:application/vnd.ms-excel';
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf("MSIE ");
		var fileName = title + '.xls';
		//Explorer 환경에서 다운로드
		if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
			if (window.navigator.msSaveBlob) {
				var blob = new Blob([tab_text], {
					type: "application/csv;charset=utf-8;"
				});
				navigator.msSaveBlob(blob, fileName);
			}
		} else {
			var blob2 = new Blob([tab_text], {
				type: "application/csv;charset=utf-8;"
			});
			var filename = fileName;
			var elem = window.document.createElement('a');
			elem.href = window.URL.createObjectURL(blob2);
			elem.download = filename;
			document.body.appendChild(elem);
			elem.click();
			document.body.removeChild(elem);
		}
	}

	function contentPrint() {
		var windowLeft = (screen.width-800)/2; //신경 쓸거 없음 자리 잡는거
		var windowTop = (screen.height-770)/2; //신경 쓸거 없음 자리 잡는거
		var printURL = "/backoffice/pop_print.asp?popTitle=입사지원서"; // pop_print.html 경로 적어주면 됨
		window.open(printURL,"content",'width=800, height=770, menubar=no, scrollbars=no,status=no,resizable=no,top=' + windowTop + ',left=' + windowLeft + ''); // 뭐 그닦 신경 쓸거 없음
	}
</script>

</head>
<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

<div id='printArea' name='printArea'>
	<style>
	table{border-collapse: collapse;}
	body {font-size: 14px; letter-spacing: -0.02em; line-height:16px}
	.app__cnts + .app__cnts {margin: 30px 0 0;}

	.squareTit {display: block; position: relative; color: #1b1b1b; margin: 0 0 10px; font-weight:600}
	.squareTit span{display:inline-block; margin-right:5px; font-size:16px;}

	.app__table {width: 100%; border-top: 2px solid #000;}
	.app__table + .app__table {margin: 10px 0 0; border-top: 1px solid #ddd;}
	.app__table tr {border-bottom: 1px solid #ddd;}
	.app__table th {border-right: 1px solid #ddd; background: #fbfbfc; font-weight: 500; color: #1b1b1b; padding: 10px; width: 100px;}
	.app__table td {padding: 5px 10px; font-weight: 500; color: #333333;}

	.inputWrap__txt {font-weight: 400; color: #777; margin: 0 1rem 0 0;}
	.app__tr--lang .inputWrap__txt {margin: 0 0 0 0.5rem;}

	.rcv__cnts {display: flex; border: 1px solid #dadada; border-top: 1px solid #333333; padding: 20px; align-items: center;}
	.rcv__txtWrap {padding: 0 0 0 30px; width: calc(100% - 260px);}
	.rcv__tit {display: block; font-weight: 500; color: #1b1b1b; margin: 0 0 20px; font-size:16px}
	.rcv__tit span {font-weight: 400; color: #666666;}
	.rcv__infoListWrap {display: flex; align-items: flex-start;}
	.rcv__infoList {width: 50%; display: flex; flex-wrap: wrap; align-items: flex-start; gap: 15px;}
	.rcv__infoList li {display: flex; width: 100%;}
	.rcv__name {position: relative; font-weight: 400; color: #666666; width: 110px;}
	.rcv__name::after {content: ":"; position: absolute; right: 0; top: 0;}
	.rcv__val {font-weight: 400; color: #1b1b1b; padding: 0 0 0 20px; width: calc(100% - 110px); font-style:normal;}
	.rcv__valList {display: flex; flex-wrap: wrap; gap: 4rem; }
	.left .rcv__name {width: 80px;}
	.left .rcv__val {width: calc(100% - 80px);}

	.blueTxt {color: #004ea2;}
	.rcv__carrerWrap {}
	.tdCell div{display:inline-block; margin-right:40px;}
	.carrerHeader {margin: 0 0 15px;}
	.carrerDate span{display:block;}
	.carrer__tit {font-weight: 600; color: #333333;}
	.carrer__titSub {font-weight: 400; color: #666666;}
	.carrer__name {display:inline-block; width: 70px; position: relative;}
	.carrer__name::after {content: ":"; position: absolute; right: 0; top: 0;}
	.carrer__val {display:inline-block; padding: 0 0 0 1rem;}
	.carrer__midTit {display: block; font-weight: 500; color: #333333; margin: 10px 0 0; font-style:normal}
	.carrer__txt {font-weight: 400; color: #666666; line-height:20px;}
	</style>

	<div class="" style='clear:both;' id="testExlTB">
		<div class="app__cntsWrap">
			<div class="app__cnts">
				<table class="app__table">
					<tr class="appEdu__tr">
						<th>공고명</th>
						<td><%=ReplaceNoHtml(empNm)%></td>
						<th>지원일</th>
						<td><%=Regdate%></td>
					</tr>
					<tr class="appEdu__tr">
						<th>지원부분</th>
						<td colspan="3"><%=ReplaceNoHtml(appField)%></td>
					</tr>

				</table>
			</div>

			<div class="app__cnts">
				<table>
					<tr>
						<td colspan="4" class="squareTit"><span>■</span>인적사항</td>
					</tr>
				</table>
				<table class="app__table">
					<tr>
						<th>이름</th>
						<td class="left"><%=ReplaceNoHtml(name)%></td>
						<th>영문이름</th>
						<td class="left"><%=ReplaceNoHtml(nameEn)%></td>
					</tr>
					<tr>
						<th>휴대폰</th>
						<td class="left"><%=ReplaceNoHtml(Phone)%></td>
						<th>비상연락처</th>
						<td class="left"><%=ReplaceNoHtml(convertSpace(eTel, "-"))%></td>
					</tr>
					<tr>
						<th>이메일</th>
						<td class="left" colspan="3"><%=ReplaceNoHtml(convertSpace(Email, "-"))%></td>
					</tr>
					<tr>
						<th>보훈대상 여부</th>
						<td class="left" colspan="3"><%=ReplaceNoHtml(convertSpace(veteransrate, "-"))%> / <%=ReplaceNoHtml(convertSpace(veteransrateRel, "-"))%> / <%=ReplaceNoHtml(convertSpace(veteransrateNo, "-"))%></td>
					</tr>
				</table>
			</div>
			<div class="app__cnts">
				<table>
					<tr>
						<td colspan="4" class="squareTit"><span>■</span>병역사항</td>
					</tr>
				</table>
				<table class="app__table">
					<tr class="app__tr--army">
						<th>복무구분</th>
						<td><%=ReplaceNoHtml(convertSpace(milservice, "-"))%></td>
						<th>면제사유</th>
						<td><%=ReplaceNoHtml(convertSpace(milEx, "-"))%></td>
					</tr>
					<tr class="app__tr--army">
						<th>군별</th>
						<td><%=ReplaceNoHtml(convertSpace(miltype, "-"))%></td>
						<th>계급</th>
						<td><%=ReplaceNoHtml(convertSpace(milgrade, "-"))%></td>
					</tr>
					<tr class="app__tr--army">
						<th>역종</th>
						<td><%=ReplaceNoHtml(convertSpace(milclass, "-"))%></td>
						<th>복무기간</th>
						<td><%=ReplaceNoHtml(milSDate)%> ~ <%=ReplaceNoHtml(milEDate)%></td>
					</tr>
				</table>
			</div>

	<% IF isArray(langRec) Then %>
	<div class="app__cnts">
		<table>
			<tr>
				<td colspan="4" class="squareTit"><span>■</span>외국어역량</td>
			</tr>
		</table>
		<div>
			<table class="app__table">
				<%
				IF isArray(langRec) Then
					For i=0 To Ubound(langRec,2)
						language = ChangeBlank(langRec(0,i))
						lang_testNm = ChangeBlank(langRec(1,i))
						lang_score = ChangeBlank(langRec(2,i))
						lang_examDate = ChangeBlank(langRec(3,i))
				%>
				<tr class="app__tr--lang">
					<th>외국어 정보</th>
					<td colspan="3" class="tdCell">
						<div><%=ReplaceNoHtml(language)%> [<span class="blueTxt"><%=ReplaceNoHtml(convertSpace(lang_testNm, "-"))%></span>]</div>
						<div>급수 및 점수 : <%=ReplaceNoHtml(convertSpace(lang_score, "-"))%></div>
						<div>취득일 : <%=ReplaceNoHtml(convertSpace(lang_examDate, "-"))%></div>
					</td>
				</tr>
				<%
					Next
				End IF
				%>
			</table>
		</div>
	</div>
	<% End IF %>

	<% IF isArray(certRec) Then %>
	<div class="app__cnts license">
		<table>
			<tr>
				<td colspan="4" class="squareTit"><span>■</span>자격증 사항</td>
			</tr>
		</table>
		<table class="app__table">
			<%
			IF isArray(certRec) Then
				For i=0 To Ubound(certRec,2)
					cert_Note1 = ChangeBlank(certRec(0,i))
					cert_Note2 = ChangeBlank(certRec(1,i))
					cert_Note3 = ChangeBlank(certRec(2,i))
					cert_Date = ChangeBlank(certRec(3,i))
			%>
			<tr class="app__tr--lang">
				<th>자격증 정보</th>
				<td colspan="3" class="tdCell">
					<div>자격명 :  <span class="blueTxt"><%=ReplaceNoHtml(convertSpace(cert_Note1, "-"))%></span></div>
					<div>발급기관 : <%=ReplaceNoHtml(convertSpace(cert_Note2, "-"))%></div>
					<div>등록번호 : <%=ReplaceNoHtml(convertSpace(cert_Note3, "-"))%></div>
					<div>취득일 : <%=ReplaceNoHtml(convertSpace(cert_Date, "-"))%></div>
				</td>
			</tr>
			<%
				Next
			End IF
			%>
		</table>
	</div>
	<% End IF %>

	<% IF isArray(carRec) Then %>
	<div class="app__cnts">
		<table>
			<tr>
				<td colspan="4" class="squareTit"><span>■</span>경력사항</td>
			</tr>
		</table>

		<table class="app__table">
			<%
			IF isArray(carRec) Then
				For i=0 To Ubound(carRec,2)
					car_Company = ChangeBlank(carRec(0,i))
					car_SDate = ChangeBlank(carRec(1,i))
					car_EDate = ChangeBlank(carRec(2,i))
					car_Note1 = ChangeBlank(carRec(3,i))
					car_Note2 = ChangeBlank(carRec(4,i))
					car_Note3 = ChangeBlank(carRec(5,i))
					car_Content = ChangeBlank(carRec(6,i))
			%>
			<tr class="app__tr--carrer">
				<th class="carrerDate"><%=ReplaceNoHtml(car_SDate)%> ~ <br><%=ReplaceNoHtml(car_EDate)%></th>
				<td colspan="3">
					<div class="carrerHeader">
						<strong class="carrer__tit"><%=ReplaceNoHtml(convertSpace(car_Company, "-"))%></strong>
						<span class="carrer__titSub">( <%=ReplaceNoHtml(convertSpace(car_Note1, "-"))%> / <%=ReplaceNoHtml(convertSpace(car_Note2, "-"))%> )</span>
					</div>
					<div>
						<span class="carrer__name">근무연한</span>
						<span class="carrer__val"><%=ReplaceNoHtml(convertSpace(car_Note3, "-"))%></span>
					</div>

					<div class="carrer__midTit">[<span class="blueTxt">담당업무 세부사항</span>]</div>
					<div class="carrer__txt"><%=ReplaceBr(ReplaceNoHtml(car_Content))%></div>
				</td>
			</tr>
			<%
				Next
			End IF
			%>
		</table>
	</div>
	<% End IF %>

	<% IF isArray(eduRec) Then %>
	<div class="app__cnts license">
		<table>
			<tr>
				<td colspan="4" class="squareTit"><span>■</span>교육사항</td>
			</tr>
		</table>
		<table class="app__table">
			<%
			IF isArray(eduRec) Then
				For i=0 To Ubound(eduRec,2)
					eduNote1 = ChangeBlank(eduRec(0,i))
					eduNote2 = ChangeBlank(eduRec(1,i))
					eduNote3 = ChangeBlank(eduRec(2,i))
					eduSDate = ChangeBlank(eduRec(3,i))
					eduEDate = ChangeBlank(eduRec(4,i))
			%>
			<tr class="app__tr--lang">
				<th>교육 정보</th>
				<td colspan="3" class="tdCell">
					<div>부분 :  <span class="blueTxt"><%=ReplaceNoHtml(convertSpace(eduNote1, "-"))%></span></div>
					<div>과정명 : <%=ReplaceNoHtml(convertSpace(eduNote2, "-"))%></div>
					<div>교육기관 : <%=ReplaceNoHtml(convertSpace(eduNote3, "-"))%></div>
					<div>교육기간 : <%=ReplaceNoHtml(eduSDate)%> ~ <%=ReplaceNoHtml(eduEDate)%></div>
				</td>
			</tr>
			<%
				Next
			End IF
			%>
		</table>
	</div>
	<% End IF %>

			<% IF IsArray(arrFile) Then %>
			<div class="app__cnts conViewArea">
				<table>
					<tr>
						<td colspan="4" class="squareTit"><span>■</span>자료 첨부</td>
					</tr>
				</table>
				<table class="app__table">
				<% For i=0 To UBound(arrFile)-1 %>
					<tr class="app__tr--carrer">
						<th>제출서류 <%=i+1%></th>
						<td colspan="3">
							<a class="rcv__downTxt" href="/_lib/download.asp?path=apply/<%=useridx%>&downfile=<%=arrFile(i)%>" download><%=ReplaceNoHtml(arrFile(i))%></a>
						</td>
					</tr>
				<% Next%>
				</table>
			</div>
			<% End IF %>
		</div>
	</div>
</div>

				<div class="btn_center pt30">
					<a href="javascript:contentPrint()" class="btn_largeG bc_green">프린트</a>
					<a href="javascript:fnExcelReport('testExlTB', '<%=ReplaceNoHtml(name)%>_지원서')" class="btn_largeW bc_green">엑셀다운로드</a>
					<a href="<%=PageLink%>?page=<%=page%>&<%=PageStr%>" class="btn_largeW">목록보기</a>
				</div>


<%
Function PT_judgeList
	IF isArray(judgeRec) Then
		Dim score1, score2, comment, id, username
		For i=0 To Ubound(judgeRec,2)

			score1 = ChangeBlank(judgeRec(0,i))
			score2 = ChangeBlank(judgeRec(1,i))
			comment = ChangeBlank(judgeRec(2,i))
			id = ChangeBlank(judgeRec(3,i))
			username = ChangeBlank(judgeRec(4,i))
			regdate = ChangeBlank(judgeRec(5,i))
			IF id="" Then
				userINFO = "탈퇴관리자"
			Else
				userINFO = username & "<br>["&id&"]"
			End IF

			Response.Write "<tr class=""appEdu__tr"">"&Vbcrlf
			Response.Write "	<td class=""center"">"&i+1&"</td>"&Vbcrlf
			Response.Write "	<td>"&userINFO&"</td>"&Vbcrlf
			Response.Write "	<td>"&getScoreLevel(score1)&"</td>"&Vbcrlf
			Response.Write "	<td>"&getScoreLevel(score2)&"</td>"&Vbcrlf
			Response.Write "	<td class=""left"">"&ReplaceNoHtml(comment)&"</td>"&Vbcrlf
			Response.Write "	<td>"&uf_ConvertDateFormat(regdate,89)&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	End IF
End Function
%>

<% IF isArray(judgeRec) Then %>

<script type="text/javascript">
function judgeExcelDown(){
	actFrm.action='_judgeExcelDown.asp';
	actFrm.submit();
}
</script>

<div class="subTitle">심사내역</div>
<div class="app__cnts">
	<table class="tbl_col">
		<colgroup>
			<col width="80"></col>
			<col width="150"></col>
			<col width="90"></col>
			<col width="90"></col>
			<col width=""></col>
			<col width="110"></col>
		</colgroup>
		<tr class="appEdu__tr">
			<th>No</th>
			<th>심사자</th>
			<th>인성</th>
			<th>직무적합성</th>
			<th>코멘트</th>
			<th>심사일</th>
		</tr>
		<%=PT_judgeList%>
	</table>
</div>
<div class="btn_right">
	<a href="javascript:judgeExcelDown()" class="btn_largeW bc_green" style="padding: 10px 20px">심사내역 엑셀다운로드</a>
</div>
<% End IF %>

				<form name="actFrm" id="actFrm" class="" method="get">
					<input type='hidden' name="idx" value="<%=idx%>">
					<input type='hidden' name="procMode" value="">
					<input type='hidden' name="selVal" value="">
					<input type='hidden' name='page' value='<%=page%>'>
					<input type='hidden' name='pagesize' value='<%=pagesize%>'>
					<input type='hidden' name='serEmpidx' value='<%=serEmpidx%>'>
					<input type='hidden' name='seritem' value='<%=seritem%>'>
					<input type='hidden' name='serGroup' value='<%=serGroup%>'>
					<input type='hidden' name='serRegdiv' value='<%=serRegdiv%>'>
					<input type='hidden' name='serStatus' value='<%=serStatus%>'>
					<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				</form>


			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->