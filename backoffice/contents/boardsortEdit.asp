<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "community" : subMenuCode = "boardsort" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Idx=Request("idx")

Sql="select sortname,boardidx,adEmail from boardsort WHERE idx = "&Idx
Set Rs=Server.CreateObject("ADODB.RecordSet")
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	title=Rs("sortname")
	boardidx=Rs("boardidx")
	adEmail=Rs("adEmail")
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
function infoModify(){
	f=document.boardsorteditform;
	if(f.title.value==""){
		alert("타이틀을 입력하세요");
		f.title.focus();
		return;
	}
	document.boardsorteditform.submit();
}
//-->
</SCRIPT>

<div class="popWrap">
	<div class="popCon">
		<h1>게시물수정<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				<form name='boardsorteditform' method='post' action='boardsortOk.asp'>
				<input type='hidden' name='sort' value='edit'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='boardidx' value='<%=boardidx%>'>

				<table class="tbl_col box" style='width:800px'>
				<colgroup>
					<col width="25%" />
					<col width="" />
				</colgroup>
					<tr>
						<th>타이틀</th>
						<td class='left'><input type='text' name='title' class='input' maxlength='100' value='<%=ReplaceTextFIeld(Title)%>'></td>
					</tr>
					<% IF CStr(boardidx)="4" Then %>
					<tr>
						<th>관리자 메일주소</th>
						<td class='left'>
							<input type='text' name='adEmail' class='input' maxlength='100' value='<%=ReplaceTextFIeld(adEmail)%>'>
							<div class="imp mt5">게시글 등록시 해당 메일로 알림 메일이 발송됩니다.</div>
						</td>
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