<!--#include virtual = _lib/common.asp -->
<!--#include virtual = _lib/dbcon.asp-->
<%
isRecord = False
idx = uf_getRequestProc(Request("idx"), "int", "", "")

IF idx<>"" Then
	Sql = "SELECT sDate, eDate, title, memo, bgColor, regdate, allDay, note1 FROM schDuleFlight WHERE idx="&idx
	Set Rs = DBcon.Execute(Sql)
	IF Not(Rs.Bof Or Rs.Eof) Then
		isRecord = True

		sDate = Rs("sDate")
		eDate = Rs("eDate")
		title = Rs("title")
		memo = Rs("memo")
		bgColor = Rs("bgColor")
		regdate = Rs("regdate")
		allDay = Rs("allDay")
		note1 = Rs("note1")

		IF allDay="1" Then
			sDate = Split(sDate,"T")(0)
			eDate = Split(eDate,"T")(0)
		Else
			sDate = Replace(sDate,"T", " ")
			eDate = Replace(eDate,"T", " ")
		End IF
	End IF
End IF

IF Not(isRecord) Then
	Response.Write ExecJavaAlert("게시글 정보를 찾을수 없습니다.",3)
	Response.END
End IF

DBcon.CLose
Set DBcon = Nothing
%>
<div class="layerBox schduleView">
	<a href="javascript:void(0);" class="closeLy"><img src="/images/bnt_lay_close.png" alt="닫기" /></a>
	<div class="contLy">
		<p class="title mb30">Schdule INFO</p>

		<div class="board_write">
			<table>
				<tbody>
					<tr>
						<th width="180">배 이름</th>
						<td><%=ReplaceNoHtml(title)%></td>
					</tr>
					<tr>
						<th>운항위치</th>
						<td><%=ReplaceNoHtml(Note1)%></td>
					</tr>
					<tr>
						<th>운항기간</th>
						<td><%=ReplaceNoHtml(sDate)%> ~ <%=ReplaceNoHtml(eDate)%></td>
					</tr>
				</tbody>
			</table>
		</div>

		<!-- [s] Btn -->
		<div class="mBtn" style='display:inline-block;text-align:center;'>
			<a href="javascript:layerClose('schduleView');" class="ok">닫기</a>
		</div>
		<!-- [e] Btn -->
	</div>
</div>