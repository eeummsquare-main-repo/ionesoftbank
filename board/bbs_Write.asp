<SCRIPT language=JavaScript src="/_lib/ckeditor/ckeditor.js" type='text/javascript'></SCRIPT>

	<script type="text/javascript">
	$(document).ready(function(){
		$(document).on("click",".inqSubmitBtn",function(){
			var requiredFlag = true;
			var frm = $(this).closest("form");

			if( requiredFlag == true ) {
				if ($("select[name=cate1] option").size()>1 && $("select[name=cate1]").val()==""){
					alert("상담분류는 필수 선택항목입니다.");
					requiredFlag = false;
					return false;
				}

				if ($("select[name=cate2] option").size()>1 && $("select[name=cate2]").val()==""){
					alert("상담분류는 필수 선택항목입니다.");
					requiredFlag = false;
					return false;
				}
				if ($("select[name=cate3] option").size()>1 && $("select[name=cate3]").val()==""){
					alert("상담분류는 필수 선택항목입니다.");
					requiredFlag = false;
					return false;
				}
			}
			$(this).closest("form").find('.reqField').each(function(){
				itemTitle = $(this).attr("reqTitle")

				if ( $(this).is(':text, textarea, select') && $(this).val().length < 1 ) {
					alert('['+itemTitle+']는 필수 입력항목 입니다.');
					$(this).focus();
					requiredFlag = false;
					return false;
				}else if ( $(this).is(':file') && $(this).val().length < 1 ) {
					alert('['+itemTitle+']는 필수 업로드항목 입니다.');
					requiredFlag = false;
					return false;
				}else if ( $(this).is(':checkbox') ) {
					attrName = $(this).attr("name")
					if($("input:checkbox[name="+attrName+"]:checked").length==0) {
						alert('['+itemTitle+']는 필수 선택항목 입니다.');
						$(this).focus();
						requiredFlag = false;
						return false;
					}
				}else if ( $(this).is(':radio') ) {
					attrName = $(this).attr("name")

					if(!$("input:radio[name="+attrName+"]").is(":checked") == true) {
						alert('['+itemTitle+']는 필수 선택항목 입니다.');
						$(this).focus();
						requiredFlag = false;
						return false;
					}
				};
			});
			if( requiredFlag == true ) {
				frm.submit();
			}
		});

		$(document).on("change","select[name=cate1]",function(){
			var mCd = $(this).val();
			var params = "mCd="+mCd;
			$.ajax({type:"POST", url:"/_lib/_inquiryCateCh.asp",data:params,dataType:"html"
			}).done(function(msg){
				var rData = msg.split("|")
				if (rData[0]=="OK"){

					if (rData[1]==""){
						$("select[name=cate2]").addClass("disNone");
						$("select[name=cate3]").addClass("disNone");
					}else{
						$("select[name=cate2]").removeClass("disNone");
						$("select[name=cate3]").addClass("disNone");
					}

					$("select[name=cate2] option:not(:first)").remove();
					$("select[name=cate2]").append(rData[1])
				}else{
					var retMsg = rData[1].replace(/\\n/gi, "\n");
					alert(retMsg)
				}
			});
		});

		$(document).on("change","select[name=cate2]",function(){
			var mCd = $(this).val();
			var params = "mCd="+mCd;
			$.ajax({type:"POST", url:"/_lib/_inquiryCateCh.asp",data:params,dataType:"html"
			}).done(function(msg){
				var rData = msg.split("|")
				if (rData[0]=="OK"){

					if (rData[1]==""){
						$("select[name=cate3]").addClass("disNone");
					}else{
						$("select[name=cate3]").removeClass("disNone");
					}

					$("select[name=cate3] option:not(:first)").remove();
					$("select[name=cate3]").append(rData[1])
				}else{
					var retMsg = rData[1].replace(/\\n/gi, "\n");
					alert(retMsg)
				}
			});
		});
	});
	</script>

<form name='boardfrm' id='boardfrm' action='../board/ok_bbswrite.asp' method='post' ENCTYPE="multipart/form-data" style='margin:0;'>
<input type='hidden' name='editorYN' value='0'>
<input type="hidden" name='seritemidx' value='<%=seritemidx%>'>
<input type="hidden" name='serstoreidx' id='serstoreidx' value='<%=serstoreidx%>'>
<input type="hidden" name='bbscode' id='bbscode' value='<%=BBsCode%>'>
<input type="hidden" name='serboardsort' id='serboardsort' value='<%=serboardsort%>'>
<input type="hidden" name='prePage' id='prePage' value='<%=prePage%>'>
<input type="hidden" name='itemidx' value='<%=itemidx%>'>
<input type="hidden" name='useridx' id='useridx' value='<%=Session("useridx")%>'>
<% IF BBsSort="" Then %>
<input type='hidden' name='boardsort' value='<%=BoardSort%>'>
<% End IF %>

<div class="board_write">
	<table>
		<tbody>
			<% IF BBsSort<>"" Then %>
			<tr>
				<th scope="row"><span class="psBul"><%=LangPack_wCate%></span></th>
				<td><div class="btnBox"><%=BBsSort%></div></td>
			</tr>
			<% End IF %>

			<% IF BBscode="8" OR BBscode="18" OR BBscode="28" OR BBscode="40" Then %>
			<tr>
				<th scope="row"><span class="psBul">상담분류</span></th>
				<td>
					<select name="cate1" style="width:auto;">
						<option value="">선택하세요</option>
						<% IF BBscode="8" Then %>
						<option value="uc">UC</option>
						<option value="erp">ERP</option>
						<% ElseIF BBscode="18" Then %>
						<option value="icube">iCUBE</option>
						<option value="icubeg20">iCUBE G20</option>
						<% ElseIF BBscode="40" Then %>
						<option value="cusetc">기타</option>
						<% Else %>
						<option value="bizboxalpha">Bizbox Alpha</option>
						<% End IF %>
					</select>
					<select name="cate2" style="width:auto;" class="disNone">
						<option value="">선택하세요</option>
					</select>
					<select name="cate3" style="width:auto;" class="disNone">
						<option value="">선택하세요</option>
					</select>
				</td>
			</tr>

			<tr>
				<th scope="row"><span class="psBul">회사정보</span></th>
				<td>
					<%=ReplaceNoHtml(GB_Member_Bizcode)%> / <%=ReplaceNoHtml(GB_Member_Company)%>
				</td>
			</tr>
			<% End IF %>

			<% IF BBscode<>"50" Then %>
			<tr>
				<th scope="row"><span class="psBul"><%=LangPack_wWriter%></span></th>
				<td>
					<div class="flex">
						<input name="writer" id="user_name" type="text" maxlength='50' class="small reqField" reqTitle="이름" value='<%=Session("username")%>' required />

						<% IF HK_PubYN="True" Then %>
						<p class="check-new">
							<input type="checkbox" id="ssCheck" name="publicYN" value="1" checked />
							<label for="ssCheck"><span class="graphic"></span><%=LangPack_wSecret%></label>
						</p>
						<% End IF %>
					</div>
					<% IF HK_PubYN="True" Then %>
					<p class="type star mt">체크 해제 시, 전체 회원에게 문의 글이 노출됩니다.</p>
					<% End IF %>
				</td>
			</tr>
			<% End IF %>

			<% IF isPwdField=True AND HK_MemYN="" AND Session("useridx")="" Then %>
			<tr>
				<th scope="row"><span class="psBul"><%=LangPack_wPass%></span></th>
				<td>
					<div class="btnBox">
						<input type="password" name="pass" id="pass" maxlength='10' class="small" required />
					</div>
				</td>
			</tr>
			<% End IF %>

			<% IF isWriteStarField=True Then %>
			<tr>
				<th scope="row"><span class=""><%=LangPack_wStar%></span></th>
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
				<th scope="row"><span class="psBul"><%=LangPack_wTel%></span></th>
				<td>
					<div class="flex three">
						<input type="text" name="tel" class="onlyNumber reqField" reqTitle="연락처" maxlength="4" value="<%=GB_Member_ArrPhone(0)%>" placeholder="" required />
						<span class="type">-</span>
						<input type="text" name="tel" class="onlyNumber reqField" reqTitle="연락처" maxlength="4" value="<%=GB_Member_ArrPhone(1)%>" placeholder="" required />
						<span class="type">-</span>
						<input type="text" name="tel" class="onlyNumber reqField" reqTitle="연락처" maxlength="4" value="<%=GB_Member_ArrPhone(2)%>" placeholder="" required />
					</div>
				</td>
			</tr>
			<% End IF %>

			<% IF isWriteEmailField=True Then %>
			<tr>
				<th scope="row"><span class="psBul"><%=LangPack_wEmail%></span></th>
				<td>
					<div class="flex three emall">
						<input type="text" name="email" maxlength="25" value="<%=GB_Member_ArrEmail(0)%>" placeholder="" required  class="reqField" reqTitle="이메일"/>
						<span class="type c">@</span>
						<input type="text" name="email" maxlength="25" value="<%=GB_Member_ArrEmail(1)%>" placeholder="" class="eDomain reqField" reqTitle="이메일" required />
						<select title="" name="email_domain" class="eDomailSelector">
							<option value="" selected><%=LangPack_SelboxEdomain%></option>
							<%=PT_ComCodeSelect("email","")%>
						</select>
					</div>
				</td>
			</tr>
			<% End IF %>

			<tr>
				<th scope="row"><span class="psBul"><%=LangPack_wTitle%></span></th>
				<td><input name="title" id="title" type="text" maxlength='100' required class="reqField" reqTitle="제목" /></td>
			</tr>
			<tr>
				<th scope="row"><span class="psBul"><%=LangPack_wCon%></span></th>
				<td><textarea name="content" id="ucontent" style="resize:none; " required class="reqField" reqTitle="내용"></textarea></td>
			</tr>

		<% IF HK_imgYN<>"False" Then %>
			<tr>
				<th scope="row"><span class=""><%=LangPack_wImage%></span></th>
				<td>
					<div class="file">
						<span class="file_wrap">
							<span class="btnFile"><%=LangPack_FileSearch%><input type="file" name="imgfiles" title="<%=LangPack_FileSearch%>"/></span>
							<span class="delFile"></span>
						</span>
						<a class="thumb"></a>
					</div>
				</td>
			</tr>
		<% End IF %>

		<% IF HK_PdsYN<>"False" Then %>
			<tr>
				<th scope="row"><%=LangPack_wFiles%></th><!-- 수정했음! -->
				<td id="fileArea">
					<div class="fileArea">
						<a onclick="addRow_Front()" class="filePlus"><span><%=LangPack_FileAddBtn%></span></a>
						<div class="file">
							<span class="file_wrap">
								<span class="btnFile">파일첨부<input type="file" name="files" title="파일첨부"/></span>
							</span>
							<a class="thumb"></a>
						</div>
					</div>
				</td>
			</tr>
		<% End IF %>
		</tbody>
	</table>
</div>

<% IF isWriteAgreeField = True Then %>
	<!-- [s] 개인정보처리방침
	<div class="clauseArea ">
		<p class="tit"><%=LangPack_PolicyTitle%></p>
		<div class="scroll">
				지점 문의사항 관련 개인정보 수집동의 (필수)<br />
				1. 개인정보의 수집 및 이용 목적<br />
				- 지점 문의사항에 대한 원활한 상담<br />
				- 지점 문의사항에 관련 정보 안내<br />
				2. 수집하는 개인정보의 항목<br />
				- 이름, 휴대폰번호, 이메일<br />
				3. 개인정보 보유 및 이용기간<br />
				- 이용 목적 달성 후, 내부규정에 따라 보관 및 지체없이 파기<br />
				※ 귀하께서는 위 개인정보 수집, 이용에 대한 동의를 거부할 권리가 있으며, 동의 거부 시에는 지점 문의사항 서비스 이용에 제
				한이 될 수 있습니다.<br />
		</div>
		<div class="checkBox end">
			<p class="check-new">
				<input type="checkbox" id="bbsagree" name="clauseCheckss2" />
				<label for="bbsagree"><%=LangPack_PolicyTxt%></label>
			</p>
		</div>
	</div>
	 [e] 개인정보처리방침 -->
<% End IF %>

<div class="board_btn long">
	<a href="javascript:history.back();" class="click cancel"><%=LangPack_wBtnCancel%></a>
	<a class="click inqSubmitBtn"><%=LangPack_wBtnSubmit%></a>
</div>
</form>

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