<!--#include file = ../_lib/common.asp-->
<!--#include file = ../../_lib/dbcon.asp-->
<%
Dim ErrorRMsg : ErrorRMsg = ""

uploadPath = Server.MapPath("/upload/business/")
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=uploadPath

idx = uf_getRequest(UploadForm("idx"),"int","4","0")
langmode = uf_getRequest(UploadForm("langmode"),"int","1","0")

'검색 필드 관련===============================
PageLink = "index.asp"
PageStr = "idx="&idx&"&langmode="&langmode
'=============================================

IF idx=0 Then
	topMenuCode = "business" : subMenuCode = "cont1"
ElseIF idx=1 Then
	topMenuCode = "business" : subMenuCode = "cont2"
ElseIF idx=2 Then
	topMenuCode = "business" : subMenuCode = "cont3"
ElseIF idx=3 Then
	topMenuCode = "business" : subMenuCode = "cont4"
ElseIF idx=4 Then
	topMenuCode = "business" : subMenuCode = "cont5"
End IF
%>
<!--#include file = ../_lib/authCheck.asp-->
<%
thumbCont = uf_getRequestProc(UploadForm("thumbCont"), "char", "", "")
cont = uf_getRequestProc(UploadForm("cont"), "char", "", "")

Dim FileUploadSuccess : FileUploadSuccess = True
Dim UploadComCnt : UploadComCnt = 0
Dim removeFileCnt : removeFileCnt = 0
Dim UploadComFile()	 : ReDim UploadComFile(UploadComCnt) 	'업로드 완료파일 배열
Dim removeFile() : ReDim removeFile(removeFileCnt)				'삭제될 파일 배열
Dim dbFileName() : ReDim dbFileName(0)								'파일명
Dim arrImgName : arrImgName=""
Dim arrFilename : arrFilename=""
Dim arrFileBtnNm : arrFileBtnNm=""

ON ERROR RESUME NEXT

IF ErrorRMsg = "" Then
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
				IF arrFilename<>"" Then
					arrFilename = arrFilename & "|"
					arrFileTit = arrFileTit & "|"
				End IF

				arrFilename = arrFilename & dbFileName(i)
				arrFileTit = arrFileTit & UploadForm("fileTit")(i)
			End IF
		Next
	End IF
	'=======첨부파일 업로드 작업=======================================

	'=======설치사진 업로드 작업=======================================
	IF FileUploadSuccess Then
		For i=1 To UploadForm("dfiles").count
			ReDim Preserve dbFileName(i)
			dbFileName(i) = UploadForm("dbdfiles")(i)

			IF UploadForm("dfiledel_idx")(i)="1" Then
				IF dbFileName(i)<>"" Then
					ReDim Preserve removeFile(removeFileCnt)
					removeFile(removeFileCnt) = dbFileName(i)
					removeFileCnt = removeFileCnt + 1
				End IF

				IF UploadForm("dfiles")(i)="" Then
					dbFileName(i) = ""
				Else
					dbFileName(i) = ImgSaves(UploadForm("dfiles")(i),uploadform.DefaultPath,3072000000)
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
				IF arrdFilename<>"" Then
					arrdFilename = arrdFilename & "|"
					arrdFileTit = arrdFileTit & "|"
					arrdFileLink = arrdFileLink & "|"
					arrdFileLinkTarget = arrdFileLinkTarget & "|"
				End IF

				arrdFilename = arrdFilename & dbFileName(i)
				arrdFileTit = arrdFileTit & UploadForm("dfileTit")(i)
				arrdFileLink = arrdFileLink & UploadForm("dfileLink")(i)
				arrdFileLinkTarget = arrdFileLinkTarget & UploadForm("dfileLinkTarget")(i)
			End IF
		Next
	End IF
	'=======설치사진 업로드 작업=======================================

	IF FileUploadSuccess = False Then
		ErrorRMsg = "파일처리중 오류가 발생했습니다.\n다시 시도해주세요."
	End IF
End IF

ON ERROR GOTO 0

IF ErrorRMsg = "" Then
	DBCon.BEGINTRANS

	Sql = "UPDATE business Set thumbCont=?, cont=?, fileNms=?, fileTits=?, detailFileNms=?, detailFileTits=?, detailFileLinks=?, detailFileLinkTargets=? Where idx="&idx&" AND langmode="&langmode
	Set objCmd = Server.CreateObject("ADODB.Command")
	With objCmd
		.ActiveConnection = DBcon
		.CommandType = adCmdText
		.CommandText = Sql

		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, thumbCont)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, cont)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrFilename)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrFileTit)

		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrdFilename)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrdFileTit)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrdFileLink)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrdFileLinkTarget)
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

	strLocation = "top.location.href='"&PageLink&"?"&pageStr&"';"
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