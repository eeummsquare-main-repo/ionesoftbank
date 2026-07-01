<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub08" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim strLocation,uploadform
Dim FileName,Idx,Page

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

seritem = uf_getRequest(Request("seritem"),"int","","0")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "list.asp"
PageStr = "seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

Sql="SELECT imgnames1, imgnames2, imgnames3, imgnames4, imgnames5 From storeAdmin"
SET Rs=DBcon.Execute(Sql)
IF Not(Rs.Bof Or Rs.Eof) Then
	Do Until Rs.Eof
		imgnames1=Rs("imgnames1")
		imgnames2=Rs("imgnames2")
		imgnames3=Rs("imgnames3")
		imgnames4=Rs("imgnames4")
		imgnames5=Rs("imgnames5")

		IF imgnames1<>"" Then 	ImgDelete imgnames1,UploadForm.DefaultPath
		IF imgnames2<>"" Then 	ImgDelete imgnames2,UploadForm.DefaultPath
		IF imgnames3<>"" Then 	ImgDelete imgnames3,UploadForm.DefaultPath
		IF imgnames4<>"" Then 	ImgDelete imgnames4,UploadForm.DefaultPath
		IF imgnames5<>"" Then 	ImgDelete imgnames5,UploadForm.DefaultPath

		Rs.MoveNext()
	Loop
End IF

Sql="DELETE storeAdmin"
DBcon.Execute Sql

Set UploadForm=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation = PageLink
Response.Write ExecJavaAlert("전체 게시물이 삭제되었습니다.",2)
%>