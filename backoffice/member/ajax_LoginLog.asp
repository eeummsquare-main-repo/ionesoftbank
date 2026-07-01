<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx=Request("idx")

Page=GetPage()
PageSize=5

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="select top "&PageSize&" regdate,wip from loginTable WHERE useridx="&idx&" AND idx NOT IN (select top "&(Page-1)*PageSize&" idx from loginTable Where useridx="&idx&" order by Idx DESC) order by Idx DESC"
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(*) from loginTable Where useridx="&idx)
	TotalPage=Int((CInt(Record_Cnt(0))-1)/CInt(PageSize)) +1
	Allrec=Rs.GetRows
	Count=Record_Cnt(0)
End If
Rs.Close

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_List()
	IF IsArray(Allrec) Then
		Num=GetTextNumDesc(Page,Pagesize,Count)

		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr>"&Vbcrlf
			Response.Write "<td class='center'>"&Num&"</td>"&Vbcrlf
			Response.Write "<td class='center'><a href='"&linkStr&"'>"&Allrec(0,i)&"</a></td>"&Vbcrlf
			Response.Write "<td class='center'><a href='"&linkStr&"'>"&Allrec(1,i)&"</a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			Num=Num-1
		Next
	Else
		Response.Write "<tr><td colspan='3' class='center' style='padding:20px 0;'>로그인 데이터가 없습니다.</td></tr>"
	End IF
End Function
%>

<div class="subTitle">로그인 현황 <span style='font-weight:normal; font-size:12px; color: #939393'>(Total : <font color="#FF0000"> <%=FormatNumber(Count,0)%></font> 건)</span></div>

<table class="tbl_row">
	<colgroup>
		<col width="8%" />
		<col />
		<col width="15%" />
	</colgroup>
	<tr>
		<th class='center'>순번</th>
		<th class='center'>접속일자</th>
		<th class='center'>접속IP</th>
	</tr>
	<%=PT_List()%>
</table>
<% IF IsArray(Allrec) Then %><%=PT_PageLink("viewPage","'"&idx&"','ajax_LoginLog.asp','LoginLogDiv'","yes")%><% End IF %>