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

Sql="Select content From CommentAdmin Where idx="&Idx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Response.WRite "noData"
	Response.End
Else
	content=Rs("content")
End IF

%>

<div class="comment-write" style='padding-top:10px;'>
<form id='commentEditfrm_<%=Idx%>' method='post' style='margin:0'>
<input type='hidden' name='idx' value='<%=Idx%>'>
<input type='hidden' name='bbscode' value='<%=bbscode%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
	<fieldset>
		<legend>댓글입력</legend>
		<div class="write">
			<textarea name='content' class="textarea" title="댓글입력"><%=content%></textarea>
			<div class="btn"><input type="button" value="댓글수정" class="btn-pack comment" onclick="boardcommentEditGo('commentEditfrm_<%=Idx%>');"></div>
		</div>
	</fieldset>
</form>
</div>