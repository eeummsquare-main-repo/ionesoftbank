<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim delFile(2)

DelCode=Request("delCode")
Sort=Request("sort")

sIndex1=Request("sIndex1")
sIndex2=Request("sIndex2")
sIndex3=Request("sIndex3")

Dim langTitle, langmode
langmode=Request("langmode")
Call getlangmodeTitle(langmode)

IF DelCode="" Or Sort="" Then
	Response.Write ExecJavaAlert("잘못된접근입니다\n확인후 다시시도해주세요.",0)
	Response.End	
End IF

IF DelCode="1317707120" OR DelCode="1317707140" OR DelCode="1317707146" OR DelCode="1317707152" OR DelCode="1317707157" Then
	Response.Write ExecJavaAlert("프로그램 로직상 삭제할수 없는 카테고리입니다.",0)
	Response.End
End IF

Server.ScriptTimeOut=7200
set UploadForm=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/category/")

IF Sort=1 Then
	Sql="SELECT * FROM VIEW_Product WHERE Catecode IN ( SELECT Lowcode From Category WHERE Topcode='"&DelCode&"' )"
Elseif Sort=2 Then
	Sql="SELECT * FROM VIEW_Product WHERE Catecode IN ( SELECT Lowcode From Category WHERE MiddleCode='"&DelCode&"' )"
Else
	Sql="SELECT * FROM VIEW_Product WHERE Catecode IN ( SELECT Lowcode From Category WHERE LowCode='"&DelCode&"' )"
End IF
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	'첨부파일 삭제===============================
	IF Sort=1 Then
		Sql = "SELECT isNull(images,''), isNull(rollimages,''), isNull(pdffilename,'') From Category WHERE Topcode='"&DelCode&"'"
	Elseif Sort=2 Then
		Sql = "SELECT isNull(images,''), isNull(rollimages,''), isNull(pdffilename,'') From Category WHERE MiddleCode='"&DelCode&"'"
	Else
		Sql = "SELECT isNull(images,''), isNull(rollimages,''), isNull(pdffilename,'') From Category WHERE LowCode='"&DelCode&"'"
	End IF

	SET FileRs=DBcon.Execute(Sql)
	IF Not(FileRs.Bof Or FileRs.Eof) Then
		Do Until FileRs.Eof
			delFile(0)=FileRs(0) : delFile(1)=FileRs(1): delFile(2)=FileRs(2)

			For i=0 To Ubound(DelFile)
				IF delFile(i)<>"" Then
					ImgDelete delFile(i),UploadForm.DefaultPath
				End IF
			Next

			FileRs.MoveNext()
		Loop
	End IF
	'첨부파일 삭제===============================

	IF Sort=1 Then
		Sql="DELETE Category WHERE topcode='"&DelCode&"'"
	Elseif Sort=2 Then
		Sql="DELETE Category WHERE MiddleCode='"&DelCode&"'"
	Else
		Sql="DELETE Category WHERE LowCode='"&DelCode&"'"
	End IF
	DBcon.Execute Sql
Else
	Set Rs=Nothing
	DBcon.Close
	Set DBcon=Nothing

	Response.Write ExecJavaAlert("선택하신 카테고리및 하위카테고리에 등록된 상품이 존재합니다.\n상품이 존재할경우 카테고리를 삭제할수 없습니다.\n상품삭제 및 이동후 다시 시도해주십시오.",0)
	Response.End
End IF

Set Rs=Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="category.asp?langmode="&langmode&"&sIndex1="&sIndex1&"&sIndex2="&sIndex2&"&sIndex3="&sIndex3
Response.Write ExecJavaAlert("선택하신카테고리가 삭제되었습니다.",2)
%>