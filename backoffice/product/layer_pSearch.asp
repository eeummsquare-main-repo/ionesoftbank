<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "" : subMenuCode = "" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
itemidx=uf_getRequestProc(Request("itemidx"), "int", "", "")
PageSize=10

Response.Write itemidx

'=====form 전송을 위한 변수 셋팅============================
Page = uf_getRequest(Request("Page"),"int","","1")
seritemstat = uf_getRequest(Request("seritemstat"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
sercatecode1 = uf_getRequest(Request("sercatecode1"),"char","","")
sercatecode2 = uf_getRequest(Request("sercatecode2"),"char","","")
sercatecode3 = uf_getRequest(Request("sercatecode3"),"char","","")

PageStr="langmode="&langmode&"&sercatecode1="&sercatecode1&"&sercatecode2="&sercatecode2&"&sercatecode3="&sercatecode3&"&seritemstat="&seritemstat&"&searchStr="&searchStr
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
IF searchStr<>"" Then strWhere=strWhere&" AND itemname Like '%"&searchStr&"%' "
IF seritemstat<>"" Then strWhere=strWhere&" AND display="&seritemstat&" "

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
Sql="SELECT top "&PageSize&" idx, display, itemname, note1, regdate, catecode, price, listimg, dbo.fn_CateFullName(catecode) AS catenames FROM View_Product WHERE isMain=1 "&strWhere&" AND idx Not IN (select top "&(Page-1)*PageSize&" idx from View_Product WHERE isMain=1 "&strWhere&" Order By listnum ASC,idx DESC) Order By listnum ASC,idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(*) from View_Product WHERE isMain=1 "&strWhere)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1 
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else 
	TotalPage=1
	Count=0
End IF
Rs.Close
'####################################제품 출력 Code 끝###################################################

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

			Response.Write "<tr align='center'>"&Vbcrlf
			Response.Write "<td><input type='checkbox' name='chkidx' value='"&loop_idx&"'></td>"&Vbcrlf
			Response.Write "<td>"&loop_Catenames&"</td>"&Vbcrlf
			Response.Write "<td align='left' style='line-height:1.3;' class=""left"">"&ReplaceNoHtml(loop_itemname)&"</td>"&Vbcrlf
			Response.Write "<td>"&isDisplayYN(loop_display)&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='4' align='center' height='150'>검색된 제품이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<script type="text/javascript">
<!--
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
	/*$.ajax({
		type:"post",
		url: "/_lib/selBoxChange2.asp",
		data:{"catecode":val1,"lccode":val2},
		dataType:"script",
		async: true
	})*/
}
function searchPro(){
	$("#actFrm input[name=sercatecode1]").val( $("#searchLayFrm select[name=sercatecode1]").val() );
	$("#actFrm input[name=sercatecode2]").val( $("#searchLayFrm select[name=sercatecode2]").val() );
	$("#actFrm input[name=searchStr]").val( $("#searchLayFrm input[name=searchstr]").val() );
	$("#actFrm input[name=seritemstat]").val( $(":input:radio[name=seritemstat]:checked").val() );

	var params = $("#searchLayFrm").serialize();
	$.ajax({
		type:"post",
		url: "layer_pSearch.asp",
		data:params,
		dataType:"html",
		async: true
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}
function goAdd(){
	var count = $('#itemFrm :checkbox[name="chkidx"]:checked').length;
	var chkedIdx = [];

	if(count==0){
		alert("등록하실 상품을 선택하세요.");
		return;
	}
	var val = confirm("선택하신 모든 상품을 관련상품으로 등록하시겠습니까?");

	if (val){
		$("#itemFrm input[name='chkidx']:checked").each(function(i) {
			chkedIdx.push($(this).val());
		});
		document.actFrm.selidx.value = chkedIdx;

		var params = $("#actFrm").serialize();
		$.ajax({
			type:"post",
			url: "productRelationOk.asp",
			data:params,
			dataType:"html",
			async: true
		}).done(function(data){
			if (data=="complete")	{
				alert("선택하신 상품이 관련상품으로 등록되었습니다.");
				location.reload();
			}
		})
	}
}
//-->
</script>

<div class="popWrap">
	<div class="popCon">
		<h1>상품검색<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">
				
				<form name="searchLayFrm" id="searchLayFrm" method="get" style='margin:0px;'>
				<input type='hidden' name='itemidx' value='<%=itemidx%>'>
				<table class="tbl_row" style='width:800px;'>
					<colgroup>
						<col style="width: 130px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">진열상태</th>
							<td>
								<input name='seritemstat' id="seritemstat1" type='radio' value='' checked><label for="seritemstat1" style='margin-right:15px;'>전체검색</label>
								<input name='seritemstat' id="seritemstat2" type='radio' value='1' <%=ChangeChecked(1,seritemstat)%>><label for="seritemstat2" style='margin-right:15px;'>노출</label>
								<input name='seritemstat' id="seritemstat3" type='radio' value='0' <%=ChangeChecked(0,seritemstat)%>><label for="seritemstat3" style='margin-right:15px;'>비노출</label>
							</td>
						</tr>
						<tr>
							<th scope="col">카테고리별</th>
							<td>
								<select name='sercatecode1' id='selBox1' onchange="changSelBox1(this.value,'')">
									<option value=''>:::1차 카테고리전체:::</option>
									<%=PT_CateGory1(gbCateRec)%>
								</select>
								<select name='sercatecode2' id='selBox2' onchange="changSelBox2(this.value,'')">
									<option value=''>:::2차 카테고리전체:::</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="searchbox">
					제품명 : 
					<input type='text' name='searchstr' size='15' class='input' value='<%=searchstr%>'>
					<a href="javascript:searchPro()" class="btn_default btn_default100">검색</a>
				</div>
				</form>

				<form name="itemFrm" id="itemFrm" method="post" style='margin:0'>
				<table class="tbl_col" style='width:800px;'>
					<colgroup>
						<col style="width: 50px" />
						<col style="width: 170px" />
						<col style="" />
						<col style="width: 80px" />
					</colgroup>
					<tr bgcolor="#F5F5F5">
						<th scope="row"><input type='checkbox' name='ch_cIdall' id='ch_cIdall'></th>
						<th scope="row">카테고리</th>
						<th scope="row">제품명</th>
						<th scope="row">진열여부</th>
					</tr>
					<%=PT_ItemList%>
				</table>
				</form>

				<%=PT_PageLink("layProductSearch","''","yes")%>

				<div class="btn_center pt30">
					<a href="javascript:goAdd()" class="btn_largeG">등록</a>
					<a href="javascript:fnLayerPopupClose()" class="btn_largeW">취소</a>
				</div>
			</div>
		</div>

	</div>
</div>

<% IF serCatecode1<>"" Then %>
<SCRIPT LANGUAGE="JavaScript">
changSelBox1("<%=serCatecode1%>","<%=serCatecode2%>")
</SCRIPT>
<% End IF %>