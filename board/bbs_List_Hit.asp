<div class="board_list">
	<table>
		<colgroup>
			<col width="100px">
			<col width="10%">
			<col width="*">
			<col width="7%">
			<col width="10%">
			<col width="7%">
			<col width="7%">
		</colgroup>
		<thead>
		<tr>
			<th scope="col"><%=LangPack_lNo%></th>
			<th scope="col"><%=LangPack_lCate%></th>
			<th scope="col"><%=LangPack_lTitle%></th>
			<th scope="col"><%=LangPack_lWriter%></th>
			<th scope="col"><%=LangPack_lDate%></th>
			<th scope="col"><%=LangPack_lHit%></th>
			<th scope="col">좋아요</th>
		</tr>
		</thead>
		<tbody>
			<%=PT_BoardList%>
		</tbody>
	</table>
</div>

<form name='boardActfrm' id='boardActfrm' method='get' action='' style='margin:0;'>
<input type='hidden' name='mode'>
<input type='hidden' name='sort'>
<input type='hidden' name='idx'>
<input type='hidden' name='Page' value='<%=Page%>'>
<input type='hidden' name='BBSCode' value='<%=BBSCode%>'>
<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
<input type='hidden' name='searchStr' value='<%=searchStr%>'>
<input type='hidden' name='pageSize' value='<%=pageSize%>'>
</form>