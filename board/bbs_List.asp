<style>
	.bbsimp{display:inline-block; padding:0.5rem 1.3rem; border:1px solid #ff6600; margin-right:1rem; border-radius:99px; font-weight: 600; font-size:0.85em; line-height:1.2; color: #ff6600}
</style>

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
			<% IF isListSortHidden = False Then %>
			<col width="10%">
			<% End IF %>
			<col width="*">
			<% IF isListWriterHidden = False Then %>
			<col width="7%">
			<% End IF %>
			<% IF isListDateHidden = False Then %>
			<col width="10%">
			<% End IF %>
			<% IF isListHitHidden = False Then %>
			<col width="7%">
			<% End IF %>
			<% IF isListTermStats = True Then %>
			<col width="7%">
			<col width="7%">
			<% End IF %>
			<% IF isListDown = True Then %>
			<col width="7%">
			<% End IF %>
			<% IF isListReplyStats Then %>
			<col width="7%">
			<% End IF %>
			<% IF BBscode="5" OR BBscode="7" OR BBscode="15" OR BBscode="17" OR BBscode="25" OR BBscode="26" OR BBscode="27"  OR BBscode="30" Then %>
			<col width="7%">
			<% End IF %>
			<% IF isListLike=True Then %>
			<col width="7%">
			<% End IF %>
		</colgroup>
		<thead>
		<tr>
			<th scope="col"><%=LangPack_lNo%></th>
			<% IF isListSortHidden = False Then %>
			<th scope="col"><%=LangPack_lCate%></th>
			<% End IF %>
			<th scope="col"><%=LangPack_lTitle%></th>
			<% IF isListWriterHidden = False Then %>
			<th scope="col"><%=LangPack_lWriter%></th>
			<% End IF %>
			<% IF isListDateHidden = False Then %>
			<th scope="col"><%=LangPack_lDate%></th>
			<% End IF %>
			<% IF isListHitHidden = False Then %>
			<th scope="col"><%=LangPack_lHit%></th>
			<% End IF %>
			<% IF isListTermStats = True Then %>
			<th scope="col"><%=LangPack_lDateTerm%></th>
			<th scope="col"><%=LangPack_lStatus%></th>
			<% End IF %>
			<% IF isListDown = True Then %>
			<th scope="col"><%=LangPack_lDown%></th>
			<% End IF %>
			<% IF isListReplyStats Then %>
			<th scope="col">답변</th>
			<% End IF %>
			<% IF BBscode="5" OR BBscode="7" OR BBscode="15" OR BBscode="17" OR BBscode="25" OR BBscode="26" OR BBscode="27" OR BBscode="30" Then %>
			<th scope="col">링크</th>
			<% End IF %>
			<% IF isListLike=True Then %>
			<th scope="col">좋아요</th>
			<% End IF %>
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