<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Idx=Request("idx")
Page=Request("Page")
BBSCode=Request("BBSCode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

DBcon.Close
Set DBcon=Nothing
%>

<div class="comment-write" style='padding-top:10px;'>
<form id='commentReplyfrm_<%=Idx%>' method='post' style='margin:0'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
	<fieldset>
		<legend>댓글입력</legend>
		<div class="write">
			<textarea name='content' class="textarea" title="댓글입력"></textarea>
			<div class="btn"><input type="button" value="답변입력" class="btn-pack comment" onclick="boardcommentReply('commentReplyfrm_<%=Idx%>');"></div>
		</div>
	</fieldset>
</form>
</div>
