<% IF isListSearch Then %>
<form name='searchfrm' method='get' style='margin:0' onsubmit="">
<input type='hidden' name='serYear' value='<%=serYear%>'>
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
	<input type="text" id="searchStr" name="searchStr" class="sch_input" value="<%=ReplaceTextField(Request("searchStr"))%>" placeholder="<%=LangPack_sStrPlaceHolder%>" />
	<input type="submit" name="" value="<%=LangPack_sBtn%>" />
</div>
</form>
<% End IF %>

<div class="board_btn">
	<div class="total">Total <strong><%=Count%></strong>, &nbsp; Page <strong><%=Page%></strong></div>
	<% IF BBscode="1" OR BBscode="3" OR BBscode="101" OR BBscode="103" Then %>
	<div class="years">
		<select name="serYear" onchange="location.href='?serYear='+this.value">
			<option value="">Year</option>
			<% For i=YEAR(Date()) + 1 To 2009 STEP -1%>
			<option value="<%=i%>" <%=iif_compare(serYear, i, "selected")%>><%=i%></option>
			<% Next %>
		</select>
	</div>
	<% End IF %>
</div>

<div class="board_document">
	<% IF TopSortListTag<>"" Then %>
	<div class="aside">
		<%=TopSortListTag%>
	</div>
	<% End IF %>

	<div class="document_contents">
		<ul>
			<%=PT_BoardList%>
		</ul>
	</div>
</div>

<% IF HK_NotYN="False" AND (CStr(Session("Membership"))>=CStr(HK_MemYN) OR CStr(HK_MemYN)="" ) Then %>
<div class="board_btn end">
	<ul class="board_user">
		<li><a href="javascript:void(0)" class="click write big" onclick="<%=WriteModeChk(HK_MemYN,"location.href='?mode=write'",prepage)%>"><%=LangPack_lWriteBtn%> <i class="fa fa-pencil" aria-hidden="true"></i></a></li>		
	</ul>
</div>
<% End IF %>

<%=PT_SpPageLink("",PageStr,"")%>

<form name='boardActfrm' id='boardActfrm' method='get' action='' style='margin:0;'>
<input type='hidden' name='mode'>
<input type='hidden' name='sort'>
<input type='hidden' name='idx'>
<input type='hidden' name='Page' value='<%=Page%>'>
<input type='hidden' name='BBSCode' value='<%=BBSCode%>'>
<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
<input type='hidden' name='search' value='<%=search%>'>
<input type='hidden' name='searchStr' value='<%=searchStr%>'>
<input type='hidden' name='pageSize' value='<%=pageSize%>'>
<input type='hidden' name='seritemidx' value='<%=seritemidx%>'>
<input type='hidden' name='serYear' value='<%=serYear%>'>
</form>