<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Dim BBsCode
BBSCode=Request("BBscode")

'============ 게시판 권한/환경변수 셋팅======================
Call HK_BBSSetup(BBsCode)
topMenuCode = HK_BBS_TopMenuCode : subMenuCode = HK_BBS_SubMenuCode
'============================================================
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Idx,Ref,ReLevel,Page
Dim Title, Content, Writer, Sort

Idx=Request("idx")
Ref=Request("Ref")
ReLevel=Request("ReLevel")
Page=Request("Page")

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serDate1, serdate2

serstatus=Request("serstatus")
serisDisplay=Request("serisDisplay")
serismain=Request("serismain")
serboardsort=Request("serboardsort")
serartistidx=Request("serartistidx")
seritem=Replaceensine(ReplaceNoHtml(Request("seritem")))
SearchStr=Replaceensine(ReplaceNoHtml(Request("SearchStr")))
pageSize = Request("PageSize")
serDate1 = Request("serDate1")
serDate2 = Request("serDate2")
serCate1=uf_getRequest(Request("serCate1"),"char","","")
serCate2=uf_getRequest(Request("serCate2"),"char","","")
serCate3=uf_getRequest(Request("serCate3"),"char","","")

PageLink="bbslist.asp"
PageStr="BBscode="&BBscode&"&pagesize="&PageSize&"&serstatus="&serstatus&"&serisDisplay="&serisDisplay&"&serismain="&serismain&"&serartistidx="&serartistidx&"&serboardsort="&serboardsort&"&serDate1="&serDate1&"&serdate2="&serdate2&"&seritem="&seritem&"&searchstr="&SearchStr

IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" OR BBscode="5" OR BBscode="15" OR BBscode="25" Then
	IF serCate1<>"" Then PageStr = PageStr & "&serCate1="&serCate1
	IF serCate2<>"" Then PageStr = PageStr & "&serCate2="&serCate2
	IF serCate3<>"" Then PageStr = PageStr & "&serCate3="&serCate3
End IF
'=============================================

Sql="SELECT title,content,editorYN FROM bbslist WHere idx="&IDX
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	REsponse.Write ExecJavaAlert("원글정보를 찾을수 없습니다.\n다시시도해주세요.",0)
	Response.End
Else
	title=Rs("title")
	Content=Rs("content")
	editorYN=Rs("editorYN")

	IF editorYN = 0 Then Content = ReplaceBr(ReplaceNoHtml(Content))
End IF

'###### 에디터 ID 생성 ##########
IF edNonce="" Then
	edNonce = GetEdNonce()
End IF
'###### 에디터 ID 생성 ##########

DBcon.Close
Set DBcon=Nothing

Writer=Session("acountname")
%>

<!--#include virtual = backoffice/common/head.asp-->
<script src="/_lib/ckeditor5/ckeditor.js"></script>
<script>var ed_nonce = "<%=edNonce%>";</script>
<script src="/_lib/ckeditor5/editorAd.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function sendit(){
	var form=document.boardform;
	if(form.writer.value==false){
		alert("작성자를 입력하세요.");
		form.writer.focus();
		return;
	}
	if(form.title.value==false){
		alert("글제목을 입력하세요.");
		form.title.focus();
		return;
	}
	form.editorYN.value=1
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
					<h2 class="top_left"><%=HK_BBS_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=HK_BBS_TopMenuName%> &gt; <span><%=HK_BBS_SubMenuName%></span>
				</div>

				<form name="boardform" action="bbsReplyOk.asp" method="post" ENCTYPE="multipart/form-data">
				<input type='hidden' name='editorYN' value=''>
				<input type='hidden' name='sort' value='<%=Sort%>'>
				<input type='hidden' name='idx' value='<%=Idx%>'>
				<input type='hidden' name='ref' value='<%=ref%>'>
				<input type='hidden' name='relevel' value='<%=ReLevel%>'>
				<input type='hidden' name='bbsCode' value='<%=bbsCode%>'>
				<input type='hidden' name='page' value='<%=Page%>'>
				<input type='hidden' name='serstatus' value='<%=serstatus%>'>
				<input type='hidden' name='serisDisplay' value='<%=serisDisplay%>'>
				<input type='hidden' name='serismain' value='<%=serismain%>'>
				<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
				<input type='hidden' name='serartistidx' value='<%=serartistidx%>'>
				<input type='hidden' name='seritem' value='<%=seritem%>'>
				<input type='hidden' name='SearchStr' value='<%=SearchStr%>'>
				<input type='hidden' name='pagesize' value='<%=pagesize%>'>
				<input type='hidden' name='serDate1' value='<%=serDate1%>'>
				<input type='hidden' name='serdate2' value='<%=serdate2%>'>
				<input type='hidden' name='edNonce' value='<%=edNonce%>'>
				<input type='hidden' name='sercate1' value='<%=sercate1%>'>
				<input type='hidden' name='sercate2' value='<%=sercate2%>'>
				<input type='hidden' name='sercate3' value='<%=sercate3%>'>
				<table class="tbl_row box">
					<colgroup>
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th style='text-align:right;' colspan='2'>
							게시물 답변
						</th>
					</tr>
					<tr>
						<th>작성자</th>
						<td><input type='text' name='writer' style='width:30%' maxlength='10' class='input' Value='<%=Writer%>'></td>
					</tr>
					<tr>
						<th>원글 제목</th>
						<td>
							<%=ReplaceNoHtml(title)%>
						</td>
					</tr>
					<tr>
						<th>원글 내용</th>
						<td><%=Content%></td>
					</tr>
					<tr class="disNone">
						<th><%=TitleName%></th>
						<td>
							<input type='text' name='title' maxlength='200' class='input' Value='답변입니다.'>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<textarea name='content' id="content" rows='20' class="ckeditor5" style='width:99%'></textarea>
						</td>
					</tr>
				<% IF HK_PdsYN<>"False" Then %>
					<!-- <tr>
						<th>파일첨부</th>
						<td>
							<table cellpadding='0' cellspacing='0' width='100%' id="inRow">
								<tr>
									<td >
										<input type='file' name='files' style='width:350px' class='input'>
										<input type='hidden' name='filedel_idx' value='0'>
										<a onclick="addRow()"><span style='color: #D90000'>필드추가</span></a>
									</td>
								</tr>
							</table>
						</td>
					</tr> -->
				<% End IF %>
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