let scroll_T = window.scrollY;
let window_W = window.innerWidth;
let window_H = $(window).height();

let pcBgH = "0";
const pcBgP = 50;

var getParam = new Array();
location.search.replace(/([^=&?]+)=([^&]+)/gi, function (a, b, c) {
	getParam[decodeURIComponent(b)] = decodeURIComponent(c);
});

$(function(){
	$("#wrap").append('<div id="progressBar"></div>');
	// var $someImages = $('img.ofi');
	// objectFitImages($someImages);

	$("body").on("mouseenter", "#header:not('.all') #pcMenu>#list>li", function(){// [PC] GNB OVER
		var idx = $("#pcMenu #list>li:not('.one')").index($(this));
		$("#pcMenu #list>li:not('.one')").each(function(index){
			if(idx == index){
				$(this).addClass("active");
				$(this).find(".gnbSub").stop().slideDown(200);
			}else{
				$(this).removeClass("active");
				$(this).find(".gnbSub").stop().slideUp(200);
			}
		});
	});
	$("body").on("mouseleave", "#header:not('.all') #pcMenu>#list", function(){// [PC] GNB OUT
		$("#pcMenu #list .gnbSub").stop().slideUp(150);
		$("#pcMenu #list>li").removeClass("active");
	});

	$("body").on("click", "#header .tSchArea>.tSch", function(){// [PC] SEARCH OPEN
		$(".mMenu:not('.mo')").removeClass("open");
		$("#header").removeClass("all");
		$("#menuArea").removeClass("open");

		if($("#header").hasClass("hh")){
			$("#header .gnbBg").stop().animate({'height' : 0}, 200,function(){
				$("#header .gnbBg").css("opacity",0)
			});
			$("#header #pcMenu .gnbSub").css("height","auto").stop().slideUp(150);
		}else{
			$("#header #pcMenu .gnbSub").slideUp(150);
		}

		if(!$(this).parent().hasClass("open")){
			$(this).parent().addClass("open");
			$("#header").addClass("sch");
			$("html").addClass("hide");
		}else{
			$(this).parent().removeClass("open");
			$("#header").removeClass("sch");
			$("html").removeClass("hide");
		}
	});
	$("#header .tSchArea a.tSch").click(function (){ // [PC] SEARCH
		//console.log("aaa");
		if($('input[name="stx"]').val()==""){
			alert("검색어를 입력해주세요");
			return false;
		}
		$('form[name=\'search\']').submit();
	});

	$("body").on("mouseleave", "#wrap[data-device='pc'] #header", function(){// [PC] HEADER OUT
		if(!$(".mMenu").hasClass("mo")){
			$("#header").removeClass("all");
			$("#header").removeClass("sch");
            $(".nav_bg").stop().slideUp(200);
            $("html").removeClass("hide");
			$("#header .tSchArea").removeClass("open");
			$(".mMenu:not('.mo')").removeClass("open");
			if($("#header").hasClass("hh")){
				$("#header .gnbBg").stop().animate({'height' : 0}, 200,function(){
					$("#header .gnbBg").css("opacity",0)
				});
				$("#header #pcMenu .gnbSub").css("height","auto").stop().slideUp(150);
			}else{
				$("#header #pcMenu .gnbSub").slideUp(150);
			}
		}
	});

	$("body").on("click", "#wrap[data-device='pc'] .mMenu", function(){ // [PC] ALL MENU OPEN
		$("#header").removeClass("all");
		$("#header .tSchArea").removeClass("open");
		$("#header").removeClass("sch");
        $(".nav_bg").stop().slideDown(300);

		if(!$(this).hasClass("open")){
			$(this).addClass("open");
			$("#header").addClass("all")
			$("html").addClass("hide");
            $(".nav_bg").stop().slideDown(300);

			if($("#header").hasClass("hh")){
				$("#header .gnbBg").css("opacity",1).stop().animate({'height' : pcBgH}, 150);
				$("#header #pcMenu li:not('.one') .gnbSub").height(pcBgH-pcBgP).stop().slideDown(600);
			}else{
				$("#header #pcMenu li:not('.one') .gnbSub").slideDown(300);
            }
		}else{
			$(this).removeClass("open");
			$("#header").removeClass("all");
			$("html").removeClass("hide");
            $(".nav_bg").stop().slideUp(200);

			if($("#header").hasClass("hh")){
				$("#header .gnbBg").stop().animate({'height' : 0}, 200,function(){
					$("#header .gnbBg").css("opacity",0)
				});
				$("#header #pcMenu .gnbSub").css("height","auto").stop().slideUp(150);
			}else{
				$("#header #pcMenu .gnbSub").slideUp(150);
			}
		}
	});

	$("body").on("click", "#wrap[data-device='mobile'] .mMenu", function(){ // [MO] MENU OPEN
		$("#header .tSchArea").removeClass("open");
		$("#header").removeClass("sch");

		if(!$(".mMenu").hasClass("open")){
			$("#header").addClass("all");
			$(".mMenu").addClass("open");
			$("html").addClass("hide");
			$("#menuArea").addClass("open");
		}else{
			$("#header").removeClass("all");
			$("#header").removeClass("sch");
			$(".mMenu").removeClass("open");
			$("html").removeClass("hide");
			$("#menuArea").removeClass("open");
		}
	});
	$("body").on("click", "#menu.gnb>li:not('.one')>a", function(){// [MO] GNB OPEN
		var idx = $("#menu.gnb>li:not('.one')>a").index($(this));
		$("#menu.gnb>li:not('.one')>a").each(function(index){
			if(idx == index){
				if(!$(this).parent().hasClass("active")){
					$(this).parent().addClass("active");
					$(this).parent().find(".gnbSub").stop().slideDown(300);
				}else{
					$(this).parent().removeClass("active");
					$(this).parent().find(".gnbSub").stop().slideUp(300);
				}
			}else{
				$(this).parent().removeClass("active");
				$(this).parent().find(".gnbSub").stop().slideUp(300);
			}
		});
	});

	var confirmClicked;
	$("body").on("click", ".famLay", function(e){// FAMILY SITE
		if(!confirmClicked) {
			confirmClicked = true;
			$('body').on('scroll touchmove mousewheel', function(event) {
				event.preventDefault();
				event.stopPropagation();
				return false;
			});
		}

		//fullpage_api.setAllowScrolling(false);

		if($(this).hasClass("open")){
			$(this).removeClass("open")
			$(".famLay .in_fam").stop().slideUp(300);
		}else{
			$(this).addClass("open")
			$(".famLay .in_fam").stop().slideDown(300);
		}
	});
	$("body").on("mouseleave", ".famLay", function(){//  FAMILY SITE
		//fullpage_api.setAllowScrolling(true);

		$(".famLay").removeClass("open");
		$(".famLay .in_fam").stop().slideUp(300);

		if(confirmClicked) {
			$('body').off('scroll touchmove mousewheel');
			confirmClicked = false;
		}
	});

	$("body").on("click", ".language", function(){ // LANGUAGE 열기
		if(!$(".language").hasClass("open")){
			$(".language").addClass("open");
			$(".language>ul").stop().slideDown(300);
		}else{
			$(".language").removeClass("open");
			$(".language>ul").stop().slideUp(150);
		}
	});
	$("body").on("mouseleave", ".language", function(){ // LANGUAGE 닫기
		$(".language").removeClass("open");
		$(".language>ul").stop().slideUp(150);
	});
});

$(window).load(function(){
	$('img[usemap]').rwdImageMaps(); // 이미지 맵 불러오기

	$("#bo_cate h2").html($("#bo_cate_ul #bo_cate_on").text());
	$("body").on("click", "#wrap[data-device='mobile'] #bo_cate", function(){// 카테고리 열기/닫기
		if(!$(this).hasClass("open")){
			$(this).addClass("open");
			$("#bo_cate_ul").stop().slideDown(300);
		}else{
			$(this).removeClass("open");
			$("#bo_cate_ul").stop().slideUp(300);
		}
	});

	$(".search-result h2").html($(".search-result a.sch_on").text());
	$("body").on("click", "#wrap[data-device='mobile'] .search-result", function(){// 전체검색결과 열기/닫기
		if(!$(this).hasClass("open")){
			$(this).addClass("open");
			$(".search-result>ul").stop().slideDown(300);
		}else{
			$(this).removeClass("open");
			$(".search-result>ul").stop().slideUp(300);
		}
	});

	$("body").on("mouseenter", "#wrap[data-device='pc'] #snb .sMenu", function(){// 서브 메뉴 열기
		var idx = $(".sMenu").index($(this));
		$(".sMenu").each(function(index){
			if(idx == index){
				if(!$(this).hasClass("active")){
					$(this).addClass("active");
					$(this).find(".lnbSub").stop().slideDown(300);
				}else{
					$(this).removeClass("active");
					$(this).find(".lnbSub").stop().slideUp(300);
				}
			}else{
				$(this).removeClass("active");
				$(this).find(".lnbSub").stop().slideUp(300);
			}
		});
	});
	$("body").on("click", "#wrap[data-device='mobile'] #snb .sMenu", function(){// 서브 메뉴 열기
		var idx = $(".sMenu").index($(this));
		$(".sMenu").each(function(index){
			if(idx == index){
				if(!$(this).hasClass("active")){
					$(this).addClass("active");
					$(this).find(".lnbSub").stop().slideDown(300);
				}else{
					$(this).removeClass("active");
					$(this).find(".lnbSub").stop().slideUp(300);
				}
			}else{
				$(this).removeClass("active");
				$(this).find(".lnbSub").stop().slideUp(300);
			}
		});
	});
	$("body").on("mouseleave", "#snb", function(){// 서브 메뉴 닫기
		$(".sMenu").removeClass("active");
		$(".sMenu .lnbSub").stop().slideUp(300);
	});



    $("body").on("click", ".faqArea .qWrap", function (e) {// FAQ Script
        var target = e.target;
        var currentTarget = e.currentTarget;

		var target_tag = target.tagName;
		//console.log(target_tag, target, currentTarget)
		
		if(target_tag != "A" || target === currentTarget){
  

            var idx = $(".faqArea .qWrap").index($(this));

            $(".faqArea .qWrap").each(function (index) {
                if (idx == index) {
                    if (!$(this).parent().hasClass("active")) {
                        $(this).parent().addClass("active");
                        $(".faqArea .aWrap").eq(index).slideDown(300);
                    } else {
                        $(this).parent().removeClass("active");
                        $(".faqArea .aWrap").eq(index).slideUp(300);
                    }
                } else {
                    $(this).parent().removeClass("active");
                    $(".faqArea .aWrap").eq(index).slideUp(300);
                }
            });
        }
    });

	$("body").on("click", ".goTop", function(){ // Go Top
		$('html, body').stop().animate({scrollTop: $("html").offset().top}, 1000, "easeOutExpo");
	});

	if($(".layerCell")){
		$(".layerCell").wrap('<div class="layerArea"><div class="layerIn">');
		$(".layerIn").append('<div class="layerBgIn"></div>');
	}
});

/*[s] Scroll Event */
$(window).on('scroll', function(){// Scroll Event
	scroll_T = window.scrollY;
	ST_Event();
});
let progress;
function ST_Event(){
	progress = ScrollporgressBar();
	$('#progressBar').css("width", progress+'%');

	if($(".historyArea").hasClass("move")){
		var his_progress = historyprogressBar();
		$('#his_progress').css("height", "calc("+his_progress+"% - "+$(".historyArea>li:last-child").height()+"px)");
	}

	if(scroll_T > 0){
		$("a.goTop").addClass("open");
	}else{
		$("a.goTop").removeClass("open");
	}

	//scale_bg()

	//console.log("ST_Event "+scroll_T)
}
/*[e] Scroll Event */

/*[s] Resize Event */
var one_mo = true;
$(window).on('throttledresize', function(){
	window_W = $(window).width();
	window_H = $(window).height();
	WR_Event();
});
function WR_Event(){
	/*[s] 초기화 */
		$("#header").removeClass("sch");
		$(".tSchArea").removeClass("open");

		$("#bo_cate_ul").attr("style", "")

		if($("html").hasClass("hide")){
			$("html").removeClass("hide");
			$("#header").removeClass("all");
			$(".mMenu").removeClass("open");
			$("#menuArea").removeClass("open");
			$("#header").removeClass("sch");
			$(".tSchArea").removeClass("open");
		}

        $("#header .gnbBg").stop().animate({'height' : 0}, 200,function(){
			$("#header .gnbBg").css("opacity",0)
		});
        $("#header #pcMenu .gnbSub").css("height", "auto").stop().slideUp(150);
    
        gnbSub_H();
        
	/*[e] 초기화 */

	if($("html").hasClass("main")){ // 메인에만 사용
	}

	if($("html").hasClass("sub")){ // 서브에만 사용
	}

	if(window_W <= "1024"){
		$("#wrap").attr("data-device","mobile");

		setTimeout(function(){
			var h_top = $("#header").height();
			$("#menuBg, #menuArea").css("top", h_top);
		}, 300);

		if($("#mVisual")){
			$("#mVisual .slider").each(function(index){
				$(this).css("background-image", "url("+$(this).attr("data-mo")+")")
			});
		}

		if(one_mo){
			$("#menu>li:not('.one')>a").attr("pc-href", $("#menu>li:not('.one')>a").attr("href"));
			one_mo = false;
		}
		$("#menu>li:not('.one')>a").attr("href","javascript:void(0);");
	}else{
		$("#wrap").attr("data-device","pc");

		if($("#mVisual")){
			$("#mVisual .slider").each(function(index){
				//$(this).css("background-image", "url("+$(this).attr("data-pc")+")")
			});
		}

		if(!one_mo){
			$("#menu>li:not('.one')>a").attr("href", $("#menu>li:not('.one')>a").attr("pc-href"));
		}
	}

	if(window_W <= "840"){
		setTimeout(function(){
			var h_top = $("#header").height();
			$(".tSchArea .tSch_in").css("top", h_top);
		}, 300);
	}else{
		$(".tSch_in").attr("style", "");
	}

	//console.log("WR_Event "+window_W, "WR_Event "+window_H)
}
/*[e] Resize Event */

function gnbSub_H(){
	$("#header.hh #pcMenu .gnbSub").each(function(index){
		var th = $(this).height()+pcBgP;
		if(pcBgH < th){
			pcBgH = th;
		}
    });
    console.log(pcBgH)
}

function popFancy(name){// 팝업 열기 javascript:popFancy('#layer-schdule');
	new Fancybox([{src:name, type: "inline"},],
		{
			on: {
				"*": (event, fancybox, slide) => {
					//console.log(`event: ${event}`);
					/*
					if(event == "initLayout" && name == "#layer-schdule"){
					}
					*/

					if(event == "ready" && name == "#layer-time"){
						new daum.roughmap.Lander({
							"timestamp" : "1670986132765",
							"key" : "2dzbb",
							"mapWidth" : "",
							"mapHeight" : ""
						}).render();
					}

					if(event == "ready" && name == "#layer-juso"){
						new daum.roughmap.Lander({
							"timestamp" : "1670991194005",
							"key" : "2dzcx",
							"mapWidth" : "",
							"mapHeight" : ""
						}).render();
					}
				},
			},
		}
	);
}
// 팝업닫기
function popFancyClose(){
	Fancybox.close();
}

function ScrollporgressBar(){
	var maxY = document.documentElement.scrollHeight - document.documentElement.clientHeight;
	var scrollY = window.scrollY || document.documentElement.scrollTop;

	return (scrollY / maxY) * 100;
}

function historyprogressBar(){
	var html_H = $("html").height();
	var his_T = $(".historyArea").offset().top;
	var max_H = document.documentElement.clientHeight;

	var his_H2 = document.querySelector(".historyArea").clientHeight - $(".historyArea>li:last-child").height();
	var scrollY = window.scrollY || document.documentElement.scrollTop;

	var end_H = html_H - his_T - his_H2;

	var move_H = html_H - his_T - end_H;

	var his_H = his_T+(his_H2-(max_H - end_H));

	var move_Y = (scrollY / his_H) * 100;

	if(move_Y > 100){
		move_Y = 100
	}

	//console.log(his_T, his_H, scrollY, move_Y, document.querySelector(".historyArea").clientHeight)
	/*
	console.clear();

	console.log("history.offset.top = " + his_T)
	console.log("history.height = " + his_H2, $(".historyArea>li:last-child").height())
	console.log("html.height/2 = " + (html_H))
	console.log("end.height = " + (end_H))
	console.log("move.height = " + (move_H))
	console.log("window.height/2 = " + (max_H/2))
	console.log("scroll.top = " + scrollY)
	console.log("move.top = " + move_Y)
	*/
	//console.log(his_T, his_H, scrollY, move_Y)
	return move_Y;
}

// 레이어 열기
var layOne = true;
var scratchState = false;
function openLay(name, gNum){
	if(layOne == true){

		lyNums++;
		//console.log(lyNums);
		$(".layerBox").each(function(index){
			if($(this).hasClass(name)){
				layOne = false;
				$(this).layerScript({divs : name});

				if(name == "walletSortLay"){
					$(".layerCell").addClass("btm")
				}

				setTimeout(function(){
					if(name == "full_clauseLay"){
						full_clause(gNum)
						//$("input#numberLay_pass").attr('autofocus', 'autofocus');

						/*
						$("body").on("click", "input#numberLay_pass", function(){
							//alert("c")
							$("input#numberLay_pass").attr('autofocus', 'autofocus').focus();
						});
						$("input#numberLay_pass").click();
						*/
					}
				}, 100);

				setTimeout(function(){
					if(name == "scratchLay"){
						scratchEvent();
					}
				}, 100);
			}
		});
	}
}
// 레이어 닫기
function layerClose(name){
	$(".layerBox").each(function(index){
		if($(this).hasClass(name)){
			var e = $(this);

			e.attr("lyNums", "");
			e.hide().attr("style","");

			lyNums --;
			if(lyNums == 0){
				$("html").css("overflow-y","auto");
				$("body").removeClass("lyOn");
				$(".layerArea").removeClass("one");
				$(".layerBox").attr("lyNums", "").hide();
			}
		}

		if($(this).attr("lyNums") == 1){
			$(this).show();
			$(".layerArea").removeClass("two");
			$(".layerArea").addClass("one");
		}
	});
}
// Plugin Script
jQuery(function($){
	//[s] Layer Script
	$.fn.layerScript = function(o){
		o = $.extend({
			divs : ''
		}, o || {});

		var e = $(this),
			  //bg = $('<div id="layerBg"></div>'),
			  //bgIn = $('<div class="layerBgIn"></div>'),
			  ly_w,
			  ly_h,
			  closeDiv = o.divs;

		e.attr("lyNums", lyNums);
		$("body").attr("lyNums", lyNums);
		// 열기
		if(!$("body").hasClass("lyOn")){
			$("html").css("overflow-y","hidden");
			$("body").addClass("lyOn");
			$(".layerArea").addClass("one");
		}
		if(lyNums == 2){
			$(".layerArea").removeClass("one");
			$(".layerArea").addClass("two");
			$(".layerBox").hide();
			e.css("z-index",13);
		}

		e.show();
		layOne = true;

		setTimeout(function(){
		}, 300);

		// 닫기
		$(this).find(".closeLy").off("click");
		$(this).find(".closeLy").on('click', function(){
			layerClose(closeDiv);
		});
		$(this).find(".btnArea>.closeLy").off("click");
		$(this).find(".btnArea>.closeLy").on('click', function(){
			layerClose(closeDiv);
		});
	}
	//[e] Layer Script

	//[s] Img Over Script
	$.fn.iOverScript = function(o){
		o = $.extend({
			btns : '',
			bg : '',
			speed : 700
		}, o || {});

		var e = $(this);

		// 활성화
		e.on("mouseenter", o.btns, function(event){
			var idx = $(o.btns).index($(this));
			point_ray("on", idx, event);
		});
		// 비활성화
		e.on("mouseleave", o.btns, function(event){
			var idx = $(o.btns).index($(this));
			point_ray("off", idx, event);
		});

		function point_ray(directions, nums, event){
			e.find(o.btns).each(function(index){
				if(nums == index){
					w = $(this).width();
					h = $(this).height();
					x = ( event.pageX - $(this).offset().left - ( w/2 )) * ( w > h ? ( h/w ) : 1 ),
					y = ( event.pageY - $(this).offset().top  - ( h/2 )) * ( h > w ? ( w/h ) : 1 ),
					direction = Math.round( ( ( ( Math.atan2(y, x) * (180 / Math.PI) ) + 180 ) / 90 ) + 3 )  % 4;

					if(directions == "on"){
						$(this).find(o.bg).show();
						if(direction == 0) {
							$(this).find(o.bg).css({"top":-h, "left":0});
						} else if(direction == 1) {
							$(this).find(o.bg).css({"top":0, "left":w});
						} else if(direction == 2) {
							$(this).find(o.bg).css({"top":h, "left":0});
						} else {
							$(this).find(o.bg).css({"top":0, "left":-w});
						}
						$(this).find(o.bg).stop().animate({top:0, left:0}, o.speed, "easeOutExpo");
					}else if(directions == "off"){
						if(direction == 0) {
							$(this).find(o.bg).stop().animate({top:-h, left:0}, o.speed, "easeOutExpo", function(){$(this).parent().find(o.bg).hide();});
						} else if(direction == 1) {
							$(this).find(o.bg).stop().animate({top:0, left:w}, o.speed, "easeOutExpo", function(){$(this).parent().find(o.bg).hide();});
						} else if(direction == 2) {
							$(this).find(o.bg).stop().animate({top:h, left:0}, o.speed, "easeOutExpo", function(){$(this).parent().find(o.bg).hide();});
						} else {
							$(this).find(o.bg).stop().animate({top:0, left:-w}, o.speed, "easeOutExpo", function(){$(this).parent().find(o.bg).hide();});
						}
					}
				}
			});
		}
	}
	//[e] Img Over Script
});

// 따라다니는 베너
var area_TT;
(function($) {
	$.fn.followingBanner = function(options) {
		var defaults = {
			direction : "top",
		};
		var settings = $.extend( {}, defaults, options );

		return this.each(function(index) {
			let ST = 0;
			let WW = 0;
			let WH = 0;
			var total_L = $(".followingBanner.top").length;
			var s = settings;
			var obj = $(this);
			var area_T = obj.offset().top;
			var area_H = obj.outerHeight();
			var area_Ts;

			obj.attr("data-top", area_T);
			obj.wrap('<div id="'+obj.attr("class")+'" class="followingBanner" style="height:'+area_H+'px"></div>');
			$("#"+obj.attr("class")).addClass(s.direction)

			$(window).trigger('resize');
			$(window).on('resize',function(){
				WH = $(window).height();
				area_T = obj.closest(".followingBanner").offset().top;
				area_H = obj.outerHeight();
				obj.closest(".followingBanner").height(area_H)
				if(s.direction == "top" && total_L > 0){
					//alert($(".followingBanner.top").eq(total_L).height())
					area_TT = area_T - $(".followingBanner.top").eq(total_L-1).height();
					area_T = area_TT;
					area_Ts = $(".followingBanner.top").eq(total_L-1).height();
					//alert(area_T)
					console.log(ST, area_T + $(".followingBanner.top").eq(total_L-1).height(), $(".followingBanner.top").eq(total_L-1).height(), total_L)
				}
			});

			$(window).on('wheel',function(){
				ST = window.scrollY || window.pageYOffset;

				if(s.direction == "top"){
					if( ST >= area_T){
						obj.attr("style", "position: fixed; top:"+area_Ts+"px");
					}else{
						obj.attr("style" ,"")
						//obj.unwrap();
					}
				}

				if(s.direction == "bottom"){
					if( (ST+WH-area_H) >= area_T){
						obj.attr("style" ,"position: static;")
					}else{
						obj.attr("style", "");
						//obj.unwrap();
					}
				}

				//console.log(ST+"__"+area_T+"__"+(ST+WH-area_H))
			});

			$(window).on('scroll',function(){
				$(window).trigger('wheel');
			});
			$(window).trigger('resize');
			$(window).trigger('wheel');
			$(window).trigger('scroll');
		});
	};
})(jQuery);

// 멀티 텝버튼
(function($) {
	$.fn.multiTab = function(options) {
		var defaults = {
			//direction : "top",
		};
		var settings = $.extend( {}, defaults, options );

		return this.each(function(index) {
			var tab = $(this);
			var tab_name = tab.find(".name");
			var tab_list = tab.find(".multi-list");
			var tab_trigger = tab.find(".multi-list>li");
			var tab_select = tab.find(".multi-list>li.active");

			tab_name.html(tab_select.text());


			tab_trigger.on("click", function(){// 카테고리 열기/닫기
				tab_trigger.removeClass("active");

				$(this).addClass("active");
				tab_name.html($(this).text());
			});

			tab.on("click", function(){// 카테고리 열기/닫기
				if(window.matchMedia("(max-width: 840px)").matches){
					if(!$(this).hasClass("open")){
						$(".multi-tab .multi-list").stop().slideUp(300);
						$(".multi-tab").removeClass("open");

						$(this).addClass("open");
						tab_list.stop().slideDown(300);
					}else{
						$(this).removeClass("open");
						tab_list.stop().slideUp(300);
					}
				}
			});

			$(window).on('throttledresize', function(){// Resize Event
				$(".multi-list").attr("style", "");
			}).resize();
		});
	};
})(jQuery);

/* 해더 스크롤시 색상 변경 */
var scrollTop;
$(window).scroll(function() {

    scrollTop = $(this).scrollTop();
    if (scrollTop >= 1) {
        $('#header').addClass('scrolled');
    } else {
        $('#header').removeClass('scrolled');
    }

}).trigger("scroll");
