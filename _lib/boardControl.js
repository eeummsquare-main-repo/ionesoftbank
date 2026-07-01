if (langCode=="eng"){
	altMsg_enterSearchTerm = "Please enter your search term."
	altMsg_enterPassword = "Please enter your password."
	altMsg_enterName = "Please input your name."
	altMsg_enterTel = "Please input your Phone Number."
	altMsg_enterTitle = "Please input your title."
	altMsg_enterEmail = "Please input your email address."
	altMsg_enterContent = "Please input your message."
	altMsg_imgFormat = "Please upload an image file."
	altMsg_selectCategory = "Please select the category."
	altMsg_CheckPrivacyPolicy = "Please check the box if you agree to the Privacy Policy."
	altMsg_ConfirmRemove = "Would you like to delete your posting?"
	altMsg_ConfirmModify = "Would you like to edit your posting?"
}else if (langCode=="chi"){
	altMsg_enterSearchTerm = "请输入搜索词。"
	altMsg_enterPassword = "请输入密码。"
	altMsg_enterName = "请输入你的名字"
	altMsg_enterTel = "请输入您的联系信息。"
	altMsg_enterEmail = "请输入您的电子邮件地址。"
	altMsg_enterTitle = "请输入标题。"
	altMsg_enterContent = "请输入您的内容。"
	altMsg_imgFormat = "请上传正确的图片。"
	altMsg_selectCategory = "请选择一个类别。"
	altMsg_CheckPrivacyPolicy = "请检查您是否同意隐私政策。"
	altMsg_ConfirmRemove = "您确定要删除该帖子吗？"
	altMsg_ConfirmModify = "您要编辑吗？"
}else if (langCode=="jap"){
	altMsg_enterSearchTerm = "検索用語を入力してください。"
	altMsg_enterPassword = "パスワードを入力してください。"
	altMsg_enterName = "名前を入力してください。"
	altMsg_enterTel = "連絡先を入力してください。"
	altMsg_enterEmail = "メールアドレスを入力してください。"
	altMsg_enterTitle = "タイトルを入力してください。"
	altMsg_enterContent = "内容を入力してください。"
	altMsg_imgFormat = "正しいイメージをアップロードしてください。"
	altMsg_selectCategory = "分類を選択してください。"
	altMsg_CheckPrivacyPolicy = "プライバシーポリシーに同意するかどうかをチェックしてください。"
	altMsg_ConfirmRemove = "記事を削除しますか？"
	altMsg_ConfirmModify = "修正しますか？"
}else{
	altMsg_enterSearchTerm = "검색어를 입력해주세요."
	altMsg_enterPassword = "비밀번호를 입력하세요."
	altMsg_enterName = "이름을 입력하세요."
	altMsg_enterTel = "연락처를 입력하세요."
	altMsg_enterEmail = "이메일 주소를 입력하세요."
	altMsg_enterTitle = "제목을 입력하세요."
	altMsg_enterContent = "내용을 입력해 주세요."
	altMsg_imgFormat = "올바른 이미지를 업로드해 주세요."
	altMsg_selectCategory = "분류를 선택하세요."
	altMsg_CheckPrivacyPolicy = "개인정보 취급방침 동의 여부에 체크해주세요."
	altMsg_ConfirmRemove = "게시물을 삭제하시겠습니까?"
	altMsg_ConfirmModify = "수정하시겠습니까?"
}

function topSearch(obj){
	if (obj.searchstr.value==""){
		alert(altMsg_enterSearchTerm);
		obj.searchstr.focus();
		return;
	}
	obj.submit();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function goPwdpage(sort,index){
	document.boardActfrm.idx.value=index;

	$.ajax({
		type:"post",
		url: "../board/bbs_pwdinput.asp",
		data:{"sort":sort,"idx":index},
		dataType:"html",
		async: true,
		beforeSend : function(){
			popupLoadingOpen();
		}
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}

function goMemberCheck(sort,index){
	var f=document.boardActfrm;
	if (sort=="modify"){
		f.action="";
		f.mode.value=sort;
	}else{
		var val = confirm(altMsg_ConfirmRemove);
		if (val){
			f.action="../board/ok_bbsDel.asp";
		}
	}
	f.idx.value=index;
	f.submit();
}

//게시판 비밀번호 컨트롤///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function goPwdpage_main(sort,index,bbscode,actpage){
	var f=document.boardActfrm;
	f.action=actpage;
	f.BBSCode.value=bbscode;
	f.sort.value=sort;
	f.idx.value=index;

	$.ajax({
		type:"post",
		url: "../board/bbs_pwdinput.asp",
		data:{"sort":sort,"idx":index},
		dataType:"html",
		async: true,
		beforeSend : function(){
			popupLoadingOpen();
		}
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}

function boardcheckpwd(sort){
	var f=document.passFrm;

	if(f.pwd.value==""){
		alert(altMsg_enterPassword);
		f.pwd.focus();
		return;
	}
	var params = $("#passFrm").serialize();
	$.ajax({type:"POST", url:"../ajaxpage/boardPassSet.asp",data:params,dataType:"html"
	}).done(function(msg){
		if (msg!="")	{
			alert(msg);
		}else{
			if(sort=="view"){
				document.boardActfrm.mode.value="view";
			}else if(sort=="bbsmodify"){
				document.boardActfrm.action=document.boardActfrm.prepage.value;
				document.boardActfrm.mode.value="modify";
				document.boardActfrm.prepage.value="";
			}else if(sort=="bbsdel"){
				document.boardActfrm.action='../board/ok_bbsdel.asp';
			}
			document.boardActfrm.submit();
		}
	});
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//게시판 함수//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function searchGo(){
	var f=document.searchfrm;
	f.submit();
}

function quickSendit(){
	var f=document.quickFrm;

	if( document.getElementById("selectBoardsort")){
		if(f.boardsort.value==""){
			alert(altMsg_selectCategory);
			f.boardsort.focus();
			return;
		}
	}
	if(f.writer.value==""){
		alert(altMsg_enterName);
		f.writer.focus();
		return;
	}
	if (f.email){
		if(f.email.value==""){
			alert(altMsg_enterEmail);
			f.email.focus();
			return;
		}
		emailChk = isValidEmailOnce( f.email.value)
	}
	if ( $("#qInCheck").length > 0){
		if (!$("#qInCheck").is(":checked")){
			alert(altMsg_CheckPrivacyPolicy);
			return;
		}
	}
	f.submit();
}

function quickSendit1(){
	var f=document.quickFrm1;

	if( document.getElementById("selectBoardsort")){
		if(f.boardsort.value==""){
			alert(altMsg_selectCategory);
			f.boardsort.focus();
			return;
		}
	}
	if(f.writer.value==""){
		alert(altMsg_enterName);
		f.writer.focus();
		return;
	}
	if(f.tel[0].value==""){
		alert(altMsg_enterTel);
		f.tel[0].focus();
		return;
	}
	if(f.tel[1].value==""){
		alert(altMsg_enterTel);
		f.tel[1].focus();
		return;
	}
	if(f.tel[2].value==""){
		alert(altMsg_enterTel);
		f.tel[2].focus();
		return;
	}
	if ( $("#qInCheck1").length > 0){
		if (!$("#qInCheck1").is(":checked")){
			alert(altMsg_CheckPrivacyPolicy);
			return;
		}
	}
	f.submit();
}

function onlineSendit(){
	var f=document.boardfrm;

	if( document.getElementById("selectBoardsort")){
		if(f.boardsort.value==""){
			alert(altMsg_selectCategory);
			f.boardsort.focus();
			return;
		}
	}
	if(f.writer.value==""){
		alert(altMsg_enterName);
		f.writer.focus();
		return;
	}
	if(f.tel){
		if ($("form[name=boardfrm] input[name=tel]").length!=1){
			if(f.tel[0].value==""){
				alert(altMsg_enterTel);
				f.tel[0].focus();
				return;
			}
			if(f.tel[1].value==""){
				alert(altMsg_enterTel);
				f.tel[1].focus();
				return;
			}
			if(f.tel[2].value==""){
				alert(altMsg_enterTel);
				f.tel[2].focus();
				return;
			}
		}else{
			if(f.tel.value==""){
				alert(altMsg_enterTel);
				f.tel.focus();
				return;
			}
		}
	}
	if(f.email){
		var emailChk
		if ($("form[name=boardfrm] input[name=email]").length!=1){
			if(f.email[0].value==""){
				alert(altMsg_enterEmail);
				f.email[0].focus();
				return;
			}
			if(f.email[1].value==""){
				alert(altMsg_enterEmail);
				f.email[1].focus();
				return;
			}
			emailChk = isValidEmail( f.email[0].value, f.email[1].value )
		}else{
			if(f.email.value==""){
				alert(altMsg_enterEmail);
				f.email.focus();
				return;
			}
			emailChk = isValidEmailOnce( f.email.value)
		}
	}

	if(f.pass){
		if(f.pass.value==""){
			alert(altMsg_enterPassword);
			f.pass.focus();
			return;
		}
	}
	if(f.title){
		if(f.title.value==""){
			alert(altMsg_enterTitle);
			f.title.focus();
			return;
		}
	}

	f.editorYN.value=0;

	if(f.imgfiles){
		if(uploadImg_check(f.imgfiles.value,altMsg_imgFormat)==false){
			return;
		}
	}
	if ( $("#onlineagree").length > 0){
		if (!$("#onlineagree").is(":checked")){
			alert(altMsg_CheckPrivacyPolicy);
			return;
		}
	}
	f.submit();
}

function sendit(){
	var f=document.boardfrm;
	var bbscode = f.bbscode.value;

	if( document.getElementById("selectBoardsort")){
		if(f.boardsort.value==""){
			alert(altMsg_selectCategory);
			f.boardsort.focus();
			return;
		}
	}
	if(f.writer.value==""){
		if (bbscode=="5"){
			alert("지점명을 입력하세요.");
		}else{
			alert(altMsg_enterName);
		}
		f.writer.focus();
		return;
	}
	if(f.tel){
		if ($("form[name=boardfrm] input[name=tel]").length!=1){
			if(f.tel[0].value==""){
				alert(altMsg_enterTel);
				f.tel[0].focus();
				return;
			}
			if(f.tel[1].value==""){
				alert(altMsg_enterTel);
				f.tel[1].focus();
				return;
			}
			if(f.tel[2].value==""){
				alert(altMsg_enterTel);
				f.tel[2].focus();
				return;
			}
		}else{
			if(f.tel.value==""){
				alert(altMsg_enterTel);
				f.tel.focus();
				return;
			}
		}
	}
	if(f.email){
		var emailChk
		if ($("form[name=boardfrm] input[name=email]").length!=1){
			if(f.email[0].value==""){
				alert(altMsg_enterEmail);
				f.email[0].focus();
				return;
			}
			if(f.email[1].value==""){
				alert(altMsg_enterEmail);
				f.email[1].focus();
				return;
			}
			emailChk = isValidEmail( f.email[0].value, f.email[1].value )
		}else{
			if(f.email.value==""){
				alert(altMsg_enterEmail);
				f.email.focus();
				return;
			}
			emailChk = isValidEmailOnce( f.email.value)
		}
	}

	if(f.pass){
		if(f.pass.value==""){
			alert(altMsg_enterPassword);
			f.pass.focus();
			return;
		}
	}
	if(f.title){
		if(f.title.value==""){
			alert(altMsg_enterTitle);
			f.title.focus();
			return;
		}
	}

	if(f.content){
		if (f.content.value==""){
			alert(altMsg_enterContent);
			f.content.focus();
			return;
		}
	}
	f.editorYN.value=0;

	if(f.imgfiles){
		if(uploadImg_check(f.imgfiles.value,altMsg_imgFormat)==false){
			return;
		}
	}
	if ( $("#bbsagree").length > 0){
		if (!$("#bbsagree").is(":checked")){
			alert(altMsg_CheckPrivacyPolicy);
			return;
		}
	}
	f.submit();
}
function modifysendit(){
	var f=document.boardfrm;
	var bbscode = f.bbscode.value;

	if( document.getElementById("selectBoardsort")){
		if(f.boardsort.value==""){
			alert(altMsg_selectCategory);
			f.boardsort.focus();
			return;
		}
	}
	if (f.writer){
		if(f.writer.value==""){
			alert(altMsg_enterName);
			f.writer.focus();
			return;
		}
	}

	if(f.pass){
		if(f.pass.value==""){
			alert(altMsg_enterPassword);
			f.pass.focus();
			return;
		}
	}

	if(f.title.value==""){
		alert(altMsg_enterTitle);
		f.title.focus();
		return;
	}
	if(f.content){
		if (f.content.value==""){
			alert(altMsg_enterContent);
			f.content.focus();
			return;
		}
	}
	f.editorYN.value=0;

	if(f.imgfiles){
		if(f.imgDel_Chk.checked){
			if(uploadImg_check(f.imgfiles.value,altMsg_imgFormat)==false){
				return;
			}
		}
	}
	if (confirm(altMsg_ConfirmModify)){
		f.submit();
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//게시판 코멘트 컨트롤/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var gb_ViewDivID="";

function viewBoardCommentArea(index,bbscode,page){
	var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
	$.ajax({type:"POST", url:"../ajaxpage/boardCommentArea.asp",data:params,dataType:"html"
	}).done(function(msg){
		$("#boardCommentDiv").html(msg)
	});
}
function boardcommentGo(){
	f=document.commentfrm;

	if(f.name){
		if(f.name.value==""){
			alert("이름을 입력해주세요.");
			f.name.focus();
			return;
		}
	}
	if(f.pwd){
		if(f.pwd.value==""){
			alert("비밀번호를 입력해주세요.");
			f.pwd.focus();
			return;
		}
	}
	if(f.content.value==false){
		alert("내용을 입력해주세요.");
		f.content.focus();
		return;
	}

	var params = $("#commentfrm").serialize();
	$.ajax({type:"POST", url:"../ajaxpage/BoardCommentAddOK.asp",data:params,dataType:"script"
	}).done(function(msg){
	});
}
function viewboardCommentReply(targetDiv,index,bbscode,page){
	if(gb_ViewDivID!=""){
		document.getElementById(gb_ViewDivID).style.display="none";
	}
	gb_ViewDivID=targetDiv;
	document.getElementById(gb_ViewDivID).style.display="inline";

	var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
	$.ajax({type:"POST", url:"../ajaxpage/boardCommentReply.asp",data:params,dataType:"html"
	}).done(function(msg){
		document.getElementById(targetDiv).innerHTML=msg;
	});
}
function boardcommentReply(thisFORM){
	var f=eval(thisFORM)
	
	targetPage="../ajaxpage/BoardCommentReplyOK.asp"

	if(f.name){
		if(f.name.value==""){
			alert("이름을 입력해주세요.");
			f.name.focus();
			return;
		}
	}
	if(f.pwd){
		if(f.pwd.value==""){
			alert("비밀번호를 입력해주세요.");
			f.pwd.focus();
			return;
		}
	}
	if(f.content.value==false){
		alert("내용을 입력해주세요.");
		f.content.focus();
		return;
	}

	var params = $("#"+thisFORM).serialize();

	$.ajax({type:"POST", url:targetPage,data:params,dataType:"script"
	}).done(function(msg){
	});
}
function boardcommentEdit(thisFORM){
	var f=eval(thisFORM)
	
	targetPage="../ajaxpage/BoardCommentEditOK.asp"

	if(f.content.value==false){
		alert("내용을 입력해주세요.");
		f.content.focus();
		return;
	}

	var params = $("#"+thisFORM).serialize();
	$.ajax({type:"POST", url:targetPage,data:params,dataType:"script"
	}).done(function(msg){
	});
}
function boardcommentEditView(targetDiv,memYN,index,bbscode,page){
	if(gb_ViewDivID!=""){
		document.getElementById(gb_ViewDivID).style.display="none";
	}
	gb_ViewDivID=targetDiv;
	document.getElementById(gb_ViewDivID).style.display="inline";

	if(memYN==''){
		$.ajax({
			type:"post",
			url: "../ajaxpage/boardCommentPwdinput.asp",
			data:{"mode":"modify","idx":index,"bbscode":bbscode,"page":page,"targetDiv":targetDiv},
			dataType:"html",
			async: true,
			beforeSend : function(){
				popupLoadingOpen();
			}
		}).done(function(data){
			fnLayerPopupOpen(data);
		})
	}else{
		var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
		$.ajax({type:"POST", url:"../ajaxpage/boardCommentEdit.asp",data:params,dataType:"html"
		}).done(function(msg){
			if(msg=="noData"){
				alert("게시물 정보를 찾을수 없습니다.\n다시시도해주세요.");
			}else if(msg=="noMember"){
				alert("작성자 본인만 수정가능합니다.");
			}else{
				document.getElementById(targetDiv).innerHTML=msg;
			}
		});
	}
}
function viewboardCommentPwdInput(targetDiv,memYN,index,bbscode,page){
	if(memYN==''){
		$.ajax({
			type:"post",
			url: "../ajaxpage/boardCommentPwdinput.asp",
			data:{"idx":index,"bbscode":bbscode,"page":page,"targetDiv":targetDiv},
			dataType:"html",
			async: true,
			beforeSend : function(){
				popupLoadingOpen();
			}
		}).done(function(data){
			fnLayerPopupOpen(data);
		})
	}else{
		var val=confirm("해당 코멘트를 삭제하시겠습니까?");
		if (val){

			var params = "idx="+index+"&bbscode="+bbscode+"&page="+page;
			$.ajax({type:"POST", url:"../ajaxpage/boardCommentDel.asp",data:params,dataType:"script"
			}).done(function(msg){
			});
		}
	}
}
function boardcommentcheckpwd(){
	if(document.boardcommentpwdchk.pwd.value==""){
		alert(altMsg_enterPassword);
		document.boardcommentpwdchk.pwd.focus();
		return;
	}
	if (document.boardcommentpwdchk.mode.value=="modify"){
		targetDiv=document.boardcommentpwdchk.targetDiv.value;
		var params = $("#boardcommentpwdchk").serialize();

		$.ajax({type:"POST", url:"../ajaxpage/boardCommentEdit.asp",data:params,dataType:"html"
		}).done(function(msg){
			if(msg=="noData"){
				alert("게시물 정보를 찾을수 없습니다.\n다시시도해주세요.");
			}else if(msg=="noPassword"){
				alert("비밀번호가 일치하지 않습니다.");
			}else if(msg=="noMember"){
				alert("작성자 본인만 수정가능합니다.");
			}else{
				document.getElementById(targetDiv).innerHTML=msg;
				fnLayerPopupClose();
			}
		});
	}else{
		var params = $("#boardcommentpwdchk").serialize();
		$.ajax({type:"POST", url:"../ajaxpage/boardCommentDel.asp",data:params,dataType:"script"
		}).done(function(msg){
			fnLayerPopupClose();
		});
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////