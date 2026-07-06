<!-- Google Tag Manager (noscript) 2026-02-12(목) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WKPK45TW"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) 2026-02-12(목) -->

<div id="header" class="hh">
	<div class="gnbBg"></div>
	<div class="inConts">
<%
		Dim hdrScriptName, hdrIsHomePage, hdrLogoTag
		hdrScriptName = LCase(Request.ServerVariables("SCRIPT_NAME"))
		hdrIsHomePage = (hdrScriptName = "/index.asp" Or hdrScriptName = "/")
		IF hdrIsHomePage Then
			hdrLogoTag = "p"
		Else
			hdrLogoTag = "h1"
		End IF
%>
		<<%=hdrLogoTag%> class="logo-h">
			<a href="/">
				<img src="/images/logo_tagline_2026.png" class="logo-tagline" alt="Authentic innovation, AX and More" fetchpriority="high" decoding="async">
				<img src="/images/logo.png" class="logo" alt="아이원소프트뱅크 - 더존 ERP 공식 파트너" decoding="async">
				<img src="/images/logo_on.png" class="logo_on" alt="아이원소프트뱅크 - 더존 ERP 공식 파트너" fetchpriority="high" decoding="async">
			</a>
		</<%=hdrLogoTag%>>

		<div id="pcMenu">
			<ul id="list">
				<script type="text/javascript">globalNavigationBar();</script>
			</ul>
		</div>

		<div class="right-utill">
			<div class="language-area">
				<div class="language">
					<a href="/purchase/inquiry.asp">구매상담</a>
				</div>
			</div>
			<div class="language-area">
				<div class="language">
					<% IF Session("useridx")="" Then %>
					<a href="/member/login.asp">로그인</a>
					<% Else %>
					<a href="/member/mypage.asp">마이페이지</a>
					<% End IF %>
				</div>
			</div>
			<button type="button" class="mMenu"><span></span></button>

		</div>
	</div>
</div>
<%' 2026-06-11 옛 PC 퀵메뉴 코드 제거 — 아래 .quick-right 블록이 대체. HTML 주석 안의 img 태그가 진단도구에서 alt 누락으로 카운트되어 삭제. %>
	<style>
		.quickWrap{display:none;}
		.quick-right{position: fixed; right:13px; bottom:130px; z-index:9; display:block;}
		.quick-right .quick-right-re{border-radius:3.2rem; display: flex; justify-content: flex-end; position: relative;}
		.quick-right .quick-right-re+.quick-right-re{margin-top: 1rem;}
		.quick-right .quick-right-re>img{height:6.4rem; position: relative; z-index:2;}
		.quick-right .quick-right-re .quick-right-list{width:6.4rem; height:6.4rem; position: absolute; right:0; top:0; overflow: hidden; border-radius:3.2rem; transition:all .3s linear;}
		.quick-right .quick-right-re .quick-right-list>*{width:24rem; height:6.4rem; padding:0.3rem 0 0 6.5rem; background: #0863de url('/images/icon_tel.jpg') no-repeat 2.3rem center/2rem; font-weight: 500; font-size:1.6rem; line-height:1.3; color: #fff; display: flex; align-items: center; border-radius:999rem; position: relative; left:7rem; transition:all .3s linear; opacity: 0;}
		.quick-right .quick-right-re .quick-right-list>*+*{margin-top:0.5rem;}
		.quick-right .quick-right-re .quick-right-list>* strong{font-weight: 600; display:block;}

		.quick-right .quick-right-re .quick-right-list>*:nth-of-type(2),
		.quick-right .quick-right-re .quick-right-list>*:nth-of-type(3),
		.quick-right .quick-right-re .quick-right-list>*:nth-of-type(4){transition-delay: 0s;}

		.quick-right .quick-right-re .quick-right-list>*.black{background: #222 url('/images/icon_inq.jpg') no-repeat 1.6rem center/3.2rem;}
		.quick-right .quick-right-re .quick-right-list>*.kaka{background: #fae100 url('/images/icon_kaka.jpg') no-repeat 1.1rem center/4.2rem; color: #381e1f;}
		.quick-right .quick-right-re .quick-right-list>*.n-talk{background: #03c75a url('/images/icon_n_talk.jpg') no-repeat 1.7rem center/3rem; color: #fff;}

		.quick-right .quick-right-re:is(:hover, .open) .quick-right-list{width:calc(24rem + 7.4rem); height:auto; padding-right:7.4rem;}
		.quick-right .quick-right-re:is(:hover, .open) .quick-right-list>*{left:0; opacity: 1;}

		.quick-right .quick-right-re:is(:hover, .open) .quick-right-list>*:nth-of-type(2){transition-delay: .2s;}
		.quick-right .quick-right-re:is(:hover, .open) .quick-right-list>*:nth-of-type(3){transition-delay: .3s;}
		.quick-right .quick-right-re:is(:hover, .open) .quick-right-list>*:nth-of-type(4){transition-delay: .4s;}

		@media only screen and (max-width : 840px){
			.quick-right .quick-right-re>img{height:50px;}
			.quick-right .quick-right-re .quick-right-list{width:50px; border-radius:25px;}
			.quick-right .quick-right-re .quick-right-list>*{width:24rem; height:50px;}
			.quick-right .quick-right-re .quick-right-list>*{padding:0 0 0.3rem 6.5rem; font-size:1.8rem;}

			.quick-right .quick-right-re:is(:hover, .open) .quick-right-list{width:calc(24rem + 60px); padding-right:60px;}

			.quick-right .quick-right-re .quick-right-list>*.black,
			.quick-right .quick-right-re .quick-right-list>*.kaka{display:none;}
		}
	</style>
	<div class="quick-right">
		<div class="quick-right-re"><img src="/images/main/q__cont01.png" alt="전화 상담" loading="lazy" decoding="async">
			<div class="quick-right-list">
				<a href="tel:1877-0256"><span><span>구입문의</span><strong>1877-0256</strong></span></a>
				<a href="tel:1877-1859"><span><span>Amaranth10 문의</span><strong>1877-1859(1)</strong></span></a>
				<a href="tel:1877-1859"><span><span>Bizbox Alpha 문의</span><strong>1877-1859(2)</strong></span></a>
				<a href="tel:1877-0840"><span><span>iCUBE G20 문의</span><strong>1877-0840</strong></span></a>
			</div>
		</div>
		<a href="/purchase/inquiry.asp" class="quick-right-re"><img src="/images/icon_inq.jpg" alt="온라인 구매 상담" loading="lazy" decoding="async" style="background:#222; border-radius:50%; padding:1.4rem; box-sizing:border-box; width:6.4rem;">
			<div class="quick-right-list">
				<p class="black"><span><span>온라인 구매상담</span><strong>평일 09:00~18:00</strong></span></p>
			</div>
		</a>
		<a href="http://pf.kakao.com/_xnFVzK" target="_blank" class="quick-right-re"><img src="/images/main/q__cont03.png" alt="카카오톡 상담" loading="lazy" decoding="async">
			<div class="quick-right-list">
				<p class="kaka"><span><span>카카오톡 상담</span><strong>오픈채팅방</strong></span></p>
			</div>
		</a>
		<a href="#" onclick="javascript:window.open('http://talk.naver.com/wil4im5?ref=https%3A%2F%2Fduzon119.co.kr%2F', 'talktalk', 'scrollbars=1, resizable=1, width=486, height=745');return false;" class="quick-right-re">
            <img src="/images/main/q__cont04.png" alt="네이버 톡톡 문의" loading="lazy" decoding="async">
			<div class="quick-right-list">
				<p class="n-talk"><span><span>톡톡문의</span><strong>24시간 도입문의 상담</strong></span></p>
			</div>
		</a>
	</div>


<%' 2026-06-11 옛 모바일 퀵메뉴 코드 제거 (위 PC 옛 퀵메뉴와 동일 사유) %>
<a href="javascript:void(0);" class="goTop">go top</a>

<script>
	$(document).ready(function () {
		$("body").on("mouseenter", ".right", function() {
			$(this).parent('.q__btn').addClass("open");
		});

		//$("body").on("mouseleave", ".q__btn.open .left", function() {
		//		$(this).parent('.q__btn').removeClass("open");
		//});

		$("body").on("mouseleave", ".q__btn", function() {
			$(this).removeClass("open");
		});
	});
</script>

<div id="menuArea" class="menuLayer">
    <!-- <div class="language">
        <a href="/" class="active"><span>KOR</span></a>
        <a href="/index_en.asp"><span>ENG</span></a>
    </div> -->
    <ul id="menu" class="gnb">
        <script type="text/javascript">globalNavigationBar();</script>
    </ul>
</div>