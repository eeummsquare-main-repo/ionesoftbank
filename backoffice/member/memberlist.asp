<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim Allrec,Page,PageSize,Record_Cnt,TotalPage,Count

'==========검색 관련=========================================
page = uf_getRequest(Request("page"),"int","","1")
pageSize = uf_getRequest(Request("PageSize"),"int","","20")
IF PageSize = "" Then PageSize=20

seroutmember = uf_getRequest(Request("seroutmember"),"int","1","")
serMemsort = uf_getRequest(Request("serMemsort"),"int","","")
serAuth = uf_getRequest(Request("serAuth"),"int","","")
serOrderbyStr = uf_getRequest(Request("serOrderbyStr"),"char","","")
serOrderbyDec = uf_getRequest(Request("serOrderbyDec"),"char","","")
searchitem = uf_getRequest(Request("searchitem"),"char","","")
searchstr = uf_getRequest(Request("searchstr"),"char","","")

oSearchStr = Request("searchstr")

IF Page="" Then	Page=1
IF serOrderbyStr="" Then serOrderbyStr="idx"
IF serOrderbyDec="" Then serOrderbyDec="DESC"
IF searchstr<>"" Then
	IF SearchItem="birthday" OR SearchItem="phone" Then
		strWhere = strWhere & " AND Replace("&SearchItem&",'-','') LIKE N'%"&Replace(searchstr,"-","")&"%' "
	Else
		strWhere = strWhere & " AND "&SearchItem&" LIKE N'%"&searchstr&"%' "
	End IF
End IF
IF seroutmember<>"" Then strWhere = strWhere & " AND outmember = "&seroutmember&" "
IF serAuth<>"" Then strWhere = strWhere & " AND isAuth = "&serAuth&" "
IF serMemsort<>"" Then strWhere = strWhere & " AND memsort = "&serMemsort&" "

PageLink="memberlist.asp"
PageStr="pagesize="&PageSize&"&seroutmember="&seroutmember&"&serMemsort="&serMemsort&"&serAuth="&serAuth&"&serOrderbyStr="&serOrderbyStr&"&serOrderbyDec="&serOrderbyDec&"&searchitem="&searchitem&"&searchstr="&Server.UrlEncode(oSearchStr)
'==========검색 관련=========================================

Set Rs=Server.CreateObject("ADODB.RecordSet")
Sql="Select top "&PageSize&" idx, name, id, memsort, email, nickname, regdate, lastLogin, loginCnt, phone, emailYN, outmember, outDate, isAuth, birthday, company, dbo.fn_cLevelCd(idx) AS cMemLevel from Members where 1=1 "&strWhere&" And idx not in (select top "&(Page-1)*Pagesize&" idx from Members where 1=1 "&strWhere&" order by "&serOrderbyStr&" "&serOrderbyDec&") order by "&serOrderbyStr&" "&serOrderbyDec
Rs.Open Sql,dbcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Record_Cnt=Dbcon.Execute("select count(*) from Members where 1=1 "&strWhere)
	Count=Record_Cnt(0)
	TotalPage=Int((CLng(Count)-1)/CLng(PageSize)) +1 
	Allrec=Rs.GetRows
Else
	TotalPage=1
End IF

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function PT_Mlist
	Dim i,No
	IF Page=1 Then
		No=Count
	Else
		No=Count-(Page-1)*Pagesize
	End IF
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			TrBG="" : TrRowSpan=""
			company = changeBlank(Allrec(15,i))
			cMemLevel = changeBlank(Allrec(16,i))

			IF Allrec(10,i)=0 Then
				MailYNStr="<span style='color:red'>메일수신 받지않음</span>"
			Else
				MailYNStr="<span style='color:blue'>메일수신 허용</span>"
			End IF
			
			IF Allrec(11,i)=1 Then
				TrBG=" style='background-color: #fff2f3' "
				TrRowSpan=" rowspan='2' "
			End IF
			LinkTag="addmember.asp?idx="& Allrec(0,i) &"&page="&page&"&"&PageStr

			Response.Write "<tr "&TrBG&">"&Vbcrlf
			Response.Write "<td class=""center"" "&TrRowSpan&"><input type='checkbox' name='chkidx' value='"&Allrec(0,i)&"' dataPhone="""&Allrec(9,i)&"'""></td>"&Vbcrlf
			Response.Write "<td class=""center"" "&TrRowSpan&">"&No&"</td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&getCommunityMemLevelNm(cMemLevel)&"</a></td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&ChangeMemSort(Allrec(3,i))&"</a></td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&ChangeAuthStr(Allrec(13,i))&"</a></td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&ReplaceNoHtml(company)&"</a></td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&Allrec(1,i)&"</a></td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&Allrec(2,i)&"</a></td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&ReplaceNoHtml(Allrec(9,i))&"</a></td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&Allrec(4,i)&"</a></td>"&Vbcrlf
			Response.Write "<td class=""center""><a href='"&LinkTag&"'>"&Left(Allrec(6,i),10)&"<br>"&MID(Allrec(6,i),11)&"</a></td>"&Vbcrlf
			Response.Write "</tr>"&Vbcrlf
			IF Allrec(11,i)=1 Then
				Response.Write "<tr "&TrBG&"><td colspan='9' style='color: #A60000;' class='right'>"&Vbcrlf
				Response.Write "본 회원은 <b>"&Allrec(12,i)&"</b> 탈퇴처리 된 회원입니다."&Vbcrlf
				Response.Write "<input type='button' value='영구삭제' class='input' style='cursor:pointer' onclick='memDel("&Allrec(0,i)&",2)'>"&Vbcrlf
				Response.Write "<input type='button' value='복 구' class='input' style='cursor:pointer' onclick='memDel("&Allrec(0,i)&",3)'>"&Vbcrlf
				Response.Write "</td></tr>"&Vbcrlf
			End IF

			No=No-1
		Next
	Else
		Response.Write "<tr><td colspan='11' class=""center"" style=""padding:50px 0"">검색된 회원이 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript">
<!--
$(document).ready(function(){
	$(document).on("keyup",".smsConArea textarea",function(e){
		var obj = $(this);
		var tObj = $(this).parent().find(".byte span");
		var max_len = 2000;
		content_length = obj.val().length;

		tmp_content = "";
		cbyte = 0;

		for( i = 0; i < content_length; i++ ){
			tmp_char = obj.val().charAt( i );
			if( escape( tmp_char ).length > 4){
				cbyte += 2;
			}
			else{ cbyte++; }

			if( cbyte <= max_len ){
				tmp_content += tmp_char;
				tObj.html(cbyte);
			}else{
				msg = '메시지는 ' + max_len + ' Byte 이하로 입력해주세요.';
				alert(msg);
				obj.val(tmp_content);

				tObj.html(max_len);
				break;
			}
		}
	});

	$(document).on("click","#recPhones li span",function(e){
		$(this).parent().remove();
	});
	$(document).on("click","#addPhone",function(e){
		//var params = $("#passFrm").serialize();

		if ($("#recPhone").val().length<10){
			alert("추가하실 휴대폰번호를 10자리 이상 입력하세요.");
			$("#recPhone").focus();
			return;
		}
		var params = "phone="+$("#recPhone").val();

		$.ajax({type:"POST", url:"ajax_smsPhoneAdd.asp",data:params,dataType:"html"
		}).done(function(msg){
			arrRet = msg.split("|")
			tmpHtml = $("#recPhones").html()

			if (tmpHtml.indexOf(arrRet[1])==-1){
				$("#recPhones").append(arrRet[0]);
			}else{
				alert("이미 추가되어 있습니다.")
			}
		});
	});

	$(document).on("click","#btnMemSel",function(e){
		var checkCnt = $("input:checkbox[name=chkidx]:checked").length
		if (checkCnt==0){
			alert("문자발송 대상 회원을 선택해주세요.");
			return;
		}

		$("input:checkbox[name=chkidx]:checked").each(function(){
			var params = "phone="+$(this).attr("dataPhone");
			$.ajax({type:"POST", url:"ajax_smsPhoneAdd.asp",data:params,dataType:"html"
			}).done(function(msg){
				arrRet = msg.split("|")
				tmpHtml = $("#recPhones").html()

				if (tmpHtml.indexOf(arrRet[1])==-1){
					$("#recPhones").append(arrRet[0]);
				}
			});
		});
	});
});

function sendSms(mode){
	var f = document.smsFrm
	f.mode.value=mode;

	if (f.smsCon.value==""){
		alert("발송할 메세지를 입력해주세요.");
		f.smsCon.focus();
		return;
	}
	if (mode!="search"){
		if ($("#recPhones li").size()==0){
			alert("발송대상 휴대폰번호를 입력/선택 해주세요.");
			return;
		}
	}
	if (mode=="search"){
		msg = "검색된 회원 전체에 메세지를 발송합니다.\n발송하시겠습니까?"
	}else{
		msg = "선택/입력하신 휴대폰번호 전체에 메세지를 발송합니다.\n발송하시겠습니까?"
	}
	if (confirm(msg)){
		var params = $("#smsFrm").serialize();
		$.ajax({type:"POST", url:"smsSend.asp",data:params,dataType:"html"
		}).done(function(msg){
			arrRet = msg.split("|");
			alert(arrRet[1]);

			if (arrRet[0]=="COMPLETE"){
				document.smsFrm.reset();
				$("#recPhones").html("");
			}
		});
	}
}
//-->
</script>

<SCRIPT LANGUAGE="JavaScript">
<!--
var checkCnt=0;
function allCheck(str){
	var chkidx = document.getElementsByName(str);
	if (checkCnt==0){
		checkedStr="true";
		checkCnt=1;
	}else{
		checkedStr="";
		checkCnt=0;
	}
	for(i=0;i<chkidx.length;i++){
		chkidx[i].checked=checkedStr;
	}
}
function MemberDel(){
	var chkidx = document.getElementsByName('chkidx');
	var cnt=0;

	for(i=0;i<chkidx.length;i++){
		if(chkidx[i].checked){
			cnt++;
		}
	}
	if(cnt==0){
		alert("삭제하실 회원을 선택해주세요.");
		return;
	}
	memform.action='MemberDel.asp?sort=1';
	memform.submit();
}

function serExcelDown(){
	var chkidx = document.getElementsByName('chkidx');
	var cnt=0;

	for(i=0;i<chkidx.length;i++){
		if(chkidx[i].checked){
			cnt++;
		}
	}
	if (cnt==0){
		confirmMsg = "검색된 내역을 엑셀로 다운로드 받습니다.\n데이터 양이 많을경우 오류가 발생할수 있습니다.\n검색 후 이용을 바랍니다.\n\n다운로드 받겠습니까?"
	}else{
		confirmMsg = "선택내용을 다운로드 받겠습니까?"
	}
	if (confirm(confirmMsg)){
		memform.action='excelDown.asp';
		memform.submit();
	}
}

function memDel(idx,sort){
	if(sort==2){
		var value=confirm("회원을 삭제하면 관련 데이터 모두 삭제됩니다.\n정말로 삭제하시겠습니까?");
	}else{
		var value=confirm("해당 회원을 복구하시겠습니까?");
	}
	if(value){
		document.memform.action='memberDel.asp?sort='+sort+'&idx='+idx;
		document.memform.submit();
	}
}

function mExcelUpload(){
	openWindow("900","500","pop_mExcelUpload.asp","setcoord","yes")
}
//-->
</SCRIPT>
<body>
	<div id="wrap">
		<!--#include virtual = backoffice/common/header.asp-->

		<div id="container">
			<!--#include virtual = backoffice/common/subMenu.asp-->
			<div class="contents">

				<div class="location">
					<h2 class="top_left"><%=GB_SubMenuName%><!-- (<%=langTitle%>)--></h2>
					<a href="/backoffice/">HOME</a> &gt; <%=GB_TopMenuName%> &gt; <span><%=GB_SubMenuName%></span>
				</div>

				<form name='searchfrm' method='get' action='memberlist.asp'>
				<table class="tbl_row">
					<colgroup>
						<col style="width: 8%" />
						<col style="width: 14%" />
						<col style="width: 8%" />
						<col style="width: 14%" />
						<col style="width: 8%" />
						<col style="width: 14%" />
						<col style="width: 8%" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col">회원등급</th>
							<td>
								<select name='serMemsort'>
									<option value=''>회원등급전체</option>
									<option value='0' <%=SelCheck("0",serMemsort)%>>일반회원</option>
									<option value='1' <%=SelCheck("1",serMemsort)%>>특별회원</option>
								</select>
							</td>
							<th scope="col">승인여부</th>
							<td>
								<select name='serAuth'>
									<option value=''>승인여부전체</option>
									<option value='0' <%=SelCheck("0",serAuth)%>>가입대기중</option>
									<option value='1' <%=SelCheck("1",serAuth)%>>보류</option>
									<option value='99' <%=SelCheck("99",serAuth)%>>가입승인</option>
								</select>
							</td>
							<th scope="col">탈퇴여부</th>
							<td>
								<select name='seroutmember'>
									<option value=''>탈퇴여부전체</option>
									<option value='0' <%=SelCheck("0",seroutmember)%>>사용중회원</option>
									<option value='1' <%=SelCheck("1",seroutmember)%>>탈퇴회원</option>
								</select>
							</td>
							<th scope="col">정렬방법</th>
							<td>
								<select name='serOrderbyStr'>
									<option value='name' <%=SelCheck("name",serOrderbyStr)%>>정렬항목:이름</option>
									<option value='idx' <%=SelCheck("idx",serOrderbyStr)%>>정렬항목:등록일</option>
									<option value='lastLogin' <%=SelCheck("lastLogin",serOrderbyStr)%>>정렬항목:최종접속</option>
									<option value='loginCnt' <%=SelCheck("loginCnt",serOrderbyStr)%>>정렬항목:접속횟수</option>
								</select>
								<select name='serOrderbyDec'>
									<option value='ASC' <%=SelCheck("ASC",serOrderbyDec)%>>정렬방식:오름차순</option>
									<option value='DESC' <%=SelCheck("DESC",serOrderbyDec)%>>정렬방식:내림차순</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="searchbox">
					<select name='searchitem'>
						<option value='name' <%=SelCheck("name",searchitem)%>>이름</option>
						<option value='id' <%=SelCheck("id",searchitem)%>>아이디</option>
						<option value='email' <%=SelCheck("email",searchitem)%>>이메일</option>
						<option value='company' <%=SelCheck("company",searchitem)%>>회사명</option>
						<option value='tel' <%=SelCheck("tel",searchitem)%>>연락처</option>
					</select>
					<input type="text" name="searchstr" value="<%=searchstr%>" />
					<a href="#jLink" onclick='searchfrm.submit();' class="btn_default btn_default100">검색</a>
					<a href="?" class="btn_default btn_default100">초기화</a>
				</div>
				</form>

				<div class='right' style="margin-bottom:10px;">
					<input type='button' value="회원등록" class="btn_gray" onclick="location.href='addmember.asp'" style="width:70px">
					<input type='button' value="선택회원삭제" class="btn_gray" onclick="MemberDel()" style="width:100px">
					<input type='button' value="엑셀다운" class="btn_green" onclick="serExcelDown()" style="width:120px">
					<input type='button' value='회원정보 엑셀업로드' class='btn_default bc_blue' onclick='mExcelUpload()' style='width:120px;'>
				</div>

				<form name='memform' method='post' action=''>
				<input type='hidden' name='serMemsort' value='<%=serMemsort%>'>
				<input type='hidden' name='Page' value='<%=Page%>'>
				<input type='hidden' name='serOrderbyStr' value='<%=serOrderbyStr%>'>
				<input type='hidden' name='serOrderbyDec' value='<%=serOrderbyDec%>'>
				<input type='hidden' name='searchitem' value='<%=searchitem%>'>
				<input type='hidden' name='searchstr' value='<%=searchstr%>'>
				<input type='hidden' name='seroutmember' value='<%=seroutmember%>'>
				<input type='hidden' name='serAuth' value='<%=serAuth%>'>
				<table class="tbl_col">
				<colgroup>
					<col width="5%" />
					<col width="7%" />
					<col width="8%" />
					<col width="8%" />
					<col width="8%" />
					<col width="" />
					<col width="" />
					<col width="" />
					<col width="" />
					<col width="" />
					<col width="9%" />
				</colgroup>
					<tr>
						<th class="center"><a href='javascript:allCheck("chkidx")'>선택</a></th>
						<th class="center">No</th>
						<th class="center">커뮤니티등급</th>
						<th class="center">등급</th>
						<th class="center">승인</th>
						<th class="center">회사명</th>
						<th class="center">이름</th>
						<th class="center">아이디</th>
						<th class="center">연락처</th>
						<th class="center">이메일</th>
						<th class="center">등록일</th>
					</tr>
					<%PT_Mlist%>
				</table>
				</form>

				<%=PT_PageLink("",PageStr,"")%>

				<div style='margin-top:30px;'>
					<!-- <div><b><span style='color: #B00000'>포인트를 클릭</span></b>하시면 해당회원의 포인트를 관리하실 수 있습니다.</div> -->
					회원삭제시 <b>삭제한 회원은 붉은색으로 표시</b>되며 로그인이 불가능한 상태로 변경됩니다.<br>
					삭제된 회원정보에는 <b>영구삭제,복구메뉴가 표시</b>되며 영구삭제시 해당 회원의 정보가 최종삭제됩니다.<br>
				</div>

				<form name="smsFrm" id="smsFrm" class="disNone">
				<input type='hidden' name='mode' value="">
				<input type='hidden' name='serMemsort' value='<%=serMemsort%>'>
				<input type='hidden' name='Page' value='<%=Page%>'>
				<input type='hidden' name='serOrderbyStr' value='<%=serOrderbyStr%>'>
				<input type='hidden' name='serOrderbyDec' value='<%=serOrderbyDec%>'>
				<input type='hidden' name='searchitem' value='<%=searchitem%>'>
				<input type='hidden' name='searchstr' value='<%=searchstr%>'>
				<input type='hidden' name='seroutmember' value='<%=seroutmember%>'>
				<input type='hidden' name='serAuth' value='<%=serAuth%>'>
				<div class="subTitle">SMS발송</div>
				<div class="smsConArea">
					<textarea name="smsCon" placeholder="발송할 SMS 내용을 입력해주세요."></textarea>
					<div class="byte"><span>0</span> / 2000 Byte</div>
				</div>
				<div class="smsArea">
					<input type='text' name='recPhone' id="recPhone" class="onlyNumber" value="" maxlength="11" placeholder="수신자 번호를 입력해주세요. (- 제외)" style='width:255px;'>
					<a class="btn_gray" id="addPhone">추가하기</a>
					<a class="btn_green" id="btnMemSel" style='width:100px'>선택회원추가</a>

					<ul id="recPhones"></ul>
				</div>
				<div class="smsBtn">
					<a class="btn_gray" onclick="sendSms('')">문자발송</a>
					<a class="btn_red mt10" onclick="sendSms('search')">검색회원 문자발송</a>
				</div>
				</form>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->