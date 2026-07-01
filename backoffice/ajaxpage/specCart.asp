<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
page=uf_getRequestProc(Request("page"), "int", "", "1")
PageSize=10

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="select top "&PageSize&" idx,title,regdate from specCart WHERE idx NOT IN (select top "&(Page-1)*PageSize&" idx from specCart order by idx DESC) order by Idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(*) from specCart")
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count=0 : TotalPage=1
End IF
Rs.Close

DBcon.CLose
SET DBCOn=Nothing

Function PT_List
	Dim i,Num
	Num=1

	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr>"&Vbcrlf
			Response.Write "<td>"&Num&"</td>"&Vbcrlf
			Response.Write "<td>"&ReplaceNoHtml(Allrec(1,i))&"</td>"&Vbcrlf
			Response.Write "<td>"&Left(Allrec(2,i),10)&"</td>"&Vbcrlf
			Response.Write "<td>"&Vbcrlf
			Response.Write "	<input type='button' value='수정' class='btn_gray' style='width:45px' onclick=""viewSpecCartModify('"&Allrec(0,i)&"','"&page&"')"">"&Vbcrlf
			Response.Write "	<input type='button' value='삭제' class='btn_gray' style='width:45px' onclick=""SpecCartDel('"&Allrec(0,i)&"','"&page&"')"">"&Vbcrlf
			Response.Write "</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='4' align='center' height='100'>등록된 스펙이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<div class="popWrap">
	<div class="popCon">
		<h1>스펙바구니 관리<a href="#" class="btnClose"><img src="/backoffice/images/close_popup.gif" alt="" /></a></h1>

		<div id="container">
			<div id="contents">

				<div style='line-height:1.3; padding: 0 10px 5px 0px;color: #ffffff; height:330px; width:800px;'>
					<table class="tbl_col">
						<tr height="25" align="center" bgcolor="#F6F6F6">
							<td width="50">순번</td>
							<td width=''>제목</td>
							<td width="90">등록일</td>
							<td width="100">관리</td>
						</tr>
						<%PT_List()%>
					</table>
					<div style='float:right; padding:10px 0 0 0;'><input type='button' value='등록' class='btn_gray' style='width:70px' onclick="viewSpecCartArea('write','<%=page%>')"></div>
					<center style='padding:10px 0 0 0;'><%=PT_PageLink("viewSpecCartArea","'list'","yes")%></center>
				</div>

				<div class="btn_center pt30">
					<a href="javascript:fnLayerPopupClose()" class="btn_largeW">닫기</a>
				</div>
			</div>
		</div>

	</div>
</div>