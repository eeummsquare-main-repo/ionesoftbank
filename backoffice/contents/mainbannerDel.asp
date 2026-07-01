<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "banner" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim strLocation,uploadform
Dim FileName,Idx,Page

langmode = Request("langmode")
bansort=Request("bansort")
Idx = Request("idx")
Page = Request("page")

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/mainbanner/")

Sql="SELECT filenames, filenames1 From mainbannerAdmin Where idx IN ("&IDX&")"
SET Rs=DBcon.Execute(Sql)
If Not(Rs.Bof Or Rs.Eof) Then
	Do Until Rs.Eof
		IF Rs(0)<>"" Then
			ImgDelete Rs(0),UploadForm.DefaultPath
			ImgDelete getImageThumbFilename(Rs(0)),UploadForm.DefaultPath
		End IF

		IF Rs(1)<>"" Then
			ImgDelete Rs(1),UploadForm.DefaultPath
			ImgDelete getImageThumbFilename(Rs(1)),UploadForm.DefaultPath
		End IF

		Rs.MoveNext()
	Loop
End IF

Sql="DELETE mainbannerAdmin WHERE idx IN ("&IDX&")"
DBcon.Execute Sql

IF bansort=5 Then
	Sql = "Delete productAlignTB WHERE mainsort='best"&idx&"'"
	DBcon.Execute Sql
End IF

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="mainbanner.asp?langmode="&langmode&"&Bansort="&Bansort
Response.Write ExecJavaAlert("게시물이 삭제되었습니다.",2)
%>