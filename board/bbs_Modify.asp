<SCRIPT language=JavaScript src="/_lib/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>

<form name='boardfrm' method='post' action='../board/ok_bbswrite.asp' ENCTYPE="multipart/form-data" style='margin:0;'>
<input type='hidden' name='editorYN' value=''>
<input type='hidden' name='seritemidx' value='<%=seritemidx%>'>
<input type='hidden' name='serstoreidx' value='<%=serstoreidx%>'>
<input type="hidden" name='bbscode' value='<%=BBsCode%>'>
<input type="hidden" name='prepage' value='<%=prepage%>'>
<input type="hidden" name='sort' value='edit'>
<input type='hidden' name='Idx' value='<%=Idx%>'>
<input type='hidden' name='Page' value='<%=Page%>'>
<input type='hidden' name='Search' value='<%=Search%>'>
<input type='hidden' name='searchStr' value='<%=searchStr%>'>
<input type='hidden' name='pageSize' value='<%=pageSize%>'>
<input type='hidden' name='serboardsort' value='<%=serboardsort%>'>
<input type="hidden" name='itemidx' value='<%=itemidx%>'>
<input type="hidden" name='ReLevel' value='<%=ReLevel%>'>
<% IF BBsSort="" Then %>
<input type='hidden' name='boardsort' value='<%=BoardSort%>'>
<% End IF %>

<p class="wPs mt40 disNone"><span class="psBul"><%=LangPack_wRequired%></span></p>
<div class="board_write">
	<table>
		<tbody>
			<% IF BBsSort<>"" Then %>
			<tr>
				<th scope="row"><span class="none"><%=LangPack_wCate%></span></th>
				<td><%=BBsSort%></td>
			</tr>
			<% End IF %>

			<% IF BBscode<>"50" Then %>
			<tr>
				<th scope="row"><span class="psBul"><%=LangPack_wWriter%></span></th>
				<td>
					<div class="btnBox">
						<input name="writer" id="user_name" type="text" maxlength='50' class="small" value='<%=Writer%>' required />

						<% IF HK_PubYN="True" Then %>
						<p class="check-new">
							<input type="checkbox" id="ssCheck" name="publicYN" value="1" <%=iif_Compare(publicYN,True,"checked")%> />
							<label for="ssCheck"><span class="graphic"></span><%=LangPack_wSecret%></label>
						</p>
						<% End IF %>
					</div>
				</td>
			</tr>
			<% End IF %>

			<% IF isWriteStarField=True Then %>
			<tr>
				<th scope="row"><span class="none"><%=LangPack_wStar%></span></th>
				<td style="padding-top:0;">
					<div class="checkIn star">
						<input type="radio" name="stars" value="5" checked id="starCheck05" name="starCheck" />
						<label for="starCheck05"><p class="i_star s5"><span></span></p></label>
					</div>
					<div class="checkIn star">
						<input type="radio" name="stars" value="4" <%=ChangeChecked(stars,4)%> id="starCheck04" name="starCheck" />
						<label for="starCheck04"><p class="i_star s4"><span></span></p></label>
					</div>
					<div class="checkIn star">
						<input type="radio" name="stars" value="3" <%=ChangeChecked(stars,3)%> id="starCheck03" name="starCheck" />
						<label for="starCheck03"><p class="i_star s3"><span></span></p></label>
					</div>
					<div class="checkIn star">
						<input type="radio" name="stars" value="2" <%=ChangeChecked(stars,2)%> id="starCheck02" name="starCheck" />
						<label for="starCheck02"><p class="i_star s2"><span></span></p></label>
					</div>
					<div class="checkIn star">
						<input type="radio" name="stars" value="1" <%=ChangeChecked(stars,1)%> id="starCheck01" name="starCheck" />
						<label for="starCheck01"><p class="i_star s1"><span></span></p></label>
					</div>
				</td>
			</tr>
			<% End IF %>

			<% IF isWriteTelField=True Then %>
			<tr>
				<th scope="row"><span class="none"><%=LangPack_wTel%></span></th>
				<td>
					<div class="flex three">
						<input type="text" name="tel" class="onlyNumber" maxlength="4" value="<%=Tel(0)%>" placeholder="" required />
						<span class="type">-</span>
						<input type="text" name="tel" class="onlyNumber" maxlength="4" value="<%=Tel(1)%>" placeholder="" required />
						<span class="type">-</span>
						<input type="text" name="tel" class="onlyNumber" maxlength="4" value="<%=Tel(2)%>" placeholder="" required />
					</div>
				</td>
			</tr>
			<% End IF %>

			<% IF isWriteEmailField=True Then %>
			<tr>
				<th scope="row"><span class="none"><%=LangPack_wEmail%></span></th>
				<td>
					<div class="flex three emall">
						<input type="text" name="email" maxlength="25" value="<%=email(0)%>" placeholder="" required />
						<span class="type c">@</span>
						<input type="text" name="email" maxlength="25" value="<%=email(1)%>" placeholder="" class="eDomain" required />
						<select title="" name="email_domain" class="eDomailSelector">
							<option value="" selected><%=LangPack_SelboxEdomain%></option>
							<%=PT_ComCodeSelect("email","")%>
						</select>
					</div>
				</td>
			</tr>
			<% End IF %>

			<tr>
				<th scope="row"><span class="none"><%=LangPack_wTitle%></span></th>
				<td><input name="title" id="title" type="text" maxlength='100' value="<%=Title%>" /></td>
			</tr>
			<tr>
				<th scope="row"><span class="none"><%=LangPack_wCon%></span></th>
				<td><textarea name="content" id="ucontent" style="resize:none; "><%=Content%></textarea></td>
			</tr>

		<% IF HK_imgYN<>"False" Then %>
			<tr>
				<th scope="row"><span class="none"><%=LangPack_wImage%></span></th>
				<td class="fileArea">
					<div class="file">
						<span class="file_wrap">
							<span class="btnFile"><%=LangPack_FileSearch%><input type="file" name="imgfiles" class="fileField" title="<%=LangPack_FileSearch%>"/></span>
							<span class="delFile"></span>
						</span>

						<a class="thumb" style="background-image:url('/upload/board/<%=ImgNames%>')"><span class="over" style="background-image:url('/upload/board/<%=ImgNames%>');"></span></a>
						<input name="imgname" id="imgname" type="hidden" value="<%=ImgNames%>" />

						<% IF ImgNames="" Then %>
						<input type='hidden' name='imgDel_Chk' value="1">
						<% Else %>
						<span style='font-size:16px; display:inline-block; vertical-align:middle; margin-left:20px;'>
							<input type='checkbox' name='imgDel_Chk' id="imgDel_Chk" class="fileFieldChk" dataVal="1">
							<label for='imgDel_Chk' style=''><%=LangPack_FileDelChk%></label>
							<a href='/_lib/download.asp?downfile=<%=Server.UrlEncode(ImgNames)%>&path=board'><span style='color: #A80000'>[<%=LangPack_FileDownBtn%>]</span></a>
						</span>
						<% End IF %>
					</div>
				</td>
			</tr>
		<% End IF %>

		<% IF HK_PdsYN<>"False" Then %>
			<tr>
				<th scope="row"><%=LangPack_wFiles%></th>
				<td id="fileArea">
					<div class="fileArea">
						<a onclick="addRow_Front()" class="filePlus"><span><%=LangPack_FileAddBtn%></span></a>
					<% IF IsArray(FileRec) Then %>
						<% For i=0 To UBound(FileRec,2) %>
						<div class="file">
							<span class="file_wrap">
								<span class="btnFile"><%=LangPack_FileSearch%><input type="file" name="files" title="파일첨부" class="fileField"/></span>
							</span>
							<a class="thumb text"></a>
							<p class="check-new">
								<input type='hidden' name='filedel_idx' class="fileDelidx" value='0'>
								<input type="checkbox" id="delcheck<%=i+1%>" name="delchk" class="fileFieldChk" dataVal="<%=FileRec(0,i)%>">
								<label for="delcheck<%=i+1%>"><span class="graphic"></span><%=LangPack_FileDelChk%></label>
							</p>
							<a href='/_lib/download.asp?downfile=<%=Server.UrlEncode(FileRec(1,i))%>&path=board'><span style='color: #A80000; font-size:1.6rem;'>[<%=LangPack_FileDownBtn%>]</span></a>
						</div>
						<% Next%>
					<% Else %>
						<div class="file">
							<span class="file_wrap">
								<span class="btnFile"><%=LangPack_FileSearch%><input type="file" name="files" title="파일첨부"/></span>
							</span>
							<a class="thumb"></a>
						</div>
						<input type='hidden' name='filedel_idx' value='0'>
					<% End IF %>
					</div>
				</td>
			</tr>
		<% End IF %>
		</tbody>
	</table>
</div>
</form>

<div class="board_btn long">
	<a href="javascript:history.back();" class="click cancel"><%=LangPack_wBtnCancel%></a>
	<a href="javascript:modifysendit();" class="click"><%=LangPack_wBtnModify%></a>
</div>

<% IF isWriteEditorUse Then %>
<SCRIPT LANGUAGE="JavaScript">
CKEDITOR.replace( 'ucontent', { customConfig: 'config_user.js' } );
</SCRIPT>
<% End IF %>

<script type="text/javascript">
$(window).load(function(){
	$("body").on("change", ".board_write input[type='file']", function(e){
		var idx = $(".board_write input[type='file']").index($(this));
		var tit = $(this).val();
		$(".board_write .thumb").eq(idx).find(".over").detach();
		$(".board_write .thumb").eq(idx).attr("style","").removeClass("text");
		if (window.File) {
			var input = $(".board_write input[type='file']").get(idx).files[0];
			var reader = new FileReader();
			$(reader).on('load', function(e) {
				if(this.result.indexOf('image') == 5){
					$(".board_write .thumb").eq(idx).attr("title", tit).css('background-image', "url('"+this.result+"')").append('<span class="over" style="background-image:url('+this.result+');"></span>');
				}else{
					$(".board_write .thumb").eq(idx).attr("title", tit).addClass("text").html(tit);
				}
			});
			reader.readAsDataURL(input);
		}
	});
});
</script>