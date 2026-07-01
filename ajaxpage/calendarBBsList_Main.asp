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
			Response.Write "<li class=""slider"">"&Vbcrlf
			Response.Write "	<a href=""../alart/program.asp?serDate="&serDate&"&idx="&Allrec(0,i)&""">"&Vbcrlf
			Response.Write "	<b>"&Vbcrlf
			Response.Write "		<strong>"&ReplaceNoHtml(Allrec(1,i))&"</strong>"&Vbcrlf
			Response.Write "		<span>"&Vbcrlf
			Response.Write "			<span>"&RemoveUnallowTags(Allrec(2,i), "")&"</span>"&Vbcrlf
			Response.Write "		</span>"&Vbcrlf
			Response.Write "	</b>"&Vbcrlf
			Response.Write "	</a>"&Vbcrlf
			Response.Write "</li>"&Vbcrlf
		Next
	Else
		Response.Write "<li class=""noCalen""><img src=""../images/main/img_none.png""></li>"&Vbcrlf
	End IF
End Function
%>

<div class="date_box">
	<em><%=addZero(Month(serDate))%>.<%=addZero(Day(serDate))%></em>
	<strong><%=Year(serDate)%></strong>
</div>
<div id="schedule_info" class="schedule_info">
	<div class="grap">
		<ul id="ui_event">
			<%=PT_List()%>
		</ul>
	</div>
</div>