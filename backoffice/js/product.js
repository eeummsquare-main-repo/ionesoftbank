$(document).ready(function(){
	$(".specAdd").click(function(){
		var html = $("#specTB tbody tr:eq(0)").html();
		var limitRow = 10;

		if (limitRow == $("#specTB tbody tr").size())	{
			alert("더이상 추가하실 수 없습니다.");
		}else{
			$("#specTB tbody").append("<tr>"+html+"</tr>");
			$("#specTB tbody tr").last().find("input, textarea").val("");
			$("#specTB tbody tr").last().find("select").val("1");
		}
	});

	$(document).on("click",".specDel",function(){
		var ckCnt = $('input:checkbox[name="specCheckidx"]:checked').length;
		if (ckCnt==0){
			alert("삭제하실 행을 선택해주세요.");
			return;
		}
		$('input:checkbox[name="specCheckidx"]').each(function(i) {
			if ($(this).is(":checked"))	{
				if ($("#specTB tbody tr").size()==1){
					$("#specTB tbody").find("input, textarea").val("");
					$("#specTB tbody").find("select").val("1");
					$("#specTB tbody").find("input:checkbox").attr("checked", false);
				}else{
					$(this).parent().parent().remove();
				}
			}
		 });
	});

	$(document).on("click",".specCopy",function(){
		var ckCnt = $('input:checkbox[name="specCheckidx"]:checked').length;
		if (ckCnt==0){
			alert("복사하실 행을 선택해주세요.");
			return;
		}
		$('input:checkbox[name="specCheckidx"]').each(function(i) {
			if ($(this).is(":checked"))	{
				var obj = $(this).closest('tr');
				obj.find("input:checkbox").attr("checked", false);

				var html = obj.clone(true);
				obj.after(html);
				obj.next().find("select").val( obj.find("select").val() )
			}
		 });
	});
});

//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 시작 ++++++++++++++++++++++++++++++++
var cateName1='';
var cateName2='';
var cateName3='';

function select2Del(){
	var cnt=goods_form.select2.length
	for(var i=0;i<cnt;i++){ goods_form.select2.remove(0); }
	if(goods_form.select3){ select3Del(); }
}
function select3Del(){
	var cnt=goods_form.select3.length
	for(var i=0;i<cnt;i++){ goods_form.select3.remove(0); }
}
function change1(index){
	if(index != -1){
		var selVal = depth1_value[goods_form.select1.selectedIndex];
		cateName1=depth1[goods_form.select1.selectedIndex];

		if(goods_form.select2){
			select2Del();
			if(depth2[index].length!=0){
				for(i=0;i<depth2[index].length;i++){
					goods_form.select2.options.add(new Option(depth2[index][i],depth2_value[index][i]));
				}
			}
		}
	}
}
function change2(index){
	if(index != -1){
		if(goods_form.select3){
			select3Del();
			if(depth3[goods_form.select1.selectedIndex][index].length!=0){
				for(i=0;i<depth3[goods_form.select1.selectedIndex][index].length;i++){
					goods_form.select3.options.add(new Option(depth3[goods_form.select1.selectedIndex][index][i],depth3_value[goods_form.select1.selectedIndex][index][i]));
				}
			}
		}
		cateName2=depth2[goods_form.select1.selectedIndex][goods_form.select2.selectedIndex];
	}
}
function change3(index){
	if(index != -1){
		cateName3=depth3[goods_form.select1.selectedIndex][goods_form.select2.selectedIndex][goods_form.select3.selectedIndex];
	}
}
//+++++++++++++++++++++++++++ 카테고리 선택에 따른 SELECTBOX 변경함수 끝 ++++++++++++++++++++++++++++++++


//############ 스펙바구니 #################################
function viewSpecCartArea(mode,page){
	var params = "page="+page;
	if(mode=="list"){
		targetPage="/backoffice/ajaxpage/SpecCart.asp"
	}else if(mode=="write"){
		targetPage="/backoffice/ajaxpage/SpecCartWrite.asp"
	}
	$.ajax({type:"POST", url:targetPage,data:params,dataType:"html"
	}).done(function(data){
		fnLayerPopupOpen(data);
	})
}
function viewSpecCartModify(idx,page){
	var params = "idx="+idx;

	$.ajax({type:"POST", url:"/backoffice/ajaxpage/SpecCartModify.asp",data:params,dataType:"html"
	}).done(function(data){
		if (data=="noIDX"){
			viewSpecCartArea('list','');
		}else if (data=="noLIST"){
			viewSpecCartArea('list','');
			alert("스펙정보를 찾을수 없습니다.");
		}else{
			fnLayerPopupOpen(data);
		}
	})
}
function SpecCartSendit(){
	var f=document.specCartFrm;

	if(f.title.value==""){
		alert("스펙바구니 제목을 입력해주세요.");
		f.title.focus();
		return;
	}

	var cnt=0
	var speccartname = document.getElementsByName('speccartname');
	var speccartval = document.getElementsByName('speccartval');

	for(i=0;i<speccartname.length;i++){
		if(speccartname[i].value!="" || speccartval[i].value!=""){
			if(speccartname[i].value==""){
				alert("스펙명을 입력하세요.");
				speccartname[i].focus();
				return;
			}
			/*if(speccartval[i].value==""){
				alert("스펙내용을 입력하세요.");
				speccartval[i].focus();
				return;
			}*/
			cnt++;
		}
	}
	if(cnt==0){
		alert("적어도 하나 이상의 스펙을 등록해주셔야 합니다.");
		return;
	}

	var params = $("#specCartFrm").serialize();
	$.ajax({type:"POST", url:"/backoffice/ajaxpage/SpecCartWriteOK.asp",data:params,dataType:"html"
	}).done(function(data){
		resetSpecCartSelectBox();
		viewSpecCartArea('list','');
		alert("스펙바구니가 등록되었습니다.");
	})
}
function SpecCartModifySendit(){
	var f=document.specCartFrm;

	if(f.title.value==""){
		alert("스펙바구니 제목을 입력해주세요.");
		f.title.focus();
		return;
	}

	var cnt=0
	var speccartname = document.getElementsByName('speccartname');
	var speccartval = document.getElementsByName('speccartval');

	for(i=0;i<speccartname.length;i++){
		if(speccartname[i].value!="" || speccartval[i].value!=""){
			if(speccartname[i].value==""){
				alert("스펙명을 입력하세요.");
				speccartname[i].focus();
				return;
			}
			/*if(speccartval[i].value==""){
				alert("스펙내용을 입력하세요.");
				speccartval[i].focus();
				return;
			}*/
			cnt++;
		}
	}
	if(cnt==0){
		alert("적어도 하나 이상의 스펙을 등록해주셔야 합니다.");
		return;
	}
	var params = $("#specCartFrm").serialize();
	$.ajax({type:"POST", url:"/backoffice/ajaxpage/SpecCartModifyOK.asp",data:params,dataType:"html"
	}).done(function(data){
		viewSpecCartArea('list',data);
		resetSpecCartSelectBox();
		alert("스펙바구니가 수정되었습니다.");
	})
}
function SpecCartDel(idx,page){
	var val=confirm("해당스펙바구니를 삭제하시겠습니까?");
	if(val){
		var params = "idx="+idx+"&page="+page

		$.ajax({type:"POST", url:"/backoffice/ajaxpage/SpecCartDel.asp",data:params,dataType:"html"
		}).done(function(data){
			viewSpecCartArea('list','');
			resetSpecCartSelectBox();
			alert("스펙바구니가 삭제되었습니다.");
		})
	}
}
function setSpeccart(){
	var f=document.goods_form;
	if($("#scartidx").val()==""){
		alert("적용하실 스펙바구니를 선택해주십시오.");
		return;
	}

	var params = "idx="+$("#scartidx").val();

	$.ajax({type:"POST", url:"/backoffice/ajaxpage/SpecCartSet.asp",data:params,dataType:"script"	})
}
function resetSpecCartSelectBox(){
	var params = "";
	$.ajax({type:"POST", url:"/backoffice/ajaxpage/SpecCartReset.asp",data:params,dataType:"script"});
}
//############ 스펙바구니 #################################