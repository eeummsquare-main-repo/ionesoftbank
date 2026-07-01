<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<%
isUpload = uf_getRequest(Request("isUpload"),"int","1","")
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<!--#include virtual = backoffice/common/head.asp-->
<script type="text/javascript">
$(document).ready(function(){
	var sCnt = 0 , fCnt=0

	$("#storeList .result").each(function(i) {
		var resultTxt = $(this).find("span").text();
		if (resultTxt=="Y"){
			sCnt++;
		}else{
			fCnt++;
		}
		$("#sCnt").html(sCnt)
		$("#fCnt").html(fCnt)
	});
	opener.location.reload()
});

function uploadImg_check( value,msg,sort ){
	var src = getFileExtension(value);

	if(sort==1 && value==""){return true;}
	if ( src == ""){
		alert(msg);
		return false;
	} else if ( !((src.toLowerCase() == "xls")) ) {
		alert('xls 파일만 업로드 하실 수 있습니다.');
		return false;
	}else{return true;}
}

function uploadOK(){
	var f = document.excelUploadFrm;

	if(uploadImg_check(f.files.value,"엑셀파일을 업로드 해주세요.",0)==false){
		f.files.focus();
		return;
	}
	f.submit();
}
</script>
<style>
.exMsg{font-size:16px; text-align:center; line-height:100px;}
.errorCon{color:red !important; text-align:left !important;}
</style>
<body>
	<div class="" style="padding:20px;">

		<form name="excelUploadFrm" id="excelUploadFrm" method="post" action="pop_mExcelUpload.asp?isUpload=1" onsubmit="uploadOK(); return false;" enctype="multipart/form-data">
		<table class="tbl_row mb20">
			<colgroup>
				<col width="15%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th colspan="2" style='font-weight:normal; text-align:right;'><a href="/upload/excel/testFile.xls" style='color: #287eff'>예제엑셀파일 다운로드</a></th>
			</tr>
			<tr>
				<th>업로드파일</th>
				<td style='position:relative;'>
					<input name="files" type="file" class="input" style='width:80%;'>

					<div style='font-size:12px; line-height:18px;' class="mt10">
						업로드한 엑셀파일 데이터를 일괄 등록합니다. <span style='color:red'>데이터가 정확하지 않으면 업로드가 되지않습니다.</span><br/>
						반드시 지정된 엑셀파일을 업로드 해주세요.
					</div>

					<div style='position:absolute; right:5px; top:5px'><a href="javascript:uploadOK()" class="btn_default bc_green" style='width:100px; line-height:65px;'>확인</a></div>
				</td>
			</tr>
		</table>
		</form>

		<%
			IF isUpload="1" Then
				Server.ScriptTimeOut=7200
				Set uploadform=server.CreateObject("DEXT.FileUpload")
				uploadform.DefaultPath=Server.MapPath("/upload/excel/")

				IF UploadForm("files")<>"" Then 
					FileName=ImgSaves(UploadForm("files"),uploadform.defaultpath,512000000)
					IF FileName=False Then Result=1

					IF Result=1 Then
						Set UploadForm=Nothing
						DBcon.Close
						Set DBcon=Nothing

						errorMsg = "업로드 허용용량(500M)을 초과하여 업로드를 실패하였습니다."
					End IF
				Else
					errorMsg = "업로드된 파일이 없습니다."
				End IF

				IF errorMsg="" Then
	%>
		<div id="resultArea" class="mb10" style="font-size:16px; text-align:right; color: #000">
			업데이트 처리결과 : 성공( <b id="sCnt">0</b> ), 실패( <b id="fCnt">0</b> )
		</div>

		<table id="storeList" class="tbl_col">
		<tr>
			<th class="center" width="50px">No</th>
			<th class="center" width="90px">등급</th>
			<th class="center" width="90px">승인</th>
			<th class="center">아이디</th>
			<th class="center">이름</th>
			<th class="center">연락처</th>
			<th class="center">이메일</th>
			<th class="center" width="30px">결과</th>
		</tr>
	<%
					strFilePath = Server.MapPath("/upload/excel/")&"/"&FileName

					Set XlsConn = Server.CreateObject("ADODB.Connection")
					XlsConn.Open "PROVIDER=MICROSOFT.ACE.OLEDB.12.0;DATA SOURCE=" & strFilePath &";Mode=ReadWrite|Share Deny None; Extended Properties='Excel 12.0; HDR=YES;IMEX=1';Persist Security Info=False"

					Set rsList = XlsConn.OpenSchema(20)
					Do Until rsList.EOF Or rsList.BOF
						 SheetName = Replace(rsList(2),"FilterDatabase","")
						 rsList.MoveNext
					Loop

					Set Rs = Server.CreateObject("ADODB.RecordSet")
					xSQL = "SELECT * FROM ["&SheetName&"]"
					Rs.Open xSQL, XlsConn, 1, 3

					IF Not(Rs.Bof Or Rs.Eof) Then
						ExcelData=Rs.GetRows()

						For i=0 To UBound(ExcelData,2)
							memsortData = uf_getRequestProc(ChangeBlank(ExcelData(1,i)),"char","","")
							isAuthData = uf_getRequestProc(ChangeBlank(ExcelData(2,i)),"char","","")
							id = uf_getRequestProc(ChangeBlank(ExcelData(3,i)),"char","20","")
							pwd = uf_getRequestProc(ChangeBlank(ExcelData(4,i)),"char","50","")
							name = uf_getRequestProc(ChangeBlank(ExcelData(5,i)),"char","20","")
							phone = uf_getRequestProc(ChangeBlank(ExcelData(6,i)),"char","15","")
							email = uf_getRequestProc(ChangeBlank(ExcelData(7,i)),"char","100","")
							bizcode = uf_getRequestProc(ChangeBlank(ExcelData(8,i)),"char","256","")
							company = uf_getRequestProc(ChangeBlank(ExcelData(9,i)),"char","50","")
							zipcode = uf_getRequestProc(ChangeBlank(ExcelData(10,i)),"char","7","")
							addr1 = uf_getRequestProc(ChangeBlank(ExcelData(11,i)),"char","100","")
							addr2 = uf_getRequestProc(ChangeBlank(ExcelData(12,i)),"char","100","")
							smsynData = uf_getRequestProc(ChangeBlank(ExcelData(13,i)),"char","","")
							emailynData = uf_getRequestProc(ChangeBlank(ExcelData(14,i)),"char","","")

							isAuth = 0
							IF isAuthData="가입승인" Then
								isAuth = 99
							ElseIF isAuthData="보류" Then
								isAuth = 1
							End IF
							memsort = 0
							IF memsortData="특별회원" Then memsort = 1
							smsyn = 0
							IF smsynData="Y" Then smsyn = 1
							emailyn = 0
							IF emailynData="Y" Then emailyn = 1

							recordErrMsg = ""
							IF id<>"" OR name<>"" OR email<>"" OR phone<>"" OR bizcode<>"" OR company<>"" Then

								IF id="" Then recordErrMsg = recordErrMsg & "<span>아이디 없음</span>"
								IF name = "" Then recordErrMsg = recordErrMsg & "<span>이름 없음</span>"
								IF email = "" Then recordErrMsg = recordErrMsg & "<span>이메일 없음</span>"

								IF recordErrMsg="" Then
									DBCon.BeginTrans
									ON ERROR RESUME Next
									
									dbErrCnt = 0

									'####### 처리모드 Setting ####################
									procMode = "update"
									Sql = "SELECT * FROM members WHERE id='"&ReplaceEnSine(id)&"'"
									Set Rs = DBcon.Execute(Sql)
									dbErrCnt = dbErrCnt + DBCon.errors.count

									IF Rs.Bof Or Rs.Eof Then
										procMode = "insert"
									End IF
									'####### 처리모드 Setting ####################

									'####### 이메일 중복체크 ####################
									Sql = "SELECT * FROM members WHERE id<>'"&ReplaceEnSine(id)&"' AND email='"&ReplaceEnSine(email)&"'"
									Set Rs = DBcon.Execute(Sql)
									dbErrCnt = dbErrCnt + DBCon.errors.count

									IF Not(Rs.Bof Or Rs.Eof) Then
										recordErrMsg = recordErrMsg & "<span>이메일 중복</span>"
									End IF
									'####### 이메일 중복체크 ####################

									IF recordErrMsg="" AND dbErrCnt=0 Then
										IF pwd="" Then
											IF procMode = "insert" Then
												Sql = "INSERT INTO members(memsort, name, zipcode, addr1, addr2, phone, email, emailYN, isAuth, smsYN, company, bizcode, id) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
											Else
												Sql = "UPDATE members SET memsort=?, name=?, zipcode=?, addr1=?, addr2=?, phone=?, email=?, emailYN=?, isAuth=?, smsYN=?, company=?, bizcode=? WHERE id=?"
											End IF

											Set objCmd = Server.CreateObject("ADODB.Command")
											With objCmd
												.ActiveConnection = DBcon
												.CommandType = adCmdText
												.CommandText = Sql

												.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, memsort)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 20, name)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 7, zipcode)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr1)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr2)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 15, phone)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, email)
												.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, emailYN)
												.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, isAuth)
												.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, smsYN)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, company)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 256, bizcode)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 20, id)
												.Execute,,adExecuteNoRecords
											End With
										Else
											IF procMode = "insert" Then
												Sql = "INSERT INTO members(memsort, pwd, name, zipcode, addr1, addr2, phone, email, emailYN, isAuth, smsYN, company, bizcode, id) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
											Else
												Sql = "UPDATE members SET memsort=?, pwd=?, name=?, zipcode=?, addr1=?, addr2=?, phone=?, email=?, emailYN=?, isAuth=?, smsYN=?, company=?, bizcode=? WHERE id=?"
											End IF

											Set objCmd = Server.CreateObject("ADODB.Command")
											With objCmd
												.ActiveConnection = DBcon
												.CommandType = adCmdText
												.CommandText = Sql

												.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, memsort)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, pwd)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 20, name)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 7, zipcode)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr1)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr2)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 15, phone)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, email)
												.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, emailYN)
												.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, isAuth)
												.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, smsYN)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, company)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 256, bizcode)
												.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 20, id)
												.Execute,,adExecuteNoRecords
											End With
										End IF

										dbErrCnt = dbErrCnt + DBCon.errors.count
									End IF

									IF CStr(Err.Number)<>"0" OR dbErrCnt > 0 Then recordErrMsg = recordErrMsg & "<span>DB처리 오류</span>"

									On Error goto 0

									IF recordErrMsg="" Then
										DBcon.CommitTrans
									Else
										DBcon.RollbackTrans
									End IF
								End IF

								Response.Write "<tr>"&Vbcrlf
								IF recordErrMsg<>"" Then
									Response.Write "<td rowspan=""2"">"&i+1&"</td>"&Vbcrlf
								Else
									Response.Write "<td>"&i+1&"</td>"&Vbcrlf
								End IF
								Response.Write "<td>"&ChangeMemSort(memsort)&"</td>"&Vbcrlf
								Response.Write "<td>"&ChangeAuthStr(isAuth)&"</td>"&Vbcrlf
								Response.Write "<td>"&ReplaceNoHtml(id)&"</td>"&Vbcrlf
								Response.Write "<td>"&ReplaceNoHtml(name)&"</td>"&Vbcrlf
								Response.Write "<td>"&ReplaceNoHtml(phone)&"</td>"&Vbcrlf
								Response.Write "<td>"&ReplaceNoHtml(email)&"</td>"&Vbcrlf

								IF recordErrMsg<>"" Then
									Response.Write "<td class=""result""><span style='color:#b70000'>N</span></td>"&Vbcrlf
								Else
									Response.Write "<td class=""result""><span style='color:#000'>Y</span></td>"&Vbcrlf
								End IF
								Response.Write "</tr>"&Vbcrlf

								IF recordErrMsg<>"" Then
									Response.Write "<tr><td colspan=""7"" class=""errorCon"">"&recordErrMsg&"</td></tr>"
								End IF

							End IF
						Next

						Set Rs=Nothing
						XlsConn.Close : Set XlsConn=Nothing
						'ImgDelete FileName,UploadForm.DefaultPath

	%>
		</table>
	<%

					Else
						Rs.Close
						Set Rs=Nothing
						XlsConn.Close
						Set XlsConn=Nothing

						Response.Write "<div class=""exMsg"">엑셀정보를 읽을수 없습니다. 형식에 맞는 엑셀파일을 업로드 하셨는지 확인 후 다시 시도해주십시오.</div>"
						Response.End
					End IF
				Else
					Response.Write "<div class=""exMsg"">"&errorMsg&"</div>"
				End IF
			Else
				Response.Write "<div class=""exMsg"">파일을 업로드해주세요.</div>"
			End IF
		%>
	</div>
</body>
</html>
<%
DBcon.Close
Set DBcon=Nothing
%>