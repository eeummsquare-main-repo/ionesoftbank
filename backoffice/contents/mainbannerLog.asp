<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "bannerLog" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim langTitle, langmode
langmode=1
'Call getLangModeTitle(langmode)

Dim SpItemCnt

bansort = uf_getRequestProc(Request("bansort"),"","","0")
serdate1 = uf_getRequestProc(Request("serdate1"),"date","","")
serdate2 = uf_getRequestProc(Request("serdate2"),"date","","")

IF serDate1 <> "" Then strWhere = strWhere & " AND regdate>'"&serDate1&"'"
IF serDate2 <> "" Then strWhere = strWhere & " AND regdate<'"&DateAdd("d",1,serDate2)&"'"

Sql="select idx, filenames, title,sDate,eDate, (Select Count(1) FROM bannerClickLog WHERE banidx = mainbannerAdmin.idx "&strWhere&") AS ClickCnt, regdate from mainbannerAdmin Where langmode="&langmode&" AND bansort="&bansort&" Order by listnum ASC, idx ASC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_BBsList()
	IF IsArray(Allrec) Then
		Num=1

		For i=0 To Ubound(Allrec,2)
			imgTag="이미지없음"
			IF Allrec(1,i)<>"" Then imgTag = "<a href=""javascript:openWindow(100,100,'/_lib/imgview.asp?path=mainbanner&imgname="&Allrec(1,i)&"','imgView','yes')""><img src=""/upload/mainbanner/"&getImageThumbFilename(Allrec(1,i))&""" style='max-width:180px; max-height:50px;'></a>"
			Response.Write "<tr align='center' "&TrBg&">"&Vbcrlf
			Response.Write "<td>"&Num&"</td>"&Vbcrlf
			Response.Write "<td>"&imgTag&"</td>"&Vbcrlf
			Response.Write "<td class='left'>"&Allrec(2,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(3,i)&" ~ "&Allrec(4,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(5,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Left(Allrec(6,i),10)&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num+1
		Next
	Else
		Response.Write "<tr><td colspan='6' align='center' height='100'>검색된 게시물이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript">
<!--
function searchGo(){
	var f=document.searchFrm;
	f.submit();
}
//-->
</script>
</head>

<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left">배너클릭로그</h2>
					<a href="/backoffice/">HOME</a> &gt; 기본정보 &gt; <span>배너클릭로그</span>
				</div>

				<div style='clear:both;'>
					<select name='bansort' style='width:100%; background-Color: #B0CEFF; font-size:14px;' onchange="location.href='?langmode=<%=langmode%>&bansort='+this.value;">
						<option value='0' <%=SelCheck(0,bansort)%>>메인포스터</option>
						<option value='6' <%=SelCheck(6,bansort)%>>인기공모전1 배너</option>
						<option value='7' <%=SelCheck(7,bansort)%>>인기공모전2 배너</option>
						<option value='1' <%=SelCheck(1,bansort)%>>비즈배너1</option>
						<option value='2' <%=SelCheck(2,bansort)%>>비즈배너2</option>
						<option value='3' <%=SelCheck(3,bansort)%>>띠배너</option>
						<option value='4' <%=SelCheck(4,bansort)%>>에디터픽1</option>
						<option value='5' <%=SelCheck(5,bansort)%>>에디터픽2</option>
						<option value='8' <%=SelCheck(8,bansort)%>>이벤트배너</option>

						<option value='1001' <%=SelCheck(1001,bansort)%>>[기존배너로그] 메인배너</option>
						<option value='1002' <%=SelCheck(1002,bansort)%>>[기존배너로그] 탑배너</option>
						<option value='1003' <%=SelCheck(1003,bansort)%>>[기존배너로그] 비즈배너</option>
						<option value='1004' <%=SelCheck(1004,bansort)%>>[기존배너로그] 띠배너 - 상위</option>
						<option value='1005' <%=SelCheck(1005,bansort)%>>[기존배너로그] 메인 에디터 Pick배너</option>
						<option value='1006' <%=SelCheck(1006,bansort)%>>[기존배너로그] 메인 비즈배너 상단배너</option>
						<option value='1007' <%=SelCheck(1007,bansort)%>>[기존배너로그] 메인 인기공모전 포스터형</option>
						<option value='1008' <%=SelCheck(1008,bansort)%>>[기존배너로그] 메인 인기공모전 썸네일형</option>
						<option value='1009' <%=SelCheck(1009,bansort)%>>[기존배너로그] 메인 추천공모전 포스터형</option>
						<option value='1010' <%=SelCheck(1010,bansort)%>>[기존배너로그] 메인 추천공모전 썸네일형</option>
						<option value='1011' <%=SelCheck(1011,bansort)%>>[기존배너로그] 메인 이주의 주목할 공모전 상단 배너</option>
						<option value='1012' <%=SelCheck(1012,bansort)%>>[기존배너로그] 메인 이주의 주목할 공모전 배너</option>
						<option value='1013' <%=SelCheck(1013,bansort)%>>[기존배너로그] 메인 씽유가 추천하는 대외활동 배너</option>
						<option value='1014' <%=SelCheck(1014,bansort)%>>[기존배너로그] 이벤트/커뮤니티 메인 진행중 이벤트</option>
						<option value='1015' <%=SelCheck(1015,bansort)%>>[기존배너로그] 씽유추천! 공모전 페이지 이번주 추천 배너 포스터형</option>
						<option value='1016' <%=SelCheck(1016,bansort)%>>[기존배너로그] 씽유추천! 공모전 페이지 이번주 추천 배너 섬네일형</option>
						<option value='1017' <%=SelCheck(1017,bansort)%>>[기존배너로그] 씽유추천! 대외활동 페이지 이번주 추천 배너 포스터형</option>
						<option value='1018' <%=SelCheck(1018,bansort)%>>[기존배너로그] 씽유추천! 대외활동 페이지 이번주 추천 배너 섬네일형</option>
						<option value='1019' <%=SelCheck(1019,bansort)%>>[기존배너로그] 하단 공지1</option>
						<option value='1020' <%=SelCheck(1020,bansort)%>>[기존배너로그] 하단 공지2</option>
						<option value='1021' <%=SelCheck(1021,bansort)%>>[기존배너로그] 메인 상단 게시판 이미지배너</option>
						<option value='1022' <%=SelCheck(1022,bansort)%>>[기존배너로그] 메인 인기공모전 HOT키워드</option>
						<option value='1023' <%=SelCheck(1023,bansort)%>>[기존배너로그] 메인 추천공모전 HOT키워드</option>
						<option value='1024' <%=SelCheck(1024,bansort)%>>[기존배너로그] 전체메뉴레이어 우측 배너 관리</option>
						<option value='1030' <%=SelCheck(1030,bansort)%>>[기존배너로그] 하단 제휴사배너관리</option>
					</select>
				</div>

				<form name='searchFrm' method='get' action='' onsubmit="searchGo();return false;">
				<input type='hidden' name='bansort' value='<%=bansort%>'>
				<table class="tbl_row mt10">
					<colgroup>
						<col style="width: 12%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">클릭일</th>
							<td>
								<div class="term_srch">
									<div class="date_wrap">
										<input type="text" name="serdate1" value="<%=serdate1%>" class="datepicker1" maxlength='10' onKeyUp="dateFormat(this);" readonly />
										~
										<input type="text" name="serdate2" value="<%=serdate2%>" class="datepicker2" maxlength='10' onKeyUp="dateFormat(this);" readonly />
									</div>

									<a href="javascript:searchGo()" class="btn_gray btn_default100">검색</a>
									<a href="?bansort=<%=bansort%>" class="btn_gray btn_default100">초기화</a>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
				</form>

				<table class="tbl_col mt10">
					<colgroup>
						<col style="width: 4%" />
						<col style="width: 200px" />
						<col style="*" />
						<col style="width: 15%" />
						<col style="width: 6%" />
						<col style="width: 8%" />
					</colgroup>
					<tr bgcolor="#F5F5F5">
						<th scope="row">순번</th>
						<th scope="row">이미지</th>
						<th scope="row">배너명</th>
						<th scope="row">게시기간</th>
						<th scope="row">클릭수</th>
						<th scope="row">등록일</th>
					</tr>
					<%PT_BBsList%>
				</table>
			
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->