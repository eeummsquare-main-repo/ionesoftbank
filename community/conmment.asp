<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim Allrec
Dim Record_Cnt,TotalPage,PageSize,Page,Count
Dim Search,SearchStr,StrWhere,BBsSelectField
Dim BBsCode,strLocation,i
Dim BoardSort,BBsSort
Dim Idx,Filename(1),FilDownTag(1),souchk,AlertMsg
Dim title,writer,regdate,content,Ref,ReLevel,Pwd,TopYn,TopTag,ReadNum,PublicYN,inputPwd,UserIdx
Dim serboardsort
Dim PreTag,NextTag
Dim AdWrite,imgnames

bbscode=50
mode=Request("mode")
pageSize = 10
prePage = thisUrl
bbsClass = "board_list"
ListTitleLineClass = "one"
recordTitleCutNum=40

isSetBSort = False
isListSearch = True
isListWriterHidden = False			'리스트 작성자 필드 숨김여부
isListDateHidden = False			'리스트 등록일 필드 숨김여부
isListHitHidden = False			'리스트 조회수 필드 숨김여부
isListSortHidden = False			'리스트 분류 필드 숨김여부
isListThumbCon = True
isListReplyStats = False
isListDown = False
isListLike = True

isViewWriterHidden = False		'VIEW 작성자 필드 숨김여부
isViewDateHidden = False		'VIEW 등록일 필드 숨김여부
isViewHitHidden = False			'VIEW 조회수 필드 숨김여부

isPwdField = True
isWriteEditorUse = False			'작성자모드 에디터 사용여부
isWriteTelField = False			'작성자모드 연락처Field 사용여부
isWriteEmailField = False			'작성자모드 EmailField 사용여부
isWriteAgreeField = True		'작성자모드 개인정보취급방침 사용여부
isWriteStarField = False			'작성자모드 평점 사용여부

IF mode="write" Then
%><!--#include virtual = /board/proc_boardwrite.asp--><%
ElseIF mode="view" Then
%><!--#include virtual = /board/proc_boardview.asp--><%
ElseIF mode="modify" Then
%><!--#include virtual = /board/proc_boardmodify.asp--><%
ElseIF mode="reply" Then
%><!--#include virtual = /board/proc_boardreply.asp--><%
Else
%><!--#include virtual = /board/proc_boardlist_cLevel.asp--><%
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
</head>

<body data-pgCode="0601">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<% IF Session("useridx")<>"" Then %>
        <div class="my_data_box">
            <div class="my_last_login my_lv0<%=GB_Member_CommunityLevel%>">
                <p><em><%=Get_marking(Session("userID"), "4")%></em> 님의 <br>마지막 로그인 시간은 <br><span class="last_date"><%=uf_ConvertDateFormat(GB_Member_lastLogin, 8)%></span></p>
            </div>
            <div class="my_info">
                <dl class="my_mb_lv">
                    <dt>나의 회원등급</dt>
                    <dd><%=getCommunityMemLevelNm(GB_Member_CommunityLevel)%></dd>
                </dl>
                <dl class="to_visit">
                    <dt>총 방문수</dt>
                    <dd><%=FormatNumber(GB_Member_loginCnt, 0)%></dd>
                </dl>
                <dl class="my_write">
                    <dt>내가 작성한 게시글</dt>
                    <dd><%=FormatNumber(GB_Member_BoardRegCnt, 0)%></dd>
                </dl>
                <dl class="my_comment">
                    <dt>내가 작성한 댓글</dt>
                    <dd><%=FormatNumber(GB_Member_CommentRegCnt, 0)%></dd>
                </dl>
            </div>
        </div>
		<% End IF %>

        <div class="multi-tab">
            <button type="button" class="name"></button>
            <ul class="multi-list">
                <li class="active"><a href="conmment.asp">전체글보기</a></li>
                <li><a href="hit.asp">인기글보기</a></li>
            </ul>
        </div>

		<% IF mode="write" Then %>
		<!--#include virtual = /board/bbs_Write.asp-->
		<% ElseIF mode="view" Then %>
		<!--#include virtual = /board/bbs_View.asp-->
		<% ElseIF mode="modify" Then %>
		<!--#include virtual = /board/bbs_Modify.asp-->
		<% ElseIF mode="reply" Then %>
		<!--#include virtual = /board/bbs_Reply.asp-->
		<% Else %>
		<!--#include virtual = /board/bbs_List.asp-->
		<% End IF %>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<script type="text/javascript">
	$(function () {
		$(".multi-tab").multiTab();
	});
</script>
</body>
</html>