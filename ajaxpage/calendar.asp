<!--#include virtual = _lib/common.asp-->
<!-- #include virtual = _lib/dbcon.asp -->
<%
Dim cmd
Dim C_Year, C_Month
Dim schsort
Dim Allrec, ContentRec, BlockTimeRec

C_Year = uf_getRequest(Request("c_year"),"int","",Year(Now))
C_Month = uf_getRequest(Request("c_month"),"int","12",Month(Now))
bbscode = uf_getRequest(Request("bbscode"),"int","",1)

Set cmd=CreateCommand(dbcon,"UP_Calendar",adCmdStoredProc)
With cmd
	.Parameters.Append CreateInputParameter("@Date",adChar,7,C_Year&"-"&AddZero(C_Month))
	Set Rs=.execute
End With

IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()

setDate1 = C_Year&"-"&AddZero(C_Month)&"-01"
setDate2 = C_Year&"-"&AddZero(C_Month)&"-31"

Sql = "SELECT idx, boardsort, viewdate, title, content FROM bbslist WHERE boardidx="&bbscode&" AND isDisplay=1 AND viewdate BETWEEN '"&setDate1&"' AND '"&setDate2&"' order by Topyn DESC, sortDate DESC,Ref desc, Idx DESC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then dataRec = Rs.GetRows()

Rs.Close()
Set Rs=Nothing

Function PT_Calendar()
	Dim i, j, SetDate, resYN, SetDateClass, holidaycont
	Dim resBlockTimeCode

	IF IsArray(Allrec) Then
		For i=0 TO Ubound(Allrec,2)
			Response.write "<tr>"&Vbcrlf
			For j=0 To Ubound(Allrec)
				toDayClass = ""

				IF IsNull(Allrec(j,i)) Then
					Response.write "	<td class=""disabled"" dataDate=""""><span class=""no-choice"">"&Allrec(j,i)&"</span></td>"&vbcrlf
				Else
					SetDateClass="" : holidaycont=""

					SetDate=C_Year&"-"&AddZero(C_Month)&"-"&AddZero(Cint(Allrec(j,i)))
					
					IF j=0 Then												'일요일이라면
						SetDateClass="sunday"
					ElseIF j=6 Then											'토요일이라면
						SetDateClass="saturday"
					End IF

					IF CDbl(Allrec(j,i)) = CINT(Allrec(j,i))+0.3 Then		'스케쥴 있고 공휴일
						SetDateClass="sunday"
						holidaycont="<div class='holidaycont'>"&Get_HolidaysTitle(SetDate)&"</div>"
					ElseIF CDbl(Allrec(j,i)) = CINT(Allrec(j,i))+0.2 Then	'공휴일
						SetDateClass="sunday"
						holidaycont="<div class='holidaycont'>"&Get_HolidaysTitle(SetDate)&"</div>"
					End IF

					IF CStr(Date())=CStr(SetDate) Then
						toDayClass = "current"
					End IF

					'Response.write "	<td><span class=""day"">"&Cint(Allrec(j,i))&"</span><a href=""javascript:goContent('"&SetDate&"','"&bbscode&"')"" class=""cont"">"&Get_SchduleTag(ContentRec(0,Cint(Allrec(j,i))-1))&"</a></td>"&vbcrlf
					'Response.write "	<td class="""&SetDateClass&" dateTD"" style=""background-color:#e6f4ff;cursor:pointer;"">"&Cint(Allrec(j,i))&holidaycont&"<span>"&Get_SchduleTag(ContentRec(0,Cint(Allrec(j,i))-1))&"</span></td>"&vbcrlf
					Response.write "	<td id=""cal_"&SetDate&""" class=""dayTD"" dg-data="""&SetDate&"""><span class=""day "&toDayClass&""">"&Cint(Allrec(j,i))&"</span><div class=""cont""></div></td>"&vbcrlf
				End IF
			Next
			Response.write "</tr>"&Vbcrlf
		Next
	End IF
End Function

Function Get_SchduleTag(str1)
	tmpStr = Replace(str1,"_|","<span>")
	tmpStr = Replace(tmpStr,"|_","</span>")

	Get_SchduleTag = tmpStr
End Function

Function Get_HolidaysTitle(strDate)
	Dim i

	IF IsArray(HolidaysRec) Then
		For i=0 To UBound(HolidaysRec,2)
			IF CStr(HolidaysRec(0,i))=strDate Then
				Get_HolidaysTitle=HolidaysRec(1,i)
				Exit For
			End IF
		Next
	End IF
End Function

Function PT_Data()
	IF IsArray(dataRec) Then
		For i=0 To Ubound(dataRec, 2)
			Response.Write "<div dataDate="""&dataRec(2,i)&"""><a href=""javascript:void(0);"" class="""&dataClass&""" dg-data="""&dataRec(2,i)&""">"&ReplaceNoHtml(dataRec(3,i))&"</a></div>"
		Next
	End IF
End Function
%>

<div class="calendarTop">
	<a href="javascript:calendarGo(-1,<%=C_Year%>,<%=C_Month%>,<%=bbscode%>);" class="p"></a>
	<strong><span><%=C_Year%>년</span> <%=AddZero(C_Month)%>월</strong>
	<a href="javascript:calendarGo(1,<%=C_Year%>,<%=C_Month%>,<%=bbscode%>);" class="n"></a>
</div>

<div class="calendarTb">
	<table>
		<thead>
		<tr>
			<th scope="col">일</th>
			<th scope="col">월</th>
			<th scope="col">화</th>
			<th scope="col">수</th>
			<th scope="col">목</th>
			<th scope="col">금</th>
			<th scope="col">토</th>
		</tr>
		</thead>
		<tbody>
		<% PT_Calendar %>
		</tbody>
	</table>
</div>

<div id="calendarData" class="disNone">
	<%=PT_Data()%>
</div>