<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "community" : subMenuCode = "boardsort" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim langTitle, langmode
langmode=Request("langmode")
Call getLangModeTitle(langmode)

title=Request("title")
boardidx=Request("boardidx")

Filename=Request("filename")
filedelchk=Request("filedelchk")
mFilename=Request("mfilename")
mfiledelchk=Request("mfiledelchk")
adEmail=Request("adEmail")
Idx=Request("idx")
Sort=Request("sort")

IF Sort="edit" Then
	Sql="Update boardsort Set boardidx=?, sortname=?, adEmail=? Where idx="&idx
Else
	Sql="Insert INTO boardsort(boardidx,sortname,adEmail) values(?,?,?)"
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@boardidx", adBigint, adParamInput, 8, boardidx)
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 100, title)
	.Parameters.Append .CreateParameter("@title", adVarWChar, adParamInput, 100, adEmail)
	.Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

IF Sort="edit" Then
	strLocation="boardsort.asp?boardidx="&boardidx
	Response.Write ExecJavaAlert("카테고리가 수정 되었습니다.",2)
Else
	strLocation="boardsort.asp?boardidx="&boardidx
	Response.Write ExecJavaAlert("카테고리가 추가 되었습니다.",2)
End IF
%>