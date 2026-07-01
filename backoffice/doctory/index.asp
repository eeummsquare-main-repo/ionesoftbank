<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
serDiv = uf_getRequest(Request("serDiv"),"int","7","0")
topMenuCode = "company" : subMenuCode = "doctor"
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
isSearch = True

'검색 필드 관련===============================
serisDisplay = uf_getRequest(Request("serisDisplay"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

IF serisDisplay<>"" Then strWhere = strWhere & " AND isDisplay="&serisDisplay : isSearch = True
IF searchStr <> "" Then strWhere = strWhere & " AND title Like N'%"&SearchStr&"%'" : isSearch = True

PageLink = "index.asp"
PageStr = "serDiv="&serDiv&"&serisDisplay="&serisDisplay&"&searchStr="&Server.UrlEncode(oSearchStr)
'=============================================

Sql = "SELECT idx, title, isDisplay, regdate, arrImgNm, titleEng FROM doctory A WHERE proDiv="&serDiv&" "&strWhere&" ORDER BY listnum ASC, Idx ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_ItemList
	Dim i,Num
	Num=1

	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			idx = ChangeBlank(Allrec(0,i))
			title = ChangeBlank(Allrec(1,i))
			isDisplay = ChangeBlank(Allrec(2,i))
			regdate = ChangeBlank(Allrec(3,i))
			imgNm = Get_ArrFileFIrstName(ChangeBlank(Allrec(4,i)), "|")
			titleEng = ChangeBlank(Allrec(5,i))

			imgTag = ""
			IF imgNm<>"" Then imgTag = "<div class=""listThumb""><a href=""javascript:openWindow(10,10,'../../_lib/imgview.asp?path=doctory&imgname="&imgNm&"','imgView','yes')""><img src=""/upload/doctory/"&getImageThumbFilename(imgNm)&""" onerror=""this.src='/upload/doctory/"&imgNm&"';""></a></div>"

			viewLinkUrl = "write.asp?idx="&idx&"&"&PageStr
			Response.Write "<tr align='center' id=""tr_"&i&""">"&Vbcrlf
			Response.Write "<td><p class=""checkIn noTxt""><input type=""checkbox"" id=""chkidx_"&idx&""" name=""chkidx"" value="""&idx&"""><label for=""chkidx_"&idx&""">선택</label></p><input type='hidden' name='dbidx' value='"&idx&"'></td>"&Vbcrlf
			Response.Write "<td>"&Num&"</td>"&Vbcrlf
			Response.Write "<td>"&imgTag&"</td>"&Vbcrlf
			Response.Write "<td class=""left"">"&Vbcrlf
			Response.Write "	<a href="""&viewLinkUrl&""">"&Vbcrlf
			Response.Write "		<div class=""offTitle"">"&ReplaceNoHtml(title)&" ("&ReplaceNoHtml(titleEng)&")</div>"&Vbcrlf
			Response.Write "	</a>"&Vbcrlf
			Response.Write "</td>"&Vbcrlf
			Response.Write "<td><a href="""&viewLinkUrl&""">"&ChageisDisplay(isDisplay)&"</a></td>"&Vbcrlf
			Response.Write "<td><a href="""&viewLinkUrl&""">"&Left(regdate,10)&"</a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num = Num+1
		Next
	Else
		Response.Write "<tr><td colspan='6' align='center' height='150'>검색된 내역이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include file = ../common/head.asp-->
<script type="text/javascript" src="../js/jquery.tablednd.js"></script>
<style>
.dragTR td{background-color:#d4d4d4}
.listThumb{width:100%; overflow:hidden; height:70px}
.listThumb img{max-height:70px;}
.offTitle{color: #000;}
.offSubTitle{margin-top:3px; color: #929292;}

.revINFO .revCnt{font-weight:700; color: #005ebb; font-size:16px;}
.revINFO a{width:100%; height:20px; line-height:20px;}
</style>
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	<% IF Not(isSearch) Then %>
	$("#listArea").tableDnD({
		onDragClass : 'dragTR',
		onDrop: function(table, row) {
		},onDragStart: function(table, row) {

		}
	});
	<% End IF %>

	$('#ch_cIdall').change(function() {
		if ($("#ch_cIdall").is(":checked")){
			$("input[name='chkidx']").prop('checked', true);
		}else{
			$("input[name='chkidx']").prop('checked', false);
		}
	});

	$(document).on("click",".orderDown",function(){
		var $tr = $(this).parent().parent();
		$tr.next().after($tr);
		setOrderBtnSet();
	});
	$(document).on("click",".orderUp",function(){
		var $tr = $(this).parent().parent();
		$tr.prev().before($tr);
		setOrderBtnSet();
	});
});

function remove(){
	var count = $(':checkbox[name="chkidx"]:checked').length;
	var chkedIdx = [];

	if(count==0){
		alert("삭제하실 게시물을 선택하세요.");
		return;
	}
	var val = confirm("선택하신 모든 게시물을 삭제하시겠습니까?");

	if (val){
		$("input[name='chkidx']:checked").each(function(i) {
			chkedIdx.push($(this).val());
		});
		document.actFrm.procMode.value = "remove";
		document.actFrm.idx.value = chkedIdx;
		document.actFrm.action = "proc.asp";
		document.actFrm.submit();
	}
}

function setOrderBy(){
	var val = confirm("노출순서를 저장합니다.\n저장하시겠습니까?");
	if (val){
		document.itemFrm.procMode.value = "listnum";
		document.itemFrm.action = "proc.asp";
		document.itemFrm.submit();
	}
}

function searchGo(){
	var f=document.searchFrm;
	f.submit();
}
//-->
</SCRIPT>
</head>

<body>

	<div id="wrap">
		<!--#include file = ../common/header.asp-->

		<div id="container">
			<!--#include file = ../common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<!-- <div class="subTab mt20 mb20">
					<a href="?serDiv=0" class="<%=iif_compare(serDiv, 0, "active")%>"><span>Room</span></a>
					<a href="?serDiv=1" class="<%=iif_compare(serDiv, 1, "active")%>"><span>Dining</span></a>
					<a href="?serDiv=2" class="<%=iif_compare(serDiv, 2, "active")%>"><span>Celebration</span></a>
					<a href="?serDiv=3" class="<%=iif_compare(serDiv, 3, "active")%>"><span>Spa</span></a>
					<a href="?serDiv=4" class="<%=iif_compare(serDiv, 4, "active")%>"><span>Event & Gift</span></a>
				</div> -->

				<form name='searchFrm' method='get' action='' onsubmit="searchGo();return false;">
				<input type='hidden' name='serDiv' value='<%=serDiv%>'>
				<div class="searchbox">
					<select name="serisDisplay">
						<option value="">노출상태 전체</option>
						<option value="0" <%=selCheck(serisDisplay,0)%>>비노출</option>
						<option value="1" <%=selCheck(serisDisplay,1)%>>노출</option>
					</select>

					<input type="text" name="searchstr" value="<%=ReplaceTextField(oSearchStr)%>" />
					<a href="javascript:searchGo()" class="btn_default btn_default100">검색</a>
					<a href="?serDiv=<%=serDiv%>" class="btn_default btn_default100">초기화</a>
				</div>
				</form>

				<form name="itemFrm" id="itemFrm" method="post" style='margin:0'>
				<input type='hidden' name="procMode" value="">
				<input type='hidden' name='serisDisplay' value='<%=serisDisplay%>'>
				<input type='hidden' name='serDiv' value='<%=serDiv%>'>
				<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
				<table class="tbl_col" id="listArea">
					<colgroup>
						<col style="width: 40px" />
						<col style="width: 80px" />
						<col style="width: 150px" />
						<col style="*" />
						<col style="width: 100px" />
						<col style="width: 120px" />
					</colgroup>
					<thead>
					<tr bgcolor="#F5F5F5">
						<th scope="row">
							<p class="checkIn noTxt"><input type="checkbox" id="ch_cIdall" name="ch_cIdall" value="1"><label for="ch_cIdall">선택</label></p>
						</th>
						<th scope="row">No</th>
						<th scope="row">이미지</th>
						<th scope="row">타이틀</th>
						<th scope="row">노출여부</th>
						<th scope="row">등록일</th>
					</tr>
					</thead>
					<tbody>
					<%=PT_ItemList%>
					</tbody>
				</table>
				</form>

				<div class="tbl_bottom">
					<% IF Not(isSearch) Then %>
					<div class="top_left">
						<div class="info">게시물을 선택 드래그 하여 순서 변경이 가능합니다.</div>
					</div>
					<% End IF %>
					<div class="top_right">
						<% IF Not(isSearch) Then %>
						<a href="javascript:setOrderBy()" class="btn_gray btn_gray100 btn_green">노출순서저장</a>
						<% End IF %>
						<input type='button' value='선택게시물삭제' class='btn_gray bc_red' style='cursor:pointer; width:100px' onclick='remove()'>
						<a href="write.asp?serDiv=<%=serDiv%>" class="btn_gray btn_gray100">등록하기</a>
					</div>
				</div>

				<form name="actFrm" id="actFrm" class="" method="get">
					<input type='hidden' name="idx" value="">
					<input type='hidden' name='serisDisplay' value='<%=serisDisplay%>'>
					<input type='hidden' name='serDiv' value='<%=serDiv%>'>
					<input type='hidden' name='searchstr' value='<%=ReplaceTextField(oSearchStr)%>'>
					<input type='hidden' name="procMode" value="">
				</form>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->