<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "code" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim serCode
'검색 필드 관련===============================
serCode = uf_getRequest(Request("serCode"),"char","","")

PageLink = "code.asp"
PageStr = "serCode="&serCode
'=============================================

IF serCode<>"" Then
	Sql = "SELECT groupCode, groupName, cType FROM COMCODE WHERE isAd=99 AND groupCode='"&serCode&"'"
	Set Rs = DBcon.Execute(Sql)
	IF Rs.Bof Or Rs.Eof Then
		serCode = ""
	Else
		groupCode=Rs(0)
		groupName=Rs(1)
		codeType=Rs(2)
	End IF
End IF

IF serCode="" Then
	Response.Write ExecJavaAlert("코드정보를 찾을수 없습니다.",0)
	Response.END
End IF

idx = uf_getRequest(Request("idx"),"int","","")

IF idx<>"" Then
	Sql = "SELECT code, name, listnum, isUse FROM COMCODE WHERE isAd=1 AND groupCode='"&serCode&"' AND idx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Rs.Bof OR Rs.Eof Then
		Response.Write ExecJavaAlert("게시물 정보를 찾을수 없습니다.",0)
		Response.END
	Else
		code = Rs("code")
		name = Rs("name")
		listnum = Rs("listnum")
		isUse = Rs("isUse")
	End IF
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
	<script type="text/javascript">
	function sendit(){
		var f = document.boardform

		if(f.groupCode.value==""){
			alert("그룹코드를 선택하세요.");
			f.groupCode.focus();
			return;
		}
		if(f.code.value==""){
			alert("코드를 입력하세요.");
			f.code.focus();
			return;
		}
		if (f.code){
			if(f.name.value==""){
				alert("코드명을 입력하세요.");
				f.name.focus();
				return;
			}
		}
		f.submit();
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

				<form name="boardform" id="boardform" action="codeProc.asp" method="post">
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="serCode" value="<%=ReplaceTextField(serCode)%>">
				<input type="hidden" name="groupName" value="<%=ReplaceTextField(groupName)%>">
				<input type="hidden" name="groupCode" value="<%=ReplaceTextField(groupCode)%>">
				<table class="tbl_row box">
					<colgroup>
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><span>그룹명</span></th>
							<td><%=ReplaceNoHtml(groupName)%></td>
						</tr>
						<tr>
							<th scope="row"><span>코드</span></th>
							<td>
								<div class="btnBox">
									<% IF codeType="int" Then %>
									<input type="text" name="code" maxlength="10" id="" value="<%=ReplaceTextField(code)%>" placeholder="숫자만입력가능" class="onlyNumber">
									<% Else %>
									<input type="text" name="code" maxlength="10" id="" value="<%=ReplaceTextField(code)%>" placeholder="" class="">
									<% End IF %>
								</div>
							</td>
						</tr>
						<% IF codeType<>"dup" Then %>
						<tr>
							<th scope="row"><span>코드명</span></th>
							<td>
								<div class="btnBox">
									<input type="text" name="name" maxlength="25" id="" value="<%=ReplaceTextField(name)%>" placeholder="" >
								</div>
							</td>
						</tr>
						<% End IF %>
						<tr>
							<th scope="row"><span>상태</span></th>
							<td>
								<input type="radio" id="realCheck01" name="isUse" value="1" checked>
								<label for="realCheck01" class="mr20">사용</label>

								<input type="radio" id="realCheck02" name="isUse" value="0" <%=iif_compare(isUse, 0, "checked")%>>
								<label for="realCheck02">미사용</label>
							</td>
						</tr>
					</tbody>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit()" class="btn_largeG"><% IF idx="" Then %>등록<% Else %>수정<% End IF %></a>
					<a href="<%=PageLink%>?page=<%=page%>&<%=pageStr%>" class="btn_largeW">취소</a>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->