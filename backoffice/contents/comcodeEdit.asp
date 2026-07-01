<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "comcode" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Idx = uf_getRequest(Request("Idx"),"int","","")

Sql="SELECT title,bansort,note1 from comcodeAdmin WHERE idx = "&Idx
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=ReplaceTextField(Rs("title"))
	Bansort=ReplaceTextField(Rs("Bansort"))
	note1=ReplaceTextField(Rs("note1"))
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function infoModify(){
	f=document.comcodeeditform;
	if(f.title.value==""){
		alert("타이틀을 입력하세요");
		f.title.focus();
		return;
	}
	document.comcodeeditform.submit();
}
//-->
</SCRIPT>

<div class="popWrap">
	<div class="popCon">
		<h1>게시물수정<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<form name='comcodeeditform' method='post' action='comcodeOk.asp' onsubmit="infoModify(); return false;">
				<input type='hidden' name='sort' value='edit'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='Bansort' value='<%=Bansort%>'>
				<table class="tbl_col" style='width:800px'>
				<colgroup>
					<col width="20%" />
					<col width="" />
				</colgroup>
					<tr>
						<th>타이틀</th>
						<td class='left'><input type='text' name='title' style='width:97%;' class='input' maxlength='50' value='<%=Title%>'></td>
					</tr>
					<% IF bansort="bank" Then %>
					<tr>
						<th>은행코드</th>
						<td class='left'><input type='text' name='note1' style='width:97%;' class='input' maxlength='50' value='<%=note1%>' placeholder="실명계좌 조회시 사용될 은행코드"></td>
					</tr>
					<% End IF %>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:infoModify()" class="btn_largeG">확인</a>
					<a href="javascript:fnLayerPopupClose()" class="btn_largeW">취소</a>
				</div>
			</div>
		</div>

	</div>
</div>