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

bbscode=7
mode=Request("mode")
pageSize = 12
prePage = thisUrl
bbsClass = "photo_list"
ListTitleLineClass = "one"
recordTitleCutNum=40

isSetBSort = False
isListSearch = True
isListWriterHidden = True			'리스트 작성자 필드 숨김여부
isListDateHidden = True			'리스트 등록일 필드 숨김여부
isListHitHidden = False			'리스트 조회수 필드 숨김여부
isListSortHidden = True			'리스트 분류 필드 숨김여부
isListThumbCon = True
isListReplyStats = False
isListDown = False

isViewWriterHidden = True		'VIEW 작성자 필드 숨김여부
isViewDateHidden = False		'VIEW 등록일 필드 숨김여부
isViewHitHidden = False			'VIEW 조회수 필드 숨김여부

isPwdField = True
isWriteEditorUse = False			'작성자모드 에디터 사용여부
isWriteTelField = True			'작성자모드 연락처Field 사용여부
isWriteEmailField = True			'작성자모드 EmailField 사용여부
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
%><!--#include virtual = /board/proc_Gallery.asp--><%
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

<body data-pgCode="0403">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<% IF mode="write" Then %>
		<!--#include virtual = /board/bbs_Write.asp-->
		<% ElseIF mode="view" Then %>
		<!--#include virtual = /board/bbs_View.asp-->
		<% ElseIF mode="modify" Then %>
		<!--#include virtual = /board/bbs_Modify.asp-->
		<% ElseIF mode="reply" Then %>
		<!--#include virtual = /board/bbs_Reply.asp-->
		<% Else %>
		<!--#include virtual = /board/bbs_Gallery.asp-->
		<% End IF %>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
<script type="text/javascript">
	$(function () {
	});
</script>
<script type="text/javascript">
	$(function(){
		// 플러그인 이미지(bg 움직임) 오버
		$(".photo_list .list").iOverScript({
			btns : '.gall_cont', // 이벤트 class
			bg : '.over', // 활성화 class
			speed : 700 // 속도
		});
	});
</script>
</body>
</html>