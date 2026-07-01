<!--#include virtual = _lib/common.asp-->
<%
idx=Request("idx")
Sort=Request("sort")
%>

<style>
.layerBox{margin:0 auto; background-color: #fff; font-size:0; line-height:0; position: relative; box-sizing: border-box;}
.layerBox>.tit{position: relative;}
.layerBox>.tit>strong{font-weight: 500; font-size:21px; line-height:1; color: #111;}
.layerBox>.tit>.closeLy{margin-top:-7px; display:inline-block; position: absolute; right:0; top:50%;}
.layerBox .contLy{padding-top:20px;}

.passLay{width:520px; padding:50px 55px;}
.passLay>.tit{display:none;}
.passLay>.contLy{padding:0 !important;}
.passLay .txt{font-size:22px; line-height:1; color: #222;}
.passLay input[type=password]{width:100%; height:50px; padding:0 10px; background-color:#fff; border:1px solid #ccc; font-weight: 300; font-size:16px; line-height:48px; color:#454545; vertical-align:middle; display:inline-block; box-sizing: border-box;}
.mt20{margin-top:20px;}
</style>

<div class="popWrap">
	<div class="popCon">
		
		<form name='passFrm' id='passFrm' method='post' action='' onSubmit="boardcheckpwd('<%=Sort%>');return false;" >
		<input type='hidden' name='idx' value="<%=idx%>">
		<div class="layerBox passLay">
			<div class="contLy">
				<p class="txt"><%=Langpack_EnterPassMsg%></p>
				<p class="form mt20"><input type="password" name='pwd' id="pwd" maxlength="20" value="" /></p>
				<div class="board_btn" style='margin:2rem 0 0;'>
					<a href="javascript:fnLayerPopupClose()" class="click cancel closeLy"><%=LangPack_wBtnCancel%></a>
					<a href="javascript:boardcheckpwd('<%=Sort%>');" class="click red"><%=LangPack_wBtnSubmit%></a>
				</div>
			</div>
		</div>
		</form>

	</div>
</div>