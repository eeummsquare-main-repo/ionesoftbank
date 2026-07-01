<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim langTitle, langmode
langmode = uf_getRequest(Request("langmode"),"int","4","0")
'Call getLangModeTitle(langmode)

PageSize=50

'=====form 전송을 위한 변수 셋팅============================
Page = uf_getRequest(Request("Page"),"int","","1")
serSelCate = uf_getRequest(Request("serSelCate"),"int","1","")
sercatecode = uf_getRequest(Request("sercatecode"),"char","50","")
searchOB = uf_getRequest(Request("searchOB"),"int","3","")
seritemstat = uf_getRequest(Request("seritemstat"),"int","1","")
serSellYn = uf_getRequest(Request("serSellYn"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
sercatecode1 = uf_getRequest(Request("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(Request("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(Request("sercatecode3"),"char","","")

PageStr="langmode="&langmode&"&serSelCate="&serSelCate&"&sercatecode1="&sercatecode1&"&sercatecode2="&sercatecode2&"&sercatecode3="&sercatecode3&"&sercatecode="&sercatecode&"&searchOB="&searchOB&"&serSellYn="&serSellYn&"&seritemstat="&seritemstat&"&searchStr="&searchStr
'=====form 전송을 위한 변수 셋팅============================

IF serCatecode1<>"" Then tmpCatecode=serCatecode1
IF serCatecode2<>"" Then tmpCatecode=serCatecode2
IF serCatecode3<>"" Then tmpCatecode=serCatecode3
IF tmpCatecode<>"" Then
	Set Rs=Server.CreateObject("ADODB.RecordSet")
	Sql="select lowcode from category where lowcode='"&tmpCatecode&"' Or Middlecode='"&tmpCatecode&"' Or Topcode='"&tmpCatecode&"'"
	Rs.Open Sql,DBcon,1

	Do Until Rs.Eof
		IF CateCodes<>"" Then CateCodes=CateCodes&","
		CateCodes=CateCodes&"'"&Rs(0)&"'"
		Rs.MoveNext
	Loop
	Rs.Close
End IF
IF CateCodes<>"" Then strWhere=strWhere&" AND Catecode IN ("&CateCodes&") "
IF serSelCate="" Then strWhere=strWhere&" AND isMain=1 "
IF searchStr<>"" Then strWhere=strWhere&" AND itemname Like '%"&searchStr&"%' "
IF seritemstat<>"" Then strWhere=strWhere&" AND display="&seritemstat&" "
IF serSellYn<>"" Then strWhere=strWhere&" AND sellYn="&serSellYn&" "

IF searchOB = "0" Then
	dbsearchOB = "itemname ASC"
Else
	dbsearchOB = "listnum ASC"
End IF

Set Rs=Server.CreateObject("ADODB.RecordSet")
'======================1차 카테고리===================================
Sql="Select lowcode,name FROM Category Where Lowcode=Topcode Order by align1Num ASC"
Set Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then gbCateRec=Rs.GetRows()
Rs.Close

Function PT_CateGory1(Rec)
	IF IsArray(Rec) Then
		For i=0 To UBound(Rec,2)
			Response.Write "<option value='"&Rec(0,i)&"' "&selCheck(Rec(0,i),sercatecode1)&">"&Rec(1,i)&"</option>"
		Next
	End IF
End Function
'=====================================================================

'####################################제품 출력 Code 시작################################################
Sql="SELECT top "&PageSize&" idx, display, itemname, note1, regdate, catecode, price, listimg, dbo.fn_CateFullName(catecode) AS catenames FROM View_Product WHERE langmode="&langmode&" "&strWhere&" AND idx Not IN (select top "&(Page-1)*PageSize&" idx from View_Product WHERE langmode="&langmode&" "&strWhere&" Order By "&dbsearchOB&",idx DESC) Order By "&dbsearchOB&",idx DESC"
Set Rs = DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(*) from View_Product WHERE langmode="&langmode&" "&strWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1 
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else 
	TotalPage=1
	Count=0
End IF
Rs.Close
'####################################제품 출력 Code 끝###################################################

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_ItemList
	Dim i,Num
	Num=GetTextNumDesc(Page,Pagesize,Count)

	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			loop_idx=Allrec(0,i)
			loop_display=Allrec(1,i)
			loop_itemname=Allrec(2,i)
			loop_note1=Allrec(3,i)
			loop_regdate=Allrec(4,i)
			loop_catecode1=Allrec(5,i)
			loop_price=Allrec(6,i)
			loop_listimg=Allrec(7,i)
			loop_Catenames=Allrec(8,i)

			IF loop_listimg="" Then
				ImgTag="NO IMAGE"
			Else
				ImgTag="<img src='/upload/product/"&loop_listimg&"' valign='middle' style=""max-width:60px; max-height:60px;"">"
			End IF

			Response.Write "<tr align='center'>"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&loop_idx&"'></td>"&Vbcrlf
			Response.Write "<td>"&ImgTag&"</td>"&Vbcrlf
			Response.Write "<td>"&loop_Catenames&"</td>"&Vbcrlf
			Response.Write "<td align='left' style='line-height:1.3;' class=""left"">"&ReplaceNoHtml(loop_itemname)&"</td>"&Vbcrlf
			Response.Write "<td>"&loop_regdate&"</td>"&Vbcrlf
			Response.Write "<td>"&isDisplayYN(loop_display)&"</td>"&Vbcrlf
			Response.Write "<td>"&Vbcrlf
			Response.Write "<div><input type='button' value=""수정"" class=""btn_gray"" onclick=""goodsEdit("&loop_idx&");"" style='width:100%;'></div>"&Vbcrlf
			'Response.Write "<div style='margin:3px 0'><input type='button' value=""관련상품"" class=""btn_green"" onclick=""location.href='productRelation.asp?itemidx="&loop_idx&"'"" style='width:100%;'></div>"&Vbcrlf
			Response.Write "<div class=""mt3""><input type='button' value=""삭제"" class=""btn_gray bc_red"" onclick=""goodsDel("&loop_idx&");"" style='width:100%;'></div>"&Vbcrlf
			Response.Write "</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='7' align='center' height='150'>검색된 제품이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
$(document).ready(function(){
	$('#ch_cIdall').change(function() {
		if ($("#ch_cIdall").is(":checked")){
			$("input[name='chkidx']").prop('checked', true);
		}else{
			$("input[name='chkidx']").prop('checked', false);
		}
	});
});

function goodsEdit(idx) {
	location.href="productEdit.asp?subitemidx="+idx+"&page=<%= Page %>&<%=PageStr%>";
}
function goodsDel(idx) {
    var choice = confirm( '해당 제품을 삭제 하시겠습니까?');
	if(choice){
		location.href="productRemove.asp?chkidx="+idx+"&page=<%= Page %>&<%=PageStr%>";
	}
}
function search(){
	searchform.submit();
}
function delSendit(){
	var chkidx = document.getElementsByName('chkidx');
	var cnt=0;

	for(i=0;i<chkidx.length;i++){
		if(chkidx[i].checked){
			cnt++;
		}
	}
	if(cnt==0){
		alert("삭제하실 제품을 선택해주세요.");
		return;
	}
	var val = confirm("복구가 불가능합니다.\n정말 삭제하시겠습니까?");

	if (val){
		itemFrm.action='productRemove.asp';
		itemFrm.submit();
	}
}
function changSelBox1(val1,val2){
	$.ajax({
		type:"post",
		url: "/_lib/selBoxChange1.asp",
		data:{"catecode":val1,"lccode":val2},
		dataType:"script",
		async: true
	})
}
function changSelBox2(val1,val2){
	$.ajax({
		type:"post",
		url: "/_lib/selBoxChange2.asp",
		data:{"catecode":val1,"lccode":val2},
		dataType:"script",
		async: true
	})
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

				<form name="searchform" method="get" action = "product.asp" style='margin:0px;'>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<table class="tbl_row">
					<colgroup>
						<col style="width: 10%" />
						<col style="width: 23%" />
						<col style="width: 10%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">카테고리별</th>
							<td colspan="3">
								<select name='sercatecode1' id='selBox1' onchange="changSelBox1(this.value,'')">
									<option value=''>:::카테고리전체:::</option>
									<%=PT_CateGory1(gbCateRec)%>
								</select>
								<select name='sercatecode2' id='selBox2' onchange="changSelBox2(this.value,'')" class="">
									<option value=''>:::2차 카테고리전체:::</option>
								</select>
								<select name='sercatecode3' id='selBox3' onchange="changSelBox3(this.value,'')" class="disNone">
									<option value=''>:::3차 카테고리전체:::</option>
								</select>
								<!-- <label><input type="checkbox" name='serSelCate' value="1" <%=iif_compare(serSelCate,1,"checked")%>>선택카테고리 포함</label> -->
							</td>
						</tr>
						<tr>
							<th scope="col">공개여부</th>
							<td>
								<input name='seritemstat' id="seritemstat1" type='radio' value='' checked><label for="seritemstat1" style='margin-right:15px;'>전체검색</label>
								<input name='seritemstat' id="seritemstat2" type='radio' value='1' <%=ChangeChecked(1,seritemstat)%>><label for="seritemstat2" style='margin-right:15px;'>공개</label>
								<input name='seritemstat' id="seritemstat3" type='radio' value='0' <%=ChangeChecked(0,seritemstat)%>><label for="seritemstat3" style='margin-right:15px;'>비공개</label>
							</td>

							<th scope="col">정렬</th>
							<td>
								<select name="searchOB" style="width:120px;">
									<option value=''>등록순</option>
									<option value='0' <%=selCheck(searchOB,"0")%>>제품명순</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="searchbox">
					제품명 : 
					<input type='text' name='searchstr' size='15' class='input' value='<%=searchstr%>'>
					<a href="javascript:search()" class="btn_default btn_default100">검색</a>
					<a href="?langmode=<%=langmode%>" class="btn_default btn_default100">초기화</a>
				</div>
				</form>

				<form name="itemFrm" id="itemFrm" method="post" style='margin:0'>
				<input type='hidden' name='page' value='<%=page%>'>
				<input type='hidden' name='serSelCate' value='<%=serSelCate%>'>
				<input type='hidden' name='seritemstat' value='<%=seritemstat%>'>
				<input type='hidden' name='serSellYn' value='<%=serSellYn%>'>
				<input type='hidden' name='sercatecode' value='<%=sercatecode%>'>
				<input type='hidden' name='searchOB' value='<%=searchOB%>'>
				<input type='hidden' name='SearchStr' value='<%=SearchStr%>'>
				<input type='hidden' name='sercatecode1' value='<%=sercatecode1%>'>
				<input type='hidden' name='sercatecode2' value='<%=sercatecode2%>'>
				<input type='hidden' name='sercatecode3' value='<%=sercatecode3%>'>
				<input type='hidden' name='langmode' value='<%=langmode%>'>
				<table class="tbl_col">
					<colgroup>
						<col style="width: 4%" />
						<col style="width: 7%" />
						<col style="width: 26%" />
						<col style="*" />
						<col style="width: 8%" />
						<col style="width: 6%" />
						<col style="width: 8%" />
					</colgroup>
					<tr bgcolor="#F5F5F5">
						<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
						<th scope="row">상품사진</th>
						<th scope="row">카테고리</th>
						<th scope="row">제품명</th>
						<th scope="row">등록일</th>
						<th scope="row">진열여부</th>
						<th scope="row">관리</th>
					</tr>
					<%=PT_ItemList%>
				</table>
				</form>

				<div class="tbl_bottom">
					<div class="top_left">
						<input type='button' value='선택게시물삭제' class='btn_gray bc_red' style='cursor:pointer; width:100px' onclick='delSendit()'>
					</div>

					<div class="top_right">
						<a href="productadd.asp?<%=PageStr%>" class="btn_gray btn_gray100">제품등록</a>
					</div>
				</div>

				<%=PT_PageLink("",PageStr,"")%>
			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->

<% IF serCatecode1<>"" Then %>
<SCRIPT LANGUAGE="JavaScript">
changSelBox1("<%=serCatecode1%>","<%=serCatecode2%>")
</SCRIPT>
<% End IF %>
<% IF serCatecode2<>"" Then %>
<SCRIPT LANGUAGE="JavaScript">
changSelBox2("<%=serCatecode2%>","<%=serCatecode3%>")
</SCRIPT>
<% End IF %>