<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "member" : subMenuCode = "sub01" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<!--#include virtual = _lib/smsSetting.asp-->
<%
phone = Replace(uf_getRequest(Request("phone"),"char","",""),"-","")

IF phone="" Then
Else
	phone = addHyphen(phone)
	IF Len(phone)>10 Then
		Response.Write "<li>"&phone&"<span>X</span><input type='hidden' name='phone' value='"&Replace(phone,"-","")&"'></li>|"&Replace(phone,"-","")
	End IF
End IF
%>