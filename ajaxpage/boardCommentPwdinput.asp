<%@codepage="65001" language="VBScript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"

mode=Request("mode")
Idx=Request("idx")
bbscode=Request("bbscode")
Page=Request("Page")
targetDiv=Request("targetDiv")
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
</style>

<div class="popWrap">
	<div class="popCon">
		<form name="boardcommentpwdchk" id="boardcommentpwdchk" method="post" onsubmit='boardcommentcheckpwd();return false;'>
		<input type='hidden' name='mode' value='<%=mode%>'>
		<input type='hidden' name='idx' value='<%=IDX%>'>
		<input type='hidden' name='bbscode' value='<%=bbscode%>'>
		<input type='hidden' name='Page' value='<%=Page%>'>
		<input type='hidden' name='targetDiv' value='<%=targetDiv%>'>

		<div class="layerBox passLay">
			<div class="contLy">
				<p class="txt">비밀번호를 입력해주세요.</p>
				<p class="form mt20"><input type="password" name='pwd' id="pwd" maxlength="20" value="" /></p>
				<div class="btnArea tac mt20">
					<a href="javascript:fnLayerPopupClose()" class="btns board cancel closeLy">취소</a>
					<a href="javascript:boardcommentcheckpwd();" class="btns board red">확인</a>
				</div>
			</div>
		</div>
		</form>

	</div>
</div>