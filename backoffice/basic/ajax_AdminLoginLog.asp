<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "admin" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim idx, page, pagesize
Dim Record_Cnt, TotalPage, Allrec, Count

Idx = uf_getRequest(Request("idx"),"int","","")
Page = uf_getRequest(Request("page"),"int","","1")
PageSize=10

Sql="select top "&PageSize&" regdate, wip from adminLog WHERE adidx="&idx&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from adminLog WHERE adidx="&idx&" order by Idx DESC) order by Idx DESC"
Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(1) from adminLog WHERE adidx="&idx)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
Else
	Count = 0 : TotalPage = 1
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_List()
	Dim i,Num
	Num=1

	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr>"&Vbcrlf
			Response.Write "	<td>"&Num&"</td>"&Vbcrlf
			Response.Write "	<td class=""left"">"&Allrec(0,i)&"</td>"&Vbcrlf
			Response.Write "	<td class=""left"">"&Allrec(1,i)&"</td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf

			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='3' style=""height:200px;"">로그인 정보가 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<div class="tbl_top">
	<h3>최근접속로그</h3>
</div>
<table class="tbl_col">
	<caption>부운영자관리 목록</caption>
	<colgroup>
		<col style="width: 7%" />
		<col style="width: *" />
		<col style="width: 30%" />
	</colgroup>
	<thead>
		<tr>
			<th scope="row">순번</th>
			<th scope="row">접속일시</th>
			<th scope="row">접속 IP</th>
		</tr>
	</thead>
	<tbody>
		<%=PT_List()%>
	</tbody>
</table>

<%=PT_PageLink("viewPage","'"&idx&"','ajax_AdminLoginLog.asp','LoginLogDiv'","yes")%>