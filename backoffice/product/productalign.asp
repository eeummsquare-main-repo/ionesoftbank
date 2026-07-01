<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "align" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim CateIdx,Special,SpItemCnt,RowCnt
Dim Allrec,ItemRec,SpecialRec,CateCodes
Dim CateRec

CateIdx = Request("cateidx")
special = Request("special")
IF Special="" Then Special=0
IF CateIdx="" Then CateIdx=0

'===================================카테고리 출력 Code============================================
Sql="Select name,lowcode,middlecode,topcode FROM Category ORDER BY align1Num, align2Num, align3Num"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	CateRec=Rs.GetRows
End IF
Rs.Close

'=============================제품리스트 Display를 위한 select 시작======================================'
IF CateIdx<>0 Then
	Sql="select lowcode from category where lowcode='"&CateIdx&"' Or Middlecode='"&CateIdx&"' Or Topcode='"&CateIdx&"'"
	SET Rs=Server.CreateObject("ADODB.Recordset")
	Rs.Open Sql,DBcon,1

	Do Until Rs.Eof
		IF CateCodes<>"" Then CateCodes=CateCodes&","
		CateCodes=CateCodes&"'"&Rs(0)&"'"
		Rs.MoveNext
	Loop
	Rs.Close

	IF Special<>"" And Special <> "0" Then	strWhere = " AND idx NOT IN(Select itemidx From productAlignTB Where mainsort='"&Special&"')"
	Sql="SELECT idx,itemname FROM View_PRODUCT WHERE catecode IN ("&CateCodes&") AND isMain=1 AND display=1 "&strWhere&" Order by listnum ASC, idx DESC"
	Rs.Open Sql,DBcon,1

	IF Not(Rs.Bof Or Rs.Eof) Then ItemRec=Rs.GetRows
End IF
'=============================제품리스트 Display를 위한 select 시작======================================'

'======================메인 분류별 아이템 리스트 Display를 위한 select 시작=============================='
IF Special<>"" And Special <> "0" Then	
	Sql="SELECT idx,itemname FROM View_PRODUCT INNER JOIN productAlignTB ON View_PRODUCT.idx = productAlignTB.itemidx WHERE mainsort='"&Special&"' AND isMain=1 AND display=1 ORDER BY mainidx ASC, idx DESC"
	SET Rs=Server.CreateObject("ADODB.Recordset")
	Rs.Open Sql,DBcon,1
	
	IF Not(Rs.Bof Or Rs.Eof) Then SpecialRec=Rs.GetRows
End IF
'======================메인 분류별 아이템 리스트 Display를 위한 select 시작=============================='

'###### 카테고리별 베스트 상품 진열 코너 #######################
Sql = "SELECT lccode, cateFullName FROM VIEW_CATEGORY WHERE TCCODE=LCCODE ORDER BY align1Num ASC, align2Num ASC, align3Num ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then cBestRec = Rs.GetRows
'###### 카테고리별 베스트 상품 진열 코너 #######################

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

'==========================================출력 함수============================================
Function PT_cateBestOption()
	IF isArray(cBestRec) Then
		For i=0 To Ubound(cBestRec,2)
			Response.Write "<option value="""&cBestRec(0,i)&""" "&iif_compare(special, cBestRec(0,i), "selected")&">메인 카테고리별 BEST 상품 - "&cBestRec(1,i)&"</option>"&Vbcrlf
		Next
	End IF
End Function

Function PT_CateScript()
	Dim i,depth1,Depth2,Depth3,PreCaCode
	Response.Write "<SCRIPT LANGUAGE='JavaScript'>"&Vbcrlf
	Response.Write "depth1 = new Array();"&Vbcrlf
	Response.Write "depth1_value = new Array();"&Vbcrlf
	Response.Write "depth2 = new Array();"&Vbcrlf
	Response.Write "depth2_value =  new Array();"&Vbcrlf
	Response.Write "depth3 = new Array();"&Vbcrlf
	Response.Write "depth3_value =  new Array();"&Vbcrlf
	IF IsArray(CateRec) Then
		Depth1=-1 : Depth2=0 : Depth3=0 : PreCaCode=""
		For i=0 To Ubound(CateRec,2)
			IF CateRec(2,i)=CateRec(3,i) Then
				Depth1=Depth1+1
				Response.Write "depth1["&Depth1&"]='"&ReplaceJScript(CateRec(0,i))&"';"&Vbcrlf
				Response.Write "depth1_value["&Depth1&"]="&CateRec(1,i)&";"&Vbcrlf
				Response.Write "depth2["&Depth1&"] = new Array();"&Vbcrlf
				Response.Write "depth2_value["&Depth1&"] = new Array();"&Vbcrlf
				Response.Write "depth3["&Depth1&"] = new Array();"&Vbcrlf
				Response.Write "depth3_value["&Depth1&"] = new Array();"&Vbcrlf
				Depth2=0
			Elseif CateRec(1,i)=CateRec(2,i) Then
				Response.Write "depth2["&Depth1&"]["&Depth2&"]='"&ReplaceJScript(CateRec(0,i))&"';"&Vbcrlf
				Response.Write "depth2_value["&Depth1&"]["&Depth2&"]="&CateRec(1,i)&";"&Vbcrlf
				Response.Write "depth3["&Depth1&"]["&Depth2&"] = new Array();"&Vbcrlf
				Response.Write "depth3_value["&Depth1&"]["&Depth2&"] = new Array();"&Vbcrlf
				Depth2=Depth2+1
				Depth3=0
			Else
				Response.Write "depth3["&Depth1&"]["&Depth2-1&"]["&Depth3&"]='"&ReplaceJScript(CateRec(0,i))&"';"&Vbcrlf
				Response.Write "depth3_value["&Depth1&"]["&Depth2-1&"]["&Depth3&"]="&CateRec(1,i)&";"&Vbcrlf

				Depth3=Depth3+1
			End IF
		Next
	End IF
	Response.Write "</SCRIPT>"&Vbcrlf
End Function

Function PT_ItemList()
	Dim i,OptStyle,ImgYn
	IF IsArray(ItemRec) Then
		RowCnt=Ubound(ItemRec,2)
		For i=0 To RowCnt
			Response.Write "<option "&OptStyle&" value='"&ItemRec(0,i)&"'>"&i+1&". "& ReplaceNoHtml(ItemRec(1,i)) & ImgYn&"</option>"&vbcrlf
		Next
	End IF
End Function

Function PT_SpecialItemList()
	Dim i
	IF IsArray(SpecialRec) Then
		SpItemCnt=Ubound(SpecialRec,2)
		For i=0 To SpItemCnt
			Response.Write "<option value='"&SpecialRec(0,i)&"'>"&i+1&". "&ReplaceNoHtml(SpecialRec(1,i))&"</option>"&vbcrlf
		Next
	End If
	IF SpItemCnt="" Then SpItemCnt=-1
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 시작 ++++++++++++++++++++++++++++++++
function select2Del(){
	var cnt=goods_form.select2.length
	for(var i=0;i<cnt;i++){ goods_form.select2.remove(0); }
}
function select3Del(){
	var cnt=goods_form.select3.length
	for(var i=0;i<cnt;i++){ goods_form.select3.remove(0); }
}
function change1(index){
	if(index != -1){
		if(goods_form.select2){
			select2Del();
			for(i=0;i<depth2[index].length;i++){
				goods_form.select2.options.add(new Option(depth2[index][i],depth2_value[index][i]));
			}
		}
		document.goods_form.cateidx.value=depth1_value[goods_form.select1.selectedIndex];
	}
}
function change2(index){
	if(index != -1){
		if(goods_form.select3){
			select3Del();
			for(i=0;i<depth3[goods_form.select1.selectedIndex][index].length;i++){
				goods_form.select3.options.add(new Option(depth3[goods_form.select1.selectedIndex][index][i],depth3_value[goods_form.select1.selectedIndex][index][i]));
			}
		}
		document.goods_form.cateidx.value=depth2_value[goods_form.select1.selectedIndex][goods_form.select2.selectedIndex];
	}
}
function change3(index){
	if(index != -1){
		document.goods_form.cateidx.value=depth3_value[goods_form.select1.selectedIndex][goods_form.select2.selectedIndex][goods_form.select3.selectedIndex];
	}
}

//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 끝 ++++++++++++++++++++++++++++++++
//+++++++++++++++++++++++++++카테고리 선택에 따른 SELECTBOX 변경함수++++++++++++++++++++++++++++++++
function goItemSubmit(index){
	location.href='productAlign.asp?cateidx='+goods_form.select1.options[index].value+'&special=<%=Special%>';
}
function mcodesend(count) {
	var f=document.goods_form;
	var num=0;
	var maxnum;

	if(f.special.selectedIndex<=0){
		alert("이동할 코너를 선택하세요.");
		return;
	}
	if (f.brcode.selectedIndex==-1) {
		alert("선택코너로 이동할 게시물을 선택하세요.");
		return;
	}
   if (f.special.selectedIndex==1){	maxnum=10000; }
   else if (f.special.selectedIndex==2){ maxnum=10000; }
   else if (f.special.selectedIndex==3){ maxnum=10000; }
   else if (f.special.selectedIndex==4){ maxnum=10000; }
   else if (f.special.selectedIndex==5){ maxnum=10000; }
   else if (f.special.selectedIndex==6){ maxnum=10000; }
 
   for(i=0;i<count;i++){
       if(f.brcode.options[i].selected==true){
           f.brcodes.value+=","+f.brcode.options[i].value;
           num++;
       }
   }
   if(parseInt(f.num.value)+num>=maxnum){
      alert("해당코너 에는 최대 "+maxnum+"개의 게시물만 등록 하실수 있습니다.\n다른 게시물을 삭제후 등록하세요.");
      return;
   }
   if (confirm("해당 게시물을 선택코너로 이동하시겠습니까?")){
      f.action="product_main_ok.asp";
	  f.submit();
   }
}

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
		alert("진열게시물의 변동사항이 없습니다.");
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
	document.goods_form.action="product_num_ok.asp"
	document.goods_form.submit();
}

function del() {
	if (document.goods_form.selcode.selectedIndex==-1) {
		alert("해당코너에서 삭제할 게시물을 선택하세요.");return;
	}
	if(!confirm("선택하신 게시물을 해당코너에서 삭제하시겠습니까?")) return;
	document.goods_form.action="product_main_del.asp"
	document.goods_form.submit();
}
function itemSearch(){
	if(goods_form.cateidx.value==false){
		alert("먼저 카테고리를 선택해주세요.");
		return;
	}goods_form.submit();
}

function OpenModal(OpenFile,Width,Height){
	var f=document.goods_form;
	var idx=f.brcode.value
	if (f.brcode.selectedIndex==-1) {
		alert("이미지 업로드할 게시물을 선택하세요.");
		return;
	}
	var returnValue=window.showModalDialog(OpenFile+'?idx='+idx,'','scroll:no; help:no; center:yes; status:no; dialogWidth:'+Width+'px; dialogHeight:'+Height+'px' );

	if (returnValue==true){
		location.href="productAlign.asp?cateidx=<%=CateIdx%>&special=<%=Special%>"
	}
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
					<h2 class="top_left"><%=GB_SubMenuName%></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<form action="productAlign.asp" method="get" name="goods_form">
				<table border="0" cellpadding="0" cellspacing="0" width='100%'>
					<tr>
						<td align='center' width='100%'>
							<select name="select1" size="8" style="background-color:#F6F6F6; width:100%; height:120px; font-size:14px; padding:5px;" onClick='change1(this.selectedIndex);'>
							</select>
						</td>
					</tr>
					<tr><td colspan='3' style='padding-top:5px;'><input type='button' value='제품 검색 (상단 카테고리 선택후 검색을 눌러주세요)' style='width:100%; font-size:14px; line-height:20px;' class='btn_gray' onclick='itemSearch();'></td></tr>
				</table>

				<div style='margin-top:20px'>
					<table width="100%" class="tbl_row">
						<colgroup>
							<col width="" />
							<col width="160px" />
						</colgroup>
						<tr height=30><td align=center colspan='2' bgcolor="#000" style="color:#fff; text-align:center;">제품 목록</td></tr>
						<tr>
							<td align=center>
								<select name=brcode style="width:100%; height:160px; padding:5px;" size="30" multiple>
								<%PT_ItemList%>
								</select>
							 </td>
							 <td valign="bottom" style='border-left:0'>
								<div style='margin-bottom:10px; text-align:left; line-height:1.4;'>
									<span style='color: red;'>알아두세요!</span><br>
									하단 진열코너까지<br>선택하시면 선택하신<br>코너에 진열된 게시물은<br>왼쪽 목록에<br>나타나지 않습니다.
								</div>
								<a href="JavaScript:mcodesend(<%=RowCnt+1%>)"><img src="images/mainregist_productbutton.gif"></a>
							 </td>
						</tr>
					 </table>
				</div>
					
				<div style='margin-top:20px'>
					<div>
						<select name="special" style="width:100%; font-size:14px; background-color: #C8E7FF;" onchange='goods_form.submit()'>
							<option value=0>진열 코너를 선택하세요</option>
							<%=PT_cateBestOption()%>
						</select>
					</div>
					<div style="margin:10px 0">
						<select name=selcode size=15 style="width:100%; height:200px" multiple>
						<%PT_SpecialItemList()%>
						</select>
					</div>
					<div style='text-align:center;'>
						<a href="JavaScript:move2top()"><img src="images/brcode_top.gif" border=0 align=absmiddle alt="최상위로"></a>
						<a href="JavaScript:move('up')"><img src="images/xcode_up.gif" border=0 align=absmiddle alt="위로"></a>
						<img src="images/xcode_sort.gif" align='absmiddle'>
						<a href="JavaScript:move('down')"><img src="images/xcode_down.gif" border=0 align='absmiddle' alt="아래로"></a>
						<a href="JavaScript:move2bottom()"><img src="images/brcode_bottom.gif" border=0 align='absmiddle' alt="최하위로"></a>
						<a href="JavaScript:del()"><img src="images/xcode_delete.gif" border=0 align='absmiddle'></a>
						<a href="JavaScript:movesend()"><img src="images/mainregist_savebutton.gif" align='absmiddle' border=0></a>
					</div>
				</div>

				<input type='hidden' name='cateidx' value='<%=CateIdx%>'>
				<input type='hidden' name='num' value="<%=SpItemCnt%>">
				<input type='hidden' name='brcodes'>
				<input type='hidden' name='index'>
				<input type='hidden' name='ok'>
				<input type='hidden' name='selcodes'>
				</form>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->

<%PT_CateScript%>
<SCRIPT LANGUAGE="JavaScript">
<!--
for(i=0;i<depth1.length;i++){
	document.all.select1.options.add(new Option(depth1[i],depth1_value[i]));
}
document.goods_form.special.options[<%=special%>].selected=true;
//-->
</SCRIPT>