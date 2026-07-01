<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx=uf_getRequestProc(Request("idx"), "int", "", "")
page=uf_getRequestProc(Request("page"), "int", "", "1")
Title=uf_getRequestProc(Request("title"), "char", "50", "")

For i=1 To Request("speccartname").Count
	'speccartlang=Replace(uf_getRequestProc(Request("speccartlang")(i), "char", "50", ""),"|","")
	speccartlang=1
	speccartname=Replace(uf_getRequestProc(Request("speccartname")(i), "char", "50", ""),"|","")
	speccartval=Replace(uf_getRequestProc(Request("speccartval")(i), "char", "1000", ""),"|","")

	IF Request("speccartname")(i)<>"" Then
		arr_speccartlang=arr_speccartlang&speccartlang&"|"
		arr_speccartname=arr_speccartname&speccartname&"|"
		arr_speccartval=arr_speccartval&speccartval&"|"
	End IF
Next

Sql="Update specCart SET title=?,speclang=?,specname=?,specval=? Where idx="&idx
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@title", adVarWchar, adParamInput, 50, title)
	.Parameters.Append .CreateParameter("@speclang", adVarWchar, adParamInput, 2147483647, arr_speccartlang)
	.Parameters.Append .CreateParameter("@specname", adVarWchar, adParamInput, 2147483647, arr_speccartname)
	.Parameters.Append .CreateParameter("@specval", adVarWchar, adParamInput, 2147483647, arr_speccartval)
	.Execute,,adExecuteNoRecords
End With
Set objCmd = Nothing

dbcon.close
set dbcon=Nothing

Response.WRite Page
%>