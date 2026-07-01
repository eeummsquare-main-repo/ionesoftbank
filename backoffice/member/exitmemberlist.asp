<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
topMenuCode = "member" : subMenuCode = "menu02"

Dim Allrec

Sql="select e.idx,id,name,e.title,e.regdate,e.useridx from exitmember as e inner Join members as m on e.useridx=m.idx"

Set Rs=Server.CreateObject("ADODB.RecordSet")
Rs.Open Sql,DBcon,1

IF Not(Rs.Bof Or Rs.Eof) Then
	Allrec=Rs.GetRows
End If

Rs.Close
Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

Function Pt_exitmem
	Dim i,Num
	Num=1
	IF IsArray(Allrec) Then
		For i=0 To Ubound(Allrec,2)
			Response.Write "<tr>"&Vbcrlf
			Response.Write "<td class='center'>"&Num&"</td>"&Vbcrlf
			Response.Write "<td class='center'>"&Allrec(1,i)&"</td>"&Vbcrlf
			Response.Write "<td class='center'>"&Allrec(2,i)&"</td>"&Vbcrlf
			Response.Write "<td>"&Allrec(3,i)&"</td>"&Vbcrlf
			Response.Write "<td class='center'>"&Allrec(4,i)&"</td>"&Vbcrlf
			Response.Write "<td class='center'>"&Vbcrlf
			Response.Write "<div style=""padding-bottom:3px;""><input type=""button"" value=""회원삭제"" style=""width:70px"" class=""btn_gray"" onclick=""memDel("&Allrec(5,i)&",5)""></div>"&Vbcrlf
			Response.Write "<div><input type=""button"" value=""신청서삭제"" style=""width:70px"" class=""btn_gray"" onclick=""memDel("&Allrec(5,i)&",4)""></div>"&Vbcrlf
			Response.Write "</td></tr>"&Vbcrlf
			Num=Num+1
		Next
	Else
		Response.Write "<tr><td colspan='6' class='center' style=""padding:50px 0"">등록된 탈퇴 신청서가 없습니다.</td></tr>"&Vbcrlf
	End IF
End Function
%>

<!--#include virtual = backoffice/common/head.asp-->
<SCRIPT LANGUAGE="JavaScript">
<!--
function memDel(idx,Sort){
	var msg;

	if(Sort==5){msg="선택하신 회원을 탈퇴처리 하시겠습니까?"}
	else{msg="선택하신 탈퇴신청서를 삭제하시겠습니까?"}

	var value=confirm(msg);
	if(value){
		document.exitform.action='memberDel.asp?sort='+Sort+'&idx='+idx;
		document.exitform.submit();
	}
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
					<h2 class="top_left">탈퇴신청서</h2>
					<a href="/backoffice/">HOME</a> &gt; 회원관리 &gt; <span>탈퇴신청서</span>
				</div>

				<form name='exitform' method='post' action=''>
				<table class="tbl_row">
				<colgroup>
					<col width="5%" />
					<col width="7%" />
					<col width="" />
					<col width="" />
					<col width="" />
					<col width="7%" />
				</colgroup>
					<tr>
						<th class="center">No</th>
						<th class="center">아이디</th>
						<th class="center">이 름</th>
						<th class="center">탈퇴사유</th>
						<th class="center">작성일</th>
						<th class="center">관리</th>
					</tr>
					<%Pt_exitmem%>
				</table>
				</form>

				<div style='margin-top:30px;'>
					※ 회원이 탈퇴신청시 해당메뉴에 신청내역이 나타납니다.<br>
					※ 신청내역에는 간략한 회원정보가 표시되며 탈퇴,삭제버튼을 통해 회원탈퇴 및 신청서 삭제처리를 하실 수 있습니다.<br>
					※ 탈퇴버튼은 해당 신청서를 작성한 회원을 탈퇴처리합니다.<br>
					※ 탈퇴처리된 회원은 회원리스트에서 붉은색으로 표시되며 로그인이 불가능한 상태로 변경됩니다.<br>
					※ 삭제버튼클릭시 해당 탈퇴신청서만 삭제됩니다..<br>
				</div>

			</div>
		</div>
	</div>
<!--#include virtual = backoffice/common/bottom.asp-->