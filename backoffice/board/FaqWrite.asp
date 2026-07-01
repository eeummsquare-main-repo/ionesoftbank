<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec,Idx,Content,TitleTag,Title,Sort,Page
Dim TitleImg,BoardSort
Dim serDate1, serDate2, seritem, serStr, pageSize
Dim langmode,langTitle

langmode = 1
serboardsort = Request("serboardsort")
sersubsort = Request("sersubsort")
serDate1 = Request("serDate1")
serDate2 = Request("serDate2")
pageSize = Request("PageSize")
seritem = Request("seritem")
serStr = Request("serStr")

Call getLangModeTitle(langmode)

Sort=Request("sort")
Page=Request("page")
Idx=Request("idx")

IF Idx<>"" Then
	Sql="SELECT title, content, BoardSort, subsort, isdisplay, edNonce FROM Faq WHERE idx="&idx
		
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		Allrec=Rs.GetRows
		Content=ReplaceNoHtml(Allrec(1,0))
		Title=ReplaceTextField(Allrec(0,0))
		BoardSort=Allrec(2,0)
		subsort=Allrec(3,0)
		isdisplay=Allrec(4,0)
		edNonce=changeBlank(Allrec(5,0))
	End IF
	Set Rs=Nothing

	TitleTag="수정"
	Sort="edit"
Else
	TitleTag="등록"
End IF

'###### 에디터 ID 생성 ##########
IF edNonce="" Then
	edNonce = GetEdNonce()
End IF
'###### 에디터 ID 생성 ##########

DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
	var form=document.boardform;
	/*if(form.boardsort.value==""){
		alert("분류를 선택하세요.");
		form.boardsort.focus();
		return;
	}*/

	if(form.title.value==""){
		alert("제목을 입력하세요.");
		form.title.focus();
		return;
	}
	form.submit();
}
//-->
</SCRIPT>
</head>

<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%><!-- (<%=langTitle%>)--></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<form name="boardform" action="faqwriteok.asp" method="post">
				<input type='hidden' name='sort' value='<%=Sort%>'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='page' value='<%=Page%>'>
				<input type="hidden" name="langmode" value="<%=langmode%>">
				<input type="hidden" name="serboardsort" value="<%=serboardsort%>">
				<input type="hidden" name="sersubsort" value="<%=sersubsort%>">
				<input type="hidden" name="serdate1" value="<%=serDate1%>">
				<input type="hidden" name="serdate2" value="<%=serDate2%>">
				<input type="hidden" name="pagesize" value="<%=pageSize%>">
				<input type="hidden" name="seritem" value="<%=seritem%>">
				<input type="hidden" name="serstr" value="<%=serStr%>">
				<input type='hidden' name='edNonce' value='<%=edNonce%>'>
				<table class="tbl_row">
					<colgroup>
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>공개여부</th>
						<td>
							<input type="radio" name='isdisplay' id="isdisplay1" value="1" checked><label for="isdisplay1" style="margin-right:10px;">공개</label>
							<input type="radio" name='isdisplay' id="isdisplay2" value="0" <%=ChangeChecked(isdisplay,0)%>><label for="isdisplay2">비공개</label>
						</td>
					</tr>
					<!-- <tr>
						<th>분류</th>
						<td>
							<select name="boardsort">
								<option value="" selected>분류선택</option>
								<option value="0" <%=selCheck(boardsort, 0)%>>치아교정</option>
								<option value="1" <%=selCheck(boardsort, 1)%>>임플란트</option>
								<option value="2" <%=selCheck(boardsort, 2)%>>심미보정</option>
							</select>
						</td>
					</tr> -->
					<tr>
						<th>제목</th>
						<td>
							<input type='text' name='title' class="txtall" Value='<%=Title%>' maxlength='100'>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<textarea name='content' id='content' style='width:100%; word-break:break-all;' class='ckeditor5'><%=Content%></textarea>
						</td>
					</tr>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:sendit()" class="btn_largeG">확인</a>
					<a href="javascript:history.back()" class="btn_largeW">취소</a>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->