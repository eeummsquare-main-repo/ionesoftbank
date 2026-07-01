<!--#include virtual = _lib/common.asp-->
<!-- #include virtual = _lib/dbcon.asp -->
<%
Dim cmd
Dim C_Year, C_Month
Dim schsort
Dim Allrec, ContentRec, BlockTimeRec

C_Year = uf_getRequest(Request("c_year"),"int","",Year(Now))
C_Month = uf_getRequest(Request("c_month"),"int","12",Month(Now))
'bbscode = uf_getRequest(Request("bbscode"),"int","",1)
bbscode = 8

Set cmd=CreateCommand(dbcon,"UP_bbsCalendar",adCmdStoredProc)
With cmd
	.Parameters.Append CreateInputParameter("@Date",adChar,7,C_Year&"-"&AddZero(C_Month))
	.Parameters.Append CreateInputParameter("@BBSCODE",adBigint,8,bbscode)
	Set Rs=.execute
End With

IF Not(Rs.Bof Or Rs.Eof) Then Allrec=Rs.GetRows()

setDate1 = C_Year&"-"&AddZero(C_Month)&"-01"
setDate2 = C_Year&"-"&AddZero(C_Month)&"-31"

Sql = "SELECT idx, viewdate, title, note1, note2, note3 FROM bbslist WHERE boardidx="&bbscode&" AND isDisplay=1 AND viewdate BETWEEN '"&setDate1&"' AND '"&setDate2&"' order by Topyn DESC, sortDate DESC,Ref desc, Idx DESC"
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
						SetDateClass=""
					ElseIF j=6 Then											'토요일이라면
						SetDateClass=""
					End IF

					IF CDbl(Allrec(j,i)) = CINT(Allrec(j,i))+0.3 Then		'스케쥴 있고 공휴일
						SetDateClass="selected"
						holidaycont="<div class='holidaycont'>"&Get_HolidaysTitle(SetDate)&"</div>"
					ElseIF CDbl(Allrec(j,i)) = CINT(Allrec(j,i))+0.2 Then	'공휴일
						SetDateClass=""
						holidaycont="<div class='holidaycont'>"&Get_HolidaysTitle(SetDate)&"</div>"
					ElseIF CDbl(Allrec(j,i)) = CINT(Allrec(j,i))+0.1 Then
						SetDateClass="selected"
					End IF

					IF CStr(Date())=CStr(SetDate) Then
						toDayClass = ""
					End IF

					Response.write "	<td id=""cal_"&SetDate&""" class=""dayTD "&toDayClass&" "&SetDateClass&""" dg-data="""&SetDate&""">"&Cint(Allrec(j,i))&"</td>"&Vbcrlf
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
			idx = ChangeBlank(dataRec(0,i))
			viewdate = ChangeBlank(dataRec(1,i))
			title = ChangeBlank(dataRec(2,i))
			note1 = ChangeBlank(dataRec(3,i))
			note2 = ChangeBlank(dataRec(4,i))
			note3 = ChangeBlank(dataRec(5,i))

			Response.Write "<div class="""&viewdate&""">"&Vbcrlf
			Response.Write "<li>"&Vbcrlf
			Response.Write "	<h4>"&ReplaceNoHtml(title)&"</h4>"&Vbcrlf
			IF note1<>"" Then
				Response.Write "	<p><span>시간</span>"&ReplaceNoHtml(note1)&"</p>"&Vbcrlf
			End IF
			IF note2<>"" Then
				Response.Write "	<p><span>장소</span>"&ReplaceNoHtml(note2)&"</p>"&Vbcrlf
			End IF
			IF note3<>"" Then
				Response.Write "	<p><span>인원</span>"&ReplaceNoHtml(note3)&"</p>"&Vbcrlf
			End IF
			Response.Write "</li>"&Vbcrlf
			Response.Write "</div>"&Vbcrlf

			'Response.Write "<div dataDate="""&viewdate&"""><a href=""javascript:void(0);"" class="""&dataClass&""" dg-data="""&viewdate&""">"&ReplaceNoHtml(dataRec(3,i))&"</a></div>"
		Next
	End IF
End Function
%>

<div class="top clear">
	<img class="btn_left" src="/images/main/calendar_left.png" alt="" onclick="calendarGo(-1,<%=C_Year%>,<%=C_Month%>)" />
	<div class="year_month_wrap">
		<strong><%=C_Year%>년</strong>
		<em><%=AddZero(C_Month)%>월</em>
	</div>
	<img class='btn_right' src="/images/main/calendar_right.png" alt="" onclick="calendarGo(1,<%=C_Year%>,<%=C_Month%>)" />
</div>
<table class="calendar_table">
	<thead>
		<tr>
			<th>일</th>
			<th>월</th>
			<th>화</th>
			<th>수</th>
			<th>목</th>
			<th>금</th>
			<th>토</th>
		</tr>
	</thead>
	<tbody>
		<% PT_Calendar %>
	</tbody>
</table>

<ul id="calendarData" class="disNone">
	<%=PT_Data()%>
</ul>