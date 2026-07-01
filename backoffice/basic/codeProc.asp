<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "code" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
'검색 필드 관련===============================
serCode = uf_getRequest(Request("serCode"),"char","","")

PageLink = "code.asp"
PageStr = "serCode="&serCode
'=============================================

mode = uf_getRequestProc(Request("mode"),"char","","")

IF mode="remove" Then
	altMsg = "삭제되었습니다."
	strLocation = PageLink&"?page="&Page&"&"&PageStr

	arridx = Split(Request("idx"), ",")
	For i=0 To Ubound(arridx) 
		idx = uf_getRequestProc(arridx(i),"int","","")
		IF idx<>"" Then
			Sql = "DELETE COMCODE WHERE idx="&idx
			DBcon.Execute(Sql)
		End IF
	Next
ElseIF mode="numchange" Then
	altMsg = "순서가 변경되었습니다."
	strLocation = PageLink&"?page="&Page&"&"&PageStr

	arridx = Split(Request("dbidx"), ",")
	For i=0 To Ubound(arridx)
		idx = uf_getRequestProc(arridx(i),"int","","")

		IF idx<>"" Then
			Sql = "UPDATE COMCODE SET listnum="&i&" WHERE idx="&idx
			DBcon.Execute(Sql)
		End IF
	Next
Else
	idx = uf_getRequestProc(Request("idx"),"int","","")
	groupCode = uf_getRequestProc(Request("groupCode"),"char","","")
	groupName = uf_getRequestProc(Request("groupName"),"char","","")
	code = uf_getRequestProc(Request("code"),"char","","")
	name = uf_getRequestProc(Request("name"),"char","",code)
	listnum = 99
	isUse = uf_getRequestProc(Request("isUse"),"int","1","0")

	IF idx="" Then
		Sql = "SELECT * FROM COMCODE WHERE groupCode='"&ReplaceEnsine(groupCode)&"' AND code='"&ReplaceEnsine(code)&"'"
		Set Rs = DBcon.Execute(Sql)
		IF Rs.Bof Or Rs.Eof Then
			altMsg = "등록되었습니다."
			strLocation = PageLink&"?page="&Page&"&"&PageStr

			Sql="INSERT INTO COMCODE (groupCode, groupName, code, name, listnum, isUse) "
			Sql = Sql & "VALUES(?, ?, ?, ?, ?, ?)"
		Else
			altMsg = "해당 코드로 등록된 게시물이 있습니다.\n같은 그룹에서 중복된 코드는 허용하지 않습니다."
			Response.Write ExecJavaAlert(altMsg, 0)
			Response.END
		End IF
	Else
		Sql = "SELECT * FROM COMCODE WHERE groupCode='"&ReplaceEnsine(groupCode)&"' AND code='"&ReplaceEnsine(code)&"' AND idx<>"&idx
		Set Rs = DBcon.Execute(Sql)
		IF Rs.Bof Or Rs.Eof Then
			altMsg = "수정되었습니다."
			strLocation = "codeWrite.asp?idx="&idx&"&page="&Page&"&"&PageStr

			Sql="UPDATE COMCODE Set groupCode=?, groupName=?, code=?, name=?, listnum=?, isUse=? Where idx="&idx
		Else
			altMsg = "해당 코드로 등록된 게시물이 있습니다.\n같은 그룹에서 중복된 코드는 허용하지 않습니다."
			Response.Write ExecJavaAlert(altMsg, 0)
			Response.END
		End IF
	End IF

	Set objCmd = Server.CreateObject("ADODB.Command")
	With objCmd
		.ActiveConnection = DBcon
		.CommandType = adCmdText
		.CommandText = Sql

		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, groupCode)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, groupName)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, code)
		.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, name)
		.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, listnum)
		.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, isUse)
		.Execute,,adExecuteNoRecords
	End With
	Set objCmd = Nothing
End IF

Set Cmd=Nothing
DBcon.Close
Set DBcon=Nothing

Response.Write ExecJavaAlert(altMsg, 2)
%>