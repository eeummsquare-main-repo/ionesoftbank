<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
dFee1 = uf_getRequestProc(Request("dFee1"),"int","",null)
dFee2 = uf_getRequestProc(Request("dFee2"),"int","",null)
dFee3 = uf_getRequestProc(Request("dFee3"),"int","",null)
dFee4 = uf_getRequestProc(Request("dFee4"),"int","",null)
dFee5 = uf_getRequestProc(Request("dFee5"),"int","",null)

Sql = "UPDATE shopinfo SET dFee1=?, dFee2=?, dFee3=?, dFee4=?, dFee5=?"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, dFee1)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, dFee2)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, dFee3)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, dFee4)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, dFee5)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

Set Cmd=Nothing
DBcon.Close
Set DBcon = Nothing

strLocation="/backoffice/"
Response.Write ExecJavaAlert("저장되었습니다.",2)
%>