<!-- #include virtual = _lib/common.asp -->
<!--#include virtual = _lib/dbcon.asp-->
<%
GB_seoTitle = "더존 ERP 커스터마이징 전문 | 더존 커스텀 개발 25년 공식 파트너 — 아이원소프트뱅크"
GB_seoDescription = "더존 ERP 커스터마이징 전문 업체 | Amaranth10·iCUBE·Bizbox 더존 커스텀 개발 및 맞춤 구축. 25년 경력 약 5,000개 기업 도입 노하우. 더존 커스터마이징 가능 업체 — 1877-0256 무료 상담."
GB_seoKeywords = "더존커스터마이징,더존ERP커스터마이징,더존커스텀,더존ERP커스텀,더존커스터마이징업체,더존,더존ERP,아이원소프트뱅크,Amaranth10,WEHAGO,위하고,iCUBE,Bizbox,OmniEsol,ONE AI,그룹웨어,회계ERP,인사ERP,물류ERP,ERP컨설팅"

Dim PopStr,GBslideCnt
Dim MainColRec,NewColRec,PutColRec
Dim NoticeRec,FreeRec

' 2026-06-30 GET_PopInfo_Mobile 결과(PopStr) Application 캐시 — 매 요청 DB 호출 제거, TTFB 개선
Dim popTs_, popVal_
popTs_  = Application("idx_popmob_0_1_ts")
popVal_ = Application("idx_popmob_0_1_data")
IF IsDate(popTs_) And DateDiff("s", CDate(popTs_), Now()) < 300 Then
	PopStr = popVal_
Else
	CALL GET_PopInfo_Mobile(0,1)
	Application.Lock
	Application("idx_popmob_0_1_ts")   = Now()
	Application("idx_popmob_0_1_data") = PopStr
	Application.Unlock
End IF

' --- Application 캐시 헬퍼: 메인 화면 데이터(배너/게시판/파트너)를 5분 캐싱하여 매 요청 SQL 호출(원격 DB 왕복) 제거 ---
Const IDX_CACHE_TTL_SEC = 300

Function CachedGetRows(cacheKey, sql)
	Dim tsVal, dataVal, rs2, rows
	tsVal   = Application("idx_"&cacheKey&"_ts")
	dataVal = Application("idx_"&cacheKey&"_data")
	IF IsArray(dataVal) And IsDate(tsVal) Then
		IF DateDiff("s", CDate(tsVal), Now()) < IDX_CACHE_TTL_SEC Then
			CachedGetRows = dataVal
			Exit Function
		End IF
	End IF

	Set rs2 = DBcon.Execute(sql)
	IF Not(rs2.Bof Or rs2.Eof) Then
		rows = rs2.GetRows()
		CachedGetRows = rows
		Application.Lock
		Application("idx_"&cacheKey&"_ts")   = Now()
		Application("idx_"&cacheKey&"_data") = rows
		Application.Unlock
	End IF
	rs2.Close
	Set rs2 = Nothing
End Function

Sql="Select Top 10 filenames, filenames1, linkurl, linkurl1, title, note1, thumbContent, linkurlNewWin, linkurlNewWin1 FROM mainbanneradmin WHERE langmode="&langmode&" AND bansort=0 AND isDisplay=1 AND (sDate='' OR (sDate<='"&NowDate&"' AND eDate>='"&NowDate&"')) ORDER BY listnum ASC, idx ASC"
banRec1 = CachedGetRows("ban1_"&langmode, Sql)

Sql="Select Top 10 filenames, filenames1, linkurl, linkurl1, title, note1, thumbContent, linkurlNewWin, linkurlNewWin1, linkurlBtnNm, linkurlBtnNm1, vodlinkurl FROM mainbanneradmin WHERE langmode="&langmode&" AND bansort=1 AND isDisplay=1 AND vodlinkurl<>'' AND (sDate='' OR (sDate<='"&NowDate&"' AND eDate>='"&NowDate&"')) ORDER BY listnum ASC, idx ASC"
banRec2 = CachedGetRows("ban2_"&langmode, Sql)

'=============================게시판 TOP Get============================'
Sql="Select Top 10 idx, title, viewdate, boardidx, writer, publicYN, pwd, boardsort, imgnames, content, vodUrl, thumbContent, filenames From View_BBslistWithFileData Where isDisplay=1 AND boardidx=30 AND ReLevel='A' Order By Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC"
BoardRec1 = CachedGetRows("board30", Sql)

Sql="Select Top 10 idx, title, viewdate, boardidx, writer, publicYN, pwd, boardsort, imgnames, content, vodUrl, thumbContent, filenames From View_BBslistWithFileData Where isDisplay=1 AND boardidx=7 AND ReLevel='A' Order By Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC"
BoardRec2 = CachedGetRows("board7", Sql)

Sql="Select Top 10 idx, title, viewdate, boardidx, writer, publicYN, pwd, boardsort, imgnames, content, vodUrl, thumbContent, filenames From View_BBslistWithFileData Where isDisplay=1 AND boardidx=17 AND ReLevel='A' Order By Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC"
BoardRec3 = CachedGetRows("board17", Sql)

Sql="Select Top 10 idx, title, viewdate, boardidx, writer, publicYN, pwd, boardsort, imgnames, content, vodUrl, thumbContent, filenames From View_BBslistWithFileData Where isDisplay=1 AND boardidx=27 AND ReLevel='A' Order By Topyn DESC, sortDate DESC,Ref desc, ReLevel ASC, Idx DESC"
BoardRec4 = CachedGetRows("board27", Sql)
'======================================================================='

Sql = "SELECT idx, title, ARRIMGNM, linkurl FROM partner WHERE isDisplay=1 ORDER BY listNum ASC, Idx ASC"
partnerRec = CachedGetRows("partner", Sql)

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_RibBanner(Rec)
	IF IsArray(Rec) Then
		Dim i, j

		Response.Write "<div id=""ribbon-banner"" class=""disNone"">"&Vbcrlf
		Response.Write "	<div class=""ribbon-roll"">"&Vbcrlf
		For i=0 To Ubound(Rec,2)
			filenames = changeBlank(Rec(0,i))
			filenames1 = changeBlank(Rec(1,i))
			linkurl = changeBlank(Rec(2,i))
			linkurl1 = changeBlank(Rec(3,i))
			title = changeBlank(Rec(4,i))
			note1 = changeBlank(Rec(5,i))
			thumbContent = ReplaceNoHtml(changeBlank(Rec(6,i)))
			linkurlNewWin = changeBlank(Rec(7,i))
			linkurlNewWin1 = changeBlank(Rec(8,i))

			IF filenames1="" Then filenames1=filenames

			altText = Replace(ReplaceNoHtml(title), """", "&quot;")
			' 2026-06-30 첫 리본 배너 이미지에 fetchpriority="high" — LCP 후보 가속
			Dim imgPriority
			IF i = 0 Then
				imgPriority = " fetchpriority=""high"" loading=""eager"""
			Else
				imgPriority = " loading=""lazy"""
			End IF
			IF linkurl<>"" Then
				Response.Write "		<div class=""slider""><a href="""&linkurl&""" target="""&iif_compare(linkurlNewWin, 1, "_blank")&"""><img" & imgPriority & " src=""/upload/mainbanner/"&filenames&""" alt="""&altText&"""></a></div>"&Vbcrlf
			Else
				Response.Write "		<div class=""slider""><img" & imgPriority & " src=""/upload/mainbanner/"&filenames&""" alt="""&altText&"""></div>"&Vbcrlf
			End IF
		Next
		Response.Write "	</div>"&Vbcrlf
		Response.Write "	<div class=""ribbon-close"">"&Vbcrlf
		Response.Write "		<p class=""check-new"" id=""ribbonToDayClose"">"&Vbcrlf
		Response.Write "			<input type=""checkbox"" id=""ribbonClose"" name=""ribbonClose"" />"&Vbcrlf
		Response.Write "			<label for=""ribbonClose""><span class=""graphic""></span>오늘 하루 동안 열지 않기</label>"&Vbcrlf
		Response.Write "		</p>"&Vbcrlf
		Response.Write "	</div>"&Vbcrlf
		Response.Write "</div>"&Vbcrlf
	End IF
End Function

Function PT_BBsTopType1(Rec, actPage, fileDownLink)
	IF IsArray(Rec) Then
		Dim i, j
		Dim idx, title, viewdate, boardidx, writer, publicYN, pwd, boardsort, imgnames, content, vodUrl, thumbContent, filenames
		For i=0 To Ubound(Rec,2)
			idx = ChangeBlank(Rec(0,i))
			title = ChangeBlank(Rec(1,i))
			viewdate = ChangeBlank(Rec(2,i))
			boardidx = ChangeBlank(Rec(3,i))
			writer = ChangeBlank(Rec(4,i))
			publicYN = ChangeBlank(Rec(5,i))
			pwd = ChangeBlank(Rec(6,i))
			boardsort = ChangeBlank(Rec(7,i))
			imgnames = ChangeBlank(Rec(8,i))
			content = ChangeBlank(Rec(9,i))
			vodUrl = ChangeBlank(Rec(10,i))
			thumbContent = ChangeBlank(Rec(11,i))
			filenames = ChangeBlank(Rec(12,i))

			IF thumbContent = "" Then thumbContent = Content

			altText = Replace(ReplaceNoHtml(title), """", "&quot;")
			imgTag="<img class=""noIMG"" alt="""&altText&""" loading=""lazy"" decoding=""async"">"
			IF imgnames<>"" Then
				imgTag = "<img src=""/upload/board/"&(imgnames)&""" alt="""&altText&""" loading=""lazy"" decoding=""async"" />"
			ElseIF vodUrl<>"" Then
				imgTag = "<img src="""&getYoutubeIMGUrlOnly(vodUrl)&""" alt="""&altText&""" loading=""lazy"" decoding=""async"" />"
			Else
				editorimgName = getImageTags(1, content)
				IF editorimgName<>"" Then
					imgTag = "<img src="""&editorimgName&""" alt="""&altText&""" loading=""lazy"" decoding=""async"" />"
				End IF
			End IF

			LinkTag = ""
			IF fileDownLink="Y" Then
				IF filenames<>"" Then
					LinkTag = "href=""/_lib/download.asp?downfile="&filenames&"&path=board"""
				End IF
			Else
				LinkTag = "href='"&actPage&"?mode=view&serboardsort="&boardsort&"&idx="&idx&"'"
			End IF

			Response.Write "<div class=""swiper-slide"">"&Vbcrlf
			Response.Write "	<a "&LinkTag&" class=""box"">"&Vbcrlf
			Response.Write "		<div class=""slide__img"">"&imgTag&"</div>"&Vbcrlf
			Response.Write "		<div class=""slide__txt"">"&Vbcrlf
			Response.Write "			<b>NEW</b>"&Vbcrlf
			Response.Write "			<p>"&ReplaceNoHtml(title)&"</p>"&Vbcrlf
			Response.Write "			<strong>"&viewdate&"</strong>"&Vbcrlf
			Response.Write "		</div>"&Vbcrlf
			Response.Write "	</a>"&Vbcrlf
			Response.Write "</div>"&Vbcrlf
		Next
	End IF
End Function

Function PT_partner()
	IF IsArray(partnerRec) Then
		Dim i, j
		Dim idx, title, ARRIMGNM, linkurl
		For i=0 To Ubound(partnerRec,2)
			idx = ChangeBlank(partnerRec(0,i))
			title = ChangeBlank(partnerRec(1,i))
			ARRIMGNM = ChangeBlank(partnerRec(2,i))
			linkurl = ChangeBlank(partnerRec(3,i))

			imgFileNm = Get_ArrFileFIrstName(ARRIMGNM,"^|^")

			linkTag = ""
			IF linkurl<>"" Then linkTag = "href='"&LinkUrl&"'"

			IF imgFileNm<>"" THen
				Response.Write "<div class=""swiper-slide"">"&Vbcrlf
				Response.Write "	<div class=""sec7__img"">"&Vbcrlf
				Response.Write "		<a "&linkTag&" target=""_blank""><img src=""/upload/partner/"&imgFileNm&""" alt="""&Replace(ReplaceNoHtml(title), """", "&quot;")&""" loading=""lazy"" decoding=""async""></a>"&Vbcrlf
				Response.Write "	</div>"&Vbcrlf
				Response.Write "</div>"&Vbcrlf
			End IF
		Next
	End IF
End Function

Function PT_vodBanner(Rec)
	IF IsArray(Rec) Then
		Dim i, j

		For i=0 To Ubound(Rec,2)
			filenames = changeBlank(Rec(0,i))
			filenames1 = changeBlank(Rec(1,i))
			linkurl = changeBlank(Rec(2,i))
			linkurl1 = changeBlank(Rec(3,i))
			title = changeBlank(Rec(4,i))
			note1 = changeBlank(Rec(5,i))
			thumbContent = changeBlank(Rec(6,i))
			linkurlNewWin = changeBlank(Rec(7,i))
			linkurlNewWin1 = changeBlank(Rec(8,i))
			linkurlBtnNm = changeBlank(Rec(9,i))
			linkurlBtnNm1 = changeBlank(Rec(10,i))
			vodlinkurl = changeBlank(Rec(11,i))

			youtubeID = getYoutubeID(vodlinkurl)
			IF linkUrlBtnNm="" Then linkUrlBtnNm = "바로가기"
			IF linkUrlBtnNm1="" Then linkUrlBtnNm1 = "바로가기"

			' 2026-06-30 첫 슬라이드 iframe만 fetchpriority="high" + loading="eager" — LCP 개선
			Dim iframePriority
			IF i = 0 Then
				iframePriority = " fetchpriority=""high"" loading=""eager"""
			Else
				iframePriority = " loading=""lazy"""
			End IF
			Response.Write "<div class=""swiper-slide"">"&Vbcrlf
			Response.Write "	<div class=""video_box"">"&Vbcrlf
			Response.Write "		<iframe class=""overlay-video""" & iframePriority & " src=""https://www.youtube-nocookie.com/embed/"&youtubeID&"?&amp;autoplay=1&amp;mute=1&amp;playlist="&youtubeID&"&amp;loop=1"" title=""YouTube video player"" frameborder=""0"" allow=""accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"" referrerpolicy=""strict-origin-when-cross-origin"" allowfullscreen></iframe>"&Vbcrlf
			Response.Write "	</div>"&Vbcrlf
			Response.Write "	<div class=""vTxtArea"">"&Vbcrlf
			Response.Write "		<div class=""vTxt"" ata-aos=""fade-up"" data-aos=""fade-up"" data-aos-delay=""150"">"&Vbcrlf
			Response.Write "			"&thumbContent&""&Vbcrlf
			Response.Write "			<p class=""ii btn"" >"&Vbcrlf
			IF linkurl<>"" Then
				Response.Write "				<a href="""&LinkUrl&""" target="""&iif_compare(linkurlNewWin, 1, "_blank")&""" class=""main__btn"">"&linkUrlBtnNm&" <img src=""/images/main/main_arr.png"" alt=""바로가기"" loading=""lazy"" decoding=""async""></a>"&Vbcrlf
			End IF
			IF linkurl1<>"" Then
				Response.Write "				<a href="""&LinkUrl1&""" target="""&iif_compare(linkurlNewWin1, 1, "_blank")&""" class=""main__btn"">"&linkUrlBtnNm1&" <img src=""/images/main/main_arr.png"" alt=""바로가기"" loading=""lazy"" decoding=""async""></a>"&Vbcrlf
			End IF
			Response.Write "			</p>"&Vbcrlf
			Response.Write "		</div>"&Vbcrlf
			Response.Write "	</div>"&Vbcrlf
			Response.Write "</div>"&Vbcrlf
		Next
	End IF
End Function
%>
<!DOCTYPE html>
<html lang="ko" class="main">

    <head>
        <!-- #include virtual=common/include/head.asp -->
    </head>

    <body data-pgCode="0000">

        <h1 class="hidden_for_a11y" style="position:absolute;left:-9999px;width:1px;height:1px;overflow:hidden;">더존 ERP 커스터마이징 전문 | 더존 커스텀 개발 — 아이원소프트뱅크㈜ 더존 공식 파트너 25년 · Amaranth 10·WEHAGO·iCUBE·Bizbox 도입 컨설팅</h1>

        <section id="wrap">
			<style>
				#ribbon-banner{width:100%; font-size:0; line-height:0; overflow:hidden; position: relative; z-index:8;}
				#ribbon-banner.disNone{display:none !important;}
				#ribbon-banner .ribbon-roll{}
				#ribbon-banner .ribbon-roll .slider{width:100%;}
				#ribbon-banner .ribbon-roll .slider img{height:12rem; object-fit: cover; object-position: center center;}

				#ribbon-banner .ribbon-close{width:100%; max-width:136rem; margin:0 auto; padding:0 3rem; text-align: right; position: relative; z-index:7;}
				#ribbon-banner .ribbon-close .check-new{position: relative; margin-top:-22px; white-space: nowrap;}
				#ribbon-banner .ribbon-close .check-new input[type=checkbox]+label{font-size:12px; color: #fff;}

				#ribbon-banner .ribbon-close .check-new input[type=checkbox]+label>.graphic,
				#ribbon-banner .ribbon-close .check-new input[type=checkbox]+label>.graphic:before{width:1.4rem; height: 1.4rem;}

				#ribbon-banner .slick-dots{width:100%; padding:0; text-align: center; position: absolute; left:0; bottom:0.7rem; z-index:7;}
				#ribbon-banner .slick-dots>li{margin:0 0.5rem; display:inline-block; vertical-align: top;}
				#ribbon-banner .slick-dots>li+li{}
				#ribbon-banner .slick-dots>li button{width:1rem; height:1rem; padding:0; background-color:#fff; border:none; font-size:0; line-height:0; opacity: 0.7; position: relative; cursor: pointer; border-radius:999px; overflow:hidden; transition: all .3s ease-out;}
				#ribbon-banner .slick-dots>li.slick-active button{width:20px; opacity: 1;}

				#ribbon-banner .ribbon-roll{opacity: 0; visibility: hidden; transition: opacity 1s ease;}
				#ribbon-banner .ribbon-roll.open,
				#ribbon-banner .ribbon-roll.slick-initialized{visibility: visible; opacity: 1;}

				#ribbon-banner:not(.disNone) + #header{position: absolute; top:12rem;}
				#ribbon-banner + #header.fixed{position: fixed; top:0;}


				@media only screen and (max-width : 1024px){
					#ribbon-banner{display:none !important;}
					#header{position: fixed !important; top:0 !important;}
				}
				@media only screen and (max-width : 840px){
				}
			</style>
			<%=PT_RibBanner(banRec1)%>

			<!-- #include virtual=common/include/header.asp -->

            <div class="quick-left">
                <p class="q_tit">DOUZONE</p>
                <ul>
                    <li>
                        <a href="javascript:link0000();">
                            <img src="/images/q_left_icon_01.png" alt="무료방문요청" loading="lazy" decoding="async">
                            <span>무료방문요청</span>
                        </a>
                    </li>
                    <li>
                        <a href="/purchase/inquiry.asp">
                            <img src="/images/q_left_icon_02.png" alt="Amaranth10 체험신청" loading="lazy" decoding="async">
                            <span>
                                <em>Amaranth10</em>
                                체험신청하기
                            </span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:openCardnewsModal();">
                            <svg class="cardnews-ico" aria-hidden="true" viewBox="0 0 32 32" width="36" height="36" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="4" y="6" width="24" height="20" rx="2"></rect>
                                <line x1="9" y1="12" x2="23" y2="12"></line>
                                <line x1="9" y1="17" x2="23" y2="17"></line>
                                <line x1="9" y1="22" x2="18" y2="22"></line>
                            </svg>
                            <span>카드뉴스<br>신청하기</span>
                        </a>
                    </li>
                </ul>
                <button type="button" class="fold_btn"><span>←</span></button>
            </div>

            <!-- ===== 카드뉴스 신청하기 모달 ===== -->
            <div id="cardnewsLayer" class="cn-layer" style="display:none;" role="dialog" aria-modal="true" aria-labelledby="cn-title">
                <div class="cn-dim"></div>
                <div class="cn-box">
                    <div class="cn-head">
                        <h3 id="cn-title">카드뉴스 신청하기</h3>
                        <button type="button" class="cn-close" aria-label="닫기">×</button>
                    </div>
                    <form id="cardnewsForm" class="cn-body" onsubmit="return false;">
                        <div class="cn-field">
                            <label for="cn-company">회사명 <em>*</em></label>
                            <input type="text" id="cn-company" name="company" placeholder="회사명을 입력하세요" maxlength="100" />
                        </div>
                        <div class="cn-field">
                            <label for="cn-writer">담당자명 <em>*</em></label>
                            <input type="text" id="cn-writer" name="writer" placeholder="담당자명을 입력하세요" maxlength="50" />
                        </div>
                        <div class="cn-field">
                            <label for="cn-phone">연락처 <em>*</em></label>
                            <input type="text" id="cn-phone" name="phone" placeholder="연락처를 입력하세요" maxlength="30" />
                        </div>
                        <div class="cn-field">
                            <label for="cn-email">이메일</label>
                            <input type="email" id="cn-email" name="email" placeholder="이메일을 입력하세요" maxlength="100" />
                        </div>
                        <div class="cn-field">
                            <label for="cn-interest">관심 주제</label>
                            <input type="text" id="cn-interest" name="interest" placeholder="예: ERP, PMS, ISMS-P 등" maxlength="200" />
                        </div>
                        <div class="cn-field">
                            <label for="cn-note1">문의사항</label>
                            <textarea id="cn-note1" name="note1" rows="4" maxlength="500" placeholder="문의사항을 입력하세요 (최대 500자)"></textarea>
                        </div>
                        <div class="cn-agree">
                            <strong>동의 항목 <em>*</em></strong>
                            <label class="cn-chk">
                                <input type="checkbox" id="cn-agree1" name="agree1" value="1">
                                <span><b>[필수]</b> 개인정보 수집 및 이용에 동의합니다.</span>
                            </label>
                            <p class="cn-desc">수집 항목: 회사명, 담당자명, 연락처, 이메일 / 목적: 카드뉴스 발송 및 서비스 안내 / 보유기간: 동의 철회 시까지</p>
                            <label class="cn-chk">
                                <input type="checkbox" id="cn-agree2" name="agree2" value="1">
                                <span><b>[필수]</b> 아이원소프트뱅크㈜의 카드뉴스 및 서비스 정보 수신에 동의합니다.</span>
                            </label>
                            <p class="cn-desc">ERP, PMS, ISMS-P 등 관련 최신 정보를 이메일로 수신합니다.</p>
                            <p class="cn-note" id="cn-noteMsg">신청을 위해 위 동의 항목에 모두 체크해 주세요.</p>
                        </div>
                        <button type="button" class="cn-submit" id="cn-submitBtn" disabled>신청하기</button>
                    </form>
                </div>
            </div>

            <style>
                /* card-news quick button (3rd) — img와 동일한 흐름으로 배치 */
                .quick-left ul li .cardnews-ico{display:block; width:36px; height:36px; color:#0863de;}
                /* 카드뉴스 텍스트 강제 줄바꿈 (BR 안 먹히는 환경 대비) */
                .quick-left ul li a > span{white-space:normal; word-break:keep-all;}

                /* card-news modal */
                #cardnewsLayer{position:fixed; inset:0; z-index:9999;}
                #cardnewsLayer .cn-dim{position:absolute; inset:0; background:rgba(0,0,0,0.55);}
                #cardnewsLayer .cn-box{position:relative; width:42rem; max-width:calc(100vw - 3rem); max-height:calc(100vh - 4rem); margin:2rem auto; top:50%; transform:translateY(-50%); background:#fff; border-radius:1.2rem; box-shadow:0 2rem 5rem rgba(0,0,0,0.3); display:flex; flex-direction:column; overflow:hidden;}
                #cardnewsLayer .cn-head{display:flex; align-items:center; justify-content:space-between; padding:1.8rem 2rem; border-bottom:1px solid #eee;}
                #cardnewsLayer .cn-head h3{margin:0; font-size:1.8rem; font-weight:700; color:#111;}
                #cardnewsLayer .cn-close{background:none; border:none; font-size:2.4rem; line-height:1; color:#888; cursor:pointer; padding:0 .4rem;}
                #cardnewsLayer .cn-body{padding:1.6rem 2rem 2rem; overflow-y:auto; flex:1 1 auto;}
                #cardnewsLayer .cn-field{margin-bottom:1.2rem;}
                #cardnewsLayer .cn-field label{display:block; margin-bottom:.5rem; font-size:1.4rem; font-weight:600; color:#333;}
                #cardnewsLayer .cn-field label em{color:#e23; font-style:normal; margin-left:.2rem;}
                #cardnewsLayer .cn-field input[type=text],
                #cardnewsLayer .cn-field input[type=email],
                #cardnewsLayer .cn-field textarea{width:100%; box-sizing:border-box; padding:.9rem 1rem; font-size:1.4rem; border:1px solid #d6d6d6; border-radius:.6rem; outline:none; background:#fff; color:#222; font-family:inherit;}
                #cardnewsLayer .cn-field input:focus,
                #cardnewsLayer .cn-field textarea:focus{border-color:#0863de;}
                #cardnewsLayer .cn-field textarea{resize:vertical; min-height:8rem;}
                #cardnewsLayer .cn-agree{margin:1.4rem 0 1.2rem; padding:1.2rem 1.4rem; background:#f7f8fb; border-radius:.8rem;}
                #cardnewsLayer .cn-agree>strong{display:block; margin-bottom:.8rem; font-size:1.4rem; color:#222;}
                #cardnewsLayer .cn-agree>strong em{color:#e23; font-style:normal;}
                /* 커스텀 체크박스: 네이티브 input 시각적으로 숨기고 span::before로 직접 그림 */
                #cardnewsLayer .cn-chk{display:block !important; position:relative !important; padding:.2rem 0 .2rem 2.6rem !important; margin-top:.6rem !important; font-size:1.3rem !important; color:#333 !important; cursor:pointer !important; min-height:2rem !important; line-height:1.45 !important;}
                #cardnewsLayer .cn-chk input[type="checkbox"]{position:absolute !important; left:.1rem !important; top:.3rem !important; width:1.8rem !important; height:1.8rem !important; opacity:0 !important; margin:0 !important; padding:0 !important; border:0 !important; z-index:1 !important; cursor:pointer !important;}
                #cardnewsLayer .cn-chk > span{display:inline-block !important; vertical-align:top !important;}
                #cardnewsLayer .cn-chk > span::before{content:'' !important; position:absolute !important; left:0 !important; top:.3rem !important; width:1.8rem !important; height:1.8rem !important; border:1.5px solid #b0b0b0 !important; border-radius:.3rem !important; background:#fff !important; box-sizing:border-box !important;}
                #cardnewsLayer .cn-chk input[type="checkbox"]:checked + span::before{background:#0863de !important; border-color:#0863de !important;}
                #cardnewsLayer .cn-chk input[type="checkbox"]:checked + span::after{content:'' !important; position:absolute !important; left:.65rem !important; top:.55rem !important; width:.5rem !important; height:.9rem !important; border:solid #fff !important; border-width:0 .25rem .25rem 0 !important; transform:rotate(45deg) !important; box-sizing:border-box !important;}
                #cardnewsLayer .cn-chk b{font-weight:700;}
                #cardnewsLayer .cn-desc{margin:.4rem 0 .6rem 2rem; font-size:1.2rem; color:#666; line-height:1.5;}
                #cardnewsLayer .cn-note{margin:.8rem 0 0; font-size:1.2rem; color:#e23;}
                #cardnewsLayer .cn-note.ok{color:#0863de;}
                #cardnewsLayer .cn-submit{width:100%; padding:1.2rem; margin-top:.4rem; font-size:1.5rem; font-weight:700; color:#fff; background:#0863de; border:none; border-radius:.6rem; cursor:pointer;}
                #cardnewsLayer .cn-submit:disabled{background:#c8ccd6; cursor:not-allowed;}

                @media only screen and (max-width:640px){
                    #cardnewsLayer .cn-box{width:auto; margin:1.5rem; transform:none; top:0; max-height:calc(100vh - 3rem);}
                }
            </style>

            <script>
                function openCardnewsModal(){
                    document.getElementById('cardnewsLayer').style.display = 'block';
                    document.body.style.overflow = 'hidden';
                }
                function closeCardnewsModal(){
                    document.getElementById('cardnewsLayer').style.display = 'none';
                    document.body.style.overflow = '';
                }
                $(function(){
                    var $layer = $('#cardnewsLayer');
                    $layer.on('click', '.cn-close, .cn-dim', closeCardnewsModal);

                    function refreshSubmitState(){
                        var ok = $('#cn-agree1').is(':checked') && $('#cn-agree2').is(':checked');
                        $('#cn-submitBtn').prop('disabled', !ok);
                        $('#cn-noteMsg').toggleClass('ok', ok).text(ok ? '동의 완료 — 신청할 수 있습니다.' : '신청을 위해 위 동의 항목에 모두 체크해 주세요.');
                    }
                    $layer.on('change', '#cn-agree1, #cn-agree2', refreshSubmitState);

                    $('#cn-submitBtn').on('click', function(){
                        var company = $.trim($('#cn-company').val());
                        var writer  = $.trim($('#cn-writer').val());
                        var phone   = $.trim($('#cn-phone').val());
                        if (!company) { alert('회사명을 입력해주세요.'); $('#cn-company').focus(); return; }
                        if (!writer)  { alert('담당자명을 입력해주세요.'); $('#cn-writer').focus(); return; }
                        if (!phone)   { alert('연락처를 입력해주세요.'); $('#cn-phone').focus(); return; }
                        if (!$('#cn-agree1').is(':checked') || !$('#cn-agree2').is(':checked')) {
                            alert('필수 동의 항목에 체크해주세요.'); return;
                        }
                        var $btn = $(this).prop('disabled', true).text('전송 중...');
                        $.ajax({
                            url: '/_lib/cardnewsProc.asp',
                            type: 'POST',
                            data: {
                                company:  company,
                                writer:   writer,
                                phone:    phone,
                                email:    $.trim($('#cn-email').val()),
                                interest: $.trim($('#cn-interest').val()),
                                note1:    $.trim($('#cn-note1').val()),
                                agree1:   $('#cn-agree1').is(':checked') ? '1' : '0',
                                agree2:   $('#cn-agree2').is(':checked') ? '1' : '0'
                            },
                            dataType: 'text'
                        }).done(function(res){
                            res = $.trim(res);
                            if (res === 'OK') {
                                alert('카드뉴스 신청이 완료되었습니다.\n빠른 시일 내 안내드리겠습니다.');
                                document.getElementById('cardnewsForm').reset();
                                refreshSubmitState();
                                closeCardnewsModal();
                            } else if (res.indexOf('ERR:') === 0) {
                                alert(res.substring(4));
                            } else {
                                alert('처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                            }
                        }).fail(function(){
                            alert('네트워크 오류가 발생했습니다.');
                        }).always(function(){
                            $btn.prop('disabled', false).text('신청하기');
                            refreshSubmitState();
                        });
                    });
                });
            </script>
            <!-- ===== /카드뉴스 신청하기 모달 ===== -->

            <script>
                $(".quick-left .fold_btn").on("click", function(){
                    if($(".quick-left").hasClass("on")){
                        $(".quick-left").removeClass("on");
                    } else {
                        $(".quick-left").addClass("on");
                    }
                });
            </script>

            <div id="fullpage">
                <div id="main" class="mainWrap">

                    <section id="mainVisual" class="f0 section sec1 section1">
                        <div class="mainSlide_scroll">SCROLL</div>
                        <div class="mainSlide_scroll_bar">
                            <div class="scroll_bar"></div>
                        </div>
                        <div class="visualRoll swiper-wrapper">
							<%=PT_vodBanner(banRec2)%>
                        </div>

                        <div class="swiper-pagination"></div>
                    </section>


                    <section id="customizing" class="section fp-auto-height fp-auto-height-responsive customizing-sec">
                        <div class="customizing-inner">
                            <div class="customizing-head" data-aos="fade-up" data-aos-duration="900" data-aos-offset="120">
                                <p class="eyebrow"><span class="dot"></span>DOUZONE CUSTOMIZING<span class="dot"></span></p>
                                <h2><b>더존 ERP</b> 커스터마이징 전문 업체</h2>
                                <p class="lead">기업 맞춤형 화면 구성부터 업무 프로세스 개선, 연동 개발까지</p>
                            </div>

                            <div class="customizing-diagram">
                                <div class="hub" data-aos="fade-up" data-aos-duration="900" data-aos-delay="150" data-aos-offset="120">
                                    <div class="hub-card">
                                        <div class="hub-icon">
                                            <svg viewBox="0 0 80 80" width="72" height="72" aria-hidden="true">
                                                <rect x="10" y="14" width="60" height="40" rx="3" fill="#fff" stroke="#1a5cd7" stroke-width="2"/>
                                                <rect x="10" y="14" width="60" height="8" rx="3" fill="#1a5cd7"/>
                                                <text x="40" y="36" text-anchor="middle" font-size="9" font-weight="700" fill="#1a5cd7">ERP</text>
                                                <rect x="16" y="40" width="18" height="10" fill="#cfe1ff"/>
                                                <rect x="38" y="40" width="12" height="10" fill="#8fb8ff"/>
                                                <rect x="52" y="40" width="14" height="10" fill="#1a5cd7"/>
                                                <rect x="32" y="56" width="16" height="6" fill="#1a5cd7"/>
                                                <rect x="26" y="62" width="28" height="4" fill="#1a5cd7"/>
                                                <circle cx="60" cy="58" r="9" fill="#1a5cd7"/>
                                                <circle cx="60" cy="58" r="3" fill="#fff"/>
                                            </svg>
                                        </div>
                                        <strong>더존 ERP 커스터마이징</strong>
                                    </div>
                                </div>

                                <ul class="branch-cards">
                                    <li data-aos="fade-up" data-aos-duration="900" data-aos-delay="300" data-aos-offset="120">
                                        <span class="num">01</span>
                                        <div class="ico">
                                            <svg viewBox="0 0 64 64" width="56" height="56" aria-hidden="true">
                                                <rect x="6" y="10" width="52" height="38" rx="3" fill="#fff" stroke="#1a5cd7" stroke-width="2"/>
                                                <rect x="6" y="10" width="52" height="7" rx="3" fill="#1a5cd7"/>
                                                <circle cx="11" cy="13.5" r="1.2" fill="#fff"/><circle cx="15" cy="13.5" r="1.2" fill="#fff"/><circle cx="19" cy="13.5" r="1.2" fill="#fff"/>
                                                <rect x="12" y="22" width="16" height="3" fill="#8fb8ff"/>
                                                <rect x="12" y="28" width="22" height="3" fill="#cfe1ff"/>
                                                <rect x="12" y="34" width="14" height="3" fill="#cfe1ff"/>
                                                <circle cx="44" cy="34" r="9" fill="none" stroke="#1a5cd7" stroke-width="2"/>
                                                <path d="M50 40 L56 46" stroke="#1a5cd7" stroke-width="3" stroke-linecap="round"/>
                                            </svg>
                                        </div>
                                        <p class="t1">더존 ERP</p>
                                        <p class="t2">화면 커스터마이징</p>
                                    </li>
                                    <li data-aos="fade-up" data-aos-duration="900" data-aos-delay="400" data-aos-offset="120">
                                        <span class="num">02</span>
                                        <div class="ico">
                                            <svg viewBox="0 0 64 64" width="56" height="56" aria-hidden="true">
                                                <rect x="24" y="6" width="16" height="12" rx="2" fill="#cfe1ff" stroke="#1a5cd7" stroke-width="2"/>
                                                <line x1="32" y1="18" x2="32" y2="28" stroke="#1a5cd7" stroke-width="2"/>
                                                <line x1="14" y1="28" x2="50" y2="28" stroke="#1a5cd7" stroke-width="2"/>
                                                <line x1="14" y1="28" x2="14" y2="36" stroke="#1a5cd7" stroke-width="2"/>
                                                <line x1="32" y1="28" x2="32" y2="36" stroke="#1a5cd7" stroke-width="2"/>
                                                <line x1="50" y1="28" x2="50" y2="36" stroke="#1a5cd7" stroke-width="2"/>
                                                <rect x="6" y="36" width="16" height="14" rx="2" fill="#8fb8ff" stroke="#1a5cd7" stroke-width="2"/>
                                                <rect x="24" y="36" width="16" height="14" rx="2" fill="#cfe1ff" stroke="#1a5cd7" stroke-width="2"/>
                                                <circle cx="50" cy="43" r="8" fill="#1a5cd7"/>
                                                <path d="M46 43 L49 46 L54 40" stroke="#fff" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
                                            </svg>
                                        </div>
                                        <p class="t1">업무 프로세스</p>
                                        <p class="t2">맞춤 개발</p>
                                    </li>
                                    <li data-aos="fade-up" data-aos-duration="900" data-aos-delay="500" data-aos-offset="120">
                                        <span class="num">03</span>
                                        <div class="ico">
                                            <svg viewBox="0 0 64 64" width="56" height="56" aria-hidden="true">
                                                <path d="M14 6 H40 L52 18 V58 H14 Z" fill="#fff" stroke="#1a5cd7" stroke-width="2"/>
                                                <path d="M40 6 V18 H52" fill="none" stroke="#1a5cd7" stroke-width="2"/>
                                                <rect x="20" y="42" width="5" height="10" fill="#cfe1ff"/>
                                                <rect x="28" y="36" width="5" height="16" fill="#8fb8ff"/>
                                                <rect x="36" y="28" width="5" height="24" fill="#1a5cd7"/>
                                            </svg>
                                        </div>
                                        <p class="t1">더존 커스텀</p>
                                        <p class="t2">보고서·양식 제작</p>
                                    </li>
                                    <li data-aos="fade-up" data-aos-duration="900" data-aos-delay="600" data-aos-offset="120">
                                        <span class="num">04</span>
                                        <div class="ico">
                                            <svg viewBox="0 0 64 64" width="56" height="56" aria-hidden="true">
                                                <rect x="2" y="14" width="24" height="18" rx="2" fill="#fff" stroke="#1a5cd7" stroke-width="2"/>
                                                <rect x="6" y="18" width="16" height="10" fill="#cfe1ff"/>
                                                <rect x="10" y="32" width="8" height="3" fill="#1a5cd7"/>
                                                <rect x="38" y="14" width="24" height="18" rx="2" fill="#fff" stroke="#1a5cd7" stroke-width="2"/>
                                                <rect x="42" y="18" width="16" height="10" fill="#8fb8ff"/>
                                                <rect x="46" y="32" width="8" height="3" fill="#1a5cd7"/>
                                                <path d="M28 23 L36 23" stroke="#1a5cd7" stroke-width="2"/>
                                                <path d="M28 23 L31 20 M28 23 L31 26" stroke="#1a5cd7" stroke-width="2" fill="none"/>
                                                <path d="M36 23 L33 20 M36 23 L33 26" stroke="#1a5cd7" stroke-width="2" fill="none"/>
                                            </svg>
                                        </div>
                                        <p class="t1">타 시스템 연동</p>
                                        <p class="t2">커스터마이징</p>
                                    </li>
                                    <li data-aos="fade-up" data-aos-duration="900" data-aos-delay="700" data-aos-offset="120">
                                        <span class="num">05</span>
                                        <div class="ico">
                                            <svg viewBox="0 0 64 64" width="56" height="56" aria-hidden="true">
                                                <path d="M8 8 H28 V18 a4 4 0 0 0 8 0 V8 H56 V28 h-10 a4 4 0 0 1 0 8 H56 V56 H36 v-10 a4 4 0 0 0 -8 0 V56 H8 V36 h10 a4 4 0 0 0 0 -8 H8 Z" fill="#cfe1ff" stroke="#1a5cd7" stroke-width="2" stroke-linejoin="round"/>
                                                <path d="M36 8 H56 V28 h-10 a4 4 0 0 1 0 8 H56 V56 H36 v-10 a4 4 0 0 0 -8 0 V56" fill="#1a5cd7" stroke="#1a5cd7" stroke-width="2" stroke-linejoin="round"/>
                                            </svg>
                                        </div>
                                        <p class="t1">더존 추가 기능</p>
                                        <p class="t2">개발</p>
                                    </li>
                                </ul>
                            </div>

                            <div class="customizing-cta" data-aos="fade-up" data-aos-duration="900" data-aos-delay="850" data-aos-offset="120">
                                <a href="/purchase/inquiry.asp" class="btn-primary">더존 커스터마이징 무료 상담 신청 <span aria-hidden="true">→</span></a>
                            </div>
                        </div>

                        <style>
                            .customizing-sec{padding:10rem 2rem; background:linear-gradient(180deg,#f4f7fc 0%, #ffffff 100%); text-align:center; position:relative; overflow:hidden;}
                            .customizing-sec:before,.customizing-sec:after{content:""; position:absolute; border-radius:50%; opacity:.5; pointer-events:none;}
                            .customizing-sec:before{width:600px; height:600px; right:-200px; top:-200px; background:radial-gradient(circle, rgba(26,92,215,.06) 0%, transparent 70%);}
                            .customizing-sec:after{width:500px; height:500px; left:-150px; bottom:-150px; background:radial-gradient(circle, rgba(26,92,215,.05) 0%, transparent 70%);}
                            .customizing-inner{max-width:130rem; margin:0 auto; position:relative; z-index:1;}
                            .customizing-head .eyebrow{display:inline-flex; align-items:center; gap:1rem; color:#1a5cd7; font-weight:700; letter-spacing:.25em; font-size:1.4rem; margin-bottom:1.6rem;}
                            .customizing-head .eyebrow .dot{width:6px; height:6px; border-radius:50%; background:#1a5cd7; display:inline-block;}
                            .customizing-head h2{font-size:4rem; font-weight:800; color:#1a2540; line-height:1.25; margin:0 0 1.6rem;}
                            .customizing-head h2 b{color:#1a5cd7; font-weight:800;}
                            .customizing-head .lead{font-size:1.7rem; color:#5a6b85; line-height:1.6; margin:0 0 6rem;}

                            .customizing-diagram{position:relative; padding:0 1rem 2rem;}
                            .hub{display:flex; justify-content:center; margin-bottom:5rem; position:relative;}
                            .hub-card{width:30rem; padding:3rem 2rem 2.4rem; background:#fff; border:2px solid #1a5cd7; border-radius:1.6rem; box-shadow:0 1.4rem 3rem rgba(26,92,215,.15); position:relative;}
                            .hub-card .hub-icon{margin:0 auto 1.2rem; display:flex; justify-content:center;}
                            .hub-card strong{display:block; font-size:1.9rem; font-weight:800; color:#1a2540;}

                            .branch-cards{list-style:none; padding:0; margin:0; display:grid; grid-template-columns:repeat(5, 1fr); gap:2rem; position:relative;}
                            .branch-cards:before{content:""; position:absolute; left:10%; right:10%; top:-3rem; height:2px; background:repeating-linear-gradient(90deg,#9fbef1 0 8px, transparent 8px 14px);}
                            .branch-cards>li{position:relative; padding:5rem 1.6rem 2.6rem; background:#fff; border:1px solid #e1ebfa; border-radius:1.4rem; box-shadow:0 .6rem 1.6rem rgba(26,92,215,.06); transition:transform .25s ease, box-shadow .25s ease, border-color .25s ease;}
                            .branch-cards>li:hover{transform:translateY(-6px); box-shadow:0 1.6rem 3rem rgba(26,92,215,.18); border-color:#1a5cd7;}
                            .branch-cards>li:before{content:""; position:absolute; left:50%; top:-3rem; width:2px; height:3rem; background:#9fbef1; transform:translateX(-50%);}
                            .branch-cards>li:after{content:""; position:absolute; left:50%; top:-3px; width:10px; height:10px; border-right:2px solid #1a5cd7; border-bottom:2px solid #1a5cd7; transform:translateX(-50%) rotate(45deg);}
                            .branch-cards .num{position:absolute; top:1.6rem; left:50%; transform:translateX(-50%); font-size:1.3rem; font-weight:700; color:#1a5cd7; letter-spacing:.05em;}
                            .branch-cards .ico{display:flex; justify-content:center; margin-bottom:1.4rem;}
                            .branch-cards .t1{font-size:1.6rem; font-weight:700; color:#1a2540; margin:0; line-height:1.3;}
                            .branch-cards .t2{font-size:1.6rem; font-weight:700; color:#1a2540; margin:.2rem 0 0; line-height:1.3;}

                            .customizing-cta{margin-top:6rem;}
                            .customizing-cta .btn-primary{display:inline-flex; align-items:center; gap:1rem; background:#1a5cd7; color:#fff; padding:1.8rem 4.2rem; border-radius:99rem; font-size:1.6rem; font-weight:700; text-decoration:none; box-shadow:0 1rem 2.4rem rgba(26,92,215,.3); transition:transform .2s ease, box-shadow .2s ease, background-color .2s ease;}
                            .customizing-cta .btn-primary:hover{transform:translateY(-2px); background:#0e49b8; box-shadow:0 1.4rem 3rem rgba(26,92,215,.4);}

                            @media (max-width: 1024px){
                                .branch-cards{grid-template-columns:repeat(3, 1fr);}
                                .branch-cards:before{display:none;}
                                .branch-cards>li:before,.branch-cards>li:after{display:none;}
                                .customizing-head h2{font-size:3rem;}
                            }
                            @media (max-width: 640px){
                                .customizing-sec{padding:6rem 1.5rem;}
                                .branch-cards{grid-template-columns:repeat(2, 1fr); gap:1.2rem;}
                                .customizing-head h2{font-size:2.4rem;}
                                .customizing-head .lead{font-size:1.4rem; margin-bottom:4rem;}
                                .hub-card{width:24rem;}
                            }
                        </style>
                    </section>


                    <section id="" class="section sec3 section3">
                        <a href="/product/amaranth10/brand.asp" style="display: block;" class="inConts">
                            <div class="main__tit" data-aos="fade-up">
                                <b>AMARANTH 10</b>
                                <h2>
                                    <span>대한민국 기업체 최적화된</span>
                                    대표 ERP
                                </h2>
                                <p>
                                    Amaranth 10은 ERP와 그룹웨어의 융합으로 이제 하나의 솔루션에서 <br />
                                    모든 업무를 해결할 수 있는 'One-Stop' 서비스 경험을 제공합니다.
                                </p>
                            </div>
                            <div class="img" data-aos="fade-up" data-aos-delay="100"><img src="/images/main/sec3__img01.png" alt="Amaranth 10 ERP 솔루션 이미지" loading="lazy" decoding="async"></div>
                        </a>
                    </section>


                    <section id="" class="section sec2 section2">
                        <a href="/product/wehago/smart_A10.asp" style="display: block;" class="inConts">
                            <div class="main__tit" data-aos="fade-up" >
                                <b>WEHAGO</b>
                                <h2>
                                    <span>기업에 필요한 다양한 업무환경을</span>
                                    제공하는 비즈니스 플랫폼
                                </h2>
                                <p>
                                    WEHAGO(위하고)는 회사 경영에 필수적인 경영관리부터 원활한 협업을 위한 <br />
                                    서비스와 부가서비스까지 한 곳에서 사용할 수 있는 비즈니스 플랫폼입니다.
                                </p>
                            </div>
                            <div class="img" data-aos="fade-up" data-aos-delay="100"><img src="/images/main/sec2__img01.png" alt="WEHAGO 비즈니스 플랫폼 이미지" loading="lazy" decoding="async"></div>
                        </a>
                    </section>

                    <section id="" class="section sec4 section4 ">
                        <div class="inConts">
                            <div class="left">
                                <div class="main__tit" data-aos="fade-up" >
                                    <b>NATIONAL SUBSIDES</b>
                                    <h2>
                                        정부 지원사업
                                    </h2>
                                    <p>
                                        기업의 인재육성과 기술우위 확보를 위한 지원으로 기업 성장을 돕고 <br />
                                        서비스 품질을 고도화 함으로써 함께 성장하는 디지털 미래 개척에 기여합니다.
                                    </p>
                                </div>
                                <a href="javascript:void(0);" class="box box1" data-aos="fade-up" data-aos-delay="200">
                                    <b>Non-face-to-face</b>
                                    <strong>정부지원</strong>
                                    <p>
                                        아이원소프트뱅크㈜의 <br />
                                        정부지원사업
                                    </p>
                                </a>
                            </div>
                            <div class="right" data-aos="fade-up" data-aos-delay="200">
                                <div class="contWrap">
                                    <a href="/government/notice.asp" class="box box2">
                                        <b>UBSIDES</b>
                                        <strong>공지사항</strong>
                                        <p>
                                            아이원소프트뱅크㈜의 <br />
                                            공지사항입니다.
                                        </p>
                                    </a>
                                    <a href="javascript:void(0);" class="box box3">
                                        <b>smart factory</b>
                                        <strong>스마트공장</strong>
                                        <p>
                                            제조업체 대상 스마트공장 <br />
                                            으로 구축 지원
                                        </p>
                                    </a>
                                    <div class="logo">
                                        <img src="/images/main/sec4__logo.png" alt="정부지원사업 로고" style="width: 41.5rem;" loading="lazy" decoding="async">
                                    </div>
                                    <a href="javascript:void(0);" class="box box4">
                                        <b>Other support</b>
                                        <strong>
                                            기타 지원사업
                                        </strong>
                                        <p>
                                            솔루션 연동 자동화 장비, <br />
                                            제어기, 센서 구입 지원
                                        </p>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section id="" class="section sec5 section5">
                        <div class="inConts">
                            <div class="main__tit" data-aos="fade-up" >
                                <b>DOUZONE</b>
                                <h2>
                                    아이원소프트뱅크는
                                </h2>
                                <p>
                                    클라우드, 모바일, 전자금융, 전자 문서 등 최첨단 기술을 통해 기업이 나아갈 바를 <br />
                                    정확히 알고 축적된 노하우와 경험으로 기업의 탄생과 성장에 기여하고 있습니다.
                                </p>
                                <a href="/company/about.asp" class="main__btn">VIEW MORE <img src="/images/main/main_arr.png" alt="바로가기" loading="lazy" decoding="async"></a>
                            </div>
                        </div>
                    </section>

                    <section id="" class="section sec6 section6">
                        <div class="inConts" data-aos="fade-up" data-aos-delay="100">
                            <div class="main__tit">
                                <b>Customer center</b>
                                <h2>
                                    고객센터
                                </h2>
                                <p>
                                    비즈니스 성장의 시작은 지금부터! <br />
                                    성장을 넘어 성공의 발걸음으로
                                </p>
                                <ul class="map_tabs">
                                    <li class="tab-link current mg" data-tab="tab-1"><p><span>01</span>공지사항</p><p><img src="/images/main/main_arr.png" alt="공지사항 바로가기" loading="lazy" decoding="async"></p></li>
                                    <li class="tab-link mg" data-tab="tab-2"><p><span>02</span>Amaranth 10</p><p><img src="/images/main/main_arr.png" alt="Amaranth 10 바로가기" loading="lazy" decoding="async"></p></li>

                                    <li class="tab-link mg" data-tab="tab-4"><p><span>03</span>Bizbox Alpha</p><p><img src="/images/main/main_arr.png" alt="Bizbox Alpha 바로가기" loading="lazy" decoding="async"></p></li>
									<li class="tab-link mg" data-tab="tab-3"><p><span>04</span>iCUBE / iCUBE G20</p><p><img src="/images/main/main_arr.png" alt="iCUBE 바로가기" loading="lazy" decoding="async"></p></li>
                                </ul>
                            </div>

                            <div id="tab-1" class="tab-content current tab1">
                                <div class="sec6__slide">
                                    <div class="swiper-container">
                                        <!-- Additional required wrapper -->
                                        <div class="swiper-wrapper">
                                            <%=PT_BBsTopType1(BoardRec1, "/customer/notice.asp", "N")%>
                                        </div>
                                        <div class="swiper-scrollbar"></div>
                                    </div>
                                </div>
                            </div>
                            <div id="tab-2" class="tab-content tab2">
                                <div class="sec6__slide">
                                    <div class="swiper-container">
                                        <!-- Additional required wrapper -->
                                        <div class="swiper-wrapper">
											<%=PT_BBsTopType1(BoardRec2, "/amaranth10/pds.asp", "N")%>
                                        </div>
                                        <div class="swiper-scrollbar"></div>
                                    </div>
                                </div>
                            </div>
                            <div id="tab-3" class="tab-content tab3">
                                <div class="sec6__slide">
                                    <div class="swiper-container">
                                        <!-- Additional required wrapper -->
                                        <div class="swiper-wrapper">
											<%=PT_BBsTopType1(BoardRec3, "/icube/pds.asp", "N")%>
                                        </div>
                                        <div class="swiper-scrollbar"></div>
                                    </div>
                                </div>
                            </div>
                            <div id="tab-4" class="tab-content tab4">
                                <div class="sec6__slide">
                                    <div class="swiper-container">
                                        <!-- Additional required wrapper -->
                                        <div class="swiper-wrapper">
											<%=PT_BBsTopType1(BoardRec4, "/bizbox/pds.asp", "N")%>
                                        </div>
                                        <div class="swiper-scrollbar"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section id="" class="section sec7 section7 fp-auto-height fp-auto-height-responsive" style="">
                        <div class="inConts flex" data-aos="fade-up" >
                            <div class="main__tit">
                                <b>Client story</b>
                                <h2>
                                    고객스토리
                                </h2>
                                <p>
                                    아이원의 대표 구축 및 교육 고객사입니다.
                                </p>
                            </div>
                            <div class="sec7__slide">
                                <div class="swiper-container" >
                                    <!-- Additional required wrapper -->
                                    <div class="swiper-wrapper">
										<%=PT_partner()%>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="footer">
                            <!-- #include virtual=common/include/footer.asp -->
                        </div>
                    </section>
                </div>
            </div>
        </section>
    </body>
</html>

<script type="text/javascript">
var mVisual, boardSwiper, ckSwiper;
$(function () {
	mVisual = new Swiper('#mainVisual', {
		watchOverflow: true,
		spaceBetween: 0,
		slidesPerView: 1,
		direction: 'horizontal',
		loop: true,
		speed: 1500,
		allowTouchMove: true,
		autoplay: {
			delay: 6000,
		},
		pagination: {
			el: '#mainVisual .swiper-pagination',
			clickable: true,
		},
		// Navigation arrows
		navigation: {
			nextEl: '#mainVisual .swiper-button-next',
			prevEl: '#mainVisual .swiper-button-prev',
		},
		on: {
			init: function () {
				//console.log(mVisual_total, this.realIndex, this.activeIndex)
				//$("#mainVisual .swiper-number .n").html(this.activeIndex)
				//$("#mainVisual .swiper-number .t").html(mVisual_total)
			},
			slideChange: function () {
				//$("#mainVisual .swiper-number .n").html(this.activeIndex)
			},
		}
	});

	$(".m-tab>a").click(function () {
		var idx = $(".m-tab>a").index($(this));
		$(".m-tab>a").each(function (index) {
			if (idx == index) {
				$(this).addClass("active");
				$(".main-board").eq(index).show()
				$(".main-board").eq(index).addClass("swiper_" + index);

				if (boardSwiper != undefined) {
					boardSwiper.destroy();
					boardSwiper = undefined;
				}

				boardSwiper = new Swiper(`.main-board.swiper_${index} .main-board-swiper`, { //mobile
					watchOverflow: true, // 슬라이드가 1개 일 때 pager, button 숨김 여부 설정
					slidesPerView: "auto",
					spaceBetween: 39,
					//slidesOffsetBefore: -10,
					//slidesOffsetafter: -10,
					direction: 'horizontal',
					loop: true,
					speed: 1000,
					allowTouchMove: true,
					navigation: {
						nextEl: `.main-board.swiper_${index} .swiper-button-next`,
						prevEl: `.main-board.swiper_${index} .swiper-button-prev`,
					},
					pagination: {
						el: `.main-board.swiper_${index} .swiper-pagination`,
						type: 'progressbar',
					},
					observer: true,
					observeParents: true,
					loopAdditionalSlides: 4
				});
			} else {
				$(this).removeClass("active");
				$(".main-board").eq(index).hide()
			}
		});
	}).filter(":first").click();
});
</script>

<script>
$(document).ready(function () {
	$('ul.map_tabs li').click(function () {
		var tab_id = $(this).attr('data-tab');
		$('ul.map_tabs li').removeClass('current');
		$('.tab-content').removeClass('current');
		$(this).addClass('current');
		$("#" + tab_id).addClass('current');
	});

	// var bulletTit = ['오지', '크런처스', '필', '미미'];
	var sec6Slide1 = new Swiper('.sec6 .swiper-container ', {
		direction: 'horizontal',
		// loop: true,
		speed: 1200,
		spaceBetween: 20,
		slidesPerView: 1,
		centeredSlides: true,
		allowTouchMove: true,
		observer: true,
		observeParents: true,
		autoplay: {
			delay: 3000,
			disableOnInteraction: false,
		},
		scrollbar: {
			el: '.sec6 .swiper-scrollbar',
			draggable: true,
		},
		navigation: {
			nextEl: '.sec6 .swiper-button-next',
			prevEl: '.sec6 .swiper-button-prev',
		},
		breakpoints: {
            600: {
				allowTouchMove: true,
				spaceBetween: 15,
				slidesPerView: 2,
				centeredSlides: false,
			},
			1025: {
				allowTouchMove: true,
				spaceBetween: 20,
				slidesPerView: 1.5,
				centeredSlides: false,
			},
			1400: {
				spaceBetween: 15,
				slidesPerView: 3,
				centeredSlides: false,
				allowTouchMove: true,
			},
		},


		// pagination: {
		//     el: '.sec6 .swiper-pagination',
		//     clickable: true,
		//     renderBullet: function (index, className) {
		//         return '<div class="' + className + '"><b>' + (bulletTit[index]) + '</b></div>';
		//     }
		// },
	});

	var sec7Slide1 = new Swiper('.sec7__slide .swiper-container ', {
		direction: 'horizontal',
		loop: true,
		loopAdditionalSlides: 1,
		speed: 1500,
		spaceBetween: 15,
		slidesPerView: 2.5,
		// allowTouchMove: false,
		autoplay: {
			delay: 0,
			disableOnInteraction: false,
		},

		breakpoints: {
			640: {
				direction: 'horizontal',
				loop: true,
				loopAdditionalSlides: 1,
                spaceBetween: 30,
				speed: 3000,
				slidesPerView: 5,
				// allowTouchMove: false,
				autoplay: {
					delay: 0,
					disableOnInteraction: false,
				},
			},
			1200: {
				// allowTouchMove: false,
				direction: 'horizontal',
				loop: true,
				loopAdditionalSlides: 1,
				speed: 3000,
				spaceBetween: 40,
				slidesPerView: 6,
				autoplay: {
					delay: 0,
					disableOnInteraction: false,
				},
			},
		},
	});

	$('#fullpage').fullpage({
		licenseKey: '8B7B0C73-C4FC4C00-96509ADF-313CB97A',
		anchors: ['section1', 'section2', 'section3', 'section4', 'section5', 'section6', 'section7', 'section8', 'section9', 'section10', 'sectionft'],
		//menu: '#pc_menu',
		autoScrolling: true,
		scrollHorizontally: true,
		responsiveWidth: 1025,
		responsiveHeight: 870,
		scrollingSpeed: 600,
		scrollOverflow: true,
		css3: true,
		lazyLoad: true,
		onLeave: function (origin, destination, direction) {
			if (window.matchMedia("(min-width: 1025px)").matches) {
				if (origin.index == 0) {
					$("#header").addClass("scrolled");
					$("#hd").addClass("on");
				}
				if (destination.index == 0) {
					$("#header").removeClass("scrolled");
					$("#hd").removeClass("on");
				}

				if (origin.index == 6) {
					sec7Slide1.autoplay.start()
				}
			}

			if (window.matchMedia("(max-height: 870px)").matches){
				//console.log("870 down")
				$("#fullpage").removeClass("ribbon");
			}else{
				//console.log("870 up")
				$("#fullpage").addClass("ribbon");
			}
		},
		afterLoad: function(origin, destination, direction) {
			if (window.matchMedia("(min-width: 1025px)").matches) {
				if (destination.index == 0) {
					$("#header").removeClass("scrolled");
				} else if (destination.index !== 0) {

				}
			}
			$('.fp-table.active .aos-init').addClass('aos-animate');
		}
	});
});
</script>


<% IF PopStr<>"" Then %>
<div id="popLayer" class="disNone">
	<div id="moPopArea">
		<%=PopStr%>
	</div>

	<style type="text/css">
	#popLayer{width:100%; height:100%; background-color: rgba(0,0,0,0.7); font-size:0; line-height:0; position:fixed; left:0; top:0; z-index:99; overflow:hidden; overflow-y:auto;}
	#popLayer.disNone{display:none !important;}
	#popLayer #moPopArea{width:100vw; min-height:100vh; padding:6rem 3rem; box-sizing: border-box; display: flex; flex-wrap:wrap; align-items: flex-start; justify-content: center; gap:3rem; -ms-flex-align:center;}
	#popLayer #moPopArea .moPop{width:100%; max-width:50rem; margin:0; position: relative;}
	#popLayer #moPopArea .moPop.disNone{display:none !important;}
	#popLayer .moPopRoll{background-color: #fff; border-radius:2rem 2rem 0 0; overflow:hidden; box-shadow:0 2rem 4rem rgba(0,0,0,0.3);}
	#popLayer .slider{width:100%; border-radius:2rem 2rem 0 0; font-size:0; line-height:0; box-sizing:border-box; overflow:hidden;}
	#popLayer .slider img{width:100%; vertical-align: top;}
	#popLayer .slider[id^="HKeditorContent"]{padding:3rem 0 6rem; font-size:1.8rem; line-height:1.5; color: #666;}
	#popLayer .slider[id^="HKeditorContent"]>*{padding-left:3rem; padding-right:3rem;}
	#popLayer .slider[id^="HKeditorContent"] img{width:auto;}

	#popLayer .layerPopClose{width:3rem; height:3rem; margin:0; padding:0; font-size:0; line-height:0; position: absolute; right:1.5rem; top:1.5rem; z-index:6; transform:rotate(45deg);}
	#popLayer .layerPopClose:before,
	#popLayer .layerPopClose:after{content: ""; background-color: #222; display: block; position:absolute; left: 50%; top:50%;}
	#popLayer .layerPopClose:before{width: 100%; height: 2px; margin:-1px 0 0 -1.5rem;}
	#popLayer .layerPopClose:after{width: 2px; height: 100%; margin:-1.5rem 0 0 -1px;}

	#popLayer .moPopClose{width:100%; margin-top:-1px; background-color: var(--point); border-radius:0 0 2rem 2rem; display: flex; justify-content: space-between; overflow:hidden;}
	#popLayer .moPopClose>*{flex:1 1 50%; height:6rem; margin:0; padding:0 3rem; font-size:1.6rem; line-height:1; display: flex; align-items: center; justify-content: flex-start;}
	#popLayer .moPopClose button{background-color: var(--bg); border:none; color: #fff; position: relative;}
	/*#popLayer .moPopClose button:before{content: "X"; width: 1.8rem; height: 1.8rem; background-color: rgba(255,255,255,0.3); border:1px solid #000; font-family: dotum; font-weight: bold; font-size:1.6rem; line-height:1.6rem; color: #000;display: inline-block; position:absolute; top:0; box-sizing: border-box;}
	#popLayer .moPopClose button.toDay_close{padding-left:2.5rem;}
	#popLayer .moPopClose button.toDay_close:before{left:0;}*/
	#popLayer .moPopClose button.close{padding-right:3rem; justify-content: flex-end;}
	#popLayer .moPopClose button.close:before{right:0;}
	#popLayer .moPopClose a{background-color: #3617cd; color:#fff}

	#popLayer .moPopRoll{opacity: 1; visibility: visible;}

	@media only screen and (max-width : 840px){
		.hd_pops{left:2rem !important; right:2rem !important;}
		#popLayer #moPopArea{padding:3rem 2rem; gap:2rem;}
		#popLayer #moPopArea .moPop{max-width:100%;}
		#popLayer .slider[id^="HKeditorContent"]{padding:3rem 3rem 6rem; font-size:2.4rem;}
		#popLayer .moPopClose>*{height:8rem; font-size:2rem;}
	}
	</style>
</div>

<script type="text/javascript">
$(function(){
	// 개별 팝업 필터: '오늘 하루' 쿠키가 걸린 팝업 숨김
	$("#popLayer .popItem").each(function(){
		var idx = $(this).data("popidx");
		if(getCookie("popLayer_"+idx)=="done"){
			$(this).addClass("disNone");
		}
	});

	// 표시할 팝업이 하나라도 있으면 오버레이 노출
	if($("#popLayer .popItem").not(".disNone").length > 0){
		$("#popLayer").removeClass("disNone");
	}

	// 개별 닫기
	$(document).on("click", "#popLayer .popItemClose", function(){
		var $item = $(this).closest(".popItem");
		$item.addClass("disNone");
		if($("#popLayer .popItem").not(".disNone").length === 0){
			$("#popLayer").addClass("disNone");
		}
	});

	// 개별 '오늘 하루 열지 않기' — popidx별 쿠키
	$(document).on("click", "#popLayer .popItemToday", function(){
		var idx = $(this).data("popidx");
		setCookie('popLayer_'+idx, "done", 1);
		var $item = $(this).closest(".popItem");
		$item.addClass("disNone");
		if($("#popLayer .popItem").not(".disNone").length === 0){
			$("#popLayer").addClass("disNone");
		}
	});
});
</script>
<% End IF %>

<script type="text/javascript">
	$(function(){
		if(getCookie("ribbon-banner")!="done"){
			if (popHtml!="")	{
				$("#ribbon-banner").removeClass("disNone");
				$("#fullpage").addClass("ribbon");
			}
		}
		/*
		$(document).on("click","#ribbonClose",function(){
			$("#ribbon-banner").addClass("disNone")
		});
		*/

		$("body").on("click", "#ribbonToDayClose", function(){
			closetoLayer('ribbon-banner')
			$("#ribbon-banner").addClass("disNone").slideUp(300);
			$("#fullpage").removeClass("ribbon");
		});

		var rePop = $(".ribbon-roll .slider").length;// 로그인쪽 위 베너
		if(rePop > 1){
			$(".ribbon-roll").addClass("roll");
			$(".ribbon-roll").slick({
				speed: 300,
				// autoplay: true,
				slidesToShow: 1,
				slidesToScroll: 1,
				arrows: false,
				dots: true,
				adaptiveHeight: true,
				centerMode: true,
				centerPadding: '0'
			});
		}else{
			$(".ribbon-roll").addClass("open");
		}

		$(window).on('scroll', function(){// Scroll Event
			scroll_T = window.scrollY;
			if(!$("#ribbon-banner").hasClass("disNone")){
				//console.log($("#ribbon-banner").height())
				if(scroll_T >= $("#ribbon-banner").height()){
					$("#header").addClass("fixed")
				}else{
					$("#header").removeClass("fixed")
				}
			}
		}).scroll();

		$(window).on('throttledresize', function(){
			window_W = $(window).width();

			//console.log(window_W, scroll_T, $("#ribbon-banner").height())
			if(window_W > "1024"){
				if(!$("#ribbon-banner").hasClass("disNone")){
					//console.log($("#ribbon-banner").height())
					if(scroll_T >= $("#ribbon-banner").height()){
						$("#header").addClass("fixed")
					}else{
						$("#header").removeClass("fixed")
					}
				}
			}

			if (window.matchMedia("(max-height: 870px)").matches){
				//console.log("870 down")
				$("#fullpage").removeClass("ribbon");
			}else{
				//console.log("870 up")
				$("#fullpage").addClass("ribbon");
			}
		}).resize();
	});
</script>