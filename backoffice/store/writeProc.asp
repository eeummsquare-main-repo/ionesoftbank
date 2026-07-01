<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "support" : subMenuCode = "sub08" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Server.ScriptTimeOut=7200
Set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/menu/")

'검색 필드 관련===============================
Dim PageLink, PageStr, pageSize
Dim serboardsort, seritem, SearchStr, serdate1, serdate2

seritem = uf_getRequest(UploadForm("seritem"),"int","","0")
SearchStr = uf_getRequest(UploadForm("searchStr"),"char","","")
oSearchStr = UploadForm("searchstr")

PageLink = "list.asp"
PageStr = "seritem="&seritem&"&searchstr="&Server.UrlEncode(oSearchStr)
'=============================================

Idx = uf_getRequestProc(UploadForm("idx"),"int","","")
isDisplay = uf_getRequestProc(UploadForm("isDisplay"),"int","1","0")
listnum = uf_getRequestProc(UploadForm("listnum"),"int","","0")

regdiv = uf_getRequest(UploadForm("regdiv"),"int","","0")
title = uf_getRequest(UploadForm("title"),"char","","")
tel = uf_getRequest(UploadForm("tel"),"char","","")
owner = uf_getRequest(UploadForm("owner"),"char","","")
addr1 = uf_getRequest(UploadForm("addr1"),"char","","")
addr2 = uf_getRequest(UploadForm("addr2"),"char","","")
addr1_ji = uf_getRequest(UploadForm("addr1_ji"),"char","","")
addr2_ji = uf_getRequest(UploadForm("addr2_ji"),"char","","")
note1 = uf_getRequest(UploadForm("note1"),"char","","")
note2 = uf_getRequest(UploadForm("note2"),"char","","")
note3 = uf_getRequest(UploadForm("note3"),"char","","")
note4 = uf_getRequest(UploadForm("note4"),"char","","")
zipcode = uf_getRequest(UploadForm("zipcode"),"char","","")
linkurl = uf_getRequest(UploadForm("linkurl"),"char","","")

'=======시험관련 파일====================
Dim imgnames(4), imgDel_chk(4)

imgnames(1)=UploadForm("imgnames1")
imgDel_chk(1)=UploadForm("imgDel_chk1")

For i=1 To UploadForm("imgfiles").count
	IF imgDel_chk(i)<>"" And imgnames(i)<>"" Then
		ImgDelete imgnames(i),UploadForm.DefaultPath
	End IF

	IF imgDel_chk(i)<>"" Or idx="" Then 
		IF UploadForm("imgfiles")(i)<>"" Then 
			imgnames(i)=ImgSaves(UploadForm("imgfiles")(i),uploadform.defaultpath,3072000000)
			IF imgnames(i)=False Then Result=1

			IF Result=1 Then
				Set UploadForm=Nothing
				DBcon.Close
				Set DBcon=Nothing
				Response.Write ExecJavaAlert("업로드 허용용량(3000M)을 초과하여 업로드를 실패하였습니다.",0)
				Response.End
			End IF
		Else
			imgnames(i)=""
		End IF
	End IF
Next
'=======================================

IF idx<>"" Then
	AlertTag = "수정"
	Sql="Update storeAdmin Set linkurl=?, isDisplay=?, regUseridx=?, regUserName=?, listnum=?, title=?, tel=?, owner=?, addr1=?, addr2=?, addr1_ji=?, addr2_ji=?, note1=?, note2=?, note3=?, note4=?, zipcode=?, imgnames1=? Where idx="&idx
Else
	AlertTag = "등록"

	Sql="INSERT INTO storeAdmin(linkurl, isDisplay, regUseridx, regUserName, listnum, title, tel, owner, addr1, addr2, addr1_ji, addr2_ji, note1, note2, note3, note4, zipcode, imgnames1) "
	Sql = Sql & "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 1000, linkurl)
	.Parameters.Append .CreateParameter("@isDisplay", adTinyint, adParamInput, 1, isDisplay)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, Session("acountidx"))
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, Session("acountname"))
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, listnum)

	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, title)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, tel)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, owner)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr1)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr2)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr1_ji)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, addr2_ji)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, note1)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, note2)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, note3)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, note4)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 6, zipcode)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 100, imgnames(1))
	
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

IF AlertTag = "수정" Then
	strLocation="write.asp?idx="&idx&"&page="&Page&"&"&PageStr	
Else
	strLocation=PageLink&"?page="&Page&"&"&PageStr
End IF

Response.Write ExecJavaAlert("게시물이 "&AlertTag&"되었습니다.",2)
%>