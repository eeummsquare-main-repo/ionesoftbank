<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "board" : subMenuCode = "estimate" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/consult/")

'검색 필드 관련===============================
Page = uf_getRequest(uploadform("Page"),"int","","")
pagesize = uf_getRequest(uploadform("pagesize"),"int","","")

serDate1 = uf_getRequest(uploadform("serDate1"),"date","","")
serDate2 = uf_getRequest(uploadform("serDate2"),"date","","")
serStatus = uf_getRequest(uploadform("serStatus"),"int","","")
seritem = uf_getRequest(uploadform("seritem"),"int","2","0")
searchstr = uf_getRequest(uploadform("searchstr"),"char","","")
oSearchstr = uploadform("searchstr")

PageLink="estimate.asp"
PageStr="pagesize="&pagesize&"&serDate1="&serDate1&"&serDate2="&serDate2&"&serStatus="&serStatus&"&seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

idx = uf_getRequestProc(uploadform("idx"),"int","","0")
status = uf_getRequestProc(uploadform("status"),"int","","0")
adMemo = uf_getRequestProc(uploadform("adMemo"),"char","","")

Filename=UploadForm("filename")
filedelchk=UploadForm("filedelchk")

IF filedelchk<>"" And Filename<>"" Then
	ImgDelete Filename,UploadForm.DefaultPath
	ImgDelete getImageThumbFilename(Filename),UploadForm.DefaultPath
End IF
IF filedelchk<>"" Then 
	IF UploadForm("files")<>"" Then 
		Filename=ImgSaves(UploadForm("files"),uploadform.defaultpath,51200000)
		IF Filename=False Then Result=1

		IF Result=1 Then
			Set UploadForm=Nothing
			DBcon.Close
			Set DBcon=Nothing
			Response.Write ExecJavaAlert("업로드 허용용량(50M)을 초과하여 업로드를 실패하였습니다.",0)
			Response.End
		End IF
	Else
		Filename=""
	End IF
End IF

Sql="UPDATE Estimate SET adMemo=?, memoModDate=getDate(), memoWid=?, memoWname=?, status=?, filenames=? Where idx="&idx
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@adMemo", adVarWChar, adParamInput, 2147483647, adMemo)
	.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Session("acountcode"))
	.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Session("acountname"))
	.Parameters.Append .CreateParameter("@par", adTinyint, adParamInput, 4, status)
	.Parameters.Append .CreateParameter("@par", adVarWChar, adParamInput, 50, Filename)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

DBcon.Close
Set DBcon = Nothing

strLocation="top.location.reload();"
Response.Write ExecJavaAlert("저장되었습니다.","3")
%>