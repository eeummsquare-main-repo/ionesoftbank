<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "brand" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/brand/")

Dim langTitle, langmode
langmode=UploadForm("langmode")
Call getLangModeTitle(langmode)

title=Replace(Replace(UploadForm("title"),"<br>","|"),"<br/>","|")
note1=UploadForm("note1")
Bansort=UploadForm("Bansort")

Filename=UploadForm("filename")
filedelchk=UploadForm("filedelchk")
dFilename=UploadForm("dfilename")
dfiledelchk=UploadForm("dfiledelchk")

Idx=UploadForm("idx")
Sort=UploadForm("sort")

isDisplay = uf_getRequest(UploadForm("isDisplay"),"int","1","1")

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

IF dfiledelchk<>"" And dFilename<>"" Then
	ImgDelete dFilename,UploadForm.DefaultPath
	ImgDelete getImageThumbFilename(dFilename),UploadForm.DefaultPath
End IF
IF dfiledelchk<>"" Or Sort="" Then 
	IF UploadForm("files1")<>"" Then 
		dFilename=ImgSaves(UploadForm("files1"),uploadform.defaultpath,51200000)
		IF dFilename=False Then Result=1

		IF Result=1 Then
			Set UploadForm=Nothing
			DBcon.Close
			Set DBcon=Nothing
			Response.Write ExecJavaAlert("업로드 허용용량(50M)을 초과하여 업로드를 실패하였습니다.",0)
			Response.End
		Else
			ThumbSaves 500,500,UploadForm("files1"),uploadform.DefaultPath,dFilename, "thumbs"
		End IF
	Else
		dFilename=""
	End IF
End IF

IF Sort="edit" Then
	Sql="Update brandAdmin Set isDisplay=?, langmode=?, bansort=?, title=?, filenames=?, topicon=?, note1=? Where idx="&idx
Else
	Sql="Insert INTO brandAdmin(isDisplay,langmode,bansort,title,filenames,topicon,note1) values(?,?,?,?,?,?,?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@isDisplay", adTinyint, adParamInput, 1, isDisplay)
	.Parameters.Append .CreateParameter("@langmode", adTinyint, adParamInput, 1, langmode)
	.Parameters.Append .CreateParameter("@bansort", adBigint, adParamInput, 8, bansort)
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 100, title)
	.Parameters.Append .CreateParameter("@Filenames", adVarWChar, adParamInput, 100, Filename)
	.Parameters.Append .CreateParameter("@dFilename", adVarWChar, adParamInput, 100, dFilename)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, note1)
	.Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

IF Sort="edit" Then
	strLocation="brand.asp?langmode="&langmode&"&Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 수정 되었습니다.",2)
Else
	strLocation="brand.asp?langmode="&langmode&"&Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 추가 되었습니다.",2)
End IF
%>