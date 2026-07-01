<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
GB_seoTitle = "채용공고 — ERP 컨설턴트·개발자 모집 | 아이원소프트뱅크"
GB_seoDescription = "채용공고·인재 모집 — 더존 ERP 컨설턴트, 개발자, 영업·고객성공 직군 채용. 25년 노하우와 함께 성장할 인재 모집. 복지·교육 풍부."
GB_seoKeywords = "ERP채용,ERP컨설턴트,개발자채용,더존파트너채용,아이원소프트뱅크채용"

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

bbscode=51
mode=Request("mode")
pageSize = 10
prePage = thisUrl
bbsClass = "board_list"
ListTitleLineClass = "one"
recordTitleCutNum=40

isSetBSort = False
isListSearch = True
isListWriterHidden = True			'리스트 작성자 필드 숨김여부
isListDateHidden = True			'리스트 등록일 필드 숨김여부
isListHitHidden = True			'리스트 조회수 필드 숨김여부
isListSortHidden = False			'리스트 분류 필드 숨김여부
isListThumbCon = True
isListReplyStats = False
isListDown = False
isListLike = True

isRecruit = True

isViewWriterHidden = True		'VIEW 작성자 필드 숨김여부
isViewDateHidden = True		'VIEW 등록일 필드 숨김여부
isViewHitHidden = True			'VIEW 조회수 필드 숨김여부

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
%><!--#include virtual = /board/proc_recruit.asp--><%
	Sql="SELECT Top 3 idx, title, viewdate, writer, readnum, imgnames, startdate, enddate, note1, note2, note3, note4, note5, always, deadline FROM bbsList WHERE isDisplay=1 AND relevel='A' AND boardidx="&BBsCode&" AND DelYN=0 ORDER BY readnum DESC, sortDate DESC, Idx DESC"
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then tRec = Rs.GetRows()

	Function PT_tRecordList()
		IF isArray(tRec) Then
			Response.Write "<div class=""late_sw"">"&Vbcrlf
			Response.Write "	<div class=""swiper-wrapper"">"&Vbcrlf

			Dim idx, title, viewdate, writer, relevel, readnum, imgnames, startdate, enddate, note1, note2, note3, note4, note5, always, deadline
			For i=0 To Ubound(tRec,2)
				idx = changeBlank(tRec(0,i))
				title = changeBlank(tRec(1,i))
				viewdate = changeBlank(tRec(2,i))
				writer = changeBlank(tRec(3,i))
				readnum = changeBlank(tRec(4,i))
				imgnames = changeBlank(tRec(5,i))
				startdate = changeBlank(tRec(6,i))
				enddate = changeBlank(tRec(7,i))
				note1 = changeBlank(tRec(8,i))
				note2 = changeBlank(tRec(9,i))
				note3 = changeBlank(tRec(10,i))
				note4 = changeBlank(tRec(11,i))
				note5 = changeBlank(tRec(12,i))
				always = changeBlank(tRec(13,i))
				deadline = changeBlank(tRec(14,i))

				IF always="1" Then
					termTag="상시채용"
				ElseIF startdate="" AND enddate="" Then
					termTag="채용시까지"
				ElseIF enddate="" Then
					termTag=""&startDate& " ~ 채용시까지"
				Else
					termTag=""&startdate&" ~ "&enddate&""
				End IF

				imgTag = ""
				IF imgnames<>"" Then imgTag = "<img src=""/upload/board/"&imgnames&""" alt="""">"

				LangPack_Progress = "모집중"
		
				IF deadline="1" Then
					termStatus = "<span class=""ico end"">"&LangPack_Deadline&"</span>"
				ElseIF always="1" Then
					termStatus = "<span class=""ico ing"">"&LangPack_Progress&"</span>"
				Else
					IF CStr(Date()) > CStr(enddate) AND enddate<>"" Then							'마감
						termStatus = "<span class=""ico end"">"&LangPack_Deadline&"</span>"
					ElseIF CStr(Date()) < CStr(startdate) AND startdate<>"" Then						'예정
						termStatus = "<span class=""ico end"">"&LangPack_Expected&"</span>"
					Else																								'진행
						termStatus = "<span class=""ico ing"">"&LangPack_Progress&"</span>"
					End IF
				End IF

				Response.Write "		<div class=""swiper-slide"">"&Vbcrlf
				Response.Write "			<a href=""recruit_view.asp"">"&Vbcrlf
				Response.Write "				<P class=""lt_date"">"&viewdate&"</P>"&Vbcrlf
				Response.Write "				<P class=""lt_logo"">"&imgTag&"</P>"&Vbcrlf
				Response.Write "				<p class=""lt_tit"">"&ReplaceNoHtml(title)&"</p>"&Vbcrlf
				Response.Write "				<p class=""lt_intro"">"&Vbcrlf
				Response.Write "					<span>"&ReplaceNoHtml(Note2)&"</span>"&Vbcrlf
				Response.Write "					<span>"&ReplaceNoHtml(Note3)&"</span>"&Vbcrlf
				Response.Write "					<span>"&ReplaceNoHtml(Note4)&"</span>"&Vbcrlf
				Response.Write "					<span>"&ReplaceNoHtml(Note5)&"</span>"&Vbcrlf
				Response.Write "				</p>"&Vbcrlf
				Response.Write "				<P class=""lt_period"">"&termTag&"</P>"&Vbcrlf
				Response.Write "				<P class=""lt_state"">"&termStatus&"</P>"&Vbcrlf
				Response.Write "			</a>"&Vbcrlf
				Response.Write "		</div>"&Vbcrlf
			Next
			Response.Write "	</div>"&Vbcrlf
			Response.Write "</div>"&Vbcrlf
		End IF
	End Function
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

<body data-pgCode="0602">

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
		<%=PT_tRecordList()%>
		<!--#include virtual = /board/bbs_recruit.asp-->
		<% End IF %>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>
</body>
</html>