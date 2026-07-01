<%
reflash_time = year(now)&"."&month(now)&"."&day(now)&"-"&hour(now)&":"&minute(now)&":"&second(now)
%>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0,maximum-scale=10,user-scalable=yes">
	<!-- <meta name="viewport" content="width=640,initial-scale=1.0,minimum-scale=0,maximum-scale=10,user-scalable=yes"> -->
	<meta name="HandheldFriendly" content="true"><!-- // * true : 모바일용(화면 크기 조정 기능) * false : Desktop에 최적화된 html 사용 -->
	<meta http-equiv="imagetoolbar" content="no">
	<meta name="format-detection" content="telephone=no, address=no, email=no, date=no" />

	<link rel="shortcut icon" type="image/x-icon" href="/images/favicon.ico" />
	<link rel="canonical" href="https://www.amaranth10.kr">
	<meta name="title" content="아이원소프트뱅크(주)">
	<meta name="keywords" content="아이원소프트뱅크(주)">
	<meta name="description" content="아이원소프트뱅크(주)">
	<meta property="og:type" content="website">
	<meta property="og:title" content="아이원소프트뱅크(주)">
	<meta property="og:site_name" content="아이원소프트뱅크(주)" />
	<meta property="og:url" content="https://www.amaranth10.kr">
	<meta property="og:image" content="/images/og_images.jpg">
	<meta property="og:description" content="아이원소프트뱅크(주)">
	<meta name="twitter:card" content="summary">
	<meta name="twitter:title" content="아이원소프트뱅크(주)">
	<meta name="twitter:url" content="https://www.amaranth10.kr">
	<meta name="twitter:image" content="/images/og_images.jpg">
	<meta name="twitter:description" content="아이원소프트뱅크(주)">

	<title>아이원소프트뱅크(주)</title>

	<!-- <link rel="stylesheet" type="text/css" href="/build/font-awesome/css/font-awesome.min.css" /> -->
	<script src="https://kit.fontawesome.com/3cb53a664a.js" crossorigin="anonymous"></script>
	<link rel="stylesheet" type="text/css" href="/common/font/SUIT-Variable.css" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">

	<link rel="stylesheet" type="text/css" href="/common/css/jquery.ui.lastest.css" />

	<script type="text/javascript" src="/common/js/jquery.lastest.js" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/jquery.ui.lastest.js" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/jquery.throttledresize.js" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/jquery.rwdImageMaps.min.js" charset="utf-8"></script>

	<script type="text/javascript">
		var langCode = "<%=langCode%>";
		var langmode = "<%=langmode%>";

		$(function(){
			$("#header .language>a").eq(langmode).addClass("active")
		});
	</script>

	<link rel="stylesheet" type="text/css" href="/common/css/layout.css?var=<%=reflash_time%>" />
	<link rel="stylesheet" type="text/css" href="/common/css/contents.css?var=<%=reflash_time%>" />
	<link rel="stylesheet" type="text/css" href="/common/css/front.css?var=<%=reflash_time%>" />

	<script type="text/javascript" src="/common/js/publisher.js?var=<%=reflash_time%>" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/link_new.js?var=<%=reflash_time%>" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/menu_new.js?var=<%=reflash_time%>" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/prefixfree.min.js"></script>

	<!--
	<% IF InStr(LCase(thisUrl)&"/", "/en/")>0 Then %>
	<script type="text/javascript" src="/common/js/menu_en.js?var=<%=reflash_time%>" charset="utf-8"></script>
	<% ElseIF InStr(LCase(thisUrl)&"/", "/ja/")>0 Then %>
	<script type="text/javascript" src="/common/js/menu_ja.js?var=<%=reflash_time%>" charset="utf-8"></script>
	<% Else %>
	<script type="text/javascript" src="/common/js/menu.js?var=<%=reflash_time%>" charset="utf-8"></script>
	<% End IF %>
	-->

	<link rel="stylesheet" type="text/css" href="/common/css/slick.css" />
	<script type="text/javascript" src="/common/js/slick.js" charset="utf-8"></script>

	<link rel="stylesheet" href="/common/css/jquery.fancybox.css">
	<script type="text/javascript" src="/common/js/jquery.fancybox.js" charset="utf-8"></script>

	<link rel="stylesheet" href="/common/css/aos.css">
	<script type="text/javascript" src="/common/js/aos.js" charset="utf-8"></script>

	<link rel="stylesheet" href="/build/ripple-click/ripple.min.css">
	<script type="text/javascript" src="/build/ripple-click/ripple.min.js" charset="utf-8"></script>

    <link rel="stylesheet" href="/common/css/fullpage.css">
	<script type="text/javascript" src="/common/js/fullpage.js" charset="utf-8"></script>

    <link rel="stylesheet" href="https://fastly.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
    <script src="https://fastly.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

  	<!-- 개발 Library -->
	<script type="text/javascript">var langCode = "<%=langCode%>";</script>
	<script type="text/javascript" src="/_lib/js/plug-in/jquery.simplemodal/jquery.simplemodal.js"></script>
	<link href="/_lib/css/editorContent.css" rel="stylesheet" type="text/css" />
	<script language="javascript" type="text/javascript" src="/_lib/functions.js"></script>
	<script language="javascript" type="text/javascript" src="/_lib/boardcontrol.js"></script>
	<script type="text/javascript" src="/_lib/js/plug-in/jquery.cookie/jquery.cookie.js"></script>
	<link rel="stylesheet" href="/_lib/ckeditor5/content-styles.css" type="text/css">
	<!-- 개발 Library -->

	<!-- 2024-07-08 Google tag (gtag.js) -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=G-SLFWLP9QKE"></script>
	<script>
	  window.dataLayer = window.dataLayer || [];
	  function gtag(){dataLayer.push(arguments);}
	  gtag('js', new Date());

	  gtag('config', 'G-SLFWLP9QKE');
	</script>

	 <!-- Talk Talk Banner Script start 2024-12-31 -->
	  <!-- <script type="text/javascript" src="https://partner.talk.naver.com/banners/script"></script>
	  <div class="talk_banner_div" data-id="155614"></div>
	  <style>
        .talk_banner_div{position: fixed; right:13px; bottom:47px; z-index:7;}
        .talk_banner_div .talk_banner_link{width:6.4rem; height:6.4rem; background:url("/images/main/q__cont04.png") no-repeat center; background-size:contain;}
        .talk_banner_div .talk_banner_link .talk_banner_preview{display:none !important;}
        @media only screen and (max-width: 840px){
            .talk_banner_div{bottom:69px}
            .talk_banner_div .talk_banner_link{width:50px; height:50px;}
        }
      </style> -->
	  <!-- Talk Talk Banner Script end 2024-12-31 -->