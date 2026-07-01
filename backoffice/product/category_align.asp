<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "category" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim CateCode,Sort,i,CateCnt,strLocation

Server.ScriptTimeOut=7200
set uploadform=server.CreateObject("DEXT.FileUpload")
uploadform.DefaultPath=Server.MapPath("/upload/category/")

Sort=Request("sort")
CateCode=Split(uploadform("catecode"),",")
sIndex1=uploadform("sIndex1")
sIndex2=uploadform("sIndex2")
sIndex3=uploadform("sIndex3")

Dim langTitle, langmode
langmode=uploadform("langmode")
Call getlangmodeTitle(langmode)

CateCnt=Ubound(CateCode)

For i=0 To CateCnt
	IF Sort=1 Then
		Sql="UPDATE Category SET align1Num="&i&" WHERE topcode='"&CateCode(i)&"'" 
	Elseif Sort=2 Then
		Sql="UPDATE Category SET align2Num="&i+1&" WHERE middlecode='"&CateCode(i)&"'" 
	Else
		Sql="UPDATE Category SET align3Num="&i+1&" WHERE lowcode='"&CateCode(i)&"'" 
	End IF
	DBcon.Execute Sql
Next

DBcon.Close
Set DBcon=Nothing

strLocation="category.asp?langmode="&langmode&"&sIndex1="&sIndex1&"&sIndex2="&sIndex2&"&sIndex3="&sIndex3
Response.Write ExecJavaAlert("카테고리 순서가 저장되었습니다.",2)
%>