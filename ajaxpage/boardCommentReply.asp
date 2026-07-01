<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
Idx=Request("idx")
Page=Request("Page")
BBSCode=Request("BBSCode")

Call HK_BBSSetup(BBsCode)
IF HK_ComYN=False Then Response.End

DBcon.CLose
SET DBcon=Nothing
%>

<div style='padding-top:5px;'>
	<div class="com_write">
		<form id='commentReplyfrm_<%=Idx%>' method='post' style='margin:0'>
		<input type='hidden' name='idx' value='<%=Idx%>'>
		<input type='hidden' name='bbscode' value='<%=bbscode%>'>
		<input type='hidden' name='Page' value='<%=Page%>'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<% IF HK_ComMode="" AND Session("useridx")="" Then %>
		  <tr>
			<td width="135" align="center" class="tt">닉네임</td>
			<td width="300"><input type="text" name='name' maxlength='10'></td>
			<td width="135" align="center" class="tt">비밀번호</td>
			<td width="300"><input type="text" name='pwd' maxlength='10'></td>
		  </tr>
		<% End IF %>
		  <tr>
			<td colspan="4" class="write">
				<textarea name="content" id="r_textarea" onkeyup="str_limit_check( this, 'r_cbyte_span',300 )" style='width:665px'></textarea>
				<a class="btnCm" onclick="<%=WriteModeChk(HK_ComMode,"boardcommentReply('commentReplyfrm_"&Idx&"')","")%>"><span>등 록</span></a>

				<div>
					<span class="byte"><strong><span id='r_cbyte_span'>0</span></strong> / 300 bytes</span>
				</div>
			</td>
		  </tr>
		</table>
		</form>
	</div>
</div>