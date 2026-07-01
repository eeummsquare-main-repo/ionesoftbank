//게시판 코멘트 컨트롤///////////////////////////////
var gb_ViewDivID="";

function viewBoardCommentArea(index,bbscode,page){
	var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
	$.ajax({type:"POST", url:"/backoffice/ajaxpage/boardCommentArea.asp",data:params,dataType:"html",
	}).done(function(data){
		document.getElementById("boardCommentDiv").innerHTML=data;	
	});
}

function boardcommentGo(){
	f=document.commentfrm;

	if(f.content.value==false){
		alert("내용을 입력해주세요.");
		f.content.focus();
		return;
	}

	var params = $("#commentfrm").serialize();
	$.ajax({type:"POST", url:"/backoffice/ajaxpage/BoardCommentAddOK.asp",data:params,dataType:"script"
	}).done(function(data){

	});
}

function viewboardCommentReply(targetDiv,index,bbscode,page){
	if(gb_ViewDivID!=""){
		document.getElementById(gb_ViewDivID).style.display="none";
	}
	gb_ViewDivID=targetDiv;
	document.getElementById(gb_ViewDivID).style.display="inline";

	var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
	$.ajax({type:"POST", url:"/backoffice/ajaxpage/boardCommentReply.asp",data:params,dataType:"html"
	}).done(function(data){
		document.getElementById(targetDiv).innerHTML=data;
	});
}

function boardcommentReply(thisFORM){
	var f=eval(thisFORM)

	if(f.content.value==false){
		alert("내용을 입력해주세요.");
		f.content.focus();
		return;
	}
	var params = $("#"+thisFORM).serialize();

	$.ajax({type:"POST", url:"/backoffice/ajaxpage/BoardCommentReplyOK.asp",data:params,dataType:"script"
	}).done(function(data){

	});
}

function viewboardCommentPwdInput(memYN,temp,index,bbscode,page){
	var val=confirm("해당 코멘트를 삭제하시겠습니까?");
	if (val){
		var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
		$.ajax({type:"POST", url:"/backoffice/ajaxpage/boardCommentDel.asp",data:params,dataType:"script"
		}).done(function(data){

		});
	}
}

function boardcommentEditView(targetDiv,index,bbscode,page){
	if(gb_ViewDivID!=""){
		document.getElementById(gb_ViewDivID).style.display="none";
	}
	gb_ViewDivID=targetDiv;
	document.getElementById(gb_ViewDivID).style.display="inline";

	var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;

	$.ajax({type:"POST", url:"/backoffice/ajaxpage/boardCommentEdit.asp",data:params,dataType:"html"
	}).done(function(msg){
		if(msg=="noData"){
			alert("게시물 정보를 찾을수 없습니다.\n다시시도해주세요.");
		}else{
			document.getElementById(targetDiv).innerHTML=msg;
		}
	});
}

function boardcommentEditGo(thisFORM){
	var f=eval(thisFORM)

	if(f.content.value==false){
		alert("내용을 입력해주세요.");
		f.content.focus();
		return;
	}

	var params = $("#"+thisFORM).serialize();

	$.ajax({type:"POST", url:"/backoffice/ajaxpage/BoardCommentEditOK.asp",data:params,dataType:"script"
	}).done(function(msg){

	});
}
/////////////////////////////////////////////////////