<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
idx = uf_getRequest(Request("idx"),"int","","")
dbTB = uf_getRequest(Request("tb"),"char","100","")
column = uf_getRequest(Request("column"),"char","100","")
folder = uf_getRequest(Request("folder"),"char","100","")

IF idx="" OR dbTB="" OR column="" OR folder="" Then
	Response.Write "error"
	Response.End
End IF

Sql="SELECT "&column&"  FROM "&dbTB&" WHERE idx="&idx
Set Rs=DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Response.Write "error"
	Response.End
Else
	Filename = Rs(0)
End IF
Set Rs=Nothing

IF Filename<>"" Then
	Server.ScriptTimeOut=7200
	set uploadform=server.CreateObject("DEXT.FileUpload")
	UploadForm.DefaultPath=Server.MapPath("/upload/"&folder&"/")

	ImgDelete Filename,UploadForm.DefaultPath
	ImgDelete getImageThumbFilename(Filename),UploadForm.DefaultPath
End IF

Sql = "UPDATE "&dbTB&" SET "&column&"='' WHERE idx="&idx
DBcon.Execute(Sql)

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing
%>