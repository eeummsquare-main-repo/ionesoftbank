<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "board" : subMenuCode = "estimate" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Page = uf_getRequest(Request("Page"),"int","","")
pagesize = uf_getRequest(Request("pagesize"),"int","","")

serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","2","0")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

PageLink="estimate.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = uf_getRequest(Request("idx"),"int","","")

IF idx="" Then
	Response.Write ExecJavaalert("잘못된 접근입니다.", 0)
	Response.End
End IF

Sql="SELECT "
Sql=Sql & "D.itemname, "
Sql=Sql & "Qty, "
Sql=Sql & "addoptValue, "
Sql=Sql & "addoptname, "
Sql=Sql & "E.status, "
Sql=Sql & "filenames "
Sql=Sql & ",useridx, adMemo, memoModDate, memoWid, memoWname "
Sql=Sql & "FROM estimate E INNER JOIN estimateDetail D ON E.idx=D.oidx WHERE E.idx="&idx&" Order By D.idx ASC"
Set Rs = DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaalert("견적정보를 찾을수 없습니다.", 0)
	Response.End
Else
	Allrec = Rs.GetRows()
	status = CStr(Allrec(4,i))
	Filenames = Allrec(5,i)
	useridx = Allrec(6,i)

	adMemo = Allrec(7,i)
	memoModDate = ReplaceNoHtml(Allrec(8,i))
	memoWid = ReplaceNoHtml(Allrec(9,i))
	memoWname = ReplaceNoHtml(Allrec(10,i))
End IF

IF Not(isNull(useridx)) Then
	Sql = "SELECT name, id, phone, email FROM Members Where idx = "&Useridx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		UserName = Rs("name")
		Userid = Rs("id")
		Userphone = Rs("phone")
		Useremail = Rs("email")

		Writer = Rs("name")
	Else
		Writer = "삭제회원"
	End IF
End IF

DBcon.Close
Set DBcon = Nothing

Function PT_List()
	IF isArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			selOptionStr="" : imgTag=""
			IF Allrec(2,i)<>"" Then
				tmpaddoptValue = Split(Allrec(2,i),"|")
				tmpaddoptName = Split(Allrec(3,i),"|")

				For j=0 To Ubound(tmpaddoptValue)
					IF selOptionStr<>"" Then selOptionStr = selOptionStr&" / "
					selOptionStr = selOptionStr & "<font color='#9B0000'>"&tmpaddoptName(j)&"</font> : "
					selOptionStr = selOptionStr & tmpaddoptValue(j)
				Next
			End IF

			IF selOptionStr<>"" Then selOptionStr = "<div class=""mt5"">"&selOptionStr&"</div>"

			Response.Write "<tr>"&Vbcrlf
			Response.Write "	<td>"&i+1&"</td>"&Vbcrlf
			Response.Write "	<td class=""left"" style='padding:10px;'>"&ReplaceNoHtml(Allrec(0,i))&""&selOptionStr&"</td>"&Vbcrlf
			Response.Write "	<td>"&Allrec(1,i)&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
		Next
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
	<script type="text/javascript">
	function adMemoOk(){
		var f = document.revFrm;
		var val = confirm("처리내역을 수정합니다.\n수정하시겠습니까?");
		if (val){
			document.revFrm.target="actFrame";
			document.revFrm.action="estimateAdmemoOk.asp"
			document.revFrm.submit()
		}
	}

	function sendEstiMail(){
		var f = document.revFrm;
		var val = confirm("견적완료 메일을 발송하시겠습니까?");
		if (val){
			document.revFrm.target="actFrame";
			document.revFrm.action="estimateMailSend.asp"
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
							<th><span class="">신청자</span></th>
							<td>
								<%=Writer%>
								<% IF UserName<>"" Then %>
								<span class="ml10"><a href='/backoffice/member/addmember.asp?idx=<%=useridx%>' target="_blank" style='color: #008ee3;'>[<%=Userid%> 회원정보 바로가기]</a></span>
								<% End IF %>
							</td>
						</tr>
						<tr>
							<th><span class="">연락처</span></th>
							<td><%=Userphone%></td>
						</tr>
						<tr>
							<th><span class="">이메일</span></th>
							<td><%=Useremail%></td>
						</tr>
					</tbody>
				</table>

				<div class="subTitle">견적요청 제품</div>
				<table class="tbl_col ">
					<colgroup>
						<col width="8%" />
						<col width="*" />
						<col width="10%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">순번</th>
							<th scope="row">요청제품</th>
							<th scope="row">수량</th>
						</tr>
						<%=PT_List()%>
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
								<option value='0' <%=selCheck(status, 0)%>>견적대기</option>
								<option value='9' <%=selCheck(status, 9)%>>견적완료</option>
								<option value='8' <%=selCheck(status, 8)%>>견적취소</option>
							</select>

							<% IF status="9" THen %>
							<input type='button' value="메일발송" class="btn_green" onclick="sendEstiMail()" style='width:100px;'>
							<% Else %>
							<span class="info">상태가 견적 완료일경우 메일 발송 버튼이 발생합니다.</span>
							<% End IF %>
						</td>
					</tr>
					<tr>
						<th>견적파일</th>
						<td colspan='3'>
							<input type='file' name='files' style='width:50%;' class='input fileField'>
							<input type='hidden' name='filename' value='<%=filenames%>'>
							<% IF filenames<>"" Then %>
								<input type='button' value="다운로드" class="btn_gray" style="width:80px" onclick="location.href='/_lib/download.asp?downfile=<%=filenames%>&path=consult'">
								<label><input type='checkbox' name='filedelchk' value='1' class="fileFieldChk"> 삭제</label>
							<% Else %>
								<input type='hidden' name='filedelchk' value='1'>
							<% End IF %>
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