<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "news" : subMenuCode = "sub05" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Page = uf_getRequest(Request("Page"),"int","","")
pagesize = uf_getRequest(Request("pagesize"),"int","","")

serDate1 = uf_getRequest(Request("serDate1"),"date","","")
serDate2 = uf_getRequest(Request("serDate2"),"date","","")
serRevDate = uf_getRequest(Request("serRevDate"),"date","","")
serStatus = uf_getRequest(Request("serStatus"),"int","","")
serstaffidx = uf_getRequest(Request("serstaffidx"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
searchstr = uf_getRequest(Request("searchstr"),"char","","")
oSearchstr = Request("searchstr")

PageLink="consult.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serRevDate="&serRevDate&"&serStatus="&serStatus&"&serstaffidx="&serstaffidx&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = uf_getRequest(Request("idx"),"int","","")

IF idx="" Then
	Response.Write ExecJavaalert("잘못된 접근입니다.", 0)
	Response.End
End IF

Sql = "SELECT subjectidx, staffidx, revDate, revTime, name, icode, sex, phone, pass, note1, note2, note3, note4, status, regsort FROM Consult Where idx="&idx
Set Rs = DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Response.Write ExecJavaalert("예약정보를 찾을수 없습니다.", 0)
	Response.End
Else
	subjectidx = Rs("subjectidx")
	staffidx = Rs("staffidx")
	revDate = Rs("revDate")
	revTime = Rs("revTime")
	name = Rs("name")
	icode = Rs("icode")
	sex = Rs("sex")
	phone = Rs("phone")
	DBpass = Rs("pass")
	note1 = Rs("note1")
	note2 = Rs("note2")
	note3 = Rs("note3")
	note4 = Rs("note4")
	status = Rs("status")
	regsort = Rs("regsort")
End IF

Sql = "SELECT idx, title FROM subjectAdmin Order By listnum ASC, idx ASC"
Set Rs = DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then subjectRec = Rs.GetRows()

DBcon.Close
Set DBcon = Nothing

Function PT_subjectList()
	Dim i
	IF IsArray(subjectRec) Then
		For i=0 To Ubound(subjectRec,2)
			Response.Write "<option value='"&subjectRec(0,i)&"' "&iif_compare(subjectidx, subjectRec(0,i), "selected")&">"&subjectRec(1,i)&"</option>"&vbcrlf
		Next
	End If
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
	<script type="text/javascript">
	<!--
	$(function(){
		var setStaffidx = "<%=staffidx%>";
		var setRevDate = "<%=RevDate%>";
		var setRevTime = "<%=revTime%>";

		$(document).on("change","#subjectidx",function(){
			var subjectidx = $(this).val();
			var params = "subjectidx="+subjectidx;
			$.ajax({type:"POST", url:"/backoffice/_lib/ajax_staffOption.asp",data:params,dataType:"script"
			}).done(function(msg){
				$("#revDate option:not(:first)").remove();
				$("#revTime option:not(:first)").remove();

				if (setStaffidx!=""){
					$('#staffidx').val(setStaffidx);
					$("#staffidx").change();
					setStaffidx = "";
				}
			});
		});
		$(document).on("change","#staffidx",function(){
			var staffidx = $(this).val();
			var params = "revDate="+setRevDate+"&staffidx="+staffidx;
			$.ajax({type:"POST", url:"/backoffice/_lib/ajax_revDateOption.asp",data:params,dataType:"script"
			}).done(function(msg){
				$("#revTime option:not(:first)").remove();

				if (setRevDate!=""){
					$('#revDate').val(setRevDate);
					$("#revDate").change();
					setRevDate = "";
				}
			});
		});
		$(document).on("change","#revDate",function(){
			var staffidx = $("#staffidx").val();
			var modiidx = $("#modiidx").val();
			var revDate = $(this).val();

			var params = "modiidx="+modiidx+"&staffidx="+staffidx+"&revDate="+revDate;
			$.ajax({type:"POST", url:"/backoffice/_lib/ajax_revTimeOption.asp",data:params,dataType:"script"
			}).done(function(msg){
				if (setRevTime!=""){
					$('#revTime').val(setRevTime);
					setRevTime="";
				}
			});
		});

		$("#subjectidx").change();

	});

	function revOK(){
		var f = document.revFrm;

		if (f.subjectidx.value==""){
			alert("진료과를 선택해주세요.");
			f.subjectidx.focus();
			return;
		}
		if (f.staffidx.value==""){
			alert("의료진을 선택해주세요.");
			f.staffidx.focus();
			return;
		}
		if (f.revDate.value==""){
			alert("진료가능 날짜를 선택해주세요.");
			f.revDate.focus();
			return;
		}
		if (f.revTime.value==""){
			alert("진료가능 시간을 선택해주세요.");
			f.revTime.focus();
			return;
		}
		if (f.name.value==""){
			alert("이름을 입력해주세요.");
			f.name.focus();
			return;
		}
		if (f.icode.value==""){
			alert("주민번호 앞자리를 입력해주세요.");
			f.icode.focus();
			return;
		}
		var sex = $(":input:radio[name=sex]:checked").val();
		if (sex==""){
			alert("성별을 선택해주세요.");
			f.phone.focus();
			return;
		}
		if (f.phone.value==""){
			alert("연락처를 입력해주세요.");
			f.phone.focus();
			return;
		}
		var val = confirm("예약정보를 수정하시겠습니까?");
		if (val){
			var params = $("#revFrm").serialize();
			$.ajax({type:"POST", url:"/backoffice/_lib/ajax_reservationModifyOK.asp",data:params,dataType:"html"
			}).done(function(msg){
				if (msg=="OK"){
					alert("예약정보가 수정 되었습니다.");
					location.reload();
				}else{
					rMsg = msg.split("|");

					alert(rMsg[1])
					if (rMsg[0]=="RELOAD"){
						location.reload();
					}else{
						$("#revDate").change();					
					}
				}
			});
		}
	}
	//-->
	</script>
</head>

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

				<form name='revFrm' id='revFrm' method='post' style='margin:0;' onsubmit="revOK(); return false;">
				<input type='hidden' name='idx' id="modiidx" value="<%=idx%>">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="serRevDate" value="<%=serRevDate%>">
				<input type="hidden" name="serStatus" value="<%=serStatus%>">
				<input type="hidden" name="serstaffidx" value="<%=serstaffidx%>">
				<input type="hidden" name="seritem" value="<%=seritem%>">
				<input type="hidden" name="SearchStr" value="<%=ReplaceTextField(oSearchstr)%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="serDate1" value="<%=serDate1%>">
				<input type="hidden" name="serDate2" value="<%=serDate2%>">
				<table class="tbl_row">
					<colgroup>
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="">진료과</span></th>
							<td>
								<select name="subjectidx" id="subjectidx">
									<option value="">선택하세요</option>
									<%=PT_subjectList()%>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="">의료진</span></th>
							<td>
								<select name="staffidx" id="staffidx">
									<option value="">선택하세요</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="">진료가능 날짜</span></th>
							<td>
								<select name="revDate" id="revDate">
									<option value="">선택하세요</option>
								</select>
							</td>
						</tr>
						<tr>
							<th><span class="">진료가능 시간</span></th>
							<td>
								<select name="revTime" id="revTime">
									<option value="">선택하세요</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>

				<div class="subTitle">기본정보(필수)</div>
				<table class="tbl_row ">
					<colgroup>
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="">초진/재진</span></th>
							<td>
								<input type="radio" id="sortCheck01" name="regsort" value="초진" checked />
								<label for="sortCheck01">초진</label>

								<input type="radio" id="sortCheck02" name="regsort" value="재진" <%=iif_compare(regsort, "재진", "checked")%> />
								<label for="sortCheck02">재진</label>
							</td>
						</tr>
						<tr>
							<th><span class="">이름</span></th>
							<td>
								<input type="text" name="name" maxlength="20" value="<%=ReplaceTextField(name)%>" placeholder="" />
							</td>
						</tr>
						<tr>
							<th scope="row"><span class="">주민번호 앞자리</span></th>
							<td>
								<input type="text" name="icode" maxlength="6" value="<%=ReplaceTextField(icode)%>" placeholder="" />
								<span class="type l">- *******</span>
							</td>
						</tr>

						<tr>
							<th scope="row"><span class="">성별</span></th>
							<td>
								<input type="radio" id="sexCheck01" name="sex" value="남" <%=iif_compare(sex, "남", "checked")%> />
								<label for="sexCheck01">남</label>

								<input type="radio" id="sexCheck02" name="sex" value="여" <%=iif_compare(sex, "여", "checked")%> />
								<label for="sexCheck02">여</label>
							</td>
						</tr>
						<tr>
							<th scope="row"><span class="">연락처</span></th>
							<td>
								<input type="text" name="phone" maxlength="15" value="<%=ReplaceTextField(phone)%>" placeholder="‘-’포함 입력" />
							</td>
						</tr>
					</tbody>
				</table>

				<div class="subTitle">상세정보(선택)</div>
				<table class="tbl_row ">
					<colgroup>
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th><span class="">신장</span></th>
							<td>
								<input type="text" name="note1" maxlength="5" value="<%=ReplaceTextField(note1)%>" placeholder="" />
								<span class="type l">cm</span>
							</td>
						</tr>
						<tr>
							<th scope="row"><span class="">체중</span></th>
							<td>
								<input type="text" name="note2" maxlength="5" value="<%=ReplaceTextField(note2)%>" placeholder="" />
								<span class="type l">kg</span>
							</td>
						</tr>
						<tr>
							<th scope="row"><span class="">질병력</span></th>
							<td>
								<input type="checkbox" id="form01Check01" name="note3" value="고혈압" <% IF InStr(","&Replace(Note3, ", ", ",")&",", ",고혈압,") > 0 Then %>checked<% End IF %> />
								<label for="form01Check01">고혈압</label>

								<input type="checkbox" id="form01Check02" name="note3" value="당뇨병" <% IF InStr(","&Replace(Note3, ", ", ",")&",", ",당뇨병,") > 0 Then %>checked<% End IF %> />
								<label for="form01Check02">당뇨병</label>

								<input type="checkbox" id="form01Check03" name="note3" value="갑상선질환" <% IF InStr(","&Replace(Note3, ", ", ",")&",", ",갑상선질환,") > 0 Then %>checked<% End IF %> />
								<label for="form01Check03">갑상선질환 </label>

								<input type="checkbox" id="form01Check04" name="note3" value="관절질환" <% IF InStr(","&Replace(Note3, ", ", ",")&",", ",관절질환,") > 0 Then %>checked<% End IF %> />
								<label for="form01Check04">관절질환</label>

								<input type="checkbox" id="form01Check05" name="note3" value="생리불순" <% IF InStr(","&Replace(Note3, ", ", ",")&",", ",생리불순,") > 0 Then %>checked<% End IF %> />
								<label for="form01Check05">생리불순</label>

								<input type="checkbox" id="form01Check06" name="note3" value="우울증" <% IF InStr(","&Replace(Note3, ", ", ",")&",", ",우울증,") > 0 Then %>checked<% End IF %> />
								<label for="form01Check06">우울증</label>

								<input type="checkbox" id="form01Check07" name="note3" value="기타" <% IF InStr(","&Replace(Note3, ", ", ",")&",", ",기타,") > 0 Then %>checked<% End IF %> />
								<label for="form01Check07">기타</label>

								<input type="checkbox" id="form01Check08" name="note3" value="해당없음" <% IF InStr(","&Replace(Note3, ", ", ",")&",", ",해당없음,") > 0 Then %>checked<% End IF %> />
								<label for="form01Check08">해당없음</label>
							</td>
						</tr>
						<tr>
							<th><span class="">현재복용약물</span></th>
							<td>
								<input type="checkbox" id="form02Check01" name="note4" value="혈압약" <% IF InStr(","&Replace(Note4, ", ", ",")&",", ",혈압약,") > 0 Then %>checked<% End IF %> />
								<label for="form02Check01">혈압약</label>

								<input type="checkbox" id="form02Check02" name="note4" value="당뇨병약제" <% IF InStr(","&Replace(Note4, ", ", ",")&",", ",당뇨병약제,") > 0 Then %>checked<% End IF %> />
								<label for="form02Check02">당뇨병약제</label>

								<input type="checkbox" id="form02Check03" name="note4" value="갑상선호르몬제" <% IF InStr(","&Replace(Note4, ", ", ",")&",", ",갑상선호르몬제,") > 0 Then %>checked<% End IF %> />
								<label for="form02Check03">갑상선호르몬제 </label>

								<input type="checkbox" id="form02Check04" name="note4" value="진통제" <% IF InStr(","&Replace(Note4, ", ", ",")&",", ",진통제,") > 0 Then %>checked<% End IF %> />
								<label for="form02Check04">진통제</label>

								<input type="checkbox" id="form02Check05" name="note4" value="정신과약물" <% IF InStr(","&Replace(Note4, ", ", ",")&",", ",정신과약물,") > 0 Then %>checked<% End IF %> />
								<label for="form02Check05">정신과약물</label>

								<input type="checkbox" id="form02Check06" name="note4" value="기타" <% IF InStr(","&Replace(Note4, ", ", ",")&",", ",기타,") > 0 Then %>checked<% End IF %> />
								<label for="form02Check06">기타</label>

								<input type="checkbox" id="form02Check07" name="note4" value="해당없음" <% IF InStr(","&Replace(Note4, ", ", ",")&",", ",해당없음,") > 0 Then %>checked<% End IF %> />
								<label for="form02Check07">해당없음</label>
							</td>
						</tr>
					</tbody>
				</table>
				</form>

				<div class="btn_center pt30">
					<a href="javascript:revOK()" class="btn_largeG">확인</a>
					<a href="<%=PageLink%>?page=<%=page%>&<%=PageStr%>" class="btn_largeW">목록보기</a>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->