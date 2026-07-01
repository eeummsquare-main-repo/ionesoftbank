<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "intra" : subMenuCode = "intra" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec,Page,PageSize,Record_Cnt,TotalPage,Count

'==========검색 관련=========================================
page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("PageSize"),"int","","10")

search = uf_getRequest(Request("search"),"char","","")
searchStr = uf_getRequest(Request("searchstr"),"char","","")	
searchMemsort = uf_getRequest(Request("searchMemsort"),"int","","")

oSearchStr = Request("searchstr")

IF searchMemsort<>"" Then  StrWhere = StrWhere & " And usersort = "&searchMemsort&" "
IF Search<>"" Then StrWhere = StrWhere & " And "&Search&" LIKE 'N%"&SearchStr&"%' "

PageLink="intraUser.asp"
PageStr="pagesize="&PageSize&"&search="&search&"&searchMemsort="&searchMemsort&"&searchstr="&Server.UrlEncode(oSearchStr)
'==========검색 관련=========================================

Sql="Select top "&PageSize&" idx,id,name,regdate,email from intraUser where 1=1 "&StrWhere&" AND idx not in"
Sql=Sql & "(select top "&(Page-1)*Pagesize&" idx from intraUser Where 1=1 "&StrWhere&" order by idx ASC) order by idx ASC"

Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,dbcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(idx) from intraUser Where 1=1 "&StrWhere)
	Count=Record_Cnt(0)
	TotalPage=Int((CInt(Count)-1)/CInt(PageSize)) +1 
	Allrec=Rs.GetRows
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_Mlist
	Dim i,No
	IF Page=1 Then
		No=Count
	Else
		No=Count-(Page-1)*Pagesize
	End IF
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr>"&Vbcrlf
			Response.Write "<td>"&No&"</td>"&Vbcrlf
			Response.Write "<td>"&ReplaceNoHtml(Allrec(1,i))&"</td>"&Vbcrlf
			Response.Write "<td>"&ReplaceNoHtml(Allrec(2,i))&"</td>"&Vbcrlf
			Response.Write "<td>"&ReplaceNoHtml(Allrec(4,i))&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(3,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Vbcrlf
			Response.Write "		<a href='useradd.asp?idx="&Allrec(0,i)&"' class=""btn_default"">수정</a>"&Vbcrlf
			Response.Write "		<a href='javascript:memDel("&Allrec(0,i)&");' class=""btn_default"">삭제</a>"&Vbcrlf
			Response.Write "</td></tr>"&Vbcrlf
			No=No-1
		Next
	Else
		Response.Write "<tr><td colspan='6' align='center' height='200'>검색된 유저가 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function memDel(idx){
	var value=confirm("선택하신 유저를 삭제 하시겠습니까?");
	if(value){
		document.memform.idx.value=idx;
		document.memform.action='intraUserDel.asp';
		document.memform.submit();
	}
}
function searchGo(){
	var f=document.search;
	f.submit();
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
					<h2 class="top_left">인트라넷 유저관리</h2>
					<a href="/backoffice/">HOME</a> &gt; 기본관리 &gt; <span>인트라넷 유저관리</span>
				</div>

				<div class="tbl_top">
					<div class="top_right">
						<a href="userAdd.asp" class="btn_gray btn_gray100">유저추가</a>
					</div>
				</div>

				<form name='memform' method='get' action=''>
				<input type='hidden' name='idx' value=''>
				<input type='hidden' name='mode' value=''>
				<input type='hidden' name='page' value='<%=page%>'>
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<input type='hidden' name='search' value='<%=search%>'>
				<input type='hidden' name='searchMemsort' value='<%=searchMemsort%>'>
				<input type='hidden' name='searchStr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<table class="tbl_col">
					<caption>부운영자관리 목록</caption>
					<colgroup>
						<col style="width: 6%" />
						<col />
						<col />
						<col />
						<col style="width: 13%" />
						<col style="width: 12%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="row">No</th>
							<th scope="row">아이디</th>
							<th scope="row">이 름</th>
							<th scope="row">Email</th>
							<th scope="row">등록일자</th>
							<th scope="row">관리</th>
						</tr>
					</thead>
					<tbody>
					<tbody>
						<%PT_Mlist%>
					</tbody>
				</table>
				</form>

				<%=PT_PageLink(PageLink,PageStr,"")%>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->