<!--#include virtual = _lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
nLetterEmail = uf_getRequestProc(Request("nLetterEmail"),"char","50","")

Sql = "SELECT * FROM newsLetter Where Email = '"&ReplaceEnsine(Request("nLetterEmail"))&"'"
Set Rs = DBcon.Execute(Sql)
IF Rs.Bof Or Rs.Eof Then
	Sql = "INSERT INTO newsLetter(Email) VALUES(?)"

	Set objCmd = Server.CreateObject("ADODB.Command")
	With objCmd
		.ActiveConnection = DBcon
		.CommandType = adCmdText
		.CommandText = Sql

		.Parameters.Append .CreateParameter("@Email", adVarWChar, adParamInput, 50, nLetterEmail)
		.Execute,,adExecuteNoRecords
	End With
	Set objCmd = Nothing

	altMsg = "Your subscription is successful. Stay tuned for the latest from Opticis!"
Else
	altMsg = "is already subscribed to the list."
End IF

DBcon.Close
Set DBcon=Nothing

strLocation = "top.nletterFrm.reset()"
Response.Write ExecJavaAlert(altMsg, 3)
%>