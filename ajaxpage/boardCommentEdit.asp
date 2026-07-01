<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Idx=Request("idx")
Page=Request("Page")
BBSCode=Request("BBSCode")
pwd=Request("pwd")

Sql="Select content,pwd,IsNull(useridx,'') As useridx,boardidx,cadwrite From CommentAdmin Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.WRite "noData"
	Response.End
Else
	content=Rs("content")
	inputPwd=Rs("pwd")
	inputuseridx=Rs("useridx")
	boardidx=Rs("boardidx")
	cadwrite=Rs("cadwrite")
End IF

IF cadwrite=True Then
	Response.WRite "noMember"
	Response.End
ElseIF inputPwd="" Then
	IF CStr(inputuseridx)<>CStr(Session("useridx")) Then
		Response.WRite "noMember"
		Response.End
	End IF
Else
	IF CStr(pwd)<>CStr(inputPwd) Then
		Response.WRite "noPassword"
		Response.End
	End IF
End IF

DBcon.Close
Set DBcon=Nothing
%>


<form id='commentEditfrm_<%=Idx%>' method='post' style='margin:0'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
<input type='hidden' name='pwd' value='<%=pwd%>'>
<div id="bo_vc_w" class="comment_write edit">
	<div class="btm">
		<% IF HK_ComMode="" AND Session("useridx")="" Then %>
		<!-- <input type="text" id="" name='name' maxlength='10' style="width:135px;" placeholder="이름" />
		<input type="password" id="" name="pwd" maxlength="10" value="" style="width:165px;" placeholder="비밀번호" />
		<p class="checkIn">
			<input type="co_pubYN" id="co_pubYN" name="clauseCheckss" />
			<label for="co_pubYN">비밀글</label>
		</p> -->
		<% End IF %>

		<textarea name="content" id="c_textarea" title="댓글을 입력해주세요." maxlength="10000" placeholder="댓글을 입력해주세요."><%=content%></textarea>
		<button type="button" id="btn_submit" class="btn_submit" onclick="boardcommentEdit('commentEditfrm_<%=Idx%>')">댓글수정</button>
	</div>
</div>
</form>
