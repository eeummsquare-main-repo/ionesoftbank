
<% IF isListSearch Then %>
<form name='searchfrm' method='get' style='margin:0' onsubmit="">
<input type='hidden' name="serboardsort" value="<%=serboardsort%>">
<div class="board_search">
	<select name="search">
		<option value="0" <%=selCheck(search,0)%>><%=LangPack_sitemAll%></option>
		<option value="1" <%=selCheck(search,1)%>><%=LangPack_sitemTitle%></option>
		<% IF isListWriterHidden = False Then %>
		<option value="2" <%=selCheck(search,2)%>><%=LangPack_sitemName%></option>
		<% End IF %>
		<option value="3" <%=selCheck(search,3)%>><%=LangPack_sitemCon%></option>
	</select>

	<input type="text" id="searchStr" name="searchStr" class="sch_input" value="<%=ReplaceTextField(oSearchStr)%>" placeholder="검색어를 입력해주세요." />
	<input type="submit" name="" value="<%=LangPack_sBtn%>" />
</div>
</form>
<% End IF %>

<%=TopSortListTag%>

<div class="faqWrap">

	<div class="faqTop">
		<div class="wd1"><b>No</b></div>
		<div class="wd2"><b>구분</b></div>
		<div class="wd3"><b>상세</b></div>
		<div class="wd4"><b>질문</b></div>
		<div class="wd5"><b>파일</b></div>
		<div class="wd6"><b>링크</b></div>
	</div>
	
	<ul class="faqArea">
		<%=PT_BoardList%>
	</ul>
</div>

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
<input type='hidden' name='artistidx' value='<%=artistidx%>'>
</form>