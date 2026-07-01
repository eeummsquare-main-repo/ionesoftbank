<SCRIPT language=JavaScript src="/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>

<div style='height:20px;'></div>
<form name='boardfrm' method='post' action='../board/ok_bbsReply.asp' ENCTYPE="multipart/form-data" style='margin:0'>
<input type='hidden' name='editorYN' value=''>
<input type='hidden' name='seritemidx' value='<%=seritemidx%>'>
<input type='hidden' name='serstoreidx' value='<%=serstoreidx%>'>
<input type="hidden" name='bbscode' value='<%=BBsCode%>'>
<input type="hidden" name='serboardsort' value='<%=serboardsort%>'>
<input type="hidden" name='Search' value='<%=Search%>'>
<input type="hidden" name='searchStr' value='<%=searchStr%>'>
<input type="hidden" name='pageSize' value='<%=pageSize%>'>
<input type="hidden" name='page' value='<%=Page%>'>
<input type="hidden" name='Ref' value='<%=Ref%>'>
<input type="hidden" name='ReLevel' value='<%=ReLevel%>'>
<input type="hidden" name='idx' value='<%=idx%>'>
<input type="hidden" name='useridx' value='<%=Session("useridx")%>'>
<input type="hidden" name='prePage' id='prePage' value='<%=prePage%>'>
<table cellspacing="0" border="0" width="100%;" class="tbl_write" style='table-layout:fixed;'>
<colgroup>
<col width="80">
<col>
<col width="80">
<col>
</colgroup>
<thead>
	<tr>
		<th scope="row"><%=LangPack_wWriter%></th>
		<td <% IF Not(HK_MemYN="" AND Session("useridx")="") Then %>colspan='3'<% End IF %>><input name="writer" type="text" size='38' maxlength='10' class='input' value='<%=Session("username")%>'></td>
		<% IF HK_MemYN="" AND Session("useridx")="" Then %>
		<th scope="row"><%=LangPack_wPass%></th>
		<td><input name="pass" type="password" size='38' maxlength='10' class='input'></td>
		<% End IF %>
	</tr>
</thead>
<tbody>
	<tr>
		<th scope="row"><%=LangPack_wTitle%></th>
		<td colspan="3"><input name="title" type="text" size="50" maxlength='45' class='input' style="width:98%;"></td>
	</tr>
	<tr>
		<td colspan="4" style='padding:10px 0 5px 0;'><div id='textareaDIV'><textarea name="content" id="ucontent" style='width:100%; word-break:break-all;' rows="15" class='ckeditor'></textarea></div></td>
	</tr>
	<% IF HK_PdsYN<>"False" Then %>
	<tr>
		<th scope="row"><%=LangPack_wFiles%></th>
		<td colspan="3">
			<table cellpadding='0' cellspacing='0' width='100%' id="inRow">
				<tr>
					<td style='padding:1px 0; border:0px solid #ffffff'>
						<input type='file' name='files' style='width:350px' class='input'>
						<input type='hidden' name='filedel_idx' value='0'>
						<a href='#jLink' onclick="addRow()"><span style='color: #D90000'><%=LangPack_FileAddBtn%></span></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<% End IF %>
</tbody>
</table>

<div style='padding:10px; text-align:center;'>
	<input type="button" value="<%=LangPack_wBtnSubmit%>" name="" class="btn_wide_gray" onclick='replysendit();' style='cursor:pointer'>
	<input type="button" value="<%=LangPack_wBtnCancel%>" name="" class="btn_wide_gray" onclick='history.back();' style='cursor:pointer'>
</div>
</form>

<SCRIPT LANGUAGE="JavaScript">
CKEDITOR.replace( 'ucontent', { customConfig: 'config_user.js' } );
</SCRIPT>