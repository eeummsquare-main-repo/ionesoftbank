<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "basic" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
isSmsUse = uf_getRequestProc(Request("isSmsUse"),"int","1","0")
smsid = uf_getRequestProc(Request("smsid"),"char","50","")
smscode = uf_getRequestProc(Request("smscode"),"char","50","")
smsBalSinNum = uf_getRequestProc(Request("smsBalSinNum"),"char","50","")

dDepositAccount = uf_getRequestProc(Request("dDepositAccount"),"char","","")
dDepositBank = uf_getRequestProc(Request("dDepositBank"),"char","","")
dDepositNm = uf_getRequestProc(Request("dDepositNm"),"char","","")

allowTestIP = Replace(uf_getRequestProc(Request("allowTestIP"),"char","","")," ","")

dFee1 = uf_getRequestProc(Request("dFee1"),"int","","0")
dFee2 = uf_getRequestProc(Request("dFee2"),"int","","0")

buyCsEmail = uf_getRequestProc(Request("buyCsEmail"),"char","","")
busCsEmail = uf_getRequestProc(Request("busCsEmail"),"char","","")
amaCsEmail = uf_getRequestProc(Request("amaCsEmail"),"char","","")
icubeCsEmail = uf_getRequestProc(Request("icubeCsEmail"),"char","","")
bizboxCsEmail = uf_getRequestProc(Request("bizboxCsEmail"),"char","","")
joinCsEmail = uf_getRequestProc(Request("joinCsEmail"),"char","","")
etcCsEmail = uf_getRequestProc(Request("etcCsEmail"),"char","","")

Sql = "UPDATE shopinfo SET dDepositAccount=?, dDepositBank=?, dDepositNm=?, isSmsUse=?, smsid=?, smscode=?, smsBalSinNum=?, allowTestIP=?, dFee1=?, dFee2=?, buyCsEmail=?, busCsEmail=?, amaCsEmail=?, icubeCsEmail=?, bizboxCsEmail=?, joinCsEmail=?, etcCsEmail=?"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, dDepositAccount)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, dDepositBank)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 50, dDepositNm)
	.Parameters.Append .CreateParameter("@Par", adTinyint, adParamInput, 1, isSmsUse)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 50, smsid)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 50, smscode)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 50, smsBalSinNum)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 4000, allowTestIP)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, dFee1)
	.Parameters.Append .CreateParameter("@Par", adBigint, adParamInput, 8, dFee2)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 4000, buyCsEmail)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 4000, busCsEmail)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 4000, amaCsEmail)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 4000, icubeCsEmail)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 4000, bizboxCsEmail)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 4000, joinCsEmail)
	.Parameters.Append .CreateParameter("@Par", adVarchar, adParamInput, 4000, etcCsEmail)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

Set Cmd=Nothing
DBcon.Close
Set DBcon = Nothing

strLocation="basic_setup.asp"
Response.Write ExecJavaAlert("기본정보가 저장되었습니다.",2)
%>