<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub05" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Page = uf_getRequest(Request("Page"),"int","","")
pagesize = uf_getRequest(Request("pagesize"),"int","","")

serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

PageLink="consult.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = uf_getRequest(Request("idx"),"int","","")

IF idx="" Then
	Response.Write ExecJavaalert("잘못된 접근입니다.", 0)
	Response.End
End IF

Sql = "SELECT hopeClass1, hopeClass2, regDiv, name, birthday, sex, phone, email, pName, pPhone, tel, zip, addr1, addr2, note1, note2, note3, note4, note5, content, status, statusChangeDate, adMemo, memoModDate, memoWid, memoWname, regdate FROM Consult Where idx="&idx
Set Rs = DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaalert("접수정보를 찾을수 없습니다.", 0)
	Response.End
Else
	hopeClass1 = Rs("hopeClass1")
	hopeClass2 = Rs("hopeClass2")
	regDiv = Rs("regDiv")
	name = Rs("name")
	birthday = Rs("birthday")
	sex = Rs("sex")
	phone = Rs("phone")
	email = Rs("email")
	pName = Rs("pName")
	pPhone = Rs("pPhone")
	tel = Rs("tel")
	zip = Rs("zip")
	addr1 = Rs("addr1")
	addr2 = Rs("addr2")
	note1 = Rs("note1")
	note2 = Rs("note2")
	note3 = Rs("note3")
	note4 = Rs("note4")
	note5 = Rs("note5")
	content = Rs("content")
	status = Rs("status")
	statusChangeDate = Rs("statusChangeDate")
	adMemo = Rs("adMemo")

	memoModDate = Rs("memoModDate")
	memoWid = ChangeBlank(Rs("memoWid"))
	memoWname = Rs("memoWname")

	regdate = Rs("regdate")
End IF

DBcon.Close
Set DBcon = Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
	<script type="text/javascript">
	function adMemoOk(){
		var f = document.revFrm;
		var val = confirm("처리내역을 수정합니다.\n수정하시겠습니까?");
		if (val){
			document.revFrm.target="actFrame";
			document.revFrm.action="consultadmemoOk.asp"
			document.revFrm.submit()
		}
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
					<h2 class="top_left"><%=GB_SubMenuName%><!-- (<%=langTitle%>)--></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

<table class="tbl_row">
	<colgroup>
		<col width="12%" />
		<col width="*" />
	</colgroup>
	<tbody>
		<tr>
			<th scope="row"><span class="psBul reqTitle">신청일시</span></th>
			<td><%=regdate%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">지원학과</span></th>
			<td>
				<div class="three days">
					<span class="type f psBul">1지망 : </span>
					<b><%=ReplaceNoHtml(hopeClass1)%></b>

					<span class="type r psBul ml20">2지망 : </span>
					<b><%=ReplaceNoHtml(hopeClass2)%></b>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">전형구분</span></th>
			<td>
				<%=regDiv%>학년도 신입생 모집
			</td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">지원자 성명</span></th>
			<td><%=ReplaceNoHtml(name)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">생년월일</span></th>
			<td><%=ReplaceNoHtml(birthday)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">성별</span></th>
			<td><%=ReplaceNoHtml(sex)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">지원자 핸드폰</span></th>
			<td><%=ReplaceNoHtml(phone)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">이메일</span></th>
			<td><%=ReplaceNoHtml(email)%></td>
		</tr>

		<tr>
			<th scope="row"><span class="psBul reqTitle">보호자 성명</span></th>
			<td><%=ReplaceNoHtml(pName)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">보호자 핸드폰</span></th>
			<td><%=ReplaceNoHtml(pPhone)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="">자택 전화번호</span></th>
			<td><%=ReplaceNoHtml(tel)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">주소</span></th>
			<td>
				<% IF zip<>"" Then %>
					(<%=ReplaceNoHtml(zip)%>)&nbsp;
				<% End IF %>
				<%=ReplaceNoHtml(addr1)%>&nbsp;<%=ReplaceNoHtml(addr2)%>
			</td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">최종학력</span></th>
			<td><%=ReplaceNoHtml(note1)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">학력정보</span></th>
			<td><%=ReplaceNoHtml(note2)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">졸업후계획</span></th>
			<td><%=ReplaceNoHtml(note3)%></td>
		</tr>
		<tr>
			<th scope="row"><span class="psBul reqTitle">지원경로</span></th>
			<td>
				<%=ReplaceNoHtml(note4)%>
				<% IF note5<>"" Then %>
				(<%=ReplaceNoHtml(note5)%>)
				<% End IF %>
			</td>
		</tr>
		<tr>
			<th scope="row"><span class="">지원동기</span></th>
			<td><%=ReplaceBr(ReplaceNoHtml(content))%></td>
		</tr>
	</tbody>
</table>

<form name='revFrm' id='revFrm' method='post' style='margin:0;' ENCTYPE="multipart/form-data">
<input type='hidden' name='idx' id="modiidx" value="<%=idx%>">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="serStatus" value="<%=serStatus%>">
<input type="hidden" name="seritem" value="<%=seritem%>">
<input type="hidden" name="SearchStr" value="<%=ReplaceTextField(oSearchstr)%>">
<input type="hidden" name="pagesize" value="<%=pagesize%>">
<input type="hidden" name="serDate1" value="<%=serDate1%>">
<input type="hidden" name="serDate2" value="<%=serDate2%>">
<div class="subTitle">처리결과</div>
<table class="tbl_row box">
	<colgroup>
		<col width="12%" />
		<col width="*" />
	</colgroup>
	<tr>
		<th>상태</th>
		<td colspan='3'>
			<select name='status'>
				<option value="">상태 전체</option>
				<option value='0' <%=selCheck(status, 0)%>>대기중</option>
				<option value='1' <%=selCheck(status, 1)%>>접수완료</option>
				<option value='3' <%=selCheck(status, 3)%>>면접완료</option>
				<option value='8' <%=selCheck(status, 8)%>>불합격</option>
				<option value='9' <%=selCheck(status, 9)%>>합격</option>
				<option value='99' <%=selCheck(status, 99)%>>신청취소</option>
			</select>
		</td>
	</tr>
	<tr>
		<th>처리결과</th>
		<td colspan='3'>
			<% IF memoWid<>"" Then %>
			<div style='color:#000; padding:0 0 5px 5px'>최종 수정자 : <%=memoWname%> [<%=memoWid%>] | <%=memoModDate%></div>
			<% End IF %>
			<textarea name='adMemo' id="adMemo" style='width:100%; word-break:break-all; padding:10px;' rows='7'><%=adMemo%></textarea>
			<div style='' class="mt5"><a href="javascript:adMemoOk()" class="btn_gray" style='width:100%; font-size:14px; line-height:20px;'>처리결과 저장</a></div>
		</td>
	</tr>
</table>
</form>

<div class="btn_center pt30">
	<a href="<%=PageLink%>?page=<%=page%>&<%=PageStr%>" class="btn_largeW">목록보기</a>
</div>


			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->