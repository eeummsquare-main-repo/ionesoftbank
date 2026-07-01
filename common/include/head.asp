<%
' 2026-06-11 — 분/초 단위에서 일 단위로 변경. 30일 캐시 정책(web.config)이 실효를 갖도록.
'  같은 날 재방문자는 캐시된 CSS/JS 그대로 사용. CSS/JS 새로 배포한 날은 자동으로 갱신됨.
reflash_time = year(now)&"."&month(now)&"."&day(now)

' === Per-page SEO override (set GB_seoTitle / GB_seoDescription / GB_seoKeywords in the page before this include) ===
Dim GB_BASIC_seoTitle, GB_BASIC_seoDescription, GB_BASIC_seoKeywords, GB_BASIC_seoSiteName
GB_BASIC_seoSiteName   = "아이원소프트뱅크(주)"
GB_BASIC_seoTitle      = "아이원소프트뱅크(주) — 더존 ERP 공식 파트너 25년"
GB_BASIC_seoDescription= "더존 ERP 도입 컨설팅 25년 경력, 약 5,000개 기업 도입 노하우. Amaranth10·WEHAGO·iCUBE G20·OmniEsol 도입부터 사후관리까지. 1877-0256 무료 상담."
GB_BASIC_seoKeywords   = "더존,ERP,아이원소프트뱅크,Amaranth10,WEHAGO,iCUBE,Bizbox,OmniEsol,ONE AI,그룹웨어,회계,인사,물류,컨설팅"

If Not IsEmpty(GB_seoTitle)       Then : Else : GB_seoTitle = ""       : End If
If Not IsEmpty(GB_seoDescription) Then : Else : GB_seoDescription = "" : End If
If Not IsEmpty(GB_seoKeywords)    Then : Else : GB_seoKeywords = ""    : End If

If GB_seoTitle       = "" Then GB_seoTitle       = GB_BASIC_seoTitle
If GB_seoDescription = "" Then GB_seoDescription = GB_BASIC_seoDescription
If GB_seoKeywords    = "" Then GB_seoKeywords    = GB_BASIC_seoKeywords

' og:type 페이지별 분기 (상품 페이지는 product, 게시글은 article, 기본 website)
Dim GB_seoOgType
If Not IsEmpty(GB_seoOgType) Then : Else : GB_seoOgType = ""  : End If
If GB_seoOgType = "" Then GB_seoOgType = "website"

' canonical / og:url 은 실제 호스트 + 현재 URL 기준으로 동적 생성 (도메인 멀티운영 안전)
Dim GB_seoHost, GB_seoScheme, GB_seoPageUrl
GB_seoHost = Request.ServerVariables("HTTP_HOST")
If GB_seoHost = "" Then GB_seoHost = "duzon119.co.kr"
If LCase(Request.ServerVariables("HTTPS")) = "on" Then
	GB_seoScheme = "https"
Else
	GB_seoScheme = "https"  ' force https — 사이트가 https로 서비스됨
End If
GB_seoPageUrl = GB_seoScheme & "://" & GB_seoHost & Request.ServerVariables("URL")

Function seoAttr(s)
	seoAttr = Replace(Replace(Replace(s, """", "&quot;"), "<", "&lt;"), ">", "&gt;")
End Function
%>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0,maximum-scale=10,user-scalable=yes">
	<!-- <meta name="viewport" content="width=640,initial-scale=1.0,minimum-scale=0,maximum-scale=10,user-scalable=yes"> -->
	<meta name="HandheldFriendly" content="true"><!-- // * true : 모바일용(화면 크기 조정 기능) * false : Desktop에 최적화된 html 사용 -->
	<meta http-equiv="imagetoolbar" content="no">
	<meta name="format-detection" content="telephone=no, address=no, email=no, date=no" />
	<meta name="naver-site-verification" content="567190b01310e71efefd0217e776de0cdf4abb6c" />
	<meta name="google-site-verification" content="p6KsuwsxtTkDrsUf3hlUmxhnFnQefLdRsfsFkFiV48M" />

	<!-- 2026-06-30 preconnect 최소화 — LCP 직결 호스트만, 나머지는 dns-prefetch로 강등 (PSI 권고) -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link rel="preconnect" href="https://www.youtube-nocookie.com">
	<link rel="dns-prefetch" href="https://kit.fontawesome.com">
	<link rel="dns-prefetch" href="https://fastly.jsdelivr.net">
	<link rel="dns-prefetch" href="https://i.ytimg.com">
	<link rel="dns-prefetch" href="https://www.youtube.com">
	<link rel="dns-prefetch" href="https://www.googletagmanager.com">
	<link rel="dns-prefetch" href="https://www.google-analytics.com">

	<link rel="shortcut icon" type="image/x-icon" href="/images/favicon.ico" />
	<link rel="manifest" href="/site.webmanifest">
	<link rel="canonical" href="<%=GB_seoPageUrl%>">

	<!-- hreflang : 다국어 페이지 신호 (검색엔진 언어 선택 정확도 ↑) -->
	<link rel="alternate" hreflang="ko"        href="<%=GB_seoScheme%>://<%=GB_seoHost%>/">
	<link rel="alternate" hreflang="en"        href="<%=GB_seoScheme%>://<%=GB_seoHost%>/en/">
	<link rel="alternate" hreflang="ja"        href="<%=GB_seoScheme%>://<%=GB_seoHost%>/ja/">
	<link rel="alternate" hreflang="x-default" href="<%=GB_seoScheme%>://<%=GB_seoHost%>/">

	<meta name="keywords" content="<%=seoAttr(GB_seoKeywords)%>">
	<meta name="description" content="<%=seoAttr(GB_seoDescription)%>">
	<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
	<meta property="og:type" content="<%=GB_seoOgType%>">
	<meta property="og:title" content="<%=seoAttr(GB_seoTitle)%>">
	<meta property="og:site_name" content="<%=seoAttr(GB_BASIC_seoSiteName)%>" />
	<meta property="og:locale" content="ko_KR">
	<meta property="og:url" content="<%=GB_seoPageUrl%>">
	<meta property="og:image" content="<%=GB_seoScheme%>://<%=GB_seoHost%>/images/og_images.jpg">
	<meta property="og:image:width" content="1200">
	<meta property="og:image:height" content="630">
	<meta property="og:description" content="<%=seoAttr(GB_seoDescription)%>">
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:title" content="<%=seoAttr(GB_seoTitle)%>">
	<meta name="twitter:url" content="<%=GB_seoPageUrl%>">
	<meta name="twitter:image" content="<%=GB_seoScheme%>://<%=GB_seoHost%>/images/og_images.jpg">
	<meta name="twitter:description" content="<%=seoAttr(GB_seoDescription)%>">

	<title><%=GB_seoTitle%></title>

	<!-- Organization schema — 구글 지식그래프 진입용. sameAs로 공식 SNS 연결해 외부 신호 통합 -->
	<script type="application/ld+json">
	{
		"@context": "https://schema.org",
		"@type": "Organization",
		"name": "아이원소프트뱅크㈜",
		"alternateName": ["아이원소프트뱅크", "IONE Softbank", "더존119"],
		"url": "https://duzon119.co.kr/",
		"logo": "https://duzon119.co.kr/images/logo_2026_on.png",
		"image": "https://duzon119.co.kr/images/og_images.jpg",
		"description": "더존 ERP 공식 파트너 25년. Amaranth10·WEHAGO·iCUBE G20·OmniEsol 도입 컨설팅 및 사후관리.",
		"foundingDate": "2001",
		"taxID": "113-86-70956",
		"telephone": "+82-1877-0256",
		"address": {
			"@type": "PostalAddress",
			"streetAddress": "디지털로 285 에이스트윈타워 1차 405호",
			"addressLocality": "구로구",
			"addressRegion": "서울특별시",
			"addressCountry": "KR"
		},
		"contactPoint": [
			{ "@type": "ContactPoint", "telephone": "+82-1877-0256", "contactType": "sales",            "areaServed": "KR", "availableLanguage": "Korean" },
			{ "@type": "ContactPoint", "telephone": "+82-1877-1859", "contactType": "customer support", "areaServed": "KR", "availableLanguage": "Korean" },
			{ "@type": "ContactPoint", "telephone": "+82-1877-0840", "contactType": "technical support","areaServed": "KR", "availableLanguage": "Korean" }
		],
		"sameAs": [
			"https://cafe.naver.com/ionesoftbank",
			"https://blog.naver.com/zhogksgjqm",
			"https://www.instagram.com/ione130501",
			"http://pf.kakao.com/_xnFVzK",
			"https://youtube.com/@IONEsoftBK_official"
		]
	}
	</script>
	<!-- /Organization schema -->

	<!-- WebSite schema + SearchAction — 구글 사이트링크 검색박스 노출 -->
	<script type="application/ld+json">
	{
		"@context": "https://schema.org",
		"@type": "WebSite",
		"name": "아이원소프트뱅크㈜",
		"alternateName": "더존119",
		"url": "https://duzon119.co.kr/",
		"inLanguage": "ko-KR",
		"publisher": { "@type": "Organization", "name": "아이원소프트뱅크㈜" },
		"potentialAction": {
			"@type": "SearchAction",
			"target": { "@type": "EntryPoint", "urlTemplate": "https://duzon119.co.kr/search.asp?keyword={search_term_string}" },
			"query-input": "required name=search_term_string"
		}
	}
	</script>
	<!-- /WebSite schema -->

	<!-- <link rel="stylesheet" type="text/css" href="/build/font-awesome/css/font-awesome.min.css" /> -->
	<!-- 2026-06-30 FontAwesome kit defer — 메인에서 미사용, 게시판/일부 페이지에서만 사용. 렌더링 차단 해제 -->
	<script src="https://kit.fontawesome.com/3cb53a664a.js" crossorigin="anonymous" defer></script>
	<link rel="stylesheet" type="text/css" href="/common/font/SUIT-Variable.css" />
    <!-- 2026-06-30 Montserrat weight 축소 — italic 미사용, 100/200 미사용 → 실제 쓰이는 300~900만 -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

	<link rel="stylesheet" type="text/css" href="/common/css/jquery.ui.lastest.css" />

	<script type="text/javascript" src="/common/js/jquery.lastest.js" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/jquery.ui.lastest.js" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/jquery.throttledresize.js" charset="utf-8" defer></script>
	<script type="text/javascript" src="/common/js/jquery.rwdImageMaps.min.js" charset="utf-8" defer></script>

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
	<script type="text/javascript" src="/common/js/link.js?var=<%=reflash_time%>" charset="utf-8" defer></script>
	<script type="text/javascript" src="/common/js/menu.js?var=<%=reflash_time%>" charset="utf-8"></script>
	<script type="text/javascript" src="/common/js/prefixfree.min.js" defer></script>

	<!-- 2026-06-30 menu.js 중복 로드 블록 제거 (위 menu.js로 통합, 다국어 분기는 추후 필요 시 단일 분기로 재구성) -->

	<link rel="stylesheet" type="text/css" href="/common/css/slick.css" />
	<script type="text/javascript" src="/common/js/slick.js" charset="utf-8"></script>

	<link rel="stylesheet" href="/common/css/jquery.fancybox.css">
	<script type="text/javascript" src="/common/js/jquery.fancybox.js" charset="utf-8" defer></script>

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

	<!-- Google Tag Manager 2026-02-12(목) -->
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
	new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
	j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
	'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
	})(window,document,'script','dataLayer','GTM-WKPK45TW');</script>
	<!-- End Google Tag Manager 2026-02-12(목) -->

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