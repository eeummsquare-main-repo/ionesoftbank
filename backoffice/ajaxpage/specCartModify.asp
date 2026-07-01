<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx=uf_getRequestProc(Request("idx"), "int", "", "")
page=uf_getRequestProc(Request("page"), "int", "", "1")

IF idx="" Then
	Response.Write "noIDX"
	Response.End
End IF

Sql="SELECT idx,title,speclang,specname,specval FROM specCart Where idx="&idx
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Response.Write "noLIST"
	Response.End
Else
	idx=Rs("idx")
	title=ReplaceTextField(Rs("title"))
	speclang=Split(Rs("speclang"),"|")
	specname=Split(Rs("specname"),"|")
	specval=Split(Rs("specval"),"|")
End IF

DBcon.CLose
SET DBCon=Nothing

Function PT_List()
	For i=0 To UBound(specname)
		Response.Write "<tr>"&Vbcrlf
		'Response.Write "	<td>"&Vbcrlf
		'Response.Write "		<select name=""speccartlang"">"&Vbcrlf
		'Response.Write "			<option value=""1"" "&selCheck(specLang(i), 1)&">국문</option>"&Vbcrlf
		'Response.Write "			<option value=""2"" "&selCheck(specLang(i), 2)&">영문</option>"&Vbcrlf
		'Response.Write "		</select>"&Vbcrlf
		'Response.Write "	</td>"&Vbcrlf
		Response.Write "	<td><input type='text' name='speccartname' maxlength='50' class='input' value='"&ReplaceTextField(specname(i))&"'></td>"&Vbcrlf
		Response.Write "	<td><input type='text' name='speccartval' maxlength='1000' class='input' value='"&ReplaceTextField(specval(i))&"' placeholder=""줄바꿈시 '^' 를 입력해주세요""></td>"&Vbcrlf
		Response.Write "</tr>"&Vbcrlf
	Next

	For i=i To 9
		Response.Write "<tr>"&Vbcrlf
		'Response.Write "	<td>"&Vbcrlf
		'Response.Write "		<select name=""speccartlang"">"&Vbcrlf
		'Response.Write "			<option value=""1"">국문</option>"&Vbcrlf
		'Response.Write "			<option value=""2"">영문</option>"&Vbcrlf
		'Response.Write "		</select>"&Vbcrlf
		'Response.Write "	</td>"&Vbcrlf
		Response.Write "	<td><input type='text' name='speccartname' maxlength='50' class='input'></td>"&Vbcrlf
		Response.Write "	<td><input type='text' name='speccartval' maxlength='1000' class='input' placeholder=""줄바꿈시 '^' 를 입력해주세요""></td>"&Vbcrlf
		Response.Write "</tr>"&Vbcrlf
	Next
End FUnction
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<div class="popWrap">
	<div class="popCon">
		<h1>스펙바구니 관리<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<div style='line-height:1.3; padding: 0 10px 5px 0px;color: #ffffff; width:100%'>

					<form name='specCartFrm' id='specCartFrm' action='' method='post'>
					<input type='hidden' name='idx' value='<%=idx%>'>
					<input type='hidden' name='page' value='<%=page%>'>
					<table cellpadding='0' cellspacing='0' class="specCartTB">
					<!-- <col width="8%"></col> -->
					<col width=""></col>
					<col width="70%"></col>
						<tr><td height='5'></td></tr>
						<tr>
							<td colspan='2' class="titleTD" >
								<span style="width:18%">스펙바구니 제목</span>
								<span style="width:81%"><input type='text' name='title' maxlength='50' value='<%=Title%>'></span>
							</td>
						</tr>
						<tr><td height='15'></td></tr>
						<tr>
							<!-- <td style='font-weight:bold; color: #970000'>언어</td> -->
							<td style='font-weight:bold; color: #970000'>스펙명</td>
							<td style='font-weight:bold; color: #970000'>스펙내용</td>
						</tr>
						<%=PT_List()%>
					</table>
					</form>
				</div>

				<div class="btn_center pt30">
					<a href="javascript:SpecCartModifySendit()" class="btn_largeG">확인</a>
					<a href="javascript:viewSpecCartArea('list','<%=page%>')" class="btn_largeW">취소</a>
				</div>
			</div>
		</div>

	</div>
</div>
</body>
</html>