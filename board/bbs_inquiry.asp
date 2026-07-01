<%=TopSortListTag%>

<% IF isListSearch Then %>
<form name='searchfrm' method='get' style='margin:0' onsubmit="">
<% IF BBsSelectField="" Then %>
<input type='hidden' name="serboardsort" value="<%=serboardsort%>">
<% End IF %>
<div class="board_search">
	<%=BBsSelectField%>
	<select name="search">
		<option value="0" <%=selCheck(search,0)%>><%=LangPack_sitemAll%></option>
		<option value="1" <%=selCheck(search,1)%>><%=LangPack_sitemTitle%></option>
		<% IF isListWriterHidden = False Then %>
		<option value="2" <%=selCheck(search,2)%>><%=LangPack_sitemName%></option>
		<% End IF %>
		<option value="3" <%=selCheck(search,3)%>><%=LangPack_sitemCon%></option>
	</select>

	<input type="text" id="searchStr" name="searchStr" class="sch_input" value="<%=ReplaceTextField(oSearchStr)%>" placeholder="<%=LangPack_sStrPlaceHolder%>." />
	<input type="submit" name="" value="<%=LangPack_sBtn%>" />
</div>
</form>
<% End IF %>

<!-- <div class="board_btn">
	<div class="total">Total <strong><%=Count%></strong>, &nbsp; Page <strong><%=page%></strong></div>
</div> -->

<div class="board_list">
	<table>
		<colgroup>
			<col width="100px">
			<col width="10%">
			<col width="10%">
			<col width="">
			<col width="10%">
			<col width="8%">
			<col width="8%">
			<col width="8%">
			<col width="9%">
		</colgroup>
		<thead>
		<tr>
			<th scope="col">No</th>
			<th scope="col">1차분류</th>
			<th scope="col">2차분류</th>
			<th scope="col">제목</th>
			<th scope="col">작성자</th>
			<th scope="col">등록일자</th>
			<th scope="col">상태변경일</th>
			<th scope="col">최종완료일</th>
			<th scope="col">진행상태</th>
		</tr>
		</thead>
		<tbody>
			<%=PT_BoardList%>
		</tbody>
	</table>
</div>

<%=PT_SpPageLink("",PageStr,"")%>

<% IF HK_NotYN="False" AND (CStr(Session("Membership"))>=CStr(HK_MemYN) OR CStr(HK_MemYN)="" ) Then %>
<div class="board_btn end">
	<ul class="board_user">
		<li><a href="javascript:void(0)" class="click write" onclick="<%=WriteModeChk(HK_MemYN,"location.href='?mode=write'",prepage)%>"><%=LangPack_lWriteBtn%> <i class="fa fa-pencil" aria-hidden="true"></i></a></li>
	</ul>
</div>
<% End IF %>

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