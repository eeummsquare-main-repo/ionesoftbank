<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "page" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
resultSortidx = uf_getRequest(Request("resultSortidx"),"int","","1")

Sql="select Top 1 content, mcontent from PageAdmin WHERE resultSortidx="&resultSortidx & strWhere
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.BOf OR Rs.Eof) Then
	Content=ReplaceNoHtml(Rs("Content"))
	mContent=ReplaceNoHtml(Rs("mContent"))
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function goAdd(){
	f=document.Pageform;
	document.Pageform.submit();
}
//-->
</SCRIPT>
<SCRIPT language=JavaScript src="/_lib/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>
</head>

<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<form name='serFrm' method='get'>
				<div style='clear:both; padding-bottom:5px;'>
					<select name='resultSortidx' class="select" style='width:100%; background-color:#000; color:#fff; font-size:14px; padding:5px; height:auto;' onchange="document.serFrm.submit()">
						<option value='1' <%=SelCheck(1,resultSortidx)%>>구강관리센터 - 상태</option>
						<option value='2' <%=SelCheck(2,resultSortidx)%>>구강관리센터 - 절차</option>
						<option value='3' <%=SelCheck(3,resultSortidx)%>>구강관리센터 - 미용치과(학)</option>
						<option value='4' <%=SelCheck(4,resultSortidx)%>>구강관리센터 - 기초</option>
						<option value='5' <%=SelCheck(5,resultSortidx)%>>구강관리센터 - 연령대별 구강관리</option>
					</select>
				</div>
				</form>

				<form name='Pageform' method='post' action='PageAdminOk.asp'>
				<input type='hidden' name='resultSortidx' value="<%=resultSortidx%>">
				<div>
					<h2 class="mt20">PC</h2>
				</div>
				<div style='clear:both;'>
					<textarea name='content' id="content" rows='10' class='ckeditor' style='width:100%;'><%=Content%></textarea>
				</div>

				<div>
					<h2 class="mt30">MOBILE</h2>
				</div>
				<div style='clear:both;'>
					<textarea name='mcontent' id="mcontent" rows='10' class='ckeditor' style='width:100%;'><%=mContent%></textarea>
				</div>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:goAdd()" class="btn_largeG">저장하기</a>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->

<SCRIPT LANGUAGE="JavaScript">
CKEDITOR.replace( 'content', { height:300 } );
CKEDITOR.replace( 'mcontent', { height:300 } );
</SCRIPT>