<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim Page
Dim idx, bbscode, pagesize

Idx=Request("idx")
bbscode=Request("bbscode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%

Page=GetPage()
PageSize=10

Set Rs=Server.CreateObject("ADODB.RecordSet")
'===========================================코멘트 리스트 Get========================================
Sql="Select Top "&PageSize&" name,content,regdate,idx,pwd,co_relevel,co_delYN,WriteID FROM VIEW_bComment_writer WHERE boardidx="&Idx&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from commentAdmin where boardidx="&Idx&" order by co_Ref desc, co_ReLevel ASC, Idx DESC) Order By co_Ref desc, co_ReLevel ASC, Idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(*) from commentAdmin where boardidx="&Idx)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	CommentAllrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count=0
	TotalPage=1
End If
Rs.Close
'====================================================================================================

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_CommentList()
	Dim i
	IF IsArray(CommentAllrec) Then
		For i=0 To Ubound(CommentAllrec,2)

			IF Len(CommentAllrec(5,i))<>1 Then
				LevelView=" style=""padding-left:"&(Len(CommentAllrec(5,i))-1)*20&"px; background:url('/_lib/memberimg/co_reply.gif') "&(Len(CommentAllrec(5,i))-1)*20-15&"px 5px no-repeat;"""
				LevelViewClass="replyicon"
			Else
				LevelView=""
				LevelViewClass=""
			End IF

			Response.Write "<li>"&Vbcrlf
			Response.Write "	<div class=""info"">"&Vbcrlf
			Response.Write "		<span class=""name"">"&CommentAllrec(0,i)&"</span>"&CommentAllrec(7,i)&""&Vbcrlf
			Response.Write "		<span class=""date"">"&CommentAllrec(2,i)&"</span>"&Vbcrlf
			Response.Write "	</div>"&Vbcrlf
			IF CommentAllrec(6,i)="True" Then
				Response.Write "	<div class=""txt delete "&LevelViewClass&""" "&LevelView&" style=''>삭제된 게시물 입니다.</div>"&Vbcrlf
			Else
				Response.Write "	<div class=""txt "&LevelViewClass&""" "&LevelView&">"&ReplaceBr(CommentAllrec(1,i))&"</div>"&Vbcrlf
				Response.Write "	<div class=""controll"">"&Vbcrlf
				Response.Write "		<a href=""javascript:boardcommentEditView('CommentReply_Area"&i&"',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')"">수정</a>|"&Vbcrlf
				Response.Write "		<a href=""javascript:viewboardCommentPwdInput('yes','visible',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')"">삭제</a>|"&Vbcrlf
				Response.Write "		<a href=""javascript:viewboardCommentReply('CommentReply_Area"&i&"',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')"">답변</a>"&Vbcrlf
				Response.Write "	</div>"&Vbcrlf
			End If
			Response.Write "	<div id='CommentReply_Area"&i&"' name='CommentReply_Area"&i&"'></div>"&Vbcrlf
			Response.Write "</li>"&Vbcrlf
		Next
	End IF
End Function
%>

<div id="boardcommentPwdINPUTDiv" name="boardcommentPwdINPUTDiv" style="position:absolute; visibility:hidden;"></div>
<div id="boardactDiv" name="boardactDiv" style="position:absolute; "></div>

<div class="comment-area">
	<div class="comment-write">
		<form name='commentfrm' id='commentfrm' method='post'>
		<input type='hidden' name='idx' value='<%=Idx%>'>
		<input type='hidden' name='bbscode' value='<%=bbscode%>'>
			<fieldset>
				<legend>댓글입력</legend>
				<div class="write">
					<textarea name='content' class="textarea" title="댓글입력"></textarea>
					<div class="btn"><input type="button" value="댓글입력" class="btn-pack comment" onclick="boardcommentGo()"></div>
				</div>
			</fieldset>
		</form>
	</div>
	<div class="comment-list">
		<ul>
			<%=PT_CommentList()%>
		</ul>
	</div>

	<%=PT_PageLink("viewBoardCommentArea","'"&idx&"','"&bbscode&"'","yes")%>
</div>