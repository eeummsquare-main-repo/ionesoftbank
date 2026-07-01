<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "product" : subMenuCode = "product" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
idx=uf_getRequestProc(Request("idx"), "int", "", "0")

Sql="SELECT idx,title,specLang,specname,specval From specCart Where idx="&idx
Set Rs=DBcon.Execute(Sql)

IF Not(Rs.Bof Or Rs.Eof) Then
	specLang=Split(Rs("specLang"),"|")
	specname=Split(Rs("specname"),"|")
	specval=Split(Rs("specval"),"|")
End IF

Response.Write "$(""#specTB tbody tr"").remove();"

For i=0 To UBound(specname)
	html = ""
	IF specname(i)<>"" Then

		html = html & "<tr>"
		html = html & "	<td class='center'><input type='checkbox' name='specCheckidx'></td>"
'		html = html & "	<td class='center'>"
'		html = html & "		<select name='speclang'>"
'		html = html & "			<option value='1' "&selCheck(specLang(i), 1)&">국문</option>"
'		html = html & "			<option value='2' "&selCheck(specLang(i), 2)&">영문</option>"
'		html = html & "		</select>"
'		html = html & "	</td>"
		html = html & "	<td class='center'>"
		html = html & "		<input type='text' name='ititle' maxlength='50' value='"&ReplaceTextField(specName(i))&"' style='width:99%'>"
		html = html & "	</td>"
		html = html & "	<td class='center'><input type='text' name='iContent' maxlength='1000' value='"&ReplaceTextField(specVal(i))&"' style='width:99%;'></td>"
		html = html & "</tr>"

		Response.Write "$(""#specTB tbody"").append("""&html&""");"
	End IF
Next

dbcon.close
set dbcon=Nothing
%>