<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
uploadPath = Server.MapPath("/upload/doctory/")
procMode = uf_getRequestProc(Request("procMode"), "char", "", "")

'검색 필드 관련===============================
serisDisplay = uf_getRequest(Request("serisDisplay"),"int","1","")
searchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "index.asp"
PageStr = "serDiv="&serDiv&"&serisDisplay="&serisDisplay&"&searchStr="&Server.UrlEncode(oSearchStr)
'=============================================

IF procMode = "" Then
	Server.ScriptTimeOut=7200
	Set uploadform=server.CreateObject("DEXT.FileUpload")
	uploadform.DefaultPath=uploadPath

	serDiv = uf_getRequest(UploadForm("serDiv"),"int","7","0")
Else
	serDiv = uf_getRequest(Request("serDiv"),"int","7","0")
End IF

topMenuCode = "company" : subMenuCode = "doctor"
%>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ErrorRMsg : ErrorRMsg = ""

IF procMode = "" Then
	'검색 필드 관련===============================
	serisDisplay = uf_getRequest(UploadForm("serisDisplay"),"int","1","")
	searchStr = uf_getRequest(UploadForm("searchStr"),"char","","")
	oSearchStr = UploadForm("searchstr")

	PageLink = "index.asp"
	PageStr = "serDiv="&serDiv&"&serisDisplay="&serisDisplay&"&searchStr="&Server.UrlEncode(oSearchStr)
	'=============================================

	Idx = UploadForm("idx")
	regdate = uf_getRequestProc(UploadForm("regdate"), "date", "", Date())
	isDisplay = uf_getRequestProc(UploadForm("isDisplay"), "int", "1", "0")
	thumbCont = uf_getRequestProc(UploadForm("thumbCont"), "char", "", "")

	title = uf_getRequestProc(UploadForm("title"), "char", "", "")
	titleEng = uf_getRequestProc(UploadForm("titleEng"), "char", "", "")
	content = uf_getRequestProc(UploadForm("content"), "char", "", "")
	content1 = uf_getRequestProc(UploadForm("content1"), "char", "", "")
	content2 = uf_getRequestProc(UploadForm("content2"), "char", "", "")

	edNonce = uf_getRequestProc(UploadForm("edNonce"),"char","","")

	mSchdule = Replace(UploadForm("mSchdule"),", ",",")
	aSchdule = Replace(UploadForm("aSchdule"),", ",",")

	IF title="" Then
		ErrorRMsg = "이름이 입력되지 않았습니다."
	Else
		IF idx="" Then
			procMode = "insert"
		Else
			Sql = "SELECT * FROM doctory WHERE idx="&idx
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
Dim arrFilename : arrFilename=""

ON ERROR RESUME NEXT

IF ErrorRMsg = "" AND (procMode = "insert" OR procMode = "update") Then
	'=======이미지 업로드 작업=======================================
	IF FileUploadSuccess Then
		For i=1 To UploadForm("imgfiles").count
			ReDim Preserve dbFileName(i)
			dbFileName(i) = UploadForm("imgdbfiles")(i)

			IF UploadForm("imgfiledel_idx")(i)="1" Then
				IF dbFileName(i)<>"" Then
					ReDim Preserve removeFile(removeFileCnt)
					removeFile(removeFileCnt) = dbFileName(i)
					removeFileCnt = removeFileCnt + 1

					ReDim Preserve removeFile(removeFileCnt)
					removeFile(removeFileCnt) = getImageThumbFilename(dbFileName(i))
					removeFileCnt = removeFileCnt + 1
				End IF

				IF UploadForm("imgfiles")(i)="" Then
					dbFileName(i) = ""
				Else
					dbFileName(i) = ImgSaves(UploadForm("imgfiles")(i),uploadform.DefaultPath,3072000000)
					IF dbFileName(i) = False Then
						FileUploadSuccess = False
						Exit For
					Else
						ReDim Preserve UploadComFile(UploadComCnt)
						UploadComFile(UploadComCnt) = dbFileName(i)
						UploadComCnt = UploadComCnt + 1

						ThumbSaves 200 , 200 , UploadForm("imgfiles")(i) , uploadform.DefaultPath, dbFileName(i), "thumbs"
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
	'=======이미지 업로드 작업=======================================

	IF FileUploadSuccess = False Then
		ErrorRMsg = "파일처리중 오류가 발생했습니다.\n다시 시도해주세요."
	End IF
End IF

ON ERROR GOTO 0

IF ErrorRMsg = "" Then
	DBCon.BEGINTRANS

	IF procMode="update" Then
		Sql = "UPDATE doctory Set regdate=?, isDisplay=?, proDiv=?, title=?, titleEng=?, thumbCont=?, mSchdule=?, aSchdule=?, content=?, content1=?, content2=?, arrImgNm=?, edNonce=? Where idx="&idx
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, regdate)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, isDisplay)
			.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, serDiv)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, title)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, titleEng)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, thumbCont)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, mSchdule)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, aSchdule)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, content)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, content1)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, content2)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrImgName)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, edNonce)
			.Execute,,adExecuteNoRecords
		End With

		'###### 에디터 ID 등록처리 ##########
		Call edNonceReg(edNonce)
		'###### 에디터 ID 등록처리 ##########
	ElseIF procMode="insert" Then
		Sql = "INSERT INTO doctory(regdate, isDisplay, proDiv, title, titleEng, thumbCont, mSchdule, aSchdule, content, content1, content2, arrImgNm, edNonce) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection = DBcon
			.CommandType = adCmdText
			.CommandText = Sql

			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, regdate)
			.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, isDisplay)
			.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, serDiv)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, title)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, titleEng)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, thumbCont)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, mSchdule)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, aSchdule)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, content)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, content1)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, content2)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrImgName)
			.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, edNonce)
			.Execute,,adExecuteNoRecords
		End With

		'###### 에디터 ID 등록처리 ##########
		Call edNonceReg(edNonce)
		'###### 에디터 ID 등록처리 ##########
	ElseIF procMode="remove" Then
		IF Request("idx")<>"" Then
			arridx = Split(Request("idx"),",")

			For i=0 To Ubound(arridx)
				idx = uf_getRequestProc(arridx(i),"int","","")

				IF idx<>"" Then
					Sql = "SELECT ARRIMGNM, edNonce FROM doctory WHERE idx="&idx
					Set Rs = DBcon.Execute(Sql)
					IF Not(Rs.Bof Or Rs.Eof) Then
						ARRIMGNM = ChangeBlank(Rs("ARRIMGNM"))
						edNonce = ChangeBlank(Rs("edNonce"))

						IF ARRIMGNM<>"" Then
							arrimgFile = Split(ARRIMGNM, "|")
							For j=0 To Ubound(arrimgFile)
								IF arrimgFile(j)<>"" Then
									ReDim Preserve removeFile(removeFileCnt)
									removeFile(removeFileCnt) = arrimgFile(j)
									removeFileCnt = removeFileCnt + 1

									ReDim Preserve removeFile(removeFileCnt)
									removeFile(removeFileCnt) = getImageThumbFilename(arrimgFile(j))
									removeFileCnt = removeFileCnt + 1
								End IF
							Next
						End IF

						Sql = "DELETE doctory WHERE idx="&idx
						DBcon.Execute(Sql)

						'###### 에디터 등록이미지 삭제처리 ##########
						Call edNonceRemove(edNonce)
						'###### 에디터 등록이미지 삭제처리 ##########
					End IF
				End IF
			Next
		End IF
	ElseIF procMode="listnum" Then
		dbidx=Request("dbidx")
		dbidx=Split(dbidx,",")
			
		Num=1
		For i=0 To Ubound(dbidx)
			Sql="UPDATE doctory SET LISTNUM="&Num&" WHERE idx="&dbidx(i)
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
		strLocation = "top.location.href='"&PageLink&"?"&pageStr&"';"
		Response.Write ExecJavaAlert("수정 되었습니다.",3)
	ElseIF procMode="insert" Then
		strLocation = "top.location.href='"&PageLink&"?"&pageStr&"';"
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

	IF procMode="" Then
		strLocation = ""
		Response.Write ExecJavaAlert(ErrorRMsg, 3)	
	ElseIF procMode="update" Then
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