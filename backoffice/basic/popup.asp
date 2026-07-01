<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "popup" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim PageLink,PageStr,PageSize,Page,Cmd,Allrec,Count,TotalPage
Dim langTitle, langmode
langmode = uf_getRequest(Request("langmode"),"int","1","0")
Call getLangModeTitle(langmode)

PageLink="popup.asp"
PageStr=""
PageSize=20
Page=GetPage()

Set Cmd=CreateCommand(DBcon,"FM_AP_PopupList",adCmdStoredProc)
With Cmd
	.Parameters.Append CreateInputParameter("@langmode",adTinyint,1,langmode)
	.Parameters.Append CreateInputParameter("@Page",adInteger,4,Page)
	.Parameters.Append CreateInputParameter("@PageSize",adInteger,4,PageSize)
	.Parameters.Append CreateOutPutParameter("@Record_Cnt",adInteger,4)
	Set Rs=.Execute
End With

IF Not(Rs.Bof Or Rs.Eof) Then
	Allrec=Rs.GetRows

	Rs.Close
	Set Rs=Nothing

	Count=Cmd.Parameters(3).Value
	TotalPage=Int((CInt(Count)-1)/CInt(PageSize)) +1
Else
	Count = 0 : TotalPage = 1
End IF

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_PopupList
	Dim i,Title,PopStatus,Sort,Num,ToDay
	Num=1

	IF IsArray(Allrec) Then
		Num = GetTextNumDesc(Page,Pagesize,Count)
		ToDay = Year(date)&AddZero(MonTh(date))&AddZero(Day(date))

		For i=0 To Ubound(Allrec,2)
			IF Allrec(1,i)=1 Then
				Sort="이미지"
			Else
				Sort="HTML"
			End IF
			Title=Allrec(2,i)

			IF ToDay>Allrec(4,i) Then
				PopStatus="종료"
			ElseIF ToDay<Allrec(3,i) Then
				PopStatus="<font color='blue'>팝업대기</font>"
			Else
				PopStatus="<font color='red'>실행중</font>"
			End IF

			Response.Write "<tr>"&Vbcrlf
			Response.Write "	<td align='center'>"&Num&"</td>"&Vbcrlf
'			IF Allrec(5,i)=0 Then
'				Response.Write "	<td align='center'>PC팝업</td>"&Vbcrlf
'			Else
'				Response.Write "	<td align='center' style='color: #a20000'>모바일팝업</td>"&Vbcrlf
'			End IF
			Response.Write "	<td align='center'>"&Sort&"</td>"&Vbcrlf
			Response.Write "	<td class=""left"">"&ReplaceNoHtml(Title)&"</td>"&Vbcrlf
			Response.Write "	<td align='center'>"&DateStr(Allrec(3,i))&"</td>"&Vbcrlf
			Response.Write "	<td align='center'>"&DateStr(Allrec(4,i))&"</td>"&Vbcrlf
			Response.Write "	<td align='center'>"&PopStatus&"</td>"&Vbcrlf
			Response.Write "	<td align='center'>"&Vbcrlf
			Response.Write "		<a href=""javascript:popupEdit("&Allrec(0,i)&");"" class=""btn_gray"">수정</a>"&Vbcrlf
			Response.Write "		<a href=""javascript:popupDel("&Allrec(0,i)&");"" class=""btn_gray bc_red"">삭제</a>"&Vbcrlf
			Response.Write "	</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='7' style=""height:200px;"">검색된 게시물이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script language="JavaScript">
<!--
// 카테고리 수정
function popupEdit( idx ) {
	location.href='popup_edit.asp?idx='+idx;
}

// 카테고리 삭제
function popupDel( idx ) {
    var choose = confirm( '삭제 하시겠습니까?');
	if(choose) {	location.href='popup_del_ok.asp?langmode=<%=langmode%>&idx='+idx; }
	else { return; }
}
//-->
</script>
</head>

<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%> <!-- [<%=langTitle%>] --></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<!-- <div class="subTab mt20 mb20">
					<a href="?langmode=0" class="<%=iif_compare(langmode, 0, "active")%>"><span>KR</span></a>
					<a href="?langmode=1" class="<%=iif_compare(langmode, 1, "active")%>"><span>EN</span></a>
				</div> -->

				<table class="tbl_col">
					<caption>팝업관리 목록</caption>
					<colgroup>
						<col style="width: 6%" />
						<!-- <col style="width: 8%" /> -->
						<col style="width: 10%" />
						<col style="" />
						<col style="width: 8%" />
						<col style="width: 8%" />
						<col style="width: 8%" />
						<col style="width: 12%" />
					</colgroup>
					<tr bgcolor="#F5F5F5">
						<th scope="row">No</th>
						<!-- <th scope="row">팝업분류</th> -->
						<th scope="row">출력 형태</th>
						<th scope="row">브라우져 타이틀바</th>
						<th scope="row">시작일</th>
						<th scope="row">종료일</th>
						<th scope="row">팝업상태</th>
						<th scope="row">관리</th>
					</tr>
					<%PT_PopupList%>
				</table>

				<div class="tbl_bottom">
					<div class="top_right">
						<a href="popup_add.asp?langmode=<%=langmode%>" class="btn_gray btn_gray100">팝업추가</a>
					</div>
				</div>

				<%=PT_PageLink(PageLink,PageStr,"")%>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->