<!--#include virtual = _lib/common_mobile.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<%
writer = uf_getRequestProc(Request("writer"),"char","50","")
Phone = uf_getRequestProc(Replace(Request("Phone"),", ","-"),"char","50","")
note1 = uf_getRequestProc(Request("note1"),"char","50","")

Sql = "INSERT INTO consult(writer, phone, note1) VALUES(?, ?, ?)"
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, writer)
	.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, Phone)
	.Parameters.Append .CreateParameter("@Par", adVarWChar, adParamInput, 50, note1)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

DBcon.Close
Set DBcon=Nothing

strLocation = "top.quickFrm.reset()"
Response.Write ExecJavaAlert("무료체험신청이 완료되었습니다.\n빠른 상담 드리겠습니다.", 3)
%>