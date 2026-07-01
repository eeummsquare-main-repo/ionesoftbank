<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
regDiv = uf_getRequest(Request("regDiv"),"int","3","0")
topMenuCode = "cont" : subMenuCode = "info"
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ErrorRMsg : ErrorRMsg = ""

'검색 필드 관련===============================
page = uf_getRequest(Request("page"),"int","","")
pageSize = uf_getRequest(Request("pageSize"),"int","","")
seritem = uf_getRequest(Request("seritem"),"int","","")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "index.asp"
PageStr = "regDiv="&regDiv&"&seritem="&seritem&"&pagesize="&PageSize&"&searchStr="&Server.UrlEncode(oSearchStr)
'=============================================

uploadPath = Server.MapPath("/upload/infomation/")
procMode = uf_getRequestProc(Request("procMode"), "char", "", "")

IF procMode = "" Then
	Server.ScriptTimeOut=7200
	Set uploadform=server.CreateObject("DEXT.FileUpload")
	uploadform.DefaultPath=uploadPath

	'검색 필드 관련===============================
	page = uf_getRequest(UploadForm("page"),"int","","")
	pageSize = uf_getRequest(UploadForm("pageSize"),"int","","")
	seritem = uf_getRequest(UploadForm("seritem"),"int","","")
	SearchStr = uf_getRequest(UploadForm("searchStr"),"char","","")
	oSearchStr = UploadForm("searchstr")

	PageLink = "index.asp"
	PageStr = "regDiv="&regDiv&"&seritem="&seritem&"&pagesize="&PageSize&"&searchStr="&Server.UrlEncode(oSearchStr)
	'=============================================

	Idx = UploadForm("idx")
	isDisplay = uf_getRequestProc(UploadForm("isDisplay"), "int", "1", "0")

	For i=1 To UploadForm("title").Count
		title = uf_getRequestProc(UploadForm("title")(i), "char", "", "")
		country = uf_getRequestProc(UploadForm("country")(i), "char", "", "")
		company = uf_getRequestProc(UploadForm("company")(i), "char", "", "")
		addr = uf_getRequestProc(UploadForm("addr")(i), "char", "", "")
		tel = uf_getRequestProc(UploadForm("tel")(i), "char", "", "")
		fax = uf_getRequestProc(UploadForm("fax")(i), "char", "", "")
		website = uf_getRequestProc(UploadForm("website")(i), "char", "", "")
		email = uf_getRequestProc(UploadForm("email")(i), "char", "", "")

		IF title<>"" Then
			IF arr_title<>"" Then
				arr_title = arr_title & "^|^"
				arr_country = arr_country & "^|^"
				arr_company = arr_company & "^|^"
				arr_addr = arr_addr & "^|^"
				arr_tel = arr_tel & "^|^"
				arr_fax = arr_fax & "^|^"
				arr_website = arr_website & "^|^"
				arr_email = arr_email & "^|^"
			End IF

			arr_title = arr_title & title
			arr_country = arr_country & country
			arr_company = arr_company & company
			arr_addr = arr_addr & addr
			arr_tel = arr_tel & tel
			arr_fax = arr_fax & fax
			arr_website = arr_website & website
			arr_email = arr_email & email
		End IF
	Next

	IF arr_title="" Then
		ErrorRMsg = "제목이 입력되지 않았습니다."
	Else
		IF idx="" Then
			procMode = "insert"
		Else
			Sql = "SELECT * FROM infomation WHERE idx="&idx
			Set Rs = DBcon.Execute(Sql)
			IF Rs.Bof Or Rs.Eof Then
				procMode = "insert"
			Else
				procMode = "update"
			End IF
		End IF
	End IF
END IF

Dim FileUploadSuccess : FileUploadSuccess = True
Dim UploadComCnt : UploadComCnt = 0
Dim removeFileCnt : removeFileCnt = 0
Dim UploadComFile()	 : ReDim UploadComFile(UploadComCnt) 	'업로드 완료파일 배열
Dim removeFile() : ReDim removeFile(removeFileCnt)				'삭제될 파일 배열
Dim dbFileName() : ReDim dbFileName(0)								'파일명
Dim arrImgName : arrImgName=""
Dim arrDImgName : arrDImgName=""
Dim arrFilename : arrFilename=""

ON ERROR RESUME NEXT

IF ErrorRMsg = "" AND (procMode = "insert" OR procMode = "update") Then
	'=======첨부파일 업로드 작업=======================================
	IF FileUploadSuccess Then
		For i=1 To UploadForm("files").count
			ReDim Preserve dbFileName(i)
			dbFileName(i) = UploadForm("dbfiles")(i)

			IF UploadForm("filedel_idx")(i)="1" Then
				IF dbFileName(i)<>"" Then
					ReDim Preserve removeFile(removeFileCnt)
					removeFile(removeFileCnt) = dbFileName(i)
					removeFileCnt = removeFileCnt + 1
				End IF

				IF UploadForm("files")(i)="" Then
					dbFileName(i) = ""
				Else
					dbFileName(i) = ImgSaves(UploadForm("files")(i),uploadform.DefaultPath,3072000000)
					IF dbFileName(i) = False Then
						FileUploadSuccess = False
						Exit For
					Else
						ReDim Preserve UploadComFile(UploadComCnt)
						UploadComFile(UploadComCnt) = dbFileName(i)
						UploadComCnt = UploadComCnt + 1
					End IF
				End IF
			End IF

			IF CStr(Err.Number)<>"0"  Then
				FileUploadSuccess = False
				Exit For
			End IF

			IF dbFileName(i)<>"" Then
				IF arrImgName<>"" Then arrImgName = arrImgName & "|"
				arrImgName = arrImgName & dbFileName(i)
			End IF
		Next
	End IF
	'=======첨부파일 업로드 작업=======================================

	IF FileUploadSuccess = False Then
		ErrorRMsg = "파일처리중 오류가 발생했습니다.\n다시 시도해주세요."
	End IF
End IF

ON ERROR GOTO 0

IF ErrorRMsg = "" Then
	DBCon.BEGINTRANS

	IF procMode="update" Then
		Sql = "UPDATE infomation Set isDisplay=?, regDiv=?, ARRIMGNM=?, arr_title=?, arr_country=?, arr_company=?, arr_addr=?, arr_tel=?, arr_fax=?, arr_website=?, arr_email=? Where idx="&idx
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, isDisplay)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, regDiv)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 4000, arrImgName)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_title)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_country)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_company)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_addr)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_tel)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_fax)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_website)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_email)
			.Execute,,adExecuteNoRecords
		End With
	ElseIF procMode="insert" Then
		Sql = "INSERT INTO infomation(isDisplay, regDiv, ARRIMGNM, arr_title, arr_country, arr_company, arr_addr, arr_tel, arr_fax, arr_website, arr_email) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, isDisplay)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, regDiv)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 4000, arrImgName)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_title)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_country)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_company)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_addr)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_tel)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_fax)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_website)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arr_email)
			.Execute,,adExecuteNoRecords
		End With
	ElseIF procMode="remove" Then
		IF Request("idx")<>"" Then
			arridx = Split(Request("idx"),",")

			For i=0 To Ubound(arridx)
				idx = uf_getRequest(arridx(i),"int","","")

				IF idx<>"" Then
					Sql = "SELECT ARRIMGNM FROM infomation WHERE idx="&idx
					Set Rs = DBcon.Execute(Sql)
					IF Not(Rs.Bof Or Rs.Eof) Then
						ARRIMGNM = ChangeBlank(Rs("ARRIMGNM"))

						IF ARRIMGNM<>"" Then
							arrFile = Split(ARRIMGNM, "|")
							For j=0 To Ubound(arrFile)
								IF arrFile(j)<>"" Then
									ReDim Preserve removeFile(removeFileCnt)
									removeFile(removeFileCnt) = arrFile(j)
									removeFileCnt = removeFileCnt + 1
								End IF
							Next
						End IF

						Sql = "DELETE infomation WHERE idx="&idx
						DBcon.Execute(Sql)
					End IF
				End IF
			Next
		End IF
	ElseIF procMode="listnum" Then
		dbidx=Request("dbidx")
		dbidx=Split(dbidx,",")
			
		Num=1
		For i=0 To Ubound(dbidx)
			Sql="UPDATE infomation SET LISTNUM="&Num&" WHERE idx="&dbidx(i)
			DBcon.Execute Sql
			Num=Num+1
		Next
	End IF

	DBcon.CommitTrans()
End IF

Set objCmd = Nothing

IF ErrorRMsg="" Then
	'### 업데이트 및 삭제파일 삭제처리 ###########
	For i=0 To Ubound(removeFile)
		IF removeFile(i)<>"" Then
			ImgDelete removeFile(i), uploadPath
		End IF
	Next
	'### 업데이트 및 삭제파일 삭제처리 ###########

	IF procMode="update" Then
		strLocation = "top.location.href='"&PageLink&"?page="&page&"&"&pageStr&"';"
		Response.Write ExecJavaAlert("수정 되었습니다.",3)
	ElseIF procMode="insert" Then
		strLocation = "top.location.href='"&PageLink&"?page="&page&"&"&pageStr&"';"
		Response.Write ExecJavaAlert("추가 되었습니다.",3)
	ElseIF procMode="remove" Then
		strLocation = PageLink&"?"&pageStr
		Response.Write ExecJavaAlert("삭제 되었습니다.",2)
	ElseIF procMode="listnum" Then
		strLocation = PageLink&"?"&pageStr
		Response.Write ExecJavaAlert("노출순서가 저장되었습니다.",2)
	End IF
Else
	'### 오류시 업로드된 파일 삭제처리 ###########
	For i=0 To Ubound(UploadComFile)
		IF UploadComFile(i)<>"" Then
			ImgDelete UploadComFile(i), uploadPath
		End IF
	Next
	'### 오류시 업로드된 파일 삭제처리 ###########

	IF procMode="update" Then
		strLocation = ""
		Response.Write ExecJavaAlert(ErrorRMsg, 3)
	ElseIF procMode="insert" Then
		strLocation = ""
		Response.Write ExecJavaAlert(ErrorRMsg, 3)
	ElseIF procMode="remove" Then
		strLocation = ""
		Response.Write ExecJavaAlert(ErrorRMsg, 0)
	ElseIF procMode="listnum" Then
		strLocation = ""
		Response.Write ExecJavaAlert(ErrorRMsg, 0)
	End IF
End IF
%>