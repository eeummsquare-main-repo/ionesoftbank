<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "page" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
resultSortidx = uf_getRequest(Request("resultSortidx"),"int","","1")

Content = Request("Content")
mContent = Request("mContent")

Content = Replace(Content,"http://"&Request.Servervariables("Server_name")&"/","/")
mContent = Replace(mContent,"http://"&Request.Servervariables("Server_name")&"/","/")

Sql="Select * FROM PageAdmin WHERE resultSortidx="&resultSortidx
Set Rs=DBcon.Execute(Sql)

IF Rs.Bof Or Rs.Eof Then
	Sql="Insert INTO PageAdmin(resultSortidx,content,mContent) values(?,?,?)"
Else
	Sql="Update PageAdmin Set resultSortidx=?, content=?, mContent=? Where resultSortidx="&resultSortidx
End IF

Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql
	
	.Parameters.Append .CreateParameter("@resultSortidx", adInteger, adParamInput, 4, resultSortidx)
	.Parameters.Append .CreateParameter("@Content", adVarWChar, adParamInput, 2147483647, Content)
	.Parameters.Append .CreateParameter("@mContent", adVarWChar, adParamInput, 2147483647, mContent)

	.Execute,,adExecuteNoRecords
End With

Set objCmd = Nothing
DBcon.Close
Set DBcon=Nothing

strLocation="PageAdmin.asp?resultSortidx="&resultSortidx
Response.Write ExecJavaAlert("페이지가 수정 되었습니다.",2)
%>