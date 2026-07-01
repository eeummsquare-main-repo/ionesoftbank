<!--#include virtual = _lib/common.asp-->
<%
GB_seoTitle = "비영리 Amaranth 10 — 재단·공공·학교 전용 ERP | 아이원소프트뱅크"
GB_seoDescription = "비영리 Amaranth 10 — 재단법인·공공기관·학교·종교단체 전용 ERP. 법인카드 26 시나리오 자동 모니터링, 국민권익위 운영실적보고서 자동 생성."
GB_seoKeywords = "비영리ERP,재단법인ERP,공공기관ERP,학교ERP,법인카드모니터링,예산통제"

Dim curTab
curTab = LCase(Trim(Request.QueryString("tab") & ""))
If curTab = "" Then curTab = "main"
Function tabCls(name)
	If curTab = name Then tabCls = " class=""active""" Else tabCls = ""
End Function
GB_seoOgType = "product"
%>
<!DOCTYPE html>
<html lang="ko" class="sub">
<head>
	<!--#include virtual=common/include/head.asp-->
	<!-- BreadcrumbList -->
	<script type="application/ld+json">
	{
		"@context": "https://schema.org",
		"@type": "BreadcrumbList",
		"itemListElement": [
			{ "@type": "ListItem", "position": 1, "name": "홈",                 "item": "https://duzon119.co.kr/" },
			{ "@type": "ListItem", "position": 2, "name": "제품/서비스",        "item": "https://duzon119.co.kr/product/amaranth10.asp" },
			{ "@type": "ListItem", "position": 3, "name": "Amaranth 10",        "item": "https://duzon119.co.kr/product/amaranth10/brand.asp" },
			{ "@type": "ListItem", "position": 4, "name": "비영리 통합관리",   "item": "https://duzon119.co.kr/product/nonprofit/intro.asp" }
		]
	}
	</script>

	<!-- A10 비영리 통합관리 externals (readdy.cc 디자인 적용) -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.5.0/remixicon.min.css">
	<script src="https://cdn.tailwindcss.com"></script>
	<script>
		// Site uses html{font-size:10px} so Tailwind rem-based values must be overridden to px
		tailwind.config = {
			important: '.np-readdy',
			corePlugins: { preflight: false },
			theme: {
				fontSize: {
					'xs':   ['13px', '18px'],
					'sm':   ['15px', '22px'],
					'base': ['18px', '28px'],
					'lg':   ['20px', '30px'],
					'xl':   ['22px', '32px'],
					'2xl':  ['28px', '38px'],
					'3xl':  ['34px', '42px'],
					'4xl':  ['40px', '48px'],
				},
				spacing: {
					'0':'0px','0.5':'2px','1':'4px','1.5':'6px','2':'8px',
					'2.5':'10px','3':'12px','3.5':'14px','4':'16px','5':'20px',
					'6':'24px','7':'28px','8':'32px','9':'36px','10':'40px',
					'11':'44px','12':'48px','14':'56px','16':'64px','20':'80px',
					'24':'96px','28':'112px','32':'128px','36':'144px','40':'160px',
					'48':'192px','52':'208px','56':'224px','64':'256px','72':'288px',
				},
				maxWidth: {
					'none':'none','0':'0px',
					'xs':'320px','sm':'384px','md':'448px','lg':'512px','xl':'576px',
					'2xl':'672px','3xl':'768px','4xl':'896px','5xl':'1024px',
					'6xl':'1440px','7xl':'1600px',
					'full':'100%','min':'min-content','max':'max-content','prose':'65ch',
				},
				borderRadius: {
					'none':'0px','sm':'2px',DEFAULT:'4px','md':'6px','lg':'8px',
					'xl':'12px','2xl':'16px','3xl':'24px','full':'9999px',
				},
				extend: {}
			}
		}
	</script>
	<style>
		.np-readdy, .np-readdy *, .np-readdy *::before, .np-readdy *::after { box-sizing: border-box; }
		.np-readdy { font-family: 'Noto Sans KR', sans-serif; line-height: 1.5; color: #111827; }
		.np-readdy h1, .np-readdy h2, .np-readdy h3, .np-readdy h4, .np-readdy h5, .np-readdy h6 { margin: 0; font-weight: inherit; }
		.np-readdy p, .np-readdy figure { margin: 0; }
		.np-readdy ul, .np-readdy ol { margin: 0; padding: 0; list-style: none; }
		.np-readdy a { color: inherit; text-decoration: none; }
		.np-readdy button { border: 0; background: transparent; cursor: pointer; font-family: inherit; padding: 0; color: inherit; }
		.np-readdy img { display: block; max-width: 100%; }
		.np-readdy [data-panel]:not(.is-active) { display: none; }
		.np-readdy .alt-section { opacity: 0; transform: translateY(48px); transition: opacity .7s ease-out, transform .7s ease-out; }
		.np-readdy .alt-section.alt-visible { opacity: 1; transform: translateY(0); }

		/* 비영리 핵심 특장점 : 모듈 이미지 마감 처리 (둥근 모서리 + 가벼운 테두리/그림자) */
		.contWrap.amaranth10 .img img {
			border-radius: 2.4rem;
			border: 1px solid rgba(0, 0, 0, 0.06);
			box-shadow: 0 1.2rem 3rem rgba(15, 23, 42, 0.08);
			background: #ffffff;
		}
		/* 비영리 핵심 특장점 : 다음 섹션(주요기능)과의 간격 확보 */
		.contWrap.amaranth10.np-features { padding-bottom: 10rem; }
	</style>
</head>

<body data-pgCode="0108">

<!--[s] Skip To Content -->
<a href="#contents" class="skip">&raquo; 본문 바로가기</a>
<!--[e] Skip To Content -->

<div id="wrap">
	<!--#include virtual=common/include/header.asp-->
	<!--#include virtual=common/include/subTop.asp-->

	<div class="inConts1720">
		<h1 class="hidden_for_a11y" style="position:absolute;left:-9999px;width:1px;height:1px;overflow:hidden;">Amaranth 10 비영리 통합관리 — 재단·공공·학교 전용 ERP·그룹웨어</h1>
		<!-- 중분류 메뉴 -->
		<ul class="amaranth10__list">
			<li><a href="/product/nonprofit/intro.asp"<%= tabCls("main") %>>주요기능</a></li>
			<li><a href="/product/nonprofit/intro.asp?tab=groupware"<%= tabCls("groupware") %>>그룹웨어</a></li>
			<li><a href="/product/nonprofit/intro.asp?tab=accounting"<%= tabCls("accounting") %>>회계관리</a></li>
			<li><a href="/product/nonprofit/intro.asp?tab=hr"<%= tabCls("hr") %>>인사관리</a></li>
			<li><a href="/product/nonprofit/intro.asp?tab=docs"<%= tabCls("docs") %>>문서관리</a></li>
		</ul>

<% If curTab = "main" Then %>
		<div class="np-readdy max-w-[1100px] mx-auto px-6 lg:px-12 py-10">

			<!-- #intro : 다크 인트로 박스 + 개요 이미지 + 6단계 프로세스 -->
			<section id="intro" class="mb-16">
				<div class="bg-[#0d1117] text-white rounded-xl p-8 md:p-14 mb-12 text-center">
					<h2 class="text-xl md:text-2xl font-bold leading-relaxed mb-6">
						<span class="text-[#4aa8ff]">Amaranth 10 비영리 통합관리</span>는<br class="hidden md:block">
						<span class="text-[#a78bfa]">회계 · 인사 · 예산 + 그룹웨어 + 문서유통</span>을<br class="hidden md:block">
						하나의 플랫폼에서 통합 제공합니다.
					</h2>
					<p class="text-sm md:text-base text-gray-300 leading-relaxed max-w-4xl mx-auto">
						비영리 조직의 핵심 업무인 <strong>예산 편성·집행·결산, 인사·급여·4대 보험, 전자결재·그룹웨어 협업, 웹한글기안기 문서유통</strong>을 단일 시스템에서 원스톱으로 처리합니다. 데이터가 모듈 간에 실시간으로 연동되어 중복 입력과 오류를 원천 차단합니다.
					</p>
				</div>

				<!-- 이미지 삭제 처리: 비영리 소개페이지 상단 개요 그림 제거 -->

				<div class="text-center mb-8">
					<h2 class="text-xl md:text-2xl font-bold text-gray-900">비영리 업무 사이클의 <strong>표준 프로세스</strong> 제공</h2>
					<p class="text-sm text-gray-500 mt-2">예산편성부터 구매·회계·인사·그룹웨어·문서유통까지 비영리 조직의 전 업무를 통합합니다</p>
				</div>

				<div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
					<div class="bg-white border border-gray-100 rounded-xl p-5 text-center hover:shadow-md transition-shadow relative">
						<span class="inline-flex w-10 h-10 bg-[#1a3a6b] text-white rounded-full text-sm font-bold mb-3 items-center justify-center">01</span>
						<h3 class="text-sm font-bold text-gray-900 mb-2">예산편성</h3>
						<p class="text-xs text-gray-500 leading-relaxed">연간/분기/월별 예산을 과목별·부서별로 편성하고, 집행 전 예산 잔액을 실시간으로 통제합니다.</p>
					</div>
					<div class="bg-white border border-gray-100 rounded-xl p-5 text-center hover:shadow-md transition-shadow relative">
						<span class="inline-flex w-10 h-10 bg-[#1a3a6b] text-white rounded-full text-sm font-bold mb-3 items-center justify-center">02</span>
						<h3 class="text-sm font-bold text-gray-900 mb-2">구매·품의</h3>
						<p class="text-xs text-gray-500 leading-relaxed">필요 물품·용역에 대한 구매 품의서를 작성하며, 예산 한도 내에서 자동으로 통제됩니다.</p>
					</div>
					<div class="bg-white border border-gray-100 rounded-xl p-5 text-center hover:shadow-md transition-shadow relative">
						<span class="inline-flex w-10 h-10 bg-[#1a3a6b] text-white rounded-full text-sm font-bold mb-3 items-center justify-center">03</span>
						<h3 class="text-sm font-bold text-gray-900 mb-2">회계처리</h3>
						<p class="text-xs text-gray-500 leading-relaxed">자동전표 생성, 장부관리, 결산 및 재무제표 작성, 세무신고 자동화까지 통합 회계 처리를 수행합니다.</p>
					</div>
					<div class="bg-white border border-gray-100 rounded-xl p-5 text-center hover:shadow-md transition-shadow relative">
						<span class="inline-flex w-10 h-10 bg-[#1a3a6b] text-white rounded-full text-sm font-bold mb-3 items-center justify-center">04</span>
						<h3 class="text-sm font-bold text-gray-900 mb-2">인사·급여</h3>
						<p class="text-xs text-gray-500 leading-relaxed">인사·근태·연차·급여·세무관리를 연동하여 인건비 정산과 4대 보험 신고를 자동화합니다.</p>
					</div>
					<div class="bg-white border border-gray-100 rounded-xl p-5 text-center hover:shadow-md transition-shadow relative">
						<span class="inline-flex w-10 h-10 bg-[#1a3a6b] text-white rounded-full text-sm font-bold mb-3 items-center justify-center">05</span>
						<h3 class="text-sm font-bold text-gray-900 mb-2">그룹웨어</h3>
						<p class="text-xs text-gray-500 leading-relaxed">메인포털, 일정관리, 전자결재, 메신저, 화상회의 등 조직 전체의 협업 인프라를 제공합니다.</p>
					</div>
					<div class="bg-white border border-gray-100 rounded-xl p-5 text-center hover:shadow-md transition-shadow relative">
						<span class="inline-flex w-10 h-10 bg-[#1a3a6b] text-white rounded-full text-sm font-bold mb-3 items-center justify-center">06</span>
						<h3 class="text-sm font-bold text-gray-900 mb-2">문서유통·기안</h3>
						<p class="text-xs text-gray-500 leading-relaxed">웹한글기안기로 문서를 작성·결재하고, 완료된 문서를 자동 보관·검색하며 자산 실사까지 연계합니다.</p>
					</div>
				</div>
			</section>

		</div><!-- /np-readdy : 핵심 특장점은 사이트 기본 스타일로 풀폭 렌더 -->

		<!-- 핵심 특장점 본문 : amaranth10 모듈 페이지와 동일 마크업·CSS 사용 (자동 좌우 교차) -->
		<div class="contWrap amaranth10 view-full np-features">
			<div class="account01">
				<div class="cont_txt">
					<b>회계관리</b>
					<h5>
						자동으로 수집된 <br />
						기관별 증빙 데이터의 <br />
						자동 분개
					</h5>
					<p>
						회계담당자는 수집된 자료와 분개를 <br />
						확인만 하고 바로 전표 처리를 <br />
						진행할 수 있습니다.
					</p>
				</div>
				<div class="img"><img src="/images/sub/overview01__img01.png" alt="자동전표처리 화면"></div>
			</div>
			<div class="hr02">
				<div class="cont_txt">
					<b>인사관리</b>
					<h5>
						관리업무 시간을 줄여주는 <br />
						효율적인 근태관리
					</h5>
					<p>
						근로기준법에 근거하여 사전 검증 및 <br />
						자동화 처리를 통한 <br />
						효율적인 근태관리가 가능합니다.
					</p>
				</div>
				<div class="img"><img src="/images/sub/hr01__img02.png" alt="근태관리 화면"></div>
			</div>
			<div class="docs01">
				<div class="cont_txt">
					<b>문서관리</b>
					<h5>
						다양한 서식과 <br />
						문서 관련 모든 작업을 <br />
						웹에서 편리하고 쉽게
					</h5>
					<p>
						문서 작성에 꼭 필요한 필수 기능을 중심으로 <br />
						웹과 PC에서 문서를 쉽게 작성하고 공유할 수 <br />
						있습니다.
					</p>
				</div>
				<div class="img"><img src="/images/sub/oneffice01__img01.png" alt="문서작성 화면"></div>
			</div>
			<div class="groupware03">
				<div class="cont_txt">
					<b>그룹웨어</b>
					<h5>
						나만의 똑똑한 AI비서로 <br />
						통합 일정 공유와 <br />
						중단 없는 업무 협업
					</h5>
					<p>
						개인 일정 뿐만 아니라 공유 일정까지 <br />
						한 곳에서 관리하고 실시간 일정 관리로 언제 <br />
						어디서나 일정 변동 사항 확인이 가능합니다.
					</p>
				</div>
				<div class="img"><img src="/images/sub/brand01__img03.png" alt="일정관리 화면"></div>
			</div>
		</div>

		<div class="np-readdy max-w-[1100px] mx-auto px-6 lg:px-12 py-10"><!-- 재진입 : 주요기능/CTA 영역 -->

			<!-- #functions : 5개 탭 (예산/회계/인사급여/그룹웨어/문서유통) -->
			<section id="functions" class="mb-20">
				<div class="text-center mb-8">
					<h2 class="text-xl md:text-2xl font-bold text-gray-900">Amaranth 10 비영리 통합관리의 <strong>주요 기능</strong></h2>
					<p class="text-sm text-gray-500 mt-2">예산·회계·인사·그룹웨어·문서유통 모듈을 세분화하여 관리합니다</p>
				</div>

				<div class="flex flex-wrap justify-center gap-2 mb-8" data-tabset="functions">
					<button type="button" data-tab-button data-tab="0" class="js-tab px-4 py-2 text-sm font-medium rounded-full transition-colors whitespace-nowrap cursor-pointer bg-[#1a3a6b] text-white">예산관리</button>
					<button type="button" data-tab-button data-tab="1" class="js-tab px-4 py-2 text-sm font-medium rounded-full transition-colors whitespace-nowrap cursor-pointer bg-gray-100 text-gray-700 hover:bg-gray-200">회계관리</button>
					<button type="button" data-tab-button data-tab="2" class="js-tab px-4 py-2 text-sm font-medium rounded-full transition-colors whitespace-nowrap cursor-pointer bg-gray-100 text-gray-700 hover:bg-gray-200">인사·급여관리</button>
					<button type="button" data-tab-button data-tab="3" class="js-tab px-4 py-2 text-sm font-medium rounded-full transition-colors whitespace-nowrap cursor-pointer bg-gray-100 text-gray-700 hover:bg-gray-200">그룹웨어</button>
					<button type="button" data-tab-button data-tab="4" class="js-tab px-4 py-2 text-sm font-medium rounded-full transition-colors whitespace-nowrap cursor-pointer bg-gray-100 text-gray-700 hover:bg-gray-200">문서유통(웹한글기안기)</button>
				</div>

				<!-- Panel 0: 예산관리 -->
				<div data-tabset="functions" data-panel="0" class="is-active">
					<div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">예산편성</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">부서별·과목별 예산 편성</h3>
							<p class="text-sm text-gray-600 leading-relaxed">연간/분기/월별 예산을 과목별·부서별로 세분화하여 편성합니다. 예산 이월 및 추가 편성이 가능하며, 집행 현황을 실시간으로 확인할 수 있습니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">예산통제</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">예산 잔액 자동 통제</h3>
							<p class="text-sm text-gray-600 leading-relaxed">구매 품의서 작성 시점부터 예산 잔액을 자동 체크하여 초과 지출을 원천 차단합니다. 예산과목별 잔액과 집행률을 한눈에 파악할 수 있습니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">예산집행현황</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">예산 집행 현황 리포트</h3>
							<p class="text-sm text-gray-600 leading-relaxed">예산과목별·부서별·기간별 집행 현황을 리포트로 확인합니다. 미집행 예산과 초과 집행 여부를 자동으로 경고하여 투명한 예산 운영을 지원합니다.</p>
						</div>
					</div>
				</div>

				<!-- Panel 1: 회계관리 -->
				<div data-tabset="functions" data-panel="1">
					<div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">자동전표</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">자동 전표 생성 및 승인</h3>
							<p class="text-sm text-gray-600 leading-relaxed">구매·검수·대금지급 데이터를 기반으로 전표가 자동 생성됩니다. 전표 분개와 승인 권한을 설정하여 업무 효율을 극대화합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">장부관리</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">총계정원장·일계표·월계표</h3>
							<p class="text-sm text-gray-600 leading-relaxed">일계표·월계표·총계정원장·현금출납장 등 다양한 장부를 실시간으로 조회하고 출력합니다. 계정과목별 잔액과 변동 내역을 한눈에 파악합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">결산·재무제표</h3>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">결산 및 재무제표 자동 생성</h3>
							<p class="text-sm text-gray-600 leading-relaxed">결산 자료를 자동 집계하여 재무상태표·손익계산서·현금흐름표 등 주요 재무제표를 생성합니다. 비영리 특화 결산 양식(사업보고·기부금명세 등)을 지원합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">세무신고</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">세무신고 자동화</h3>
							<p class="text-sm text-gray-600 leading-relaxed">부가가치세·원천세·종합소득세 등 주요 세무 신고 자료를 자동 생성하고 홈텍스 연계를 통해 전자신고를 지원합니다. 비영리 법인 특화 신고 양식을 제공합니다.</p>
						</div>
					</div>
				</div>

				<!-- Panel 2: 인사·급여관리 -->
				<div data-tabset="functions" data-panel="2">
					<div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">인사관리</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">인사·근태·연차 통합 관리</h3>
							<p class="text-sm text-gray-600 leading-relaxed">사원 기본 정보·발령·채용·퇴직까지 인사 이력을 체계적으로 관리합니다. 근태·연차·휴가를 자동으로 집계하고 잔여 일수를 실시간으로 확인합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">급여관리</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">급여 계산 및 대장 관리</h3>
							<p class="text-sm text-gray-600 leading-relaxed">기본급·수당·공제를 자동 계산하여 급여 대장을 생성합니다. 급여 이체 파일을 은행별 포맷으로 출력하고, 급여명세서를 전자결재 또는 이메일로 배포합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">4대보험</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">4대 보험 자동 신고</h3>
							<p class="text-sm text-gray-600 leading-relaxed">건강보험·국민연금·고용보험·산재보험 가입·상실·변동 신고를 자동 생성하여 전자신고합니다. 보험료 계산과 납부 내역을 자동으로 집계합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">세무관리</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">원천징수·연말정산</h3>
							<p class="text-sm text-gray-600 leading-relaxed">근로소득 원천징수와 연말정산을 시스템 내에서 처리합니다. 간이세액표 자동 적용, 근로자 소득공제 자료 수집, 환급/추가 납부 계산까지 완전 자동화됩니다.</p>
						</div>
					</div>
				</div>

				<!-- Panel 3: 그룹웨어 -->
				<div data-tabset="functions" data-panel="3">
					<div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">메인포털</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">맞춤형 업무 포털</h3>
							<p class="text-sm text-gray-600 leading-relaxed">부서별·직급별 맞춤 대시보드를 제공합니다. 공지사항·전자결재 대기함·일정·업무 현황을 한 화면에서 확인하며, 위젯을 자유롭게 배치할 수 있습니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">전자결재</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">유연한 결재 라인 설정</h3>
							<p class="text-sm text-gray-600 leading-relaxed">품의·품의(지출)·품의(계약) 등 비영리 조직 특화 결재 양식을 제공합니다. 결재 라인을 부서·직급·프로젝트별로 자유롭게 설정하고, 대결·위임 기능을 지원합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">일정관리</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">조직 일정 공유 및 알림</h3>
							<p class="text-sm text-gray-600 leading-relaxed">부서별·프로젝트별 일정을 공유 캘린더로 관리합니다. 회의실 예약과 연동되며, 일정 알림을 메신저·이메일·푸시로 자동 전송합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">메신저·화상회의</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">실시간 협업 커뮤니케이션</h3>
							<p class="text-sm text-gray-600 leading-relaxed">조직 내 메신저를 통해 빠른 업무 소통이 가능합니다. 화상회의·화면 공유·파일 전송을 지원하여 재택근무·재난 상황에서도 업무가 중단되지 않습니다.</p>
						</div>
					</div>
				</div>

				<!-- Panel 4: 문서유통(웹한글기안기) -->
				<div data-tabset="functions" data-panel="4">
					<div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">웹한글기안기</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">브라우저에서 한글 문서 작성</h3>
							<p class="text-sm text-gray-600 leading-relaxed">별도 프로그램 설치 없이 브라우저에서 한글 문서를 작성·편집할 수 있습니다. 기안·결재·반려·보완 요청까지 전자결재와 원스톱으로 연동됩니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">문서결재</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">문서 기안·결재·공람</h3>
							<p class="text-sm text-gray-600 leading-relaxed">작성한 문서를 전자결재 시스템에 바로 기안할 수 있습니다. 결재 완료 후 자동으로 문서 번호가 부여되고, 공람·열람 권한을 세분화하여 관리합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">문서보관·검색</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">자동 보관 및 Full-text 검색</h3>
							<p class="text-sm text-gray-600 leading-relaxed">결재 완료 문서는 자동으로 중앙 보관함에 저장됩니다. 문서 제목·내용·작성자·기간 등 다양한 조건으로 Full-text 검색이 가능하며, 권한별 열람을 통제합니다.</p>
						</div>
						<div class="bg-white border border-gray-100 rounded-xl p-6 hover:shadow-md transition-shadow">
							<span class="inline-block px-3 py-1 bg-[#1a3a6b]/10 text-[#1a3a6b] text-xs font-semibold rounded-full mb-3">연관문서·댓글</span>
							<h3 class="text-base font-bold text-gray-900 leading-relaxed mb-3">연관 문서 연결 및 협업</h3>
							<p class="text-sm text-gray-600 leading-relaxed">유사한 과거 문서나 참고 문서를 연결하여 함께 열람할 수 있습니다. 문서 내 댓글 기능으로 결재자와 실무자가 실시간으로 소통하며 문서를 다듬어갑니다.</p>
						</div>
					</div>
				</div>
			</section>

			<!-- CTA -->
			<section class="mb-10">
				<div class="bg-[#1a3a6b] text-white rounded-xl p-8 md:p-14 text-center">
					<h2 class="text-xl md:text-2xl font-bold mb-3"><span class="text-[#4aa8ff]">Amaranth 10 비영리 통합관리</span>로<br class="md:hidden"> 스마트한 조직 운영을 시작하세요.</h2>
					<p class="text-sm md:text-base text-white/80 leading-relaxed mb-6">예산·회계·인사·그룹웨어·문서유통을 하나의 플랫폼에서 통합 관리합니다.<br>담당 컨설턴트가 친절하게 안내해 드리겠습니다.</p>
					<a href="/purchase/inquiry.asp" class="inline-flex items-center justify-center px-6 py-3 bg-white text-[#1a3a6b] text-sm font-bold rounded-lg hover:bg-gray-100 transition-colors whitespace-nowrap cursor-pointer">도입문의 바로가기</a>
				</div>
			</section>

		</div>
<% End If %>
<% If curTab = "groupware" Then %>
<!--#include file="_partials/groupware.asp"-->
<% End If %>
<% If curTab = "accounting" Then %>
<!--#include file="_partials/accounting.asp"-->
<% End If %>
<% If curTab = "hr" Then %>
<!--#include file="_partials/hr.asp"-->
<% End If %>
<% If curTab = "docs" Then %>
<!--#include file="_partials/docs.asp"-->
<% End If %>
	</div>
	<!--#include virtual=common/include/footer.asp-->
</div>

<script>
(function(){
	function activateTab(tabset, idx){
		document.querySelectorAll('[data-tabset="'+tabset+'"][data-tab-button]').forEach(function(btn){
			var on = (String(btn.dataset.tab) === String(idx));
			btn.classList.toggle('bg-[#1a3a6b]', on);
			btn.classList.toggle('text-white', on);
			btn.classList.toggle('bg-gray-100', !on);
			btn.classList.toggle('text-gray-700', !on);
			btn.classList.toggle('hover:bg-gray-200', !on);
		});
		document.querySelectorAll('[data-tabset="'+tabset+'"][data-panel]').forEach(function(p){
			p.classList.toggle('is-active', String(p.dataset.panel) === String(idx));
		});
	}
	document.querySelectorAll('[data-tab-button]').forEach(function(btn){
		btn.addEventListener('click', function(){
			activateTab(btn.dataset.tabset || btn.closest('[data-tabset]').dataset.tabset, btn.dataset.tab);
		});
	});
	if ('IntersectionObserver' in window) {
		var io = new IntersectionObserver(function(entries){
			entries.forEach(function(en){
				if (en.isIntersecting){ en.target.classList.add('alt-visible'); io.unobserve(en.target); }
			});
		}, { threshold: 0.12 });
		document.querySelectorAll('.alt-section').forEach(function(el){ io.observe(el); });
	} else {
		document.querySelectorAll('.alt-section').forEach(function(el){ el.classList.add('alt-visible'); });
	}
})();
</script>
</body>
</html>
