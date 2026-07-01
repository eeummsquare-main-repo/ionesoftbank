<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "community" : subMenuCode = "boardsort" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim SpItemCnt

boardidx = uf_getRequestProc(Request("boardidx"),"int","","")

Sql = "SELECT idx, boardname, langsort, langindex FROM boardAdmin WHERE isBBSSort=1"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then 
	bbsRec = Rs.GetRows()
	firstBoardidx = bbsRec(0,0)
End IF

IF boardidx="" Then boardidx=firstBoardidx

Sql="SELECT idx, sortname FROM boardsort Where boardidx="&boardidx&" order by listnum ASC, idx ASC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1
IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_bbsList()
	Dim i
	IF IsArray(bbsRec) Then
		For i=0 To Ubound(bbsRec,2)
			IF CStr(boardidx) = CStr(bbsRec(0,i)) Then
				Response.Write "<option value='"&bbsRec(0,i)&"' selected>"&bbsRec(1,i)&" 분류관리</option>"&vbcrlf
			Else
				Response.Write "<option value='"&bbsRec(0,i)&"'>"&bbsRec(1,i)&" 분류관리</option>"&vbcrlf
			End IF
		Next
	End IF
End Function

Function PT_SpecialItemList()
	Dim i
	IF IsArray(Allrec) Then
		SpItemCnt=Ubound(Allrec,2)
		For i=0 To SpItemCnt
			Response.Write "<option value='"&Allrec(0,i)&"'>"&i+1&". "&Allrec(1,i)&"</option>"&vbcrlf
		Next
	End If
	IF SpItemCnt="" Then SpItemCnt=-1
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function boardView(){
	if(document.goods_form.selcode.selectedIndex==-1){
		alert("수정하실 게시물을 선택하세요.");
		return;
	}
	idx=document.goods_form.selcode[document.goods_form.selcode.selectedIndex].value;

	$.ajax({
		type:"post",
		url: "boardsortEdit.asp?Idx="+idx,
		data:"",
		dataType:"html",
		async: true
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}
function boardDel(){
	if(document.goods_form.selcode.selectedIndex==-1){
		alert("삭제하실 게시물을 선택하세요.");
		return;
	}
	var value=confirm("선택하신 게시물을 삭제하시겠습니까?");
	if(value){
		idx=document.goods_form.selcode[document.goods_form.selcode.selectedIndex].value;
		location.href='boardsortDel.asp?idx='+idx;
	}
}
function goAdd(){
	f=document.boardsortform;
	if(f.title.value==""){
		alert("타이틀을 입력하세요");
		f.title.focus();
		return;
	}
	document.boardsortform.submit();
}

//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 끝 ++++++++++++++++++++++++++++++++

function move(temp) {
	cur_index = document.goods_form.selcode.selectedIndex;
	if (cur_index==-1) {
		alert("이동할 게시물을 선택하세요.");
		return;
	}
	if (temp=="up" && cur_index==0) {
		alert("선택하신 게시물은 더이상 위로 이동되지 않습니다.");
		return;
	}
	if (temp=="down" && cur_index==(document.goods_form.selcode.length-1)) {
		alert("선택하신 게시물은 더이상 아래로 이동되지 않습니다.");
	return;
	}
	if (temp=="up") index = cur_index-1;
	else if(temp=="down") index = cur_index+1;

	index_value = document.goods_form.selcode.options[index].value;
	index_text = document.goods_form.selcode.options[index].text;

	document.goods_form.selcode.options[index].value = document.goods_form.selcode.options[cur_index].value;
	document.goods_form.selcode.options[index].text = document.goods_form.selcode.options[cur_index].text;

	document.goods_form.selcode.options[cur_index].value = index_value;
	document.goods_form.selcode.options[cur_index].text = index_text;

	document.goods_form.selcode.selectedIndex = index;
	document.goods_form.ok.value="yes";
}

function move2top(){
	cur_index = document.goods_form.selcode.selectedIndex;
	if (cur_index==-1) {
		alert("이동할 게시물을 선택하세요.");
		return;
	}
	len=document.goods_form.selcode.length-1;
	index_value = document.goods_form.selcode.options[cur_index].value;
	index_text = document.goods_form.selcode.options[cur_index].text;
	for(i=cur_index;i>0;i--){
		document.goods_form.selcode.options[i].value=document.goods_form.selcode.options[i-1].value;
		document.goods_form.selcode.options[i].text=document.goods_form.selcode.options[i-1].text;
	}
	document.goods_form.selcode.options[0].value=index_value;
	document.goods_form.selcode.options[0].text=index_text;
	document.goods_form.selcode.selectedIndex=0;
	document.goods_form.ok.value="yes";
}

function move2bottom(){
	cur_index = document.goods_form.selcode.selectedIndex;
	if (cur_index==-1) {
		alert("이동할 게시물을 선택하세요.");
		return;
	}
	len=document.goods_form.selcode.length-1;
	index_value = document.goods_form.selcode.options[cur_index].value;
	index_text = document.goods_form.selcode.options[cur_index].text;
	for(i=cur_index;i<len;i++){
		document.goods_form.selcode.options[i].value=document.goods_form.selcode.options[i+1].value;
		document.goods_form.selcode.options[i].text=document.goods_form.selcode.options[i+1].text;
	}
	document.goods_form.selcode.options[len].value=index_value;
	document.goods_form.selcode.options[len].text=index_text;
	document.goods_form.selcode.selectedIndex=len;
	document.goods_form.ok.value="yes";
}

function movesend() {
	if (document.goods_form.ok.value!="yes") {
		alert("순서의 변동사항이 없습니다.");
		return;
	}
	if (!confirm("현재의 순서대로 저장하시겠습니까?")) return;
	temp = "";
	for (i=0;i<=(document.goods_form.selcode.length-1);i++) {
		if (i==0) temp = document.goods_form.selcode.options[i].value;
		else temp+=","+document.goods_form.selcode.options[i].value;
	}
	document.goods_form.selcodes.value = temp;
	document.goods_form.index.value=document.goods_form.selcode.length;
	document.goods_form.action="boardsortNumChangeOk.asp"
	document.goods_form.submit();
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

				<div style='clear:both;'>
					<select name='boardidx' style='width:100%; background-Color: #B0CEFF; font-size:14px;' onchange="location.href='?boardidx='+this.value;">
						<%=PT_bbsList()%>
					</select>
				</div>

				<form method="post" name="goods_form">
				<input type='hidden' name='boardidx' value='<%=boardidx%>'>
				<table style="width:100%; padding-top:10px;">
				<colgroup>
				<col width='*'></col>
				<col width='195'></col>
				</colgroup>
				<thead>
				</thead>
					<tr>
						<td>
							<select name=selcode id="selcode" style="width:100%; height:250px; font-size:12px; padding:10px;" size="2" ondblclick='boardView()'>
								<% PT_SpecialItemList() %>
							</select>
						</td>
						<td valign='top' align="right">
							<table>
								<tr>
									<td>
										<a href="JavaScript:move2top()"><img src="images/brcode_top.gif" border=0 style='vertical-align: middle;' alt="최상위로"></a>
										<a href="JavaScript:move('up')"><img src="images/xcode_up.gif" border=0 style='vertical-align: middle;' alt="위로"></a>
										<img src="images/xcode_sort.gif" style='vertical-align: middle;'>
										<a href="JavaScript:move('down')"><img src="images/xcode_down.gif" border=0 style='vertical-align: middle;' alt="아래로"></a>
										<a href="JavaScript:move2bottom()"><img src="images/brcode_bottom.gif" border=0 style='vertical-align: middle;' alt="최하위로"></a>
									</td>
								</tr>
								<tr>
									<td style='padding:3px 0;'>
										<div><input type='button' value='게시물 순서저장하기' class='btn_gray' style='width:100%; color: #ffffff;' onclick='movesend()'></div>
										<div style="margin:3px 0;"><input type='button' value='선택게시물 수정하기' class='btn_gray' style='width:100%; color: #ffa6a6;' onclick='boardView()'></div>
										<div><input type='button' value='선택게시물 삭제하기' class='btn_gray' style='width:100%; color: #a6c5ff;' onclick='boardDel()'></div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>

				<div style='margin-top:10px;'>
					<font color='red'>TIP</font> - 좌측 항목을 더블클릭하거나 , 클릭후 우측 수정하기 버튼을 클릭하시면 수정페이지로 넘어갑니다.<br>
					<!-- 메인 전광판배너 이미지 최적사이즈[450px * 730px], 상위 5개까지 해당코너에 나타납니다.<br>
					메인 객실이미지배너 이미지 최적사이즈[125px * 100px], 상위 10개까지 해당코너에 나타납니다.<br> -->
				</div>
				<input type='hidden' name='num' value="<%=SpItemCnt%>">
				<input type='hidden' name='index'>
				<input type='hidden' name='ok'>
				<input type='hidden' name='selcodes'>
				</form>

				<form name='boardsortform' method='post' action='boardsortOk.asp' onsubmit="goAdd(); return false;">
				<input type='hidden' name='boardidx' value='<%=boardidx%>'>
				<table class="tbl_col box" style='margin-top:40px;'>
				<colgroup>
					<col width="25%" />
					<col width="" />
				</colgroup>
					<tr><th colspan='2'>게시물 추가</th></tr>
					<tr>
						<th>타이틀</th>
						<td class='left'><input type='text' name='title' class='input' maxlength='100'></td>
					</tr>
					<% IF CStr(boardidx)="4" Then %>
					<tr>
						<th>관리자 메일주소</th>
						<td class='left'>
							<input type='text' name='adEmail' class='input' maxlength='100'>
							<div class="imp mt5">게시글 등록시 해당 메일로 알림 메일이 발송됩니다.</div>
						</td>
					</tr>
					<% End IF %>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="#jLink" ONCLICK="goAdd();" class="btn_largeG">추가하기</a>
				</div>
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->