<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub08" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

seritem = uf_getRequest(Request("seritem"),"int","","0")
SearchStr = uf_getRequest(Request("searchStr"),"char","","")
oSearchStr = Request("searchstr")

PageLink = "list.asp"
PageStr = "seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

IF Request("delSort") = "group" Then
	idx = Request("chkidx")
Else
	idx = Request("idx")
End IF

idx = Split(idx,",")

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/board/")

For i=0 To Ubound(IDX)
	Sql="SELECT imgnames1, imgnames2, imgnames3, imgnames4, imgnames5 From storeAdmin Where idx="&Idx(i)
	SET Rs=DBcon.Execute(Sql)

	IF Not(Rs.Bof Or Rs.Eof) Then
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
	End IF

	Sql="DELETE storeAdmin Where idx="&Idx(i)
	DBcon.Execute Sql
Next

DBcon.Close
Set DBcon=Nothing

strLocation=PageLink&"?page="&Page&"&"&PageStr

Response.Write ExecJavaAlert("선택하신 게시물이 삭제되었습니다.",2)
%>