<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/category/")

Dim langTitle, langmode
langmode=UploadForm("langmode")
Call getLangModeTitle(langmode)

title=UploadForm("title")
Bansort=UploadForm("Bansort")

Filename=UploadForm("filename")
filedelchk=UploadForm("filedelchk")
mFilename=UploadForm("mfilename")
mfiledelchk=UploadForm("mfiledelchk")
Idx=UploadForm("idx")
Sort=UploadForm("sort")

IF filedelchk<>"" And Filename<>"" Then
	ImgDelete Filename,UploadForm.DefaultPath
	ImgDelete getImageThumbFilename(Filename),UploadForm.DefaultPath
End IF
IF filedelchk<>"" Or Sort="" Then 
	IF UploadForm("files")<>"" Then 
		Filename=ImgSaves(UploadForm("files"),uploadform.defaultpath,51200000)
		IF Filename=False Then Result=1

		IF Result=1 Then
			Set UploadForm=Nothing
			DBcon.Close
			Set DBcon=Nothing
			Response.Write ExecJavaAlert("업로드 허용용량(50M)을 초과하여 업로드를 실패하였습니다.",0)
			Response.End
		Else
			ThumbSaves 500,500,UploadForm("files"),uploadform.DefaultPath,Filename, "thumbs"
		End IF
	Else
		Filename=""
	End IF
End IF

IF mfiledelchk<>"" And mFilename<>"" Then
	ImgDelete mFilename,UploadForm.DefaultPath
	ImgDelete getImageThumbFilename(mFilename),UploadForm.DefaultPath
End IF
IF mfiledelchk<>"" Or Sort="" Then 
	IF UploadForm("mfiles")<>"" Then 
		mFilename=ImgSaves(UploadForm("mfiles"),uploadform.defaultpath,51200000)
		IF mFilename=False Then Result=1

		IF Result=1 Then
			Set UploadForm=Nothing
			DBcon.Close
			Set DBcon=Nothing
			Response.Write ExecJavaAlert("업로드 허용용량(50M)을 초과하여 업로드를 실패하였습니다.",0)
			Response.End
		Else
			ThumbSaves 500,500,UploadForm("mfiles"),uploadform.DefaultPath,mFilename, "thumbs"
		End IF
	Else
		mFilename=""
	End IF
End IF

IF Sort="edit" Then
	Sql="Update categoryAdmin Set langmode=?, bansort=?, title=?, filenames=?, mfilenames=? Where idx="&idx
Else
	Sql="Insert INTO categoryAdmin(langmode,bansort,title,filenames,mfilenames) values(?,?,?,?,?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@langmode", adTinyint, adParamInput, 1, langmode)
	.Parameters.Append .CreateParameter("@bansort", adBigint, adParamInput, 8, bansort)
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 100, title)
	.Parameters.Append .CreateParameter("@Filenames", adVarWChar, adParamInput, 100, Filename)
	.Parameters.Append .CreateParameter("@Filenames", adVarWChar, adParamInput, 100, mFilename)
	.Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

IF Sort="edit" Then
	strLocation="category.asp?langmode="&langmode&"&Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 수정 되었습니다.",2)
Else
	strLocation="category.asp?langmode="&langmode&"&Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 추가 되었습니다.",2)
End IF
%>