<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
GB_seoTitle = "자료실 — 더존 ERP 도입 가이드·소개서 PDF | 아이원소프트뱅크"
GB_seoDescription = "더존 ERP 자료실·뉴스레터 — 도입 가이드, 제품 소개서, 사례집을 PDF로 무료 다운로드. 의사결정에 필요한 자료를 한곳에서 확인하세요."
GB_seoKeywords = "더존ERP자료실,ERP도입가이드,Amaranth10소개서,ERP사례집,뉴스레터"

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
pageSize = 10
prePage = thisUrl
bbsClass = "board_list"
ListTitleLineClass = "one"
recordTitleCutNum=40

isSetBSort = False
isListSearch = True
isListWriterHidden = True			'리스트 작성자 필드 숨김여부
isListDateHidden = False			'리스트 등록일 필드 숨김여부
isListHitHidden = False			'리스트 조회수 필드 숨김여부
isListSortHidden = True			'리스트 분류 필드 숨김여부
isListThumbCon = True
isListReplyStats = False
isListDown = False

isViewWriterHidden = True		'VIEW 작성자 필드 숨김여부
isViewDateHidden = False		'VIEW 등록일 필드 숨김여부
isViewHitHidden = False			'VIEW 조회수 필드 숨김여부

isPwdField = True
isListDown = True
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
%><!--#include virtual = /board/proc_boardlist.asp--><%
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

<body data-pgCode="0401">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div id="container">
		<div class="multi-tab">
			<button type="button" class="name"></button>
			<ul class="multi-list">
				<li><a href='inquiry.asp'>1:1 사용문의</a></li>
				<li ><a href='notice.asp' >동영상강의</a></li>
				<li class="active"><a href='pds.asp'>자료실</a></li>
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