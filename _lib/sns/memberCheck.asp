<!--#include virtual = _lib/common.asp-->
<%
idx=Request("idx")
Sort=Request("sort")
%>

<style>
.layerBox{margin:0 auto; background-color: #fff; position: relative; box-sizing: border-box; border-top:3px solid #22a840; border-bottom:3px solid #22a840;}
.layerBox>.tit{position: relative;}
.layerBox>.tit>strong{font-weight: 500; font-size:21px; line-height:1; color: #111;}
.layerBox>.tit>.closeLy{margin-top:-7px; display:inline-block; position: absolute; right:0; top:50%;}
.layerBox .contLy{padding-top:20px;}

.passLay{width:580px; padding:40px 35px;}
.passLay>.tit{display:none;}
.passLay>.contLy{padding:0 !important;}
.passLay .txt{font-size:22px; line-height:1; color: #222; margin-bottom:10px;}
.passLay .txt div{font-size:16px; line-height:20px;}

.layerFrm {display:block; position:relative; left:0; top:0; margin-top:20px}
.layerFrm input[type=password],.layerFrm input[type=text]{width:385px !important; height:40px;border:1px solid #dddddd; display:block; padding:0px 10px ; margin-bottom:15px; font-size:14px; box-sizing: border-box}
.btnSubmit{position:absolute;top:0px;right:0px;}
.layerFrm .btn-pack{width: 115px; height: 95px; position:absolute; top:0; right:0;}

/* 버튼 */
.buttons {*zoom:1; max-width:1200px; margin:20px auto;}
.buttons:after {content:" "; display:block; clear:both;}
.buttons .cen {text-align:center;}
.buttons .cen .btn-pack {margin:0 2px;}
.buttons .fr {float:right;}
.buttons .fl {float:left;}
.buttons a {text-decoration:none;}
.buttons a,.buttons input {vertical-align:top;}

.btn-pack {display:inline-block;overflow:visible;position:relative;margin:0;padding:0 10px;background:#fff;color:#4d4d4d;border:1px solid #ddd;text-align:center;text-decoration:none !important;vertical-align:top;white-space:nowrap;cursor:pointer;outline:0;box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.btn-pack.focus {background:#22a840; border:1px solid #22a840; color:#fff; font-size:18px;}
.btn-pack.dark {background:#555; border:1px solid #555;  color:#fff;}
.btn-pack.medium {height:35px;padding:0 12px;line-height:33px;font-size:14px;}
.btn-pack.large {height:40px;padding:0 26px;line-height:38px;font-size:15px;}
.btn-pack.xlarge {height:45px;padding:0 30px;line-height:43px;font-size:16px;font-weight:400;}
.btn-pack.small {height:30px;padding:0 10px;line-height:28px;font-size:13px;}
.btn-pack.comment {width:110px; height:62px;padding:0;line-height:60px;font-size:18px;font-weight:400;}
.btn-pack.submit {width:110px;height:40px;border:0;background:#0072bc;border:1px solid #0072bc;color:#fff;font-size:15px;font-weight:400;}
.btn-pack.cancel {width:110px;height:40px;border:0;background:#fff;border:1px solid #a6a7a7;color:#4d4d4d;font-size:15px;font-weight:400;}
</style>

<div class="popWrap">
	<div class="popCon">
		
		<div class="layerBox passLay">
			<div class="contLy">
				<div class="txt">
					SNS 로그인을 위해서는 회원가입이 필요합니다.
					<div style='margin-top:10px;'>기존 회원이시라면 로그인을 해주세요. 완료시 자동으로 SNS연결이 됩니다.</div>
					<div>기존회원이 아니라면 편리한 간편 회원가입을 해주세요.</div>
				</div>
				
				<form name="snsloginfrm" method="post" action="../member/login_ok.asp" onSubmit="mainLoginInputSendit(snsloginfrm);return false;">
				<input type='hidden' name='snsLogin' value='1'>
				<input type='hidden' name='guestCHK' value='<%=guestCHK%>'>
				<input type='hidden' name='returnURL' value='<%=returnURL%>'>
				<div class="layerFrm">
					<input type="text" id="snsUserid" name="userid" value="" maxlength="15" onkeydown="mainLoginInputSendit(snsloginfrm);" placeholder="ID를 입력하세요." />
					<input type="password" id="snsPwd" name="passwd" value="" maxlength="15" onkeydown="mainLoginInputSendit(snsloginfrm);" placeholder="비밀번호를 입력하세요." />
					<input type="button" value="로그인" class="btn-pack focus login" onclick="mainLoginSend(snsloginfrm);">
				</div>
				</form>

				<div class="buttons mt20">
					<div class="cen">
						<a href="../member/yak.asp?snsReg=1" class="btn-pack large dark ">간편 회원가입하기</a>
						<a href="javascript:fnLayerPopupClose()" class="btn-pack large">닫기</a>
					</div>
				</div>

			</div>
		</div>

	</div>
</div>