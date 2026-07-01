<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "admin" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec
Dim strWhere
Dim Record_Cnt,TotalPage,PageSize,Page,Count

Page=GetPage()
IF PageSize = "" Then PageSize=20

Sql="select top "&PageSize&" idx,id,name,username,tel,logincnt,lastlogin,lastloginIP,regdate,email from admin WHERE 1=1 "&strWhere&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from admin WHERE 1=1 "&strWhere&" order by Idx DESC) order by Idx DESC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) from admin WHERE 1=1 "&strWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count = 0 : TotalPage = 1

	IF CInt(page)>1 Then
		Response.Redirect "?page="&CInt(page)-1&"&serdate1="&serdate1&"&serdate2="&serdate2&"&pagesize="&pagesize&"&seritem="&seritem&"&serstr="&serstr
	End IF
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BBsList
	Dim i,Num
	Num=1

	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr>"&Vbcrlf
			Response.Write "	<td>"&Num&"</td>"&Vbcrlf
			Response.Write "	<td>"&ReplaceNoHtml(Allrec(1,i))&"</td>"&Vbcrlf
			Response.Write "	<td>"&ReplaceNoHtml(Allrec(2,i))&"</td>"&Vbcrlf
			Response.Write "	<td>"&ReplaceNoHtml(Allrec(3,i))&"</td>"&Vbcrlf
			Response.Write "	<td>"&ReplaceNoHtml(Allrec(4,i))&"</td>"&Vbcrlf
			Response.Write "	<td>"&Allrec(5,i)&"</td>"&Vbcrlf
			Response.Write "	<td>"&Allrec(6,i)&"</td>"&Vbcrlf
			Response.Write "	<td>"&Allrec(7,i)&"</td>"&Vbcrlf
			Response.Write "	<td>"&Left(Allrec(8,i),10)&"</td>"&Vbcrlf
			Response.Write "	<td>"&Vbcrlf
			Response.Write "		<a href=""javascript:boardModify("&Allrec(0,i)&");"" class=""btn_gray"">수정</a>"&Vbcrlf
			IF CStr(Allrec(0,i)) = 1 Then
				Response.Write "		<a href=""javascript:alert('Super Admin 계정입니다.\n해당 계정은 삭제가 불가능합니다.')"" class=""btn_gray bc_red"">삭제</a>"&Vbcrlf
			Else
				Response.Write "		<a href=""javascript:boardDel("&Allrec(0,i)&");"" class=""btn_gray bc_red"">삭제</a>"&Vbcrlf
			End IF
			Response.Write "	</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='10' style=""height:200px;"">검색된 관리자가 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardModify(idx){
	document.paramtransFrm.idx.value = idx;
	document.paramtransFrm.action = "adminAdd.asp";
	document.paramtransFrm.submit();
}
function boardDel(idx){
	var value=confirm("선택하신 관리자를 삭제하시겠습니까?");
	if(value){
		document.paramtransFrm.idx.value = idx;
		document.paramtransFrm.action = "adminDel.asp";
		document.paramtransFrm.submit();
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
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<div class="tbl_top">
					<div class="top_right">
						<a href="adminAdd.asp" class="btn_gray btn_gray100">관리자추가</a>
					</div>
				</div>

				<table class="tbl_col">
					<caption>부운영자관리 목록</caption>
					<colgroup>
						<col style="width: 6%" />
						<col />
						<col />
						<col />
						<col style="width: 10%" />
						<col style="width: 6%" />
						<col style="width: 13%" />
						<col style="width: 10%" />
						<col style="width: 8%" />
						<col style="width: 12%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="row">NO</th>
							<th scope="row">아이디</th>
							<th scope="row">관리자명</th>
							<th scope="row">이름</th>
							<th scope="row">연락처</th>
							<th scope="row">접속수</th>
							<th scope="row">최근접속일시</th>
							<th scope="row">최근접속IP</th>
							<th scope="row">등록일</th>
							<th scope="row">관리</th>
						</tr>
					</thead>
					<tbody>
					<tbody>
						<%PT_BBsList%>
					</tbody>
				</table>

				<%=PT_PageLink("","","")%>

				<form name="paramtransFrm" id="paramtransFrm" method="get">
					<input type="hidden" name="idx" value="">
					<input type="hidden" name="page" value="<%=page%>">
				</form>
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->