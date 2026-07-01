$(window).load(function(){	
	$(".ajaxBBS").each(function(){
		var bcode = $(this).attr("bbscode");
		var boardsort = $(this).attr("boardsort");
		var btype = $(this).attr("bbstype");
		var tObj = $(this);

		if (btype=="gallery"){
			bbsListUrl = "../../board_ajax/bbs_gallery.asp"
		}else{
			bbsListUrl = "../../board_ajax/bbs_list.asp"
		}

		$.ajax({
			type:"post",
			url: bbsListUrl,
			data:{"bbscode":bcode, "serboardsort":boardsort},
			dataType:"html",
			async: true
		}).done(function(data){
			tObj.html(data)
		})
	});

	$("body").on("click", ".bbsPageing a", function(){
		var page = $(this).attr("datapg");
		var tObj = $(this).parents(".ajaxBBS");
		if (page){
			tObj.find("form[name=boardActfrm]>input[name=page]").val(page);
			ajaxBBsList(tObj);
		}
	});

	$("body").on("click", "#bbsSearchBtn", function(){
		var page = 1;
		var search = $(".search_top select[name=search]").val();
		var searchStr = $(".search_top input[name=searchstr]").val();
		var tObj = $(this).parents(".ajaxBBS");
		if (page){
			tObj.find("form[name=boardActfrm]>input[name=page]").val(page);
			tObj.find("form[name=boardActfrm]>input[name=search]").val(search);
			tObj.find("form[name=boardActfrm]>input[name=searchstr]").val(searchStr);

			ajaxBBsList(tObj);
		}
	});

	$("body").on("click", ".bbsCon", function(){
		var idx = $(this).attr("dataidx");
		var tObj = $(this).parents(".ajaxBBS");
		if (idx){
			tObj.find("form[name=boardActfrm]>input[name=idx]").val(idx);
			ajaxBBsView(tObj);
		}
	});

	$("body").on("click", ".bbsListBtn", function(){
		var tObj = $(this).parents(".ajaxBBS");

		ajaxBBsList(tObj);
	});
});

function ajaxBBsView(tObj){
	var bcode = tObj.attr("bbscode");
	var boardsort = tObj.attr("boardsort");
	var btype = tObj.attr("bbstype");
	var params = tObj.find("form[name=boardActfrm]").serialize();

	$.ajax({
		type:"post",
		url: "../../board_ajax/bbs_view.asp",
		data:params,
		dataType:"html",
		async: true
	}).done(function(data){
		tObj.html(data);

		moveArea((tObj.offset().top)-50);
	})
}

function ajaxBBsList(tObj){
	var bcode = tObj.attr("bbscode");
	var boardsort = tObj.attr("boardsort");
	var btype = tObj.attr("bbstype");

	if (btype=="gallery"){
		bbsListUrl = "../../board_ajax/bbs_gallery.asp"
	}else if (btype=="product"){
		bbsListUrl = "../../board_ajax/bbs_Product.asp"
	}else{
		bbsListUrl = "../../board_ajax/bbs_list.asp"
	}
	var params = tObj.find("form[name=boardActfrm]").serialize();

	$.ajax({
		type:"post",
		url: bbsListUrl,
		data:params,
		dataType:"html",
		async: true
	}).done(function(data){
		tObj.html(data);
		thumbnail();
		moveArea((tObj.offset().top)-50);
	})
}