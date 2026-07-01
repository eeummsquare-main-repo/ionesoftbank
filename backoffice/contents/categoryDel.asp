<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim strLocation,uploadform
Dim FileName,Idx,Page

langmode=Request("langmode")
Idx=Request("idx")
Page=Request("page")

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/category/")

Sql="SELECT Bansort,filenames From categoryAdmin Where idx="&IDX
SET Rs=DBcon.Execute(Sql)
If Not(Rs.Bof Or Rs.Eof) Then
	IF Rs(1)<>"" Then
		ImgDelete Rs(1),UploadForm.DefaultPath
		ImgDelete getImageThumbFilename(Rs(1)),UploadForm.DefaultPath
	End IF
	Bansort=Rs(0)
End IF

Sql="DELETE categoryAdmin WHERE idx="&Idx
DBcon.Execute Sql

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="category.asp?langmode="&langmode&"&Bansort="&Bansort
Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>