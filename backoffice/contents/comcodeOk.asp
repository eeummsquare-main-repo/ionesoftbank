<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "comcode" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
title = uf_getRequestProc(Request("title"),"char","100","")
Bansort = uf_getRequestProc(Request("Bansort"),"char","","")

Idx = uf_getRequestProc(Request("Idx"),"int","","")
Sort = uf_getRequestProc(Request("Sort"),"char","","")

IF Sort="edit" Then
	Sql="Update comcodeAdmin Set bansort=?, title=?, note1=? Where idx="&idx
Else
	Sql="Insert INTO comcodeAdmin(bansort,title,note1) values(?,?,?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql
	
	.Parameters.Append .CreateParameter("@bansort", adVarWChar, adParamInput, 10, bansort)
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 100, title)
	.Parameters.Append .CreateParameter("@note1", adVarWChar, adParamInput, 100, note1)

	.Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

IF Sort="edit" Then
	strLocation="comcode.asp?Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 수정 되었습니다.",2)
Else
	strLocation="comcode.asp?Bansort="&Bansort
	Response.Write ExecJavaAlert("게시물이 추가 되었습니다.",2)
End IF
%>