<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "pageSeo" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ErrorRMsg : ErrorRMsg = ""

uploadPath = Server.MapPath("/upload/seo/")

Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=uploadPath

idx = uf_getRequest(UploadForm("idx"),"idx","5","0")

seoTitle = uf_getRequestProc(UploadForm("seoTitle"),"char","","")
seoDescription = uf_getRequestProc(UploadForm("seoDescription"),"char","","")
seoKeywords = uf_getRequestProc(UploadForm("seoKeywords"),"char","","")
seoimgDel_Chk = uf_getRequestProc(UploadForm("seoimgDel_Chk"),"char","","")
seoFileNm = uf_getRequestProc(UploadForm("seoFileNm"),"char","","")

seoSubject = uf_getRequestProc(UploadForm("seoSubject"),"char","","")
seoAuthor = uf_getRequestProc(UploadForm("seoAuthor"),"char","","")
seoCopyright = uf_getRequestProc(UploadForm("seoCopyright"),"char","","")
seoNaverKey = uf_getRequestProc(UploadForm("seoNaverKey"),"char","","")


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

IF ErrorRMsg = "" Then
	'=======첨부파일 업로드 작업=======================================
	IF FileUploadSuccess Then
		seoFileNm = UploadForm("seoFileNm")

		IF UploadForm("seoimgDel_Chk")="1" Then
			IF seoFileNm<>"" Then
				ReDim Preserve removeFile(removeFileCnt)
				removeFile(removeFileCnt) = seoFileNm
				removeFileCnt = removeFileCnt + 1
			End IF

			IF UploadForm("seoFiles")="" Then
				seoFileNm = ""
			Else
				seoFileNm = ImgSaves(UploadForm("seoFiles"),uploadPath,3072000000)
				IF seoFileNm = False Then
					FileUploadSuccess = False
				Else
					ReDim Preserve UploadComFile(UploadComCnt)
					UploadComFile(UploadComCnt) = seoFileNm
					UploadComCnt = UploadComCnt + 1
				End IF
			End IF
		End IF

		IF CStr(Err.Number)<>"0"  Then FileUploadSuccess = False
	End IF
	'=======첨부파일 업로드 작업=======================================

	IF FileUploadSuccess = False Then
		ErrorRMsg = "파일처리중 오류가 발생했습니다.\n다시 시도해주세요."
	End IF
End IF

ON ERROR GOTO 0

IF ErrorRMsg = "" Then
	DBCon.BEGINTRANS

	Sql = "UPDATE seoData Set seoTitle=?, seoDescription=?, seoKeywords=?, seoFile=?, seoSubject=?, seoAuthor=?, seoCopyright=?, seoNaverKey=? Where idx="&idx
	Set objCmd = Server.CreateObject("ADODB.Command")
	With objCmd
		.ActiveConnection = DBcon
		.CommandType = adCmdText
		.CommandText = Sql

		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, seoTitle)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, seoDescription)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, seoKeywords)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, seoFileNm)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, seoSubject)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, seoAuthor)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, seoCopyright)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2000, seoNaverKey)
		.Execute,,adExecuteNoRecords
	End With
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

	strLocation = "top.location.reload();"
	Response.Write ExecJavaAlert("수정 되었습니다.",3)
Else
	'### 오류시 업로드된 파일 삭제처리 ###########
	For i=0 To Ubound(UploadComFile)
		IF UploadComFile(i)<>"" Then
			ImgDelete UploadComFile(i), uploadPath
		End IF
	Next
	'### 오류시 업로드된 파일 삭제처리 ###########

	strLocation = ""
	Response.Write ExecJavaAlert(ErrorRMsg, 3)
End IF
%>