<%@ Language="VBScript" CodePage="65001" %>
<!--METADATA TYPE="TypeLib" NAME="Microsoft ActiveX Data Objects 2.7 Library" UUID="{EF53050B-882E-4776-B643-EDA472E8E3F2}" VERSION="2.7"-->
<% 'Option Explicit %>
<%
REM	인코딩 설정 : Page  - Encoding  [0 : ANSI], [949 : EUC-KR], [65001 : 유니코드(UTF-8)], [65535 : 유니코드(UTF-16)]
Response.CharSet = "utf-8"
Response.Expires = "-1"
Response.CodePage = "65001"
Session.CodePage = "65001"
Response.AddHeader "Expires","-1"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Cache-Control","no-cache,must-revalidate"
%>
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = _lib/functions.asp-->
<%
Dim ErrorMsg : ErrorMsg = ""

edNonce = uf_getRequest(Request("_nonce"),"char","","")
editroUploadPath = Server.MapPath("/upload/SmartUpload/")
handlerMode = uf_getRequest(Request("del"),"int","1","0")

IF edNonce = "" Then ErrorMsg = "Empty edNonce"

IF ErrorMsg = "" Then
	IF handlerMode = "1" Then		'파일삭제
		delFileNm = uf_getRequest(Request("file"),"char","","")

		IF delFileNm = "" Then
			ErrorMsg = "삭제할 파일을 찾을수 없음."
		Else
			ImgDelete delFileNm, editroUploadPath
			FileURL = "/upload/SmartUpload/"&delFileNm

			Sql = "DELETE editorFileINFO WHERE edNonce=? AND fileINFO=?"
			Set objCmd = Server.CreateObject("ADODB.Command")
			With objCmd
				.ActiveConnection = DBcon
				.CommandType = adCmdText
				.CommandText = Sql

				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, edNonce)
				.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, FileURL)
				.Execute,,adExecuteNoRecords
			End With
			Set objCmd = Nothing
		End IF
	Else									'파일업로드
		Set UploadForm = Server.CreateObject("DEXT.FileUpload") '// 파일업로드 컴포넌트를 선언
		UploadForm.AutoMakeFolder = true '자동폴더 생성
		UploadForm.DefaultPath = editroUploadPath '// 파일이 실제로 업로드되는 위치
		Set objImage =Server.CreateObject("DEXT.ImageProc")

		Dim FileOriName, FileName, FileURL

		Dimg = UploadForm("files") '// 업로드 파일

		IF trim(Dimg) <> "" THEN
			FileOriName = UploadForm("files").filename
			FileSize = UploadForm("files").FileLen
			FileFormat = UploadForm("files").ImageFormat
			imgWSize = UploadForm("files").ImageWidth
			imgHSize = UploadForm("files").ImageHeight

			IF FileFormat<>"" THen
				FileName = SE_FileSave(UploadForm("files"), UploadForm.DefaultPath)
				FileURL = "/upload/SmartUpload/"&FileName
				FileUrlEnc = Replace("/upload/SmartUpload/"&Server.Urlencode(FileName), "/", "\/")

				Sql = "INSERT INTO editorFileINFO(edNonce, fileINFO) VALUES(?, ?)"
				Set objCmd = Server.CreateObject("ADODB.Command")
				With objCmd
					.ActiveConnection = DBcon
					.CommandType = adCmdText
					.CommandText = Sql

					.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, edNonce)
					.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 200, FileURL)
					.Execute,,adExecuteNoRecords
				End With
				Set objCmd = Nothing
			Else
				ErrorMsg = "이미지 포멧만 업로드 가능합니다."
			End IF
		END IF
	End IF
End IF

DBcon.Close
Set DBcon=Nothing

IF handlerMode = "1" Then		'파일삭제
	IF ErrorMsg = "" Then
		Response.Write "{"""&delFileNm&""":true}"
	Else
		Response.Write "{""error"":"""&ErrorMsg&"""}"
	End IF
Else
	IF ErrorMsg = "" Then
		Response.Write "{""files"":[{""oriname"":"""&FileOriName&""", ""name"":"""&FileName&""", ""size"":"&FileSize&", ""type"":"""&FileFormat&""", ""url"":"""&FileUrlEnc&""", ""width"":"&imgWSize&", ""height"":"&imgHSize&"}]}"
	Else
		Response.Write "{""error"":"""&ErrorMsg&"""}"
	End IF
End IF
%>