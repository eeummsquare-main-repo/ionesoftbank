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
Function SE_FileSave(FormName,Path)
	Dim FileName,FilePath,Filenameonly,Fileext,i

	FileExt = FormName.FileExtension
	FilenameOnly = Session.sessionID&"_"&getTimestamp(Now())

	FileName = FilenameOnly &"."& Fileext
	FilePath=Path & "\" & FileName

	IF uploadform.fileexists(FilePath) then
		i=0
		Do while(1)
			FilePath=Path & "\" & FilenameOnly & "_" & i &"."& Fileext
			FileName = FilenameOnly & "_" & i &"."& Fileext
			IF Not UploadForm.FileExists(FilePath) Then Exit Do
			i=i+1
		Loop
	End IF
	FormName.saveas FilePath
	SE_FileSave = FileName
End Function


Dim ErrorMsg : ErrorMsg = ""
Dim editroUploadPath : editroUploadPath = Server.MapPath("/upload/ckeditor5/")

Set UploadForm = Server.CreateObject("DEXT.FileUpload") '// 파일업로드 컴포넌트를 선언
UploadForm.AutoMakeFolder = true '자동폴더 생성
UploadForm.DefaultPath = editroUploadPath '// 파일이 실제로 업로드되는 위치
Set objImage =Server.CreateObject("DEXT.ImageProc")

Dim FileOriName, FileName, FileURL

edNonce = uf_getRequest(UploadForm("ed_nonce"),"char","","")
Dimg = UploadForm("upload") '// 업로드 파일

IF edNonce = "" Then ErrorMsg = "Empty edNonce"

IF ErrorMsg = "" Then
	IF trim(Dimg) <> "" THEN
		FileOriName = UploadForm("upload").filename
		FileSize = UploadForm("upload").FileLen
		FileFormat = UploadForm("upload").ImageFormat
		imgWSize = UploadForm("upload").ImageWidth
		imgHSize = UploadForm("upload").ImageHeight

		IF FileFormat<>"" THen
			FileName = SE_FileSave(UploadForm("upload"), UploadForm.DefaultPath)
			FileURL = "/upload/ckeditor5/"&FileName
			FileUrlEnc = Replace("/upload/ckeditor5/"&Server.Urlencode(FileName), "/", "\/")

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

IF ErrorMsg = "" Then
	Response.Write "{""filename"" : """&FileOriName&""", ""uploaded"" : 1, ""url"":"""&FileUrlEnc&"""}"&Vbcrlf
Else
	Response.Write "{""uploaded"" : 0, ""url"":"""" ""error"": {""message"": """&ErrorMsg&"""}}"
End IF
%>