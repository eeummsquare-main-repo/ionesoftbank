<script type='text/javascript' src='/common/calendar.js'></script>


<form name="fo_search" method="get">
<input type="hidden" name="tp" value="<%=TP%>">
<table class="tbl_row">
	<colgroup>
		<col style="width: 12%" />
		<col style="width: *" />
	</colgroup>
	<tbody>
		<tr><th colspan='2' style="text-align:center;">확인코자 하는 내역의 조회 기간을 먼저 입력하신 후 조건에 해당하는 항목을 클릭해 주세요!</th></tr>
		<tr>
			<th scope="col">총접속수</th>
			<td><%=FormatNumber(Total_Count,0)%> 명</td>
		</tr>
		<tr>
			<th scope="col">어제 접속수</th>
			<td ><%=FormatNumber(Yesterday_Count,0)%> 명</td>
		</tr>
		<tr>
			<th scope="col">오늘 접속수</th>
			 <td ><%=FormatNumber(Today_Count,0)%> 명</td>
		</tr>
		<tr>
			<th scope="col">조회기간</th>
			<td>
				<div class="term_srch">
					<div class="date_wrap">
						<input type="text" name="fd" value="<%=FDATE%>" class="datepicker1" maxlength='10' onKeyUp="dateFormat(this);" readonly />
						~
						<input type="text" name="ed" value="<%=EDATE%>" class="datepicker2" maxlength='10' onKeyUp="dateFormat(this);" readonly />
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="col">조회항목</th>
			<td>
				<input type='button' value="방문자" class="btn_counter<%if tp = "1" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_1);">
				<input type='button' value="방문도메인" class="btn_counter<%if tp = "2" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_2);">
				<input type='button' value="브라우져" class="btn_counter<%if tp = "3" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_3);">
				<input type='button' value="운영체제" class="btn_counter<%if tp = "4" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_4);">
				<input type='button' value="시간별" class="btn_counter<%if tp = "5" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_5);">
				<input type='button' value="요일별" class="btn_counter<%if tp = "6" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_6);">
				<input type='button' value="일별" class="btn_counter<%if tp = "7" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_7);">
				<input type='button' value="월별" class="btn_counter<%if tp = "8" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_8);">
				<input type='button' value="년별" class="btn_counter<%if tp = "9" then%>_over<% end if %>" onclick="fnSearch(SEARCH_TYPE_9);">
			</td>
		</tr>
	</tbody>
</table>
</form>