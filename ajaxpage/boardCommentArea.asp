<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim Page
Idx=Request("idx")
bbscode=Request("bbscode")
Page=GetPage()
PageSize=10

Call HK_BBSSetup(BBsCode)
IF HK_ComYN=False Then Response.End

Set Rs=Server.CreateObject("ADODB.RecordSet")
'===========================================코멘트 리스트 Get========================================
Sql="Select Top "&PageSize&" name, content, regdate, idx, pwd, co_relevel, co_delYN, co_pubYN, isNull(oriuseridx,-1), cadwrite FROM commentAdmin WHERE boardidx="&Idx&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from commentAdmin where boardidx="&Idx&" Order By co_Ref desc, co_ReLevel ASC, Idx DESC) Order By co_Ref desc, co_ReLevel ASC, Idx DESC"
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
				LevelIMG="<img src='/_lib/memberimg/co_reply.gif' border='0'> "
				LevelView="padding-left:"&(Len(CommentAllrec(5,i))-1)*15&"px;"
			Else
				LevelIMG=""
				LevelView=""
			End IF

			Response.Write "<dl style='"&LevelView&"'>"&Vbcrlf
			Response.Write "	<dt >"&LevelIMG&""&Vbcrlf
			IF CommentAllrec(6,i)="True" Then
				Response.Write "		<span style='color: #B71700;'>삭제된 게시물 입니다.</span>"&Vbcrlf
			Else
				IF CommentAllrec(7,i)=1 Then
					IF CStr(CommentAllrec(8,i))=CStr(Session("useridx")) Then
						Response.Write "		"&ReplaceBr(CommentAllrec(1,i))
					Else
						Response.Write "		<img src=""/img/icon_secret.gif"" alt=""비밀글""> <span style='color: #C1C1C1;'>비공개 게시물입니다.</span>"&Vbcrlf
					End IF
				Else
					Response.Write "	"&ReplaceBr(CommentAllrec(1,i))
				End IF
			End IF
			Response.Write "	</dt>"&Vbcrlf
			Response.Write "	<dd>"&Vbcrlf
			Response.Write "		<p><span class=""guest"">"&CommentAllrec(0,i)&"</span></p>"&Vbcrlf
			Response.Write "		<p><time>"&CommentAllrec(2,i)&"</time></p>"&Vbcrlf
			IF CommentAllrec(6,i)<>"True" AND CommentAllrec(9,i)<>"True" Then
				Response.Write "		<div class=""comment_option"">"&Vbcrlf
				IF CommentAllrec(4,i)="" Then
					Response.Write "			<a onclick=""boardcommentEditView('CommentReply_Area"&i&"','yes',"&CommentAllrec(3,i)&",'"&bbscode&"','"&storeidx&"','"&page&"')""><span>수정</span></a>"&Vbcrlf
				Else
					Response.Write "			<a onclick=""boardcommentEditView('CommentReply_Area"&i&"','',"&CommentAllrec(3,i)&",'"&bbscode&"','"&storeidx&"','"&page&"')""><span>수정</span></a>"&Vbcrlf
				End IF

				IF CommentAllrec(4,i)="" Then
					Response.Write "			<a onclick=""viewboardCommentPwdInput('CommentReply_Area"&i&"','yes',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')""><span>삭제</span></a>"&Vbcrlf
				Else
					Response.Write "			<a onclick=""viewboardCommentPwdInput('CommentReply_Area"&i&"','',"&CommentAllrec(3,i)&",'"&bbscode&"','"&page&"')""><span>삭제</span></a>"&Vbcrlf
				End IF

				IF CommentAllrec(7,i)=0 OR CStr(CommentAllrec(8,i))=CStr(Session("useridx")) Then
					'Response.Write "			<a onclick=""viewboardCommentReply('CommentReply_Area"&i&"',"&CommentAllrec(3,i)&",'"&bbscode&"','"&storeidx&"','"&page&"')"">답변</a>"&Vbcrlf
				End IF
				Response.Write "		</div>"&Vbcrlf
			End IF
			Response.Write "	</dd>"&Vbcrlf
			Response.Write "</dl>"&Vbcrlf

			Response.Write "<div id='CommentReply_Area"&i&"' name='CommentReply_Area"&i&"'></div>"&Vbcrlf
		Next
	End IF
End Function
%>

<div class="comment_Area">
	<div id="boardactDiv" name="boardactDiv" style="position:absolute; visibility:hidden;"></div>
	<p class="comment_title"><i class="fa fa-comments-o" aria-hidden="true"></i> 댓글 (<%=Count%>)</p>

	<form name='commentfrm' id='commentfrm' method='post' style='margin:0px;'>
	<input type='hidden' name='idx' value='<%=Idx%>'>
	<input type='hidden' name='bbscode' value='<%=bbscode%>'>
	<div id="bo_vc_w" class="comment_write">
		<div class="btm">
			<% IF HK_ComMode="" AND Session("useridx")="" Then %>
			<input type="text" id="" name='name' maxlength='10' placeholder="이름" />
			<input type="password" id="" name="pwd" maxlength="10" value="" placeholder="비밀번호" />
			<% End IF %>
			<!-- <p class="checkIn">
				<input type="checkbox" id="co_pubYN" name="co_pubYN" value="1" />
				<label for="co_pubYN">비밀글</label>
			</p> -->
			<textarea name="content" id="c_textarea" title="댓글을 입력해주세요." maxlength="10000" placeholder="댓글을 입력해주세요."></textarea>
			<button type="button" id="btn_submit" class="btn_submit" onclick="<%=WriteModeChk(HK_ComMode,"boardcommentGo()","")%>">댓글등록</button>
		</div>
	</div>
	</form>

	<div class="comment_list">
		<%=PT_CommentList()%>
	</div>

	<% IF Count=0 Then %>
	<% Else %>
		<%=PT_SpPageLink("viewBoardCommentArea","'"&idx&"','"&bbscode&"'","yes")%>
	<% End IF %>
</div>