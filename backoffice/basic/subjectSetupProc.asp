<!--#include virtual = backoffice/_lib/common.asp-->
<!--#include virtual = _lib/dbcon.asp-->
<% topMenuCode = "admin" : subMenuCode = "subject" %>
<!--#include virtual = backoffice/_lib/authCheck.asp-->
<%
Dim ErrorRMsg : ErrorRMsg = ""

idx = uf_getRequestProc(Request("idx"), "int", "1", "0")
txtCon1 = uf_getRequestProc(Request("txtCon1"), "char", "", "")
txtCon2 = uf_getRequestProc(Request("txtCon2"), "char", "", "")
txtCon3 = uf_getRequestProc(Request("txtCon3"), "char", "", "")

txtinfo1 = uf_getRequestProc(Request("txtinfo1"), "char", "", "")
txtinfo2 = uf_getRequestProc(Request("txtinfo2"), "char", "", "")
txtinfo3 = uf_getRequestProc(Request("txtinfo3"), "char", "", "")
txtinfo4 = uf_getRequestProc(Request("txtinfo4"), "char", "", "")
txtinfo5 = uf_getRequestProc(Request("txtinfo5"), "char", "", "")
txtinfo6 = uf_getRequestProc(Request("txtinfo6"), "char", "", "")
txtinfo7 = uf_getRequestProc(Request("txtinfo7"), "char", "", "")
txtinfo8 = uf_getRequestProc(Request("txtinfo8"), "char", "", "")
txtinfo9 = uf_getRequestProc(Request("txtinfo9"), "char", "", "")
txtinfo10 = uf_getRequestProc(Request("txtinfo10"), "char", "", "")
txtinfo11 = uf_getRequestProc(Request("txtinfo11"), "char", "", "")
txtinfo12 = uf_getRequestProc(Request("txtinfo12"), "char", "", "")
txtinfo13 = uf_getRequestProc(Request("txtinfo13"), "char", "", "")
txtinfo14 = uf_getRequestProc(Request("txtinfo14"), "char", "", "")
txtinfo15 = uf_getRequestProc(Request("txtinfo15"), "char", "", "")
txtinfo16 = uf_getRequestProc(Request("txtinfo16"), "char", "", "")
txtinfo17 = uf_getRequestProc(Request("txtinfo17"), "char", "", "")
txtinfo18 = uf_getRequestProc(Request("txtinfo18"), "char", "", "")

For i=1 To Request("areaNm").Count()
	areaNm = uf_getRequestProc(Request("areaNm")(i), "char", "", "")
	areaPrice = uf_getRequestProc(Request("areaPrice")(i), "int", "", "")

	IF areaNm<>"" AND areaPrice<>"" Then
		IF arrAreaNm<>"" Then
			arrAreaNm = arrAreaNm & "|"
			arrAreaPrice = arrAreaPrice & "|"
		End IF
		arrAreaNm = arrAreaNm & areaNm
		arrAreaPrice = arrAreaPrice & areaPrice
	End IF
Next

Set objCmd = Nothing

Sql = "UPDATE subjectData SET arrAreaNm=?, arrAreaPrice=?, txtCon1=?, txtCon2=?, txtCon3=?, txtinfo1=?, txtinfo2=?, txtinfo3=?, txtinfo4=?, txtinfo5=?, txtinfo6=?, txtinfo7=?, txtinfo8=?, txtinfo9=?, txtinfo10=?, txtinfo11=?, txtinfo12=?, txtinfo13=?, txtinfo14=?, txtinfo15=?, txtinfo16=?, txtinfo17=?, txtinfo18=? WHERE idx="&idx
Set objCmd = Server.CreateObject("ADODB.Command")
With objCmd
	.ActiveConnection = DBcon
	.CommandType = adCmdText
	.CommandText = Sql

	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrAreaNm)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, arrAreaPrice)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtCon1)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtCon2)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtCon3)

	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo1)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo2)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo3)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo4)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo5)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo6)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo7)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo8)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo9)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo10)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo11)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo12)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo13)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo14)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo15)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo16)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo17)
	.Parameters.Append .CreateParameter("@Par", adVarWchar, adParamInput, 2147483647, txtinfo18)
	.Execute,,adExecuteNoRecords
End With

strLocation = "subjectSetup.asp?idx="&idx
Response.Write ExecJavaAlert("저장되었습니다.",2)
%>