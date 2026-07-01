<script type="text/javascript">
<!--
$(document).ready(function(){
	$(document).on("change","select[name=sercate1]",function(){
		var mCd = $(this).val();
		var params = "mCd="+mCd;
		$.ajax({type:"POST", url:"/_lib/_inquiryCateCh.asp",data:params,dataType:"html"
		}).done(function(msg){
			var rData = msg.split("|")
			if (rData[0]=="OK"){
				$("select[name=sercate2] option:not(:first)").remove();
				if (rData[1]==""){
					$("select[name=sercate2]").addClass("disNone");
					$("select[name=sercate2]").addClass("disNone");
				}else{
					$("select[name=sercate2]").removeClass("disNone");
					$("select[name=sercate2]").append(rData[1]);

					var caetSetVal = $("select[name=sercate2]").attr("setVal")
					if (caetSetVal){
						$("select[name=sercate2]").val(caetSetVal);
						$("select[name=sercate2]").attr("setVal", "");
					}
				}
			}else{
				var retMsg = rData[1].replace(/\\n/gi, "\n");
				alert(retMsg)
			}
		});
	});
	$("select[name=sercate1]").change();
});
//-->
</script>

<%=TopSortListTag%>

<% IF isListSearch Then %>
<form name='searchfrm' method='get' style='margin:0' onsubmit="">
<% IF BBsSelectField="" Then %>
<input type='hidden' name="serboardsort" value="<%=serboardsort%>">
<% End IF %>
<div class="board_search">
	<%=BBsSelectField%>

	<% IF BBscode="5" OR BBscode="15" OR BBscode="25" Then %>
	<select name="sercate1" style="width:auto;">
		<option value="">- 분류 전체 -</option>
		<% IF BBscode="5" Then %>
		<%=Create_CCodeOption("amaCate", sercate1)%>
		<% ElseIF BBscode="15" Then %>
		<%=Create_CCodeOption("icubeCate", sercate1)%>
		<% Else %>
		<%=Create_CCodeOption("bizboxCate", sercate1)%>
		<% End IF %>
	</select>
	<select name="sercate2" style="width:auto;" class="disNone" setVal="<%=sercate2%>">
		<option value="">- 분류 전체 -</option>
	</select>
	<% End IF %>

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

<!-- <div class="board_btn">
	<div class="total">Total <strong><%=Count%></strong>, &nbsp; Page <strong><%=Page%></strong></div>
</div> -->

<div class="<%=bbsClass%>">
	<ul class="list">
		<%=PT_BoardList%>
	</ul>
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
</form>