<style>
.board_view .comment_wp{width:100%;border-bottom:1px solid #ccc;}
.board_view .comment_wp:after{clear:both;display:block;content:'';}
.board_view .comment_wp li{display:block;float:left;width:830px;;border-bottom:1px solid #ccc;padding:13px 20px;letter-spacing:-1px;}
.board_view .comment_wp li dt{font-size:16px;color:#333333;display:inline-block;}
.board_view .comment_wp li dd{display:inline-block;}
.board_view .comment_wp li dd.date{font-size:15px;color:#888;display:inline-block;margin-right:10px;}
.board_view .comment_wp li dd.comment{width:100%;display:block;padding-top:10px;line-height:25px;color:#666666;font-size:15px;}

.board_view .com_write{float:left;width:100%;padding:15px 0;}
.board_view .com_write table{border-top:1px solid #ccc;}
.board_view .com_write td.tt{background:#ebebeb;font-size:16px;color:#333;height:50px;font-weight:500;}
.board_view .com_write td input{margin-left:5px;width:290px;height:34px; padding:0 10px; background-color:#fff; border:1px solid #ccc; line-height:28px; color:#666; vertical-align:middle; display:inline-block; box-sizing: border-box;}
.board_view .com_write td.write textarea{display:inline-block;width:704px;height:78px;border:1px solid #ccc;padding:10px;}
.board_view .com_write td.write a{margin-left:5px;}

.view_cont .conIMG{text-align:center;}
</style>

<% IF HK_comYn=True Then %>
<SCRIPT LANGUAGE="JavaScript">
<!--
$("document").ready(function(){
	viewBoardCommentArea('<%=idx%>','<%=BBscode%>','')

	$(document).on("click", ".like_btn", function(){
		event.preventDefault()

		if ($(this).hasClass("nLogin")){
			var confirmVal = confirm("회원전용 컨텐츠입니다.\n로그인 페이지로 이동하시겠습니까?");
			if (confirmVal){
				location.href="/member/login.asp?returnURL="+document.location.pathname+"?"+document.location.search;
			}
		}else{
			var index = $(this).attr("dataidx")
			var obj = $(this)

			var params = "bidx="+index;
			$.ajax({type:"POST", url: "/_proc/_LikeProc.asp",data:params,dataType:"html"
			}).done(function(msg){
				var msg = msg.split("|")
				var retCode = msg[0];
				
				if (retCode=="OK"){
					var retisLike = msg[1];
					var likeCnt = msg[2];

					if (retisLike=="0"){		//좋아요 삭제
						obj.removeClass("active")
					}else{					// 좋아요 추가
						obj.addClass("active")
					}
					$(".likeCount").html(likeCnt)
				}else{
					var retMsg = msg[1].replace(/\\n/gi, "\n");
					alert(retMsg)
				}
			});
		}
	});
});
//-->
</SCRIPT>
<% End IF %>

<div class="board_view">
	<table>
		<thead>
			<tr>
				<th>
					<div class="view_title"><%=ReplaceNoHtml(Title)%></div>
					<div class="view_info">
						<div class="view_txt">

<% IF BBscode="51" Then %>
<p class="txt"><strong>회사명</strong>&nbsp;<%=PT_Msg(note1)%></p>
<p class="txt"><strong>모집부문</strong>&nbsp;<%=PT_Msg(note2)%></p>
<p class="txt"><strong>채용인원</strong>&nbsp;<%=PT_Msg(note3)%></p>
<p class="txt"><strong>고용형태</strong>&nbsp;<%=PT_Msg(note4)%></p>
<p class="txt"><strong>근무지역</strong>&nbsp;<%=PT_Msg(note5)%></p>
<% End IF %>

							<% IF SortName <> "" Then %>
							<p class="txt"><strong>구분</strong>&nbsp;<%=Sortname%></p>
							<% End IF %>

							<% IF cateNames <> "" Then %>
							<p class="txt"><strong>분류</strong>&nbsp;<%=cateNames%></p>
							<% End IF %>

							<% IF BBscode=100 Then %>
							<p class="txt"><%=startdate%> ~ <%=enddate%></p>
							<% End IF %>

							<% IF isRecruit Then %>
							<p class="txt"><strong>모집일</strong>&nbsp;<%=termTag%></p>
							<% End IF %>

							<% IF isViewWriterHidden = False Then %>
							<p class="txt"><strong><%=LangPack_wWriter%></strong> <%=ReplaceNoHtml(Writer)%></p>
							<% End IF %>

							<% IF isViewDateHidden = False Then %>
							<p class="txt"><strong><%=LangPack_wDate%></strong>&nbsp;<%=uf_ConvertDateFormat(Regdate, 2)%></p>
							<% End IF %>

							<% IF isListTermStats = True Then %>
							<p class="txt"><%=startdate%> ~ <%=enddate%></p>
							<p class="txt"><%=statusIMG%></p>
							<% End IF %>
						</div>

						<% IF isViewHitHidden = False Then %>
						<div class="view_right">
							<% IF BBscode="50" Then %>
							<p class="txt like_box"><button type="button" class="like_btn f0 <% IF Session("useridx")="" Then %>nLogin<% End IF %> <%=iif_InstrCompare(GB_myLikeBBsRecord, idx, "active")%>" dataidx="<%=idx%>">좋아요 수</button> <span class="likeCount"><%=LikeCnt%></span></p>
							<% End IF %>
							<p class="txt"><i class="fa fa-eye" aria-hidden="true"></i> &nbsp;<%=readnum%></p>
						</div>
						<% End IF %>

						<% IF isRecruit Then %>
						<div class="view_right">
							<div class="state"><%=termStatus%></div>
						</div>
						<% End IF %>
					</div>
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="view_cont">
					<% IF VodUrl<>"" Then %>
					<div class="wideFrame"><iframe  src="<%=getYoutubeUrl(VodUrl)%>" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
					<% End IF %>

					<% altTextView = Replace(ReplaceNoHtml(title), "'", "&#39;") %>
					<% IF ImgNames<>"" AND HK_ImgViewYN<>"False" Then Response.write "<div class=""conIMG""><img src='/upload/board/"&ImgNames&"' alt='"&altTextView&"'></div>" %>
					<%
						IF HK_ImgViewYN = True AND IsArray(FileRec) Then
							For i=0 To UBound(FileRec,2)
								Exitsts=UCase(mid(FileRec(0,i),instrrev(FileRec(0,i),".")+1))

								IF Exitsts="JPG" Or Exitsts="JPEG" Or Exitsts="GIF" Or Exitsts="PNG" Then
									Response.write "<div class=""conIMG""><img src='/upload/board/"&FileRec(0,i)&"' alt='"&altTextView&"'></div>"
								ElseIF Exitsts="MP4" Then
									Response.Write "	<div class=""cVideo"">"&Vbcrlf
									Response.Write "		<video id=""player"" class=""video-js vjs-default-skin"" controls=""controls"" ><source src=""/upload/board/"&FileRec(0,i)&""" type=""video/mp4"" /></video>"&Vbcrlf
									Response.Write "	</div>"&Vbcrlf
								End If
							Next
						End IF
					%>
					<div id="bo_v_con" class="ck-content"><p><%=Content%></p></div>

					<%=PT_FileArea()%>

					<% IF isRecruitConsule Then %>
					<!-- <div class="board_btns center mt100">
						<a href="recruit_application.asp?empidx=<%=idx%>" class="click blue">입사 지원하기</a>
					</div> -->
					<% End IF %>
				</td>
			</tr>
			<%=PT_ReplyList()%>
			<% IF CStr(status)="9" Then %>
			<tr><td class="answer"><p class="tit">답변 <span class="right">(<%=comDate%>)</span></p><p><%=ReplaceBr(adMemo1)%><%=PT_memoFileArea()%></p></td></tr>
			<% ElseIF CStr(status)="1" Then %>
			<tr><td class="answer"><p class="tit">답변 <span class="right">(<%=statusChDate%>)</span></p><p><%=ReplaceBr(adMemo)%><%=PT_memoFileArea()%></p></td></tr>
			<% End IF %>
		</tbody>
	</table>
</div>
<div class="pageNavigation">
	<dl class="prev">
		<dt><%=LangPack_wPrev%></dt>
		<dd>
			<%=PreTag%>
		</dd>
	</dl>
	<dl class="next">
		<dt><%=LangPack_wNext%></dt>
		<dd>
			<%=NextTag%>
		</dd>
	</dl>
</div>

<div class="board_btn end">
	<a href="?page=<%=Page%>&<%=PageStr%>" class="click"><%=LangPack_wBtnList%></a>
</div>

<% IF HK_comYn=True Then %>
<div id="boardCommentDiv" name="boardCommentDiv"></div>
<% End IF%>

<form name='boardActfrm' id='boardActfrm' method='get' action='' style='margin:0;'>
<input type='hidden' name='mode'>
<input type='hidden' name='sort'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
<input type='hidden' name='BBSCode' value='<%=BBSCode%>'>
<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
<input type='hidden' name='search' value='<%=search%>'>
<input type='hidden' name='searchStr' value='<%=searchStr%>'>
<input type='hidden' name='pageSize' value='<%=pageSize%>'>
<input type='hidden' name='prepage' value='<%=prepage%>'>
<input type='hidden' name='serYear' value='<%=serYear%>'>
<input type='hidden' name='serdiv1' value='<%=serdiv1%>'>
<input type='hidden' name='serdiv2' value='<%=serdiv2%>'>
<input type='hidden' name='serCate1' value='<%=serCate1%>'>
<input type='hidden' name='serCate2' value='<%=serCate2%>'>
<input type='hidden' name='seritemidx' value='<%=seritemidx%>'>
</form>