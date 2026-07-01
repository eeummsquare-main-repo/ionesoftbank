<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
serDate = uf_getRequest(Request("serDate"),"char","10","")
bbscode = uf_getRequest(Request("bbscode"),"int","","")

IF serDate<>"" AND bbscode<>"" Then
	Sql="SELECT idx, title, content FROM bbslist WHERE isDisplay=1 AND viewdate='"&serDate&"' AND boardidx='"&bbscode&"'"
	Set Rs=DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then Allrec = Rs.GetRows()
	Set Rs=Nothing
End IF

DBcon.Close
Set DBcon=Nothing

Function PT_List()
	IF isArray(Allrec) Then
		For i = 0 To Ubound(Allrec,2)
			Response.Write "	<li>"&Vbcrlf
			Response.Write "		<a href=""javascript:void(0);"" class=""bbsViewLink"" dataidx="""&Allrec(0,i)&""">"&Vbcrlf
			Response.Write "			<div class=""tit"">"&ReplaceNoHtml(Allrec(1,i))&"</div>"&Vbcrlf
			Response.Write "			<div class=""txt"">"&RemoveUnallowTags(Allrec(2,i), "")&"</div>"&Vbcrlf
			Response.Write "		</a>"&Vbcrlf
			Response.Write "	</li>"&Vbcrlf
		Next
	End IF
End Function
%>

<div class="calendarList">
	<div class="title"><%=uf_ConvertDateFormat(serDate, 7)%> 일정</div>
	<ul>
		<%=PT_List()%>
	</ul>
</div>